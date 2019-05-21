
function insertWindmillDust(obj, dx, dy, dz)
{
	if(!obj)
		return;
		
	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);
	
	local particleCreater = obj.getVar().GetparticleCreaterMap("ATTurnWindmillDust", "Character/Mage/Effect/Particle/ATTurnWindmillDust.ptl", obj);
		
	particleCreater.Restart(0);
	particleCreater.SetPos(x + dx, y + dy, z + dz);	
	
	sq_AddParticleObject(obj, particleCreater);
}


function setCustomData_po_ATTurnWidmill(obj, reciveData)
{

	if(!obj) return;


	local flip = reciveData.readDword();
	local distance = reciveData.readDword();	
	local attackRate = reciveData.readDword();
	local term = reciveData.readDword();
	local dirType = reciveData.readDword();
	local angle = reciveData.readDword();

	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);
	
	obj.getVar("dir").clear_vector();
	obj.getVar("dir").push_vector(dirType);
	obj.getVar("dir").push_vector(angle);
	
	local disW = distance;
	local disH = 0;
	if(dirType)
	{
		local cos_x = distance.tofloat() * sq_CosTable(angle);
		local sin_y = distance.tofloat() * sq_SinTable(angle);
		
		disW = sq_Abs( cos_x.tointeger() );
		disH = sq_Abs( sin_y.tointeger() );
		
		print(" angle:" + angle + " sin_y:" + sin_y);
		
	}
	
		
	obj.getVar("dis").clear_vector();	
	obj.getVar("dis").push_vector(x);
	obj.getVar("dis").push_vector(y);
	obj.getVar("dis").push_vector(z);
	obj.getVar("dis").push_vector(disW); // x이동거리
	obj.getVar("dis").push_vector(disH); // y이동거리
	
	

	obj.getVar("flip").clear_vector(); // state vector
	obj.getVar("flip").push_vector(flip);
	
	obj.getVar("state").clear_vector(); // state vector
	obj.getVar("state").push_vector(PASSIVEOBJ_SUB_STATE_0);
	
	//print(" term:" + term);
	initGetVarTimer(obj, 1, term, -1);
	
	obj.getVar("particle").clear_timer_vector();
	obj.getVar("particle").push_timer_vector();
	
	local t = obj.getVar("particle").get_timer_vector(0);
	t.setParameter(20, -1);		
	t.resetInstant(0);
	
	local pAttack = sq_GetCurrentAttackInfo(obj);			
	sq_SetCurrentAttackBonusRate(pAttack, attackRate);
	
		
	if(obj.isMyControlObject()) {
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
		
		obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_0, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
	
	//ATTurnWindmillDust.ptl

}

function setState_po_ATTurnWidmill(obj, state, datas)
{

	if(!obj) return;
	
	local passiveState = state;
	
	obj.getVar("state").set_vector(0, passiveState);

	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);
	
	if(passiveState == PASSIVEOBJ_SUB_STATE_0)
	{
		if(obj.getVar("flip").get_vector(0))
		{
			local ani = obj.getCustomAnimation(1);
			obj.setCurrentAnimation(ani);
		}
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		if(!obj.getVar("flip").get_vector(0))
		{
			local ani = obj.getCustomAnimation(0);
			obj.setCurrentAnimation(ani);
		}
		else
		{
			local ani = obj.getCustomAnimation(2);
			obj.setCurrentAnimation(ani);
		}
	
	}
	

}

function procAppend_po_ATTurnWidmill(obj)
{
	if(!obj) return;
	
	local passiveState = obj.getVar("state").get_vector(0);
	
	local pAni = obj.getCurrentAnimation();
	local currentT = sq_GetCurrentTime(pAni);
	
	if(passiveState == PASSIVEOBJ_SUB_STATE_0)
	{
		local fireT = 200;
		local srcX = obj.getVar("dis").get_vector(0); // 시작x
		local srcY = obj.getVar("dis").get_vector(1); // 시작y
		local srcZ = obj.getVar("dis").get_vector(2); // 시작z
		    	
		local distance = obj.getVar("dis").get_vector(3); // 총 이동거리
		
		local v = sq_GetUniformVelocity(0, distance, currentT, fireT);
		
		local dstX = sq_GetDistancePos(srcX, obj.getDirection(), v);
		 
		sq_setCurrentAxisPos(obj, 0, dstX);
		
		
		
		// 추가
		if(obj.getVar("dir").get_vector(0))
		{
			local disH = obj.getVar("dis").get_vector(4); // 세로 이동거리
			local vH = sq_GetUniformVelocity(0, disH, currentT, fireT);
			
			//print(" disH:" + disH);
			if(obj.getVar("dir").get_vector(0) == 1)
			{
				vH = -vH;
			}
			
			local dstY = srcY + vH;
			sq_setCurrentAxisPos(obj, 1, dstY);
		}
		
		
		if(currentT >= fireT)
		{
			if(obj.isMyControlObject())
			{
				local pIntVec = sq_GetGlobalIntVector();
			
				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);

				obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
			}
		}
		
		// 먼지 파티클 생성
		local t = obj.getVar("particle").get_timer_vector(0);
		
		if(t.isOnEvent(currentT) == true)
		{		
			local dx = sq_GetDistancePos(0, obj.getDirection(), 10);
			insertWindmillDust(obj, dx, 5, -8);
		}
		
		local hitT = obj.getVar().get_timer_vector(0);
	
		if(hitT)
		{		
			if(hitT.isOnEvent(currentT) == true)
			{
				//print(" reset");
				obj.resetHitObjectList();
			}
		}
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
	}


}

function onChangeSkillEffect_po_ATTurnWidmill(obj, skillIndex, reciveData)
{

	if(!obj) return;

}

function onDestroyObject_po_ATTurnWidmill(obj, object)
{

	if(!obj) return;

}

function onKeyFrameFlag_po_ATTurnWidmill(obj, flagIndex)
{

}

function onEndCurrentAni_po_ATTurnWidmill(obj)
{
	if(!obj) return;
	
	local passiveState = obj.getVar("state").get_vector(0);
	
	if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		if(obj.isMyControlObject())
		{
			sq_SendDestroyPacketPassiveObject(obj);
		}
	}
	

}
