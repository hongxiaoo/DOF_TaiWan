PO_ICE_FIELD_SUB_STATE_MAKE_FOG <- 2;
PO_ICE_FIELD_SUB_STATE_MAKE_PRICKLE <- 3;

PO_ICE_FIELD_VAR_POWER	 <- 2;
PO_ICE_FIELD_VAR_ICE_LEVEL <- 3;
PO_ICE_FIELD_VAR_ICE_PROB	 <- 4;
PO_ICE_FIELD_VAR_ICE_TIME  <- 5;

function setCustomData_po_ATIceFieldEx(obj, reciveData)
{
	if(!obj) return;	
	
	local power		= reciveData.readFloat();
	local iceLevel	= reciveData.readDword();	
	local iceProb	= reciveData.readDword();	
	local iceTime	= reciveData.readDword();	
			
	local attackInfo = sq_GetCurrentAttackInfo(obj);
	if(attackInfo)
	{
		sq_SetCurrentAttackBonusRate(attackInfo, power.tointeger());
		sq_SetAttackInfoForceHitStunTime(attackInfo, 0);
		sq_SetChangeStatusIntoAttackInfo(attackInfo, 0, ACTIVESTATUS_FREEZE, iceProb, iceLevel, iceTime);
	}
	
	if(obj.isMyControlObject()) 
	{
		local ani = sq_GetCurrentAnimation(obj);
		local inTime = ani.getDelaySum(0,9);
		local stayTime = ani.getDelaySum(10,27);
		local endTime = ani.getDelaySum(28,36);
		
		sq_flashScreen(obj, inTime, stayTime, endTime, 200, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_NORMAL);
	}
}



function onKeyFrameFlag_po_ATIceFieldEx(obj, flagIndex)
{
	if(!obj)
		return false;
		
		printc("flagIndex " + flagIndex);
	if(flagIndex < 4) {
		sq_SetMyShake(obj,4,60);
	}
	else {
		sq_SetMyShake(obj,4,200);
	}
	
	return true;
}