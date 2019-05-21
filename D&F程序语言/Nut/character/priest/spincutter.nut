
S_SPINCUTTER_THROW <- 0
S_SPINCUTTER_RECALL <- 1
S_SPINCUTTER_ARRIVAL <- 2

CSI_THROW_LEN <- 0
CSI_STAY_TIME <- 1
CSI_SPIN_HIT_COUNT <- 2

I_OBJ_VECTOR_ROPE_ANI <- 0
I_OBJ_VECTOR_ROPE_DODGE_ANI <- 1



// 스킬 세부발동 조건을 만들어주는 함수입니다.. 발동 조건 state는 이미 소스에서 구현되어 있습니다. 이곳에서 useskill과 setstate를 지정해주면 됩니다.
function checkExecutableSkill_Spincutter(obj)  
{
	if(!obj) return false;
	local b_useskill = obj.sq_IsUseSkill(SKILL_SPINCUTTER);
	if(b_useskill) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(S_SPINCUTTER_THROW); // substate세팅
		obj.sq_IntVectPush(obj.getDirection()); // substate세팅
		obj.sq_addSetStatePacket(STATE_SPINCUTTER, STATE_PRIORITY_IGNORE_FORCE, true);
		return true;
	}	
	
	return false;
}

// 스킬아이콘 활성화 조건을 따지는 함수입니다. true를 리턴하면 스킬 아이콘이 활성화가 됩니다. (발동조건 state는  소스에서 처리됩니다.)
function checkCommandEnable_Spincutter(obj)
{
	if(!obj) return false;
	
	local state = obj.sq_GetSTATE();
	
	if(state == STATE_ATTACK) {
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_SPINCUTTER); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_SPINCUTTER);
	}

	return true;
}

// loop 부분입니다 ismycontrol로 감싸지 않은 연결된 모든 object들이 이곳을 거치게됩니다.
function onProc_spincutter(obj)
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
	
    if(substate == S_SPINCUTTER_THROW) {
    	
		local startT = pAni.GetFrameStartTime(1);
		
		local pushT = pAni.getDelaySum(0, 6);
		local pRope1 = sq_var.get_obj_vector(I_OBJ_VECTOR_ROPE_ANI); // 로프 애니1
		local pRope2 = sq_var.get_obj_vector(I_OBJ_VECTOR_ROPE_DODGE_ANI); // 로프 애니2
		local pRopeAniN = pRope1.getCurrentAnimation();
		local pRopeAniD = pRope2.getCurrentAnimation();
		
		local ropeObjX = pRope1.getXPos();
		
		local len = sq_var.get_vector(1);

    	local delay = obj.sq_getIntData(SKILL_SPINCUTTER, CSI_STAY_TIME) + pushT;    		
    	
    	local rate = 1.0;
    	
    	
		if(currentT > startT  && currentT < delay) {
			//local v = sq_GetAccel(100, len, currentT, delay, true);			
			local v = sq_GetAccel(50, len, currentT, 650, true);
			
			rate = v / 1000.0;
		}
		else if(currentT >= delay) {
			rate = len / 1000.0;
		}
		
		//print("ropeObjX:" + ropeObjX + "obj.getDirection():" + obj.getDirection() + "len:" + len);
		
		pRopeAniN.setImageRate(rate, 1.0);
		pRopeAniD.setImageRate(rate, 1.0);		
		
		local size = sq_GetAniRealImageSize(pRopeAniD, ENUM_DIRECTION_RIGHT);
		local ropeX = sq_GetDistancePos(ropeObjX, obj.getDirection(), size);
		
		local pSickleObj = obj.sq_GetPassiveObject(24101); // sickle 
		
		
		if(pSickleObj) {
			pSickleObj.setCurrentPos(ropeX, posY, posZ);
		}
		
		local pSpincutterObj = obj.sq_GetPassiveObject(24100); // 발사하기 전 스핀커터가 조금씩 앞으로 가는 효과를 연출하자
		
		if(pSpincutterObj) {
			pSpincutterObj.setCurrentPos(ropeX, posY - 1, posZ);		
		}
		
    	if(frmIndex >= 2 && frmIndex < 6) {    		
    		
	    	local flag = sq_var.get_vector(0);
	    	
	    	if(flag == 0) {
	    		local offsetLen = 110;
				local pRope = sq_var.get_obj_vector(I_OBJ_VECTOR_ROPE_DODGE_ANI); // 로프 애니2
				local pRopeAniD = pRope.getCurrentAnimation();
				
				local size = sq_GetAniRealImageSize(pRopeAniD, ENUM_DIRECTION_RIGHT);				
				local distanceL = size + offsetLen;
				
				local state = obj.sq_GetSTATE();
	    		local attack_bonus_rate = obj.sq_getBonusRateWithPassive(SKILL_SPINCUTTER, state, 1 ,1.0);
	    		
	    		local skill = sq_GetSkill(obj, SKILL_SPINCUTTER);
	    		local bonus_rate = sq_GetAttackBonusRate(skill, 1, 1.0);
	    		
				print("\n passive_bonus_rate:" + attack_bonus_rate + " attack_bonus_rate:" + bonus_rate);

				local multiHit = obj.sq_getIntData(SKILL_SPINCUTTER, CSI_SPIN_HIT_COUNT);
	    		
	    		
	    		if(obj.isMyControlObject()) {
					obj.sq_binaryData_startWrite();
					obj.sq_binaryData_writeDword(multiHit);
					obj.sq_binaryData_writeDword(attack_bonus_rate);
		    		
		    		obj.sq_p00_sendCreatePassiveObjectPacket(24100, 0, distanceL, -1, 0);
		    	}
		    	 sq_var.set_vector(0, 1);	
	    	}
    	}
    	else if(frmIndex >= 6) {
	    	local delay = obj.sq_getIntData(SKILL_SPINCUTTER, CSI_STAY_TIME);	    	
    		local currentT = sq_GetCurrentTime(pAni) - pAni.getDelaySum(false);
    		
    		
    		if(obj.isMyControlObject()) {
    			obj.setSkillCommandEnable(SKILL_SPINCUTTER, true);
	    		
    			local iEnterSkill = obj.sq_IsEnterSkill(SKILL_SPINCUTTER);
	    		
    			if(currentT >= delay || iEnterSkill != -1) { // 스핀커터 recall 발동
    				local flag = sq_var.get_vector(2);
	    			
    				if(!flag) {
						sq_var.set_vector(2,1);
						
						obj.sq_IntVectClear();
						obj.sq_IntVectPush(S_SPINCUTTER_RECALL);
						obj.sq_IntVectPush(obj.getDirection()); // substate세팅
						obj.sq_addSetStatePacket(STATE_SPINCUTTER, STATE_PRIORITY_USER, true);
    				}
    			}
    		}
    	}
		
		
    }
    else if(substate == S_SPINCUTTER_RECALL) {
    }
    else if(substate == S_SPINCUTTER_ARRIVAL) {
    }	
	
}

// loop 부분입니다 ismycontrol 호스트가 본인이 object가 이곳을 들어갑니다. setstate 세팅이나 패시브오브젝트 생성 , 등등 처리합니다.
function onProcCon_spincutter(obj)
{
	if(!obj) return;
	local pAni = obj.sq_getCurrentAni();
	local bEnd = obj.sq_ani_IsEnd(pAni);
    local frmIndex = obj.sq_ani_GetCurrentFrameIndex(pAni);
	local sq_var = obj.getVar();
	//

    local subState = obj.getSkillSubState();
        
    if(subState == S_SPINCUTTER_RECALL) {
    }
    else if(subState == S_SPINCUTTER_ARRIVAL) {
    }

	if(bEnd) {
	    if(subState == S_SPINCUTTER_THROW) {
	    	
	    }
	    else if(subState == S_SPINCUTTER_RECALL) {
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(S_SPINCUTTER_ARRIVAL);
			obj.sq_IntVectPush(obj.getDirection()); // substate세팅
			obj.sq_addSetStatePacket(STATE_SPINCUTTER, STATE_PRIORITY_USER, true);
	    }
	    else if(subState == S_SPINCUTTER_ARRIVAL) {
			obj.sq_addSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	    }
	}
}

// state종료와 동시에 한번 호출되는 함수입니다. oldstate가 종료되는 state입니다. 무언가 발사된것이 있거나 종료처리될것이 있다면 이곳에서 처리합니다.
function onEndState_spincutter(obj, new_state)
{
	if(!obj) return;
	if(new_state != STATE_SPINCUTTER) {
		local sq_var = obj.getVar();
		local pRope1 = sq_var.get_obj_vector(I_OBJ_VECTOR_ROPE_ANI); // 로프 애니1
		local pRope2 = sq_var.get_obj_vector(I_OBJ_VECTOR_ROPE_DODGE_ANI); // 로프 애니2
		
		if(pRope1) {
			pRope1.setValid(false);
		}
		if(pRope2) {
			pRope2.setValid(false);
		}	
	}
}

// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_spincutter(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	local sq_var = obj.getVar();
	local substate = obj.sq_getVectorData(datas, 0); // 첫번째 substate입니다..	
	local direction = obj.sq_getVectorData(datas, 1); // 첫번째 substate입니다..	
	obj.setSkillSubState(substate); //set substate
	obj.sq_stopMove();
	
    
	sq_var.clear_vector();
	//sq_var.clear_obj_vector();
	
	sq_var.push_vector(0);
	
	local len = obj.sq_getIntData(SKILL_SPINCUTTER, CSI_THROW_LEN);
	sq_var.push_vector(len);
	sq_var.push_vector(0);
	
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();
	
	
    if(substate == S_SPINCUTTER_THROW) {
		sq_var.clear_ani_vector(); // 애니메이션 벡터를 삭제한다..
	
		obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_SPINCUTTER); //   	

		local firstAttackRate = obj.sq_getBonusRateWithPassive(SKILL_SPINCUTTER, state, 0, 1.0);    		
		local skill = sq_GetSkill(obj, SKILL_SPINCUTTER);
		local bonus_rate = sq_GetAttackBonusRate(skill, 0, 1.0);
		
		print("\n state:" + state + " first_passive_bonus_rate:" + firstAttackRate + " first_attack_bonus_rate:" + bonus_rate);
		
		obj.sq_setCurrentAttackBonusRate(firstAttackRate);
		
		
		/////////////////////////////////////////////
		if(obj.isMyControlObject()) {
			obj.sq_binaryData_startWrite();
			obj.sq_binaryData_writeDword(firstAttackRate);
		    
			obj.sq_p00_sendCreatePassiveObjectPacket(24101, 0, 0, 0, 0);
		}
	    ///////////////////////////////////////////////
		
    	
    	
		obj.sq_setCurrentAnimation(CUSTOM_ANI_SPINCUTTER1);
		local pAni = obj.sq_getCurrentAni();
		
		local pRopeNormal = obj.sq_createCNRDAnimation("Effect/Animation/Spincutter/throw/4_rope_normal_0.ani");
		local pRopeDodge = obj.sq_createCNRDAnimation("Effect/Animation/Spincutter/throw/5_rope_dodge_0.ani");

		
		//local pSickleAni = obj.sq_createCNRDAnimation("Effect/Animation/Spincutter/throw/sickle/2_sickle_00_normal.ani");		
		
		
		pRopeNormal.setImageRate(0.1, 1.0);
		pRopeDodge.setImageRate(0.1, 1.0);
		
		local offsetLen = 101;
		
		local ropeX = sq_GetDistancePos(posX, direction, offsetLen);
		
		local pPooledObj = obj.sq_createCNRDPooledObject(pRopeNormal, false);
		local pRopeDogeObj = obj.sq_createCNRDPooledObject(pRopeDodge, false);		
		//local pSickleObj = obj.sq_createCNRDPooledObject(pSickleAni, false);
			
		
		pPooledObj.setCurrentDirection(direction);
		pRopeDogeObj.setCurrentDirection(direction);
		//pSickleObj.setCurrentDirection(direction);
		
		pPooledObj.setCurrentPos(ropeX, posY, posZ);
		pRopeDogeObj.setCurrentPos(ropeX, posY, posZ);		
		
		sq_var.clear_obj_vector();
		sq_var.push_obj_vector(pPooledObj);
		sq_var.push_obj_vector(pRopeDogeObj);
		//sq_var.push_obj_vector(pSickleObj);
		
		obj.sq_AddObject(pPooledObj);
		obj.sq_AddObject(pRopeDogeObj);
		//obj.sq_AddObject(pSickleObj);
		
		local size = sq_GetAniRealImageSize(pRopeDodge, direction);
		//pSickleObj.setCurrentPos(ropeX + size, posY, posZ);
    }
    else if(substate == S_SPINCUTTER_RECALL) {
		obj.sq_setCurrentAnimation(CUSTOM_ANI_SPINCUTTER2);
		
		local pA = obj.sq_getCurrentAni();
		obj.sq_setAnimationSpeedRate(pA, 120.0);
		
		local pRope1 = sq_var.get_obj_vector(I_OBJ_VECTOR_ROPE_ANI); // 로프 애니1
		local pRope2 = sq_var.get_obj_vector(I_OBJ_VECTOR_ROPE_DODGE_ANI); // 로프 애니2
		
		if(pRope1) {
			pRope1.setValid(false);
		}
		if(pRope2) {
			pRope2.setValid(false);
		}	  
		
    }
    else if(substate == S_SPINCUTTER_ARRIVAL) {
		obj.sq_setCurrentAnimation(CUSTOM_ANI_SPINCUTTER3);
    }
    
}

// irdcharacter에서  setstate() -> IRDActiveObject::setState -> aftersetstate() 이런순서에서 마지막 setstate입니다. skill특성에 따라서 호출할 필요가 
// 있다면 이 함수를 이용합니다.

function onAfterSetState_spincutter(obj, state, datas, isResetTimer)
{
	if(!obj) return;
}

// onbeforeattack 콜백함수 입니다
function onBeforeAttack_spincutter(obj, damager, boundingBox)
{
	
}

// onAttack 콜백함수 입니다
function onAttack_spincutter(obj, damager, boundingBox)
{
	
}

// onAfterAttack 콜백함수 입니다
function onAfterAttack_spincutter(obj, damager, boundingBox)
{
	
}

// onBeforeDamage 콜백함수 입니다
function onBeforeDamage_spincutter(obj, attacker, boundingBox)
{
	
}

// onDamage 콜백함수 입니다
function onDamage_spincutter(obj, attacker, boundingBox)
{
	
}

// onAfterDamage 콜백함수 입니다
function onAfterDamage_spincutter(obj, attacker, boundingBox)
{
	
}


