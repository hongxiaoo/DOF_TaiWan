
SUB_STATE_DARK_CHANGE_READY	<- 0
SUB_STATE_DARK_CHANGE_START	<- 1


function sendSubState_DarkChange(obj,subState)
{
	if(!obj) return;
	
	if(obj.isMyControlObject()) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(subState); // substate세팅
		obj.sq_AddSetStatePacket(STATE_DARK_CHANGE, STATE_PRIORITY_USER, true);
	}
}

function checkExecutableSkill_DarkChange(obj)
{
	if(!obj) return false;

	local b_useskill = obj.sq_IsUseSkill(SKILL_DARK_CHANGE);
	if(b_useskill) {
		sendSubState_DarkChange(obj,SUB_STATE_DARK_CHANGE_READY);		
		return true;
	}		
	return false;
}

function checkCommandEnable_DarkChange(obj)
{
	if(!obj) return false;

	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK)
	{
		return obj.sq_IsCommandEnable(SKILL_DARK_CHANGE); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_BROKENARROW);
	}
	

	return true;
}

function onSetState_DarkChange(obj, state, datas, isResetTimer)
{
	if(!obj) return;

	obj.sq_StopMove();
	local sq_var = obj.getVar();
	local skill_level	= sq_GetSkillLevel(obj, SKILL_DARK_CHANGE);
	local substate		= obj.sq_GetVectorData(datas, 0);
	obj.setSkillSubState(substate);

	if(substate == SUB_STATE_DARK_CHANGE_READY) {
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_DARK_CHANGE_READY);
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_INFO_DARK_CHANGE);		
		
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_DARK_CHANGE , STATE_DARK_CHANGE, 0, 1.0);
		obj.sq_SetCurrentAttackBonusRate(damage);
		sq_var.setBool(0,false); // 변수 : 싸이즈 변화가 있었는지 유무				
		
		// 캐스팅 속도를 따라가도록 설정
		// 캐스팅 속도가 변경되면, 에니메이션 속도도 변경 됩니다.
		// 캐스팅 게이지도 표시를 해줍니다.
		local skillLevel = sq_GetSkillLevel(obj, SKILL_DARK_CHANGE);
		local castTime  = sq_GetCastTime(obj, SKILL_DARK_CHANGE, skillLevel);
		local animation = sq_GetCurrentAnimation(obj);
		local castAniTime = sq_GetFrameStartTime(animation, 5);
		local speedRate = castAniTime.tofloat() / castTime.tofloat();
		
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
			SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, speedRate, speedRate);

		sq_StartDrawCastGauge(obj, castAniTime, true);
		obj.sq_PlaySound("MW_DCHANGE");
	}
	else if(substate == SUB_STATE_DARK_CHANGE_START) {
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_DARK_CHANGE_START);
		sq_flashScreen(obj,0,0,800,150, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
		
		local dark_range = sq_GetLevelData(obj, SKILL_DARK_CHANGE, 1, skill_level);
		dark_range = dark_range * 0.01;
		
		local ani = sq_GetCurrentAnimation(obj);			
		if(ani){			
			sq_var.setBool(0,true);
			sq_var.setFloat(1,dark_range);
			ani.setAttackBoundingBoxSizeRate(dark_range,false);
		}
		
		// pvp가 아니면 가시 화면 전체에 암흑이 걸린다.
		if(!sq_isPVPMode() && obj.isMyControlObject()) { 
			obj.callBackAllObject(obj,0,OBJECTTYPE_ACTIVE);			
		}
		sq_EndDrawCastGauge(obj);
		addElementalChain_ATMage(obj, ENUM_ELEMENT_DARK);
	}
}

function onAllCallBack_DarkChange(parentObj, obj, callBackIndex)
{		
	if(!obj)
		return true;
		
	printc("onAllCallBack_DarkChange");
	local ao = sq_GetCNRDObjectToActiveObject(obj);

	if(ao && sq_IsInScreenCollisionObject(obj,true) && parentObj.isEnemy(ao) ) {		
		// 0.공격력%  1.암전범위% 2.암흑 레벨 3.암흑 확률 4.암흑 지속시간		
		local skill_level	= sq_GetSkillLevel(parentObj, SKILL_DARK_CHANGE);	
		local dark_power	= sq_GetLevelData(parentObj, SKILL_DARK_CHANGE, 2, skill_level);	
		local dark_prob		= sq_GetLevelData(parentObj, SKILL_DARK_CHANGE, 3, skill_level);
		local dark_time		= sq_GetLevelData(parentObj, SKILL_DARK_CHANGE, 4, skill_level);
		
		sq_sendSetActiveStatusPacket(obj, parentObj, ACTIVESTATUS_BLIND, dark_prob.tofloat(), dark_power.tointeger(), false, dark_time.tointeger());
	}	
	return true;
}

function onEndState_DarkChange(obj, newState)
{
	if(!obj) return;
	local sq_var = obj.getVar();	
	
	if(newState != STATE_DARK_CHANGE) {
		local isResized = sq_var.getBool(0);
				
		if(isResized) {
			local ani = sq_GetCurrentAnimation(obj);		
			if(ani){
				local dark_range = sq_var.getFloat(1);
				ani.setAttackBoundingBoxSizeRate(1.0/dark_range,false);					
			}
		}
	}
}



function onEndCurrentAni_DarkChange(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_DARK_CHANGE_READY) {
		sendSubState_DarkChange(obj,SUB_STATE_DARK_CHANGE_START);
	}
	else if(substate == SUB_STATE_DARK_CHANGE_START) {
		obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	}
	

}

function onAttack_DarkChange(obj, damager, boundingBox, isStuck)
{
	if (!obj) return;
	
	local attackInfo = sq_GetCurrentAttackInfo(obj);
	
	if (!attackInfo) return;
	
	if(sq_isPVPMode()) { // pvp에선 맞은 애들만 암흑에 걸린다.
		// 0.공격력%  1.암전범위% 2.암흑 레벨 3.암흑 확률 4.암흑 지속시간		
		local skill_level	= sq_GetSkillLevel(obj, SKILL_DARK_CHANGE);	
		local dark_power	= sq_GetLevelData(obj, SKILL_DARK_CHANGE, 2, skill_level);	
		local dark_prob		= sq_GetLevelData(obj, SKILL_DARK_CHANGE, 3, skill_level);
		local dark_time		= sq_GetLevelData(obj, SKILL_DARK_CHANGE, 4, skill_level);
		
		sq_SetChangeStatusIntoAttackInfo(attackInfo, 0, ACTIVESTATUS_BLIND, dark_prob, dark_power, dark_time);
	}
}


function onKeyFrameFlag_DarkChange(obj, flagIndex)
{
	if(!obj) return true;
	
	local angle = 0;
	if(flagIndex == 1) {
		sq_SetMyShake(obj,2,160);	
	}
	return true;
}