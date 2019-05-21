

function setCustomData_po_ATDarknessMantleExp(obj, reciveData)
{
	if(!obj) return;
	
	local expAttackRate = reciveData.readDword(); // 어둠서클 퍼댑
	local sizeRate = reciveData.readDword(); // 크로니클아이템 추가 기능 어둠서클 확대율 (100%)
	
	
	obj.getVar("flag").clear_vector();
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);	
	
	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);
	
	local pAttack = sq_GetCurrentAttackInfo(obj);
	sq_SetCurrentAttackBonusRate(pAttack, expAttackRate);
	
	local pooledObj = null;
	
	pooledObj = sq_CreateDrawOnlyObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/exp/3_exp_shock_normal_1.ani", ENUM_DRAWLAYER_BOTTOM, true);
	
	sq_AddObject(obj, pooledObj, OBJECTTYPE_DRAWONLY, false);
	
	local fScreen = sq_flashScreen(obj,0,80,0,80, sq_RGB(255,255,255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
	sq_addFlashScreen(fScreen, 0, 240, 240, 150, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);

	sq_SetMyShake(obj,4,200);
	obj.sq_PlaySound("MW_DMANTLE");
	
	// 크로니클아이템 추가 기능 어둠서클 확대율 (100%)
	local currentAni = sq_GetCurrentAnimation(obj);
	
	if(currentAni)
	{
		sizeRate = sizeRate.tofloat() / 100.0;
		currentAni.Proc();
		currentAni.setImageRateFromOriginal(sizeRate, sizeRate);
		
		sq_SetAttackBoundingBoxSizeRate(currentAni, sizeRate, sizeRate, sizeRate);
	}
	
	
}

function setState_po_ATDarknessMantleExp(obj, state, datas)
{

	if(!obj) return;

}

function procAppend_po_ATDarknessMantleExp(obj)
{

	if(!obj) return;

}

function onChangeSkillEffect_po_ATDarknessMantleExp(obj, skillIndex, reciveData)
{

	if(!obj) return;

}

function onDestroyObject_po_ATDarknessMantleExp(obj, object)
{

	if(!obj) return;

}

function onKeyFrameFlag_po_ATDarknessMantleExp(obj, flagIndex)
{

}

function onEndCurrentAni_po_ATDarknessMantleExp(obj)
{
	if(!obj) return;
	
	if(obj.isMyControlObject())
	{
		sq_SendDestroyPacketPassiveObject(obj);
	}
}
