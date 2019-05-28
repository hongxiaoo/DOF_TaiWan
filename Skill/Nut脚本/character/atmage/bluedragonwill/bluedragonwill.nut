
SUB_STATE_BLUEDRAGONWILL_0	<- 0
SUB_STATE_BLUEDRAGONWILL_1	<- 1
SUB_STATE_BLUEDRAGONWILL_2	<- 2
SUB_STATE_BLUEDRAGONWILL_3	<- 3
SUB_STATE_BLUEDRAGONWILL_4	<- 4

function checkExecutableSkill_BlueDragonWill(obj)
{

	if(!obj) return false;

	local b_useskill = obj.sq_IsUseSkill(SKILL_BLUEDRAGONWILL);

	if(b_useskill) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_BLUEDRAGONWILL_0); // substate세팅
		obj.sq_AddSetStatePacket(STATE_BLUEDRAGONWILL, STATE_PRIORITY_IGNORE_FORCE, true);
		return true;
	}	
	
	return false;

}

function checkCommandEnable_BlueDragonWill(obj)
{

	if(!obj) return false;

	local state = obj.sq_GetState();

	if(state == STATE_ATTACK)
	{
		return obj.sq_IsCommandEnable(SKILL_BLUEDRAGONWILL); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_BROKENARROW);
	}

	return true;

}

function onSetState_BlueDragonWill(obj, state, datas, isResetTimer)
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


	if(substate == SUB_STATE_BLUEDRAGONWILL_0) {
	
		obj.sq_PlaySound("MW_ICEHAMMER_READY");	
		
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_BLUEDRAGONWILL1);
		
		local pAni = obj.sq_GetCurrentAni();
		
		//local chargeT = obj.sq_GetIntData(SKILL_BLUEDRAGONWILL, 0); // 기운 충전시간
		//local delaySum = sq_GetDelaySum(pAni);
		//
		//local rate = delaySum.tofloat() * 100.0 / chargeT.tofloat();
		//
		//obj.sq_SetAnimationSpeedRate(pAni, rate);

		local skillLevel = sq_GetSkillLevel(obj, SKILL_BLUEDRAGONWILL);
		// 캐스팅 속도를 따라가도록 설정
		// 캐스팅 속도가 변경되면, 에니메이션 속도도 변경 됩니다.
		// 캐스팅 게이지도 표시를 해줍니다.
		local castTime = sq_GetCastTime(obj, SKILL_BLUEDRAGONWILL, skillLevel);
		local animation = sq_GetCurrentAnimation(obj);
		local startTime = sq_GetFrameStartTime(animation, 16);
		local speedRate = startTime.tofloat() / castTime.tofloat();
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
			SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, speedRate, speedRate);
			
		sq_StartDrawCastGauge(obj, startTime, true);
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_1) {
	
		local group = obj.sq_GetVectorData(datas, 1);
		local uniqueId = obj.sq_GetVectorData(datas, 2);
		
		local targetObj = sq_GetObject(obj, group, uniqueId);
	
		obj.getVar().push_vector(posX); // 현재 x : i: 2
		obj.getVar().push_vector(posY); // 현재 y : i: 3
		
		if(targetObj) {
			local disX = sq_Abs(targetObj.getXPos() - posX);
			local disY = targetObj.getYPos() - posY;
			
			disX = disX - 40;
			
			if(disX <= 0)
				disX = 0;
			
			obj.getVar().push_vector(disX); // x축 이동거리 : i: 4
			obj.getVar().push_vector(disY); // y축 이동거리 : i: 5
		}
		else { // 디폴트 이동거리
			local defaultDistance = obj.sq_GetIntData(SKILL_BLUEDRAGONWILL, 1); // 간접 공격 (지진 확대율) (100~)
			obj.getVar().push_vector(defaultDistance); // x축 이동거리 
			obj.getVar().push_vector(0); // y축 이동거리
		}		
	
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_BLUEDRAGONWILL2);
		
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_2) {
		obj.sq_PlaySound("MW_ICEHAMMER");	
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_BLUEDRAGONWILL3);
		sq_setCurrentAxisPos(obj, 2, 0);
		
		if(obj.isMyControlObject()) {
			obj.sq_SetShake(obj,3,300);

			local distanceL = 90;
			local h = 0;
			
			local spin_radius = obj.sq_GetIntData(SKILL_BLUEDRAGONWILL, 2); // 간접 공격 (지진 확대율) (100~)
			local spin_r = spin_radius.tofloat() / 100.0;
			
			local firstAttackRate = obj.sq_GetBonusRateWithPassive(SKILL_BLUEDRAGONWILL, STATE_BLUEDRAGONWILL, 0, 1.0); //2.공격력(%)
			local power = obj.sq_GetPowerWithPassive(SKILL_BLUEDRAGONWILL, STATE_BLUEDRAGONWILL, 1,-1,1.0);	 // 간접공격력
			local pow = obj.sq_GetSkillPower(SKILL_BLUEDRAGONWILL, 1);
			
			local l_data = obj.sq_GetLevelData(SKILL_BLUEDRAGONWILL, 1, 1);
			
			print("power:" + power + " pow:" + pow + " l_data:" + l_data);
			
			sq_BinaryStartWrite();
			sq_BinaryWriteFloat(spin_r); // 
			sq_BinaryWriteDword(power); // 간접공격력
			
			obj.sq_SendCreatePassiveObjectPacket(24246, 0, distanceL, -1, h); // 지진이미지 간접 공격
			
			sq_BinaryStartWrite();
			sq_BinaryWriteDword(firstAttackRate); // 공격력(%)
			
			obj.sq_SendCreatePassiveObjectPacket(24245, 0, distanceL, 5, h);
		}
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_3) {
		// SUB_STATE_BLUEDRAGONWILL_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_4) {
		// SUB_STATE_BLUEDRAGONWILL_4 서브스테이트 작업
	}
	
	//obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
	//		SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
}

function prepareDraw_BlueDragonWill(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_BLUEDRAGONWILL_0) {
		// SUB_STATE_BLUEDRAGONWILL_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_1) {
		// SUB_STATE_BLUEDRAGONWILL_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_2) {
		// SUB_STATE_BLUEDRAGONWILL_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_3) {
		// SUB_STATE_BLUEDRAGONWILL_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_4) {
		// SUB_STATE_BLUEDRAGONWILL_4 서브스테이트 작업
	}
	

}

function onProc_BlueDragonWill(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	local pAni = obj.sq_GetCurrentAni();
	local frmIndex = obj.sq_GetCurrentFrameIndex(pAni);
	local sq_var = obj.getVar();
	local currentT = sq_GetCurrentTime(pAni);
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();

	if(substate == SUB_STATE_BLUEDRAGONWILL_0) {
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_1) {
    	//local dash_t = pAni.getDelaySum(false); //
		local dash_t = pAni.getDelaySum(0, 2) + 60; //
    	
    	
		local srcX = obj.getVar().get_vector(2); // 시작x
		local srcY = obj.getVar().get_vector(3); // 시작y
    	    	
    	local dis_x_len = sq_var.get_vector(4); // 총 이동거리
		local dis_y_len = obj.getVar().get_vector(5); // y축 이동거리
		
		local v = sq_GetAccel(0, dis_x_len, currentT, dash_t, true);
		
		local my = sq_GetUniformVelocity(0, dis_y_len, currentT, dash_t);
		
		local dstX = sq_GetDistancePos(srcX, obj.getDirection(), v);
		local dstY = srcY + my;
		 
		if(sq_var.get_vector(0)) { // 전프레임에서 이동할 수 없는 지역을 만났다면..
			if(sq_var.get_vector(1) != posY) { // 전 posY와 비교해봐서 달라졌다면..
				sq_var.set_vector(0, 0); // 이동플래그를 off해줍니다..
				sq_var.set_vector(1, posY);
			}
		}
		 
		if(obj.isMovablePos(dstX, dstY) && !sq_var.get_vector(0)) { // 이동플래그와 이동가능지역이 모두 가능해야 이동
			sq_setCurrentAxisPos(obj, 0, dstX);
			sq_setCurrentAxisPos(obj, 1, dstY);
		}
		else { // 이동할 수 없는 지역을 만났다..
			sq_var.set_vector(0,1); // 이동 플래그 인덱스 3 이동할 수 없는 지역을 만났을 때 그순간 더이상 이동못한다..
			local offset = dstX - posX;
			
			if(offset != 0) {				
				if(offset < 0) 
					offset = -offset;
				
				local totalLen = sq_var.get_vector(4); // 총이동거리
				sq_var.set_vector(4, totalLen - offset);
			}
		}
		
		
		
		if(frmIndex == 2){
    		sq_setCurrentAxisPos(obj, 2, 30);
		}
		else if(frmIndex == 3) {
    		sq_setCurrentAxisPos(obj, 2, 60);
		}
		else if(frmIndex == 4){
    		sq_setCurrentAxisPos(obj, 2, 50);
		}
		else if(frmIndex == 5){
    		sq_setCurrentAxisPos(obj, 2, 40);
		}
    	
	
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_2) {
		// SUB_STATE_BLUEDRAGONWILL_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_3) {
		// SUB_STATE_BLUEDRAGONWILL_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_4) {
		// SUB_STATE_BLUEDRAGONWILL_4 서브스테이트 작업
	}
	

}

function onProcCon_BlueDragonWill(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_BLUEDRAGONWILL_0) {
		// SUB_STATE_BLUEDRAGONWILL_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_1) {
		// SUB_STATE_BLUEDRAGONWILL_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_2) {
		// SUB_STATE_BLUEDRAGONWILL_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_3) {
		// SUB_STATE_BLUEDRAGONWILL_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_4) {
		// SUB_STATE_BLUEDRAGONWILL_4 서브스테이트 작업
	}
	

}

function onEndCurrentAni_BlueDragonWill(obj)
{

	if(!obj) return;

	if(!obj.isMyControlObject()) {
		return;
	}
	
	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_BLUEDRAGONWILL_0) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_BLUEDRAGONWILL_1); // substate세팅
		
		// 500 // x축 타겟팅 범위
		// 120 // y축 타겟팅 범위
		// 10 // z축 타겟팅 범위
		
		//local x_range = obj.sq_GetIntData(SKILL_BLUEDRAGONWILL, 3); // 기운 충전시간
		//local y_range = obj.sq_GetIntData(SKILL_BLUEDRAGONWILL, 4); // 기운 충전시간
		//local z_range = obj.sq_GetIntData(SKILL_BLUEDRAGONWILL, 5); // 기운 충전시간
		
		//local targetObj = sq_FindTarget(obj, 0, x_range, y_range, z_range);
		//
		//if(targetObj) {
			//local group = sq_GetGroup(targetObj);
			//local uniqueId = sq_GetUniqueId(targetObj);
			//
			//obj.sq_IntVectPush(group); // 
			//obj.sq_IntVectPush(uniqueId); // 
		//}
		//else {
			//obj.sq_IntVectPush(-1); // 
			//obj.sq_IntVectPush(-1); // 
		//}
		local distance = obj.sq_GetIntData(SKILL_BLUEDRAGONWILL, SKL_STATIC_INT_IDX_3); // 적과의 거리
		local angle = obj.sq_GetIntData(SKILL_BLUEDRAGONWILL, SKL_STATIC_INT_IDX_4); // 적과의 각도
		
		local targetObj = findAngleTarget(obj, distance, angle, 100);
		if(targetObj) {
			local group = sq_GetGroup(targetObj);
			local uniqueId = sq_GetUniqueId(targetObj);
			
			obj.sq_IntVectPush(group); // 
			obj.sq_IntVectPush(uniqueId); // 
		}
		else {
			obj.sq_IntVectPush(-1); // 
			obj.sq_IntVectPush(-1); // 
		}
		
		
		obj.sq_AddSetStatePacket(STATE_BLUEDRAGONWILL, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_1) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_BLUEDRAGONWILL_2); // substate세팅
		obj.sq_AddSetStatePacket(STATE_BLUEDRAGONWILL, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_2) {
			obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_3) {
		// SUB_STATE_BLUEDRAGONWILL_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_4) {
		// SUB_STATE_BLUEDRAGONWILL_4 서브스테이트 작업
	}
	

}

function onKeyFrameFlag_BlueDragonWill(obj, flagIndex)
{

	if(!obj) return false;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_BLUEDRAGONWILL_0) {
		// SUB_STATE_BLUEDRAGONWILL_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_1) {
		// SUB_STATE_BLUEDRAGONWILL_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_2) {
		// SUB_STATE_BLUEDRAGONWILL_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_3) {
		// SUB_STATE_BLUEDRAGONWILL_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_4) {
		// SUB_STATE_BLUEDRAGONWILL_4 서브스테이트 작업
	}
	

	return false;

}

function onEndState_BlueDragonWill(obj, new_state)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_BLUEDRAGONWILL_0) {
		// SUB_STATE_BLUEDRAGONWILL_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_1) {
		// SUB_STATE_BLUEDRAGONWILL_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_2) {
		// SUB_STATE_BLUEDRAGONWILL_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_3) {
		// SUB_STATE_BLUEDRAGONWILL_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_4) {
		// SUB_STATE_BLUEDRAGONWILL_4 서브스테이트 작업
	}
	
	sq_EndDrawCastGauge(obj);

}

function onAfterSetState_BlueDragonWill(obj, state, datas, isResetTimer)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_BLUEDRAGONWILL_0) {
		// SUB_STATE_BLUEDRAGONWILL_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_1) {
		// SUB_STATE_BLUEDRAGONWILL_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_2) {
		// SUB_STATE_BLUEDRAGONWILL_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_3) {
		// SUB_STATE_BLUEDRAGONWILL_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BLUEDRAGONWILL_4) {
		// SUB_STATE_BLUEDRAGONWILL_4 서브스테이트 작업
	}
	

}

function getHitDirection_BlueDragonWill(obj, damager)
{
	if(!obj) return 0;
	
	print("getHitDirection_BlueDragonWill");
	
	return sq_GetOppositeDirection(obj.getDirection());
	
}
