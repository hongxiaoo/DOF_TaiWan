
function setCustomData_po_ATElementalStrikeEx(obj, reciveData)
{
	if(!obj) return;
	
	local pole_attack_rate = reciveData.readDword();
	local attack_rate = reciveData.readDword();
	local imagePerRate = reciveData.readDword();
	local element = reciveData.readDword();
	local speedRate = reciveData.readDword();

	obj.getVar("imagerate").clear_vector(); // state vector
	obj.getVar("imagerate").push_vector(imagePerRate);
	
	obj.getVar("attack").clear_vector(); // state vector
	obj.getVar("attack").push_vector(attack_rate);
	obj.getVar("attack").push_vector(pole_attack_rate);
	
	
	obj.getVar("element").clear_vector(); // state vector
	obj.getVar("element").push_vector(element);
	
	obj.getVar("speed").clear_vector(); // state vector
	obj.getVar("speed").push_vector(speedRate);
	
	obj.getVar("state").clear_vector(); // state vector
	obj.getVar("state").push_vector(0);
	
	obj.getVar("flag").clear_vector();
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);	
	obj.getVar("flag").push_vector(0);	
	obj.getVar("flag").push_vector(0);	
	
	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);
	
	
	
	if(obj.isMyControlObject())
	{
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
		obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_0, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}

}


function setState_po_ATElementalStrikeEx(obj, state, datas)
{
	if(!obj) return;
	
	local pChr = obj.getTopCharacter();
	
	local passiveState = state;
	
	obj.getVar("state").set_vector(0, passiveState);
	
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();
	
	local imagePerRate = obj.getVar("imagerate").get_vector(0);
	local imageRate = imagePerRate.tofloat() / 100.0;
	
	
	
	
	if(passiveState == PASSIVEOBJ_SUB_STATE_0)
	{
		local attackInfo = sq_GetCustomAttackInfo(obj, 0);
		sq_SetCurrentAttackInfo(obj, attackInfo);
		
		local attack_rate = obj.getVar("attack").get_vector(1);
		local pAttack = sq_GetCurrentAttackInfo(obj);
		sq_SetCurrentAttackBonusRate(pAttack, attack_rate);
		
		local element = obj.getVar("element").get_vector(0);		
		if(pAttack)
		{
			if (element != ENUM_ELEMENT_NONE)
			{
				pAttack.setElement(ENUM_ELEMENT_NONE);
				print(" \n push element:" + element);
				pAttack.setElement(element);
			}
		}
		
	
		local currentAni = obj.getCurrentAnimation();
		currentAni.Proc();
		print( " setImageRate:");
		currentAni.setImageRateFromOriginal(imageRate, imageRate);
		sq_SetAttackBoundingBoxSizeRate(currentAni, imageRate, imageRate, imageRate);
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		//local attackInfo = sq_GetDefaultAttackInfo(obj);
		local attackInfo = sq_GetCustomAttackInfo(obj, 1);
		sq_SetCurrentAttackInfo(obj, attackInfo);
		
		local attack_rate = obj.getVar("attack").get_vector(0);

		local pAttack = sq_GetCurrentAttackInfo(obj);
		sq_SetCurrentAttackBonusRate(pAttack, attack_rate);	
		
		local element = obj.getVar("element").get_vector(0);
		if(pAttack)
		{
			if(element != ENUM_ELEMENT_NONE)
				pAttack.setElement(element);
		}
		
		
		sq_SetMyShake(pChr,4,320);

		local ani = obj.getCustomAnimation(0);
		obj.setCurrentAnimation(ani);		
		
		local currentAni = obj.getCurrentAnimation();
		currentAni.Proc();
		print( " setImageRate:");
		currentAni.setImageRateFromOriginal(imageRate, imageRate);
		sq_SetAttackBoundingBoxSizeRate(currentAni, imageRate, imageRate, imageRate);
		
		local element = obj.getVar("element").get_vector(0);
		
		if (element == ENUM_ELEMENT_FIRE)
		{
			obj.sq_PlaySound("ESTRIKE_FIRE");
		}
		else if(element == ENUM_ELEMENT_WATER)
		{			
			obj.sq_PlaySound("ESTRIKE_WATER");
		}
		else if(element == ENUM_ELEMENT_DARK)
		{			
			obj.sq_PlaySound("ESTRIKE_DARK");
		}
		else if(element == ENUM_ELEMENT_LIGHT)
		{			
			obj.sq_PlaySound("ESTRIKE_LIGHT");
		}
		else if(element == ENUM_ELEMENT_NONE)
		{			
			obj.sq_PlaySound("ESTRIKE_FIRE");
		}		
	}
	
	local currentAni = obj.getCurrentAnimation();
	
	if(currentAni)
	{
		local speedRate = obj.getVar("speed").get_vector(0);
		currentAni.setSpeedRate(speedRate.tofloat());
	}
}


function procAppend_po_ATElementalStrikeEx(obj)
{
	if(!obj) return;
	
	local pChr = obj.getTopCharacter();
	
	local passiveState = obj.getVar("state").get_vector(0);
	
	
	if(passiveState == 0)
	{
		return;
	}


	local pAni = obj.getCurrentAnimation();
	
	local frameIndex = 0;
	
	if(pAni)
	{
		frameIndex = pAni.GetCurrentFrameIndex();
	}


	if(passiveState == PASSIVEOBJ_SUB_STATE_0)
	{
		
		if(frameIndex >= 10)
		{	
			if(obj.getVar("flag").get_vector(1) == 0)
			{
				sq_SetMyShake(pChr,2,150);
				obj.getVar("flag").set_vector(1, 1);
			}
		}
		
		if(frameIndex >= 11)
		{	
			if(obj.getVar("flag").get_vector(3) == 0)
			{
				local element = obj.getVar("element").get_vector(0);
				
				if (element == ENUM_ELEMENT_FIRE)
				{
					obj.sq_PlaySound("MCANNON_FIREFALL");
				}
				else if(element == ENUM_ELEMENT_WATER)
				{			
					obj.sq_PlaySound("MCANNON_ATK");
				}
				else if(element == ENUM_ELEMENT_DARK)
				{			
					obj.sq_PlaySound("MCANNON_DARKFALL");
				}
				else if(element == ENUM_ELEMENT_LIGHT)
				{			
					obj.sq_PlaySound("MCANNON_LIGHTFALL");
				}
				else if(element == ENUM_ELEMENT_NONE)
				{			
					obj.sq_PlaySound("MCANNON_FIREFALL");
				}
				
				obj.getVar("flag").set_vector(3, 1);
			}
		}

		if(frameIndex >= 14)
		{	
			if(obj.getVar("flag").get_vector(2) == 0)
			{
				if(pChr)
				{
					obj.sq_PlaySound("ESTRIKE_READY");
				}
				
				obj.getVar("flag").set_vector(2, 1);
			}
		}
		
		if(frameIndex >= 21)
		{	
			if(obj.getVar("flag").get_vector(0) == 0)
			{
				local fScreen = sq_flashScreen(obj,0,80,0,80, sq_RGB(255,255,255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
				sq_addFlashScreen(fScreen, 0, 320, 320, 180, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
				
				obj.getVar("flag").set_vector(0, 1);
			}
		}
	}
}

function setCustomData_po_ATElementalStrikeFireEx(obj, reciveData)
{
	setCustomData_po_ATElementalStrikeEx(obj, reciveData);
}

function setState_po_ATElementalStrikeFireEx(obj, state, datas)
{
	setState_po_ATElementalStrikeEx(obj, state, datas);
}

function procAppend_po_ATElementalStrikeFireEx(obj)
{
	procAppend_po_ATElementalStrikeEx(obj);
}


function onEndCurrentAni_po_ATElementalStrikeFireEx(obj)
{
	if(!obj) return;

	local passiveState = obj.getVar("state").get_vector(0);

	print(" passiveState:" + passiveState);
	if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		if(obj.isMyControlObject())
		{
			sq_SendDestroyPacketPassiveObject(obj);
		}
	}
	else
	{
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
		obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
}



///////////////////////////////////
// 公加己
///////////////////////////////////

function setCustomData_po_ATElementalStrikeNoneEx(obj, reciveData)
{
	setCustomData_po_ATElementalStrikeEx(obj, reciveData);
}

function setState_po_ATElementalStrikeNoneEx(obj, state, datas)
{
	setState_po_ATElementalStrikeEx(obj, state, datas);
}

function procAppend_po_ATElementalStrikeNoneEx(obj)
{
	procAppend_po_ATElementalStrikeEx(obj);
}


function onEndCurrentAni_po_ATElementalStrikeNoneEx(obj)
{
	if(!obj) return;

	local passiveState = obj.getVar("state").get_vector(0);

	print(" passiveState:" + passiveState);
	if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		if(obj.isMyControlObject())
		{
			sq_SendDestroyPacketPassiveObject(obj);
		}
	}
	else
	{
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
		obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
}

/////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////
// 鞠加己
///////////////////////////////////

function setCustomData_po_ATElementalStrikeDarkEx(obj, reciveData)
{
	setCustomData_po_ATElementalStrikeEx(obj, reciveData);
}

function setState_po_ATElementalStrikeDarkEx(obj, state, datas)
{
	setState_po_ATElementalStrikeEx(obj, state, datas);
}

function procAppend_po_ATElementalStrikeDarkEx(obj)
{
	procAppend_po_ATElementalStrikeEx(obj);
}


function onEndCurrentAni_po_ATElementalStrikeDarkEx(obj)
{
	if(!obj) return;

	local passiveState = obj.getVar("state").get_vector(0);

	print(" passiveState:" + passiveState);
	if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		if(obj.isMyControlObject())
		{
			sq_SendDestroyPacketPassiveObject(obj);
		}
	}
	else
	{
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
		obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
}

/////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////
// 荐加己
///////////////////////////////////

function setCustomData_po_ATElementalStrikeWaterEx(obj, reciveData)
{
	setCustomData_po_ATElementalStrikeEx(obj, reciveData);
}

function setState_po_ATElementalStrikeWaterEx(obj, state, datas)
{
	setState_po_ATElementalStrikeEx(obj, state, datas);
}

function procAppend_po_ATElementalStrikeWaterEx(obj)
{
	procAppend_po_ATElementalStrikeEx(obj);
}


function onEndCurrentAni_po_ATElementalStrikeWaterEx(obj)
{
	if(!obj) return;

	local passiveState = obj.getVar("state").get_vector(0);

	print(" passiveState:" + passiveState);
	if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		if(obj.isMyControlObject())
		{
			sq_SendDestroyPacketPassiveObject(obj);
		}
	}
	else
	{
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
		obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
}

/////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////
// 疙加己
///////////////////////////////////

function setCustomData_po_ATElementalStrikeLightEx(obj, reciveData)
{
	setCustomData_po_ATElementalStrikeEx(obj, reciveData);
}

function setState_po_ATElementalStrikeLightEx(obj, state, datas)
{
	setState_po_ATElementalStrikeEx(obj, state, datas);
}

function procAppend_po_ATElementalStrikeLightEx(obj)
{
	procAppend_po_ATElementalStrikeEx(obj);
}


function onEndCurrentAni_po_ATElementalStrikeLightEx(obj)
{
	if(!obj) return;

	local passiveState = obj.getVar("state").get_vector(0);

	print(" passiveState:" + passiveState);
	if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		if(obj.isMyControlObject())
		{
			sq_SendDestroyPacketPassiveObject(obj);
		}
	}
	else
	{
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
		obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
}

/////////////////////////////////////////////////////////////////////////////////////////
