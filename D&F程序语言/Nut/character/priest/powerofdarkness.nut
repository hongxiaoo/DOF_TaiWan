// 서브 스테이트가 필요 없다.
SUBSTATE_POWER_OF_DARKNESS_START		<- 0;
SUBSTATE_POWER_OF_DARKNESS_EXPLOSION	<- 1;
SUBSTATE_POWER_OF_DARKNESS_LIFT			<- 2;
SUBSTATE_POWER_OF_DARKNESS_LAST			<- 3;
SUBSTATE_POWER_OF_DARKNESS_END			<- 4;

POD_VAR_ARROW_COUNT						<- 1; // 사용한 화살 갯수
POD_VAR_CIRCLE_INDEX					<- 2; // 생성된 구체 인덱스
POD_VAR_CIRCLE_OBJECT_GROUP				<- 3; // 생성된 구체 그룹
POD_VAR_CIRCLE_OBJECT_UID				<- 4; // 생성된 구체 UID
POD_VAR_CIRCLE_OBJECT					<- 5; // 생성된 구체
POD_VAR_SUPERARMOR						<- 6; // 슈퍼아머 어펜디지
POD_VAR_FLASHSCREEN						<- 7; // 생성된 구체

POD_TIME_EVENT_ARROWGAP <- 1; // 타임 이벤트 : 화살 발동 시간 간격
POD_TIME_EVENT_LIFTTIME <- 2; // 타임 이벤트 : 몬스터 띄우는 시간
POD_TIME_EVENT_LASTDELAY <- 3; // 타임 이벤트 : 막타까지 딜레이
POD_TIME_EVENT_LAST <- 4; // 타임 이벤트 : 막타후 딜레이

POD_SOUND_INDEX_LOOP <- 92716;

function sendSubState_PowerOfDarkness(obj, subState)
{	
	if(!obj) return;
	
	if(obj.isMyControlObject()) {
		local sq_var = obj.getVar();
		local circleGroup = sq_var.getInt(POD_VAR_CIRCLE_OBJECT_GROUP);
		local circleUID = sq_var.getInt(POD_VAR_CIRCLE_OBJECT_UID);
	
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(subState); // substate세팅
		obj.sq_IntVectPush(circleGroup);
		obj.sq_IntVectPush(circleUID); // 구체의 UID 세팅
		obj.sq_addSetStatePacket(STATE_POWER_OF_DARKNESS, STATE_PRIORITY_IGNORE_FORCE, true);
	}
}
//------------------------------------------------------------------------------

// 스킬 세부발동 조건을 만들어주는 함수입니다.. 발동 조건 state는 이미 소스에서 구현되어 있습니다. 이곳에서 useskill과 setstate를 지정해주면 됩니다.
function checkExecutableSkill_PowerOfDarkness(obj)  
{
	if(!obj) return false;
	local b_useskill = obj.sq_IsUseSkill(SKILL_POWER_OF_DARKNESS);

	if(b_useskill) {
		sendSubState_PowerOfDarkness(obj,SUBSTATE_POWER_OF_DARKNESS_START);
		return true;
	}	
	
	return false;
}

//------------------------------------------------------------------------------
function isGrabable_PowerOfDarkness(obj)
{
	local sq_var = obj.getVar();
	local i=0;	
	local objectsSize = sq_var.get_obj_vector_size();		
	
	if(objectsSize == 0)
		return false;	
		
	for(;i<objectsSize;++i)
	{				
		local damager = sq_GetCNRDObjectToCollisionObject(sq_var.get_obj_vector(i));		
		if(damager && !sq_IsGrabable(obj,damager)) {		
			return false;
		}
	}	
	return true;
}

function resetDungeonStart_PowerOfDarkness(obj, moduleType, resetReason, isDeadTower, isResetSkillUserCount)
{
	obj.sq_setXScrollStop(0);
}

//isCheckHitCollision와 checkHit는 피격 체크를 상대방이 아닌 내가 해야 할경우에 쓰인다. pvp에선 상대방이 피격체크를 하면 응답시간이 느려 스킬이 캔슬되는 경우가 있기 때문.
function onIsCheckHitCollision_PowerOfDarkness(obj,damager)
{
	local subState = obj.getSkillSubState();	
	if(subState == SUBSTATE_POWER_OF_DARKNESS_START)  //어둠의 권능 pvp에서 첫타 실패 막기 위해.
		return obj.isMyControlObject();
	
	//기본적으론 나의 오브젝트가 아니면 false다. 여기서 false를 하게 되면 나의 오브젝트 인지 결과가 리턴된다.
	return (damager && damager.isMyControlObject());
}

function isForceHitCheck_PowerOfDarkness(obj)
{
	if(obj.isMyControlObject()) {
		local subState =  obj.getSkillSubState();	
		if(subState == SUBSTATE_POWER_OF_DARKNESS_START) { //어둠의 권능 pvp에서 첫타 실패 막기 위해.
			return true;
		}	
	}
	return false;
}

// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_PowerOfDarkness(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	local sq_var = obj.getVar();  
	local subState = obj.sq_getVectorData(datas, 0);	
	obj.setSkillSubState(subState);
	
	if(subState == SUBSTATE_POWER_OF_DARKNESS_START)
	{	
		sq_var.clear_obj_vector();
		obj.sq_stopMove();
		obj.sq_setCurrentAnimation(CUSTOM_ANI_POWER_OF_DARKNESS_START);
		obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_POWER_OF_DARKNESS);
		obj.sq_setAttackPowerWithPassive(SKILL_POWER_OF_DARKNESS, STATE_POWER_OF_DARKNESS, -1, 0, 1.0);
		if(!sq_isPVPMode()) // 결장에서는 슈아 안검
			obj.sq_setSuperArmor(POD_VAR_SUPERARMOR);
		
		local sk = sq_GetSkill(obj,SKILL_POWER_OF_DARKNESS);		
		local pw = sq_GetAttackBonusRate(sk,0,1.0);
		
		sq_var.setInt(POD_VAR_CIRCLE_INDEX,-1);		
		obj.sq_PlaySound("PR_DARKPOWER_READY");
		obj.sq_setXScrollStart(150,300);
	}
	else if(subState == SUBSTATE_POWER_OF_DARKNESS_LIFT)
	{
		local i=0;		
		local objectsSize = sq_var.get_obj_vector_size();
		local liftTime = obj.sq_getIntData(3);
		local x = obj.sq_getIntData(1);
		local z = obj.sq_getIntData(2);		
			
		for(;i<objectsSize;++i)
		{					
			local damager = sq_var.get_obj_vector(i);
			local aoDamager = sq_GetCNRDObjectToActiveObject(damager);
			if(aoDamager) {
				local masterAppendage = aoDamager.GetSquirrelAppendage("Appendage/Character/ap_PowerOfDarkness.nut");			
				sq_AccelMoveToAppendageForce(aoDamager, obj, obj, x, 0, z - aoDamager.getObjectHeight()/2, liftTime, true, masterAppendage,true);
			}
		}
		local circleGroup = obj.sq_getVectorData(datas, 1);		
		local circleUID = obj.sq_getVectorData(datas, 2);
				
		local darkCircle = sq_GetObject(obj,circleGroup,circleUID);
		if(darkCircle) {				
			local damager = sq_var.get_obj_vector(0);
			darkCircle.setCurrentPos(darkCircle.getXPos(),damager.getYPos()+1,darkCircle.getZPos()); // y축 좌표 맞추기
			sq_moveWithParent(damager,darkCircle);
		}		
		
		sq_SetMyShake(obj,5,160);			
			
		obj.setTimeEvent(POD_TIME_EVENT_LIFTTIME,liftTime,1,false);
		obj.sq_setCurrentAnimation(CUSTOM_ANI_POWER_OF_DARKNESS_STAY);		
		
		sq_AddDrawOnlyAniFromParent(obj,"Character/Priest/Effect/Animation/PowerOfDarkness/guard_attack_none.ani",172,0,0);
		sq_AddDrawOnlyAniFromParent(obj,"Character/Priest/Effect/Animation/PowerOfDarkness/guard_attack_none_r.ani",172,0,0);
	}	
	else if(subState == SUBSTATE_POWER_OF_DARKNESS_LAST)
	{
		local gap = obj.sq_getIntData(5);
		obj.setTimeEvent(POD_TIME_EVENT_LASTDELAY,gap,1,false);
		obj.sq_setCurrentAnimation(CUSTOM_ANI_POWER_OF_DARKNESS_STAY);
		obj.stopSound(POD_SOUND_INDEX_LOOP);
	}
	else if(subState == SUBSTATE_POWER_OF_DARKNESS_EXPLOSION)
	{	
		local gap = obj.sq_getIntData(4);
		obj.setTimeEvent(POD_TIME_EVENT_ARROWGAP,gap,0,true);
		obj.sq_setCurrentAnimation(CUSTOM_ANI_POWER_OF_DARKNESS_STAY);			
	}	
	else if(subState == SUBSTATE_POWER_OF_DARKNESS_END)
	{		
		obj.sq_setCurrentAnimation(CUSTOM_ANI_POWER_OF_DARKNESS_END);
		obj.sq_setXScrollStop(300);
	}
}

function onEndState_PowerOfDarkness(obj,newState) 
{	
	if(!obj) return;
	if(newState != STATE_POWER_OF_DARKNESS) {
		obj.sq_removeSuperArmor(POD_VAR_SUPERARMOR);
		
		local sq_var = obj.getVar();  
		local darkCircleObject = sq_var.getObject(POD_VAR_CIRCLE_OBJECT);
		local darkCircle = sq_GetCNRDObjectToCollisionObject(darkCircleObject);
		local flashScreenObj = sq_var.getObject(POD_VAR_FLASHSCREEN);
		
		if(flashScreenObj) { // 플래쉬 스크린 작동중이면 끔
			local pflashScreen = sq_GetCNRDObjectToFlashScreen(flashScreenObj);
			if(pflashScreen)
				pflashScreen.fadeOut();
		}		
		
		sq_moveWithParent(null,darkCircle);	
		obj.sq_setXScrollStop(300);
		
		if(darkCircle && darkCircle.isMyControlObject()) {	
			sendPowerOfDarknessCircleSubState(darkCircle,POWER_OF_DARKNESS_CIRCLE_DESTROY);
		}		
		
		removeAllPoweOfDarknessAppendage(obj);		
	}
}



// 한정된 랜덤을 위한 함수
function getArrowCreateAngle(areaIndex)
{
	areaIndex = areaIndex%6;
		
	local minAngle = 0;
	local maxAngle = 0;
	if(areaIndex == 0) // 250~310 도
		minAngle = 250, maxAngle = 310;
	else if(areaIndex == 1) // 10~70 도
		minAngle = 10, maxAngle = 70;
	else if(areaIndex == 2) // 70~130 도
		minAngle = 70, maxAngle = 130;
	else if(areaIndex == 3) // 190~250도
		minAngle = 190, maxAngle = 250;		
	else if(areaIndex == 4) // 310~370도
		minAngle = 310, maxAngle = 370;		
	else if(areaIndex == 5) // 130~190도
		minAngle = 130, maxAngle = 190;
		
	local angle = sq_getRandom(minAngle,maxAngle);
	return angle.tofloat() * 0.0174532;
}

function createPowerOfDarknessArrow(obj, angle)
{
	local sq_var = obj.getVar();  
	local circleGroup = sq_var.getInt(POD_VAR_CIRCLE_OBJECT_GROUP);
	local circleUID   = sq_var.getInt(POD_VAR_CIRCLE_OBJECT_UID);
		
	local darkCircle = sq_GetObject(obj,circleGroup,circleUID);		
	if(darkCircle) {		
		local x = darkCircle.getXPos() > obj.getXPos() ? darkCircle.getXPos() - obj.getXPos() : obj.getXPos() - darkCircle.getXPos();
		local z = darkCircle.getZPos() > obj.getZPos() ? darkCircle.getZPos() - obj.getZPos() : obj.getZPos() - darkCircle.getZPos();			
		local rate = obj.sq_getBonusRateWithPassive(SKILL_POWER_OF_DARKNESS, STATE_POWER_OF_DARKNESS,2,1.0);	
		
		obj.sq_binaryData_startWrite();
		obj.sq_binaryData_writeFloat(angle.tofloat());
		obj.sq_binaryData_writeDword(rate);
		sq_SendCreatePassiveObjectPacket(obj,24108, 0, x, sq_getRandom(-1,2), z, obj.getDirection());		
	}
}


//POD_TIME_EVENT_ARROWGAP <- 1; // 타임 이벤트 : 화살 발동 시간 간격
//POD_TIME_EVENT_LIFTTIME <- 2; // 타임 이벤트 : 몬스터 띄우는 시간
function onTimeEvent_PowerOfDarkness(obj, timeEventIndex, timeEventCount)
{
	local subState = obj.getSkillSubState();
	
	if(timeEventIndex == POD_TIME_EVENT_LIFTTIME) {
		sendSubState_PowerOfDarkness(obj,SUBSTATE_POWER_OF_DARKNESS_EXPLOSION);		
	}
	else if(timeEventIndex == POD_TIME_EVENT_ARROWGAP) {
	
		local sq_var = obj.getVar();  
		local current = sq_var.getInt(1);
		sq_var.setInt(1,current+1);
		local maxArraw = obj.sq_getLevelData(1);

		if(current >= maxArraw) // 시간 딜레이를 좀더 주기 위해
		{			
			sendSubState_PowerOfDarkness(obj,SUBSTATE_POWER_OF_DARKNESS_LAST);							
			return true;
		}
		else if(current < maxArraw)
		{	
			createPowerOfDarknessArrow(obj,getArrowCreateAngle(current));	
		}		
		return false;
	}
	else if(timeEventIndex == POD_TIME_EVENT_LASTDELAY)
	{		
		local lastMaxArrow = obj.sq_getIntData(6);
		local i = 0;
		for(i=0;i<lastMaxArrow;++i){
			local angle = 360/lastMaxArrow * i;			
			angle = angle * 0.0174532;			
			createPowerOfDarknessArrow(obj,angle.tofloat());
		}

		obj.sq_PlaySound("PR_DARKPOWER");
		obj.setTimeEvent(POD_TIME_EVENT_LAST,900,1,false);
		return true;
	}
	else if(timeEventIndex == POD_TIME_EVENT_LAST)
	{
		sq_flashScreen(obj,160,0,0,150, sq_RGB(255,255,255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
		sendSubState_PowerOfDarkness(obj,SUBSTATE_POWER_OF_DARKNESS_END);
		return true;				
	}
	else
		sendSubState_PowerOfDarkness(obj,SUBSTATE_POWER_OF_DARKNESS_END);	
				
	return true; // true면 콜백 중단
}


function onEndCurrentAni_PowerOfDarkness(obj)
{
	local subState = obj.getSkillSubState();
	
	if(subState == SUBSTATE_POWER_OF_DARKNESS_START)
	{				
		local sq_var = obj.getVar();
		local objectsSize = sq_var.get_obj_vector_size();		
		
		if (objectsSize > 0)
		{
			if(isGrabable_PowerOfDarkness(obj))
				sendSubState_PowerOfDarkness(obj,SUBSTATE_POWER_OF_DARKNESS_LIFT);
			else
				sendSubState_PowerOfDarkness(obj,SUBSTATE_POWER_OF_DARKNESS_EXPLOSION);
										
			obj.playSound("DARKPOWER_CATCH_LOOP",POD_SOUND_INDEX_LOOP,0,0,0);			
		}
		else 
			sendSubState_PowerOfDarkness(obj,SUBSTATE_POWER_OF_DARKNESS_END);		
	}
	else if(subState == SUBSTATE_POWER_OF_DARKNESS_END)
		obj.sq_addSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);	
}

// onAttack 콜백함수 입니다
function onAttack_PowerOfDarkness(obj, damager, boundingBox)
{
	local sq_var = obj.getVar();  
	local subState = obj.getSkillSubState();
	
	if(subState == SUBSTATE_POWER_OF_DARKNESS_START)
	{					
		local masterAppendage = CNSquirrelAppendage.sq_AppendAppendage(damager, obj, SKILL_EXECUTION, false, "Appendage/Character/ap_PowerOfDarkness.nut", true);
				 
		if(masterAppendage) {			
			if(sq_IsHoldable(obj,damager)) {
				sq_HoldAndDelayDie(damager, obj, true, true, true, 300, 300, ENUM_DIRECTION_NEUTRAL , masterAppendage);
				damager.setCurrentDirection(sq_GetOppositeDirection(obj.getDirection()));			
			}
		
			local collectingTime = obj.sq_getIntData(0);			
			if(sq_IsGrabable(obj,damager) && sq_IsHoldable(obj,damager) && !sq_IsFixture(damager)) //잡을수 있는 상태				
				sq_MoveToAppendageForce(damager, obj, obj, 160, 0, 90 - damager.getObjectHeight()/2, collectingTime, true, masterAppendage);			
			else if(sq_IsHoldable(obj,damager) && !sq_IsFixture(obj)) 
				sq_MoveToAppendageForce(damager, obj, obj, 160, 0, damager.getZPos(), collectingTime, true, masterAppendage);			
			
			obj.sq_PlaySound("DARKPOWER_CATCH");
			sq_var.push_obj_vector(damager);
		}
	}
}

function removeAllPoweOfDarknessAppendage(obj)
{
	local sq_var = obj.getVar();  		
	local i=0;		
	local objectsSize = sq_var.get_obj_vector_size();
	
	for(;i<objectsSize;++i)
	{
		local damager = sq_var.get_obj_vector(i);
		if(damager)
			CNSquirrelAppendage.sq_RemoveAppendage(damager, "Appendage/Character/ap_PowerOfDarkness.nut");
		sq_SimpleMoveToNearMovablePos(damager,200);
	}		
}

		
function onKeyFrameFlag_PowerOfDarkness(obj,flagIndex)
{
	local sq_var = obj.getVar(); 
	if(flagIndex == 0 && obj.isMyControlObject())
	{
		obj.sq_binaryData_startWrite(); //초기화를 위한 더미 코드
		obj.sq_binaryData_writeDword(0); 		
			
		local circleIndex = sq_SendCreatePassiveObjectPacket(obj,24107, 0, 172, 2, 97,obj.getDirection());		
		 
		sq_var.setInt(POD_VAR_CIRCLE_INDEX,circleIndex);
	}	
	else if(flagIndex == 1 && obj.isMyControlObject())
	{
		local flashScreenObj = sq_flashScreen(obj,80,99990,240,150, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
		sq_var.setObject(POD_VAR_FLASHSCREEN,flashScreenObj);		
	}
	else if(flagIndex == 2 && obj.isMyControlObject()) // 모을 객체중에 안 잡히는 애가 있다면 바로 폭발 모드로
	{
		local objectsSize = sq_var.get_obj_vector_size();
		if(!isGrabable_PowerOfDarkness(obj) && objectsSize > 0)
			sendSubState_PowerOfDarkness(obj,SUBSTATE_POWER_OF_DARKNESS_EXPLOSION);		
	}
		
	return true;	
}

function onCreateObject_PowerOfDarkness(obj, createObject)
{	
	local sq_var = obj.getVar();  
	local cuid = sq_GetUniqueId(createObject);
	local circleIndex = sq_var.getInt(POD_VAR_CIRCLE_INDEX);
	
	if(cuid == circleIndex) {	
		local group = sq_GetGroup(createObject);
		local uid  = sq_GetUniqueId(createObject);
		sq_var.setObject(POD_VAR_CIRCLE_OBJECT, createObject);
		
		sq_var.setInt(POD_VAR_CIRCLE_OBJECT_GROUP, group);
		sq_var.setInt(POD_VAR_CIRCLE_OBJECT_UID, uid);
	}
}
