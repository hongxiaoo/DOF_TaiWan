POWER_OF_DARKNESS_CIRCLE_START <- 0;
POWER_OF_DARKNESS_CIRCLE_DESTROY <- 3;
POWER_OF_DARKNESS_BACK_SIDE <- 0;

function setCustomData_po_PowerOfDarknessCircle(obj,reciveData)
{		
	local backObj = sq_AddDrawOnlyAniFromParent(obj,"PassiveObject/Character/Priest/Animation/PowerOfDarkness/circle_back.ani",0,-2,0);
	obj.sq_var.setObject(POWER_OF_DARKNESS_BACK_SIDE ,backObj);
}

function onDestroyObject_po_PowerOfDarknessCircle(obj, destroyObj)
{
	if(isSameObject(obj,destroyObj))
	{
		local backObj = obj.sq_var.getObject(POWER_OF_DARKNESS_BACK_SIDE);		
		if(backObj)
			backObj.setValid(false);
	}
}

function procAppend_po_PowerOfDarknessCircle(obj)
{		
	local backObj = obj.sq_var.getObject(POWER_OF_DARKNESS_BACK_SIDE);
	
	if(backObj) {
		backObj.setCurrentPos(obj.getXPos(),obj.getYPos()-3,obj.getZPos());
		backObj.setCurrentDirection(obj.getDirection());
	}
}

function onKeyFrameFlag_po_PowerOfDarknessCircle(obj,flagIndex)
{	
	return true;
}

function onEndCurrentAni_po_PowerOfDarknessCircle(obj)
{
	local state = obj.getState();
	
	if(state == POWER_OF_DARKNESS_CIRCLE_DESTROY) {		
		local backObj = obj.sq_var.getObject(POWER_OF_DARKNESS_BACK_SIDE);
		if(backObj)
			backObj.setValid(false);
		obj.sq_var.setObject(POWER_OF_DARKNESS_BACK_SIDE,NULL);
			
		sq_SendDestroyPacketPassiveObject(obj);
	}
}

function setState_po_PowerOfDarknessCircle(obj, state, datas)
{	
	if(state == POWER_OF_DARKNESS_CIRCLE_DESTROY) {
		obj.setCurrentAnimation(obj.getCustomAnimation(0));		
		
		local backObj = obj.sq_var.getObject(POWER_OF_DARKNESS_BACK_SIDE);
		if(backObj)
			backObj.setValid(false);
		
		local newBackObj = sq_AddDrawOnlyAniFromParent(obj,"PassiveObject/Character/Priest/Animation/PowerOfDarkness/circle_back_last.ani",0,-2,0);
		obj.sq_var.setObject(POWER_OF_DARKNESS_BACK_SIDE ,newBackObj);
	}
}

function sendPowerOfDarknessCircleSubState(obj, state)
{
	obj.addSetStatePacket(state, sq_GetGlobalIntVector(),STATE_PRIORITY_AUTO,false,"");
	obj.flushSetStatePacket();
}
