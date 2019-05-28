HSS_SUB_STATE_READY		<- 0
HSS_SUB_STATE_ATTACK_1	<- 1
HSS_SUB_STATE_ATTACK_2  <- 2
HSS_SUB_STATE_ATTACK_3	<- 3
HSS_SUB_STATE_ATTACK_4	<- 4
HSS_SUB_STATE_LAST		<- 5



// 스킬 세부발동 조건을 만들어주는 함수입니다.. 발동 조건 state는 이미 소스에서 구현되어 있습니다. 이곳에서 useskill과 setstate를 지정해주면 됩니다.
function checkExecutableSkill_HighSpeedSlash(obj)  
{
	if(!obj) return false;
	local b_useskill = obj.sq_IsUseSkill(SKILL_HIGH_SPEED_SLASH);
	if(b_useskill) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(HSS_SUB_STATE_READY); // substate세팅
		obj.sq_addSetStatePacket(STATE_HIGH_SPEED_SPLASH, STATE_PRIORITY_IGNORE_FORCE, true);
		return true;
	}	
	
	return false;
}

// 스킬아이콘 활성화 조건을 따지는 함수입니다. true를 리턴하면 스킬 아이콘이 활성화가 됩니다. (발동조건 state는  소스에서 처리됩니다.)
function checkCommandEnable_HighSpeedSlash(obj)
{
	if(!obj) return false;
	
	local state = obj.sq_GetSTATE();
	
	if(state == STATE_ATTACK) {
		return obj.sq_IsCommandEnable(SKILL_HIGH_SPEED_SLASH); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_HIGH_SPEED_SLASH);
	}

	return true;
}

//------------------------------------------------------------------------------
function onProc_HighSpeedSlash(obj)
{	
	if(!obj) return;
	if(obj.isMyControlObject())
	{
		obj.setSkillCommandEnable(SKILL_HIGH_SPEED_SLASH,true);
		local subState = obj.getSkillSubState();
		if(subState >= HSS_SUB_STATE_ATTACK_1 && subState <= HSS_SUB_STATE_ATTACK_4)
		{	
			
			local b_useskill = obj.sq_IsEnterSkill(SKILL_HIGH_SPEED_SLASH);			
			
			if(b_useskill != -1)
			{
				local sq_var = obj.getVar();
				sq_var.setBool(2,true);
			}
		}
	}
}

function onEndState_HighSpeedSlash(obj, newState)
{
	if(!obj) return;
	if(newState != STATE_HIGH_SPEED_SPLASH) {
		obj.setCarryWeapon(true);
	}
}



function sendSubState_HighSpeedSlash(obj, subState)
{	
	if(!obj) return;
	
	if(obj.sq_isMyControlObject()) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(subState); // substate세팅
		obj.sq_addSetStatePacket(STATE_HIGH_SPEED_SPLASH, STATE_PRIORITY_USER, true);
	}	
}

// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_HighSpeedSlash(obj, state, datas, isResetTimer)
{		
	local sq_var = obj.getVar();
	local subState = obj.sq_getVectorData(datas, 0);
	obj.setSkillSubState(subState);
	
	//공통 적용
	obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_HIGH_SPEED_SLASH);	
		
	if(subState == HSS_SUB_STATE_READY)
	{		
		sq_var.setInt(0,0);			   // 현재의 다단 히트 횟수 초기화	
		sq_var.setFloat(1,100.0);			   // 속도 증가율 초기화			 
		sq_var.setBool(2,false);	   // 키입력 초기화
		
		obj.sq_stopMove();
		obj.sq_setCurrentAnimation(CUSTOM_ANI_HIGH_SPEED_READY);		
		obj.sq_PlaySound("PR_FASTCUT_READY");
	}
	else if(subState == HSS_SUB_STATE_ATTACK_1)
	{	
		if(obj.isCarryWeapon())
			obj.setCarryWeapon(false);
		obj.sq_setCurrentAnimation(CUSTOM_ANI_HIGH_SPEED_ATTACK_1);		
		obj.sq_PlaySound("FASTCUT_SWISH");
	}
	else if(subState == HSS_SUB_STATE_ATTACK_2)
	{	
		obj.sq_setCurrentAnimation(CUSTOM_ANI_HIGH_SPEED_ATTACK_2);
		obj.sq_PlaySound("FASTCUT_SWISH");
	}
	else if(subState == HSS_SUB_STATE_ATTACK_3)
	{	
		obj.sq_setCurrentAnimation(CUSTOM_ANI_HIGH_SPEED_ATTACK_3);
		obj.sq_PlaySound("FASTCUT_SWISH");
	}
	else if(subState == HSS_SUB_STATE_ATTACK_4)
	{	
		obj.sq_setCurrentAnimation(CUSTOM_ANI_HIGH_SPEED_ATTACK_4);
		obj.sq_PlaySound("FASTCUT_SWISH");
	}
	else if(subState == HSS_SUB_STATE_LAST)
	{	
		obj.sq_setCurrentAnimation(CUSTOM_ANI_HIGH_SPEED_LAST);
		obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_HIGH_SPEED_SLASH_LAST);	
		obj.sq_PlaySound("FASTCUT_WHOOSH");
		obj.sq_PlaySound("PR_FASTCUT");
	}
	
	if(subState >= HSS_SUB_STATE_ATTACK_1 && subState <= HSS_SUB_STATE_ATTACK_4)
	{	
		local isKeyInput = sq_var.getBool(2);
		if(isKeyInput) {  //키입력이 있었다.
			local speedUpRate = sq_var.getFloat(1); // 속도 증가율
			
			//속도 증가. 
			local intDataSpeedUpRate = obj.sq_getIntData(0);
			local maxSpeedUpRate = obj.sq_getIntData(1);
			
			maxSpeedUpRate = maxSpeedUpRate.tofloat();
			intDataSpeedUpRate = (intDataSpeedUpRate.tofloat() + 100.0) / 100;
			speedUpRate = speedUpRate * intDataSpeedUpRate.tofloat();
			
			if(speedUpRate > maxSpeedUpRate)
				speedUpRate = maxSpeedUpRate;
			
			sq_var.setBool(2,false);
			sq_var.setFloat(1,speedUpRate); //현재 속도 갱신			
						
			if(speedUpRate > 0)
			{
				local ani = obj.sq_getCurrentAni();
				ani.setSpeedRate(speedUpRate);				
				//print("subState" + subState + "speedUpRate : "+speedUpRate);								
			}
		}
		//print("DelaySum : " + obj.sq_getDelaySum());
	}
	
	obj.sq_setAttackPowerWithPassive(SKILL_HIGH_SPEED_SLASH, state, -1,1,1.0);
	
}

function onEndCurrentAni_HighSpeedSlash(obj)
{
	local sq_var = obj.getVar();
	local subStateIndex = obj.getSkillSubState();
	local currentHitCount = sq_var.getInt(0);
	local maxHitCount = obj.sq_getLevelData(0);
	
	if(subStateIndex < HSS_SUB_STATE_LAST && currentHitCount >= maxHitCount){		
		sendSubState_HighSpeedSlash(obj,HSS_SUB_STATE_LAST);
		return;
	}	
	sq_var.setInt(0,currentHitCount+1); //다단히트 횟수 갱신
	
	if(subStateIndex == HSS_SUB_STATE_READY)
		sendSubState_HighSpeedSlash(obj, HSS_SUB_STATE_ATTACK_1);
	else if(subStateIndex == HSS_SUB_STATE_ATTACK_1)
		sendSubState_HighSpeedSlash(obj, HSS_SUB_STATE_ATTACK_2);
	else if(subStateIndex == HSS_SUB_STATE_ATTACK_2)
		sendSubState_HighSpeedSlash(obj, HSS_SUB_STATE_ATTACK_3);
	else if(subStateIndex == HSS_SUB_STATE_ATTACK_3)
		sendSubState_HighSpeedSlash(obj, HSS_SUB_STATE_ATTACK_4);
	else if(subStateIndex == HSS_SUB_STATE_ATTACK_4)
		sendSubState_HighSpeedSlash(obj, HSS_SUB_STATE_ATTACK_1);
	else if(subStateIndex == HSS_SUB_STATE_LAST){
		obj.sq_addSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);		
	}
	
	
}

function onKeyFrameFlag_HighSpeedSlash(obj,flagIndex)
{
	//if(flagIndex == 1)
		
		
	return true;
}