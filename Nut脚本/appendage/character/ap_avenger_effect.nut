
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_avenger_effect")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_avenger_effect")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_avenger_effect")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_avenger_effect")
	appendage.sq_AddFunctionName("drawAppend", "drawAppend_appendage_avenger_effect")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_avenger_effect")
}


function sq_AddEffect(appendage)
{
	//appendage.sq_AddEffectFront("Character/Priest/Effect/Animation/ScytheMastery/1_aura_normal.ani")
}

function proc_appendage_avenger_effect(appendage)
{
	if(!appendage) {
		return;
	}
	
}


function onStart_appendage_avenger_effect(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
	
	
}


function prepareDraw_appendage_avenger_effect(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}




function onEnd_appendage_avenger_effect(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();
}

function drawAppend_appendage_avenger_effect(appendage, isOver, x, y, isFlip)
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
	
	local targetV = 50;

	local al = sq_GetUniformVelocity(200, targetV, appendage.getTimer().Get(), 500);
	
	local rgb = sq_RGB(0, 0, 0);
	local alpha = sq_ALPHA(al);
	pAni.setEffectLayer(true, GRAPHICEFFECT_NONE, true, rgb, alpha, true, false);
	
	
	local size = sq_AniLayerListSize(pAni);
	
	if(size > 0) {
		//local aniList =[];
		//aniList.resize(size);		
		for(local i=0;i<size;i+=1) {
			local aniL = sq_getAniLayerListObject(pAni, i);
			
			if(aniL) {
				local effect = aniL.GetCurrentFrame().GetGraphicEffect();
				
				if(effect != GRAPHICEFFECT_LINEARDODGE) {
					aniL.setEffectLayer(true, GRAPHICEFFECT_NONE, true, rgb, alpha, true, false);
				}
			}
		}
	}
	
	//CNRDAnimation::AniLayerList *layerList = animation->getAnimationLayers();
	//for (CNRDAnimation::AniLayerList::iterator it = layerList->begin(); it != layerList->end(); it++)
	//{
		//if ((*it).second->GetFrameNumber() != 0 && (*it).second->GetCurrentFrame() && (*it).second->GetCurrentFrame()->GetGraphicEffect() != GRAPHICEFFECT_LINEARDODGE)
			//(*it).second->setEffectLayer(true, GRAPHICEFFECT_NONE, true, RGB(255, 0, 0), ALPHA(alpha), true);
	//}
	
	
	if(al == targetV) {
		appendage.setValid(false);
	}
}

// 어벤져 각성 변신의 끝부분
function isEnd_appendage_avenger_effect(appendage)
{
	if(!appendage) return false;
	
	local T = appendage.getTimer().Get();
	
	return false;
}