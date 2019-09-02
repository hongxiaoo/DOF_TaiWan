PIECE_OF_ICE_CORE_STATE_STAY   <- 2;
PIECE_OF_ICE_CORE_STATE_DAMAGE <- 3;
PIECE_OF_ICE_CORE_STATE_END	   <- 4;

PIECE_OF_ICE_CORE_VAR_START_X <- 0;
PIECE_OF_ICE_CORE_VAR_SHAKE_END_TIME <- 1;

function setCustomData_po_ATPieceOfIceCore(obj, reciveData)
{
	if(!obj) return;	
	
	local var = obj.getVar();		
	local x = obj.getXPos();
	var.setInt(PIECE_OF_ICE_CORE_VAR_START_X, x);
	var.push_ct_vector();
	local timer = var.get_ct_vector(0);
	obj.sendStateOnlyPacket(PIECE_OF_ICE_CORE_STATE_STAY);
	
	var.setInt(PIECE_OF_ICE_CORE_VAR_SHAKE_END_TIME, 0); 		
}

function setState_po_ATPieceOfIceCore(obj, state, datas)
{
	if(!obj) return;
		
	if(state == PIECE_OF_ICE_CORE_STATE_DAMAGE)
	{
		local ani = obj.getCurrentAnimation();
				
		local var = obj.getVar();		
		if(ani) {			
			local currentIndex = sq_GetVectorData(datas, 0) + 3;
			ani.setCurrentFrameWithChildLayer(currentIndex);
		}		
		local timer = var.get_ct_vector(0);
		var.setInt(PIECE_OF_ICE_CORE_VAR_SHAKE_END_TIME, timer.Get() + 50); 
		sq_SetMyShake(obj,2,80);
	}	
	else if(state == PIECE_OF_ICE_CORE_STATE_END)
	{			
		local ani = obj.getCurrentAnimation();			
	
		if(ani)	
			ani.setCurrentFrameWithChildLayer(10); // 마지막 프레임
	}
}

function procAppend_po_ATPieceOfIceCore(obj)
{
	if(!obj) return;
	
	local var = obj.getVar();	
	local timer = var.get_ct_vector(0);			
	
	local shakeEndTime = var.getInt(PIECE_OF_ICE_CORE_VAR_SHAKE_END_TIME);
	local shakeValue = 0;
	if(timer.Get() < shakeEndTime && obj.getState() != PIECE_OF_ICE_CORE_STATE_END)
		shakeValue = (sq_GetShuttleValue(0, 6,sq_GetObjectTime(obj),100)-3);
		
	local x = var.getInt(PIECE_OF_ICE_CORE_VAR_START_X) + shakeValue;
	local y = obj.getYPos();
	local z = sq_GetShuttleValue(55, 65,sq_GetObjectTime(obj),1200);

	sq_SetCurrentPos(obj, x, y, z);
}

function onKeyFrameFlag_po_ATPieceOfIceCore(obj, flagIndex)
{
	if(!obj)
		return false;

	if(flagIndex == 1)
	{
		sq_SetMyShake(obj,3,100);
	}
	if(flagIndex == 2)
	{
		obj.sendStateOnlyPacket(PIECE_OF_ICE_CORE_STATE_END);		
	}
	return true;	
}

function onEndCurrentAni_po_ATPieceOfIceCore(obj)
{
	if(!obj) return;
	
	if(obj.isMyControlObject()) {
		sq_SendDestroyPacketPassiveObject(obj);
	}
}
