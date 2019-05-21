SUBSTATE_PANDEMONIUM_EX_START <- 0;
SUBSTATE_PANDEMONIUM_EX_END   <- 1;

// 변수 인덱스
PEND_EX_MAGIC_FIELD			  <- 0;
PEND_EX_IS_ENDED			  <- 1;
PEND_EX_CREATE_DEVIL_COUNT	  <- 2;
PEND_EX_MAGIC_OVER			  <- 3;
PEND_EX_FLASHSCREEN			  <- 4;	

PEND_EVENT_TIMER_CREATE_DEVIL <- 0;


function sendSubState_PandemoniumEx(obj, subState)
{	
	if(!obj) return;
	
	if(obj.isMyControlObject()) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(subState); // substate세팅
		obj.sq_addSetStatePacket(STATE_PANDEMONIUM_EX, STATE_PRIORITY_IGNORE_FORCE, true);
	}
}
//------------------------------------------------------------------------------

// 스킬 세부발동 조건을 만들어주는 함수입니다.. 발동 조건 state는 이미 소스에서 구현되어 있습니다. 이곳에서 useskill과 setstate를 지정해주면 됩니다.
function checkExecutableSkill_PandemoniumEx(obj)  
{
	if(!obj) return false;
	local b_useskill = obj.sq_IsUseSkill(SKILL_PANDEMONIUM_EX);

	if(b_useskill) {
		sendSubState_PandemoniumEx(obj,SUBSTATE_PANDEMONIUM_EX_START);
		return true;
	}	
	
	return false;
}

function checkCommandEnable_PandemoniumEx(obj)
{
	if(!obj) return false;
	return true;
}
//------------------------------------------------------------------------------
function resetDungeonStart_PandemoniumEx(obj, moduleType, resetReason, isDeadTower, isResetSkillUserCount)
{
	obj.sq_setXScrollStop(0);
}

//isCheckHitCollision와 checkHit는 피격 체크를 상대방이 아닌 내가 해야 할경우에 쓰인다. pvp에선 상대방이 피격체크를 하면 응답시간이 느려 스킬이 캔슬되는 경우가 있기 때문.
function onIsCheckHitCollision_PandemoniumEx(obj,damager)
{
	local subState = obj.getSkillSubState();	
	if(subState == SUBSTATE_POWER_OF_DARKNESS_START)  //어둠의 권능 pvp에서 첫타 실패 막기 위해.
		return obj.isMyControlObject();
	
	//기본적으론 나의 오브젝트가 아니면 false다. 여기서 false를 하게 되면 나의 오브젝트 인지 결과가 리턴된다.
	return (damager && damager.isMyControlObject());
}


// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_PandemoniumEx(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	local sq_var = obj.getVar();  
	local subState = obj.sq_getVectorData(datas, 0);	
	obj.setSkillSubState(subState);


	if(subState == SUBSTATE_PANDEMONIUM_EX_START) {			
		obj.sq_stopMove();
		
		if(isAvengerAwakenning(obj)) {
			local ani = obj.getVar().GetAnimationMap("PAND_EX_START", "Character/Priest/Animation/AvengerAwakening/PandemoniumStart.ani"); 
			obj.setCurrentAnimation(ani);
			obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_AWAKENING_PANDEMONIUM_START);
		}
		else {
			obj.sq_setCurrentAnimation(CUSTOM_ANI_PANDEMONIUM_START);
			obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_PANDEMONIUM_EX_ON_START);
		}
		
		//첫타를 위함 셋팅
		local dmg = obj.sq_getBonusRateWithPassive(SKILL_PANDEMONIUM_EX, STATE_PANDEMONIUM_EX, 0,1.0);
	
		//악마화 상태에선 공격력 증폭
		if(isAvengerAwakenning(obj)) {
			local devilPowerUpRate = obj.sq_getIntData(0);
			dmg = dmg * (devilPowerUpRate + 100) * 0.01;
		}
		
		sq_SetCurrentAttackBonusRate(sq_GetCurrentAttackInfo(obj),dmg.tointeger());		
		obj.sq_setXScrollStart(300,150);			
	}
	else if(subState == SUBSTATE_PANDEMONIUM_EX_END) {
		if(isAvengerAwakenning(obj)) {
			local ani = obj.getVar().GetAnimationMap("PAND_EX_END", "Character/Priest/Animation/AvengerAwakening/PandemoniumEnd.ani"); 
			obj.setCurrentAnimation(ani);
		}
		else {
			obj.sq_setCurrentAnimation(CUSTOM_ANI_PANDEMONIUM_END);
		}
		obj.sq_setXScrollStop(300);			
		sq_SetMyShake(obj,0,0);	
		
		
		local flashScreenObj = sq_var.getObject(PEND_EX_FLASHSCREEN);		
		if(flashScreenObj) { // 플래쉬 스크린 작동중이면 끔
			local pflashScreen = sq_GetCNRDObjectToFlashScreen(flashScreenObj);
			if(pflashScreen)
				pflashScreen.fadeOut();
		}		
	}
}

function onEndState_PandemoniumEx(obj,newState) 
{	
	if(!obj) return;
	
	if(newState != SUBSTATE_PANDEMONIUM_EX_END) {
	
		local sq_var = obj.getVar(); 
		 
		local magicField = sq_var.getObject(PEND_EX_MAGIC_FIELD);
		if(magicField)
			magicField.setValid(false);
				
		local magicOver = sq_var.getObject(PEND_EX_MAGIC_OVER);
		if(magicOver)
			magicOver.setValid(false);
						
			
		local isEnded = sq_var.getBool(PEND_EX_IS_ENDED);
		if(!isEnded) {		
		
			local endMagicField = sq_CreateDrawOnlyObject(obj,"Character/Priest/Effect/Animation/Pandemonium/end/base.ani",ENUM_DRAWLAYER_NORMAL,true);
			local endMagicFieldOver = sq_CreateDrawOnlyObject(obj,"Character/Priest/Effect/Animation/Pandemonium/end/OverEffectbase.ani",ENUM_DRAWLAYER_NORMAL,true);
						
			if(isAvengerAwakenning(obj)) {
				local xPos = sq_GetDistancePos(endMagicField.getXPos(), obj.getDirection(), 80);	
				endMagicField.setCurrentPos(xPos, endMagicField.getYPos(), endMagicField.getZPos()+20); 
				
				//xPos = sq_GetDistancePos(magicField.getXPos(), obj.getDirection(), 5);	 
				endMagicFieldOver.setCurrentPos(endMagicField.getXPos(), endMagicField.getYPos()+2, endMagicField.getZPos()); 
			}
			
			sq_var.setBool(PEND_EX_IS_ENDED,true);
		}
		
		obj.sq_setXScrollStop(300);
		sq_SetMyShake(obj,0,0);	
	}
}


function onTimeEvent_PandemoniumEx(obj, timeEventIndex, timeEventCount)
{	
	local sq_var = obj.getVar(); 		
	local maxCount = obj.sq_getIntData(1);
	local moveSpeed = obj.sq_getIntData(2);	
	local maxTime = obj.sq_getIntData(3);	
	local moveMaxDistance = obj.sq_getIntData(4);
	local currentCount = sq_var.getInt(PEND_EX_CREATE_DEVIL_COUNT);
	
	if(currentCount	== maxCount) {
		obj.setTimeEvent(PEND_EVENT_TIMER_CREATE_DEVIL,30,0,false);	
		sq_var.setInt(PEND_EX_CREATE_DEVIL_COUNT,currentCount+1);
	}
	else if(currentCount > maxCount) {
		sendSubState_PandemoniumEx(obj,SUBSTATE_PANDEMONIUM_EX_END);
		return true;
	}
	else {	
		local createDevilZ = currentCount%2 == 1 ? sq_getRandom(-20,-45) : sq_getRandom(20,45);
		
		local createDevilSize = sq_getRandom(0,4); // 0이면 작은 사이즈 그 이왼 큰사이즈 즉 20%확률로 작은게 나옴
		
		
		local devilPowerUpRate = obj.sq_getIntData(0);
		local dmgRate = isAvengerAwakenning(obj) ? (devilPowerUpRate + 100)* 0.01 : 1.0;
		local dmg = obj.sq_getBonusRateWithPassive(SKILL_PANDEMONIUM_EX, STATE_PANDEMONIUM_EX, 0, dmgRate);
		local createXPos = 85;
		local createZPos = 64;
		
		if(isAvengerAwakenning(obj)) {
			createXPos = 160;
			createZPos = 80;			
		}		
			
		obj.sq_binaryData_startWrite(); //생성 크기를 정해서 보낼것.		
		obj.sq_binaryData_writeWord(createDevilSize);
		obj.sq_binaryData_writeWord(moveSpeed);
		obj.sq_binaryData_writeWord(maxTime);	
		obj.sq_binaryData_writeWord(moveMaxDistance);
		obj.sq_binaryData_writeDword(dmg.tointeger());	
		
		
		sq_SendCreatePassiveObjectPacket(obj,24110, 0, createXPos, 1, createZPos + createDevilZ, obj.getDirection());	
		
		
	
		sq_var.setInt(PEND_EX_CREATE_DEVIL_COUNT,currentCount+1);
		local createDevilTimeGap = sq_getRandom(50,90);
			
		obj.setTimeEvent(PEND_EVENT_TIMER_CREATE_DEVIL,createDevilTimeGap,0,false);		
	}	
	
	return false; // true면 콜백 중단
}


function onEndCurrentAni_PandemoniumEx(obj)
{
	local subState = obj.getSkillSubState();

	if(subState == SUBSTATE_PANDEMONIUM_EX_END)
	{
		obj.sq_addSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	}	
}
		
function onKeyFrameFlag_PandemoniumEx(obj,flagIndex)
{	
	if(flagIndex == 1)
	{		
		local sq_var = obj.getVar();  
		local magicField = sq_CreateDrawOnlyObject(obj,"Character/Priest/Effect/Animation/Pandemonium/start/base.ani",ENUM_DRAWLAYER_NORMAL,false);		
		local overEffect = sq_CreateDrawOnlyObject(obj,"Character/Priest/Effect/Animation/Pandemonium/start/OverEffectbase.ani",ENUM_DRAWLAYER_NORMAL,false);		
		
		if(isAvengerAwakenning(obj)) {
			local xPos = sq_GetDistancePos(magicField.getXPos(), obj.getDirection(), 80);	 
			magicField.setCurrentPos(xPos, magicField.getYPos(), magicField.getZPos()+20);			
		}
		sq_var.setObject(PEND_EX_MAGIC_FIELD, magicField);	
		sq_var.setObject(PEND_EX_MAGIC_OVER, overEffect);		
		
		//local xPos = sq_GetDistancePos(magicField.getXPos(), obj.getDirection(), 10);	 
		overEffect.setCurrentPos(magicField.getXPos(), magicField.getYPos()+2, magicField.getZPos());
				
		local createDevilTimeGap = sq_getRandom(50,90);				
		obj.setTimeEvent(PEND_EVENT_TIMER_CREATE_DEVIL,createDevilTimeGap,0,true);
		
		sq_SetMyShake(obj,4,3000);
		
		local flashScreenObj = sq_flashScreen(obj,80,5000,240,150, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
		sq_var.setObject(PEND_EX_FLASHSCREEN,flashScreenObj);
	}	
	return true;	
}
