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



function checkCommandEnable_WindStrike(obj)
{
	if (!obj) return false;
	local state = obj.sq_GetState();
	

	if (state == STATE_STAND)
		return true;

	if(state == STATE_ATTACK)
	{
		return obj.sq_IsCommandEnable(SKILL_WIND_STRIKE);
	}	
	
	
	return true;
}


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

	if (isMyControlObject && flagIndex == 1)
	{
		local windstrikemount = obj.sq_GetLevelData(3);
		local winstrikex = 0;
		local winstrikey = 0;
		for(local i=0;i<windstrikemount;++i){
		local xPosMin = obj.sq_GetIntData(SKILL_WIND_STRIKE, 0);
		local xPosMax = obj.sq_GetIntData(SKILL_WIND_STRIKE, 1);
		
		local attackBonusRate = obj.sq_GetBonusRateWithPassive(SKILL_WIND_STRIKE, STATE_WIND_STRIKE, SKL_LVL_COLUMN_IDX_0, 1.0);	// ???1(%)
		local power = obj.sq_GetPowerWithPassive(SKILL_WIND_STRIKE, STATE_WIND_STRIKE, SKL_LVL_COLUMN_IDX_1, SKL_LVL_COLUMN_IDX_0, 1.0);
		local upForce = obj.sq_GetLevelData(2);
				
				
		obj.sq_StartWrite();
		obj.sq_WriteDword(attackBonusRate);
		obj.sq_WriteDword(power);
		obj.sq_WriteWord(upForce);
		obj.sq_WriteWord(windstrikemount);
		obj.sq_SendCreatePassiveObjectPacket(24201, 0, 120*i, 60*i, 0);
		obj.sq_SendCreatePassiveObjectPacket(24201, 0, 120*i, -60*i, 0);
		obj.sq_SendCreatePassiveObjectPacket(24201, 0, -120*i, 60*i, 0);
		obj.sq_SendCreatePassiveObjectPacket(24201, 0, -120*i, -60*i, 0);
	}
	}
	return true;
}



