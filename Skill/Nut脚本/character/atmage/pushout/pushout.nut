ENUM_AMP_SUBSTATE_GRAB <-0 ;	// 잡기
ENUM_AMP_SUBSTATE_PUSH <-1 ;	// 밀기
ENUM_AMP_SUBSTATE_RELEASE <-2;	// 해제

VAR_AMP_IS_GRAB				 <-0 //잡은 몹이 있는지 체크
VAR_AMP_HOLD_REALSE			 <-1 //잡은거 해제
VAR_AMP_HOLD_REALSE_COMPLETE <-2 //해제 완료


function checkExecutableSkill_PushOut(obj)
{
	if(!obj) return false;

	local b_useskill = obj.sq_IsUseSkill(SKILL_PUSH_OUT);
	
	if(b_useskill) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(ENUM_AMP_SUBSTATE_GRAB); // substate세팅		
		obj.sq_AddSetStatePacket(STATE_PUSH_OUT , STATE_PRIORITY_USER, true);
		return true;
	}	
	return false;

}

function checkCommandEnable_PushOut(obj)
{
	if(!obj)
		return false;

	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK) {
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_PUSH_OUT); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_PUSH_OUT);
	}
	
	return true;
}

function onEndState_PushOut(obj, newState)
{
	if(newState != STATE_PUSH_OUT)
	{
		removeAllPushOutAppendage(obj,true);
	}
	return 0;
}

function onProc_PushOut(obj)
{
	if(!obj)
		return;
	local var = obj.getVar();  		
	local objectsSize = var.get_obj_vector_size();
	
	for(local i=0;i<objectsSize;++i)
	{
		local damager = var.get_obj_vector(i);
		if(damager)
		{
			local currentAni	  = obj.getCurrentAnimation();
			local currentAniIndex = currentAni.GetCurrentFrameIndex();
			local z = obj.getZPos() + 50 - damager.getObjectHeight()/2;	
			
			if(z < 0)
				z = 0;			
			
			if(obj.isCurrentCutomAniIndex(CUSTOM_ANI_PUSH_OUT_GRAB)) { // 잡기 애니 상태일땐 모은다.					
				if(currentAniIndex > 0) {
					local x = sq_GetDistancePos(obj.getXPos(), obj.getDirection(), 86);			
					damager.setCurrentPos(x, obj.getYPos()-1, z);
				}
			}
			else if(obj.isCurrentCutomAniIndex(CUSTOM_ANI_PUSH_OUT)) {						
				local x = 46;		
				if(currentAniIndex == 0) {
					x = -10;
				}
				if(currentAniIndex == 1) {
					x = -20;
				}
				
				x = sq_GetDistancePos(obj.getXPos(), obj.getDirection(), x);		
				damager.setCurrentPos(x, obj.getYPos()-1, z);				
			}			
		}			
	}
}

function onSetState_PushOut(obj, state, datas, isResetTimer)
{
	if(!obj) return;
	
	local subState = sq_GetVectorData(datas, 0);
	local var = obj.getVar(); 
	obj.setSkillSubState(subState);		
	
	if(subState == ENUM_AMP_SUBSTATE_GRAB) {
			
		//변수 초기화		
		var.setBool(VAR_AMP_IS_GRAB,false);
		var.setBool(VAR_AMP_HOLD_REALSE,false);
		var.setBool(VAR_AMP_HOLD_REALSE_COMPLETE,false);
		
		obj.sq_StopMove();
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_PUSH_OUT_GRAB);	
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_INFO_PUSH_OUT_GRAB);
		// 컨버전 스킬을 적용한다.
		obj.sq_SetApplyConversionSkill();
	}
	else if(subState == ENUM_AMP_SUBSTATE_PUSH) {
		local group = sq_GetVectorData(datas, 1);
		local uniqueId = sq_GetVectorData(datas, 2);
		local damager = sq_GetObject(obj, group, uniqueId);
		if (damager)
		{
			if(CNSquirrelAppendage.sq_IsAppendAppendage(damager,"Character/ATMage/PushOut/ap_PushOut.nut")) {
				sq_RemoveAppendage(damager,"Character/ATMage/PushOut/ap_PushOut.nut");
			}
		     
			local masterAppendage = CNSquirrelAppendage.sq_AppendAppendage(damager, obj, SKILL_PUSH_OUT, true, "Character/ATMage/PushOut/ap_PushOut.nut", true);
			if(masterAppendage) {																	
				var.push_obj_vector(damager);
			}
		}

		obj.sq_SetCurrentAnimation(CUSTOM_ANI_PUSH_OUT);
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_INFO_PUSH_OUT);
		// 컨버전 스킬을 적용한다.
		obj.sq_SetApplyConversionSkill();
		
		local level				 = sq_GetSkillLevel(obj, SKILL_PUSH_OUT);		
		local pushingAttackPower = obj.sq_GetBonusRateWithPassive(SKILL_PUSH_OUT , STATE_PUSH_OUT, 0, 1.0);// 밀어내는 공격력
		local attackInfo		 = sq_GetCurrentAttackInfo(obj);		
		local pushingPower		 = sq_GetLevelData(obj, SKILL_PUSH_OUT, 1, level); // 밀어내는 힘.	
		sq_SetCurrentAttacknBackForce(attackInfo,pushingPower);	
		sq_SetCurrentAttackBonusRate(attackInfo,pushingAttackPower);
	}
	else if(subState == ENUM_AMP_SUBSTATE_RELEASE) {
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_PUSH_OUT_ATTACK);		
	}
		
	if(subState != ENUM_AMP_SUBSTATE_GRAB) 
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED, SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
}

function onTimeEvent_PushOut(obj, timeEventIndex, timeEventCount)
{	
	return false;	
} 

function removeAllPushOutAppendage(obj,isListClear)
{
	if(!obj)
		return;

	local var = obj.getVar();  		
	local objectsSize = var.get_obj_vector_size();
	
	for(local i=0;i<objectsSize;++i)
	{
		local damager = var.get_obj_vector(i);
		if(damager)
			CNSquirrelAppendage.sq_RemoveAppendage(damager, "Character/ATMage/PushOut/ap_PushOut.nut");		
	}		
	
	if(isListClear) {
		var.clear_obj_vector();
		var.setBool(VAR_AMP_HOLD_REALSE_COMPLETE,true);
	}
}

function onEndCurrentAni_PushOut(obj)
{
	if(!obj || !obj.isMyControlObject()) return;
	
	local subState = obj.getSkillSubState();	
	if(subState == ENUM_AMP_SUBSTATE_GRAB)	{
		local var = obj.getVar();  		
		local objectsSize = var.get_obj_vector_size();
		if(objectsSize <= 0) {
			obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
		}
		else {
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(ENUM_AMP_SUBSTATE_PUSH); // substate세팅	
			obj.sq_AddSetStatePacket(STATE_PUSH_OUT , STATE_PRIORITY_USER, true);		
		}
	}
	else if(subState == ENUM_AMP_SUBSTATE_PUSH)
	{
		local var = obj.getVar();
		var.setBool(VAR_AMP_HOLD_REALSE,true);
		
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(ENUM_AMP_SUBSTATE_RELEASE); // substate세팅	
		obj.sq_AddSetStatePacket(STATE_PUSH_OUT , STATE_PRIORITY_USER, true);	
	}
	else if(subState == ENUM_AMP_SUBSTATE_RELEASE) 
	{
		obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	}
}

// onAttack 콜백함수 입니다
function onAttack_PushOut(obj, damager, boundingBox, isStuck)
{
	if(!obj)
		return 0;

	local var = obj.getVar();
	if(var.getBool(VAR_AMP_IS_GRAB))
		return 0;	
	
	local subState = obj.getSkillSubState();	
	
	if(subState == ENUM_AMP_SUBSTATE_GRAB)	{		
		if(damager.getState() != STATE_HOLD 
		     && sq_IsGrabable(obj,damager) 
		     && sq_IsHoldable(obj,damager) 
		     && !sq_IsFixture(damager)) {

			var.setBool(VAR_AMP_IS_GRAB,true);
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(ENUM_AMP_SUBSTATE_PUSH); // substate세팅
			obj.sq_IntVectPush(sq_GetGroup(damager));
			obj.sq_IntVectPush(sq_GetUniqueId(damager));
			obj.sq_AddSetStatePacket(STATE_PUSH_OUT , STATE_PRIORITY_USER, true);
		}		
	}
}

function onKeyFrameFlag_PushOut(obj, flagIndex)
{
	if(!obj) return true;
	
	if(flagIndex == 1) {
		local var = obj.getVar();		
				// 잡고 있는 애들 해제		
		removeAllPushOutAppendage(obj,false);		
		
		// 데미지 처리
		local objectsSize = var.get_obj_vector_size();
		
		for(local i=0;i<objectsSize;++i)
		{
			local damager = var.get_obj_vector(i);
			local x = sq_GetDistancePos(obj.getXPos(), obj.getDirection(), 44);	
			local z = obj.getZPos() + 50 - damager.getObjectHeight()/2;				
			if(z < 0)
				z = 0;

			local y = obj.getYPos();
			x = damager.sq_findNearLinearMovableXPos(x, y, obj.getXPos(), y, 10);
			damager.setCurrentPos(x, y, z);
			if(damager && damager.isMyControlObject())
				sq_SendHitObjectPacketWithNoStuck(obj,damager,0,0,0);	
				
			if(!CNSquirrelAppendage.sq_IsAppendAppendage(damager,"Character/ATMage/PushOut/ap_PushOutExplosion.nut")) {
				local masterAppendage = CNSquirrelAppendage.sq_AppendAppendage(damager, obj, SKILL_PUSH_OUT, true, "Character/ATMage/PushOut/ap_PushOutExplosion.nut", true);				
				if(masterAppendage)
				{
					sq_HoldAndDelayDie(damager, obj, false, true, false, 0, 0, ENUM_DIRECTION_NEUTRAL , masterAppendage);	
				}
			}
				
		}
		
		removeAllPushOutAppendage(obj,true);	
	}
	return true;
}
