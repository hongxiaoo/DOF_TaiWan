
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_atmage_manaburst")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_atmage_manaburst")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_atmage_manaburst")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_atmage_manaburst")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_atmage_manaburst")
}


function sq_AddEffect(appendage)
{
	if(!appendage)
		return;
	appendage.sq_AddEffectFront("Character/Mage/Effect/Animation/ATManaBurst/00_mana_dodge_loop.ani")
}




function proc_appendage_atmage_manaburst(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();
	
	local currentT = appendage.getTimer().Get();
	local t = appendage.sq_var.get_timer_vector(0);
	//
	local time = appendage.sq_var.get_vector(0);	
	
	
}


function onStart_appendage_atmage_manaburst(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();		


	appendage.sq_var.clear_timer_vector();
	appendage.sq_var.push_timer_vector();
	appendage.sq_var.push_timer_vector();
			
	local t = appendage.sq_var.get_timer_vector(0);
	t.setParameter(400, -1);
	t.resetInstant(0);

	local t2 = appendage.sq_var.get_timer_vector(1);
	t2.setParameter(500, -1);
	t2.resetInstant(0);	
	
	local sqrObj = sq_GetCNRDObjectToSQRCharacter(obj);
	
	if(sqrObj)
	{
		sqrObj.sq_RemovePassiveSkillAttackBonusRate(SKILL_MANABURST);
		sqrObj.sq_AddPassiveSkillAttackBonusRate(SKILL_MANABURST, SKL_LVL_COLUMN_IDX_1);
		sqrObj.sq_PlaySound("FLOODMANA_LOOP", 7577);
	}
}


function prepareDraw_appendage_atmage_manaburst(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}




function onEnd_appendage_atmage_manaburst(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();		
	
	local sqrObj = sq_GetCNRDObjectToSQRCharacter(obj);
	
	if(sqrObj)
	{
		sqrObj.sq_RemovePassiveSkillAttackBonusRate(SKILL_MANABURST);
		sqrObj.stopSound(7577);
	}
	
}

// 어벤져 각성 변신의 끝부분
function isEnd_appendage_atmage_manaburst(appendage)
{
	if(!appendage)
		return false;
		
	local T = appendage.getTimer().Get();	
	
	return false;
}