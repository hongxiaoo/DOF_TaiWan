
function setCustomData_po_ATWaterCannonExp(obj, receiveData)
{
	if(!obj) return;
	
	local attackBonusRate = receiveData.readDword();
	local group = receiveData.readDword();
	local id = receiveData.readDword();
	local sizeRate = receiveData.readDword();
	
	
	print( " attackrate:" + attackBonusRate + " sizeRate:" + sizeRate + " id:" + id);
	// 패킷으로 받은 공격력 셋팅	
	
	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);
	
	print( " x:" + x + " y:" + y + " z:" + z);
	
	
	local attackInfo = sq_GetCurrentAttackInfo(obj);
	if (attackInfo)
		sq_SetCurrentAttackBonusRate(attackInfo, attackBonusRate);

	// 물대포의 크기를 조절함.
	local currentAni = sq_GetCurrentAnimation(obj);
	
	print(" currentAni:" + currentAni);
	
	sizeRate = sizeRate.tofloat() / 100.0;
	currentAni.Proc();
	currentAni.setImageRateFromOriginal(sizeRate, sizeRate);
	
	sq_SetAttackBoundingBoxSizeRate(currentAni, sizeRate, sizeRate, sizeRate);
	
	local parentObj = obj.getParent();
		
	if(parentObj)
	{	
		local damager = sq_GetObject(parentObj, group, id);
		local colObj = sq_GetCNRDObjectToCollisionObject(damager);
		if(colObj && parentObj) 
			sq_AddHitObject(obj, colObj);
	}
}

function setState_po_ATWaterCannonExp(obj, state, datas)
{

	if(!obj) return;

}

function procAppend_po_ATWaterCannonExp(obj)
{

	if(!obj) return;
	

}

function onChangeSkillEffect_po_ATWaterCannonExp(obj, skillIndex, reciveData)
{

	if(!obj) return;

}

function onDestroyObject_po_ATWaterCannonExp(obj, object)
{

	if(!obj) return;

}

function onKeyFrameFlag_po_ATWaterCannonExp(obj, flagIndex)
{

}

function onEndCurrentAni_po_ATWaterCannonExp(obj)
{
	if(!obj) return;

	if(obj.isMyControlObject())
	{
		sq_SendDestroyPacketPassiveObject(obj);
	}
	

}
