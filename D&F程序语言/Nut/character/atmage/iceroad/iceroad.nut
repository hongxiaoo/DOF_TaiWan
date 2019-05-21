
SUB_STATE_ICEROAD_0	<- 0
SUB_STATE_ICEROAD_1	<- 1
SUB_STATE_ICEROAD_2	<- 2
SUB_STATE_ICEROAD_3	<- 3
SUB_STATE_ICEROAD_4	<- 4
SUB_STATE_ICEROAD_CASTING	<- 5

SKL_LV_0 <- 0 // 시간당 mp 소모량
SKL_LV_1 <- 1 // 지속시간
SKL_LV_2 <- 2 // 이속 감소치
SKL_LV_3 <- 3 // 이속 확율


function checkExecutableSkill_IceRoad(obj)
{

	if(!obj) return false;
	
	local skill = sq_GetSkill(obj, SKILL_ICEROAD);
	
	if(!skill) return false;
	
	local appendage = obj.GetSquirrelAppendage("Character/ATMage/IceRoad/ap_ATMage_IceRoad.nut");
	
	if(appendage) {
		local isvalid = appendage.isValid();
		if(isvalid) {
			sq_SendChangeSkillEffectPacket(obj, SKILL_ICEROAD);
			//skill.resetCurrentCoolTime();
			//skill.setSealActiveFunction(true);	
			//local skill_level = sq_GetSkillLevel(obj, SKILL_ICEROAD);
			//obj.startSkillCoolTime(SKILL_ICEROAD, skill_level, -1);
			//
			//appendage.setValid(false);
			return true;
		}
	}	
	
	if(skill.isInCoolTime()) return false;
	
	local b_useskill = obj.sq_IsUseSkill(SKILL_ICEROAD);

	if(b_useskill) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_ICEROAD_CASTING); // substate세팅
		obj.sq_AddSetStatePacket(STATE_ICEROAD, STATE_PRIORITY_IGNORE_FORCE, true);
		return true;
	}

	return false;

}

function checkCommandEnable_IceRoad(obj)
{

	if(!obj) return false;

	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK) {
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_ICEROAD);
	}
	

	return true;

}

function onSetState_IceRoad(obj, state, datas, isResetTimer)
{

	if(!obj) return;

	local substate = obj.sq_GetVectorData(datas, 0);
	obj.setSkillSubState(substate);
	
	obj.sq_StopMove();	
	
	//obj.sq_SendCreatePassiveObjectPacket(24243, 0, 0, 0, 0);
	
	obj.getVar().clear_vector();
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);

	if(substate == SUB_STATE_ICEROAD_CASTING) {
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_ICEROAD_CASTING);
		
		local skillLevel = sq_GetSkillLevel(obj, SKILL_ICEROAD);
		local castTime = sq_GetCastTime(obj, SKILL_ICEROAD, skillLevel);
		local animation = sq_GetCurrentAnimation(obj);
		local startTime = sq_GetFrameStartTime(animation, 16);
		local speedRate = startTime.tofloat() / castTime.tofloat();
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
			SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, speedRate, speedRate);

		obj.sq_PlaySound("MW_ICEROAD");
		sq_StartDrawCastGauge(obj, startTime, true);
	}
	else if(substate == SUB_STATE_ICEROAD_0) {
		//CUSTOM_ANI_ICEROAD
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_ICEROAD);
	}
	else if(substate == SUB_STATE_ICEROAD_1) {
		// SUB_STATE_ICEROAD_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_2) {
		// SUB_STATE_ICEROAD_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_3) {
		// SUB_STATE_ICEROAD_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_4) {
		// SUB_STATE_ICEROAD_4 서브스테이트 작업
	}
	

}

function prepareDraw_IceRoad(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_ICEROAD_0) {
		// SUB_STATE_ICEROAD_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_1) {
		// SUB_STATE_ICEROAD_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_2) {
		// SUB_STATE_ICEROAD_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_3) {
		// SUB_STATE_ICEROAD_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_4) {
		// SUB_STATE_ICEROAD_4 서브스테이트 작업
	}
	

}

function onProc_IceRoad(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	local pAni = obj.sq_GetCurrentAni();
	local frmIndex = obj.sq_GetCurrentFrameIndex(pAni);
	local currentT = sq_GetCurrentTime(pAni);

	if(substate == SUB_STATE_ICEROAD_0) {
		if(frmIndex >= 7) {
			if(!obj.getVar().get_vector(0)) {
			
				local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_ICEROAD, false, "Character/ATMage/IceRoad/ap_ATMage_IceRoad.nut", false);
				
				// 여기서 append 작업		
				CNSquirrelAppendage.sq_Append(appendage, obj, obj);
				//

				if(obj.isMyControlObject()) {
					local skill = sq_GetSkill(obj, SKILL_ICEROAD);
					skill.setSealActiveFunction(false);
				}

				
				obj.getVar().set_vector(0, 1);
			}
		}
		
		if(frmIndex >= 4) {
			if(!obj.getVar().get_vector(1)) {
				local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_ICEROAD, true, "Appendage/Character/ap_atmage_effect.nut", true);
				obj.getVar().set_vector(1, 1);
			}
		}
	}
	else if(substate == SUB_STATE_ICEROAD_1) {
		// SUB_STATE_ICEROAD_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_2) {
		// SUB_STATE_ICEROAD_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_3) {
		// SUB_STATE_ICEROAD_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_4) {
		// SUB_STATE_ICEROAD_4 서브스테이트 작업
	}
	

}

function onProcCon_IceRoad(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();
	
	//obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);

	if(substate == SUB_STATE_ICEROAD_0) {
		// SUB_STATE_ICEROAD_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_1) {
		// SUB_STATE_ICEROAD_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_2) {
		// SUB_STATE_ICEROAD_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_3) {
		// SUB_STATE_ICEROAD_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_4) {
		// SUB_STATE_ICEROAD_4 서브스테이트 작업
	}
	

}

function onEndCurrentAni_IceRoad(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_ICEROAD_CASTING)
	{
		if(obj.isMyControlObject())
		{
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(SUB_STATE_ICEROAD_0); // substate세팅
			obj.sq_AddSetStatePacket(STATE_ICEROAD, STATE_PRIORITY_IGNORE_FORCE, true);
		}
	}
	else if(substate == SUB_STATE_ICEROAD_0)
	{
		// SUB_STATE_ICEROAD_0 서브스테이트 작업
		if(obj.isMyControlObject())
		{
			obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
		}
	}
	else if(substate == SUB_STATE_ICEROAD_1) {
		// SUB_STATE_ICEROAD_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_2) {
		// SUB_STATE_ICEROAD_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_3) {
		// SUB_STATE_ICEROAD_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_4) {
		// SUB_STATE_ICEROAD_4 서브스테이트 작업
	}
	

}

function onKeyFrameFlag_IceRoad(obj, flagIndex)
{

	if(!obj) return false;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_ICEROAD_0) {
		// SUB_STATE_ICEROAD_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_1) {
		// SUB_STATE_ICEROAD_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_2) {
		// SUB_STATE_ICEROAD_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_3) {
		// SUB_STATE_ICEROAD_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_4) {
		// SUB_STATE_ICEROAD_4 서브스테이트 작업
	}
	

	return false;

}

function onEndState_IceRoad(obj, new_state)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_ICEROAD_0) {
		// SUB_STATE_ICEROAD_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_1) {
		// SUB_STATE_ICEROAD_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_2) {
		// SUB_STATE_ICEROAD_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_3) {
		// SUB_STATE_ICEROAD_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_4) {
		// SUB_STATE_ICEROAD_4 서브스테이트 작업
	}
	
	// 스테이트 종료 혹은 취소 되었다면 캐스팅 게이지 없앰
	sq_EndDrawCastGauge(obj);

}

function onAfterSetState_IceRoad(obj, state, datas, isResetTimer)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_ICEROAD_0) {
		// SUB_STATE_ICEROAD_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_1) {
		// SUB_STATE_ICEROAD_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_2) {
		// SUB_STATE_ICEROAD_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_3) {
		// SUB_STATE_ICEROAD_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICEROAD_4) {
		// SUB_STATE_ICEROAD_4 서브스테이트 작업
	}
	

}
