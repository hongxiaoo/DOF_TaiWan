
function setCustomData_po_ATFirePillar(obj, reciveData)
{
	if(!obj) return;
	
	local attackRate = reciveData.readDword(); // 어택공격력
	local distance = reciveData.readDword(); // 나가는 거리
	local arriveTime = reciveData.readDword(); // 소용돌이 나가는 속도 (거리까지 도달하는 시간) (1/1000초)
	local term = reciveData.readDword();
	
	initGetVarTimer(obj, 1, term, -1);

	obj.getVar("state").clear_vector(); // state vector
	obj.getVar("state").push_vector(0);
	
	obj.getVar("flag").clear_vector();
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);
	
	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);
		
	obj.getVar("dis").clear_vector();
	
	obj.getVar("dis").push_vector(x);
	obj.getVar("dis").push_vector(y);
	obj.getVar("dis").push_vector(z);
	obj.getVar("dis").push_vector(distance);
	
	obj.getVar("arriveTime").clear_vector();
	obj.getVar("arriveTime").push_vector(arriveTime);
	
	obj.getVar("frmIndex").clear_vector();
	obj.getVar("frmIndex").push_vector(0);
	obj.getVar("frmIndex").push_vector(0);
	obj.getVar("frmIndex").push_vector(0);
	
	local pAttack = sq_GetCurrentAttackInfo(obj);
	sq_SetCurrentAttackBonusRate(pAttack, attackRate);

	if(obj.isMyControlObject()) {
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
		
		obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_0, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}

}

function setState_po_ATFirePillar(obj, state, datas)
{
	if(!obj) return;
	
	local passiveState = state;
	
	obj.getVar("state").set_vector(0, passiveState);
	
	obj.getVar("flag").set_vector(VECTOR_FLAG_0, 0);

	//initGetVarTimer(obj, 1, 400, 10);
	
	if(passiveState == PASSIVEOBJ_SUB_STATE_0)
	{
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		local ani = obj.getCustomAnimation(0);
		obj.setCurrentAnimation(ani);
	}	
	else if(passiveState == PASSIVEOBJ_SUB_STATE_2)
	{
	}

}

function procAppend_po_ATFirePillar(obj)
{

	if(!obj) return;
	
	local state = obj.getVar("state").get_vector(0);
	local passiveState = state;
	
	local pAni = obj.getCurrentAnimation();
	local frmIndex = sq_GetAnimationFrameIndex(pAni);
	local currentT = sq_GetCurrentTime(pAni);

	local objX = sq_GetXPos(obj);
	local objY = sq_GetYPos(obj);
	local parentObj = obj.getParent();
	
	if(!parentObj)
	{
		if(obj.isMyControlObject())
		{
			sq_SendDestroyPacketPassiveObject(obj);
			return;
		}
	}
	
	if(parentObj.getState() != STATE_FIREPILLAR)
	{
		//if(passiveState == PASSIVEOBJ_SUB_STATE_0)
		//{
			//if(obj.isMyControlObject())
			//{
				//local pIntVec = sq_GetGlobalIntVector();
			//
				//sq_IntVectorClear(pIntVec);
				//sq_IntVectorPush(pIntVec, 0);
//
				//obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
				//return;
			//}
		//}
	}
		
	if(passiveState == PASSIVEOBJ_SUB_STATE_0)
	{
		
		local fireT = obj.getVar("arriveTime").get_vector(0);
		
		local srcX = obj.getVar("dis").get_vector(0); // 시작x
		local srcY = obj.getVar("dis").get_vector(1); // 시작y
		local srcZ = obj.getVar("dis").get_vector(2); // 시작z
		    	
		local distance = obj.getVar("dis").get_vector(3); // 총 이동거리
		
		local v = sq_GetUniformVelocity(0, distance, currentT, fireT);
		print(" distance:" + distance);
		local dstX = sq_GetDistancePos(srcX, obj.getDirection(), v);
		local dstY = srcY;
		
		sq_setCurrentAxisPos(obj, 0, dstX);
		
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
		
		local hitT = obj.getVar().get_timer_vector(0);
	
		if(hitT)
		{		
			if(hitT.isOnEvent(currentT) == true)
			{
				print(" reset");
				obj.resetHitObjectList();
			}
		}
			
	}
	
	local oldFrmIndex = obj.getVar("frmIndex").get_vector(VECTOR_FLAG_0);
	if(frmIndex != oldFrmIndex)
	{
		obj.getVar("frmIndex").set_vector(VECTOR_FLAG_0, frmIndex);
		
		local x = objX;
		local y = objY;
		
		local cnt = obj.getVar("frmIndex").get_vector(VECTOR_FLAG_1);
		local size = 3;
		local iKeyList =[];
		iKeyList.resize(size);
		
		iKeyList[0] = 0;
		iKeyList[1] = 15;
		iKeyList[2] = -15;
		
		local yList =[];
		yList.resize(size);
		yList[0] = -1;
		yList[1] = 1;
		yList[2] = -2;
		
		local pooledObj = createAnimationPooledObject(obj, "PassiveObject/Character/Mage/Animation/ATFirePillar/3_firetail_dodge.ani", true, x, y + yList[cnt], iKeyList[cnt]);
		
		pooledObj.setCurrentDirection(obj.getDirection());
		
		cnt = cnt + 1;
		if(cnt > (size - 1))
		{
			cnt = 0;
		}
		obj.getVar("frmIndex").set_vector(VECTOR_FLAG_1, cnt);
	}
	
}

function onChangeSkillEffect_po_ATFirePillar(obj, skillIndex, reciveData)
{

	if(!obj) return;

}

function onDestroyObject_po_ATFirePillar(obj, object)
{

	if(!obj) return;

}

function onKeyFrameFlag_po_ATFirePillar(obj, flagIndex)
{

}

function onEndCurrentAni_po_ATFirePillar(obj)
{
	if(!obj) return;
	
	local state = obj.getVar("state").get_vector(0);
	local passiveState = state;

	if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		if(obj.isMyControlObject())
		{
			sq_SendDestroyPacketPassiveObject(obj);
		}
	}	
}



