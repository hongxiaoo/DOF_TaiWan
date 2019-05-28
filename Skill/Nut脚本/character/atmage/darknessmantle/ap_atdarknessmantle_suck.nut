
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_atdarkness_suck")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_atdarkness_suck")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_atdarkness_suck")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_atdarkness_suck")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_atdarkness_suck")
}


function sq_AddEffect(appendage)
{
}

function proc_appendage_atdarkness_suck(appendage)
{
	if(!appendage) {
		return;
	}
	
	local parentObj = appendage.getParent();
	local source = appendage.getSource();

	local isExist = sq_IsExistObject(parentObj, source);
	
	if(!isExist)
	{ // 중복되는것이 없다면..	흡수 오로라를 지웁니다.
		print( "\n\n proc_appendage_atdarkness_suck setvalid false");
		appendage.setValid(false);
	}
	
}


function onStart_appendage_atdarkness_suck(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
	
	
}


function prepareDraw_appendage_atdarkness_suck(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}




function onEnd_appendage_atdarkness_suck(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();
	print( "\n\n delete suck appendage");
	appendage.sq_DeleteAppendages();
}


// 어벤져 각성 변신의 끝부분
function isEnd_appendage_atdarkness_suck(appendage)
{
	if(!appendage) return false;
	
	local T = appendage.getTimer().Get();
	
	return false;
}