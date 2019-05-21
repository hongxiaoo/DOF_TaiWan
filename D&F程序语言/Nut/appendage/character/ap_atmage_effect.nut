
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_atmage_effect")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_atmage_effect")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_atmage_effect")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_atmage_effect")
	appendage.sq_AddFunctionName("drawAppend", "drawAppend_appendage_atmage_effect")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_atmage_effect")
}


function sq_AddEffect(appendage)
{
	//appendage.sq_AddEffectFront("Character/Priest/Effect/Animation/ScytheMastery/1_aura_normal.ani")
}

function proc_appendage_atmage_effect(appendage)
{
	if(!appendage) {
		return;
	}
	
}


function onStart_appendage_atmage_effect(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
	
	
}


function prepareDraw_appendage_atmage_effect(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}




function onEnd_appendage_atmage_effect(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();
}

function drawAppend_appendage_atmage_effect(appendage, isOver, x, y, isFlip)
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
	
	local currentT = sq_GetCurrentTime(pAni);
	
	local startT = 150;
	local endT = 250;
	local effectT = 500;
	local effectType = GRAPHICEFFECT_DODGE;
	local rgb = sq_RGB(0, 90, 255);
	
	if(appendage.sq_GetSkillIndex() == SKILL_FLAMECIRCLE) {
		startT = 50;
		endT = 250;
		effectT = 500;
		effectType = GRAPHICEFFECT_DODGE;
		rgb = sq_RGB(0, 0, 0);
	}
	else if(appendage.sq_GetSkillIndex() == SKILL_BROKENARROW)
	{
		startT = 100;
		endT = 200;
		effectT = 100;
		effectType = GRAPHICEFFECT_LINEARDODGE;
		rgb = sq_RGB(0, 75, 255);
	}
	
	
	local targetV = endT;

	local al = sq_GetUniformVelocity(startT, targetV, appendage.getTimer().Get(), effectT);
	
	local alpha = sq_ALPHA(al);
	pAni.setEffectLayer(true, effectType, true, rgb, alpha, true, false);
	
	
	local size = sq_AniLayerListSize(pAni);
	
	if(appendage.sq_GetSkillIndex() != SKILL_FLAMECIRCLE) {	
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
	}
	
	if(al == targetV) {
		appendage.setValid(false);
	}
}

// 어벤져 각성 변신의 끝부분
function isEnd_appendage_atmage_effect(appendage)
{
	if(!appendage) return false;
	
	local T = appendage.getTimer().Get();
	
	return false;
}