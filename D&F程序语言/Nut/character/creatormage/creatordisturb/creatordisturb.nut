
SUB_STATE_CREATORDISTURB_0	<- 0

function checkExecutableSkill_CreatorDisturb(obj)
{
	if(!obj) return false;

	// 같은 계통속성인데 한번 더 누르면 일반공격으로 전환됩니다.
	local type = getCreatorSkillStateSkillIndex(obj);

	if (type == CREATOR_TYPE_DISTURB)
	{
		setCreatorSkillStateSkillIndex(obj, -1);
		onAllChargeCreatorMageGauge(obj);
		return false;
	}


	local b_useskill = obj.sq_IsUseSkill(SKILL_CREATORDISTURB);

	if (b_useskill)
	{
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_CREATORDISTURB_0); // substate세팅
		obj.sq_AddSetStatePacket(STATE_CREATORDISTURB, STATE_PRIORITY_USER, true);
		return true;
	}
	
	return false;
}

function checkCommandEnable_CreatorDisturb(obj)
{
	if(!obj) return false;
	
	local state = obj.sq_GetState();

	local skill_level = obj.sq_GetSkillLevel(SKILL_CREATORDISTURB);
	if(state == STATE_ATTACK)
	{
		return obj.sq_IsCommandEnable(SKILL_CREATORDISTURB); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_BROKENARROW);
	}
	
	return true;
}

function onSetState_CreatorDisturb(obj,state,datas,isResetTimer)
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
	
	print(" onSetSTATE_CREATORDISTURB");
		
	if (substate == SUB_STATE_CREATORDISTURB_0)
	{
		// 화염속성을 쓴다고 알려줍니다.
		setCreatorSkillStateSkillIndex(obj, CREATOR_TYPE_DISTURB);
		// 모든 크레이터의 속성 충전을 시작합니다.
		onAllChargeCreatorMageGauge(obj);
		// 플레임 속성 충전을 중지합니다.
		setChargeCreatorMageGauge(obj, CREATOR_TYPE_DISTURB, 0);
		
		obj.sq_PlaySound("R_CR_INTERRUPTION");
		
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_CAST_DISTURB);

		// 캐스팅 속도를 따라가도록 설정
		// 캐스팅 속도가 변경되면, 에니메이션 속도도 변경 됩니다.
		// 캐스팅 게이지도 표시를 해줍니다.
		local skillLevel = sq_GetSkillLevel(obj, SKILL_CREATORDISTURB);
		local castTime = sq_GetCastTime(obj, SKILL_CREATORDISTURB, skillLevel);
		local animation = sq_GetCurrentAnimation(obj);
		local startTime = sq_GetDelaySum(animation);
		local speedRate = startTime.tofloat() / castTime.tofloat();
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
		SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, speedRate, speedRate);

		sq_StartDrawCastGauge(obj, startTime, true);


		
	}
}

function prepareDraw_CreatorDisturb(obj)
{

	if(!obj) return;

}

function onProc_CreatorDisturb(obj)
{

	if(!obj) return;

}

function onProcCon_CreatorDisturb(obj)
{

	if(!obj) return;

}

function onEndCurrentAni_CreatorDisturb(obj)
{
	if(!obj) return;
	
	if(!obj.isMyControlObject()) {
		return;
	}
	
	local substate = obj.getSkillSubState();
	
	if (substate == SUB_STATE_CREATORDISTURB_0)
	{
		obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	}

}

function onKeyFrameFlag_CreatorDisturb(obj,flagIndex)
{

	if(!obj) return false;

	return true;

}

function onEndState_CreatorDisturb(obj,new_state)
{
	if(!obj) return;

	sq_EndDrawCastGauge(obj);
}

function onAfterSetState_CreatorDisturb(obj,state,datas,isResetTimer)
{

	if(!obj) return;

}

function onBeforeAttack_CreatorDisturb(obj,damager,boundingBox,isStuck)
{

	if(!obj) return;

}

function onAttack_CreatorDisturb(obj,damager,boundingBox,isStuck)
{

	if(!obj) return;

}

function onAfterAttack_CreatorDisturb(obj,damager,boundingBox,isStuck)
{

	if(!obj) return 0;

	return 1;

}

function onBeforeDamage_CreatorDisturb(obj,attacker,boundingBox,isStuck)
{

	if(!obj) return;

}

function onDamage_CreatorDisturb(obj,attacker,boundingBox)
{

	if(!obj) return;

}

function onAfterDamage_CreatorDisturb(obj,attacker,boundingBox)
{

	if(!obj) return;

}
