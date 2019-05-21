
function checkExecutableSkill_IceFieldEx(obj)
{

	if (!obj) return false;

	local useSkill = obj.sq_IsUseSkill(SKILL_ICE_FIELD_EX);

	if (useSkill) {
		obj.sq_AddSetStatePacket(STATE_ICE_FIELD_EX, STATE_PRIORITY_IGNORE_FORCE, false);
		return true;
	}

	return false;

}

function checkCommandEnable_IceFieldEx(obj)
{

	if(!obj) return false;

	local state = obj.sq_GetState();

	if(state == STATE_ATTACK) {
		// 캔슬 스킬 개편 작업자: 정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_ICE_FIELD_EX);
	}

	return true;

}

function onSetState_IceFieldEx(obj, state, datas, isResetTimer)
{
	if(!obj) return;	
	
	obj.sq_StopMove();
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_ICE_FIELD_EX);	
	obj.sq_PlaySound("MW_ICEFIELD");
}

function onEndCurrentAni_IceFieldEx(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();	
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);	// 애니 끝나면 스탠드로.
}

function onKeyFrameFlag_IceFieldEx(obj, flagIndex)
{

	if(!obj) return false;

	local substate = obj.getSkillSubState();	
	local level		  = sq_GetSkillLevel(obj, SKILL_ICE_FIELD_EX);
	
	if(flagIndex == 1) {
		local level	    = sq_GetSkillLevel(obj, SKILL_ICE_FIELD_EX);
		local power		= obj.sq_GetBonusRateWithPassive(SKILL_ICE_FIELD_EX , STATE_ICE_FIELD_EX, 0, 1.0);	//  LEVEL 0. 얼음 송곳 공격력(%)
		local iceLevel  = sq_GetLevelData(obj, SKILL_ICE_FIELD_EX, 1, level);	// LEVEL 1. 빙결 레벨
		local iceProb   = sq_GetLevelData(obj, SKILL_ICE_FIELD_EX, 2, level);	// LEVEL 2. 빙결 확률
		local iceTime   = sq_GetLevelData(obj, SKILL_ICE_FIELD_EX, 3, level);	// LEVEL 3. 빙결 시간
		
		obj.sq_StartWrite();
		obj.sq_WriteFloat(power.tofloat()); //음수일수도 있기때문에 float형으로 보낸다. sqr에선 DWORD 형을 자동으로 int형으로 바꿔 주질 않기 때문.
		obj.sq_WriteDword(iceLevel);
		obj.sq_WriteDword(iceProb);
		obj.sq_WriteDword(iceTime);
		obj.sq_SendCreatePassiveObjectPacket(24237, 0, 0, 0, 0);	// 필드 생성, 100,50의 좌표에 생성		
	}

	return true;

}
