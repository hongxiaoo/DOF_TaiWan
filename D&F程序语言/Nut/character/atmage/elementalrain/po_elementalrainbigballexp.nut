
function setCustomData_po_ATElementalRainBigBallExp(obj, receiveData)
{
	if(!obj)
		return;
	// 마지막 폭발의 공격력 셋팅
	local attackBonusRate = receiveData.readDword();
	local sizeRate = receiveData.readWord();
	
	local attackInfo = sq_GetCurrentAttackInfo(obj);
	sq_SetCurrentAttackBonusRate(attackInfo, attackBonusRate);	
	local mage = obj.getTopCharacter();
	if (mage)
		attackInfo.setElement(mage.getThrowElement());
		
	// 화면진동
	if (obj.isMyControlObject())
	{
		sq_SetMyShake(obj, 6, 800);
		local flashScreen = sq_flashScreen(obj, 80, 80, 80, 120, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
		sq_addFlashScreen(flashScreen, 0, 80, 0, 120, sq_RGB(255,255,255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
		sq_addFlashScreen(flashScreen, 0, 80, 120, 200, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
	}
	
	
	// 아이템과 연동되는 기능
	// 마지막 폭발의 사이즈를 변경할 수 있는 기능임
	local animation = sq_GetCurrentAnimation(obj);
	if (!animation) return;
	local size = sizeRate.tofloat() / 100.0;
	animation.setImageRateFromOriginal(size, size);
	animation.setAutoLayerWorkAnimationAddSizeRate(size);
	sq_SetAttackBoundingBoxSizeRate(animation, size, size, size);
}

function onAttack_po_ATElementalRainBigBallExp(obj, damager, boundingBox, isStuck)
{
	if (!obj)
		return 0;
	return 0;
}


function procAppend_po_ATElementalRainBigBallExp(obj)
{

}
