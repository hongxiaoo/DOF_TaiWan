
function onAfterSetState_ElementalChange(obj, state, datas, isResetTimer)
{
	obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
		SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
		
	local throwState = obj.getThrowState();
	
	if (throwState == 1)
	{		
		// 속성발동 appendage 걸어주기
		local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_ELEMENTAL_CHANGE, false, "Character/ATMage/ElementalChange/ap_ATMage_Elemental_Change.nut", false);
		local skillLevel = sq_GetSkillLevel(obj, SKILL_ELEMENTAL_CHANGE);
		local validTime = sq_GetLevelData(obj, SKILL_ELEMENTAL_CHANGE, 0, skillLevel); 
		
		if (appendage != null)
		{
			// 버프 UI 출력 어펜드를 걸어주기 전에 호출되어야 합니다.
			appendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, sq_getJob(obj), SKILL_ELEMENTAL_CHANGE, skillLevel);
			appendage.sq_SetValidTime(validTime);			
			appendage.setBuffIconImage(55);
			appendage.setEnableIsBuff(true);
			CNSquirrelAppendage.sq_AppendAppendageID(appendage, obj, obj, APID_SKILL_ELEMENTAL_CHANGE, false);
		}
		
		// 속성 보호의 속성을 바꿔 준다.		
		local skillLevel = sq_GetSkillLevel(obj, SKILL_ELEMENTAL_SHIELD);
		if(skillLevel > 0)		
		{				
			sq_RemoveChangeStatus(obj, APID_AT_MAGE_ELEMENT_SHIELD);
			
			local elementalType = obj.getThrowElement();	
			local upValue = sq_GetIntData(obj, SKILL_ELEMENTAL_SHIELD, 0);
			local ap = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_FIRE + elementalType, false, upValue.tofloat() , 0);
			if (ap)
			{
				ap.getAppendageInfo().setValidTime(validTime);				
				ap.sq_Append(obj, obj, APID_AT_MAGE_ELEMENT_SHIELD, 0, null);
			}			
		}
		
		local element = obj.getThrowElement();
		local x = obj.getXPos();
		local y = obj.getYPos() + 1;
		local z = obj.getZPos();
		
		if (element == ENUM_ELEMENT_FIRE)
			createAnimationPooledObject(obj, "Character/Mage/Effect/Animation/ATElementalChange/00_fire_dodge.ani", true, x, y, z);
		else if (element == ENUM_ELEMENT_WATER)
			createAnimationPooledObject(obj, "Character/Mage/Effect/Animation/ATElementalChange/00_ice_dodge.ani", true, x, y, z);
		else if (element == ENUM_ELEMENT_DARK)
			createAnimationPooledObject(obj, "Character/Mage/Effect/Animation/ATElementalChange/01_dark_dodge.ani", true, x, y, z);
		else if (element == ENUM_ELEMENT_LIGHT)
			createAnimationPooledObject(obj, "Character/Mage/Effect/Animation/ATElementalChange/00_light_dodge.ani", true, x, y, z);		
	}
	else if (throwState == 3) 
	{
		obj.sq_PlaySound("PCHANGE");
	}
}

function onAfterSetState_ManaBurst(obj, state, datas, isResetTimer)
{
	local throwState = obj.getThrowState();
	
	if (throwState == 1)
	{
		obj.sq_PlaySound("MW_FLOODMANA");
		obj.sq_PlaySound("FLOODMANA_CAST");
	
		// 마나폭주
		local skillLevel = obj.sq_GetSkillLevel(SKILL_MANABURST);
		local change_time = sq_GetLevelData(obj, SKILL_MANABURST, SKL_LVL_COLUMN_IDX_2, skillLevel);
		
		
		local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_MANABURST, false, 
		"Character/ATMage/ManaBurst/ap_ATMage_ManaBurst.nut", false);
		
		appendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, sq_getJob(obj), SKILL_MANABURST, skillLevel);
		appendage.sq_SetValidTime(change_time); // 어펜디지 타임 세팅
		
		// 여기서 append 작업		
		//CNSquirrelAppendage.sq_Append(appendage, obj, obj);
		CNSquirrelAppendage.sq_Append(appendage, obj, obj, true); // 버프온
	}
}




function onAfterSetState_Throw(obj, state, datas, isResetTimer)
{
	local skillIndex = obj.getThrowIndex();
	
	if (skillIndex == SKILL_ELEMENTAL_CHANGE)
	{
		onAfterSetState_ElementalChange(obj, state, datas, isResetTimer);
		
		if (obj.getThrowState() == 0)
		{
			// 커스텀 UI를 활성화 시킨다.
			obj.setIsCustomSelectSkill(true);
		}
		else if (obj.getThrowState() == 1)
		{
			obj.sq_PlaySound("PCHANGE_SELECT");
			
			
			if (obj.isMyControlObject())
			{
				sq_BinaryStartWrite();
				sq_BinaryWriteByte(obj.getThrowElement());
				sq_SendChangeSkillEffectPacket(obj, SKILL_ELEMENTAL_CHANGE);
			}
		}		
	}
	else if(skillIndex == SKILL_MANABURST)
	{
		onAfterSetState_ManaBurst(obj, state, datas, isResetTimer);
	}
}
