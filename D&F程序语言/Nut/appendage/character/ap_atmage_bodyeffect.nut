
APPENDAGE_INDEX_STATE <- 0
APPENDAGE_INDEX_ISEND <- 1

function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_atmage_bodyeffect")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_atmage_bodyeffect")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_atmage_bodyeffect")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_atmage_bodyeffect")
	appendage.sq_AddFunctionName("drawAppend", "drawAppend_appendage_atmage_bodyeffect")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_atmage_bodyeffect")
}


function sq_AddEffect(appendage)
{
}

function proc_appendage_atmage_bodyeffect(appendage)
{
	if(!appendage) {
		return;
	}
	
}


function onStart_appendage_atmage_bodyeffect(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
	
	appendage.getVar().clear_vector();
	appendage.getVar().push_vector(0);
	appendage.getVar().push_vector(0);
	
	
}


function prepareDraw_appendage_atmage_bodyeffect(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}




function onEnd_appendage_atmage_bodyeffect(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();
}

function drawAppend_appendage_atmage_bodyeffect(appendage, isOver, x, y, isFlip)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();
	
	if(!obj) {
		appendage.setValid(false);
		return;
	}
	
	local pAni = sq_GetCurrentAnimation(obj);
	
	if(!pAni) {
		appendage.setValid(false);
		return;
	}
	
	local state = appendage.getVar().get_vector(APPENDAGE_INDEX_STATE);
	
	local currentT = sq_GetCurrentTime(pAni);
	
	local startT = 150;
	local endT = 250;
	local effectT = 500;
	local effectType = GRAPHICEFFECT_DODGE;
	local rgb = sq_RGB(0, 90, 255);
	
	if(appendage.sq_GetSkillIndex() == SKILL_TELEPORT)
	{
		if(state == 0)
		{
			startT = 50;
			endT = 200;
			effectT = 240;
			effectType = GRAPHICEFFECT_LINEARDODGE;
			rgb = sq_RGB(255, 255, 255);
		}
		else if(state == 1)
		{
			print("state:" + state + " appendage.getTimer().Get():" + appendage.getTimer().Get());
			startT = 200;
			endT = 50;
			effectT = 200;
			effectType = GRAPHICEFFECT_LINEARDODGE;
			rgb = sq_RGB(255, 255, 255);
		}
	}
	else if(appendage.sq_GetSkillIndex() == SKILL_DIEHARD)
	{
		if(state == 0)
		{
			startT = 50;
			endT = 200;
			effectT = 700;
			effectType = GRAPHICEFFECT_LINEARDODGE;
			rgb = sq_RGB(255, 255, 255);
		}
		else if(state == 1)
		{
			startT = 200;
			endT = 50;
			effectT = 600;
			effectType = GRAPHICEFFECT_LINEARDODGE;
			rgb = sq_RGB(255, 255, 255);
		}
	}
	
	
	local targetV = endT;

	local al = sq_GetUniformVelocity(startT, targetV, appendage.getTimer().Get(), effectT);
	
	local alpha = sq_ALPHA(al);
	pAni.setEffectLayer(true, effectType, true, rgb, alpha, true, false);
	
	
	local size = sq_AniLayerListSize(pAni);
	
	if(size > 0) {
		for(local i=0;i<size;i+=1) {
			local aniL = sq_getAniLayerListObject(pAni, i);
			
			if(aniL) {
				local effect = aniL.GetCurrentFrame().GetGraphicEffect();
				
				if(effect != GRAPHICEFFECT_LINEARDODGE) {
					aniL.setEffectLayer(true, effectType, true, rgb, alpha, true, false);
				}
			}
		}
	}

	//if(al == targetV) {
	if(appendage.getVar().get_vector(APPENDAGE_INDEX_ISEND) == 1)
	{
		appendage.setValid(false);
	}
	else if(al == targetV)
	{
		if(appendage.sq_GetSkillIndex() == SKILL_TELEPORT || appendage.sq_GetSkillIndex() == SKILL_DIEHARD)
		{
			if(state == 0)
			{
				appendage.getTimer().Reset();
				appendage.getTimer().Start(0,0);
				appendage.getVar().set_vector(APPENDAGE_INDEX_STATE, 1);
			}
			else if(state == 1)
			{
				appendage.getVar().set_vector(APPENDAGE_INDEX_ISEND, 1);
			}
		}
	}	
	
}

// 어벤져 각성 변신의 끝부분
function isEnd_appendage_atmage_bodyeffect(appendage)
{
	if(!appendage) return false;
	
	local T = appendage.getTimer().Get();
	
	return false;
}