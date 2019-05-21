

// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_AvengerAttack(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	if(isAvengerAwakenning(obj) == false) {
		obj.getVar().clear_vector();

		obj.getVar().push_vector(0); // 0번인덱스
		obj.getVar().push_vector(0); // 1번인덱스
		obj.getVar().push_vector(0);// 2번인덱스
		obj.getVar().push_vector(0);// 3번인덱스
		obj.getVar().push_vector(0);// 4번인덱스
		
		if(obj.getAttackIndex() == 0)
		{
			obj.setAttackXVelocity(100);
			obj.setAttackXAccel(-300);
			obj.setAttackXVelocityFast(200);
			obj.setAttackXAccelFast(-300);	
		}

		if(obj.getAttackIndex() == 1) { //
			obj.setAttackXVelocity(50);
			obj.setAttackXAccel(-300);
			obj.setAttackXVelocityFast(50);
			obj.setAttackXAccelFast(-300);	
		}		
		
		if(obj.getAttackIndex() == 2) { //
			obj.setAttackXVelocity(20);
			obj.setAttackXAccel(-300);
			obj.setAttackXVelocityFast(50);
			obj.setAttackXAccelFast(-30);
		}
		if(obj.getAttackIndex() == 3) 
		{ //

		}
		return;
	}
	
	obj.sq_stopMove();

	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();	
	local dir = sq_GetDirection(obj);

	obj.getVar().clear_vector();
	obj.getVar().push_vector(0);
	
	obj.setAttackXVelocity(0);
	obj.setAttackXAccel(0);
	obj.setAttackXVelocityFast(0);
	obj.setAttackXAccelFast(0);
	
	
}


function onAfterSetState_AvengerAttack(obj, state, datas, isResetTimer)
{
	if(!obj) return;
	
	if(isAvengerAwakenning(obj) == false) {
		return;
	}
		
	print("	onAfterSetState_AvengerAttack obj.getAttackIndex():" + obj.getAttackIndex());
	
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
	

	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();	
	local dir = sq_GetDirection(obj);
	local power = 0;


	if(obj.getAttackIndex() == 0) { // 각성 변신상태 기본 공격 마지막이라면..			
		local v = 5;
		local dstX = sq_GetDistancePos(posX, obj.getDirection(), v);
		
		if(obj.isMovablePos(dstX, posY)) {
			obj.setCurrentPos(dstX, posY, posZ);
		}
		
		obj.setAttackXVelocity(50);
		obj.setAttackXAccel(-300);
		obj.setAttackXVelocityFast(100);
		obj.setAttackXAccelFast(-300);

			//print("	sqr_CreatePooledObject 4_dust_normal.ani");
		sqr_CreatePooledObject(obj, "Effect/Animation/Awakening/attack/attack1/4_dust_normal.ani", posX, posY + 1, posZ, dir);

	}		
	if(obj.getAttackIndex() == 1) { // 각성 변신상태 기본 공격 마지막이라면..			
		obj.getVar().push_vector(0);
		
		obj.getVar().push_vector(0);
		obj.getVar().push_vector(0);
		
			//print("	sqr_CreatePooledObject 4_dust_normal_0.ani");
			//print("	sqr_CreatePooledObject 4_dust_normal_1.ani");
			
		sqr_CreatePooledObject(obj, "Effect/Animation/Awakening/attack/attack2/4_dust_normal_0.ani", posX, posY + 1, posZ, dir);
		sqr_CreatePooledObject(obj, "Effect/Animation/Awakening/attack/attack2/4_dust_normal_1.ani", posX, posY + 1, posZ, dir);
	}		
	if(obj.getAttackIndex() == 2) { // 각성 변신상태 기본 공격 마지막이라면..
		obj.getVar().push_vector(0);
		obj.getVar().push_vector(0);
		obj.getVar().push_vector(0);
	}
	if(obj.getAttackIndex() == 3) { // 각성 변신상태 기본 공격 마지막이라면..
		obj.getVar().push_vector(0); 
		obj.getVar().push_vector(0); // 2번 플래그 충전중인지 아닌지 판단하는 플래그
		obj.getVar().push_vector(0);
	}
	
	if(obj.getAttackIndex() == 4) { // 각성 변신상태 기본 공격 마지막이라면..
		obj.getVar().push_vector(0); 
		obj.getVar().push_vector(0); // 2번 플래그 충전중인지 아닌지 판단하는 플래그
		obj.getVar().push_vector(0);
	}

	
	// 각성패시브 : 악몽(48레벨)
	// 1. 각성 변신 동안 각성기 공격력이 증가함
	// 2. 데빌 스트라이커의 악마 게이지 차는량 증가.
	// 각성패시브 악몽을 갖고 있는지 체크하고 갖고 있다면 악마 게이지 차는량을 증가시켜서 리턴합니다..	
	
	if(obj.getAttackIndex() < 3) {
		obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_AW_ATTACK1 + obj.getAttackIndex());
		// 
		
		local rate = obj.sq_getPassiveAttackRate(0, state, 1.0);
		
	    //print("sq_getPassiveAttackRate:" + rate.tofloat());
	    
	    power = obj.sq_getBonusRateWithPassive(SKILL_AVENGER_AWAKENING, state, SL_1_HIT_MAGIC_ATK + obj.getAttackIndex(),1.0);	
	    
		//local before_power = obj.sq_getSkillPower(SKILL_AVENGER_AWAKENING, SL_1_HIT_MAGIC_ATK + obj.getAttackIndex());
		
		
	    //print("before CUSTOM_ATTACKINFO_AW_ATTACK1:" + before_power);
	    //print("CUSTOM_ATTACKINFO_AW_ATTACK1:" + power);
	}
	
	if(obj.getAttackIndex() >= 4)
	{ // 어벤저 - 둠스가디언 막타 공격력 충전에 따라 차이를 보입니다..
		obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_AW_ATTACK4);
		//power = obj.sq_getSkillPower(SKILL_AVENGER_AWAKENING, SL_JUMP_MAGIC_ATK);
		
	    //power = obj.sq_getPowerWithPassive(SKILL_AVENGER_AWAKENING,SL_1_HIT_MAGIC_ATK + obj.getAttackIndex(),-1,1.0);	
	    //print("CUSTOM_ATTACKINFO_AW_ATTACK4:" + power);
	    
	    ///////////////////////////////////
		local chargeTime = sq_GetIntData(obj, SKILL_AVENGER_AWAKENING, 0); //점프 마법 공격 최대 충전시간
		
		//local level = sq_GetSkillLevel(obj, SKILL_AVENGER_AWAKENING);		
		//local AtkAdd = sq_GetLevelData(obj, SKILL_AVENGER_AWAKENING, SL_JUMP_MAGIC_ATK, level);		
		//local fullchargeAtkAdd = sq_GetLevelData(obj, SKILL_AVENGER_AWAKENING, SL_JUMP_FULLCHARGE_MAGIC_ATK, level);				
		//local offset = fullchargeAtkAdd - AtkAdd; // 풀충전 공격력과 기본 공격력 사이의 offset값을 구해낸다..				
		//local stateTimer = obj.getStateTimer();
		
	    local basePower = obj.sq_getBonusRateWithPassive(SKILL_AVENGER_AWAKENING, state, SL_JUMP_MAGIC_ATK,1.0);
	    local maxPower = obj.sq_getBonusRateWithPassive(SKILL_AVENGER_AWAKENING, state, SL_JUMP_FULLCHARGE_MAGIC_ATK,1.0);

		local stateTimer = obj.sq_getVectorData(datas, 1); // 첫번째 substate입니다..	

		local resultPower = sq_GetUniformVelocity(basePower, maxPower, stateTimer, chargeTime); // 충전값
		
		// 특정레벨 이상일경우 무조건 맥스 파워
		if(obj.isOverSkillLevel(SKILL_AVENGER_AWAKENING, 3))
			resultPower = maxPower;
			
		power = resultPower;
		
		//print("stateTimer:" + stateTimer + " chargeTime:" + chargeTime);
		print("basePower:" + basePower + " maxPower:" + maxPower + " resultPower:" + resultPower + " timer:" + stateTimer);	
	    //////////////////////////////////
	    
		local awakening_var = obj.getVar("awakening");
		awakening_var.get_ct_vector(0).Reset();
		awakening_var.get_ct_vector(0).Start(0,0);
		
		local cooltime = getLoadSkillEnableTime(obj, SKILL_AVENGER_AWAKENING, 1); // 디폴트 쿨타임
		awakening_var.set_vector(0, cooltime); // 쿨타임세팅
		
	}
		
	obj.sq_setCurrentAttackBonusRate(power);
}


// prepareDraw 함수 입니다..
function prepareDraw_AvengerAttack(obj)
{
}


// loop 부분입니다 ismycontrol로 감싸지 않은 연결된 모든 object들이 이곳을 거치게됩니다.
function onProc_AvengerAttack(obj)
{
	if(!obj) return;
	if(isAvengerAwakenning(obj) == false) {
		return;
	}
	
	local substate = obj.getSkillSubState();
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();
	
	local pAni = obj.sq_getCurrentAni();
    local frmIndex = obj.sq_ani_GetCurrentFrameIndex(pAni);
	local currentT = sq_GetCurrentTime(pAni);

	
	if(obj.getAttackIndex() == 2) {
		// 세번째 펀치는 속도를 좀 빠르게
		if(!obj.getVar().get_vector(0)) {
			if(frmIndex >= 0 && frmIndex < 5) {
				local pA = obj.sq_getCurrentAni();
				obj.sq_setAnimationSpeedRate(pA, 160.0);
				obj.getVar().set_vector(0, 1);
			}
		}
		
		if(!obj.getVar().get_vector(1)) {
			if(frmIndex >= 5) {
				local pA = obj.sq_getCurrentAni();
				obj.sq_setAnimationSpeedRate(pA, 100.0);
				obj.getVar().set_vector(1, 1);
			}
		}		
		
		if(frmIndex >= 6) {
			local dustFlag = obj.getVar().get_vector(3);
			if(!dustFlag) {
				obj.getVar().set_vector(3, 1);
				//print("size_vector:" + obj.getVar().size_vector());
				
				//local dustN = obj.getVar().GetAnimationMap("15_dust_normal","Character/Priest/Effect/Animation/Awakening/attack/attack3/15_dust_normal.ani");
				//pAni.addLayerAnimation(1, dustN, false);
				
				// 공격 먼지 생성
				local dust_n_Ani = obj.sq_createCNRDAnimation("Effect/Animation/Awakening/attack/attack3/15_dust_normal.ani");
				local dustObj = obj.sq_createCNRDPooledObject(dust_n_Ani, true);
				dustObj.setCurrentDirection(obj.getDirection());
		
				
				dustObj.setCurrentPos(posX, posY + 2, 0);
				obj.sq_AddObject(dustObj);
				
				//print("dustFlag:" + dustFlag);
				
			}
		}
	}
	
	if(obj.getAttackIndex() == 3) { // 마지막 내려찍기 충전 중
		// 세번째 펀치는 속도를 좀 빠르게
		local chargeTime = sq_GetIntData(obj, SKILL_AVENGER_AWAKENING, 0); //점프 마법 공격 최대 충전시간
		local stateTimer = obj.sq_getStateTimer();
		
		if(chargeTime <= stateTimer && !obj.getVar().get_vector(0)) {
			print("\n fullCharge");
			local pfullChargeAni = obj.getVar().GetAnimationMap("Attack4_2", "Character/Priest/Animation/AvengerAwakening/Attack4_2.ani");
			if(pfullChargeAni) {
				obj.setCurrentAnimation(pfullChargeAni);
			}
			obj.getVar().set_vector(0, 1);
		}
	}
	
	
	if(obj.getAttackIndex() == 4) { // 마지막 내려찍기 공격
		// 세번째 펀치는 속도를 좀 빠르게
		if(!obj.getVar().get_vector(1)) {
			local pA = obj.sq_getCurrentAni();
			obj.sq_setAnimationSpeedRate(pA, 100.0);
			obj.getVar().set_vector(1, 1);
		}
	}
	
	
}

// loop 부분입니다 ismycontrol 호스트가 본인이 object가 이곳을 들어갑니다. setstate 세팅이나 패시브오브젝트 생성 , 등등 처리합니다.
function onProcCon_AvengerAttack(obj)
{
	if(!obj) return;
	if(isAvengerAwakenning(obj) == false) {
		local pAni = obj.sq_getCurrentAni();
		local bEnd = obj.sq_ani_IsEnd(pAni);
		 local frmIndex = obj.sq_ani_GetCurrentFrameIndex(pAni);
		
		
		if(obj.getAttackIndex() == 2) // 만약 3타 째라면..
		{	
			// (박정완씨 튜닝)
			if(frmIndex >= 5) // 6번 프레임 이상이라면.
			{ 
				if(obj.getVar().get_vector(2) == 0)
				{ // 2번 플래그가 0이라면
					obj.getVar().set_vector(2, 1); // 2번플래그를 1로 바꾼다 왜냐하면 딱 한번만 이안으로 들어와야하기때문에..
					//print("CUSTOM_ATTACKINFO_AVENGER_ATTACK_3_2:" + CUSTOM_ATTACKINFO_AVENGER_ATTACK_3_2);
					obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_AVENGER_ATTACK_3_2); // 찍기 공격을 위해 
				}
			}
		}
		
		// 원하는것을 짠다..
		if(obj.getAttackIndex() == 3) // 만약 4타 째라면..
		{	
			if(frmIndex >= 7) {
				if(obj.getVar().get_vector(3) == 0)
				{ // 3번 플래그가 0이라면
					// 어벤저 평막타 2번째 atk파일을 세팅하기 위함이다.. 찍기공격으로 바꾸기 위해서입니다..
					//print("obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_AVENGER_ATTACK_4_2);");
					obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_AVENGER_ATTACK_4_2);
					
					obj.getVar().set_vector(3, 1); // 2번플래그를 1로 바꾼다 왜냐하면 딱 한번만 이안으로 들어와야하기때문에..
					
				}
			}
			if(frmIndex >= 8) // 8번 프레임 이상이라면.
			{ 
				if(obj.getVar().get_vector(2) == 0)
				{ // 2번 플래그가 0이라면
					obj.sq_setShake(obj, 1, 200); // 지진을 일으킨다.. 
					obj.getVar().set_vector(2, 1); // 2번플래그를 1로 바꾼다 왜냐하면 딱 한번만 이안으로 들어와야하기때문에..
				}
			}
		}
		
		
		return;
	}
	
	local pAni = obj.sq_getCurrentAni();
	local bEnd = obj.sq_ani_IsEnd(pAni);
    local frmIndex = obj.sq_ani_GetCurrentFrameIndex(pAni);
	
    local substate = obj.getSkillSubState();
    
    //if (obj.getAttackIndex() < obj.sq_getAttackCancelStartFrameSize() &&
		//frmIndex >= obj.sq_getAttackCancelStartFrame(obj.getAttackIndex()) &&
		//sq_IsEnterCommand(obj, 1)
	//)
	
    
        
	if(obj.getAttackIndex() == 2) { // 각성 변신상태 기본 공격 마지막이라면..	
	
		if(frmIndex >= 5) {
			if(obj.getVar().get_vector(2) == 0) {
				obj.getVar().set_vector(2, 1);
				obj.sq_setShake(obj, 2, 500);
			}
		}
	}
	
	if(obj.getAttackIndex() < 3) {
	
		sq_SetKeyxEnable(obj, 1, true);	
			
		local bCommand = sq_IsEnterCommand(obj, 1);
		
		if (bCommand)
		{
		   local var_awakening = obj.getVar("awakening");
		   local t = var_awakening.get_ct_vector(0).Get();	
		   
		   //print("var_awakening.get_ct_vector(0).Get():" + t + "var_awakening.get_vector(0):" + var_awakening.get_vector(0));

		   if(var_awakening.get_ct_vector(0).Get() > var_awakening.get_vector(0)) { // 자체 쿨타임 체크
				obj.sq_IntVectClear();
				obj.sq_IntVectPush(3); // substate세팅
				obj.sq_addSetStatePacket(STATE_ATTACK, STATE_PRIORITY_USER, true);
		   }
		   else { // 쿨타임이 덜 됐다..
				obj.startCantUseSkillWarning();
				if (obj.isMessage()) {
					sq_AddMessage(414); // 414>쿨타임입니다.
				}
		   }
			return;
		}
	
	}
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();
	
	if(obj.getAttackIndex() == 3) {		
		
		local bDownKey = sq_IsDownKey(obj, 1, false);
		local chargeTime = sq_GetIntData(obj, SKILL_AVENGER_AWAKENING, 0) * 2; //점프 마법 공격 최대 충전시간
		local stateTimer = obj.sq_getStateTimer();
		print("\n chargeTime:" + chargeTime + " stateTimer:" + stateTimer);
		
		// 요청사항
		// 완충 후에 완충시간만큼 흐르면 자동으로 넘어갑니다..		
		if(!bDownKey || stateTimer >= chargeTime) { // 손을 띄었다는것은.. 
			
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(4); // substate세팅
			obj.sq_IntVectPush(stateTimer); // 기본에서 추가 공격력
			
			
			obj.sq_addSetStatePacket(STATE_ATTACK, STATE_PRIORITY_USER, true);
			return;
		}
	}
	
}
