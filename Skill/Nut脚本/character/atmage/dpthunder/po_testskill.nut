
// setCustomData
function setCustomData_po_TestSkill(obj, receiveData)
{
	if(!obj)
		return;

	local attackBonusRate = receiveData.readDword();// ¢Xo¢XY¡PA(%)	
	local power = receiveData.readDword();		// ¢Xo¢XY¡PA+
	//local upForce = receiveData.readWord();		// ?c?i¡¦A Eu
	
	local attackInfo = sq_GetCurrentAttackInfo(obj);
	sq_SetCurrentAttackBonusRate(attackInfo, attackBonusRate);
	sq_SetCurrentAttackPower(attackInfo, power);
	//sq_SetCurrentAttacknUpForce(attackInfo, upForce);
}



function onEndCurrentAni_po_TestSkill(obj)
{
	if(!obj)
		return;
		
	if(obj.isMyControlObject())
	{
		sq_SendDestroyPacketPassiveObject(obj);
	}
}
