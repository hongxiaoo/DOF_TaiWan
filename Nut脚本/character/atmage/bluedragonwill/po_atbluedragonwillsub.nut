
function setCustomData_po_ATBlueDragonWillSub(obj, reciveData)
{
	if(!obj) return;
	
	local radius = reciveData.readFloat();
	local attack = reciveData.readDword();
	
	print("setCustomData_po_ATBlueDragonWillSub:" + attack);
	
	local pAni = obj.getCurrentAnimation();
	
	if(pAni) {
		pAni.setImageRate(radius, radius);
		sq_SetAttackBoundingBoxSizeRate(pAni, radius, radius, 1.0);
	}
	
	local atk = sq_GetCurrentAttackInfo(obj);
	
	if(atk) {
		sq_SetCurrentAttackPower(atk, attack);
	}
}

function setState_po_ATBlueDragonWillSub(obj, state, datas)
{

	if(!obj) return;

}

function procAppend_po_ATBlueDragonWillSub(obj)
{

	if(!obj) return;

}

function onChangeSkillEffect_po_ATBlueDragonWillSub(obj, skillIndex, reciveData)
{

	if(!obj) return;

}

function onDestroyObject_po_ATBlueDragonWillSub(obj, object)
{

	if(!obj) return;

}

function onKeyFrameFlag_po_ATBlueDragonWillSub(obj, flagIndex)
{

}

function getHitDirection_po_ATBlueDragonWillSub(obj, damager)
{
	if(!obj) return 0;
	
	local pChr = obj.getTopCharacter();
	
	if(pChr) {	
		return sq_GetOppositeDirection(pChr.getDirection());
	}
	
	return 0;
}

function onEndCurrentAni_po_ATBlueDragonWillSub(obj)
{

	if(!obj) return;

	if(obj.isMyControlObject()) {
		sq_SendDestroyPacketPassiveObject(obj);
	}

}
