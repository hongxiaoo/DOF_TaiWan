/////////////////////////////////////////////////////////
//
// 패시브 스킬처리
// 해당 스킬의 패시브 스킬의 Appendage등록/해제 등등
//
/////////////////////////////////////////////////////////
function ProcPassiveSkillAvenger(obj, skill_index, skill_level)
{
	if (skill_index == SKILL_SCYTHE_MASTERY)
	{
		if (obj.getWeaponSubType() == WEAPON_SUBTYPE_SCYTHE && skill_level > 0)
		{
			local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, skill_index, false, "Appendage/Character/scythe_mastery.nut", true);
			
			local attack_speed = sq_GetLevelData(obj, skill_index, 0, skill_level);
			local dark_element = sq_GetLevelData(obj, skill_index, 1, skill_level);
			local light_element = sq_GetLevelData(obj, skill_index, 2, skill_level) * -1;
			local weaponMagicAttack = sq_GetLevelData(obj, skill_index, 3, skill_level);

			local change_appendage = appendage.sq_getChangeStatus("scythe");
			if(!change_appendage) {
				change_appendage = appendage.sq_AddChangeStatus("scythe",obj, obj, 0, CHANGE_STATUS_TYPE_ATTACK_SPEED, true, attack_speed );
			}
		
			// 공속증가, 암속성 저항증가, 명속성 저항감소
			if(change_appendage) {
				change_appendage.clearParameter();
				change_appendage.addParameter(CHANGE_STATUS_TYPE_ATTACK_SPEED, true, attack_speed.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_DARK, false, dark_element.tofloat());
				change_appendage.addParameter(CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_LIGHT, false, light_element.tofloat());
				
				change_appendage.addParameter(CHANGE_STATUS_TYPE_EQUIPMENT_MAGICAL_ATTACK, true, weaponMagicAttack.tofloat());				
			}
		}
		else
		{
			//CNSquirrelAppendage.sq_RemoveAppendage(obj, "Appendage/Character/scythe_mastery.nut");			
			if(skill_level > 0) {
				local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, skill_index, false, "Appendage/Character/scythe_mastery.nut", true);
			
				if(appendage) {					
					local change_appendage = appendage.sq_getChangeStatus("scythe");					
					if(change_appendage) {
						change_appendage.clearParameter();
					}
				}
			}
		}
	}
	else if(skill_index == SKILL_HEARTHINGS)
	{
		if (skill_level > 0)
			obj.sq_addPassiveSkillAttackBonusRate(SKILL_HEARTHINGS,1);
	}
	
	if(skill_index == SKILL_DEVILSTRIKE) { // 데빌스트라이커 
		if (skill_level > 0) {
			local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, skill_index, false, "Appendage/Character/ap_avenger_devilstrike.nut", true);
			local maxValue = sq_GetIntData(obj, SKILL_DEVILSTRIKE, SI_DS_MAX_DEVIL_GAUGE); // 최대 악마게이지 수치
			if(appendage.sq_var.size_vector() != 5) { // 지난 게이지가 지워지는 버그수정
				appendage.sq_var.clear_vector();		
				appendage.sq_var.push_vector(maxValue); // 최대 악마게이지 수치
				appendage.sq_var.push_vector(0); // 현재 악마게이지 수치
				appendage.sq_var.push_vector(0); // 지난 수치
				appendage.sq_var.push_vector(0); // 
				appendage.sq_var.push_vector(0);
			}
			else {
			 // 만일 맥스게이지가 다르다면 갱신해줘야합니다..
				local max_gauge = appendage.sq_var.get_vector(DS_APEND_MAX_GAUGE);
				
				if(max_gauge != maxValue) {
					appendage.sq_var.set_vector(DS_APEND_MAX_GAUGE, maxValue);
				}
			}
			
			obj.getVar("devilStrike").clear_vector();
			obj.getVar("devilStrike").push_vector(0); // character "devilstrike" sqrvar 0번인덱스 기술을 쓴 인덱스
			obj.getVar("devilStrike").push_vector(0);
			obj.getVar("devilStrike").push_vector(0);
			obj.getVar("devilStrike").push_vector(0);
			
			obj.getVar("devilStrike").clear_ct_vector(); // 타이머 클리어
			obj.getVar("devilStrike").push_ct_vector();
			obj.getVar("devilStrike").push_ct_vector();
			obj.getVar("devilStrike").push_ct_vector();
			
			obj.getVar("devilStrike").get_ct_vector(0).Reset();
			obj.getVar("devilStrike").get_ct_vector(0).Start(0,0);
			
			
			appendage.sq_var.clear_timer_vector(); // 타이머 클리어
			appendage.sq_var.push_timer_vector(); // 타이머 푸시
			appendage.sq_var.push_timer_vector();
		}
		else {
			CNSquirrelAppendage.sq_RemoveAppendage(obj, "Appendage/Character/ap_avenger_devilstrike.nut");
		}
	}
	
	if(skill_index == SKILL_NIGHTMARE) { // 각성 패시브악몽(48레벨)
		// 각성패시브 : 악몽(48레벨)
		// 1. 각성 변신 동안 각성기 공격력이 증가함
		// 2. 데빌 스트라이커의 악마 게이지 차는량 증가.
		// 각성패시브 악몽을 갖고 있는지 체크하고 갖고 있다면 악마 게이지 차는량을 증가시켜서 리턴합니다..	
		if (skill_level > 0) {
			obj.sq_addPassiveSkillAttackBonusRate(SKILL_NIGHTMARE,1); // 1.공격력 증가량(%)
		}
		//if (skill_level > 0) {
			//local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, skill_index, false, "Appendage/Character/ap_avenger_nightmare.nut", true);
			//obj.sq_addPassiveSkillAttackBonusRate(SKILL_NIGHTMARE,1);
		//}
		//else {
			//CNSquirrelAppendage.sq_RemoveAppendage(obj, "Appendage/Character/ap_avenger_nightmare.nut");
		//}
	}
	
	
	return true;
}


function onUseSkillAvengerPassiveSkill(obj,skillIndex, skillLevel)
{
	if(!obj)
		return;
		
	local hearthingsLevel = obj.sq_getSkillLevel(SKILL_HEARTHINGS);
	local activeRate	  = obj.sq_getIntData(SKILL_HEARTHINGS,1); //발동 확률
		
	if(activeRate >= sq_getRandom(0,100) && hearthingsLevel > 0 && obj.isSkillClassType(skillIndex,3)) {		
			
		local time				= obj.sq_getLevelData(SKILL_HEARTHINGS,0,hearthingsLevel);
		local changeMoveSpeed	= obj.sq_getLevelData(SKILL_HEARTHINGS,2,hearthingsLevel);
		local changeHp			= obj.sq_getLevelData(SKILL_HEARTHINGS,3,hearthingsLevel) * -1;
		local changeMp			= obj.sq_getLevelData(SKILL_HEARTHINGS,4,hearthingsLevel) * -1;
		local currentCount		= 1;
		local maxCount			= obj.sq_getIntData(SKILL_HEARTHINGS,0);
				
		local oldAppendage = obj.GetSquirrelAppendage("Appendage/Character/hearthings.nut");
		if(oldAppendage) {
			currentCount = currentCount + oldAppendage.sq_var.getInt(0);
			if(currentCount > maxCount) // 중첩 최대치 
				return;
		}		
	
		local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, skillIndex, true, "Appendage/Character/hearthings.nut", true);		
		local change_appendage = appendage.sq_getChangeStatus("hearthings");
		
		if(!change_appendage) {
			change_appendage = appendage.sq_AddChangeStatus("hearthings",obj, obj, 0, CHANGE_STATUS_TYPE_MOVE_SPEED, true, currentCount.tointeger() * changeMoveSpeed.tointeger() );
		}
		
		if(change_appendage) {
			change_appendage.clearParameter();
			change_appendage.addParameter(CHANGE_STATUS_TYPE_MOVE_SPEED, true, currentCount.tofloat() * changeMoveSpeed.tofloat());
			change_appendage.addParameter(CHANGE_STATUS_TYPE_HP_MAX, true, currentCount.tofloat() * changeHp.tofloat());
			change_appendage.addParameter(CHANGE_STATUS_TYPE_MP_MAX, true, currentCount.tofloat() * changeMp.tofloat());			
		}
		
		appendage.getAppendageInfo().setValidTime(time); // 유효시간	
				
		appendage.sq_var.setInt(0,currentCount.tointeger());
	}

}



function OnBeforeAttackAvengerPassiveSkill(obj, damager, bounding_box, is_stuck)
{
	// 사이드 마스터리를 갖고 있다면, 낫에 의한 타격 물리 공격을 -> 마법 공격으로 바꿔준다.
	if(!obj) return false;
	
	if (is_stuck == false)
	{
		local result = CNSquirrelAppendage.sq_IsAppendAppendage(obj, "Appendage/Character/scythe_mastery.nut");
		

		if (result == true)
		{
			if(obj.getWeaponSubType() == WEAPON_SUBTYPE_SCYTHE) { // 낫 일때만
				// state 가 평타일때와 물리타일때만 적용됩니다..
				local state = obj.sq_GetSTATE();
				if(sqr_IsNormalAttack(state) == true) {
					local attack_info = sq_GetCurrentAttackInfo(obj);			
					local eType = sq_GetAttackType(attack_info);
					if(eType == ATTACKTYPE_PHYSICAL) {
						sq_ChangeAttackTypeToOpposite(attack_info);
					}
				}
			}
		}
	}
	
	return true;
}


