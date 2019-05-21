
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_atmage_iceroad_cs")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_atmage_iceroad_cs")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_atmage_iceroad_cs")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_atmage_iceroad_cs")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_atmage_iceroad_cs")
}


function sq_AddEffect(appendage)
{
}




function proc_appendage_atmage_iceroad_cs(appendage)
{
	if(!appendage)
	{
		return;
	}

	local obj = appendage.getParent();
	
	if(!obj)
	{
		appendage.setValid(false);
		return;
	}

	if(appendage.sq_var.size_vector() == 0)
	{
		appendage.setValid(false);
		return;
	}
	
	if(appendage.sq_var.get_vector(1) == 0)
	{
		local isActiveStatus = sq_IsValidActiveStatus(obj, ACTIVESTATUS_SLOW);
		
		//if(!isActiveStatus || obj.isDead())
		//{
			//appendage.sq_DeleteEffectFront();
			//appendage.sq_AddEffectFront("Character/Mage/Effect/Animation/ATIceRoad/end/00_icebottom_dodge.ani")
			//appendage.sq_var.set_vector(1, 1);
			//return;
		//}
	
		local T = appendage.getTimer().Get();	
		local maxT = appendage.sq_var.get_vector(0);
		
		if(T >= maxT)
		{ // 시간이 다 됐거나
			appendage.sq_DeleteEffectFront();
			appendage.sq_AddEffectFront("Character/Mage/Effect/Animation/ATIceRoad/end/00_icebottom_dodge.ani")
			appendage.sq_var.set_vector(1, 1);
			return;
		}
	}
	else
	{
		local ani = appendage.sq_GetFrontAnimation(0);
		
		if(ani)
		{
			local isEnd = sq_IsEnd(ani);
			
			if(isEnd)
			{
				appendage.setValid(false);
			}
		}
	}
	
}


function onStart_appendage_atmage_iceroad_cs(appendage)
{
	if(!appendage) {
		return;
	}
	
	appendage.sq_DeleteEffectFront();
	appendage.sq_AddEffectFront("Character/Mage/Effect/Animation/ATIceRoad/loop/01_iceup_dodge.ani")
	
	appendage.sq_var.clear_vector();		
	appendage.sq_var.push_vector(0); // 플래그
	appendage.sq_var.push_vector(0); // 플래그
}


function prepareDraw_appendage_atmage_iceroad_cs(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}




function onEnd_appendage_atmage_iceroad_cs(appendage)
{
	if(!appendage)
	{
		return;
	}
	appendage.sq_DeleteEffectFront();
}


// 어벤져 각성 변신의 끝부분
function isEnd_appendage_atmage_iceroad_cs(appendage)
{
	
	
	return false;
}