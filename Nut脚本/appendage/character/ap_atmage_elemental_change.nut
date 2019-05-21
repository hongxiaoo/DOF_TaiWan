
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_atmage_elemental_change")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_atmage_elemental_change")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_atmage_elemental_change")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_atmage_elemental_change")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_atmage_elemental_change")
}


function sq_AddEffect(appendage)
{
	//appendage.sq_AddEffectFront("Character/Priest/Effect/Animation/ScytheMastery/1_aura_normal.ani")
}

function proc_appendage_atmage_elemental_change(appendage)
{
	if (!appendage)
		return;	
}


function onStart_appendage_atmage_elemental_change(appendage)
{
	if (!appendage)
		return;
	
	// 속성 선택 메뉴가 나타남
	// 속성 선택을하면 appendage가 append된다.
	// 



	local obj = appendage.getParent();	
}


function prepareDraw_appendage_atmage_elemental_change(appendage)
{
	if (!appendage)
		return;
	
	local obj = appendage.getParent();	
}




function onEnd_appendage_atmage_elemental_change(appendage)
{
	if (!appendage)
		return;
	
	local obj = appendage.getParent();
}

function isEnd_appendage_atmage_elemental_change(appendage)
{
	if (!appendage)
		return false;
	
	local time = appendage.getTimer().Get();
	
	return false;
}