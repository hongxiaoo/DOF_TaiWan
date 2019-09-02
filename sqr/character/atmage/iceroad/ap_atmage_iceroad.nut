
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_atmage_iceroad")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_atmage_iceroad")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_atmage_iceroad")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_atmage_iceroad")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_atmage_iceroad")
}


function sq_AddEffect(appendage)
{
	if(!appendage)
		return;
	appendage.sq_AddEffectFront("Character/Mage/Effect/Animation/ATIceRoad/loop/00_icebottom_dodge.ani")
}




function proc_appendage_atmage_iceroad(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();
	
	local currentT = appendage.getTimer().Get();
	local t = appendage.sq_var.get_timer_vector(0);
	//
	//if (t.isOnEvent(currentT) == true) {
		//if(obj.isMyControlObject()) {	
			//if(obj.getZPos() == 0) {
				//local skill = sq_GetSkill(obj, SKILL_ICEROAD); //->getSpendMp(this);
			//
				//if(skill) {
					//local spendMp = skill.getSpendMp(obj, -1);
					//if (spendMp > obj.getMp())
					//{
						//appendage.setValid(false);
						//skill.setSealActiveFunction(true);
					//}
					//else
					//{
						//// MP가 충분하다면 얼음의 길 한조각을 만든다..
						//sq_SendCreatePassiveObjectPacket(obj, 24243, 0, 0, 0, 0, obj.getDirection());
						//obj.sendSetMpPacket(obj.getMp() - spendMp);
					//}
				//
				//}
			//}
		//}
	//}
	//
	local state = sq_GetState(obj);
	
	local term = -1;
	
	if(state == STATE_DASH) {
		term = 400;
	}
	else if(state == STATE_STAND) {
		if(!obj.isStay()) {
			term = 800;
		}
	}
	
	if(t.getEventTerm() != term) {
		t.setParameter(term, -1);
		t.resetInstant(0);
	}
	
	
}

function onStart_appendage_atmage_iceroad(appendage)
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
	
	//appendage.sq_var.clear_vector();		
	//appendage.sq_var.push_vector(20000); // I_AVENGER_AWAKENING_TIME	
	//appendage.sq_var.push_vector(4000); // 완전 변신체 HP 
	
	local obj = appendage.getParent();	
	if(obj)
		obj.sq_PlaySound("ICEROAD_LOOP", 7578);
	

}


function onEnd_appendage_atmage_iceroad(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();
	if(obj)
		obj.stopSound(7578);
	
}

function prepareDraw_appendage_atmage_iceroad(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}



// 어벤져 각성 변신의 끝부분
function isEnd_appendage_atmage_iceroad(appendage)
{
	if(!appendage)
		return false;
	local T = appendage.getTimer().Get();	
	
	return false;
}