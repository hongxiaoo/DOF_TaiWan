function checkExecutableSkill_WindStrike(obj)  
{
	if (!obj) return false;
	local isUse = obj.sq_IsUseSkill(SKILL_WIND_STRIKE);

	if (isUse) {
		obj.sq_AddSetStatePacket(STATE_WIND_STRIKE , STATE_PRIORITY_USER, false);
		return true;
	}

	return false;
}



// 스킬아이콘 활성화 조건을 따지는 함수입니다. true를 리턴하면 스킬 아이콘이 활성화가 됩니다. (발동조건 state는  소스에서 처리됩니다.)
function checkCommandEnable_WindStrike(obj)
{
	if (!obj) return false;
	local state = obj.sq_GetState();
	

	if (state == STATE_STAND)
		return true;
		
	if(state == STATE_ATTACK)
	{
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_WIND_STRIKE); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_WIND_STRIKE);
	}	
	
	
	return true;
}


// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_WindStrike(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	obj.sq_StopMove();
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_WIND_STRIKE);
	obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
			SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
}

function onEndCurrentAni_WindStrike(obj)
{
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}


function onKeyFrameFlag_WindStrike(obj,flagIndex)
{
	if(!obj)
		return false;

	local isMyControlObject = obj.sq_IsMyControlObject();

	// 회오리 오브젝트 생성
	if (isMyControlObject && flagIndex == 1)
	{
		local xPosMin = obj.sq_GetIntData(SKILL_WIND_STRIKE, 0);
		local xPosMax = obj.sq_GetIntData(SKILL_WIND_STRIKE, 1);
		
		local attackBonusRate = obj.sq_GetBonusRateWithPassive(SKILL_WIND_STRIKE, STATE_WIND_STRIKE, SKL_LVL_COLUMN_IDX_0, 1.0);	// 공격력1(%)
		local power = obj.sq_GetPowerWithPassive(SKILL_WIND_STRIKE, STATE_WIND_STRIKE, SKL_LVL_COLUMN_IDX_1, SKL_LVL_COLUMN_IDX_0, 1.0);
		//local power = obj.sq_GetSkillPowerWithAttackBonusRate(SKILL_WIND_STRIKE, 1, attackBonusRate);
		local upForce = obj.sq_GetLevelData(2);
				
				
		obj.sq_StartWrite();
		//obj.sq_WriteWord(EARTHQUAKE_ROCK_MAX);
		obj.sq_WriteDword(attackBonusRate);	// attackBonusRate
		obj.sq_WriteDword(power);		// power
		obj.sq_WriteWord(upForce);		// upForce
		obj.sq_SendCreatePassiveObjectPacket(24201, 0, 120, 1, 0);
	}
	return true;
}
