POI_CUSTOM_ANI_SMALL_ICE	<- 0;
POI_CUSTOM_ANI_SMOKE		<- 1;
POI_CUSTOM_ANI_DODGE		<- 2;
POI_CUSTOM_ANI_SMALL_DODGE	<- 3;

PIECE_OF_ICE_EXPLOSION <- 2;

function setCustomData_po_ATPieceOfIce(obj, reciveData)
{
	if(!obj) return;

	local isSmall = reciveData.readWord() < 2;
	local horizonAngle = reciveData.readFloat(); //좌우 범위
	local verticalAngle = reciveData.readFloat(); //상하 범위
	local lifeTime = reciveData.readWord();
	local attackPower = 0;
	
	local mage = obj.getTopCharacter();
	mage = sq_ObjectToSQRCharacter(mage);	
	if (mage) {
		attackPower = mage.sq_GetBonusRateWithPassive(SKILL_PIECE_OF_ICE , STATE_PIECE_OF_ICE, 0, 1.0);
	}
		
	obj.sq_SetMoveParticle("Particle/ATPieceOfice.ptl", horizonAngle.tofloat(), verticalAngle.tofloat());
	
	local iceAni;
	if(isSmall)	
	{
		obj.setCurrentAnimation(obj.getCustomAnimation(POI_CUSTOM_ANI_SMALL_ICE));
		iceAni = obj.getCurrentAnimation();		
				
		local dodge = sq_CreateAnimation("PassiveObject/Character/Mage/Animation/ATPieceOfIce/","06_piece_dodge_1.ani");
		iceAni.addLayerAnimation(1,dodge,true);// 닷지		
	}
	else
	{		
		iceAni = obj.getCurrentAnimation();			
		
		local dodge = sq_CreateAnimation("PassiveObject/Character/Mage/Animation/ATPieceOfIce/","06_piece_dodge.ani");
		iceAni.addLayerAnimation(1,dodge,true);// 닷지	
	}	
	
	sq_SetCustomRotate(obj,sq_ToRadian(-horizonAngle.tofloat()/3.0));	
	obj.setTimeEvent(0,lifeTime,1,false);
	
	sq_SetCurrentAttackBonusRate(sq_GetCurrentAttackInfo(obj), attackPower);
	
}



function setState_po_ATPieceOfIce(obj, state, datas)
{
	if(!obj) return;
	
	if(state == PIECE_OF_ICE_EXPLOSION) {
		obj.sq_RemoveMoveParticle();
		local explosionAni = obj.getCustomAnimation(POI_CUSTOM_ANI_SMOKE);		
		obj.setCurrentAnimation(explosionAni);		
	}	
}



function procAppend_po_ATPieceOfIce(obj)
{
	if(!obj) return;
	
	if(obj.isMyControlObject())
	{	
		local mage = obj.getTopCharacter();
		mage = sq_ObjectToSQRCharacter(mage);	
		if (mage) {
			if(!mage.isMovablePos(obj.getXPos(), obj.getYPos()))
				obj.sendStateOnlyPacket(PIECE_OF_ICE_EXPLOSION);
		}
	}
}		



function onTimeEvent_po_ATPieceOfIce(obj, timeEventIndex, timeEventCount)
{		
	if(!obj)
		return false;

	if(timeEventIndex == 0)
	{
		obj.sendStateOnlyPacket(PIECE_OF_ICE_EXPLOSION);
	
		return true; // true면 콜백 중단
	}	
	return false;	
} 


function onEndCurrentAni_po_ATPieceOfIce(obj)
{
	if(!obj) return;
	
	if(obj.isMyControlObject())
	{
		sq_SendDestroyPacketPassiveObject(obj); // 내부에서 ismycontrol 체크
	}
}
