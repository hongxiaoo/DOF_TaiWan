
function setCustomData_po_ATBlueDragonWillExp(obj, reciveData)
{

	if(!obj) return;

	local attack_rate = reciveData.readDword();
	
	local atk = sq_GetCurrentAttackInfo(obj);
	
	if(atk) {
		sq_SetCurrentAttackBonusRate(atk, attack_rate);
	}
}

function setState_po_ATBlueDragonWillExp(obj, state, datas)
{

	if(!obj) return;

}

function procAppend_po_ATBlueDragonWillExp(obj)
{

	if(!obj) return;

}

function getHitDirection_po_ATBlueDragonWillExp(obj, damager)
{
	if(!obj) return 0;
	
	local pChr = obj.getTopCharacter();
	
	if(pChr) {	
		return sq_GetOppositeDirection(pChr.getDirection());
	}
	
	return 0;
}


function onChangeSkillEffect_po_ATBlueDragonWillExp(obj, skillIndex, reciveData)
{

	if(!obj) return;

}

function onDestroyObject_po_ATBlueDragonWillExp(obj, object)
{

	if(!obj) return;

}

function onKeyFrameFlag_po_ATBlueDragonWillExp(obj, flagIndex)
{

}

function onEndCurrentAni_po_ATBlueDragonWillExp(obj)
{

	if(!obj) return;

	if(obj.isMyControlObject()) {
		sq_SendDestroyPacketPassiveObject(obj);
	}

}
