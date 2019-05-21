function checkExecutableSkill_guizhanx(obj)
{
	if (!obj) return false;
	local isUse = obj.sq_IsUseSkill(SKILL_guizhanx);

	if (isUse) {
		obj.sq_AddSetStatePacket(STATE_guizhanx , STATE_PRIORITY_USER, false);
		return true;
	}

	return false;
}


function checkCommandEnable_guizhanx(obj)
{
	if (!obj) return false;
	local state = obj.sq_GetState();
	

	if (state == STATE_STAND)
		return true;
		
	if(state == STATE_ATTACK)
	{
	
		return obj.sq_IsCommandEnable(SKILL_guizhanx);
	}	
	
	
	return true;
}


function onSetState_guizhanx(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	obj.sq_StopMove();
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_guizhanx);
	obj.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_INFO_guizhanx);
	obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
			SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
	obj.sq_setCustomHitEffectFileName("Character/Swordman/Effect/Animation/hardattack1.ani");	
	obj.sq_setCustomHitEffectFileName("Character/Swordman/Effect/Animation/hardattack2.ani");	
}

function onEndCurrentAni_guizhanx(obj)
{
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}


function onKeyFrameFlag_guizhanx(obj,flagIndex)
{
	if(!obj)
		return false;

	local isMyControlObject = obj.sq_IsMyControlObject();

	
	if (isMyControlObject && flagIndex == 1)
	{
		local xPosMin = obj.sq_GetIntData(SKILL_guizhanx, 0);
		local xPosMax = obj.sq_GetIntData(SKILL_guizhanx, 1);
		
		local attackBonusRate = obj.sq_GetBonusRateWithPassive(SKILL_guizhanx, STATE_guizhanx, SKL_LVL_COLUMN_IDX_0, 1.0);
		local power = obj.sq_GetPowerWithPassive(SKILL_guizhanx, STATE_guizhanx, SKL_LVL_COLUMN_IDX_1, SKL_LVL_COLUMN_IDX_0, 1.0);
				
				
		obj.sq_StartWrite();
		obj.sq_WriteDword(attackBonusRate);	// attackBonusRate
		obj.sq_WriteDword(power);		// power
	}
	return true;
}
