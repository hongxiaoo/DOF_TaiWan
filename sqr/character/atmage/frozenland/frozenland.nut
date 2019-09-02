
SUB_STATE_FROZENLAND_0	<- 0
SUB_STATE_FROZENLAND_1	<- 1
SUB_STATE_FROZENLAND_2	<- 2
SUB_STATE_FROZENLAND_3	<- 3
SUB_STATE_FROZENLAND_4	<- 4
SUB_STATE_FROZENLAND_CASTING	<- 5

function createShockWaveAnimation(obj, x, y, z)
{
	local ani = sq_CreateAnimation("", "PassiveObject/Character/Mage/Animation/ATFrozenLand/sub_dodge.ani");
	
	local shockWaveObj = sq_CreatePooledObject(ani,true);
	shockWaveObj = sq_SetEnumDrawLayer(shockWaveObj, ENUM_DRAWLAYER_BOTTOM);
	
	if(shockWaveObj)
	{
		shockWaveObj.setCurrentPos(x,y,z);
		sq_AddObject(obj, shockWaveObj, OBJECTTYPE_DRAWONLY, false);
	}
}


function checkExecutableSkill_FrozenLand(obj)
{

	if(!obj) return false;

	local b_useskill = obj.sq_IsUseSkill(SKILL_FROZENLAND);

	if(b_useskill) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_FROZENLAND_CASTING); // substate세팅
		obj.sq_AddSetStatePacket(STATE_FROZENLAND, STATE_PRIORITY_IGNORE_FORCE, true);
		return true;
	}	
	
	return false;

}

function checkCommandEnable_FrozenLand(obj)
{

	if(!obj) return false;

	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK)
	{
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_FROZENLAND); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_FROZENLAND);
	}
	

	return true;

}

function onSetState_FrozenLand(obj, state, datas, isResetTimer)
{

	if(!obj) return;

	local substate = obj.sq_GetVectorData(datas, 0);
	obj.setSkillSubState(substate);
	obj.sq_StopMove();

	obj.getVar().clear_vector();
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	
	obj.getVar("state").clear_ct_vector();
	obj.getVar("state").push_ct_vector();	
	
	
	if(substate == SUB_STATE_FROZENLAND_CASTING)
	{
		// 캐스팅 속도를 따라가도록 설정
		// 캐스팅 속도가 변경되면, 에니메이션 속도도 변경 됩니다.
		// 캐스팅 게이지도 표시를 해줍니다.
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_FROZENLAND_CASTING);
		
		local skillLevel = sq_GetSkillLevel(obj, SKILL_FROZENLAND);
		local castTime = sq_GetCastTime(obj, SKILL_FROZENLAND, skillLevel);
		local animation = sq_GetCurrentAnimation(obj);
		local startTime = sq_GetFrameStartTime(animation, 16);
		local speedRate = startTime.tofloat() / castTime.tofloat();
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
			SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, speedRate, speedRate);

		sq_StartDrawCastGauge(obj, startTime, true);
		obj.sq_PlaySound("MW_SLASHWATER");
	}
	else if(substate == SUB_STATE_FROZENLAND_0) {
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_FROZENLAND1);
		
	}
	else if(substate == SUB_STATE_FROZENLAND_1) {
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_FROZENLAND2);
	}
	else if(substate == SUB_STATE_FROZENLAND_2) {
		local t = obj.getVar("state").get_ct_vector(0);
		t.Reset();
		t.Start(10000,0);
		//obj.sq_SetCurrentAnimation(CUSTOM_ANI_FROZENLAND3);
	}
	else if(substate == SUB_STATE_FROZENLAND_3)
	{
		//print(" obj.sq_SetCurrentAnimation(CUSTOM_ANI_FROZENLAND3);");
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_FROZENLAND3);
	}
	else if(substate == SUB_STATE_FROZENLAND_4) {
		// SUB_STATE_FROZENLAND_4 서브스테이트 작업
	}
	
	//obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
	//		SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
}

function prepareDraw_FrozenLand(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_FROZENLAND_0) {
		// SUB_STATE_FROZENLAND_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_1) {
		// SUB_STATE_FROZENLAND_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_2) {
		// SUB_STATE_FROZENLAND_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_3) {
		// SUB_STATE_FROZENLAND_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_4) {
		// SUB_STATE_FROZENLAND_4 서브스테이트 작업
	}
	

}

function onProc_FrozenLand(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	local pAni = obj.sq_GetCurrentAni();
	local frmIndex = obj.sq_GetCurrentFrameIndex(pAni);
	local currentT = sq_GetCurrentTime(pAni);

	if(substate == SUB_STATE_FROZENLAND_0) {
		// SUB_STATE_FROZENLAND_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_1) {
		// SUB_STATE_FROZENLAND_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_2) {
		// SUB_STATE_FROZENLAND_2 서브스테이트 작업

		local t = obj.getVar("state").get_ct_vector(0);
		local currentT = 0;
		
		currentT = t.Get();
			
		//print(" currentT:" + currentT);
			
		if(currentT > 240)
		{		
			if(!obj.getVar().get_vector(1))
			{
				//obj.sq_SetCurrentAnimation(CUSTOM_ANI_FROZENLAND3);
				if(obj.isMyControlObject())
				{
					obj.sq_IntVectClear();
					obj.sq_IntVectPush(SUB_STATE_FROZENLAND_3); // substate세팅
					obj.sq_AddSetStatePacket(STATE_FROZENLAND, STATE_PRIORITY_IGNORE_FORCE, true);
				}
				
				obj.getVar().set_vector(1, 1);
			}
		}

	}
	else if(substate == SUB_STATE_FROZENLAND_3) {
		// SUB_STATE_FROZENLAND_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_4) {
		// SUB_STATE_FROZENLAND_4 서브스테이트 작업
	}
	

}

function onProcCon_FrozenLand(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	local pAni = obj.sq_GetCurrentAni();
	local frmIndex = obj.sq_GetCurrentFrameIndex(pAni);
	
	if(substate == SUB_STATE_FROZENLAND_0) {
		if(frmIndex >= 4) {	
			if(obj.getVar().get_vector(0) == 0) 
			{			
				if(obj.isMyControlObject())
				{
					local radiusRate = obj.sq_GetIntData(SKILL_FROZENLAND, 0);// 0. 시전범위 (마법진 지름 비율 : 100%~)
					local stopSpinNum = obj.sq_GetIntData(SKILL_FROZENLAND, 2); // 2. 기둥이 나타나서 제자리에서 스핀을 도는 수
					local spinTime = obj.sq_GetIntData(SKILL_FROZENLAND, 3); // 3. 소용돌이 쳐서 가운데로 들어오는 시간
					
					sq_BinaryStartWrite();
					sq_BinaryWriteDword(radiusRate); // 시전범위 (마법진 지름 비율 : 100%~)
					sq_BinaryWriteDword(stopSpinNum); // 기둥이 나타나서 제자리에서 스핀을 도는 수
					sq_BinaryWriteDword(spinTime); // 소용돌이 쳐서 가운데로 들어오는 시간
					
					local multiHitTerm = obj.sq_GetIntData(SKILL_FROZENLAND, 1); // 1. 기둥 다단히트 간격 (0.001초 단위)
					local multiHitAttackRate = obj.sq_GetBonusRateWithPassive(SKILL_FROZENLAND, STATE_FROZENLAND, 0, 1.0); //0.기둥 다단히트 공격력(%)
					local expAttackRate = obj.sq_GetBonusRateWithPassive(SKILL_FROZENLAND, STATE_FROZENLAND, 1, 1.0); // 1.기둥 폭발 공격력(%)
					 obj.sq_GetLevelData(SKILL_FROZENLAND, 1, obj.sq_GetSkillLevel(SKILL_FROZENLAND));

					// 2.빙결 확율 3.빙결 레벨 4.빙결 시간
					local skillLevel = obj.sq_GetSkillLevel(SKILL_FROZENLAND);
					local frozenRate = obj.sq_GetLevelData(SKILL_FROZENLAND, 2, skillLevel); // 2.빙결 확율
					local frozenLevel = obj.sq_GetLevelData(SKILL_FROZENLAND, 3, skillLevel); // 3.빙결 레벨
					local frozenTime = obj.sq_GetLevelData(SKILL_FROZENLAND, 4, skillLevel); // 4.빙결 시간
					
					sq_BinaryWriteDword(multiHitTerm); // 기둥 다단히트 간격
					sq_BinaryWriteDword(multiHitAttackRate); // 기둥 다단히트 공격력 (%)
					sq_BinaryWriteDword(expAttackRate); // 기둥 폭발 공격력 (%)
					sq_BinaryWriteDword(frozenRate); // 빙결 확율
					sq_BinaryWriteDword(frozenLevel); // 빙결 레벨
					sq_BinaryWriteDword(frozenTime); // 빙결 시간
					
					// 크로니클 아이템 추가 작업
					// 크로니클 아이템 추가 작업 제자리에서 돌고있는 시간이 0보다 크다면 주위를 선회하는 state로 변경해야 합니다.
					local spinAddTime = obj.sq_GetIntData(SKILL_FROZENLAND, 4); // 4. 소용돌이가 캐릭터 주변을 회전하는 시간 (0.001초단위)
					sq_BinaryWriteDword(spinAddTime); // 소용돌이가 캐릭터 주변을 회전하는 시간 (0.001초단위)
					
					
					obj.sq_SendCreatePassiveObjectPacket(24247, 0, 10, -1, 0); // 남법사 - 얼어붙은 대지 (마법진)
				}

				obj.getVar().set_vector(0, 1);
			}
		}
	}
	else if(substate == SUB_STATE_FROZENLAND_1) {
		
		local magicCirclePassiveObj = obj.sq_GetPassiveObject(24247); // po_ATFrozenLandMagicCircle
		local stateChange = true;
		
		if(magicCirclePassiveObj)
		{			
			local magicCirclePassiveState = magicCirclePassiveObj.getState();
			
			if(magicCirclePassiveState == S_PO_FROZENLAND_MC_3)
			{
				stateChange = true;
			}
			else
			{
				stateChange = false;
			}
		}
		
		if(stateChange)
		{
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(SUB_STATE_FROZENLAND_2); // substate세팅
			obj.sq_AddSetStatePacket(STATE_FROZENLAND, STATE_PRIORITY_IGNORE_FORCE, true);
		}
		
	}
	else if(substate == SUB_STATE_FROZENLAND_2) {
		// SUB_STATE_FROZENLAND_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_3) {
		// SUB_STATE_FROZENLAND_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_4) {
		// SUB_STATE_FROZENLAND_4 서브스테이트 작업
	}
	

}

function onEndCurrentAni_FrozenLand(obj)
{

	if(!obj) return;

	if(!obj.isMyControlObject()) {
		return;
	}
	
	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_FROZENLAND_CASTING)
	{
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_FROZENLAND_0); // substate세팅
		obj.sq_AddSetStatePacket(STATE_FROZENLAND, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == SUB_STATE_FROZENLAND_0) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_FROZENLAND_1); // substate세팅
		obj.sq_AddSetStatePacket(STATE_FROZENLAND, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == SUB_STATE_FROZENLAND_1) {
	}
	else if(substate == SUB_STATE_FROZENLAND_2) {
	}
	else if(substate == SUB_STATE_FROZENLAND_3) {
		obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	}
	else if(substate == SUB_STATE_FROZENLAND_4) {
		// SUB_STATE_FROZENLAND_4 서브스테이트 작업
	}
	

}

function onKeyFrameFlag_FrozenLand(obj, flagIndex)
{

	if(!obj) return false;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_FROZENLAND_0) {
		// SUB_STATE_FROZENLAND_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_1) {
		// SUB_STATE_FROZENLAND_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_2) {
		// SUB_STATE_FROZENLAND_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_3) {
		// SUB_STATE_FROZENLAND_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_4) {
		// SUB_STATE_FROZENLAND_4 서브스테이트 작업
	}
	

	return false;

}

function onEndState_FrozenLand(obj, new_state)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_FROZENLAND_0) {
		// SUB_STATE_FROZENLAND_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_1) {
		// SUB_STATE_FROZENLAND_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_2) {
		// SUB_STATE_FROZENLAND_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_3) {
		// SUB_STATE_FROZENLAND_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_4) {
		// SUB_STATE_FROZENLAND_4 서브스테이트 작업
	}
	
	// 스테이트 종료 혹은 취소 되었다면 캐스팅 게이지 없앰
	sq_EndDrawCastGauge(obj);
	
	

}

function onAfterSetState_FrozenLand(obj, state, datas, isResetTimer)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_FROZENLAND_0) {
		// SUB_STATE_FROZENLAND_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_1) {
		// SUB_STATE_FROZENLAND_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_2) {
		// SUB_STATE_FROZENLAND_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_3) {
		// SUB_STATE_FROZENLAND_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FROZENLAND_4) {
		// SUB_STATE_FROZENLAND_4 서브스테이트 작업
	}
	

}
