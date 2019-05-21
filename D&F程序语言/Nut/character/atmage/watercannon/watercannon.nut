function checkExecutableSkill_WaterCannon(obj)
{
	if (!obj)
		return false;
	
	local isUseSkill = obj.sq_IsUseSkill(SKILL_WATER_CANNON);
	if (isUseSkill)
	{
	}
	
	if (isUseSkill)
	{
		obj.sq_AddSetStatePacket(STATE_WATER_CANNON, STATE_PRIORITY_IGNORE_FORCE, false);
		return true;
	}	

	return false;

}

function checkCommandEnable_WaterCannon(obj)
{

	if(!obj) return false;

	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK)
	{
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_WATER_CANNON);
	}
	

	return true;

}

function onChangeSkillEffect_WaterCannon(obj, skillIndex, reciveData)
{
	if(!obj)
		return;
}

function onSetState_WaterCannon(obj, state, datas, isResetTimer)
{
	if (!obj)
		return;

	obj.sq_StopMove();
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_WATER_CANNON);
	//obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
	//	SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
	
	obj.sq_PlaySound("MW_WCANNON_READY");
	addElementalChain_ATMage(obj, ENUM_ELEMENT_WATER);
}

function prepareDraw_WaterCannon(obj)
{
}


function onProc_WaterCannon(obj)
{
	if (!obj)
		return;
}

function onProcCon_WaterCannon(obj)
{
}

function onEndCurrentAni_WaterCannon(obj)
{
	if (!obj)
		return;
	if (!obj.isMyControlObject())
		return;

	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

function onKeyFrameFlag_WaterCannon(obj, flagIndex)
{
	if (!obj)
		return false;
	if (!obj.sq_IsMyControlObject())
		return false;

	// 물대포 패시브 오브젝트 생성
	local skill = sq_GetSkill(obj, SKILL_WATER_CANNON);	// 스킬
	local skillLevel = sq_GetSkillLevel(obj, SKILL_WATER_CANNON);	// 스킬레벨
	local attackBonusRate = obj.sq_GetBonusRateWithPassive(SKILL_WATER_CANNON, STATE_WATER_CANNON, 0, 1.0);	// 공격력(%)
	local sizeRate = sq_GetLevelData(obj, SKILL_WATER_CANNON, 1, skillLevel);	// 물대포의 크기
	local xVelocityWaterCannon = sq_GetIntData(obj, SKILL_WATER_CANNON, 0); // 물대포의 속도
	local distance = sq_GetIntData(obj, SKILL_WATER_CANNON, 1); // 물대포의 나가는 거리
	
	
	obj.sq_StartWrite();
	obj.sq_WriteDword(attackBonusRate);
	obj.sq_WriteWord(sizeRate);
	obj.sq_WriteWord(xVelocityWaterCannon);
	obj.sq_WriteWord(distance);
	obj.sq_SendCreatePassiveObjectPacket(24217, 0, 68, 1, 70);


	local xVelocity = sq_GetIntData(obj, SKILL_WATER_CANNON, 2);
	local xAccel = sq_GetIntData(obj, SKILL_WATER_CANNON, 3);
	// 방향키를 반대로 하고 있는지 체크
	local direction = obj.sq_GetInputDirection(0);
    if (obj.getDirection() == sq_GetOppositeDirection(direction))
	{
		xVelocity = sq_GetIntData(obj, SKILL_WATER_CANNON, 4);
		xAccel = sq_GetIntData(obj, SKILL_WATER_CANNON, 5);
    }

	// 뒤로 밀려나는 효과를 위함
	obj.sq_SetStaticMoveInfo(0, xVelocity, xVelocity, false, xAccel, true);
	obj.sq_SetStaticMoveInfo(1, 0, 0, false);
	obj.sq_SetMoveDirection(obj.getDirection(), ENUM_DIRECTION_NEUTRAL);

	return true;
}
