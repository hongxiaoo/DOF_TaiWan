
////////////////////////////////////////////////////////////////////

function enableAuraEffect_AuraTundraSoul(appendage, target)
{
	//print(" auratundra");	
	
	local isAppend = CNSquirrelAppendage.sq_IsAppendAppendage(target, "Character/ATMage/TundraSoul/ap_ATMage_TundraSoulCS.nut");

	print( "isAppend:" + isAppend);
	
	local parentObject = appendage.getParent();
	local parentObj = sq_ObjectToSQRCharacter(parentObject);
	
	if(!parentObj)
		return;
	
	if(isAppend)
	{
		if(sq_IsValidActiveStatus(target, ACTIVESTATUS_FREEZE) || !parentObj.isInBattle())
		{
			CNSquirrelAppendage.sq_RemoveAppendage(target, "Character/ATMage/TundraSoul/ap_ATMage_TundraSoulCS.nut");
		}
		return;
	}
		
		
		
	local appendage = CNSquirrelAppendage.sq_AppendAppendage(target, parentObj, SKILL_TUNDRASOUL, false, 
	"Character/ATMage/TundraSoul/ap_ATMage_TundraSoulCS.nut", true);
	
	local skillLevel = parentObj.sq_GetSkillLevel(SKILL_TUNDRASOUL);
	// 0.얼기까지 걸리는 시간 1.빙결레벨 2.빙결확율 3.빙결시간 4.얼어있는 적 추가 데미지
	local frozenWaitTime = parentObj.sq_GetLevelData(SKILL_TUNDRASOUL, 0, skillLevel); // 0.얼기까지 걸리는 시간
	local frozenLevel = parentObj.sq_GetLevelData(SKILL_TUNDRASOUL, 1, skillLevel);	 // 1.빙결레벨
	local frozenRate = parentObj.sq_GetLevelData(SKILL_TUNDRASOUL, 2, skillLevel);	 // 2.빙결확율
	local frozenTime = parentObj.sq_GetLevelData(SKILL_TUNDRASOUL, 3, skillLevel);	 // 3.빙결시간
	local frozenAddDamageRate = parentObj.sq_GetLevelData(SKILL_TUNDRASOUL, 4, skillLevel);	 // 4.얼어있는 적 추가 데미지

	appendage.getVar("skl").clear_vector();
	appendage.getVar("skl").push_vector(frozenWaitTime);
	appendage.getVar("skl").push_vector(frozenLevel);
	appendage.getVar("skl").push_vector(frozenRate);
	appendage.getVar("skl").push_vector(frozenTime);
	appendage.getVar("skl").push_vector(frozenAddDamageRate);
}

function disableAuraEffect_AuraTundraSoul(appendage, target)
{
	if(!sq_IsValidActiveStatus(target, ACTIVESTATUS_FREEZE))
	{
		CNSquirrelAppendage.sq_RemoveAppendage(target, "Character/ATMage/TundraSoul/ap_ATMage_TundraSoulCS.nut");
	}
	//print(" disable");

}

function isInAuraRange_AuraTundraSoul(appendage, target)
{
	//print(" \n aa:" + target);
	if(sq_IsValidActiveStatus(target, ACTIVESTATUS_FREEZE))
	{
		local isAppend = CNSquirrelAppendage.sq_IsAppendAppendage(target, "Character/ATMage/TundraSoul/ap_ATMage_TundraSoulCS.nut");
		
		if(isAppend)
		{
			//CNSquirrelAppendage.sq_RemoveAppendage(target, "Character/ATMage/TundraSoul/ap_ATMage_TundraSoulCS.nut");
		}
		return false;
	}
	
	if(!sq_IsInBattle())
		return false;
	
	return true;
}
////////////////////////////////////////////////////////////////////

function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_atmage_tundrasoul")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_atmage_tundrasoul")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_atmage_tundrasoul")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_atmage_tundrasoul")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_atmage_tundrasoul")
	appendage.sq_AddFunctionName("onSetHp", "onSetHp_appendage_atmage_tundrasoul")
}


function sq_AddEffect(appendage)
{
}

function proc_appendage_atmage_tundrasoul(appendage)
{
	if(!appendage) {
		return;
	}	
	
	
	local parentObj = appendage.getParent();
	local currentT = appendage.getTimer().Get();
	local rebirthTime_ = appendage.sq_var.get_vector(VECTOR_I_REBIRTH_TIME);
	
	if(!parentObj)
	{
		appendage.setValid(false);
		return;
	}
	
	
	local parentChr = sq_GetCNRDObjectToSQRCharacter(parentObj);
	
	if(!parentChr)
	{
		appendage.setValid(false);
		return;
	}
	
	local skill = sq_GetSkill(parentChr, SKILL_TUNDRASOUL);
	
	if(skill)
	{
		local auraAppendage = 0;
		local appendage = CNSquirrelAppendage.sq_GetAppendage(parentChr, "Character/ATMage/TundraSoul/ap_ATMage_TundraSoul.nut");
		
		if(appendage)
		{
			auraAppendage = appendage.sq_getSquirrelAuraMaster("AuraTundraSoul");
		}
		
		if(!parentChr.isInBattle())
		{ // 전장중이 아니라면.. on이든 off든 무조건 aura 효과를 꺼야합니다.
			if(auraAppendage)
			{
				if(parentChr.isMyControlObject())
				{
					sq_BinaryStartWrite();
					sq_BinaryWriteDword(1); // 
					sq_SendChangeSkillEffectPacket(parentChr, SKILL_TUNDRASOUL);
				}
			}
		}
		else		
		{ // 전장중이라면..

			if(skill.isSealFunction())
			{ // off인데 아우라가 있으면 꺼야합니다.
				if(auraAppendage)
				{
					//print(" parentChr.isInBattle():" + parentChr.isInBattle() + " auraAppendage:" + auraAppendage);
					if(parentChr.isMyControlObject())
					{
						sq_BinaryStartWrite();
						sq_BinaryWriteDword(1); // 
						sq_SendChangeSkillEffectPacket(parentChr, SKILL_TUNDRASOUL);
					}
				}
			}
			else
			{ // on인데 아우라가 없으면 켜야합니다.
				if(parentObj.getState() == STATE_DIE) // 죽은상태라면 아우라를 일단 꺼야합니다.
				{
					if(auraAppendage)
					{
						if(parentChr.isMyControlObject())
						{
							sq_BinaryStartWrite();
							sq_BinaryWriteDword(1); // 
							sq_SendChangeSkillEffectPacket(parentChr, SKILL_TUNDRASOUL);
						}
					}
				}
				else
				{				
					if(!auraAppendage)
					{
						if(parentChr.isMyControlObject())
						{
							//print(" parentChr.isInBattle():" + parentChr.isInBattle() + " auraAppendage:" + auraAppendage);
							sq_BinaryStartWrite();
							sq_BinaryWriteDword(0); // 
							sq_SendChangeSkillEffectPacket(parentChr, SKILL_TUNDRASOUL);
						}
					}
					else
					{ // 아우라가 있다는 상태이지만 valid가 false일 수 있습니다.
						if(!auraAppendage.isValid())
						{ // 아우라가 isvalid가 false라면.. 일단 지워야합니다.
							print( " \n\n valid:" + auraAppendage.isValid());
							sq_BinaryStartWrite();
							sq_BinaryWriteDword(1); // 
							sq_SendChangeSkillEffectPacket(parentChr, SKILL_TUNDRASOUL);
						}
					}
				}
			}
		}
	}
	
}


function onStart_appendage_atmage_tundrasoul(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();		


	appendage.sq_var.clear_timer_vector();
	appendage.sq_var.push_timer_vector();
	appendage.sq_var.push_timer_vector();
	
	appendage.sq_var.clear_vector();
	appendage.sq_var.push_vector(0); // state
			
	local t = appendage.sq_var.get_timer_vector(0);
	t.setParameter(400, -1);
	t.resetInstant(0);
	
	local sqrObj = sq_GetCNRDObjectToSQRCharacter(obj);
	
	if(sqrObj)
	{
	}
}


function prepareDraw_appendage_atmage_tundrasoul(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}

function onEnd_appendage_atmage_tundrasoul(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();		
	
	local sqrObj = sq_GetCNRDObjectToSQRCharacter(obj);
	
	if(sqrObj)
	{
	}
	
}

// 어벤져 각성 변신의 끝부분
function isEnd_appendage_atmage_tundrasoul(appendage)
{
	if(!appendage)
		return false;
		
	local T = appendage.getTimer().Get();	
	
	return false;
}