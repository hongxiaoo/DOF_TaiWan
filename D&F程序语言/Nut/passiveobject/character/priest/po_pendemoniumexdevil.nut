PEND_EX_PO_IS_MOVING <- 0;
PEND_EX_PO_POS_X	 <- 1;
PEND_EX_PO_SPEED	 <- 2;
PEND_EX_MOVE_MAX	 <- 3;
         
function setCustomData_po_PandemoniumEx(obj,reciveData)
{		
	local scale		  = reciveData.readWord();
	local speed		  = reciveData.readWord();
	local maxTime     = reciveData.readWord();	
	local maxDistance = reciveData.readWord();	
	local dmg		  = reciveData.readDword();
	
	local posX = obj.getXPos();
	
	local pAttack = sq_GetCurrentAttackInfo(obj);
	sq_SetCurrentAttackBonusRate(pAttack, dmg);	
	
	//scale  의 범위는 0~4 0이면 작은 사이즈 그이외엔 큰사이즈	
	local ani = obj.getCurrentAnimation();
	local addAni = null;
	if(scale == 0) {
		obj.setCurrentAnimation(obj.getCustomAnimation(1));
		ani = obj.getCurrentAnimation();
		addAni = obj.getCustomAnimation(2);
	}
	else {				
		addAni = obj.getCustomAnimation(0);
	}	
	
	if(ani && addAni)
		ani.addLayerAnimation(2,addAni,false);
	
	if(ani)
		ani.setFrameDelay(4,maxTime,true);
	
	
	obj.sq_var.setBool(PEND_EX_PO_IS_MOVING,false);
	obj.sq_var.setInt(PEND_EX_PO_POS_X, posX);	
	obj.sq_var.setInt(PEND_EX_PO_SPEED, speed);	
	obj.sq_var.setInt(PEND_EX_MOVE_MAX, maxDistance);	
	
}

function procAppend_po_PandemoniumEx(obj)
{
	if(obj.sq_var.getBool(PEND_EX_PO_IS_MOVING))
	{
		local currentTime = obj.sq_var.get_ct_vector(0);
		local posX = obj.getXPos();
		local posY = obj.getYPos();
		local posZ = obj.getZPos();
		local speed = obj.sq_var.getInt(PEND_EX_PO_SPEED);
		local maxDistanceX = obj.sq_var.getInt(PEND_EX_MOVE_MAX);
		
		local startPosX = obj.sq_var.getInt(PEND_EX_PO_POS_X);
		local distanceX = sq_GetUniformVelocity(0, speed, currentTime.Get(), maxDistanceX);
		
		posX = sq_GetDistancePos(startPosX, obj.getDirection(), distanceX);			
		obj.setCurrentPos(posX, posY, posZ);
	}
}

function onKeyFrameFlag_po_PandemoniumEx(obj,flagIndex)
{	
	if(flagIndex == 0) {
		//if(obj.sq_isMyControlObject()) // 진동,번쩍 이펙트는 나에게만 보인다.
		//	obj.sq_setShake(obj,3,150);	
		obj.sq_var.push_ct_vector();
		local currentTime = obj.sq_var.get_ct_vector(0);
		
		currentTime.Start(9999999,0);
		
		obj.sq_var.setBool(PEND_EX_PO_IS_MOVING,true);
		
		
		//sq_SendDestroyPacketPassiveObject(obj);
		
	}
	return true;
}

function onEndCurrentAni_po_PandemoniumEx(obj)
{
	sq_SendDestroyPacketPassiveObject(obj);
}
