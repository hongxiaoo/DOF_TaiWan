
// sub state
S_FASTMOVE_PLAY <- 0
S_FASTMOVE_LOOP <- 1
S_FASTMOVE_PRO <- 2
S_FASTMOVE_END <- 3

// 스태틱 데이타 인덱스
FM_SI_C_TIME <- 0  // 회전 후 톱날이 완전 생성되는 시간
FM_SI_MULTI_HIT_COUNT <- 1 // 다단히트 간격
FM_SI_MOVE_VEL <- 2 // 톱날 이동속도
FM_SI_Y_AXIS_MOVESPEED <- 3 // 톱날 상하 이동속도

// 레벨인포 인덱스
FM_LI_HIT_RATE <- 0 // 톱날 히트 데미지(%)
FM_LI_MOVE_LEN <- 1 // 이동거리 (px)

VECTOR_I_SRC_X <- 0 // 시작지점을 저장한 벡터 인덱스



// 스킬 세부발동 조건을 만들어주는 함수입니다.. 발동 조건 state는 이미 소스에서 구현되어 있습니다. 이곳에서 useskill과 setstate를 지정해주면 됩니다.
function checkExecutableSkill_Fastmove(obj)  
{
	if(!obj) return false;
	local b_useskill = obj.sq_IsUseSkill(SKILL_FASTMOVE);
	if(b_useskill) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(S_FASTMOVE_PLAY); // substate세팅
		obj.sq_addSetStatePacket(STATE_FASTMOVE, STATE_PRIORITY_IGNORE_FORCE, true);
		return true;
	}	
	
	return false;
}

// 스킬아이콘 활성화 조건을 따지는 함수입니다. true를 리턴하면 스킬 아이콘이 활성화가 됩니다. (발동조건 state는  소스에서 처리됩니다.)
function checkCommandEnable_Fastmove(obj)
{
	if(!obj) return false;
	
	local state = obj.sq_GetSTATE();
	
	if(state == STATE_ATTACK) {
		return obj.sq_IsCommandEnable(SKILL_FASTMOVE); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_FASTMOVE);
	}
	
	return true;
}

// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_fastmove(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	local substate = obj.sq_getVectorData(datas, 0); // 첫번째 substate입니다..	
	obj.setSkillSubState(substate); //set substate
	
    
    local sq_var = obj.getVar();	
    sq_var.clear_vector();
	sq_var.push_vector(0);
	
// 스태틱 데이타 인덱스
//FM_SI_C_TIME <- 0  // 회전 후 톱날이 완전 생성되는 시간
//FM_SI_MULTI_HIT_COUNT <- 1 // 다단히트 간격

// 레벨인포 인덱스
//FM_LI_HIT_RATE <- 0 // 톱날 히트 데미지(%)
//FM_LI_MOVE_LEN <- 1 // 이동거리 (px)	
	
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();
	
	local particle = sq_var.GetparticleCreaterMap("FastMove", "Character/Priest/Effect/Particle/Fastmove.ptl", obj);
	
	
   	obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_FASTMOVE);
   	
   	obj.sq_setAttackPowerWithPassive(SKILL_FASTMOVE, state, -1,FM_LI_HIT_RATE,1.0);	
   	
    if(substate == S_FASTMOVE_PLAY) {
		obj.sq_stopMove();
		local time = obj.sq_getIntData(SKILL_FASTMOVE, FM_SI_C_TIME);		
		sq_var.push_vector(time);
		sq_var.push_vector(0);
    			
		obj.sq_setCurrentAnimation(CUSTOM_ANI_FASTMOVE1);
    }
    else if(substate == S_FASTMOVE_LOOP) {
		obj.sq_stopMove();
		//obj.sq_var.push_vector(posZ);
		//local pAni = obj.sq_getCurrentAni();
		
		sq_var.push_vector(posZ); // index : 1 // srcZ
		local jumpstate = 0;
		
		//print("sq_GetVelocityZ:" + sq_GetVelocity(obj, 2));
		//print("getDownDownFrame:" + obj.getDownDownFrame() + " getDownUpFrame:" + obj.getDownUpFrame() + " getDownBounceUpFrame:" + obj.getDownBounceUpFrame() + " getDownLieFrame:" + obj.getDownLieFrame());
		//print("getJumpUpStartFrame:" + obj.getJumpUpStartFrame() + " getJumpDownStartFrame:" + obj.getJumpDownStartFrame() + " getJumpLandStartFrame:" + obj.getJumpLandStartFrame());
		
		
		if(posZ > 0) {		
			//local frmIndex = obj.getDownUpFrame();

			if(sq_GetVelocity(obj, 2) < 0) {
				jumpstate = 2; // 하강중
			}
			else {
				jumpstate = 1; // 상승중
			}
		}
		sq_var.push_vector(jumpstate); // index : 2 // 점프플래그 0 : 맨땅에 있었을 때 1 : 올라갈 때 있었을때 2 : 내려가는 순간 있었을 때
		sq_var.push_vector(0); // index : 3 // 
		sq_var.push_vector(0); // index : 4 // 
		
		obj.sq_setCurrentAnimation(CUSTOM_ANI_FASTMOVE2);		
    }
    else if(substate == S_FASTMOVE_PRO) {
    	//CUSTOM_ATTACKINFO_FASTMOVE
    	local max_break_v = obj.sq_getVectorData(datas, 1); // 두번째 vector값은 감속 값
		obj.sq_setCurrentAnimation(CUSTOM_ANI_FASTMOVE3);
		sq_var.push_vector(posX); // 벡터 인덱스 1
		
		local pAni = obj.sq_getCurrentAni();
		local initDelay = pAni.GetFrameStartTime(3);
				
		//local vel = obj.sq_getIntData(SKILL_FASTMOVE, FM_SI_MOVE_VEL); // 이동속도
		local vel = obj.sq_getIntData(SKILL_FASTMOVE, FM_SI_MOVE_VEL); // 이동속도
		local d = obj.sq_getLevelData(SKILL_FASTMOVE, FM_LI_MOVE_LEN, 1);
		
		//local moveT =  (d * 10) / vel; // 이동 총 시간 구하기
		local v_rate;
		if(!(sq_GetCurrentModuleType() == 4) && !(sq_GetCurrentModuleType() == 5)) //현재모듈이 pvp모듈이나 fair_pvp모듈일 경우
		{
			v_rate = (vel - max_break_v);
		}
		else
		{
			v_rate = vel;
		}
		
		if(v_rate <= 0) 
		{
			v_rate = 1;
		}
		local moveT =  (d * 800) / (v_rate); // 이동 총 시간 구하기
		
		sq_var.push_vector(moveT); // 이동 총 시간 벡터 인덱스 2		
		sq_var.push_vector(0); // 이동 플래그 인덱스 3 이동할 수 없는 지역을 만났을 때 그순간 더이상 이동못한다..
		sq_var.push_vector(posY); // 인덱스4 바로 전 posY좌표를 저장하는 부분입니다.. 톱날공격이 상하로 이동이 가능해지면서 이동플래그관련 처리를 새롭게 해야합니다..
		local len = obj.sq_getLevelData(SKILL_FASTMOVE, FM_LI_MOVE_LEN, 1);
		//len = len - break_len; // 감속된 값을 깎는다..
		sq_var.push_vector(len); // 인덱스5
		sq_var.push_vector(0); // 인덱스6 사운드 플래그
		
		local hitCnt = obj.sq_getIntData(SKILL_FASTMOVE, FM_SI_MULTI_HIT_COUNT); // 다단히트
		
		local term = moveT / hitCnt;
		
		obj.sq_setShake(obj, 2, moveT);
		//obj.sq_setShake(obj, 4, moveT);
		// 클리핑
		sq_CurrentAnimationProc(pAni);
		
	//	local alsSpinNormal = obj.sq_getAutoLayerWorkAnimation(pAni, "2_sn");
//		local alsSpinDodge = obj.sq_getAutoLayerWorkAnimation(pAni, "2_sd");
	//	if(alsSpinNormal)
		//	alsSpinNormal.setCustomClipArea(true, 0, 0, 10, 10, false);
			
		//if(alsSpinDodge)
			//alsSpinDodge.setCustomClipArea(true, 0, 0, 10, 10, false);
		//

		sq_var.clear_timer_vector();
		sq_var.push_timer_vector();
				
		local t = sq_var.get_timer_vector(0);
		//t.setParameter(35, -1);
		t.setParameter(60, -1);		
		t.resetInstant(0);
		
		obj.sq_timer_.setParameter(term, hitCnt);
		obj.sq_timer_.resetInstant(initDelay);
		
		// 고속이동 y축 이동 가능하도록 수정작업
		// 스태틱 데이타로 상하이동 속도 추가	
		// FM_SI_Y_AXIS_MOVESPEED <- 3 // 톱날 상하 이동속도
		local y_axis_movespeed = obj.sq_getIntData(SKILL_FASTMOVE, FM_SI_Y_AXIS_MOVESPEED);
		//obj.sq_setMoveDirection(ENUM_DIRECTION_DOWN, ENUM_DIRECTION_DOWN);
		//obj.setAxisMoveDirection(1, ENUM_DIRECTION_DOWN, true, true);
		//obj.sq_setStaticMoveInfo(1, 263, 0, true, 0, 0);
		//obj.sq_setStaticMoveInfo(1, 200, 0, true, 0, 0);
		//obj.sq_setStaticSpeedInfo(1, 1);
		//
		obj.sq_setStaticMoveInfo(1,y_axis_movespeed,y_axis_movespeed,true);
		obj.sq_setMoveDirection(obj.getDirection(), ENUM_DIRECTION_NEUTRAL);
		//
    }
    else if(substate == S_FASTMOVE_END) {
		obj.sq_stopMove();
    	sq_var.push_vector(posX); // 벡터 인덱스 1
		obj.sq_setCurrentAnimation(CUSTOM_ANI_FASTMOVE4);
    }
	
    
}


// prepareDraw 함수 입니다..
function prepareDraw_fastmove(obj)
{
if(!obj) return;
//	local substate = obj.getSkillSubState();
	
	//if(substate == S_FASTMOVE_PRO) {
		//local pAni = obj.sq_getCurrentAni();
		
		//local alsSpinNormal = obj.sq_getAutoLayerWorkAnimation(pAni, "2_sn");
		//local alsSpinDodge = obj.sq_getAutoLayerWorkAnimation(pAni, "2_sd");
		
		//if(alsSpinNormal)
		//	alsSpinNormal.setCustomClipArea(true, 5, 5, 5, 5, false);
			
		//if(alsSpinDodge)
//			alsSpinDodge.setCustomClipArea(true, 0, 0, 0, 0, false);
//	}
}


// loop 부분입니다 ismycontrol로 감싸지 않은 연결된 모든 object들이 이곳을 거치게됩니다.
function onProc_fastmove(obj)
{
	if(!obj) return;
	local substate = obj.getSkillSubState();
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();
	
	local pAni = obj.sq_getCurrentAni();
    local frmIndex = obj.sq_ani_GetCurrentFrameIndex(pAni);

	local sq_var = obj.getVar();
	local currentT = sq_GetCurrentTime(pAni);
	
	
//S_FASTMOVE_PLAY <- 0
//S_FASTMOVE_LOOP <- 1
//S_FASTMOVE_PRO <- 2
//S_FASTMOVE_END <- 3
	
    if(substate == S_FASTMOVE_PLAY) {		
    }
    else if(substate == S_FASTMOVE_LOOP) {
		local max_break_v = 0;
    	//local time = obj.sq_getIntData(SKILL_FASTMOVE, FM_SI_C_TIME);
    	local time = obj.sq_getIntData(SKILL_FASTMOVE, FM_SI_C_TIME); // 톱날이 완전 생성되는 시간..
    	
    	if(obj.isMyControlObject()) {
    		if(sq_GetSkillLevel(obj, SKILL_FASTMOVE_EX) > 0) // 고속이동강화 관련 작업
    		{
    			local direction = obj.sq_getInputDirection(0);
    			
    			if(direction == ENUM_DIRECTION_NEUTRAL) {
    				sq_var.set_vector(4, currentT); // 아무것도 안눌렀을때 시간을 체크한다..
    			}
    			
    			if(direction == ENUM_DIRECTION_LEFT || direction == ENUM_DIRECTION_RIGHT) {
    				if(obj.getDirection() == ENUM_DIRECTION_LEFT || obj.getDirection() == ENUM_DIRECTION_RIGHT) {    				
    					if(direction != obj.getDirection()) {
    						//local max_break = 200;
    						local max_break = obj.sq_getIntData(SKILL_FASTMOVE_EX, 4); //느리게 이동하는 비율 (0~300) // 0 으로 하면 기존 속도가 나오게 되고 값이 늘어나면 속도가 느려집니다..
    						local t = time - sq_var.get_vector(4);
    						local c_t = currentT - sq_var.get_vector(4);
    						local v = sq_GetUniformVelocity(0, max_break, c_t, t);
    						
    						max_break_v = v;
    						//print("\n v:" + v + " c_t:" + c_t + " t:" + t);
    					}
    				}
    			}
    		}
    	}
    
    	
    	//sq_var.push_vector(posZ); // index : 1 // srcZ
    	
    	local srcZ = sq_var.get_vector(1); // 시전 시작 높이
    	local jumpstate = sq_var.get_vector(2); // jumpstate : 0 : 바닥 1 : 상승중 2 : 하강중
    	
		local up_t = time / 2;
		local up_l = 20 + srcZ;
    	
		local move_l = 0;
    		
    	//if(srcZ <= 0) {

		if(jumpstate == 0) {
    		
    		if(up_t > currentT) {
    			//move_l = sq_GetAccel(0, up_l, currentT, up_t, true);
    			move_l = sq_GetAccel(srcZ, up_l, currentT, up_t, true);
    		}
    		else {
    			move_l = sq_GetAccel(up_l, 0, currentT - up_t, up_t, false);
    		}
    		
    		if(currentT >= time) {
    			obj.setCurrentPos(posX, posY, 0);
	    		
				if(obj.isMyControlObject()) {			    	
					obj.sq_IntVectClear();
					obj.sq_IntVectPush(S_FASTMOVE_PRO);
					obj.sq_IntVectPush(max_break_v);
					obj.sq_addSetStatePacket(STATE_FASTMOVE, STATE_PRIORITY_USER, true);
				}    	
    		}
    		else {
    			obj.setCurrentPos(posX, posY, move_l);
    		}
    		
    	}
    	else if(jumpstate == 1) {
    		up_t = 100;
    		local down_t = 400;
    		up_l = 10 + srcZ;
    			    	
    		move_l = 0;
    		
    		//print("\n uprising");

    		
    		if(up_t > currentT) {
    			move_l = sq_GetAccel(srcZ, up_l, currentT, up_t, true);
    		}
    		else {
    			move_l = sq_GetAccel(up_l, 0, currentT - up_t, down_t, false);
    		}
    		
    		if(currentT >= (down_t + up_t) ) {
    			obj.setCurrentPos(posX, posY, 0);
	    		
				if(obj.isMyControlObject()) {			    	
					obj.sq_IntVectClear();
					obj.sq_IntVectPush(S_FASTMOVE_PRO);
					obj.sq_IntVectPush(max_break_v);
					obj.sq_addSetStatePacket(STATE_FASTMOVE, STATE_PRIORITY_USER, true);
				}    	
    		}
    		else {
    			obj.setCurrentPos(posX, posY, move_l);
    		}    		
    	}
    	else if(jumpstate == 2) { // 하강중
    		up_t = 50;
    		local down_t = 400;
    		up_l = srcZ;
    			    	
    		move_l = 0;
    		//print("\n downing");
    		
    		if(up_t > currentT) {
    			move_l = sq_GetAccel(srcZ, up_l, currentT, up_t, true);
    		}
    		else {
    			move_l = sq_GetAccel(up_l, 0, currentT - up_t, down_t, false);
    		}
    		
    		if(currentT >= (down_t + up_t) ) {
    			obj.setCurrentPos(posX, posY, 0);
	    		
				if(obj.isMyControlObject()) {			    	
					obj.sq_IntVectClear();
					obj.sq_IntVectPush(S_FASTMOVE_PRO);
					obj.sq_IntVectPush(max_break_v);
					obj.sq_addSetStatePacket(STATE_FASTMOVE, STATE_PRIORITY_USER, true);
				}    	
    		}
    		else {
    			obj.setCurrentPos(posX, posY, move_l);
    		}    		
    	}    	
    }
    else if(substate == S_FASTMOVE_PRO) {
//FM_LI_HIT_RATE <- 0 // 톱날 히트 데미지(%)
//FM_LI_MOVE_LEN <- 1 // 이동거리 (px)
		local initDelay = pAni.GetFrameStartTime(2);
		
		if(initDelay <= currentT) {
	    	local delayT = sq_var.get_vector(2); // 벡터인덱스 2 총 이동시간
	    	//print(delayT);
	    	local len = sq_var.get_vector(5);
	    	//print(len);
	    	
	    	
			if(sq_var.get_vector(6) == 0) // 인덱스6 사운드 플래그
			{
				obj.sq_PlaySound("FMOVE_DASH_LOOP", 7575);
				sq_var.set_vector(6, 1);
			}
	    	
			local v = sq_GetAccel(0, len, currentT - initDelay, delayT, false);
			//local v = sq_GetUniformVelocity(0, len, currentT - initDelay, delayT);	
			
			local srcX = sq_var.get_vector(1); // 벡터 인덱스 1
			
			local dstX = sq_GetDistancePos(srcX, obj.getDirection(), v);
			 
			if(sq_var.get_vector(3)) { // 전프레임에서 이동할 수 없는 지역을 만났다면..
				if(sq_var.get_vector(4) != posY) { // 전 posY와 비교해봐서 달라졌다면..
					sq_var.set_vector(3, 0); // 이동플래그를 off해줍니다..
					sq_var.set_vector(4, posY);
				}
			}
			 
			if(obj.isMovablePos(dstX, posY) && !sq_var.get_vector(3)) { // 이동플래그와 이동가능지역이 모두 가능해야 이동
				//obj.setCurrentPos(dstX, posY, posZ);
				sq_setCurrentAxisPos(obj, 0, dstX);
			}
			else { // 이동할 수 없는 지역을 만났다..
				sq_var.set_vector(3,1); // 이동 플래그 인덱스 3 이동할 수 없는 지역을 만났을 때 그순간 더이상 이동못한다..
				local offset = dstX - posX;
				
				if(offset != 0) {				
					if(offset < 0) 
						offset = -offset;
					
					local totalLen = sq_var.get_vector(5);
					sq_var.set_vector(5, totalLen - offset);
				}
			}
			
			if (obj.sq_timer_.isOnEvent(currentT) == true)
				obj.resetHitObjectList();
				
			if(v >= len) { // 목적지에 도착했을 때 sub state를 바꾼다..			 
				obj.stopSound(7575);
				if(obj.isMyControlObject()) {
					obj.sq_IntVectClear();
					obj.sq_IntVectPush(S_FASTMOVE_END);
					obj.sq_addSetStatePacket(STATE_FASTMOVE, STATE_PRIORITY_USER, true);
				}
			}

			

			
			// 고속이동 y축 이동 가능하도록 수정작업
			// 스태틱 데이타로 상하이동 속도 추가
			
			// 먼지 파티클 생성
			local t = sq_var.get_timer_vector(0);
			
			if(t.isOnEvent(currentT) == true) {
				//local dust_type = obj.getDustParticleType(LANDPARTICLE_MOVE);
				//local particleCreater = sq_GetobjectParticleCreaters(dust_type);
				//if(obj.getDirection() == ENUM_DIRECTION_LEFT)
					//particleCreater.getParticleInfo().xFlip = true;
				//else
					//particleCreater.getParticleInfo().xFlip = false;					
				//OBJECT_VECTOR objects = chargeSpearParticleCreator_->createObjectParticle();		
				
				local particleCreater = sq_var.GetparticleCreaterMap("FastMove", "Character/Priest/Effect/Particle/Fastmove.ptl", obj);				
					
				particleCreater.Restart(0);
				//particleCreater.SetPos(posX, posY, posZ-1);				
				local dstX = sq_GetDistancePos(posX, obj.getDirection(), -20);				
				particleCreater.SetPos(dstX, posY, posZ+28);	
				
				sq_AddParticleObject(obj, particleCreater);
			}
			
		}
    }
    else if(substate == S_FASTMOVE_END) {    	
    		local len = 40;
    		local delaySum = 400;
			local v = sq_GetAccel(0, len, currentT, delaySum, false);
			//local v = sq_GetUniformVelocity(0, len, currentT - initDelay, delayT);	
			
			local srcX = sq_var.get_vector(1); // 벡터 인덱스 1
			
			local dstX = sq_GetDistancePos(srcX, obj.getDirection(), v);
			 
			if(obj.isMovablePos(dstX, posY)) {
				obj.setCurrentPos(dstX, posY, posZ);
			}
    }
	
	
}

// loop 부분입니다 ismycontrol 호스트가 본인이 object가 이곳을 들어갑니다. setstate 세팅이나 패시브오브젝트 생성 , 등등 처리합니다.
function onProcCon_fastmove(obj)
{
	if(!obj) return;
	local pAni = obj.sq_getCurrentAni();
	local bEnd = obj.sq_ani_IsEnd(pAni);
    local frmIndex = obj.sq_ani_GetCurrentFrameIndex(pAni);
	
	//

    local substate = obj.getSkillSubState();

    if(substate == S_FASTMOVE_PLAY) {		
    }
    else if(substate == S_FASTMOVE_LOOP) {
    }
    else if(substate == S_FASTMOVE_PRO) {
    }
    else if(substate == S_FASTMOVE_END) {
    }
        
        
	if(bEnd) {
		if(substate == S_FASTMOVE_PLAY) {
				obj.sq_IntVectClear();
				obj.sq_IntVectPush(S_FASTMOVE_LOOP);
				obj.sq_addSetStatePacket(STATE_FASTMOVE, STATE_PRIORITY_USER, true);
				//obj.sq_addSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
		}
		else if(substate == S_FASTMOVE_LOOP) {
		}
		else if(substate == S_FASTMOVE_PRO) {
			//obj.sq_addSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
		}
		else if(substate == S_FASTMOVE_END) {
				obj.sq_addSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
		}
	}
}

// state종료와 동시에 한번 호출되는 함수입니다. oldstate가 종료되는 state입니다. 무언가 발사된것이 있거나 종료처리될것이 있다면 이곳에서 처리합니다.
function onEndState_fastmove(obj, new_state)
{
	if(!obj) return;
	if(new_state != STATE_FASTMOVE) {
		obj.stopSound(7575);
	}
}


// irdcharacter에서  setstate() -> IRDActiveObject::setState -> aftersetstate() 이런순서에서 마지막 setstate입니다. skill특성에 따라서 호출할 필요가 
// 있다면 이 함수를 이용합니다.

function onAfterSetState_fastmove(obj, state, datas, isResetTimer)
{
	if(!obj) return;
	
}

// onbeforeattack 콜백함수 입니다
function onBeforeAttack_fastmove(obj, damager, boundingBox)
{
	
}

// onAttack 콜백함수 입니다
function onAttack_fastmove(obj, damager, boundingBox)
{
	
}

// onAfterAttack 콜백함수 입니다
function onAfterAttack_fastmove(obj, damager, boundingBox)
{
	
}

// onBeforeDamage 콜백함수 입니다
function onBeforeDamage_fastmove(obj, attacker, boundingBox)
{
	
}

// onDamage 콜백함수 입니다
function onDamage_fastmove(obj, attacker, boundingBox)
{
	
}

// onAfterDamage 콜백함수 입니다
function onAfterDamage_fastmove(obj, attacker, boundingBox)
{
	
}


