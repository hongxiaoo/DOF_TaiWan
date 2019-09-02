
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_expression")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_expression")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_expression")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_expression")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_expression")
}


function sq_AddEffect(appendage)
{
}

function proc_appendage_expression(appendage)
{
	if(!appendage) {
		return;
	}
	
}


function onStart_appendage_expression(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
	
	
}


function prepareDraw_appendage_expression(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}




function onEnd_appendage_expression(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();
}


function isEnd_appendage_expression(appendage)
{
	if(!appendage) return false;
	
	local T = appendage.getTimer().Get();
	
	return false;
}