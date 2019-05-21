
function setCustomData_po_CreatorMicroAttack(obj,recive)
{
	print(" setcustom data");

	if(!obj) return;		
	
	local mage = obj.getTopCharacter();
	if (!mage)
		return;
	
	// 기본기 숙련 적용
	mage.applyBasicAttackUp(sq_GetCurrentAttackInfo(obj),STATE_ATTACK);	
	sq_SetCurrentAttackInfo(obj,sq_GetCurrentAttackInfo(obj));
	
}

function setState_po_CreatorMicroAttack(obj,state,datas)
{

	if(!obj) return;

}

function procAppend_po_CreatorMicroAttack(obj)
{
	if(!obj) return;	
}

function onChangeSkillEffect_po_CreatorMicroAttack(obj,skillIndex,reciveData)
{

	if(!obj) return;

}

function onDestroyObject_po_CreatorMicroAttack(obj,object)
{

	if(!obj) return;

}

function onKeyFrameFlag_po_CreatorMicroAttack(obj,flagIndex)
{

	if(!obj) return;

}

function onEndCurrentAni_po_CreatorMicroAttack(obj)
{
	if(!obj) return;
	
	
	if(obj.isMyControlObject()) {
		sq_SendDestroyPacketPassiveObject(obj);
	}

}
