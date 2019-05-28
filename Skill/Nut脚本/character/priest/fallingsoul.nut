


//------------------------------------------------------------------------------
function IsCheckUseFallingSoul(obj) 
{
	if(!obj) return false; 
	local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_devilstrike.nut"); // 데빌스트라이커 어펜디지
	if(!appendage) return false;
	
	
	if(appendage.sq_var.size_vector() > 1) {
		// 7. 악마게이지 소모량
		local skillLevel = sq_GetSkillLevel(obj, SKILL_FALLING_SOUL);		
		local consumeMax = sq_GetIntData(obj, SKILL_FALLING_SOUL, 0, skillLevel);
		local time       = sq_GetLevelData(obj, SKILL_FALLING_SOUL, 1, skillLevel);
		local darkPower  = sq_GetLevelData(obj, SKILL_FALLING_SOUL, 2, skillLevel);
		
		//DS_APEND_MAX_GAUGE <- 0 // 최대 악마게이지 수치
		//DS_APEND_GAUGE <- 1 // 현재 악마게이지 수치
		
		local consumeValue = appendage.sq_var.get_vector(DS_APEND_GAUGE); // gauge index 0
		if(consumeValue == 0)
		{		
			obj.startCantUseSkillWarning();
			if (obj.isMessage())
				sq_AddMessage(29002); // 29002>악마게이지가 부족합니다.
			return false;
		}
		
		if(consumeMax < consumeValue)
			consumeValue = consumeMax;		
		
			
		local consumeRate = sq_GetLevelData(obj, SKILL_FALLING_SOUL, 0, skillLevel);
		consumeRate = consumeRate.tofloat()/100.0;
		
		
		//print("---- Falling Soul info -----------------------")
		//print("consume : " + consumeValue + " / " + consumeRate);
		
		local magicPowerUpValue = (consumeValue*consumeRate) + 0.5;		
		
		print("magicPowerUpValue : " + magicPowerUpValue);		
		
		magicPowerUpValue = magicPowerUpValue.tointeger();
		
		print("magicPowerUpValue : " + magicPowerUpValue);
		//print("time : " + time);
		
		
		
		local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_FALLING_SOUL, false, "FallingSoul", false);
		
		// 버프 UI 출력 어펜드를 걸어주기 전에 호출되어야 합니다..
		local skill_level = sq_GetSkillLevel(obj, SKILL_FALLING_SOUL);
		appendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, sq_getJob(obj), SKILL_FALLING_SOUL, skill_level);
		//
		
		// 여기서 append 작업		
		CNSquirrelAppendage.sq_Append(appendage, obj, obj);
		

		local change_appendage = appendage.sq_getChangeStatus("FallingSoulMagic");
		if(!change_appendage) {
			change_appendage = appendage.sq_AddChangeStatus("FallingSoulMagic",obj, obj, time, CHANGE_STATUS_TYPE_MAGICAL_ATTACK, false, magicPowerUpValue.tointeger());
		}

		// 공속증가, 암속성 저항증가, 명속성 저항감소
		if(change_appendage) {
			change_appendage.clearParameter();
			change_appendage.addParameter(CHANGE_STATUS_TYPE_MAGICAL_ATTACK, false, magicPowerUpValue.tofloat());
			change_appendage.addParameter(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_DARK, false, darkPower.tofloat());
			//local appendageInfo = change_appendage.getAppendageInfo();
			//appendageInfo.setValidTime(time);
		}
		
		local appendageInfo = appendage.getAppendageInfo();
		appendageInfo.setValidTime(time);
		
		consumeDevilGauge(obj, consumeValue); // 악마게이지를 줄여줍니다..
		
		return true;
	}
	
	
	return false;
}

function checkCommandEnable_FallingSoul(obj)
{

	if(!obj) return false;

	local bRet = true;
	
	local state = obj.sq_GetSTATE();
	
	if(state == STATE_ATTACK) {
		////캔슬기 삭제 작업 (2012.04.12) bRet = obj.sq_IsCommandEnable(SKILL_FALLING_SOUL);
		bRet = obj.sq_IsCommandEnable(SKILL_FALLING_SOUL);
	}
	
	if(!bRet) return false;
	

	local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_devilstrike.nut"); // 데빌스트라이커 어펜디지
	if(!appendage) 
		return false;
	
	local consumeValue = appendage.sq_var.get_vector(DS_APEND_GAUGE); // gauge index 0
	if(consumeValue == 0)
		return false;	
		
	return true;
}


		


// 스킬 세부발동 조건을 만들어주는 함수입니다.. 발동 조건 state는 이미 소스에서 구현되어 있습니다. 이곳에서 useskill과 setstate를 지정해주면 됩니다.
function checkExecutableSkill_FallingSoul(obj)  
{
	if(!obj) return false;
	local b_useskill = obj.sq_IsUseSkill(SKILL_FALLING_SOUL);


	if(b_useskill) {
		if(IsCheckUseFallingSoul(obj)) { // 악마게이지로 처형을 쓸 수 있습니다..					
			if(obj.isMyControlObject())
			{
				obj.sq_IntVectClear();				
				obj.sq_IntVectPush(0);
				obj.sq_IntVectPush(0); //THROW_TYPE_SKILL
				obj.sq_IntVectPush(SKILL_FALLING_SOUL);
				obj.sq_IntVectPush(500);
				obj.sq_IntVectPush(500);
				obj.sq_IntVectPush(3);
				obj.sq_IntVectPush(4);  //SPEED_TYPE_CAST_SPEED
				obj.sq_IntVectPush(4);  //SPEED_TYPE_CAST_SPEED
				obj.sq_addSetStatePacket(STATE_THROW, STATE_PRIORITY_USER, true);
			}

			return true;
		}
	}	
	
	return false;
}


//------------------------------------------------------------------------------


// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_FallingSoul(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
}