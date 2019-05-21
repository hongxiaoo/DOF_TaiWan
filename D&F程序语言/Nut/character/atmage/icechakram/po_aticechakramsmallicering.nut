
SMALLICERING_START_X <- 0
SMALLICERING_START_Y <- 1
SMALLICERING_START_Z <- 2

SMALLICERING_MOV_X <- 3
SMALLICERING_MOV_Y <- 4
SMALLICERING_MOV_Z <- 5


function getTargetZPos(target)
{
	if(!target)
		return 50;
		
	local height = target.getZPos();
	
	height = height + sq_GetObjectHeight(target);
		
	height = height + 50;
	
	return height;
}

function updateAngle(obj, angle)
{
	if(!obj)
		return;

	local currentAngle_ = obj.getVar("angle").get_vector(0);
	
	if (currentAngle_ == (angle + 360) % 360)
		return;
		
	currentAngle_ = (angle + 360) % 360;
	obj.getVar("angle").set_vector(0, currentAngle_);
	
	if (currentAngle_ >= 90 && currentAngle_ < 270)
	{
		obj.setCurrentDirection(ENUM_DIRECTION_LEFT);
	}
	else
	{
		obj.setCurrentDirection(ENUM_DIRECTION_RIGHT);
	}
}

function moveToBombingState(obj, currentAngle)
{
	//local angle = 20 + sq_getRandom(0, 10);
	if(!obj)
		return;
		
	if(obj.isMyControlObject())
	{
		//int angle = 20 + Rand_r() % 10;
		local angle = 50 + sq_getRandom(0, 10);
		//local angle = sq_getRandom(0, 180);
		
		if(sq_getRandom(0, 2) != 0)
			angle = -angle;

		//print( " send changeAngle:" + angle);
		
		sq_BinaryStartWrite();
		sq_BinaryWriteFloat(angle.tofloat());
		
		sq_SendChangeSkillEffectPacket(obj, SKILL_ICECHAKRAM);
	}
}



function procSmallRingMove(obj)
{
	if(!obj)
		return;
		
	//local target = obj.sq_var.get_obj_vector(0);
	
	//if (target)
	{
		local t = obj.getVar("sr").get_ct_vector(0);
		if(!t)
			return;
			
		local time = t.Get();
		
		
		local radius = 0;
		local angle = 0;
		local zPos = 0;
		local currentAngle = 0;
		//local bombingTurnStartTime_ = 10;
		//local bombingTurnEndTime_ = 200;
		local bombingTurnStartTime_ = 60;
		local bombingTurnEndTime_ = 300;
		local bombingStartAngle_ = obj.getVar("sr").get_vector(1)
		local bombingChangeAngle_ = obj.getVar("sr").get_vector(0);

		//print( " bombingChangeAngle_:" + bombingChangeAngle_);		
		//local BOMBING_RADIUS = 40;
		local BOMBING_RADIUS = 30;
		
		local srcZ = obj.getVar("pos").get_vector(2);
		local currentAngle_ = obj.getVar("angle").get_vector(0);
		
		
		if (time <= bombingTurnStartTime_)
		{
			//	직선
			//radius = sq_GetUniformVelocity((isFlyToCenter_)? 0 : -BOMBING_RADIUS, BOMBING_RADIUS, time, bombingTurnStartTime_);
			radius = sq_GetUniformVelocity(0, BOMBING_RADIUS, time, bombingTurnStartTime_);
			angle = bombingStartAngle_;
			zPos = srcZ;
			currentAngle = currentAngle_;
		}
		else
		{
			//	선회
			local dstZPos_ = obj.getVar("pos").get_vector(2);
			

			//local OVER_RADIUS = 50;
			local OVER_RADIUS = 150;
			local turnTime = time - bombingTurnStartTime_;
			local turnEndTime = bombingTurnEndTime_ - bombingTurnStartTime_;
			
			if (turnTime <= turnEndTime / 2)
				radius = BOMBING_RADIUS + sq_GetAccel(0, OVER_RADIUS, turnTime, turnEndTime / 2, true);
			else
				radius = BOMBING_RADIUS + sq_GetAccel(OVER_RADIUS, 0, turnTime - turnEndTime / 2, turnEndTime / 2, false);
				
			angle = bombingStartAngle_ + sq_GetUniformVelocity(0, bombingChangeAngle_, turnTime, turnEndTime);
			//zPos = sq_GetUniformVelocity(srcZ, dstZPos_, turnTime, turnEndTime);
			
			if (bombingChangeAngle_ > 0)
				currentAngle = sq_GetUniformVelocity(bombingStartAngle_, bombingStartAngle_ + 180 + bombingChangeAngle_, turnTime, turnEndTime);
			else
				currentAngle = sq_GetUniformVelocity(bombingStartAngle_, bombingStartAngle_ - 180 + bombingChangeAngle_, turnTime, turnEndTime);
		}

		local posX = CNRDObject.getAngleDistanceXPos(obj.getVar("pos").get_vector(0), angle, radius, ENUM_DIRECTION_RIGHT);
		local posY = CNRDObject.getAngleDistanceYPos(obj.getVar("pos").get_vector(1), angle, radius, false);
		local posZ = obj.getVar("pos").get_vector(2);
		sq_setCurrentAxisPos(obj, 0, posX);
		sq_setCurrentAxisPos(obj, 1, posY);
		sq_setCurrentAxisPos(obj, 2, posZ);
		//setCurrentPos(2, zPos);
		updateAngle(obj, currentAngle);
		
		//print( " time:" + time);
		
		if(time > bombingTurnEndTime_)
		{
			//print( " time out :" + time);
			moveToBombingState(obj, 0);
			//t.Reset();
			//t.Start(10000,0);
			//local changeAngle = moveToBombingState(obj, 0);
			//obj.getVar("sr").set_vector(0, changeAngle);
			//local currentAng = obj.getVar("angle").get_vector(0);
			//obj.getVar("sr").set_vector(1, changeAngle);
			//return;
		}
		
	}
}


function setCustomData_po_ATIceChakramSmallIceRing(obj, reciveData)
{

	if(!obj) return;
	
	local id = reciveData.readDword();
	local multi_hit_num = reciveData.readDword();
	local power = reciveData.readDword();
	local moveMode = reciveData.readDword();
		
	local hitCnt = multi_hit_num;
	
	local atk = sq_GetCurrentAttackInfo(obj);
	
	if(atk)
	{
		sq_SetCurrentAttackBonusRate(atk, power);
	}
	
	
	// 작은 얼음고리가 공격하면서 돌아다니는 시간 시간 (노승진)
	local attackTime = 3000; // 0.01초단위
	
	obj.getVar("attackTime").clear_vector();
	obj.getVar("attackTime").push_vector(attackTime);
	
	
	obj.getVar("move").clear_vector();
	obj.getVar("move").push_vector(moveMode);
	
	local object = sq_GetObjectByObjectId(obj, id);
	obj.sq_var.clear_obj_vector();
	obj.sq_var.push_obj_vector(object);
	
	obj.getVar("findchr").clear_vector();
	obj.getVar("findchr").push_vector(1);
	
	
	
	if(!object)
	{
		obj.getVar("findchr").set_vector(0, 0);
	}
	
	obj.getVar().clear_ct_vector();
	obj.getVar().push_ct_vector();	
	
	local t = obj.getVar().get_ct_vector(0);
	t.Reset();
	t.Start(10000,0);
	
	obj.getVar("sr").clear_ct_vector();
	obj.getVar("sr").push_ct_vector();	
	
	obj.getVar("sr").clear_vector();

	local changeAngle = 45;
	obj.getVar("sr").push_vector(changeAngle);
	obj.getVar("sr").push_vector(20);
	
	
	
	
	obj.getVar("dir").clear_vector();
	obj.getVar("dir").push_vector(0);
	
	local pAni = obj.getCurrentAnimation();	
	local initDelay = 0;

	local term = attackTime / hitCnt;
	
	obj.timer_.setParameter(term, -1);
	obj.timer_.resetInstant(initDelay);
	
	
	///////////////////////////////////////////////////////////////////////
	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);
	
	obj.getVar("pos").clear_vector();
	
	obj.getVar("pos").push_vector(x);
	obj.getVar("pos").push_vector(y);
	obj.getVar("pos").push_vector(z);
	
	obj.getVar("dis").clear_vector();	
	
	
	
	obj.getVar("dis").push_vector(x);
	obj.getVar("dis").push_vector(y);
	obj.getVar("dis").push_vector(z);
	
	local xLen = 200;
	local yLen = 0;
	local zLen = 50;
	//local zLen = 250;
	
	if(object)
	{
		xLen = obj.getXDistance(object);
		yLen = sq_GetYPos(object) - sq_GetYPos(obj);
		zLen = sq_GetZPos(object) + (sq_GetObjectHeight(object) / 2);
	}
	
	obj.getVar("dis").push_vector(xLen);
	obj.getVar("dis").push_vector(yLen);
	obj.getVar("dis").push_vector(zLen);

	///////////////////////////////////////////////////////////////////////
	
	obj.getVar("state").clear_vector(); // state vector
	obj.getVar("state").push_vector(0);
	
	obj.getVar("hitCnt").clear_vector();
	obj.getVar("hitCnt").push_vector(hitCnt);
	obj.getVar("hitCnt").push_vector(1);
	
	obj.getVar("end").clear_vector();
	obj.getVar("end").push_vector(0);
	
	
	obj.getVar("state").clear_ct_vector();
	
	obj.getVar("state").push_ct_vector();
	local t = obj.getVar("state").get_ct_vector(0);
	t.Reset();
	t.Start(100000,0);
	
	//print(" term:" + term + "hitCnt:" + hitCnt);
	initGetVarTimer(obj, 2, term, hitCnt + 1);
	
	local currentT = 0;
	
	local isMyControl = obj.isMyControlObject();
	
	

	if(isMyControl) {
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
		
		obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_0, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
	
	

}

function setState_po_ATIceChakramSmallIceRing(obj, state, datas)
{
	if(!obj) return;
	
	local pChr = obj.getTopCharacter();
	
	if(!pChr)
	{
		if(obj.isMyControlObject())
		{
			sq_SendDestroyPacketPassiveObject(obj);			
		}
				
		return;
	}
	
	local t = obj.getVar().get_ct_vector(0);
	
	if(t)
	{
		t.Reset();
		t.Start(10000,0);
	}
	
	local srT = obj.getVar("sr").get_ct_vector(0);
	srT.Reset();
	srT.Start(10000,0);
	
	

	local passiveState = state;
	
	obj.getVar("state").set_vector(0, passiveState);
	
	obj.getVar("angle").clear_vector();
	obj.getVar("angle").push_vector(0);
	
	
	if(passiveState == PASSIVEOBJ_SUB_STATE_0)
	{ // 추격
		local dir = obj.getDirection();
		obj.getVar("dir").set_vector(0, dir);
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{ // 타격
		local x = sq_GetXPos(obj);
		local y = sq_GetYPos(obj);
		local z = sq_GetZPos(obj);
		
		obj.getVar("pos").clear_vector();
		
		obj.getVar("pos").push_vector(x);
		obj.getVar("pos").push_vector(y);
		obj.getVar("pos").push_vector(z);
		
		//obj.sq_SetMoveParticle("Particle/Sparrow.ptl", 20.0, -25.0);
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_2)
	{
		local x = sq_GetXPos(obj);
		local y = sq_GetYPos(obj);
		local z = sq_GetZPos(obj);
		
		obj.getVar("dis").clear_vector();
		
		obj.getVar("dis").push_vector(x);
		obj.getVar("dis").push_vector(y);
		obj.getVar("dis").push_vector(z);
		
		local dx = sq_GetXPos(pChr);
		local dy = sq_GetYPos(pChr) + 1;
		local dz = sq_GetZPos(pChr) + 160;
		
		local xLen = 200;
		local yLen = 0;
		local zLen = 50;
		
		xLen = obj.getXDistance(pChr);
		yLen = dy - sq_GetYPos(obj);
		zLen = dz;

		print(" zLen:" + zLen);		
		//print( " xlen:" + xLen + " ylen:" + yLen + " zlen:" + zLen);
		
		obj.getVar("dis").push_vector(xLen);
		obj.getVar("dis").push_vector(yLen);
		obj.getVar("dis").push_vector(zLen);
		
		local initDir = obj.getVar("dir").get_vector(0);
		
		//local oppDir = sq_GetOppositeDirection(initDir);
		//obj.setCurrentDirection(oppDir);
		if(x > dx)
		{
			obj.setCurrentDirection(ENUM_DIRECTION_LEFT);
		}
		else
		{
			obj.setCurrentDirection(ENUM_DIRECTION_RIGHT);
		}
	
	}
}

function procAppend_po_ATIceChakramSmallIceRing(obj)
{
	if(!obj) return;

	local state = obj.getVar("state").get_vector(0);
	
	if(state == 0)
		return;
	
	local pChr = obj.getTopCharacter();
	
	if(!pChr)
	{
		if(obj.isMyControlObject())
		{
			sq_SendDestroyPacketPassiveObject(obj);			
		}
		
		return;
	}
	
	local passiveState = state;
		
	local pAni = obj.getCurrentAnimation();
	
	local t = obj.getVar().get_ct_vector(0);
	local currentT = 0;
	
	currentT = t.Get();
	
		
	if(passiveState == PASSIVEOBJ_SUB_STATE_0 || passiveState == PASSIVEOBJ_SUB_STATE_2)
	{ // 추격, 회수
		local fireT = 150;
		
		if(obj.getVar("findchr").get_vector(0) == 0)
		{
			fireT = 350;
		}
		
		if(passiveState == PASSIVEOBJ_SUB_STATE_2)
		{
			fireT = 300;
		}
		local srcX = obj.getVar("dis").get_vector(SMALLICERING_START_X); // 시작x
		local srcY = obj.getVar("dis").get_vector(SMALLICERING_START_Y); // 시작y
		local srcZ = obj.getVar("dis").get_vector(SMALLICERING_START_Z); // 시작z
		    	
		local dis_x_len = obj.getVar("dis").get_vector(SMALLICERING_MOV_X); // 총 이동거리
		local dis_y_len = obj.getVar("dis").get_vector(SMALLICERING_MOV_Y); // y축 이동거리
		local endZ = obj.getVar("dis").get_vector(SMALLICERING_MOV_Z); // z축 이동거리
		
		local v = sq_GetAccel(0, dis_x_len, currentT, fireT, true);
		local my = sq_GetAccel(0, dis_y_len, currentT, fireT, true);
		local mz = sq_GetAccel(srcZ, endZ, currentT, fireT, true);
		//local v = sq_GetUniformVelocity(0, dis_x_len, currentT, fireT);
		//local my = sq_GetUniformVelocity(0, dis_y_len, currentT, fireT);
		//local mz = sq_GetUniformVelocity(srcZ, endZ, currentT, fireT);
		
		local dstX = sq_GetDistancePos(srcX, obj.getDirection(), v);
		local dstY = srcY + my;
		 
		sq_setCurrentAxisPos(obj, 0, dstX);
		sq_setCurrentAxisPos(obj, 1, dstY);
		sq_setCurrentAxisPos(obj, 2, mz);
		
		if(passiveState == PASSIVEOBJ_SUB_STATE_2)
		{
			
		}
	
		if(currentT >= fireT)
		{
			if(passiveState == PASSIVEOBJ_SUB_STATE_0)
			{
				if(obj.isMyControlObject())
				{
					local pIntVec = sq_GetGlobalIntVector();
				
					sq_IntVectorClear(pIntVec);
					sq_IntVectorPush(pIntVec, 0);

					obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
				}
			}
			else if(passiveState == PASSIVEOBJ_SUB_STATE_2)			
			{
				if(obj.isMyControlObject())
				{
					sq_SendDestroyPacketPassiveObject(obj);
				}
			}
		}
	
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{ // 타격
	
		local hitT = obj.getVar().get_timer_vector(0);

		if(!obj.getVar("move").get_vector(0))
		{
			procSmallRingMove(obj);
		}
		else
		{		
			local movT = obj.getVar().get_timer_vector(1);
			if(movT)
			{
				if(movT.isOnEvent(currentT) == true)
				{			
					local x = sq_GetXPos(obj);
					local y = sq_GetYPos(obj);
					local z = sq_GetZPos(obj);
					
					local ox = obj.getVar("pos").get_vector(0);
					local oy = obj.getVar("pos").get_vector(1);
					local oz = obj.getVar("pos").get_vector(2);
					
					local dx = 0;
					local dy = 0;
					local dz = 0;
					
					
					if(ox != x)
						dx = ox;
					else
						dx = x + sq_getRandom(-40, 40);
					
					if(oy != y)
						dy = oy;
					else
						dy = y + sq_getRandom(-40, 40);
				
					//print( " ox:" + ox + " oy:" + oy + " x:" + x + " y:" + y + " dx:" + dx + " dy:" + dy);
					
					sq_setCurrentAxisPos(obj, 0, dx);
					sq_setCurrentAxisPos(obj, 1, dy);
					sq_setCurrentAxisPos(obj, 2, z);
				}
			}
		}
	
		if(hitT)
		{		
			if(hitT.isOnEvent(currentT) == true)
			{			
				obj.resetHitObjectList();
			}
		}	

		local targetObj = obj.sq_var.get_obj_vector(0);
		
		if(targetObj)
		{
			local x = sq_GetXPos(targetObj);
			local y = sq_GetYPos(targetObj);
			local z = targetObj.getZPos() + (sq_GetObjectHeight(targetObj) / 2);
			
			obj.getVar("pos").set_vector(0, x);
			obj.getVar("pos").set_vector(1, y);
			obj.getVar("pos").set_vector(2, z);
		}
		
		
		local attackTime = obj.getVar("attackTime").get_vector(0); // 0.01초단위
		if(currentT > attackTime || obj.getVar("findchr").get_vector(0) == 0)
		{
			if(obj.isMyControlObject())
			{
				local pIntVec = sq_GetGlobalIntVector();
				
				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);
				
				obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_2, pIntVec, STATE_PRIORITY_AUTO, false, "");
			}
		}
	}
}

function onChangeSkillEffect_po_ATIceChakramSmallIceRing(obj, skillIndex, reciveData)
{
	if(!obj) return;
	
	if(skillIndex != SKILL_ICECHAKRAM) return;	
	
	local pChr = obj.getTopCharacter();	
	
	if(!pChr) return;	
	
	local changeAngle = reciveData.readFloat();

	//print( " changeAngle:" + changeAngle);
	local t = obj.getVar("sr").get_ct_vector(0);
	
	if(!t)
		return;
		
	t.Reset();
	t.Start(10000,0);
	
	//print( " changeAngle:" + changeAngle);
	
		//local bombingStartAngle_ = obj.getVar("sr").get_vector(1)
		//local bombingChangeAngle_ = obj.getVar("sr").get_vector(0);
	
	obj.getVar("sr").set_vector(0, changeAngle.tointeger());
	local currentAng = obj.getVar("angle").get_vector(0);
	obj.getVar("sr").set_vector(1, currentAng);
	
	
}

function onDestroyObject_po_ATIceChakramSmallIceRing(obj, object)
{

	if(!obj) return;

}

function onKeyFrameFlag_po_ATIceChakramSmallIceRing(obj, flagIndex)
{

}

function onEndCurrentAni_po_ATIceChakramSmallIceRing(obj)
{

	if(!obj) return;

}

function getCustomHitEffectFileName_po_ATIceChakramSmallIceRing(obj, isAttachOnDamager)
{
	return "PassiveObject/Character/Mage/Animation/ATIceChakram/fire/08_chakrahit_dodge.ani";
}
