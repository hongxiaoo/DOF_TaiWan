


function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_creator_flame")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_creator_flame")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_creator_flame")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_creator_flame")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_creator_flame")
}


function sq_AddEffect(appendage)
{
}

function proc_appendage_creator_flame(appendage)
{
	if (!appendage)
	{
		return;
	}
	
	local cnt = appendage.sq_var.get_vector(I_REMAIN_COUNT);
	local isCharge = appendage.sq_var.get_vector(l_CHARGE_ON); // 충전 중인지 체크

	
	// 충전모드라면..
	if (isCharge)
	{
	
		// 최대충전량을 얻어와서 충전을 시킵니다.
		local time = appendage.getTimer().Get();

		appendage.sq_var.set_vector(I_CURRENT_CHARGE_TIME, time);
		
		local maxCnt = appendage.sq_var.get_vector(I_MAX_COUNT);
		local initRemainCnt = appendage.sq_var.get_vector(I_CHARGE_INIT_COUNT);
		local maxChargeT = appendage.sq_var.get_vector(I_CHARGE_TIME);
		local chargeTime = maxChargeT.tofloat() * ((maxCnt.tofloat() - initRemainCnt.tofloat()) / maxCnt.tofloat());
		
		//print(" flame charge t:" + maxChargeT);

		local currentCnt = sq_GetUniformVelocity(initRemainCnt, maxCnt, time, chargeTime.tointeger());
		appendage.sq_var.set_vector(I_REMAIN_COUNT, currentCnt);
		
		// 다 채웠다면 충전모드 해제
		if (currentCnt >= maxCnt)
		{
			appendage.sq_var.set_vector(l_CHARGE_ON, 0);
			appendage.sq_var.set_vector(I_CHARGE_INIT_COUNT, 0);
			appendage.sq_var.set_vector(I_CURRENT_CHARGE_TIME, 0);
		}
	}
	
}


function onStart_appendage_creator_flame(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
	
	local sq_var = appendage.sq_var;
	sq_var.clear_timer_vector();
	sq_var.push_timer_vector();
	
	local t = sq_var.get_timer_vector(0);
	
	if (t)
	{
		local eventTerm = 10;
		t.setParameter(eventTerm, -1);
		t.resetInstant(0);
	}
}


function prepareDraw_appendage_creator_flame(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}




function onEnd_appendage_creator_flame(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();
}


function isEnd_appendage_creator_flame(appendage)
{
	if(!appendage) return false;
	
	local T = appendage.getTimer().Get();
	
	return false;
}