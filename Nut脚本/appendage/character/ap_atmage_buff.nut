
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_atmage_buff")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_atmage_buff")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_atmage_buff")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_atmage_buff")
	appendage.sq_AddFunctionName("drawAppend", "drawAppend_appendage_atmage_buff")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_atmage_buff")
}


function sq_AddEffect(appendage)
{
}

function proc_appendage_atmage_buff(appendage)
{
	if(!appendage) {
		return;
	}
	
}


function onStart_appendage_atmage_buff(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
	
	
}


function prepareDraw_appendage_atmage_buff(appendage)
{
	if(!appendage) {
		return;
	}
}




function onEnd_appendage_atmage_buff(appendage)
{
	if(!appendage) {
		return;
	}	
}

function drawAppend_appendage_atmage_buff(appendage, isOver, x, y, isFlip)
{
	if(!appendage) {
		return;
	}

	local T = appendage.getTimer().Get();
	local validT = appendage.getAppendageInfo().getValidTime()
	
	if(validT < T)
	{
		appendage.setValid(false);	
	}
	
}

// 어벤져 각성 변신의 끝부분
function isEnd_appendage_atmage_buff(appendage)
{
	if(!appendage) return false;
	
	
	return false;
}