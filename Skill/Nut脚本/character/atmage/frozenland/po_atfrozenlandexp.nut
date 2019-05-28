
S_PO_FROZENLAND_0 <- 10
S_PO_FROZENLAND_1 <- 11
S_PO_FROZENLAND_2 <- 12


function setCustomData_po_ATFrozenLandExp(obj, reciveData)
{

	if(!obj) return;
	
	local radiusSize = reciveData.readDword(); // 반지름
	local expAttackRate = reciveData.readDword(); // 폭발공격력
	local radius100Rate = reciveData.readDword(); // 서클 확대 비율
	
	
	obj.getVar("state").clear_vector(); // state vector
	obj.getVar("state").push_vector(0);
	
	obj.getVar("flag").clear_vector();
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);
	
	obj.getVar("radius").clear_vector();
	obj.getVar("radius").push_vector(radiusSize * 2);
	obj.getVar("radius").push_vector(radius100Rate);
	
	obj.getVar("attack").clear_vector();
	obj.getVar("attack").push_vector(expAttackRate);
	
	local pAttack = sq_GetCurrentAttackInfo(obj);
	sq_SetCurrentAttackBonusRate(pAttack, expAttackRate);
	
	
	if(obj.isMyControlObject()) {
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
		
		obj.addSetStatePacket(S_PO_FROZENLAND_0, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
	
	

}

function create_water_pole(obj, index, dx, dy, dz)
{
	local x = sq_GetXPos(obj) + dx;
	local y = sq_GetYPos(obj) + dy;
	local z = sq_GetZPos(obj) + dz;
	local ani = 0;
	if(index == 0) 
	{
		ani = sq_CreateAnimation("", "PassiveObject/Character/Mage/Animation/ATFrozenLand/exp/waterpole/04_exp_spray_back_normal_50.ani");
	}
	else
	{
		ani = sq_CreateAnimation("", "PassiveObject/Character/Mage/Animation/ATFrozenLand/exp/waterpole_1/04_exp_spray_back_normal_50.ani");
	}
	local pole_obj = sq_CreatePooledObject(ani,true);
	
	pole_obj.setCurrentPos(x,y,z);
	obj.getVar("cl").push_obj_vector(pole_obj); // 여기서 
	sq_AddObject(obj, pole_obj, OBJECTTYPE_DRAWONLY, false);
	
	createShockWaveAnimation(obj, x, y, z);
}

function create_exp_circle(obj, index, dx, dy, dz)
{
	local x = sq_GetXPos(obj) + dx;
	local y = sq_GetYPos(obj) + dy;
	local z = sq_GetZPos(obj) + dz;
	local ani = 0;
	if(index == 0) 
	{
		ani = sq_CreateAnimation("", "PassiveObject/Character/Mage/Animation/ATFrozenLand/exp/01/01_waterwave_normal_1.ani");
	}
	else
	{
		ani = sq_CreateAnimation("", "PassiveObject/Character/Mage/Animation/ATFrozenLand/exp/01/01_waterwave_normal_2.ani");
	}
	local pole_obj = sq_CreatePooledObject(ani,true);
	
	pole_obj.setCurrentPos(x,y,z);
	obj.getVar("cl").push_obj_vector(pole_obj); // 여기서 
	sq_AddObject(obj, pole_obj, OBJECTTYPE_DRAWONLY, false);
}


function setState_po_ATFrozenLandExp(obj, state, datas)
{

	if(!obj) return;

	local passiveState = state;
	
	obj.getVar("state").set_vector(0, passiveState);
	
	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);

	if(passiveState == S_PO_FROZENLAND_0) {
		//local fScreen = sq_flashScreen(obj,0,100,0,140, sq_RGB(255,255,255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
		local fScreen = sq_flashScreen(obj,0,160,0,140, sq_RGB(255,255,255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
		
		//create_exp_circle		
		local fullRadius = obj.getVar("radius").get_vector(0);
		
		local x1 = fullRadius.tofloat() * 0.48;
		local x2 = fullRadius.tofloat() * -0.42;

		//local x1 = fullRadius.tofloat() * 0.38; // 원본
		//local x2 = fullRadius.tofloat() * -0.32; // 원본
		
		create_exp_circle(obj, 0, x1.tointeger(), -10, 0);		
		create_exp_circle(obj, 0, x2.tointeger(), 35, 0);	

		local x3 = fullRadius.tofloat() * -0.207;
		local x4 = fullRadius.tofloat() * 0.368;		

		//local x3 = fullRadius.tofloat() * -0.107; // 원본
		//local x4 = fullRadius.tofloat() * 0.268; // 원본
		
		create_exp_circle(obj, 1, x3.tointeger(), -50, 0);
		create_exp_circle(obj, 1, x4.tointeger(), 40, 0);
	}
	else if(passiveState == S_PO_FROZENLAND_1) {
		sq_SetMyShake(obj,4,400);	
		local fScreen = sq_flashScreen(obj,0,800,200,140, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
		//local fScreen = sq_flashScreen(obj,0,600,200,140, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
		local ani = obj.getCustomAnimation(0);
		obj.setCurrentAnimation(ani);
		
		
		local radius100Rate = obj.getVar("radius").get_vector(1);
	
		local radiusRate = (radius100Rate.tofloat() / 100.0);
	
		local currentAni = sq_GetCurrentAnimation(obj);
		sq_SetAttackBoundingBoxSizeRate(currentAni, radiusRate, 1.0, 1.0);
		
		local atk = sq_GetCurrentAttackInfo(obj);
		
		if(atk) 
		{
			sq_SetChangeStatusIntoAttackInfo(atk, 0, ACTIVESTATUS_FREEZE, 100, 0, 1000);
		}
		//currentAni.setAttackBoundingBoxSizeRate(radiusRate, true);
		
		
		// 186 * 2 = 372 len / x = 140; 0.37;
		
		local fullRadius = obj.getVar("radius").get_vector(0);
		
		local x1 = fullRadius.tofloat() * 0.38;
		local x2 = fullRadius.tofloat() * -0.32;
		
		//create_water_pole(obj, 0, x1.tointeger(), -20, 0);		
		//create_water_pole(obj, 0, x2.tointeger(), 25, 0);
		//
		create_water_pole(obj, 0, x1.tointeger(), -10, 0);		
		create_water_pole(obj, 0, x2.tointeger(), 35, 0);
		
		local x3 = fullRadius.tofloat() * -0.107;
		local x4 = fullRadius.tofloat() * 0.268;
		
		//create_water_pole(obj, 1, x3.tointeger(), -60, 0);
		//create_water_pole(obj, 1, x4.tointeger(), 30, 0);

		create_water_pole(obj, 1, x3.tointeger(), -50, 0);
		create_water_pole(obj, 1, x4.tointeger(), 40, 0);
	}
	

}

function procAppend_po_ATFrozenLandExp(obj)
{

	if(!obj) return;
	
	local pChr = obj.getTopCharacter();
	
	if(!pChr) {
		if(obj.isMyControlObject())
			sq_SendDestroyPacketPassiveObject(obj);
		return;
	}
	
	local state = obj.getVar("state").get_vector(0);
	local passiveState = state;
	
	local pAni = sq_GetCurrentAnimation(obj);
	local frmIndex = sq_GetAnimationFrameIndex(pAni);
	local currentT = sq_GetCurrentTime(pAni);

	if(passiveState == S_PO_FROZENLAND_0) {
	}
	else if(passiveState == S_PO_FROZENLAND_1) {
		if(frmIndex > 0) {
			if(obj.getVar("flag").get_vector(VECTOR_FLAG_0) == 0) {
				obj.getVar("flag").set_vector(VECTOR_FLAG_0, 1);
			}
		}
	}
	else if(passiveState == S_PO_FROZENLAND_1) {
	}
	

}


function onDestroyObject_po_ATFrozenLandExp(obj, object)
{

	if(!obj) return;

}

function onKeyFrameFlag_po_ATFrozenLandExp(obj, flagIndex)
{

}

function onEndCurrentAni_po_ATFrozenLandExp(obj)
{

	if(!obj) return;

	if(!obj.isMyControlObject()) return;
	
	
	local state = obj.getVar("state").get_vector(0);
	
	local passiveState = state;

	if(passiveState == S_PO_FROZENLAND_0) {
	
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
		
		obj.addSetStatePacket(S_PO_FROZENLAND_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
	else if(passiveState == S_PO_FROZENLAND_1) {
		if(obj.isMyControlObject()) {
			sq_SendDestroyPacketPassiveObject(obj);
		}
	}
	else if(passiveState == S_PO_FROZENLAND_2) {
	}
}


function onAttack_po_ATFrozenLandExp(obj, damager, boundingBox, isStuck)
{
	if(!obj)
		return 0;
	
	local pChr = obj.getTopCharacter();
	
	if(!pChr)
		return 0;
	
	if(obj.isMyControlObject())
	{
		print("sq_ReleaseActiveStatus:");
		//sq_ReleaseActiveStatus(damager, ACTIVESTATUS_FREEZE);		//기획상으로 마지막 타격에 빙결이 해제되지 않는게 맞다고합니다.
	}

	return 0;
}
