
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_atmage_darknessmantle_effect")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_atmage_darknessmantle_effect")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_atmage_darknessmantle_effect")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_atmage_darknessmantle_effect")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_atmage_darknessmantle_effect")
}


function sq_AddEffect(appendage)
{
}




function proc_appendage_atmage_darknessmantle_effect(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();
	
	if(!obj)
	{
		appendage.setValid(false);
		return;
	}	
	
	local time = appendage.getTimer().Get();
	
	local x = obj.getXPos();
	local y = obj.getYPos();
	local z = obj.getZPos();
	
	//procParticleCreaterMap(appendage, obj, time, "PassiveObject/Character/Mage/Particle/mm_darkaura.ptl", x, y, z);
	local t = appendage.getVar().get_timer_vector(0);
	
	if(!t)
		return;
	
	if(t.isOnEvent(time) == true)
	{
		local particleCreater = appendage.getVar().GetparticleCreaterMap("mm_darkaura", "PassiveObject/Character/Mage/Particle/mm_darkaura.ptl", obj);
			
		particleCreater.Restart(0);
		particleCreater.SetPos(x, y, z);
		
		sq_AddParticleObject(obj, particleCreater);
	}
	
	if(t.isEnd() == true)
	{
		appendage.setValid(false);
	}
}


function onStart_appendage_atmage_darknessmantle_effect(appendage)
{
	if(!appendage) {
		return;
	}	
	
	local obj = appendage.getParent();
	
	if(!obj)
	{
		appendage.setValid(false);
		return;
	}	
	
	initGetVarTimer(appendage, 1, 60, 100);
	
	
}


function prepareDraw_appendage_atmage_darknessmantle_effect(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}




function onEnd_appendage_atmage_darknessmantle_effect(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
	
}


// 어벤져 각성 변신의 끝부분
function isEnd_appendage_atmage_darknessmantle_effect(appendage)
{
	
	
	return false;
}