function checkExecutableSkill_windtest(obj)  
{
	if (!obj) return false;
	local isUse = obj.sq_IsUseSkill(SKILL_windtest);

	if (isUse) {
		obj.sq_AddSetStatePacket(STATE_windtest , STATE_PRIORITY_USER, false);
		return true;
	}

	return false;
}



// ????? ??? ??? ??? ?????. true? ???? ?? ???? ???? ???. (???? state?  ???? ?????.)
function checkCommandEnable_windtest(obj)
{
	if (!obj) return false;
	local state = obj.sq_GetState();
	

	if (state == STATE_STAND)
		return true;
		
	if(state == STATE_ATTACK)
	{
		// ?????? ????? ??? ?????. ???:??? [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_windtest); // ?????? ????? ??? ?????. ???:??? [2012.04.20] obj.sq_IsCommandEnable(SKILL_windtest);
	}	
	
	
	return true;
}


// state? ???? ???? ???? ???. ?? ???? ?????. 
function onSetState_windtest(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	obj.sq_StopMove();
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_windtest);
	obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
			SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
}

function onEndCurrentAni_windtest(obj)
{
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}


function onKeyFrameFlag_windtest(obj,flagIndex)
{
	if(!obj)
		return false;

	local isMyControlObject = obj.sq_IsMyControlObject();

	// ??? ???? ??
	if (isMyControlObject && flagIndex == 1)
	{
		local xPosMin = obj.sq_GetIntData(SKILL_windtest, 0);
		local xPosMax = obj.sq_GetIntData(SKILL_windtest, 1);
		local strikeCount = obj.sq_GetIntData(SKILL_windtest, 2);
		
		local attackBonusRate = obj.sq_GetBonusRateWithPassive(SKILL_windtest, STATE_windtest, SKL_LVL_COLUMN_IDX_0, 1.0);	// ???1(%)
		local power = obj.sq_GetPowerWithPassive(SKILL_windtest, STATE_windtest, SKL_LVL_COLUMN_IDX_1, SKL_LVL_COLUMN_IDX_0, 1.0);
		//local power = obj.sq_GetSkillPowerWithAttackBonusRate(SKILL_windtest, 1, attackBonusRate);
		local upForce = obj.sq_GetLevelData(2);
				
				
		obj.sq_StartWrite();
		//obj.sq_WriteWord(EARTHQUAKE_ROCK_MAX);
		obj.sq_WriteDword(attackBonusRate);	// attackBonusRate
		obj.sq_WriteDword(power);		// power
		obj.sq_WriteWord(upForce);		// upForce
		while(strikeCount--)
		{
			obj.sq_SendCreatePassiveObjectPacket(24201, 0, 120*strikeCount, 1, 0);
		}
	}
	return true;
}
