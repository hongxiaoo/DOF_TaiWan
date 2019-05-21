
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_PowerOfDarkness")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_PowerOfDarkness")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_PowerOfDarkness")
}


function proc_appendage_PowerOfDarkness(appendage)
{
	if(!appendage) {
		return;
	}
	
}



function onStart_appendage_PowerOfDarkness(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();		

}



function onEnd_appendage_PowerOfDarkness(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();		
	if(obj && sq_IsMyControlObject(obj) ) {
		sq_SimpleMoveToNearMovablePos(obj,200);
		//obj.setObjectHeight(-1);
	}
	
}

