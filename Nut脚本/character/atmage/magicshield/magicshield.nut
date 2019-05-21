// 어펜디지만을 붙이고 상세기능은 어펜디지에서 다 한다.

function checkExecutableSkill_MagicShield(obj)
{

	if(!obj) return false;

	local b_useskill = obj.sq_IsUseSkill(SKILL_MAGIC_SHIELD);
	if(b_useskill) {
		obj.sq_AddSetStatePacket(STATE_MAGIC_SHIELD , STATE_PRIORITY_USER, false);
		return true;
	}	
	return false;

}

function checkCommandEnable_MagicShield(obj)
{
	if(!obj)
		return false;
		
	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK) {
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_MAGIC_SHIELD);
	}
	
	return true;
}

function onEndState_MagicShield(obj, newState)
{
}

function onSetState_MagicShield(obj, state, datas, isResetTimer)
{
	if(!obj) return;
	
	obj.sq_StopMove();
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_AT_MAGIC_SHIELD);
	obj.sq_PlaySound("MW_ESHIELD");
	
	//obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
	//	SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
}

function onEndCurrentAni_MagicShield(obj)
{
	if(!obj) return;
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

function onKeyFrameFlag_MagicShield(obj, flagIndex)
{
	if(!obj) return true;	
	
	local appendage = null;
	
	if (CNSquirrelAppendage.sq_IsAppendAppendage(obj, "Character/ATMage/MagicShield/ap_MagicShield.nut"))
		CNSquirrelAppendage.sq_RemoveAppendage(obj, "Character/ATMage/MagicShield/ap_MagicShield.nut");
	
	appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_MAGIC_SHIELD, true, "Character/ATMage/MagicShield/ap_MagicShield.nut", false);
				
	if (appendage) {
		local level	= sq_GetSkillLevel(obj, SKILL_MAGIC_SHIELD);
		appendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, sq_getJob(obj),SKILL_MAGIC_SHIELD,level); //  아이콘
		CNSquirrelAppendage.sq_AppendAppendageID(appendage, obj, obj, APID_MAGIC_SHIELD, true);
	}

	return true;
}
