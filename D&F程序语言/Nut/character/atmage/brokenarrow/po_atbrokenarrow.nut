
BrokenArrow_START_X <- 0
BrokenArrow_START_Y <- 1
BrokenArrow_START_Z <- 2

BrokenArrow_MOV_X <- 3
BrokenArrow_MOV_Y <- 4
BrokenArrow_MOV_Z <- 5



function setCustomData_po_ATBrokenArrow(obj, reciveData)
{
	if(!obj) return;
	
	
	local xLen = reciveData.readDword();
	local yLen = reciveData.readDword();
	local zLen = reciveData.readDword();
	local attackRate = reciveData.readDword();
	local expTime = reciveData.readDword();
	local stunTime = reciveData.readDword();
	local angle = reciveData.readFloat() * 100;
	
	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);
		
	obj.getVar("dis").clear_vector();
	
	obj.getVar("dis").push_vector(x);
	obj.getVar("dis").push_vector(y);
	obj.getVar("dis").push_vector(z);
	
	obj.getVar("dis").push_vector(xLen);
	obj.getVar("dis").push_vector(yLen);
	obj.getVar("dis").push_vector(zLen);

	obj.getVar("state").clear_vector(); // state vector
	obj.getVar("state").push_vector(BrokenArrow_state_0);

	local expT = expTime; // 경직시간

	obj.getVar("fire").clear_vector(); // state vector
	obj.getVar("fire").push_vector(expT);
	
	local current100Angle = angle.tointeger();
	obj.getVar("angle").clear_vector();
	obj.getVar("angle").push_vector(current100Angle);
	
	local pIntVec = sq_GetGlobalIntVector();
	sq_IntVectorClear(pIntVec);
	sq_IntVectorPush(pIntVec, 0);
	
	//sq_SetAttackInfoForceHitStunTime(
	
	local atk = sq_GetCurrentAttackInfo(obj);
	
	if(atk)
	{
		sq_SetCurrentAttackBonusRate(atk, attackRate);
		sq_SetAttackInfoForceHitStunTime(atk, stunTime);
	}

	
	
	if(obj.isMyControlObject())
	{
		obj.addSetStatePacket(BrokenArrow_state_0, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}

}

function setState_po_ATBrokenArrow(obj, state, datas)
{
	if(!obj) return;
	
	local passiveState = state;
	
	obj.getVar("state").set_vector(0, passiveState);

	if(passiveState == BrokenArrow_state_0)
	{
		obj.sq_PlaySound("BARROW_SHOT");
	}
	else if(passiveState == BrokenArrow_state_1)
	{
		local ani = obj.getCustomAnimation(0);
		obj.setCurrentAnimation(ani);
	}
	else if(passiveState == BrokenArrow_state_2)
	{
		local ani = obj.getCustomAnimation(1);
		obj.setCurrentAnimation(ani);
	}
	
	local current100Angle = obj.getVar("angle").get_vector(0);
	
	if(current100Angle != -100)
	{
		local pAni = obj.getCurrentAnimation();
		local angle = current100Angle.tofloat() / 100.0;
		print(" set angle:" + angle);
		//sq_SetfRotateAngle(pAni, angle);
		//sq_SetfRotateAngle(pAni, 5.0);
		//obj.void CNRDObject::setCustomRotate(bool isApply, float rotateAnlge)
		obj.setCustomRotate(true, angle);

	}
	
}

function procAppend_po_ATBrokenArrow(obj)
{

	if(!obj) return;
	
//BrokenArrow_START_X <- 0
//BrokenArrow_START_Y <- 1
//BrokenArrow_START_Z <- 2
//
//BrokenArrow_MOV_X <- 3
//BrokenArrow_MOV_Y <- 4
//BrokenArrow_MOV_Z <- 5
	local passiveState = obj.getVar("state").get_vector(0);
	
//BrokenArrow_state_0 <- 10
//BrokenArrow_state_1 <- 11
	local pAni = obj.getCurrentAnimation();
	local currentT = sq_GetCurrentTime(pAni);

	if(passiveState == 0)
	{
		return;
	}	

	if(passiveState == BrokenArrow_state_0)
	{

		local fireT = 200;
		local srcX = obj.getVar("dis").get_vector(BrokenArrow_START_X); // 시작x
		local srcY = obj.getVar("dis").get_vector(BrokenArrow_START_Y); // 시작y
		local srcZ = obj.getVar("dis").get_vector(BrokenArrow_START_Z); // 시작z
		    	
		local dis_x_len = obj.getVar("dis").get_vector(BrokenArrow_MOV_X); // 총 이동거리
		local dis_y_len = obj.getVar("dis").get_vector(BrokenArrow_MOV_Y); // y축 이동거리
		local endZ = obj.getVar("dis").get_vector(BrokenArrow_MOV_Z); // z축 이동거리
		
		local v = sq_GetUniformVelocity(0, dis_x_len, currentT, fireT);
		local my = sq_GetUniformVelocity(0, dis_y_len, currentT, fireT);
		local mz = sq_GetUniformVelocity(srcZ, endZ, currentT, fireT);
		
		local dstX = sq_GetDistancePos(srcX, obj.getDirection(), v);
		local dstY = srcY + my;
		 
		sq_setCurrentAxisPos(obj, 0, dstX);
		sq_setCurrentAxisPos(obj, 1, dstY);
		sq_setCurrentAxisPos(obj, 2, mz);

		if(currentT >= fireT)
		{
			if(obj.isMyControlObject())
			{
				sq_SendDestroyPacketPassiveObject(obj);
			}
		}
	}
	else if(passiveState == BrokenArrow_state_1)
	{
		local fireT = obj.getVar("fire").get_vector(0);


		if(obj.isMyControlObject())
		{
				
			local moveParent = sq_GetMoveParent(obj);
			
			local changeState = false;
			
			if(!moveParent)
				changeState = true;
				
			if(moveParent)
			{
				local isSmashing = false; // 후려치는 액션인지
				local parentState = obj.sq_GetParentState();
				local subState = obj.sq_GetParentSkillSubState();
				
				if(parentState == STATE_BROKENARROW && subState >= SUB_STATE_BROKENARROW_3)
					isSmashing = true;
					
				if(moveParent.getState() == STATE_DOWN && isSmashing == true)
				{
					changeState = true;
				}
			}
			
			if(currentT >= fireT)
				changeState = true;
			
			if(changeState == true)
			{
				if(obj.isMyControlObject())
				{
					local pIntVec = sq_GetGlobalIntVector();
				
					sq_IntVectorClear(pIntVec);
					sq_IntVectorPush(pIntVec, 0);

					obj.addSetStatePacket(BrokenArrow_state_2, pIntVec, STATE_PRIORITY_AUTO, false, "");
				}
			}
		}
	}
	else if(passiveState == BrokenArrow_state_2)
	{
		local isEnd = sq_IsEnd(pAni);
		
		if(isEnd == true)
		{
			if(obj.isMyControlObject())
			{
				sq_SendDestroyPacketPassiveObject(obj);
			}
		}
	}
	
}

function onChangeSkillEffect_po_ATBrokenArrow(obj, skillIndex, reciveData)
{

	if(!obj) return;

}

function onDestroyObject_po_ATBrokenArrow(obj, object)
{
	if(!obj) return;

}

function onKeyFrameFlag_po_ATBrokenArrow(obj, flagIndex)
{

}

function onEndCurrentAni_po_ATBrokenArrow(obj)
{

	if(!obj) return;

}

function onAttack_po_ATBrokenArrow(obj, damager, boundingBox, isStuck)
{
	if(!obj)
		return 0;
	
	local pChr = obj.getTopCharacter();
	
	if(!pChr)
		return 0;

	// 화살에 맞았을 때 화살 흔적		
	
	local x = sq_GetXPos(pChr);
	local y = sq_GetYPos(pChr);
	local z = sq_GetZPos(pChr);
	
	local damagerX = sq_GetXPos(damager);
	local damagerY = sq_GetYPos(damager);
	local damagerZ = sq_GetZPos(damager);
	
	local direction = ENUM_DIRECTION_LEFT;
	
	if(x < damagerX)
	{
		direction = ENUM_DIRECTION_RIGHT;
	}
	
	//local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, 
	//SKILL_BROKENARROW, true, "Character/ATMage/BrokenArrow/ap_ATBrokenArrow.nut", true);
	//
	
	//local ani = sq_CreateAnimation("", "PassiveObject/Character/Mage/Animation/ATBrokenArrow/hiteffect/00_arrow_normal.ani");	
	//local arrowObj = sq_CreatePooledObject(ani,true);
	//sq_AddObjectTarget(obj, arrowObj, damager, OBJECTTYPE_DRAWONLY, BROKENARROW_UNIQUE_ID);
	
	//arrowObj.setCurrentDirection(direction);
	
	//local hitX = (sq_GetCenterXPos(boundingBox) - 5);// + sq_getRandom(0, 2);
	local hitX = sq_GetXPos(damager) + sq_getRandom(0, 2);
	local hitY = sq_GetYPos(damager) + 1;
	local hitZ = (sq_GetCenterZPos(boundingBox) - 5) + sq_getRandom(0, 5);
	
	//arrowObj.setCurrentPos(hitX,hitY,hitZ);
	//sq_moveWithParent(damager, arrowObj);
	
	obj.setCurrentPos(hitX,hitY,hitZ);
	sq_moveWithParent(damager, obj);
	

	local appendage = CNSquirrelAppendage.sq_AppendAppendage(damager, damager, SKILL_BROKENARROW, 
	true, "Appendage/Character/ap_atmage_effect.nut", true);
	
	print(" onattack");
	
	
	if(obj.isMyControlObject())
	{
		local passiveState = obj.getVar("state").get_vector(0);

		print(" onattack:" + passiveState);
		if(passiveState == BrokenArrow_state_0)
		{
			local pIntVec = sq_GetGlobalIntVector();
		
			sq_IntVectorClear(pIntVec);
			sq_IntVectorPush(pIntVec, 0);

			obj.addSetStatePacket(BrokenArrow_state_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
		}
		else if(passiveState == BrokenArrow_state_1)
		{
			local pIntVec = sq_GetGlobalIntVector();
			
			sq_IntVectorClear(pIntVec);
			sq_IntVectorPush(pIntVec, 0);

			obj.addSetStatePacket(BrokenArrow_state_2, pIntVec, STATE_PRIORITY_AUTO, false, "");
			//sq_SendDestroyPacketPassiveObject(obj);
		}
		
		//local group = sq_GetGroup(damager);
		//local uniqueId = sq_GetUniqueId(damager);
		//
		//sq_BinaryStartWrite();
		//sq_BinaryWriteWord(group);
		//sq_BinaryWriteWord(uniqueId);
		//
		//sq_SendChangeSkillEffectPacket(pChr, SKILL_BROKENARROW);
	
	
		//sq_SendDestroyPacketPassiveObject(obj);
	}
	
	return 0;
}


function getCustomHitEffectFileName_po_ATBrokenArrow(obj, isAttachOnDamager)
{
	return "PassiveObject/Character/Mage/Animation/ATBrokenArrow/02_arrowboom_dodge.ani";
}


