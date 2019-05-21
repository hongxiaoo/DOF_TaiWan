
SUB_STATE_FALLENBLOSSOMS_0	<- 0
SUB_STATE_FALLENBLOSSOMS_1	<- 1
SUB_STATE_FALLENBLOSSOMS_2	<- 2
SUB_STATE_FALLENBLOSSOMS_3	<- 3
SUB_STATE_FALLENBLOSSOMS_4	<- 4

//STATE_FALLENBLOSSOMS			<- 40	// 공통:낙화연창
//SKILL_FALLENBLOSSOMS			<- 21   // 공통:낙화연창

function checkExecutableSkill_FallenBlossoms(obj)
{

	if(!obj) return false;

	local b_useskill = obj.sq_IsUseSkill(SKILL_FALLENBLOSSOMS);

	if(b_useskill)
	{
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_FALLENBLOSSOMS_0); // substate세팅
		obj.sq_AddSetStatePacket(STATE_FALLENBLOSSOMS, STATE_PRIORITY_IGNORE_FORCE, true);
		return true;
	}	
	
	return false;

}

function checkCommandEnable_FallenBlossoms(obj)
{

	if(!obj) return false;

	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK)
	{
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_FALLENBLOSSOMS); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_FALLENBLOSSOMS);
	}	

	return true;

}

function createFallenBlossomsSpear(obj, disX, disY, disZ)
{
	local ani = sq_CreateAnimation("","Character/Mage/Effect/Animation/ATFallenBlossoms/02/spear/01_lance_normal.ani");
	local pooledObj = sq_CreatePooledObject(ani,true);
	
	local posX = sq_GetDistancePos(obj.getXPos(), obj.getDirection(), disX);
	
	pooledObj.setCurrentPos(posX,obj.getYPos() + disY,obj.getZPos() + disZ);
	
	pooledObj.setCurrentDirection(obj.getDirection());
	
	sq_moveWithParent(obj, pooledObj);
	
	sq_AddObject(obj,pooledObj,2,false);	

}

function createFallenBlossomsSpearEnd(obj, disX, disY, disZ)
{
	local ani = sq_CreateAnimation("","Character/Mage/Effect/Animation/ATFallenBlossoms/02/spearEnd/01_lance_normal.ani");
	local pooledObj = sq_CreatePooledObject(ani,true);
	
	local posX = sq_GetDistancePos(obj.getXPos(), obj.getDirection(), disX);
	
	pooledObj.setCurrentPos(posX,obj.getYPos() + disY,obj.getZPos() + disZ);
	
	pooledObj.setCurrentDirection(obj.getDirection());
	
	sq_moveWithParent(obj, pooledObj);
	
	sq_AddObject(obj,pooledObj,2,false);	

}

function createFallenBlossomsSpearExp(obj, disX, disY, disZ)
{
	local ani = sq_CreateAnimation("","Character/Mage/Effect/Animation/ATFallenBlossoms/03/04_break_dodge.ani");
	local pooledObj = sq_CreatePooledObject(ani,true);
	
	local posX = sq_GetDistancePos(obj.getXPos(), obj.getDirection(), disX);
	
	pooledObj.setCurrentPos(posX,obj.getYPos() + disY,obj.getZPos() + disZ);
	
	pooledObj.setCurrentDirection(obj.getDirection());
	
	sq_moveWithParent(obj, pooledObj);
	
	sq_AddObject(obj,pooledObj,2,false);	

}


function onSetState_FallenBlossoms(obj, state, datas, isResetTimer)
{

	if(!obj) return;

	local substate = obj.sq_GetVectorData(datas, 0);
	obj.setSkillSubState(substate);

	obj.sq_StopMove();


	if(substate == SUB_STATE_FALLENBLOSSOMS_0) {
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_FALLENBLOSSOMS1);
		obj.sq_PlaySound("MW_ICESPEAR");
		
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
				SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_1)
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_FALLENBLOSSOMS2);
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_INFO_FALLENBLOSSOMS);	
		
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
				SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
	
		local sq_var = obj.getVar();
		
		sq_var.clear_timer_vector();
		sq_var.push_timer_vector();
		
		local t = sq_var.get_timer_vector(0);
		t.setParameter(60, -1);		
		t.resetInstant(0);
		
		
		local particle = sq_var.GetparticleCreaterMap("FallenBlossomsP", "Character/Fighter/Particle/ATThrowWeb.ptl", obj);
		
	
		obj.getVar().clear_vector();
		obj.getVar().push_vector(0);
		obj.getVar().push_vector(0);
		obj.getVar().push_vector(0);
		obj.getVar().push_vector(0);
		
		
		local len = obj.sq_GetIntData(SKILL_FALLENBLOSSOMS, 0); // 전진거리
		//local len = 250;
		
		local pAttack = sq_GetCurrentAttackInfo(obj);
		local attackRate = obj.sq_GetBonusRateWithPassive(SKILL_FALLENBLOSSOMS STATE_FALLENBLOSSOMS, 0, 1.0); //2.공격력(%)
		sq_SetCurrentAttackBonusRate(pAttack, attackRate);
		
		local posX = obj.getXPos();
		//local delay = 480;
		local ani = obj.sq_GetCurrentAni();
		
		local delay = 0; 
		if(ani)
			delay = ani.getDelaySum(false);
		
		local skillLevel = sq_GetSkillLevel(obj, SKILL_FALLENBLOSSOMS);		
		local multiHit = sq_GetLevelData(obj, SKILL_FALLENBLOSSOMS, 1, skillLevel);
		print(" multiHit:" + multiHit + " delay:" + delay);
		print(delay / multiHit);
		
		obj.sq_timer_.setParameter(delay / multiHit, multiHit - 1);
		obj.sq_timer_.resetInstant(0);
		
		
		
		obj.getVar("flag").clear_vector();
		obj.getVar("flag").push_vector(posX);
		obj.getVar("flag").push_vector(len);
		obj.getVar("flag").push_vector(delay);
		obj.getVar("flag").push_vector(0);
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_2) {
		createFallenBlossomsSpearExp(obj, 0, 3, 70);
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_FALLENBLOSSOMS3);
		
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
				SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
		
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_3) {
		// SUB_STATE_FALLENBLOSSOMS_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_4) {
		// SUB_STATE_FALLENBLOSSOMS_4 서브스테이트 작업
	}
	
	

}

function prepareDraw_FallenBlossoms(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	

}

function onProc_FallenBlossoms(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	local pAni = obj.sq_GetCurrentAni();
	local frmIndex = obj.sq_GetCurrentFrameIndex(pAni);
	local currentT = sq_GetCurrentTime(pAni);

	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();

	if(substate == SUB_STATE_FALLENBLOSSOMS_0) {
		// SUB_STATE_FALLENBLOSSOMS_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_1) {
		if(frmIndex >= 0)
		{
			if(!obj.getVar().get_vector(0))
			{
				createFallenBlossomsSpear(obj, 0, 1, 69);
				obj.getVar().set_vector(0, 1);
			}
		}
	
		if(frmIndex >= 1)
		{
			if(!obj.getVar().get_vector(1))
			{
				createFallenBlossomsSpear(obj, -12, -1, 85);
				obj.getVar().set_vector(1, 1);
			}
		}

		if(frmIndex >= 2)
		{
			if(!obj.getVar().get_vector(2))
			{
				createFallenBlossomsSpear(obj, -21, 2, 45);
				obj.getVar().set_vector(2, 1);
			}
		}
		
		if(frmIndex >= 4)
		{
			if(!obj.getVar().get_vector(3))
			{
				createFallenBlossomsSpearEnd(obj, 0, 3, 70);
				obj.getVar().set_vector(3, 1);
			}
		}
		
		//////
		// 움직임
		local sq_var = obj.getVar("flag");
		
		//obj.getVar("flag").clear_vector();
		//obj.getVar("flag").push_vector(posX);
		//obj.getVar("flag").push_vector(len);
		//obj.getVar("flag").push_vector(delay);
    	local delayT = sq_var.get_vector(2); // 벡터인덱스 2 총 이동시간
    	local len = sq_var.get_vector(1);    	
    	
		local v = sq_GetAccel(0, len, currentT, delayT, true);
    	print(" delayT:" + delayT + " current:" + currentT);
		local srcX = sq_var.get_vector(0); // 벡터 인덱스 1
		
		local dstX = sq_GetDistancePos(srcX, obj.getDirection(), v);
		 
		if(obj.isMovablePos(dstX, posY) && !sq_var.get_vector(3))
		{ // 이동플래그와 이동가능지역이 모두 가능해야 이동
			sq_setCurrentAxisPos(obj, 0, dstX);
		}
		else
		{ // 이동할 수 없는 지역을 만났다..
			sq_var.set_vector(3,1); // 이동 플래그 인덱스 3 이동할 수 없는 지역을 만났을 때 그순간 더이상 이동못한다..
			local offset = dstX - posX;
			
			if(offset != 0) {				
				if(offset < 0) 
					offset = -offset;
				
				local totalLen = sq_var.get_vector(1);
				sq_var.set_vector(1, totalLen - offset);
			}
		}
		
		if (obj.sq_timer_.isOnEvent(currentT) == true)
			obj.resetHitObjectList();
			
		//////
		
		// 먼지 파티클 생성
		local t = obj.getVar().get_timer_vector(0);
		
		if(t.isOnEvent(currentT) == true)
		{
			local particleCreater = sq_var.GetparticleCreaterMap("FallenBlossomsP", "Character/Fighter/Particle/ATThrowWeb.ptl", obj);				
				
			particleCreater.Restart(0);
			local dstX = sq_GetDistancePos(posX, obj.getDirection(), -20);	
			particleCreater.SetPos(dstX, posY + 1, posZ + 5);	
			
			sq_AddParticleObject(obj, particleCreater);
		}
		
	
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_2) {
		// SUB_STATE_FALLENBLOSSOMS_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_3) {
		// SUB_STATE_FALLENBLOSSOMS_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_4) {
		// SUB_STATE_FALLENBLOSSOMS_4 서브스테이트 작업
	}
	

}

function onProcCon_FallenBlossoms(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_FALLENBLOSSOMS_0) {
		// SUB_STATE_FALLENBLOSSOMS_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_1) {
		// SUB_STATE_FALLENBLOSSOMS_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_2) {
		// SUB_STATE_FALLENBLOSSOMS_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_3) {
		// SUB_STATE_FALLENBLOSSOMS_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_4) {
		// SUB_STATE_FALLENBLOSSOMS_4 서브스테이트 작업
	}
	

}

function onEndCurrentAni_FallenBlossoms(obj)
{

	if(!obj) return;
	
	if(!obj.isMyControlObject())
		return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_FALLENBLOSSOMS_0) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_FALLENBLOSSOMS_1); // substate세팅
		obj.sq_AddSetStatePacket(STATE_FALLENBLOSSOMS, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_1) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_FALLENBLOSSOMS_2); // substate세팅
		obj.sq_AddSetStatePacket(STATE_FALLENBLOSSOMS, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_2) {
		obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_3) {
		// SUB_STATE_FALLENBLOSSOMS_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_4) {
		// SUB_STATE_FALLENBLOSSOMS_4 서브스테이트 작업
	}
	

}

function onKeyFrameFlag_FallenBlossoms(obj, flagIndex)
{

	if(!obj) return false;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_FALLENBLOSSOMS_0) {
		// SUB_STATE_FALLENBLOSSOMS_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_1) {
		// SUB_STATE_FALLENBLOSSOMS_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_2) {
		// SUB_STATE_FALLENBLOSSOMS_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_3) {
		// SUB_STATE_FALLENBLOSSOMS_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_4) {
		// SUB_STATE_FALLENBLOSSOMS_4 서브스테이트 작업
	}
	

	return false;

}

function onEndState_FallenBlossoms(obj, new_state)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_FALLENBLOSSOMS_0) {
		// SUB_STATE_FALLENBLOSSOMS_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_1) {
		// SUB_STATE_FALLENBLOSSOMS_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_2) {
		// SUB_STATE_FALLENBLOSSOMS_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_3) {
		// SUB_STATE_FALLENBLOSSOMS_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_4) {
		// SUB_STATE_FALLENBLOSSOMS_4 서브스테이트 작업
	}
	

}

function onAfterSetState_FallenBlossoms(obj, state, datas, isResetTimer)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_FALLENBLOSSOMS_0) {
		// SUB_STATE_FALLENBLOSSOMS_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_1) {
		// SUB_STATE_FALLENBLOSSOMS_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_2) {
		// SUB_STATE_FALLENBLOSSOMS_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_3) {
		// SUB_STATE_FALLENBLOSSOMS_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_FALLENBLOSSOMS_4) {
		// SUB_STATE_FALLENBLOSSOMS_4 서브스테이트 작업
	}
	

}
