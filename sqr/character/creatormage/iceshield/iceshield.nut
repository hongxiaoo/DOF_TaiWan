
SUB_STATE_ICESHIELD_0	<- 0
SUB_STATE_ICESHIELD_1	<- 1

//STATE_ICESHIELD <- 58
//SKILL_ICESHIELD <- 135


function checkExecutableSkill_IceShield(obj)
{
	if (!obj) return false;

	local b_useskill = obj.sq_IsUseSkill(SKILL_ICESHIELD);

	if (b_useskill)
	{
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_ICESHIELD_0); // substate세팅
		obj.sq_AddSetStatePacket(STATE_ICESHIELD, STATE_PRIORITY_USER, true);
		return true;
	}
	
	return false;
}

function checkCommandEnable_IceShield(obj)
{
	if(!obj) return false;
	
	local state = obj.sq_GetState();

	local skill_level = obj.sq_GetSkillLevel(SKILL_ICESHIELD);
	if(state == STATE_ATTACK)
	{
		return obj.sq_IsCommandEnable(SKILL_ICESHIELD); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_BROKENARROW);
	}
	
	return true;
}

function onSetState_IceShield(obj,state,datas,isResetTimer)
{
	if(!obj) return;
	
	local substate = obj.sq_GetVectorData(datas, 0);
	obj.setSkillSubState(substate);

	obj.sq_StopMove();

	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();

	obj.getVar().clear_vector();
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	

	if (substate == SUB_STATE_ICESHIELD_0)
	{
		//setCreatorSkillStateSkillIndex(obj, -1);
		
		local skill_level = obj.sq_GetSkillLevel(SKILL_ICESHIELD);
		
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_ICE_SHIELD);
		
		local speedRate = 1.0;
		
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
			SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, speedRate, speedRate);
			
		obj.getVar("state").clear_ct_vector();
		
		obj.getVar("state").push_ct_vector();
		local t = obj.getVar("state").get_ct_vector(0);
		t.Reset();
		t.Start(100000,0);
		
		
		local multiHitTerm = obj.sq_GetIntData(SKILL_ICESHIELD, 0); // 0.다단히트 간격
			
		obj.sq_timer_.setParameter(multiHitTerm, -1);
		obj.sq_timer_.resetInstant(0);
		
		local skill_level = obj.sq_GetSkillLevel(SKILL_ICESHIELD);
		// 0.유지시간
		local attackTime = obj.sq_GetLevelData(SKILL_ICESHIELD, SKL_LV_0, skill_level);			
			
 		obj.sq_PlaySound("R_CR_ICESHIELD");
	}
	else if (substate == SUB_STATE_ICESHIELD_1)
	{
		
	}
}

function onProc_IceShield(obj)
{

	if(!obj) return;

}

function onProcCon_IceShield(obj)
{

	if(!obj) return;

}

function onEndCurrentAni_IceShield(obj)
{

	if(!obj) return;

	if (!obj.isMyControlObject())
	{
		return;
	}
	
	local substate = obj.getSkillSubState();
	
	//if (substate == SUB_STATE_FIREHURRICANE_0)
	//{
		obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	//}

}

function onKeyFrameFlag_IceShield(obj,flagIndex)
{
	if(!obj) return false;
	
	if (flagIndex == 1)
	{
		obj.sq_PlaySound("BREAKING_RUSH");
		if (obj.sq_IsMyControlObject())
		{
			local skill_level = obj.sq_GetSkillLevel(SKILL_ICESHIELD);
			// 0.유지시간
			local time = obj.sq_GetLevelData(SKILL_ICESHIELD, SKL_LV_0, skill_level);			
			
			obj.sq_StartWrite();
			obj.sq_WriteWord(time);
			obj.sq_SendCreatePassiveObjectPacket(23504, 0, 0, 0, 1);
		}
	}
	
	return true;

}

function onEndState_IceShield(obj,new_state)
{

	if(!obj) return;

}

function onAfterSetState_IceShield(obj,state,datas,isResetTimer)
{

	if(!obj) return;

}

