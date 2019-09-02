
// sub state
//S_FASTMOVE_PLAY <- 0
//S_FASTMOVE_LOOP <- 1
//S_FASTMOVE_PRO <- 2
//S_FASTMOVE_END <- 3
//

// sub state
S_AWAKENING_0 <- 0
S_AWAKENING_1 <- 1
S_AWAKENING_2 <- 2
S_AWAKENING_3 <- 3

// 스태틱 데이타 인덱스
FM_SI_C_TIME <- 0  // 회전 후 톱날이 완전 생성되는 시간
FM_SI_MULTI_HIT_COUNT <- 1 // 다단히트 간격
FM_SI_MOVE_VEL <- 2 // 톱날 이동속도

// 레벨인포 인덱스
FM_LI_HIT_RATE <- 0 // 톱날 히트 데미지(%)
FM_LI_MOVE_LEN <- 1 // 이동거리 (px)

VECTOR_I_SRC_X <- 0 // 시작지점을 저장한 벡터 인덱스




// 스킬 세부발동 조건을 만들어주는 함수입니다.. 발동 조건 state는 이미 소스에서 구현되어 있습니다. 이곳에서 useskill과 setstate를 지정해주면 됩니다.
function checkExecutableSkill_Awakening(obj)  
{
	if(!obj) return false;
	local b_useskill = obj.sq_IsUseSkill(SKILL_AVENGER_AWAKENING);
	if(b_useskill) {
		//print("\n sq_getSendState:" + obj.sq_getSendState()); // 여기서 -1이 아니라면 스킬이 씹히게 됩니다..
		//
		//if(obj.sq_getSendState() != -1) {
			//print("\n warning warning skill skip :" + obj.sq_getSendState()); // 여기서 -1이 아니라면 스킬이 씹히게 됩니다..
			//print("\n warning warning skill skip :" + obj.sq_getSendState()); // 여기서 -1이 아니라면 스킬이 씹히게 됩니다..
			//print("\n warning warning skill skip :" + obj.sq_getSendState()); // 여기서 -1이 아니라면 스킬이 씹히게 됩니다..
		//}
		
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(S_AWAKENING_0); // substate세팅
		obj.sq_addSetStatePacket(STATE_AVENGER_AWAKENING, STATE_PRIORITY_USER, true);
		return true;
	}	
	
	return false;
}

// 스킬아이콘 활성화 조건을 따지는 함수입니다. true를 리턴하면 스킬 아이콘이 활성화가 됩니다. (발동조건 state는  소스에서 처리됩니다.)
function checkCommandEnable_Awakening(obj)
{
	if(!obj) return false;
	
	if(obj.getVar("takingAwakenSkillBack").size_vector() == 0) {
		obj.getVar("takingAwakenSkillBack").push_vector(0);
		obj.getVar("takingAwakenSkillBack").push_vector(0);
	}
	
	local var_takingAwakenSkillBack = obj.getVar("takingAwakenSkillBack").get_vector(0);
	
	local bRet = false;
	
	if(!var_takingAwakenSkillBack)
		bRet = true;
	else {
		obj.getVar("takingAwakenSkillBack").set_vector(0, 0);
		bRet = false;
	}
	
	return bRet;
}

// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_Awakening(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	local substate = obj.sq_getVectorData(datas, 0); // 첫번째 substate입니다..	
	obj.setSkillSubState(substate); //set substate
	obj.sq_stopMove();	
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();
	local sq_var = obj.getVar();
	
	local skill_level = sq_GetSkillLevel(obj, SKILL_AVENGER_AWAKENING);
	
   	obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_FASTMOVE);
   	
	//local attack_rate = obj.sq_getSkillAttackBonusRate(SKILL_SPINCUTTER, FM_LI_HIT_RATE);    		
	//obj.sq_setCurrentAttackBonusRate(attack_rate);
   	//
    if(substate == S_AWAKENING_0) {
		//local time = obj.sq_getIntData(SKILL_AVENGER_AWAKENING, FM_SI_C_TIME);
		//obj.sq_var.push_vector(time);
		//obj.sq_var.push_vector(0);
		sq_var.clear_vector();
		sq_var.clear_obj_vector();
		sq_var.clear_ani_vector();
		sq_var.push_vector(0);
		
		obj.sq_setCurrentAnimation(CUSTOM_ANI_AVENGER_AWAKENING1);
    }
    else if(substate == S_AWAKENING_1) {
		//.func(&CSQStateVar::clear_ani_vector, NTEXT("clear_ani_vector"))
		//.func(&CSQStateVar::push_ani_vector, NTEXT("push_ani_vector"))
		//local bodyN = obj.sq_var.GetAnimationMap("2_body_normal","Effect/Animation/Awakening/Transform/01/2_body_normal.ani");
		local p_body_normal_ani = obj.sq_createCNRDAnimation("Effect/Animation/Awakening/Transform/01/2_body_normal.ani");
		sq_var.push_ani_vector(p_body_normal_ani);
		sq_var.push_vector(0);
		obj.sq_setCurrentAnimation(CUSTOM_ANI_AVENGER_AWAKENING2);
    }
    else if(substate == S_AWAKENING_2) {
		local dstZ = sq_var.get_vector(0);
		obj.setCurrentPos(posX, posY, dstZ);
		
		obj.sq_setCurrentAnimation(CUSTOM_ANI_AVENGER_AWAKENING3);
		
		// 어펜디지 로딩 map으로 푸시 skill파일에서 시간 기타등등 정보 입력
		//
		local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_AVENGER_AWAKENING, false, "Appendage/Character/ap_avenger_awakening.nut", false);
		
		local change_time = sq_GetLevelData(obj, SKILL_AVENGER_AWAKENING, SL_CHANGE_TIME, skill_level);
		
		appendage.sq_SetValidTime(change_time); // 어펜디지 타임 세팅
		
		// 버프 UI 출력 어펜드를 걸어주기 전에 호출되어야 합니다..
		appendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, sq_getJob(obj), SKILL_AVENGER_AWAKENING, skill_level);
		//
		
		// 여기서 append 작업		
		CNSquirrelAppendage.sq_Append(appendage, obj, obj);
		//		
		
		// Awakening.skl 스킬레벨 테이블
		//SL_PERFECT_CHANGE_HP <- 0 // (0) 완전 변신체 HP 
		//SL_CHANGE_TIME <- 1 // (1) 지속시간 
		//SL_DEF_INC <- 2 // (2) 방어력증가(+)
		//SL_ATK_SPD <- 3 // (3) 공격속도(+)
		//SL_MOV_SPD <- 4 // (4) 이동속도(+)
		//SL_1_HIT_MAGIC_ATK <- 5 // (5) 1타 마법공격력(+)
		//SL_2_HIT_MAGIC_ATK <- 6 // (6) 2타 마법공격력(+)
		//SL_3_HIT_MAGIC_ATK <- 7 // (7) 3타 마법공격력(+)
		//SL_DASH_MAGIC_ATK <- 8 // (8) 대시 마법공격력(+)
		//SL_JUMP_MAGIC_ATK <- 9 // (9) C(점프) 마법공격력(+)		
		
		// 공속증가, 암속성 저항증가, 명속성 저항감소
		if(appendage) {
		
			local dooms_hp = sq_GetLevelData(obj, SKILL_AVENGER_AWAKENING, SL_PERFECT_CHANGE_HP, skill_level);
			
			local def_inc = sq_GetLevelData(obj, SKILL_AVENGER_AWAKENING, SL_DEF_INC, skill_level);
			local atk_spd = sq_GetLevelData(obj, SKILL_AVENGER_AWAKENING, SL_ATK_SPD, skill_level);
			local mov_spd = sq_GetLevelData(obj, SKILL_AVENGER_AWAKENING, SL_MOV_SPD, skill_level);
			
			// 버프 UI 출력
			appendage.setAppendCauseSkill(2, sq_getJob(obj), SKILL_AVENGER_AWAKENING, skill_level);

			//
			
			appendage.sq_var.clear_vector();		
			appendage.sq_var.push_vector(change_time); // 지속시간
			
			
			
			local awakening_var = obj.getVar("awakening");
			awakening_var.clear_ct_vector();
			awakening_var.push_ct_vector();
			
			awakening_var.get_ct_vector(0).Reset();
			awakening_var.get_ct_vector(0).Start(0,0);
			
			
			if(awakening_var.size_vector() == 0) { // 타이머로 쓰일 멤버
				awakening_var.push_vector(0);
			}
			else {
				awakening_var.set_vector(0, 0);
			}
			
				
			// 둠스가디언 hp세팅
			local convert_rate = sq_GetAbilityConvertRate(obj, CONVERT_TABLE_TYPE_HP)
			local dooms_con_hp = dooms_hp.tofloat() * convert_rate.tofloat();
			appendage.sq_var.push_vector(dooms_con_hp.tointeger()); // 완전 변신체 HP 
			///////		
			
			appendage.sq_var.push_vector(1); // index 2 
			// 리얼 밸리드 플래그로 쓸 멤버입니다.. 왜 이런식이 됐냐면.. 
			// 어벤저가 state_stand상태에서만 변신해제가 되어야 합니다 
			// 그래서 valid가 false가 된다고 해서 곧장 변신해제 됐다고 간주해서는 안됩니다 여러방법을 생각해낸 결과 이 방법이 가장 깔끔할거 같아서 입니다.. 
			// 머 쓰이는 곳도 없으니까
			
			local change_appendage = appendage.sq_getChangeStatus("changeStatus");
			
			if(!change_appendage)
				change_appendage = appendage.sq_AddChangeStatus("changeStatus",obj, obj, change_time, CHANGE_STATUS_TYPE_ATTACK_SPEED, true, atk_spd);
			
			if(change_appendage) {
				change_appendage.clearParameter();
				change_appendage.addParameter(CHANGE_STATUS_TYPE_EQUIPMENT_PHYSICAL_DEFENSE, false, def_inc.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_EQUIPMENT_MAGICAL_DEFENSE, false, def_inc.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_ATTACK_SPEED, false, atk_spd.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_MOVE_SPEED, false, mov_spd.tofloat());
				
			}
			
			///////////////////////////////////////////////////////////////////
			// _C_2011_PASSIVE_SKILL_UPGRADE_OCTOBER_
			// 악마화 변경 악마화상태의 hP를 자신의 HP와 공유하도록 변경됩니다.
			local hpmaxup_appendage = appendage.sq_getHpMaxUp("HpMaxUp");
			
			if(!hpmaxup_appendage)
				hpmaxup_appendage = appendage.sq_AddHpMaxUp("HpMaxUp",obj, obj, change_time, dooms_hp, 0);
			///////////////////////////////////////////////////////////////////
			
		}
		//appendage.sq_AddChangeStatus("2",obj, obj, 0, CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_DARK, false, dark_element);
		//appendage.sq_AddChangeStatus("3",obj, obj, 0, CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_LIGHT, false, light_element);

		// 여기에서 변신 동작 애니메이션 로딩 map으로 푸시
		//
		
		//obj.sq_var.push_vector(posX); // 벡터 인덱스 1
    }
    else if(substate == S_AWAKENING_3) {
		obj.getVar().clear_vector();
    	obj.getVar().push_vector(posZ); // 벡터 인덱스 1
    	obj.getVar().push_vector(0); // 지진 플래그
    	obj.getVar().set_vector(1, 0);
    	
    	obj.getVar().get_vector(0); // 벡터 인덱스 1    	

    	
		//DWORD rgb = obj.sq_getRGB(0,0,0);
		obj.sq_bottomcreateFlash(0, 240, 280, 150, 0);
    	
		//obj.sq_setCurrentAnimation(CUSTOM_ANI_AVENGER_AWAKENING4);
		local awakening_ani = obj.getVar().GetAnimationMap("Awakening4", "Character/Priest/Animation/Awakening4.ani"); // 스킨아바타 때문에 외부에서 애니메이션을 가지고 와야 합니다..
		obj.setCurrentAnimation(awakening_ani);
		
		// 구형..등록
		local ch_ld_0_ani = obj.sq_createCNRDAnimation("Effect/Animation/Awakening/Transform/03/1_change_light_dodge_00.ani"); // 구형 플립형이라서 따로 추가해줘야합니다..		
		local p_change_light_obj = obj.sq_createCNRDPooledObject(ch_ld_0_ani, true);		
		if(p_change_light_obj) {
			// 15 -2 75
			local dstX = sq_GetDistancePos(posX, obj.getDirection(), 15);
			p_change_light_obj.setCurrentPos(dstX, posY - 2, posZ + 75);
			obj.sq_AddObject(p_change_light_obj);
		}
		
		// 9레벨 이상이면	
		if(obj.isOverSkillLevel(SKILL_AVENGER_AWAKENING, 4))
		{
			obj.endSkillCoolTime(SKILL_PANDEMONIUM_EX);
			obj.endSkillCoolTime(SKILL_EX_DISASTER);
			
		}
    }
	
    
}


// prepareDraw 함수 입니다..
function prepareDraw_Awakening(obj)
{
	if(!obj) return;
}


// loop 부분입니다 ismycontrol로 감싸지 않은 연결된 모든 object들이 이곳을 거치게됩니다.
function onProc_Awakening(obj)
{
	if(!obj) return;
	local substate = obj.getSkillSubState();
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();
	
	local pAni = obj.sq_getCurrentAni();
    local frmIndex = obj.sq_ani_GetCurrentFrameIndex(pAni);

	local currentT = sq_GetCurrentTime(pAni);
	local sq_var = obj.getVar();
	
//S_AWAKENING_0 <- 0
//S_AWAKENING_1 <- 1
//S_AWAKENING_2 <- 2
//S_AWAKENING_3 <- 3

	//print("substate:" + substate);
	
    if(substate == S_AWAKENING_0) {		
    }
    else if(substate == S_AWAKENING_1) {
    	//local time = obj.sq_getIntData(SKILL_AVENGER_AWAKENING, FM_SI_C_TIME); // 톱날이 완전 생성되는 시간..
    	//local time = 1600; // 톱날이 완전 생성되는 시간..
    	local time = 1200; // 톱날이 완전 생성되는 시간..
    	
    	local up_t = time;
    	local up_l = 40;
    	
    	local move_l = 0;
    	
		move_l = sq_GetAccel(0, up_l, currentT, up_t, true);

   		obj.setCurrentPos(posX, posY, move_l);
	
    	if(move_l >= up_l) {
    	
			local body_n_ani = sq_var.get_ani_vector(0);

			
	   		local b_body_n = sq_var.get_vector(1); //
	   		//// 만약에 효과가 추가되어 있지 않았다면..			
	   		if(!b_body_n) {
				pAni.addLayerAnimation(10010, body_n_ani, true);
				sq_var.set_vector(1, 1);
			}
			
			
			local bEnd = sq_IsEnd(body_n_ani);
			local index_bodyani = obj.sq_ani_GetCurrentFrameIndex(body_n_ani);
			local body_currentT = sq_GetCurrentTime(body_n_ani);
			
		    //print("proc substate:" + substate + "  index_bodyani:" + index_bodyani + " b_body_n:" + b_body_n);
		    
			if(bEnd == true) {    	
				local backlight_dodge_obj = pAni.getLastAlsObject();
				//print("backlight_dodge_obj:" + backlight_dodge_obj);

				
				//if(backlight_dodge_obj) {
						//print("setValid:" + backlight_dodge_objj);
						//backlight_dodge_obj.setValid(false);
				//}
	    	
				sq_var.set_vector(0, move_l); // 마지막 프레임의 높이를 푸시한다..
								
				if(obj.isMyControlObject()) {
					//obj.sq_IntVectClear();
					//obj.sq_IntVectPush(S_AWAKENING_2);
					//obj.sq_addSetStatePacket(STATE_AVENGER_AWAKENING, STATE_PRIORITY_USER, true);
					//local backlight_dodge = obj.sq_getAutoLayerWorkAnimation(pAni, "1_e_bl_d");
						//pAni.removeLayerAnimation(backlight_dodge);
						
					
					obj.sq_IntVectClear();
					obj.sq_IntVectPush(S_AWAKENING_2);
					obj.sq_addSetStatePacket(STATE_AVENGER_AWAKENING, STATE_PRIORITY_USER, true);
					//obj.sq_addSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);					
				}
			}
		}
		else {
	
			if(move_l >= (up_l - 10)) {
		   		local b_body_n = sq_var.get_vector(1); //
		   		if(!b_body_n) {
					//local bodyN = sq_var.GetAnimationMap("2_body_normal","Effect/Animation/Awakening/Transform/01/2_body_normal.ani");
					local body_n_ani = sq_var.get_ani_vector(0);
					pAni.addLayerAnimation(10010, body_n_ani, true);
					sq_var.set_vector(1, 1);
				}
			}
    		//pAni.addLayerAnimation()
    		//addLayerAnimation(
    	}
    }
    else if(substate == S_AWAKENING_2) {
		local dstZ = sq_var.get_vector(0);
		
    	local up_t = pAni.getDelaySum(false); //
    	local up_l = 3;
    	
    	local move_l = 0;
    	
		move_l = sq_GetAccel(0, up_l, currentT, up_t, false);

   		obj.setCurrentPos(posX, posY, dstZ + move_l);
		
    }
    else if(substate == S_AWAKENING_3) {  // 변신이 된 상태..	
		
		local fIndex = 2;
		local delay = pAni.getDelaySum(0, fIndex); //
		local down_t = 120; // 
		
		if(frmIndex > fIndex && (delay + down_t) >= currentT) {
			local dstZ = obj.getVar().get_vector(0);
    		//local down_t = 180; // 
    		local move_l = 0;
    		
    		
	    	
			move_l = sq_GetAccel(dstZ, 0, currentT - delay, down_t, false);
			
			local t = currentT - delay;
    		
   			obj.setCurrentPos(posX, posY, move_l);
   		}
   		else if(frmIndex <= fIndex) {
			local dstZ = obj.getVar().get_vector(0);
   			obj.setCurrentPos(posX, posY, dstZ);   			
   		}
   			
		if(obj.getVar().get_vector(1) == 0 && obj.getZPos() == 0 && (delay + down_t) < currentT) { // 지진 플래그
			//sq_SetMyShake(obj,4,1000);
			
 			
			obj.sq_setShake(obj, 2, 500);			

			// 충격파 발생			
			local p_shockwave_ani = obj.sq_createCNRDAnimation("Effect/Animation/Awakening/Transform/03/sub_dodge.ani");
			local p_obj_1 = obj.sq_createCNRDPooledObject(p_shockwave_ani, true);			
			p_obj_1.setCurrentDirection(obj.getDirection());
			
			local v = 25;
			local dstX = sq_GetDistancePos(posX, obj.getDirection(), v);
			
			p_obj_1.setCurrentPos(dstX, posY - 1, 0);
			obj.sq_AddObject(p_obj_1);
			
			
			local p_shock_ani = obj.sq_createCNRDAnimation("Effect/Animation/Awakening/Transform/03/5_crack_normal.ani");
			local p_obj_2 = obj.sq_createCNRDPooledObject(p_shock_ani, true);
			
			p_obj_2.setCurrentDirection(obj.getDirection());
			p_obj_2.setCurrentPos(posX, posY + 1, 0);
			obj.sq_AddObject(p_obj_2);
			
			obj.getVar().set_vector(1, 1);				
		} 		
   		
   		
    }
	
	
}

// loop 부분입니다 ismycontrol 호스트가 본인이 object가 이곳을 들어갑니다. setstate 세팅이나 패시브오브젝트 생성 , 등등 처리합니다.
function onProcCon_Awakening(obj)
{
	if(!obj) return;
	local pAni = obj.sq_getCurrentAni();
	local bEnd = obj.sq_ani_IsEnd(pAni);
    local frmIndex = obj.sq_ani_GetCurrentFrameIndex(pAni);
	
    local substate = obj.getSkillSubState();

    if(substate == S_AWAKENING_0) {
    }
    else if(substate == S_AWAKENING_1) {
    }
    else if(substate == S_AWAKENING_2) {
    }
    else if(substate == S_AWAKENING_3) {
    }
    

	if(obj.getVar("takingAwakenSkillBack").size_vector() > 0) {	
		if(obj.getVar("takingAwakenSkillBack").get_vector(0)) {		
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(0); // substate세팅
			obj.sq_addSetStatePacket(STATE_AWAKENING_TURN_OFF, STATE_PRIORITY_IGNORE_FORCE, true);
			return;
		}
	}
    
        
        
        
	if(bEnd) {
		if(substate == S_AWAKENING_0) {
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(S_AWAKENING_1);
			obj.sq_addSetStatePacket(STATE_AVENGER_AWAKENING, STATE_PRIORITY_USER, true);
		}
		else if(substate == S_AWAKENING_1) {
		}
		else if(substate == S_AWAKENING_2) {
			//obj.sq_addSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(S_AWAKENING_3);
			obj.sq_addSetStatePacket(STATE_AVENGER_AWAKENING, STATE_PRIORITY_USER, true);
		}
		else if(substate == S_AWAKENING_3) {
			obj.sq_addSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
		}
	}
}

// irdcharacter에서  setstate() -> IRDActiveObject::setState -> aftersetstate() 이런순서에서 마지막 setstate입니다. skill특성에 따라서 호출할 필요가 
// 있다면 이 함수를 이용합니다.

function onAfterSetState_Awakening(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
}

// onbeforeattack 콜백함수 입니다
function onBeforeAttack_Awakening(obj, damager, boundingBox)
{
	
}

// onAttack 콜백함수 입니다
function onAttack_Awakening(obj, damager, boundingBox)
{
	
}

// onAfterAttack 콜백함수 입니다
function onAfterAttack_Awakening(obj, damager, boundingBox)
{
	
}

// onBeforeDamage 콜백함수 입니다
function onBeforeDamage_Awakening(obj, attacker, boundingBox)
{
	
}

// onDamage 콜백함수 입니다
function onDamage_Awakening(obj, attacker, boundingBox)
{
	
}

// onAfterDamage 콜백함수 입니다
function onAfterDamage_Awakening(obj, attacker, boundingBox)
{
	
}


