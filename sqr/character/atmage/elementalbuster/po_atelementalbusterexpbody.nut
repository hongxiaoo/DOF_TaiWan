

/************************************************
************************************************
// 캐릭터 위치에서 생성되는 큰 폭발 오브젝트
************************************************
************************************************/
function setPower_po_ATElementalBuster(obj, power)
{
	local attackInfo = sq_GetCurrentAttackInfo(obj);
	if (attackInfo)
		sq_SetCurrentAttackBonusRate(attackInfo, power);
		
	//printc("power : " + power);
}

function setSizeRate_po_ATElementalBuster(obj, sizeRate)
{
	local animation = sq_GetCurrentAnimation(obj);
	if (!animation) return;
	
	local sizeRate = sizeRate.tofloat() / 100.0;
	animation.setImageRateFromOriginal(sizeRate, sizeRate);
	animation.setAutoLayerWorkAnimationAddSizeRate(sizeRate);
	sq_SetAttackBoundingBoxSizeRate(animation, sizeRate, sizeRate, sizeRate);
}

function setCustomData_po_ATElementalBusterExpBodyFire(obj, receiveData)
{	// FIRE
	if (!obj) return;
	local power = receiveData.readDword();
	setPower_po_ATElementalBuster(obj, power);
	
	local sizeRate = receiveData.readWord();
	setSizeRate_po_ATElementalBuster(obj, sizeRate);
}

function setCustomData_po_ATElementalBusterExpBodyWater(obj, receiveData)
{	// WATER
	if (!obj) return;
	local power = receiveData.readDword();
	setPower_po_ATElementalBuster(obj, power);
	
	local sizeRate = receiveData.readWord();
	setSizeRate_po_ATElementalBuster(obj, sizeRate);
}

function setCustomData_po_ATElementalBusterExpBodyLight(obj, receiveData)
{	// LIGHT
	if (!obj) return;
	local power = receiveData.readDword();
	setPower_po_ATElementalBuster(obj, power);
	
	local sizeRate = receiveData.readWord();
	setSizeRate_po_ATElementalBuster(obj, sizeRate);
}

function setCustomData_po_ATElementalBusterExpBodyDark(obj, receiveData)
{	// DARK
	if (!obj) return;
	local power = receiveData.readDword();
	setPower_po_ATElementalBuster(obj, power);
	
	local sizeRate = receiveData.readWord();
	setSizeRate_po_ATElementalBuster(obj, sizeRate);
}

function onEndCurrentAni_po_ATElementalBuster(obj)
{
	if (!obj) return;	
	if (obj.isMyControlObject()) {
		sq_SendDestroyPacketPassiveObject(obj);
	}
}

function onEndCurrentAni_po_ATElementalBusterExpBodyFire(obj)
{	// FIRE
	onEndCurrentAni_po_ATElementalBuster(obj);
}
function onEndCurrentAni_po_ATElementalBusterExpBodyWater(obj)
{	// WATER
	onEndCurrentAni_po_ATElementalBuster(obj);
}
function onEndCurrentAni_po_ATElementalBusterExpBodyLight(obj)
{	// LIGHT
	onEndCurrentAni_po_ATElementalBuster(obj);
}
function onEndCurrentAni_po_ATElementalBusterExpBodyDark(obj)
{	// DARK
	onEndCurrentAni_po_ATElementalBuster(obj);
}



/************************************************
************************************************
// 캐릭터 위치에서 생성되는 중간크기 폭발 오브젝트
************************************************
************************************************/
function setCustomData_po_ATElementalBusterExpBigFire(obj, receiveData)
{	// FIRE
	if (!obj) return;
	local power = receiveData.readDword();
	setPower_po_ATElementalBuster(obj, power);
	
	local sizeRate = receiveData.readWord();
	setSizeRate_po_ATElementalBuster(obj, sizeRate);
}

function setCustomData_po_ATElementalBusterExpBigWater(obj, receiveData)
{	// WATER
	if (!obj) return;
	local power = receiveData.readDword();
	setPower_po_ATElementalBuster(obj, power);
	
	local sizeRate = receiveData.readWord();
	setSizeRate_po_ATElementalBuster(obj, sizeRate);
}

function setCustomData_po_ATElementalBusterExpBigLight(obj, receiveData)
{	// LIGHT
	if (!obj) return;
	local power = receiveData.readDword();
	setPower_po_ATElementalBuster(obj, power);
	
	local sizeRate = receiveData.readWord();
	setSizeRate_po_ATElementalBuster(obj, sizeRate);
}

function setCustomData_po_ATElementalBusterExpBigDark(obj, receiveData)
{	// DARK
	if (!obj) return;
	local power = receiveData.readDword();
	setPower_po_ATElementalBuster(obj, power);
	
	local sizeRate = receiveData.readWord();
	setSizeRate_po_ATElementalBuster(obj, sizeRate);
}

function onEndCurrentAni_po_ATElementalBusterExpBigFire(obj)
{	// FIRE
	onEndCurrentAni_po_ATElementalBuster(obj);
}

function onEndCurrentAni_po_ATElementalBusterExpBigWater(obj)
{	// WATER
	onEndCurrentAni_po_ATElementalBuster(obj);
}

function onEndCurrentAni_po_ATElementalBusterExpBigLight(obj)
{	// LIGHT
	onEndCurrentAni_po_ATElementalBuster(obj);
}

function onEndCurrentAni_po_ATElementalBusterExpBigDark(obj)
{	// DARK
	onEndCurrentAni_po_ATElementalBuster(obj);
}






/************************************************
************************************************
// 캐릭터 위치에서 생성되는 작은크기 폭발 오브젝트
************************************************
************************************************/
function setCustomData_po_ATElementalBusterExpSmallFire(obj, receiveData)
{	// FIRE
	if (!obj) return;
	local power = receiveData.readDword();
	setPower_po_ATElementalBuster(obj, power);
	
	local sizeRate = receiveData.readWord();
	setSizeRate_po_ATElementalBuster(obj, sizeRate);
}

function setCustomData_po_ATElementalBusterExpSmallWater(obj, receiveData)
{	// WATER
	if (!obj) return;
	local power = receiveData.readDword();
	setPower_po_ATElementalBuster(obj, power);
	
	local sizeRate = receiveData.readWord();
	setSizeRate_po_ATElementalBuster(obj, sizeRate);
}

function setCustomData_po_ATElementalBusterExpSmallLight(obj, receiveData)
{	// LIGHT
	if (!obj) return;
	local power = receiveData.readDword();
	setPower_po_ATElementalBuster(obj, power);
	
	local sizeRate = receiveData.readWord();
	setSizeRate_po_ATElementalBuster(obj, sizeRate);
}

function setCustomData_po_ATElementalBusterExpSmallDark(obj, receiveData)
{	// DARK
	if (!obj) return;
	local power = receiveData.readDword();
	setPower_po_ATElementalBuster(obj, power);
	
	local sizeRate = receiveData.readWord();
	setSizeRate_po_ATElementalBuster(obj, sizeRate);
}

function onEndCurrentAni_po_ATElementalBusterExpSmallFire(obj)
{	// FIRE
	onEndCurrentAni_po_ATElementalBuster(obj);
}

function onEndCurrentAni_po_ATElementalBusterExpSmallWater(obj)
{	// WATER
	onEndCurrentAni_po_ATElementalBuster(obj);
}

function onEndCurrentAni_po_ATElementalBusterExpSmallLight(obj)
{	// LIGHT
	onEndCurrentAni_po_ATElementalBuster(obj);
}

function onEndCurrentAni_po_ATElementalBusterExpSmallDark(obj)
{	// DARK
	onEndCurrentAni_po_ATElementalBuster(obj);
}

