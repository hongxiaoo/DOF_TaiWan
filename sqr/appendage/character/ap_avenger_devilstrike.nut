
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_avenger_devilstrike")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_avenger_devilstrike")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_avenger_devilstrike")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_avenger_devilstrike")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_avenger_devilstrike")
}


function sq_AddEffect(appendage)
{
	//appendage.sq_AddEffectFront("Character/Priest/Effect/Animation/ScytheMastery/1_aura_normal.ani")
}

function proc_appendage_avenger_devilstrike(appendage)
{
	if(!appendage) {
		return;
	}
	
}


function onStart_appendage_avenger_devilstrike(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
	
}


function prepareDraw_appendage_avenger_devilstrike(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}




function onEnd_appendage_avenger_devilstrike(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();
}


// 어벤져 각성 변신의 끝부분
function isEnd_appendage_avenger_devilstrike(appendage)
{
	if(!appendage) return false;
	
	local T = appendage.getTimer().Get();
	
	return false;
}