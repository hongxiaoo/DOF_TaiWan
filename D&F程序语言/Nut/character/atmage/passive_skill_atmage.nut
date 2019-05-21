/////////////////////////////////////////////////////////
//
// 패시브 스킬처리
// 해당 스킬의 패시브 스킬의 Appendage등록/해제 등등
//
/////////////////////////////////////////////////////////

function ProcPassiveSkill_ATMage(obj, skill_index, skill_level)
{
	if (skill_index == SKILL_EXPRESSION)
	{
		if(skill_level > 0)
		{
			local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, skill_index, false, "Character/ATMage/Expressions/ap_atmage_expression.nut", true);
		
				print(" expression appendage:" + appendage);
			if(appendage)
			{
				local magicalAtkChangeRate = sq_GetLevelData(obj, skill_index, SKL_LVL_COLUMN_IDX_1, skill_level);				
				
				local change_appendage = appendage.sq_getChangeStatus("expression");
				
				if(!change_appendage) {
					change_appendage = appendage.sq_AddChangeStatus("expression",obj, obj, 0, CHANGE_STATUS_TYPE_MAGICAL_ATTACK, false, magicalAtkChangeRate );
				}
				
				
				if(change_appendage)
				{
					change_appendage.clearParameter();
					
					print(" expression attack rate:" + magicalAtkChangeRate.tofloat());
					change_appendage.addParameter(CHANGE_STATUS_TYPE_MAGICAL_ATTACK, false, magicalAtkChangeRate.tofloat());
				}
			}
		}
	}
	else if(skill_index == SKILL_DIEHARD)
	{ // 불사
		if(skill_level > 0)
		{
			local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, skill_index, false, 
			"Character/ATMage/DieHard/ap_ATMage_DieHard.nut", true);

			if(appendage)
			{
			}
		}
	
	}
	else if(skill_index == SKILL_TUNDRASOUL)
	{ // 툰드라의 가호
		if(skill_level > 0)
		{
			local skill = sq_GetSkill(obj, SKILL_TUNDRASOUL);
			if(!skill)
				return true;
			
			print( " passive_skill_tundrasoul");
			//if(!skill.isSealFunction())
			{
				local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, skill_index, false, 
				"Character/ATMage/TundraSoul/ap_ATMage_TundraSoul.nut", true);
				
				if(appendage)
				{
					print(" passive object isinBattle:" + obj.isInBattle());
					
					//if(!skill.isSealFunction())
					//{
						//if(sq_IsInBattle())
						//{
							//local range = obj.sq_GetIntData(SKILL_TUNDRASOUL , 0);// 0. 빙결 상태이상에 걸리는 효과범위
							//local AuraTundraSoulAppendage = appendage.sq_AddSquirrelAuraMaster("AuraTundraSoul",obj, obj, range, 18, 5, 0);
						//}
						//else
						//{
							//appendage.sq_DeleteAppendages();
						//}
					//}
					//else
					//{
						//appendage.sq_DeleteAppendages();
					//}
				}
			}
		}
	}
	
	return true;
}


function onUseSkillPassiveSkill_ATMage(obj,skillIndex, skillLevel)
{
	if(!obj)
		return;		
		
	print( " onuseskill");

}




