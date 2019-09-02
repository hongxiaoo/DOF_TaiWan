function checkExecutableSkill_RISINGCUTKAI(obj)
{
	if (!obj) return false;

	local isUse = obj.sq_IsUseSkill(SKILL_RISINGCUTKAI);

	if (isUse)
	{
		obj.sq_AddSetStatePacket(STATE_RISINGCUTKAI, STATE_PRIORITY_USER, false);
		return true;
	}

	return false;
}

function checkCommandEnable_RISINGCUTKAI(obj)
{
	if (!obj) return false;

	local state = obj.sq_GetState();
	if (state = STATE_STAND)
	{
		return true;
	}

	return true;
}

function onSetState_RISINGCUTKAI(obj, state, datas, isResetTimer)
{
	if (!obj) return;

	obj.sq_StopMove();
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_RISINGCUTKAI);

}

function onEndCurrentAni_RISINGCUTKAI(obj)
{
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	
}