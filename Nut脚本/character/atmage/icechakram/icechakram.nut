ENUM_ICE_CHAKRAM_TIMER_LARGE_MULTI_HIT <- 0;

SUB_STATE_ICECHAKRAM_0	<- 0
SUB_STATE_ICECHAKRAM_1	<- 1
SUB_STATE_ICECHAKRAM_2	<- 2
SUB_STATE_ICECHAKRAM_3	<- 3
SUB_STATE_ICECHAKRAM_4	<- 4 // 날린 차크람 모으기.
SUB_STATE_ICECHAKRAM_5	<- 5 // 큰 차크람 회전
SUB_STATE_ICECHAKRAM_6	<- 6 // 큰 차크람 던지기

VAR_ICE_CHAKRAM_ATTRACT_APPENDAGE <- 0;

function checkExecutableSkill_IceChakram(obj)
{

	if(!obj) return false;

	local b_useskill = obj.sq_IsUseSkill(SKILL_ICECHAKRAM);

	if(b_useskill) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_ICECHAKRAM_0); // substate세팅				
		//2차 공격 테스트용.
		//obj.sq_IntVectPush(SUB_STATE_ICECHAKRAM_4); // substate세팅
		
		obj.sq_AddSetStatePacket(STATE_ICECHAKRAM, STATE_PRIORITY_IGNORE_FORCE, true);
		return true;
	}	
	
	return false;

}

function checkCommandEnable_IceChakram(obj)
{

	if(!obj) return false;

	local state = obj.sq_GetState();

	if(state == STATE_ATTACK) {
		// 캔슬 스킬 개편 작업자: 정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_ICECHAKRAM);
	}
	return true;

}

function onSetState_IceChakram(obj, state, datas, isResetTimer)
{

	if(!obj) return;

	local substate = obj.sq_GetVectorData(datas, 0);
	obj.setSkillSubState(substate);
	
	obj.getVar().clear_vector();
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	
	obj.getVar("state").clear_ct_vector();
	obj.getVar("state").push_ct_vector();	
	
	obj.getVar("ani").clear_vector();
	obj.getVar("ani").push_vector(0);

	if(substate == SUB_STATE_ICECHAKRAM_0) {
		// SUB_STATE_ICECHAKRAM_0 서브스테이트 작업
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_ICECHAKRAM_1);
		
		
		// 캐스팅 없음.		
	}
	else if(substate == SUB_STATE_ICECHAKRAM_1) {
		// SUB_STATE_ICECHAKRAM_1 서브스테이트 작업
		local t = obj.getVar("state").get_ct_vector(0);
		t.Reset();
		t.Start(10000,0);
		
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_ICECHAKRAM_2);
		
		if(obj.isMyControlObject())
		{
			//5	 // 0. 생성되는 얼음고리 갯수
			//5   // 1. 작은 얼음 고리 다단히트 횟수
			local createSmallRingNum = sq_GetLevelData(obj,	SKILL_ICECHAKRAM, 3, sq_GetSkillLevel(obj, SKILL_ICECHAKRAM)); // 3. 생성되는 얼음고리 갯수
			local multiHitNum = sq_GetLevelData(obj,	SKILL_ICECHAKRAM, 4, sq_GetSkillLevel(obj, SKILL_ICECHAKRAM)); // 4. 작은 얼음 고리 다단히트 횟수		
			local power = obj.sq_GetBonusRateWithPassive(SKILL_ICECHAKRAM, STATE_ICECHAKRAM, 0,1.0);	 // 0.작은 얼음고리 다단히트 공격력(+)
		
			sq_BinaryStartWrite();
			sq_BinaryWriteDword(createSmallRingNum); // 
			sq_BinaryWriteDword(multiHitNum); // 
			sq_BinaryWriteDword(power); // 
			obj.sq_SendCreatePassiveObjectPacket(24257, 0, 0, 0, 0); // 24257	`Character/Mage/ATIceChakramSmallMgr.obj` // 남법사 빙류환 작은빙결 매니져 
		}
		
	}
	else if(substate == SUB_STATE_ICECHAKRAM_2) {
		// SUB_STATE_ICECHAKRAM_2 서브스테이트 작업
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_ICECHAKRAM_3);
		obj.sq_PlaySound("RAGEBLAST_SPIN_01", 7577);
	}
	else if(substate == SUB_STATE_ICECHAKRAM_3) {
		// SUB_STATE_ICECHAKRAM_3 서브스테이트 작업
		local isFindChr = obj.sq_GetVectorData(datas, 1);
		obj.getVar("findchr").clear_vector();
		obj.getVar("findchr").push_vector(isFindChr);
		
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_ICECHAKRAM_4);
	}
	else if(substate == SUB_STATE_ICECHAKRAM_4) {
		// SUB_STATE_ICECHAKRAM_4 서브스테이트 작업
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_ICECHAKRAM_4);
	}	
	else if(substate == SUB_STATE_ICECHAKRAM_5) { // 회전
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_ICECHAKRAM_5);
		sq_SetCurrentAttackInfoFromCustomIndex(obj,CUSTOM_ATTACK_INFO_ICE_CHAKRAM);
		
		sq_SetBodyEffect(obj, obj, true, sq_RGB(255,255,255), 0, 80, 0, sq_ALPHA(255)); // 몸에 하얀 이펙트
		
		sq_SetCurrentAttackeHitStunTime(sq_GetCurrentAttackInfo(obj), 0); // 공격 경직시간 없애기.
				
		// 큰고리 다단 히트 공격력 설정		
		local power = obj.sq_GetBonusRateWithPassive(SKILL_ICECHAKRAM , STATE_ICECHAKRAM, 1, 1.0);		
		obj.sq_SetCurrentAttackBonusRate(power);
		
		// 큰고리 다단 히트 간격 콜백
		local multiHitTimeGab = sq_GetIntData(obj, SKILL_ICECHAKRAM, 4);
		obj.setTimeEvent(ENUM_ICE_CHAKRAM_TIMER_LARGE_MULTI_HIT, multiHitTimeGab , 0, false); // 0이면 무한대
		
		obj.sq_PlaySound("MW_RAGEBLAST_READY");			
		
		local attractPower = sq_GetLevelData(obj, SKILL_ICECHAKRAM, 6, sq_GetSkillLevel(obj, SKILL_ICECHAKRAM));
		if(attractPower > 0)
		{						
			// 끌어당겨질 목적지 타겟, 끌어들이는 힘의 거리 , 타겟으로 부터의 목적지 거리, 끌어당길 속도
			local appendage = sq_AttractToMe(obj, 200, 100, attractPower);
			local var = obj.getVar();
			var.setAppendage(VAR_ICE_CHAKRAM_ATTRACT_APPENDAGE, appendage);
		}
	}
	else if(substate == SUB_STATE_ICECHAKRAM_6) {
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_ICECHAKRAM_6);
	}
	
	

}


function onTimeEvent_IceChakram(obj, timeEventIndex, timeEventCount)
{	
	if(!obj)
		return false;

	if(!obj.isMyControlObject())
		return false;
		
	if(timeEventIndex == ENUM_ICE_CHAKRAM_TIMER_LARGE_MULTI_HIT)
	{	
		obj.resetHitObjectList(); //다단히트를위해 히트오브젝트 리스트를 리셋.
		return false; // false면 계속 콜백 (timeEventCount카운트가 유한이라면 timeEventCount 만큼 콜백)
	}
	
	return true; // true면 콜백 중단
}


function prepareDraw_IceChakram(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_ICECHAKRAM_0) {
		// SUB_STATE_ICECHAKRAM_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_1) {
		// SUB_STATE_ICECHAKRAM_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_2) {
		// SUB_STATE_ICECHAKRAM_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_3) {
		// SUB_STATE_ICECHAKRAM_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_4) {
		// SUB_STATE_ICECHAKRAM_4 서브스테이트 작업
	}
	

}

function onProc_IceChakram(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	local pAni = obj.sq_GetCurrentAni();
	local frmIndex = obj.sq_GetCurrentFrameIndex(pAni);
	local currentT = sq_GetCurrentTime(pAni);

	obj.sq_StopMove();
	if(substate == SUB_STATE_ICECHAKRAM_0) {
		// SUB_STATE_ICECHAKRAM_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_1) {
		// SUB_STATE_ICECHAKRAM_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_2) {
		// SUB_STATE_ICECHAKRAM_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_3) {
		// SUB_STATE_ICECHAKRAM_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_4) {
		// SUB_STATE_ICECHAKRAM_4 서브스테이트 작업
	}
	

}

function onProcCon_IceChakram(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();
	
	local pAni = obj.sq_GetCurrentAni();
	local frmIndex = obj.sq_GetCurrentFrameIndex(pAni);
	
	

	if(substate == SUB_STATE_ICECHAKRAM_0) {
		// SUB_STATE_ICECHAKRAM_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_1)
	{
		local loopTime = 400;
		
		local t = obj.getVar("state").get_ct_vector(0);
		local currentT = 0;
		
		currentT = t.Get();
		
		//print( " currentT:" + currentT + " loopTime:" + loopTime);
			
		if(currentT > loopTime)
		{		
			if(!obj.getVar().get_vector(0))
			{
				obj.sq_IntVectClear();
				obj.sq_IntVectPush(SUB_STATE_ICECHAKRAM_2); // substate세팅
				obj.sq_AddSetStatePacket(STATE_ICECHAKRAM, STATE_PRIORITY_IGNORE_FORCE, true);
				
				obj.getVar().set_vector(0, 1);
			}
		}		
	}
	else if(substate == SUB_STATE_ICECHAKRAM_2)
	{
		if(obj.isMyControlObject())
		{
			if(obj.getVar("ani").get_vector(0))
			{
				local smallRingObj = obj.sq_GetPassiveObject(24258); // po_ATIceChakramSmallIceRing.nut 24258
				
				if(smallRingObj)
				{
					local passiveState = smallRingObj.getState();
					
					if(passiveState == PASSIVEOBJ_SUB_STATE_2)
					{
						local isFindChr = smallRingObj.getVar("findchr").get_vector(0);
						obj.sq_IntVectClear();
						obj.sq_IntVectPush(SUB_STATE_ICECHAKRAM_3); // substate세팅
						obj.sq_IntVectPush(isFindChr); // substate세팅
						obj.sq_AddSetStatePacket(STATE_ICECHAKRAM, STATE_PRIORITY_IGNORE_FORCE, true);
					}
				}
				else
				{
					obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
				}
			}
		}
	}
	else if(substate == SUB_STATE_ICECHAKRAM_3) {
		// SUB_STATE_ICECHAKRAM_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_4) {
		// SUB_STATE_ICECHAKRAM_4 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_6) {
		sq_RemoveParticle("Character/Mage/Effect/Particle/ATIceChakramDust.ptl", obj);	
	}
	

}

function onEndCurrentAni_IceChakram(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_ICECHAKRAM_0) {
		// SUB_STATE_ICECHAKRAM_0 서브스테이트 작업		
		if(obj.isMyControlObject())
		{
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(SUB_STATE_ICECHAKRAM_1); // substate세팅
			obj.sq_AddSetStatePacket(STATE_ICECHAKRAM, STATE_PRIORITY_IGNORE_FORCE, true);
		}
	}
	else if(substate == SUB_STATE_ICECHAKRAM_1) {
	}
	else if(substate == SUB_STATE_ICECHAKRAM_2) {
		obj.getVar("ani").set_vector(0, 1);
	}
	else if(substate == SUB_STATE_ICECHAKRAM_3) {
		// SUB_STATE_ICECHAKRAM_3 서브스테이트 작업
		if(obj.isMyControlObject())
		{
			if(obj.getVar("findchr").get_vector(0))
			{
				obj.sq_IntVectClear();
				obj.sq_IntVectPush(SUB_STATE_ICECHAKRAM_5); // substate세팅
				obj.sq_AddSetStatePacket(STATE_ICECHAKRAM, STATE_PRIORITY_IGNORE_FORCE, true);
			}
			else
				obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
		}
	}
	else if(substate == SUB_STATE_ICECHAKRAM_4) {
		// 날아온 차크람을 모으는 동작
		obj.sendStatePacket(STATE_ICECHAKRAM, SUB_STATE_ICECHAKRAM_5);		
	}
	else if(substate == SUB_STATE_ICECHAKRAM_5) {
		// 큰 차크람 회전 시키는 동작
		obj.sendStatePacket(STATE_ICECHAKRAM, SUB_STATE_ICECHAKRAM_6);		

	}
	else if(substate == SUB_STATE_ICECHAKRAM_6) {
		// 큰 차크람 회전 시키는 동작
		obj.sendStateOnlyPacket(STATE_STAND);
	}

}

function onKeyFrameFlag_IceChakram(obj, flagIndex)
{

	if(!obj) return true;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_ICECHAKRAM_0) {
		// SUB_STATE_ICECHAKRAM_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_1) {
		// SUB_STATE_ICECHAKRAM_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_2) {
		// SUB_STATE_ICECHAKRAM_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_3) {
		// SUB_STATE_ICECHAKRAM_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_4) {
		// SUB_STATE_ICECHAKRAM_4 서브스테이트 작업

	}
	else if(substate == SUB_STATE_ICECHAKRAM_5) {		
		if(flagIndex == 1)
		{
			obj.sq_PlaySound("RAGEBLAST_THROW_LOOP",3711);	
			
			sq_SetMyShake(obj,2,100);		
			sq_CreateParticle("Character/Mage/Effect/Particle/ATIceChakramDust.ptl",obj,60, -60,0,true,350,1000,100);			
			sq_CreateParticle("Character/Mage/Effect/Particle/ATIceChakramDust_1.ptl",obj,-10,-10,0,true,350,1000,100);
		}
	}
	else if(substate == SUB_STATE_ICECHAKRAM_6) {		
		if(flagIndex == 1)
		{
			local createXDis = 30;
			local createYDis = 1;
			local createZDis = 58;						
			local searchAngleH = 30;
			local searchAngleV = 15;
			local distance = 1000;
			local angle = 20;
			
			local x = sq_GetDistancePos(obj.getXPos(), sq_GetDirection(obj), createXDis);
			local y = sq_GetDistancePos(obj.getYPos(), ENUM_DIRECTION_DOWN, createYDis);
			local z = sq_GetDistancePos(obj.getZPos(), ENUM_DIRECTION_UP, createZDis);
			
			local x_range = obj.sq_GetIntData(SKILL_ICECHAKRAM , 3); // x축 최대 범위
			local y_range = 200; //
			local z_range = 100; //
		
			printc("x_range " + x_range);
			local activeObject = getPriorityTarget(obj, 0, x_range, y_range, z_range, null, true);
			printc("activeObject " + activeObject);
						
			local maxDistance = activeObject ? abs(activeObject.getXPos() - x) : obj.sq_GetIntData(SKILL_ICECHAKRAM , 3);;
			local horizonAngle = activeObject ? sq_GetShootingHorizonAngle(activeObject, y, 0, searchAngleH, maxDistance) : 0.0 ;
			local verticalAngle = activeObject ? sq_GetShootingVerticalAngle(activeObject, z, 0, searchAngleV, maxDistance, 300) : 0.0;
			local moveSpeed = obj.sq_GetIntData(SKILL_ICECHAKRAM , 5);			
												
			sq_BinaryStartWrite();
			sq_BinaryWriteFloat(horizonAngle);  // 이동 각도 수평
			sq_BinaryWriteFloat(verticalAngle); // 이동 각도 수직
			sq_BinaryWriteDword(moveSpeed);		// 이동 속도
			sq_BinaryWriteDword(maxDistance);	// 이동 거리
			sq_BinaryWriteDword(sq_GetGroup(activeObject));	// 타겟 정보
			sq_BinaryWriteDword(sq_GetUniqueId(activeObject));	// 타겟 정보
			
			obj.sq_SendCreatePassiveObjectPacket(24234, 0, createXDis, createYDis, createZDis);			
			
			local attractPower = sq_GetLevelData(obj, SKILL_ICECHAKRAM, 6, sq_GetSkillLevel(obj, SKILL_ICECHAKRAM));
			if(attractPower > 0)
			{				
				local var = obj.getVar();
				local appendage = var.getAppendage(VAR_ICE_CHAKRAM_ATTRACT_APPENDAGE);
				if(appendage)
					appendage.setValid(false);			
			}
			
			obj.stopSound(3711);
		}
	}
		
	return true;

}

function onEndState_IceChakram(obj, new_state)
{
	if(!obj)
		return;
	
	obj.stopSound(7577);
	
	if (new_state != STATE_STAND)
	{
		local var = obj.getVar();
		local appendage = var.getAppendage(VAR_ICE_CHAKRAM_ATTRACT_APPENDAGE);
		if (appendage)
			appendage.setValid(false);
	}
	
	// 데미지,상태이상 등으로 아이스 차크람이 끝났다.
	if(new_state != STATE_ICECHAKRAM)
	{
		obj.stopSound(3711);
		// 파티클 제거.
		sq_RemoveParticle("Character/Mage/Effect/Particle/ATIceChakramDust.ptl", obj);
		sq_RemoveParticle("Character/Mage/Effect/Particle/ATIceChakramDust_1.ptl", obj);
	}	
}

function onAfterSetState_IceChakram(obj, state, datas, isResetTimer)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_ICECHAKRAM_0) {
		// SUB_STATE_ICECHAKRAM_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_1) {
		// SUB_STATE_ICECHAKRAM_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_2) {
		// SUB_STATE_ICECHAKRAM_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_3) {
		// SUB_STATE_ICECHAKRAM_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_ICECHAKRAM_4) {
		// SUB_STATE_ICECHAKRAM_4 서브스테이트 작업
	}
	

}
