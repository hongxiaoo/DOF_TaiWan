
function checkExecutableSkill_Resonance(obj)
{
	if (!obj)
		return false;
	
	local isUseSkill = obj.sq_IsUseSkill(SKILL_RESONANCE);

	if (isUseSkill)
	{
		obj.sq_AddSetStatePacket(STATE_RESONANCE, STATE_PRIORITY_IGNORE_FORCE, false);
		return true;
	}	

	return false;
}


function onEndCurrentAni_Resonance(obj)
{
	if (!obj)
		return;
	if (!obj.isMyControlObject())
		return;

	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

function checkCommandEnable_Resonance(obj)
{
	if (!obj)
		return false;

	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK) {
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_RESONANCE);
	}
	

	return true;

}

function onEndState_Resonance(obj, state)
{
	// 스테이트 종료 혹은 취소 되었다면 캐스팅 게이지 없앰
	sq_EndDrawCastGauge(obj);
}


// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_Resonance(obj, state, datas, isResetTimer)
{	
	if (!obj)
		return;

	obj.getVar().clear_vector();
	obj.getVar().push_vector(0);

	obj.sq_StopMove();
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_RESONANCE);
	obj.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_INFO_RESONANCE);

	obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATResonance/0_body_dodge.ani"), 6, -68);
	obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATResonance/4_s-1_dodge.ani"), 6, -68);
	obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATResonance/3_m_dodge.ani"), 6, -68);

	// 수속성 강화 버프를 걸어준다.
	local skillLevel = sq_GetSkillLevel(obj, SKILL_RESONANCE);

	// 캐스팅 속도를 따라가도록 설정
	// 캐스팅 속도가 변경되면, 에니메이션 속도도 변경 됩니다.
	// 캐스팅 게이지도 표시를 해줍니다.
	local castTime = sq_GetCastTime(obj, SKILL_RESONANCE, skillLevel);
	local animation = sq_GetCurrentAnimation(obj);
	local startTime = sq_GetFrameStartTime(animation, 15);
	local speedRate = startTime.tofloat() / castTime.tofloat();	
	obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
		SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, speedRate, speedRate);

	sq_StartDrawCastGauge(obj, startTime, true);
}


function onProc_Resonance(obj)
{
	if(!obj) return;

	local substate = obj.getSkillSubState();

	local pAni = obj.sq_GetCurrentAni();
	local frmIndex = obj.sq_GetCurrentFrameIndex(pAni);
	local currentT = sq_GetCurrentTime(pAni);

	local sq_var = obj.getVar();
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();	
	
	if(frmIndex >= 16)
	{
		if(!obj.getVar().get_vector(0))
		{
			obj.getVar().set_vector(0, 1);
		}
	}

}


function onKeyFrameFlag_Resonance(obj, flagIndex)
{
	if (flagIndex == 1)
	{
		if(obj.sq_IsMyControlObject())
		{
			obj.sq_SetShake(obj, 3, 250);
		}
		
		local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_RESONANCE, false,
		 "Character/ATMage/Resonance/ap_ATMage_element_attack_water.nut", false);


		local skill_level = sq_GetSkillLevel(obj, SKILL_RESONANCE);
		appendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, sq_getJob(obj), SKILL_RESONANCE, skill_level);

		// 여기서 append 작업		
		CNSquirrelAppendage.sq_AppendAppendageID(appendage, obj, obj, APID_RESONANCE, true);
		//		
		
		// 중복되면 안되기 때문에.. 다시 얻는다..
		appendage = obj.GetSquirrelAppendage("Character/ATMage/Resonance/ap_ATMage_element_attack_water.nut");
		
		// 이속 감소
		if(appendage)
		{
			 // 지속시간
			local change_time = sq_GetLevelData(obj, SKILL_RESONANCE, SKL_STATIC_INT_IDX_0, skill_level);
			
			appendage.sq_SetValidTime(change_time); // 어펜디지 타임 세팅
			
			print(" change_time:" + change_time);
			
			local registValue = sq_GetLevelData(obj, SKILL_RESONANCE, 
			SKL_STATIC_INT_IDX_2, skill_level); // 2.자신의 수속성 강화 증가량(+)
			
			local change_appendage = appendage.sq_getChangeStatus("ele_atk_water");
			
			if(!change_appendage)
				change_appendage = appendage.sq_AddChangeStatusAppendageID(obj, obj, 0, 
				CHANGE_STATUS_TYPE_ELEMENT_ATTACK_WATER, 
				false, registValue, APID_COMMON);
			
			if(change_appendage) {
				change_appendage.clearParameter();
				change_appendage.addParameter(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_WATER, false, registValue.tofloat());
			}
		}
		
	}

	return true;
}


function onAttack_Resonance(obj, damager, boundingBox, isStuck)
{
	if(!obj) return;
	
	local pChr = obj;
	
	local active_damager = sq_GetCNRDObjectToActiveObject(damager);
	
	if(!active_damager) return 0;
	
	local appendage = CNSquirrelAppendage.sq_AppendAppendage(damager, damager, SKILL_RESONANCE, false,
	 "Character/ATMage/Resonance/ap_ATMage_Resonance.nut", false);

	// 여기서 append 작업		
	CNSquirrelAppendage.sq_AppendAppendageID(appendage, damager, damager, APID_RESONANCE);
	//		
	
	// 중복되면 안되기 때문에.. 다시 얻는다..
	appendage = active_damager.GetSquirrelAppendage("Character/ATMage/Resonance/ap_ATMage_Resonance.nut");
	
	// 이속 감소
	if(appendage)
	{
		local skill_level = sq_GetSkillLevel(pChr, SKILL_RESONANCE);
		 // 지속시간
		local change_time = sq_GetLevelData(pChr, SKILL_RESONANCE, SKL_STATIC_INT_IDX_0, skill_level);
		
		appendage.sq_SetValidTime(change_time); // 어펜디지 타임 세팅
		
		local registValue = sq_GetLevelData(pChr, SKILL_RESONANCE, 
		SKL_STATIC_INT_IDX_1, skill_level); // 1.적 수속성 저항 감소량(+)
		
		registValue = -registValue;
		
		local change_appendage = appendage.sq_getChangeStatus("changeStatus");
		
		if(!change_appendage)
			change_appendage = appendage.sq_AddChangeStatusAppendageID(damager, damager, 0, 
			CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_WATER, 
			false, registValue, APID_COMMON);
		
		if(change_appendage) {
			change_appendage.clearParameter();
			change_appendage.addParameter(CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_WATER, false, registValue.tofloat());
		}
	}
	else {
		print(" exist appendage");
	}
	

}
