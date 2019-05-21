ENUM_PO_ICE_CHAKRAM_TIMER_LARGE_MULTI_HIT <- 0;
ENUM_PO_ICE_CHAKRAM_TIMER_LARGE_MOVE_END  <- 1;
ENUM_PO_ICE_CHAKRAM_TIMER_LARGE_SPIN      <- 2;


ENUM_PIC_SUB_STATE_FLYING		<-10; //PIC == PO_ICE_CHAKRAM
ENUM_PIC_SUB_STATE_SPIN			<-11;	
ENUM_PIC_SUB_STATE_READY_EXPLOSION	<-12; // 폭발준비 : 하애짐
ENUM_PIC_SUB_STATE_EXPLOSION		<-13; // 바로 폭발시

ENUM_PIC_CUSTOM_ATTACK_INFO_DEFAULT <- -1;
ENUM_PIC_CUSTOM_ATTACK_INFO_SPIN	<- 0;
ENUM_PIC_CUSTOM_ATTACK_INFO_EXPLOSION	<- 1;

ENUM_PIC_CUSTOM_ANI_READY		<- 0;
ENUM_PIC_CUSTOM_ANI_EXPLOSION	<- 1;


function setAttackInfo_po_ATIceChakramLarge(obj, attackInfoIndex)
{
	if(attackInfoIndex != ENUM_PIC_CUSTOM_ATTACK_INFO_DEFAULT)
		sq_SetCurrentAttackInfoFromCustomIndex(obj, attackInfoIndex);
		
	local parentObj = obj.getTopCharacter();
	if(parentObj) { // 다단히트를 위한 타이머.		
		// 큰고리 다단 히트 공격력 설정
		local sqrParent = sq_ObjectToSQRCharacter(parentObj);
		if(sqrParent) {
			local power = sqrParent.sq_GetBonusRateWithPassive(SKILL_ICECHAKRAM , STATE_ICECHAKRAM, 1, 1.0);		
			local attackInfo = sq_GetCurrentAttackInfo(obj);
			sq_SetCurrentAttackBonusRate(attackInfo, power);
			sq_SetCurrentAttackeHitStunTime(attackInfo, 0); // 공격 경직시간 없애기.
		}
	}
}


function setCustomData_po_ATIceChakramLarge(obj, reciveData)
{
	if(!obj) return;
	
	local parentObj = obj.getTopCharacter();
	if(parentObj) { // 다단히트를 위한 타이머.
		local multiHitTimeGab = sq_GetLevelData(parentObj,	SKILL_ICECHAKRAM, 5, sq_GetSkillLevel(parentObj, SKILL_ICECHAKRAM));
		obj.setTimeEvent(ENUM_PO_ICE_CHAKRAM_TIMER_LARGE_MULTI_HIT, multiHitTimeGab, 0, true); // 0이면 무한대
			
		// 큰고리 다단 히트 공격력 설정
		setAttackInfo_po_ATIceChakramLarge(obj, ENUM_PIC_CUSTOM_ATTACK_INFO_DEFAULT);
	}
	
	local horizonAngle  = reciveData.readFloat();
	local verticalAngle = reciveData.readFloat();	
	local moveSpeed		= reciveData.readDword();
	local maxDistance	= reciveData.readDword();
	local group			= reciveData.readDword(); // 타겟 그룹
	local uid			= reciveData.readDword(); // 타겟 Uid	
	local target		= sq_GetObject(obj, group, uid);
	
	local var = obj.getVar();
	var.setObject(0,target);
	
	
	
	obj.sq_SetMoveParticle("Particle/ATIceChakramLarge.ptl", horizonAngle, verticalAngle);
	sq_SetSpeedToMoveParticle(obj,0,moveSpeed);
	
	//시간 = 거리/속도
	local flyTiime = maxDistance.tofloat()/moveSpeed.tofloat() * 1000.0;
	
	// 이동 정시할 시간.
	obj.setTimeEvent(ENUM_PO_ICE_CHAKRAM_TIMER_LARGE_MOVE_END, flyTiime.tointeger(), 1, false); // 0이면 무한대
	
	obj.sendStateOnlyPacket(ENUM_PIC_SUB_STATE_FLYING); // 기본 스테이트는 날아가는 상태.
	sq_CreateParticle("PassiveObject/Character/Mage/Particle/ATIceChakramDust.ptl",obj,0,0,-40,true,50,flyTiime.tointeger(),100);
	obj.sq_PlaySound("RAGEBLAST_THROW_LOOP",2711);	
}

function destroy_po_ATIceChakramLarge(obj)
{
	sq_RemoveParticle("PassiveObject/Character/Mage/Particle/ATIceChakramDust.ptl", obj);	
	obj.stopSound(2711);
}

function onTimeEvent_po_ATIceChakramLarge(obj, timeEventIndex, timeEventCount)
{	
	if(!obj)
		return true;
	
	if(timeEventIndex == ENUM_PO_ICE_CHAKRAM_TIMER_LARGE_MULTI_HIT)
	{			
		obj.resetHitObjectList(); //다단히트를위해 히트오브젝트 리스트를 리셋.				
		return false; // false면 계속 콜백 (timeEventCount카운트가 유한이라면 timeEventCount 만큼 콜백)
	}
	else if(timeEventIndex == ENUM_PO_ICE_CHAKRAM_TIMER_LARGE_MOVE_END)
	{
		//이동 끝이면 제자리 회전.		
		obj.sendStateOnlyPacket(ENUM_PIC_SUB_STATE_SPIN);
		printc("ENUM_PIC_SUB_STATE_SPIN");
		return true;		
	}
	else if(timeEventIndex ==  ENUM_PO_ICE_CHAKRAM_TIMER_LARGE_SPIN)
	{
		// 폭발
		obj.sendStateOnlyPacket(ENUM_PIC_SUB_STATE_READY_EXPLOSION);		
		
	}
	
	return true;
}


function setState_po_ATIceChakramLarge(obj, state, datas)
{
	if(!obj) return;
	
	if(state == ENUM_PIC_SUB_STATE_SPIN)
	{		
		// 먼지 파티클 제거.
		sq_RemoveParticle("PassiveObject/Character/Mage/Particle/ATIceChakramDust.ptl", obj);
		
		setAttackInfo_po_ATIceChakramLarge(obj, ENUM_PIC_CUSTOM_ATTACK_INFO_SPIN);
		
		// 제자리에서 스핀. 타겟이 없다면 바로 폭발				
		obj.sq_RemoveMoveParticle();
		local var = obj.getVar();
		local target = var.getObject(0);	
	
		if (target) {							
			obj.setTimeEvent(ENUM_PO_ICE_CHAKRAM_TIMER_LARGE_SPIN, 500, 1, false); // 0이면 무한대				
		}
		else {
			obj.sendStateOnlyPacket(ENUM_PIC_SUB_STATE_EXPLOSION);		
		}
	}		
	else if(state == ENUM_PIC_SUB_STATE_READY_EXPLOSION)
	{
		setCurrentAnimationFromCutomIndex(obj, ENUM_PIC_CUSTOM_ANI_READY);		
	}
	else if(state == ENUM_PIC_SUB_STATE_EXPLOSION)
	{
		obj.stopSound(2711);
		// 다단히트의 타이머를 중단.
		obj.stopTimeEvent(ENUM_PO_ICE_CHAKRAM_TIMER_LARGE_MULTI_HIT);
		
		setCurrentAnimationFromCutomIndex(obj, ENUM_PIC_CUSTOM_ANI_EXPLOSION);	
		sq_SetCurrentAttackInfoFromCustomIndex(obj, ENUM_PIC_CUSTOM_ATTACK_INFO_EXPLOSION);
			
		local parentObj = obj.getTopCharacter();
		if(parentObj) {
			// 폭발 히트 공격력 설정
			local sqrParent = sq_ObjectToSQRCharacter(parentObj);
			if(sqrParent) {
				local power = sqrParent.sq_GetBonusRateWithPassive(SKILL_ICECHAKRAM , STATE_ICECHAKRAM, 2, 1.0);		
				local attackInfo = sq_GetCurrentAttackInfo(obj);
				sq_SetCurrentAttackBonusRate(attackInfo, power);
				sq_SetCurrentAttackeHitStunTime(attackInfo, 0); // 공격 경직시간 없애기.
			}
		}		
		
		local flashScreen = sq_flashScreen(obj, 0, 80, 0, 120, sq_RGB(255,255,255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
		sq_addFlashScreen(flashScreen, 0, 960, 320, 120, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
		
		sq_SetMyShake(obj,4,340);
	}		
}

function onAttack_po_ATIceChakramLarge(obj, damager, boundingBox, isStuck)
{	// 평타 무속성
	if (!obj)
		return 0;
	if (isStuck)
		return 0;
		
	local var = obj.getVar();
	var.push_obj_vector(damager);
	
	local target = var.getObject(0);
	
	if(target && isSameObject(target,damager))//타겟을 공격했다면.
	{	
		// 타겟이 이동가능한 객체라면 강제로 이동.	//맞기 이쁜 위치로.		
		if(!sq_IsFixture(damager) && sq_IsGrabable(obj,target)) {		
			sq_SetCurrentPos(damager, sq_GetDistancePos(obj.getXPos(), obj.getDirection(), 100), obj.getYPos(), damager.getZPos());
		}
	}
	
	
	return 0;
}

function getCustomHitEffectFileName_po_ATIceChakramLarge(obj, isAttachOnDamager)
{
	// 너무 많으면 렉 유발. 공격하는 갯수가 많을 수록 적게 표시
	local var = obj.getVar();
	local maxN = var.get_obj_vector_size();
	
	if(maxN > 3)
		maxN = 3;
		
	if(sq_getRandom(0,maxN) == 0)
		return "PassiveObject/Character/Mage/Animation/ATIceChakram/fire/08_chakrahit_dodge.ani";
	else
		return "";
}


function procAppend_po_ATIceChakramLarge(obj)
{
	//obj.sendDestroyPacket(true);
}


function onKeyFrameFlag_po_ATIceChakramLarge(obj, flagIndex)
{
	if(!obj) return true;
	
	if(flagIndex == 1) {
		
	}
	return true;
}

function onEndCurrentAni_po_ATIceChakramLarge(obj)
{
	if(!obj) return;
	
	if(obj.getState() == ENUM_PIC_SUB_STATE_READY_EXPLOSION) 
	{
		obj.sendStateOnlyPacket(ENUM_PIC_SUB_STATE_EXPLOSION);		
	}	
	else if(obj.getState() == ENUM_PIC_SUB_STATE_EXPLOSION)
	{
		obj.sendDestroyPacket(true);		
	}	
}
