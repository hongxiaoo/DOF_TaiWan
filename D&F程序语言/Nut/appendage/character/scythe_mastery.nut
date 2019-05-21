
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_priest_scythe_mastery")
	appendage.sq_AddFunctionName("isDrawAppend", "isDrawAppend_appendage_priest_scythe_mastery")
}


function sq_AddEffect(appendage)
{
	appendage.sq_AddEffectFront("Character/Priest/Effect/Animation/ScytheMastery/1_aura_normal.ani")
}


function proc_appendage_priest_scythe_mastery(appendage)
{

}

function isDrawAppend_appendage_priest_scythe_mastery(appendage)
{
	if(!appendage) {
		return false;
	}
	
	local obj = appendage.getParent();	
	
	
	if(obj) {
	
		switch(obj.getState())
		{		
		case STATE_FASTMOVE :		// 고속이동일때엔 사이드마스터리를 그리지 않는다..
		case STATE_AVENGER_AWAKENING :
		case STATE_EXECUTION :
		case STATE_AWAKENING_TURN_OFF :
		case STATE_EX_DISASTER :
			return false;
		}
		
		if(isAvengerAwakenning(obj))
			return false;
			
		if(sq_GetGrowAvatarViewControl(obj))
			return false;
	}
	return true;
}