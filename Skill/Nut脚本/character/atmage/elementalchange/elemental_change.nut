
function checkExecutableSkill_ElementalChange(obj)
{

	if (!obj) return false;

	local isUseSkill = obj.sq_IsUseSkill(SKILL_ELEMENTAL_CHANGE);
	if (isUseSkill)
	{
		/*
		# STATE_THROW
		[0]   Throw State (0:모으기, 1:던지기, 2:개인시전)
		* Throw State 0 *
		[1]   던지는 타입 (ENUM_THROW_TYPE)
		[2]   던지는 대상의 인덱스 (스킬 인덱스 or 아이템 인덱스)
		[3]   모으는 시간
		[4]   발사 시간
		[5]   던지기 애니메이션 타입 (0 or 1)
		[6]   모으기 속도 타입
		[7]   발사 속도 타입
		[8]   모으기 속도 (안넣으면 SPEED_VALUE_DEFAULT)
		[9]   발사 속도 (안넣으면 SPEED_VALUE_DEFAULT)
		[10]	개인시전 범위 (안넣거나 -1이면 개인시전 안함)
		* Throw State 1 *
		// Throw State 2에서 넘어왔을 경우에만
		[1]	개인 시전시 대상 Object Id
		* Throw State 2 *
		*/

		obj.sq_IntVectClear();				
		obj.sq_IntVectPush(0);		// throwState
		obj.sq_IntVectPush(0);		// throwType
		obj.sq_IntVectPush(SKILL_ELEMENTAL_CHANGE);	// throwIndex
		obj.sq_IntVectPush(500);	// throwChargeTime
		obj.sq_IntVectPush(500);	// throwShootTime
		obj.sq_IntVectPush(0);		// throwAnimationIndex
		obj.sq_IntVectPush(4);		// chargeSpeedType
		obj.sq_IntVectPush(4);		// throwShootSpeedType
		obj.sq_IntVectPush(1000);	// chargeSpeedValue
		obj.sq_IntVectPush(1000);	// throwShootSpeedValue
		obj.sq_IntVectPush(-1);		// personalCastRange
		obj.sq_AddSetStatePacket(STATE_THROW, STATE_PRIORITY_USER, true);	
		

		//obj.sq_AddSetStatePacket(STATE_ELEMENTAL_CHANGE, STATE_PRIORITY_USER, false);
		obj.sq_PlaySound("MW_PCHANGE");
		
		return true;
	}
	return false;

}



function checkCommandEnable_ElementalChange(obj)
{
	if(!obj) return false;

	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK)
	{
		return obj.sq_IsCommandEnable(SKILL_ELEMENTAL_CHANGE); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_BROKENARROW);
	}

	return true
}

function onSetState_ElementalChange(obj, state, datas, isResetTimer)
{
	if (!obj)
		return;

	obj.sq_StopMove();
	//obj.sq_SetCurrentAnimation(CUSTOM_ANI_ELEMENTAL_CHANGE);
	
	//local attackSpeedRate = obj.sq_GetIntData(SKILL_CRYSTALATTACK, 0);	
	//if(attackSpeedRate != 100) {
	//	obj.sq_SetAnimationSpeedRate(obj.sq_GetCurrentAni(),attackSpeedRate.tofloat());
	//}
	//local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_ELEMENTAL_CHANGE, false, "Character/ATMage/ElementalChange/ap_ATMage_Elemental_Change.nut", true);
	//local maxValue = sq_GetIntData(obj, SKILL_DEVILSTRIKE, SI_DS_MAX_DEVIL_GAUGE);
}

function prepareDraw_ElementalChange(obj)
{
	if (!obj)
		return;
}

function onEndCurrentAni_ElementalChange(obj)
{
	if (!obj)
		return;
}

function onKeyFrameFlag_ElementalChange(obj, flagIndex)
{
	if (!obj)
		return true;
	
	return true;
}