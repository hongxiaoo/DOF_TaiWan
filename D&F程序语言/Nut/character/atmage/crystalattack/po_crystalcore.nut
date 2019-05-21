
function setCustomData_po_ATCrystalCore(obj,receiveData)
{		
	if(!obj)
		return;
	local dmg = receiveData.readDword();
	local angle = receiveData.readFloat();
	local attackSpeedRate = receiveData.readWord();
	local index = receiveData.readWord();
	
	if(index >= 3 && index <= 6)
		setCurrentAnimationFromCutomIndex(obj,0);
	else if(index > 6)
		setCurrentAnimationFromCutomIndex(obj,1);	
	
	
	angle = sq_ToRadian(angle);
	obj.sq_var.setInt(0,dmg);			
	sq_SetCustomRotate(obj,angle);
	
	if(attackSpeedRate != 100) {
		local ani = sq_GetCurrentAnimation(obj);
		if(ani) {
			ani.setSpeedRate(attackSpeedRate.tofloat());
		}
	}	
}


function onKeyFrameFlag_po_ATCrystalCore(obj,flagIndex)
{		
	if(!obj)
		return false;
		
	local parentObj = obj.getParent();
	
	if(parentObj) {
		sq_SetCurrentAttackInfo(obj,obj.getDefaultAttackInfo());
		
		local dmg = obj.sq_var.getInt(0);		
		local attackInfo = sq_GetCurrentAttackInfo(obj);	
		sq_SetCurrentAttackBonusRate(attackInfo, dmg);
		
		sq_SetMyShake(parentObj,3,120);
	}
	return true;
}

function onEndCurrentAni_po_ATCrystalCore(obj)
{
	if(!obj)
		return;
		
	if(obj.isMyControlObject())
	{
		sq_SendDestroyPacketPassiveObject(obj);
	}
}

