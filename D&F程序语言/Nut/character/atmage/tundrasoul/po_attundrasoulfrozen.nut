
function setCustomData_po_ATTundraSoulFrozen(obj, reciveData)
{
	if(!obj) return;	

	local id = reciveData.readDword();
	local frozenLevel = reciveData.readDword();	// 1.ºù°á·¹º§
	local frozenRate = reciveData.readDword();		// 2.ºù°áÈ®À²
	local frozenTime = reciveData.readDword();		// 3.ºù°á½Ã°£

	local pChr = obj.getTopCharacter();
	
	local object = sq_GetObjectByObjectId(obj, id);
	
	if(!pChr || !object)
	{
		sq_SendDestroyPacketPassiveObject(obj);
		return;
	}
	
	local atk = sq_GetCurrentAttackInfo(obj);
	sq_SetChangeStatusIntoAttackInfo(atk, 0, ACTIVESTATUS_FREEZE, frozenRate, frozenLevel, frozenTime);
	
	if(obj.isMyControlObject())
	{
		sq_SendHitObjectPacket(obj,object,0,0,(sq_GetObjectHeight(obj) / 2));
		
	}
}

function setState_po_ATTundraSoulFrozen(obj, state, datas)
{

	if(!obj) return;

}

function procAppend_po_ATTundraSoulFrozen(obj)
{

	if(!obj) return;
	
	sq_SendDestroyPacketPassiveObject(obj);
	

}

function onChangeSkillEffect_po_ATTundraSoulFrozen(obj, skillIndex, reciveData)
{

	if(!obj) return;

}

function onDestroyObject_po_ATTundraSoulFrozen(obj, object)
{

	if(!obj) return;

}

function onKeyFrameFlag_po_ATTundraSoulFrozen(obj, flagIndex)
{

}

function onEndCurrentAni_po_ATTundraSoulFrozen(obj)
{

	if(!obj) return;

}
