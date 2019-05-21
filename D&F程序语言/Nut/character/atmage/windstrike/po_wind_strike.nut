
// setCustomData
function setCustomData_po_ATWindStrike(obj, receiveData)
{
	if(!obj)
		return;

	local attackBonusRate = receiveData.readDword();// °ø°Ý·Â(%)	
	local power = receiveData.readDword();		// °ø°Ý·Â+
	local upForce = receiveData.readWord();		// ¶ç¿ì´Â Èû
	
	local attackInfo = sq_GetCurrentAttackInfo(obj);
	sq_SetCurrentAttackBonusRate(attackInfo, attackBonusRate);
	sq_SetCurrentAttackPower(attackInfo, power);
	sq_SetCurrentAttacknUpForce(attackInfo, upForce);
}



function onEndCurrentAni_po_ATWindStrike(obj)
{
	if(!obj)
		return;
		
	if(obj.isMyControlObject())
	{
		sq_SendDestroyPacketPassiveObject(obj);
	}
}
