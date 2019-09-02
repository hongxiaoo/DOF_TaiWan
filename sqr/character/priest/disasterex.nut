
S_DISASTER_0 <- 0
S_DISASTER_1 <- 1
S_DISASTER_2 <- 2
S_DISASTER_3 <- 3
S_DISASTER_4 <- 4

//750 // 악마화 상태일 때, 데미지 증폭률
//500 // 악마화 상태일 때, 악마화 지속시간 증가,ms 단위
//2000 // 타게팅 시간 (ms 단위)
//500 // 타겟의 x축 이동시간
//500 // 타겟의 y축 이동시간
//250 // 소용돌이가 적을 끌어들이는 범위(x축 지름)
//125 // 소용돌이가 적을 끌어들이는 속도


SD_I_DAMAGE_INC <- 0 // 악마화 상태일 때, 데미지 증폭률
SD_I_AWAKENING_INC <- 1 //// 악마화 상태일 때, 악마화 지속시간 증가,ms 단위
SD_I_TARGET_TIME <- 2 // 타게팅 시간 (ms 단위)
SD_I_TARGET_MOV_X <- 3 // 타겟의 X축 이동시간
SD_I_TARGET_MOV_Y <- 4 // 타겟의 y축 이동시간
SD_I_TARGET_SUCK_LEN <- 5 // 소용돌이가 적을 끌어들이는 범위(x축 지름)
SD_I_TARGET_SUCK_VEL <- 6 // 소용돌이가 적을 끌어들이는 속도



// 스킬 세부발동 조건을 만들어주는 함수입니다.. 발동 조건 state는 이미 소스에서 구현되어 있습니다. 이곳에서 useskill과 setstate를 지정해주면 됩니다.
function checkExecutableSkill_DisasterEx(obj)  
{
	if(!obj) return false;
	local b_useskill = obj.sq_IsUseSkill(SKILL_EX_DISASTER);
	if(b_useskill) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(S_DISASTER_0); // substate세팅
		obj.sq_IntVectPush(obj.getDirection()); // substate세팅
		obj.sq_addSetStatePacket(STATE_EX_DISASTER, STATE_PRIORITY_IGNORE_FORCE, true);
		return true;
	}	
	
	return false;
}

// 스킬아이콘 활성화 조건을 따지는 함수입니다. true를 리턴하면 스킬 아이콘이 활성화가 됩니다. (발동조건 state는  소스에서 처리됩니다.)
function checkCommandEnable_DisasterEx(obj)
{
	if(!obj) return false;
	
	local state = obj.sq_GetSTATE();
	
	if(state == STATE_ATTACK) {
		return obj.sq_IsCommandEnable(SKILL_EX_DISASTER); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_EARTH_QUAKE);
	}
	
	
	return true;
}

// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_DisasterEx(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	local sq_var = obj.getVar();
	local substate = obj.sq_getVectorData(datas, 0); // 첫번째 substate입니다..	
	local direction = obj.sq_getVectorData(datas, 1); // 첫번째 substate입니다..	
	obj.setSkillSubState(substate); //set substate
	obj.sq_stopMove();
	
    
	sq_var.clear_vector();
	sq_var.push_vector(0);	
	sq_var.push_vector(0);
	sq_var.push_vector(0);
	
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();
	
//CUSTOM_ANI_EX_DISASTER_1		<- 118	  // EX스킬 - 재앙1
//CUSTOM_ANI_EX_DISASTER_2		<- 119	  // EX스킬 - 재앙1
//CUSTOM_ANI_EX_DISASTER_3		<- 120	  // EX스킬 - 재앙1
//CUSTOM_ANI_EX_DISASTER_4		<- 121	  // EX스킬 - 재앙1
//CUSTOM_ANI_EX_DISASTER_5		<- 122	  // EX스킬 - 재앙1
	obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_DISASTER);
	
	local attack_rate = 1.0;

	//SD_I_DAMAGE_INC <- 0 // 악마화 상태일 때, 데미지 증폭률
	//SD_I_AWAKENING_INC <- 1 //// 악마화 상태일 때, 악마화 지속시간 증가,ms 단위
	
	if(isAvengerAwakenning(obj)) {
		local inc = obj.sq_getIntData(SKILL_EX_DISASTER, SD_I_DAMAGE_INC); // 타겟의 X축 이동시간
		local inc_rate = inc.tofloat() / 100.0;
		print("\n inc_rate:" + inc_rate);
		attack_rate += inc_rate;
	}
	
	obj.stopSound(7575);
	obj.sq_setAttackPowerWithPassive(SKILL_EX_DISASTER, state, -1, 0, attack_rate);

	
    if(substate == S_DISASTER_0) {
		if(isAvengerAwakenning(obj)) {
			local ani = obj.getVar().GetAnimationMap("Disaster1", "Character/Priest/Animation/disasterEx/Disaster1.ani"); // 스킨아바타 때문에 외부에서 애니메이션을 가지고 와야 합니다..
			obj.setCurrentAnimation(ani);
			local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_AVENGER_AWAKENING, false, "Appendage/Character/ap_avenger_awakening.nut", false);
			if(appendage) { // 각성상태라면 각성시간을 늘려줘야합니다.
				local skill_level = obj.sq_getSkillLevel(SKILL_AVENGER_AWAKENING);
				local t = sq_GetLevelData(obj, SKILL_AVENGER_AWAKENING, SL_CHANGE_TIME, skill_level);
				local awakening_inc_t = obj.sq_getIntData(SKILL_EX_DISASTER, SD_I_AWAKENING_INC); // 악마화 상태일 때, 악마화 지속시간 증가,ms 단위
				appendage.sq_var.set_vector(I_AVENGER_AWAKENING_TIME, t + awakening_inc_t);
				appendage.sq_SetValidTime(t + awakening_inc_t); // 어펜디지 타임 세팅
			}
		}
		else {
			obj.sq_setCurrentAnimation(CUSTOM_ANI_EX_DISASTER_1);
		}
    
		local pAni = obj.sq_getCurrentAni();		
    }
    else if(substate == S_DISASTER_1) {
		obj.sq_setShake(obj, 3, 160);
    
		if(isAvengerAwakenning(obj)) {
			 // 스킨아바타 때문에 외부에서 애니메이션을 가지고 와야 합니다..
			local ani = obj.getVar().GetAnimationMap("Disaster2", "Character/Priest/Animation/disasterEx/Disaster2.ani");
			obj.setCurrentAnimation(ani);
		}
		else {
			obj.sq_setCurrentAnimation(CUSTOM_ANI_EX_DISASTER_2);
		}
    
		/////////////////////////////////////////////
		//if(obj.isMyControlObject()) {
			//obj.sq_binaryData_startWrite();
			//obj.sq_binaryData_writeDword(0);
			//obj.sq_p00_sendCreatePassiveObjectPacket(24101, 0, 0, 0, 0);
		//}
	    ///////////////////////////////////////////////	
		local pA = obj.sq_getCurrentAni();
		
		local iX = posX;
		local iY = posY;

		//int offsetX = lua_getIntData(SKILL_SPIRAL_COLUMN_EX, 0);
		//offsetX = lua_getDistancePos(iX, sq_GetDirection(this), offsetX);

		//int vX = lua_getIntData(SKILL_SPIRAL_COLUMN_EX, 1);
		//int vY = 0;
		
	//SD_I_DAMAGE_INC <- 0 // 악마화 상태일 때, 데미지 증폭률
	//SD_I_AWAKENING_INC <- 1 //// 악마화 상태일 때, 악마화 지속시간 증가,ms 단위
	//SD_I_TARGET_TIME <- 2 // 타게팅 시간 (ms 단위)
	//SD_I_TARGET_MOV_X <- 3 // 타겟의 X축 이동시간
	//SD_I_TARGET_MOV_Y <- 4 // 타겟의 y축 이동시간
	//SD_I_TARGET_SUCK_LEN <- 5 // 소용돌이가 적을 끌어들이는 범위(x축 지름)
	//SD_I_TARGET_SUCK_VEL <- 6 // 소용돌이가 적을 끌어들이는 속도
	//
		//
		local vX = obj.sq_getIntData(SKILL_EX_DISASTER, SD_I_TARGET_MOV_X); // 타겟의 X축 이동시간
		local vY = obj.sq_getIntData(SKILL_EX_DISASTER, SD_I_TARGET_MOV_Y); // 타겟의 Y축 이동시간

		obj.sq_addAttractAimPointMark(iX, iY, vX, vY);
		//450	// 끌어들이는 범위 (x축 지름)
		//180	// 끌어들이는 적의 최대 높이
		local range = obj.sq_getIntData(SKILL_EX_DISASTER, SD_I_TARGET_SUCK_LEN); // 소용돌이가 적을 끌어들이는 범위(x축 지름)
		local suck_vel = obj.sq_getIntData(SKILL_EX_DISASTER, SD_I_TARGET_SUCK_VEL); // 소용돌이가 적을 끌어들이는 속도
		obj.sq_setAttractAimInfo(suck_vel, suck_vel, range / 2, 180);
		//obj.sq_setAttractAimInfo(91, 113, range / 2, 180);
		
		
    }
    else if(substate == S_DISASTER_2) {
    //
		//CUSTOM_ATTACKINFO_DISASTER
   		obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_DISASTER);
   		
		if(isAvengerAwakenning(obj)) {
			 // 스킨아바타 때문에 외부에서 애니메이션을 가지고 와야 합니다..
			local ani = obj.getVar().GetAnimationMap("Disaster3", "Character/Priest/Animation/disasterEx/Disaster3.ani");
			obj.setCurrentAnimation(ani);
		}
		else {
			obj.sq_setCurrentAnimation(CUSTOM_ANI_EX_DISASTER_3);
		}
		
		obj.sq_PlaySound("DISASTER_CIRCLE_LOOP", 7575);
   		
    }
    else if(substate == S_DISASTER_3) {
    
		if(isAvengerAwakenning(obj)) {
			 // 스킨아바타 때문에 외부에서 애니메이션을 가지고 와야 합니다..
			local ani = obj.getVar().GetAnimationMap("Disaster4", "Character/Priest/Animation/disasterEx/Disaster4.ani");
			obj.setCurrentAnimation(ani);
		}
		else {
			obj.sq_setCurrentAnimation(CUSTOM_ANI_EX_DISASTER_4);
		}
    
		
    }
    else if(substate == S_DISASTER_4) {
		if(isAvengerAwakenning(obj)) {
			 // 스킨아바타 때문에 외부에서 애니메이션을 가지고 와야 합니다..
			local ani = obj.getVar().GetAnimationMap("Disaster5", "Character/Priest/Animation/disasterEx/Disaster5.ani");
			obj.setCurrentAnimation(ani);
		}
		else {
			obj.sq_setCurrentAnimation(CUSTOM_ANI_EX_DISASTER_5);
		}
    }
}

// irdcharacter에서  setstate() -> IRDActiveObject::setState -> aftersetstate() 이런순서에서 마지막 setstate입니다. skill특성에 따라서 호출할 필요가 
// 있다면 이 함수를 이용합니다.

function onAfterSetState_DisasterEx(obj, state, datas, isResetTimer)
{
	if(!obj) return;
}

// onbeforeattack 콜백함수 입니다
function onBeforeAttack_DisasterEx(obj, damager, boundingBox)
{
	
}



// loop 부분입니다 ismycontrol로 감싸지 않은 연결된 모든 object들이 이곳을 거치게됩니다.
function onProc_DisasterEx(obj)
{
	if(!obj) return;
	
	local substate = obj.getSkillSubState();
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();
	
	local sq_var = obj.getVar();
	local pAni = obj.sq_getCurrentAni();
    local frmIndex = obj.sq_ani_GetCurrentFrameIndex(pAni);

	local currentT = sq_GetCurrentTime(pAni);
	
    if(substate == S_DISASTER_0) {
    }
    else if(substate == S_DISASTER_1) {
		if(frmIndex >= 0) {
    		local flag = sq_var.get_vector(0);
    		if(!flag) {
				local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_EX_DISASTER, true, "Appendage/Character/ap_avenger_effect.nut", true);
				sq_var.set_vector(0, 1);
			}
	   }
	   //isAvengerAwakenning()
    }
    else if(substate == S_DISASTER_2) {
		local stateTimer = obj.sq_getStateTimer();		
		//SD_I_DAMAGE_INC <- 0 // 악마화 상태일 때, 데미지 증폭률
		//SD_I_AWAKENING_INC <- 1 //// 악마화 상태일 때, 악마화 지속시간 증가,ms 단위
		//SD_I_TARGET_TIME <- 2 // 타게팅 시간 (ms 단위)
		//SD_I_TARGET_MOV_X <- 3 // 타겟의 X축 이동시간
		//SD_I_TARGET_MOV_Y <- 4 // 타겟의 y축 이동시간
		//SD_I_TARGET_SUCK_LEN <- 5 // 소용돌이가 적을 끌어들이는 범위(x축 지름)
		//SD_I_TARGET_SUCK_VEL <- 6 // 소용돌이가 적을 끌어들이는 속도
		//local t = 1000;
		local t = obj.sq_getIntData(SKILL_EX_DISASTER, SD_I_TARGET_TIME); // 타게팅 시간 (ms 단위)
		
		//print("\n stateTimer:" + stateTimer);
		
		if(stateTimer > (t - 750)) {
    		local flag = sq_var.get_vector(1);
    		if(!flag) {				
				local iX = obj.getXPos();
				local iY = obj.getYPos();
				local iPX = obj.sq_getAttractAimPosX(iX,iY, false);
				local iPY = obj.sq_getAttractAimPosY(iX,iY, false) + 2;
				
				print("\n posX:" + posX + " posY:" + posY + " aimposX:" + iPX + " aimposY:" + iPY);

				sq_MoveToNearMovablePos(obj, iPX, iPY, 0, iX, iY, posZ, 200, -1, 3);
				obj.sq_removeAttractAimPointMark();
				sq_var.set_vector(1, 1);
			}
	   }
		
		if(stateTimer > t) {
			if(obj.isMyControlObject()) {
				obj.sq_IntVectClear();
				obj.sq_IntVectPush(S_DISASTER_3);
				obj.sq_IntVectPush(obj.getDirection()); // substate세팅
				obj.sq_addSetStatePacket(STATE_EX_DISASTER, STATE_PRIORITY_IGNORE_FORCE, true);
			}
		}
    
    }	
    else if(substate == S_DISASTER_3) {
		if(frmIndex >= 5) {
    		local flag = sq_var.get_vector(0);
    		if(!flag) {
				if(obj.isMyControlObject()) {
				
					//SD_I_DAMAGE_INC <- 0 // 악마화 상태일 때, 데미지 증폭률
					//SD_I_AWAKENING_INC <- 1 //// 악마화 상태일 때, 악마화 지속시간 증가,ms 단위
					
					local attack_rate = 1.0;
					if(isAvengerAwakenning(obj)) {
						local inc = obj.sq_getIntData(SKILL_EX_DISASTER, SD_I_DAMAGE_INC); // 타겟의 X축 이동시간
						local inc_rate = inc.tofloat() / 100.0;
						attack_rate += inc_rate;
					}
					
					local bonus_rate = obj.sq_getBonusRateWithPassive(SKILL_EX_DISASTER, STATE_EX_DISASTER, 1, attack_rate);
					
					obj.sq_binaryData_startWrite();
					obj.sq_binaryData_writeDword(bonus_rate);
					obj.sq_p00_sendCreatePassiveObjectPacket(24109, 0, 0, 0, 0); // 폭발
				}
				
				
				if(isAvengerAwakenning(obj)) {
					//local particleCreater = sq_var.GetparticleCreaterMap("GuillotineSub", "PassiveObject/Character/Thief/Particle/GuillotineSub.ptl", obj);
					local particleCreater = sq_var.GetparticleCreaterMap("GuillotineSub6", "Character/Priest/Effect/Particle/DisasterStonsSmall.ptl", obj);
					particleCreater.Restart(0);
					//local dstX = sq_GetDistancePos(posX, obj.getDirection(), -20);				
					particleCreater.SetPos(posX, posY, posZ);
					sq_AddParticleObject(obj, particleCreater);
					
					obj.sq_PlaySound("PR_DGUARDIAN_DISASTER"); // 악마화 변신 후 마지막 땅에 부딫히며 번개칠때 보이스
				}
				else {				
					obj.sq_PlaySound("PR_DISASTER"); // 마지막 땅에 부딫히며 번개칠때 보이스
				}
				
				local fScreen = sq_flashScreen(obj,0,320,320,200, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);

				obj.sq_setShake(obj, 6, 320);

				obj.sq_removeAttractAimPointMark();
				sq_var.set_vector(0, 1);
			}
		}
    
    }	
    else if(substate == S_DISASTER_4) {
    }	
    
    
    
    if(substate == S_DISASTER_4) {
		if(frmIndex >= 4) {
    		local flag = sq_var.get_vector(0);
    		if(!flag) {
				local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_EX_DISASTER, true, "Appendage/Character/ap_avenger_effect.nut", true);
				sq_var.set_vector(0, 1);
			}
	   }
    }
    
	
}

// loop 부분입니다 ismycontrol 호스트가 본인이 object가 이곳을 들어갑니다. setstate 세팅이나 패시브오브젝트 생성 , 등등 처리합니다.
function onProcCon_DisasterEx(obj)
{
	if(!obj) return;
	local pAni = obj.sq_getCurrentAni();
	local bEnd = obj.sq_ani_IsEnd(pAni);
    local frmIndex = obj.sq_ani_GetCurrentFrameIndex(pAni);
	local sq_var = obj.getVar();
	//

    local subState = obj.getSkillSubState();
        
    if(subState == S_DISASTER_1) {
    }
    else if(subState == S_DISASTER_2) {
    }
    else if(subState == S_DISASTER_3) {
    }
    

	if(bEnd) {
	    if(subState == S_DISASTER_0) {
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(S_DISASTER_1);
			obj.sq_IntVectPush(obj.getDirection()); // substate세팅
			obj.sq_addSetStatePacket(STATE_EX_DISASTER, STATE_PRIORITY_IGNORE_FORCE, true);
	    }
	    else if(subState == S_DISASTER_1) {
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(S_DISASTER_2);
			obj.sq_IntVectPush(obj.getDirection()); // substate세팅
			obj.sq_addSetStatePacket(STATE_EX_DISASTER, STATE_PRIORITY_IGNORE_FORCE, true);
	    }
	    else if(subState == S_DISASTER_2) {
	    }
	    else if(subState == S_DISASTER_3) {
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(S_DISASTER_4);
			obj.sq_IntVectPush(obj.getDirection()); // substate세팅
			obj.sq_addSetStatePacket(STATE_EX_DISASTER, STATE_PRIORITY_IGNORE_FORCE, true);
	    }
	    else if(subState == S_DISASTER_4) {
			obj.sq_addSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	    }
	}
}

// state종료와 동시에 한번 호출되는 함수입니다. oldstate가 종료되는 state입니다. 무언가 발사된것이 있거나 종료처리될것이 있다면 이곳에서 처리합니다.
function onEndState_DisasterEx(obj, new_state)
{
	if(!obj) return;
	if(new_state != STATE_EX_DISASTER) {
		obj.sq_removeAttractAimPointMark();
	}
	obj.stopSound(7575);
}

// onAttack 콜백함수 입니다
function onAttack_DisasterEx(obj, damager, boundingBox)
{
	
}

// onAfterAttack 콜백함수 입니다
function onAfterAttack_DisasterEx(obj, damager, boundingBox)
{
	
}

// onBeforeDamage 콜백함수 입니다
function onBeforeDamage_DisasterEx(obj, attacker, boundingBox)
{
	
}

// onDamage 콜백함수 입니다
function onDamage_DisasterEx(obj, attacker, boundingBox)
{
	
}

// onAfterDamage 콜백함수 입니다
function onAfterDamage_DisasterEx(obj, attacker, boundingBox)
{
	
}

function getScrollBasisPos_DisasterEx(obj)
{
	if(!obj) return;
	
	local substate = obj.getSkillSubState();

	if(substate == S_DISASTER_2 || substate == S_DISASTER_1) {
		if(obj.isMyControlObject()) {
			local iX = obj.getXPos();
			local iY = obj.getYPos();
			local iPX = obj.sq_getAttractAimPosX(iX,iY, false);
			local iPY = obj.sq_getAttractAimPosY(iX,iY, false);
			obj.sq_SetCameraScrollPosition(iPX, iPY, 0);
			return true;
		}
	}
	
	return false;
}
