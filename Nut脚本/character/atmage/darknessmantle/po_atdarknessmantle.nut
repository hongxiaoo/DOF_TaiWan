
function createBlackCrackPaticle(obj, x, y, z)
{
	if(!obj)
		return;

	local particleCreater = obj.getVar().GetparticleCreaterMap("CrackBlackPtl", "PassiveObject/Character/Mage/Particle/ATDarknessMantleCrack.ptl", obj);
		
	particleCreater.Restart(0);
	particleCreater.SetPos(x, y, z);
	sq_AddParticleObject(obj, particleCreater);
}


function createCrackPiece(obj, index, x, y, z)
{
	if(!obj)
		return null;
		
	local pooledObj = null;
	
	local cx = 0;
	local cy = 0;
	local cz = 0;
	
	
	//obj.getVar("crackpos").push_vector(0);
	//obj.getVar("crackpos").push_vector(0);
	//obj.getVar("crackpos").push_vector(0);
	//obj.getVar("crackpos").push_vector(0);	
	//obj.getVar("crackpos").push_vector(0);	
	//obj.getVar("crackpos").push_vector(0);	
	
	if(index == 0)
	{
		//pooledObj = createAnimationPooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Crack/12_crack_darkball_dodge.ani", false, x, y, z);
		cx = x - 30;
		cy = y + 2;
		cz = z + 174;
		pooledObj = createAnimationPooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Crack/08_crack_back_normal_50.ani", false, cx, cy, cz);
	}
	else if(index == 1)
	{
		//pooledObj = createAnimationPooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Crack/12_crack_darkball_dodge_1.ani", false, x, y, z);
		cx = x + 45;
		cy = y + 1;
		cz = z + 118;
		pooledObj = createAnimationPooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Crack/08_crack_back_normal_50.ani", false, cx, cy, cz);
	}
	else if(index == 2)
	{
		//pooledObj = createAnimationPooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Crack/12_crack_darkball_dodge_2.ani", false, x, y, z);
		cx = x + 8;
		cy = y + 1;
		cz = z + 50;
		pooledObj = createAnimationPooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Crack/08_crack_back_normal_50.ani", false, cx, cy, cz);
	}
	
	local vectorIndex = index * 2;
	obj.getVar("crackpos").set_vector(vectorIndex + 0, cx);
	obj.getVar("crackpos").set_vector(vectorIndex + 1, cz);
	
	
	
	return pooledObj;
}

function createDarkBall(obj, x, y, z)
{
	local pooledObj = createAnimationPooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Crack/darkball/09_darkball_0.ani", false, x, y, z);
	
	return pooledObj;
}


function createFrontFirstDarknessArea(obj, x, y, z, widthRate, heightRate)
{
	local pooledObj = createAnimationImageRatePooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/01/05_aura_front_normal_1.ani", false, widthRate, heightRate, x, y, z);
	
	return pooledObj;
}

function createBackFirstDarknessArea(obj, x, y, z, widthRate, heightRate)
{
	local pooledObj = createAnimationImageRatePooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/01/01_aura_back_normal_1.ani", false, widthRate, heightRate, x, y, z);
	
	return pooledObj;
}

function createFrontFirstSDarknessArea(obj, x, y, z, widthRate, heightRate)
{
	local pooledObj = createAnimationImageRatePooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/01/05_aura_front_normal_2.ani", false, widthRate, heightRate, x, y, z);
	
	return pooledObj;
}

function createBackFirstSDarknessArea(obj, x, y, z, widthRate, heightRate)
{
	local pooledObj = createAnimationImageRatePooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/01/01_aura_back_normal_2.ani", false, widthRate, heightRate, x, y, z);
	
	return pooledObj;
}



function createFrontLoopDarknessArea(obj, x, y, z, widthRate, heightRate)
{
	local pooledObj = createAnimationImageRatePooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Loop/05_aura_front_normal_1.ani", false, widthRate, heightRate, x, y, z);
	
	return pooledObj;	
}

function createBackLoopDarknessArea(obj, x, y, z, widthRate, heightRate)
{
	local pooledObj = createAnimationImageRatePooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Loop/01_aura_back_normal_1.ani", false, widthRate, heightRate, x, y, z);
	
	return pooledObj;
}

function createFrontLoopSDarknessArea(obj, x, y, z, widthRate, heightRate)
{
	local pooledObj = createAnimationImageRatePooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Loop/05_aura_front_normal_2.ani", false, widthRate, heightRate, x, y, z);
	
	return pooledObj;
}

function createBackLoopSDarknessArea(obj, x, y, z, widthRate, heightRate)
{
	local pooledObj = createAnimationImageRatePooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Loop/01_aura_back_normal_2.ani", false, widthRate, heightRate, x, y, z);
	
	return pooledObj;	
}


function destroyCrackObject(obj)
{
	if(!obj)
		return;

	local objListSize = obj.getVar("crack").get_obj_vector_size();
	
	print(" crack objListSize:" + objListSize);
	for(local i =0;i<objListSize;++i)
	{				
		local crackObj = obj.getVar("crack").get_obj_vector(i);
		if(crackObj == null)
			continue;
			
		crackObj.setValid(false);
	}
	
	obj.getVar("crack").clear_obj_vector();
}

function setPosXCrackObject(obj, cx)
{
	local objListSize = obj.getVar("crack").get_obj_vector_size();
	
	for(local i =0;i<objListSize;++i)
	{				
		local vObj = obj.getVar("crack").get_obj_vector(i);
		if(vObj == null)
			continue;

		sq_setCurrentAxisPos(vObj, 0, cx);
	}
}


function procCrackDarknessCircle(obj) // 균열이 났을 때 구체가 흔들리는 처리
{
	if(!obj)
		return;
		
	local circle_obj = obj.getVar().get_obj_vector(0); // 구
	
	if(!circle_obj)
		return;
	
	local x = sq_GetXPos(circle_obj);
	local y = sq_GetYPos(circle_obj);
	local z = sq_GetZPos(circle_obj);
	
	local vib = false;
	local objListSize = obj.getVar().get_obj_vector_size();	

	for(local i =1;i<objListSize;++i)
	{				
		local crackObj = obj.getVar().get_obj_vector(i);
		if(crackObj == null)
			continue;
			
		local ani = sq_GetCurrentAnimation(crackObj);
		local frmIndex = sq_GetAnimationFrameIndex(ani);
	
		print( " exp i:" + i + " frmIndex:" + frmIndex);
		if(frmIndex >= 1)
		{
			local expVectorIndex = i - 1;
			
			if(!obj.getVar("crackexp").get_vector(expVectorIndex))
			{
				sq_SetMyShake(obj, 2, 100);
							
				local ox = sq_GetXPos(obj);
				local oy = y + 1;
				local oz = sq_GetZPos(obj);
			
				local crackPooledObj = null;
				
				if(expVectorIndex == 0)
					crackPooledObj = createAnimationPooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Crack/12_crack_darkball_dodge.ani", false, ox, oy, oz);
				else if(expVectorIndex == 1)
					crackPooledObj = createAnimationPooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Crack/12_crack_darkball_dodge_1.ani", false, ox, oy, oz);
				else if(expVectorIndex == 2)
					crackPooledObj = createAnimationPooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Crack/12_crack_darkball_dodge_2.ani", false, ox, oy, oz);

				obj.getVar("crack").push_obj_vector(crackPooledObj);
				
				local vectorIndex = (expVectorIndex) * 2;
				//
				local cx = obj.getVar("crackpos").get_vector(vectorIndex + 0);
				local cz = obj.getVar("crackpos").get_vector(vectorIndex + 1);
				//
				local particleCreater = obj.getVar().GetparticleCreaterMap("ATDarknessMantlePtl", "PassiveObject/Character/Mage/Particle/Appear.ptl", obj);
					//
				particleCreater.Restart(0);
				particleCreater.SetPos(cx, y + 5, cz);	
				
				sq_AddParticleObject(obj, particleCreater);
				//	
				createBlackCrackPaticle(obj, cx, y + 4, cz);
				//
				obj.getVar("crackexp").set_vector(expVectorIndex, 1);
			}
		}
		
		if(frmIndex >= 1 && frmIndex < 4)
		{
			vib = true;
		}
	}
	
	
	
	
	local cx = obj.getVar("darkcircle").get_vector(0);
	
	if(vib)
	{
		if(x <= cx)
		{
			sq_setCurrentAxisPos(circle_obj, 0, cx + 2);
			setPosXCrackObject(obj, cx + 2);
		}
		else
		{
			sq_setCurrentAxisPos(circle_obj, 0, cx - 2);
			setPosXCrackObject(obj, cx - 2);
		}
	}
	else
	{
		if(x != cx)
		{
			sq_setCurrentAxisPos(circle_obj, 0, cx);
			setPosXCrackObject(obj, cx);
		}
	}
	
	
}

function setCustomData_po_ATDarknessMantle(obj, reciveData)
{

	if(!obj) return;

	local suckVel = reciveData.readDword(); // 0. 끌어당기는 힘
	// 0.검은기운 범위 (<-100%->) 1.맨틀공격력(%) 2.둔화레벨 3.둔화지속레벨
	local darkCircleRate = reciveData.readDword(); // 어둠서클 범위 (100%)
	local expAtkRate = reciveData.readDword(); // 1.맨틀공격력(%)
	local slowLevel = reciveData.readDword(); // 둔화 레벨
	local slowTime = reciveData.readDword(); // 둔화 지속시간
	local sizeRate = reciveData.readDword(); // 크로니클아이템 추가 기능 어둠서클 확대율 (100%)


	// 크로니클아이템 추가 기능 어둠서클 확대율 (100%)
	obj.getVar("sizerate").clear_vector();
	obj.getVar("sizerate").push_vector(sizeRate);
	
	obj.getVar("attack").clear_vector();
	obj.getVar("attack").push_vector(suckVel);
	obj.getVar("attack").push_vector(darkCircleRate);
	obj.getVar("attack").push_vector(expAtkRate);
	obj.getVar("attack").push_vector(slowLevel);
	obj.getVar("attack").push_vector(slowTime);
	
	obj.getVar("flag").clear_vector();
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);
	
	obj.getVar("state").clear_vector(); // state vector
	obj.getVar("state").push_vector(PASSIVEOBJ_SUB_STATE_0);
	

	obj.getVar("state").clear_ct_vector();
	obj.getVar("state").push_ct_vector();	
	
	obj.getVar("crackexp").clear_vector();
	obj.getVar("crackexp").push_vector(0);
	obj.getVar("crackexp").push_vector(0);
	obj.getVar("crackexp").push_vector(0);
	obj.getVar("crackexp").push_vector(0);	
	obj.getVar("crackexp").push_vector(0);	
	obj.getVar("crackexp").push_vector(0);	
	
	obj.getVar("crackpos").clear_vector();
	obj.getVar("crackpos").push_vector(0);
	obj.getVar("crackpos").push_vector(0);
	obj.getVar("crackpos").push_vector(0);
	obj.getVar("crackpos").push_vector(0);	
	obj.getVar("crackpos").push_vector(0);	
	obj.getVar("crackpos").push_vector(0);	
	
	obj.getVar("crack").clear_obj_vector();
	
	obj.getVar("create").clear_vector();
	obj.getVar("create").push_vector(1);
	
	
	local pIntVec = sq_GetGlobalIntVector();
	sq_IntVectorClear(pIntVec);
	sq_IntVectorPush(pIntVec, 0);	
	obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_0, pIntVec, STATE_PRIORITY_AUTO, false, "");
}

function setState_po_ATDarknessMantle(obj, state, datas)
{
	if(!obj) return;
	
	local passiveState = state;
	
	obj.getVar("flag").clear_vector();
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);	
	
	obj.getVar("crackexp").clear_vector();
	obj.getVar("crackexp").push_vector(0);
	obj.getVar("crackexp").push_vector(0);
	obj.getVar("crackexp").push_vector(0);
	obj.getVar("crackexp").push_vector(0);	
	obj.getVar("crackexp").push_vector(0);	
	obj.getVar("crackexp").push_vector(0);	
	
	obj.getVar("crackpos").clear_vector();
	obj.getVar("crackpos").push_vector(0);
	obj.getVar("crackpos").push_vector(0);
	obj.getVar("crackpos").push_vector(0);
	obj.getVar("crackpos").push_vector(0);	
	obj.getVar("crackpos").push_vector(0);	
	obj.getVar("crackpos").push_vector(0);	
	
	obj.getVar("state").set_vector(0, passiveState);

	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);

	
	local t = obj.getVar("state").get_ct_vector(0);
	t.Reset();
	t.Start(10000,0);
	
	
	//obj.getVar("attack").push_vector(suckVel);
	//obj.getVar("attack").push_vector(darkCircleRate);
	//obj.getVar("attack").push_vector(expAtkRate);
	//obj.getVar("attack").push_vector(slowLevel);
	//obj.getVar("attack").push_vector(slowTime);
//.tointeger()
//.tofloat()	

	local area100Rate = obj.getVar("attack").get_vector(VECTOR_FLAG_1);
	
	local areaRate = area100Rate.tofloat() / 100.0;
	
	
	if(passiveState == PASSIVEOBJ_SUB_STATE_0)
	{
		local po1 = createBackFirstDarknessArea(obj, x, y - 25, 0, areaRate, areaRate);
		local po2 = createFrontFirstDarknessArea(obj, x, y + 50, 0, areaRate, areaRate);		
		local po3 = createBackFirstSDarknessArea(obj, x, y - 22, 0, areaRate, areaRate);
		local po4 = createFrontFirstSDarknessArea(obj, x, y + 20, 0, areaRate, areaRate);
		
		destroyObject(obj);


		
		obj.getVar().push_obj_vector(po1);
		obj.getVar().push_obj_vector(po2);
		obj.getVar().push_obj_vector(po3);
		obj.getVar().push_obj_vector(po4);
		
		local currentAni = sq_GetCurrentAnimation(obj);
		
		if(currentAni)
		{
			//currentAni.setImageRateFromOriginal(areaRate, areaRate);
			currentAni.applyBoundingBoxRate(areaRate,0,0); //
		}
		
		initGetVarTimer(obj, 1, 30, -1);
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		//local po1 = createBackLoopDarknessArea(obj, x, y - 25, 0, areaRate, areaRate);
		//local po2 = createFrontLoopDarknessArea(obj, x, y + 50, 0, areaRate, areaRate);
		//local po3 = createBackLoopSDarknessArea(obj, x, y - 22, 0, areaRate, areaRate);
		//local po4 = createFrontLoopSDarknessArea(obj, x, y + 20, 0, areaRate, areaRate);
		
		local ani = obj.getCustomAnimation(0);
		
		if(ani)
			obj.setCurrentAnimation(ani);
			
		//destroyObject(obj);
//
		//local loopAni = po2.getCurrentAnimation();
		//local size = sq_GetAniRealImageSize(loopAni, ENUM_DIRECTION_RIGHT);
		//
		//obj.getVar("attack").push_vector(size);
//
		//obj.getVar().push_obj_vector(po1);
		//obj.getVar().push_obj_vector(po2);
		//obj.getVar().push_obj_vector(po3);
		//obj.getVar().push_obj_vector(po4);
		
		local currentAni = sq_GetCurrentAnimation(obj);
		
		if(currentAni)
		{
			currentAni.applyBoundingBoxRate(areaRate,0,0); //
		}
	}	
	else if(passiveState == PASSIVEOBJ_SUB_STATE_2)
	{
		local po1 = createAnimationImageRatePooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Release/01_aura_back_normal_1.ani", true, areaRate, areaRate, x, y - 25, 0);
		local po2 = createAnimationImageRatePooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Release/05_aura_front_normal_1.ani", true, areaRate, areaRate, x, y + 50, 0);
		local po3 = createAnimationImageRatePooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Release/01_aura_back_normal_2.ani", true, areaRate, areaRate, x, y - 22, 0);
		local po4 = createAnimationImageRatePooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Release/05_aura_front_normal_2.ani", true, areaRate, areaRate, x, y + 20, 0);
		
		destroyObject(obj);
		
		local ani = obj.getCustomAnimation(1);
		
		if(ani)
			obj.setCurrentAnimation(ani);
			
		
			
		local p5 = createAnimationPooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/Suck/07_absorb_normal_50r.ani", false, x + 3, y + 10, 110);
		obj.getVar().push_obj_vector(p5);
		
		local parentObj = obj.getParent();

		// 끌어들이는 어펜디지 가동		
		local appendage = CNSquirrelAppendage.sq_AppendAppendage(parentObj, obj, SKILL_DARKNESSMANTLE, false, "Character/ATMage/DarknessMantle/ap_ATDarknessMantle_suck.nut", false);

		
		local suckVel = obj.getVar("attack").get_vector(VECTOR_FLAG_0);
		local range = obj.getVar("attack").get_vector(VECTOR_FLAG_5);
		
		if(appendage)
		{
			//appendage.sq_SetValidTime(3000);
			// 여기서 append 작업		
			CNSquirrelAppendage.sq_Append(appendage, parentObj, obj);
			
			local auraAppendage = appendage.sq_getAuraMaster("auraMaster");
			//
			if(!auraAppendage)
				auraAppendage = appendage.sq_AddAuraMaster("auraMaster", parentObj, obj, 1200, 18, 5, 0);
			
			if(auraAppendage)
			{
				auraAppendage.setAttractionInfo(suckVel, suckVel, range, 100);
			}
			//
		}
		
		
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_3)
	{
		local cx = x + 3;
		local cy = y + 10;
		local cz = 110;
		
		local poBall = createDarkBall(obj, cx, cy, cz);
		
		destroyObject(obj);
	
	//4183
	//6515
		
		obj.getVar().push_obj_vector(poBall); // 0
		
		obj.getVar("darkcircle").clear_vector();
		
		obj.getVar("darkcircle").push_vector(cx);
		obj.getVar("darkcircle").push_vector(cy);
		obj.getVar("darkcircle").push_vector(cz);
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_4)
	{
		local cx = x;
		local cy = y + 12;
		local cz = 0;		
		
		local expStartObj = createAnimationPooledObject(obj, "PassiveObject/Character/Mage/Animation/ATDarknessMantle/16_exp_start.ani", false, cx, cy, cz);
		obj.getVar().push_obj_vector(expStartObj); // 4
	}
	
	local atk = sq_GetCurrentAttackInfo(obj);
	
	if(atk)
	{
		local slowLevel = obj.getVar("attack").get_vector(VECTOR_FLAG_3);
		local slowTime = obj.getVar("attack").get_vector(VECTOR_FLAG_4);
		
		sq_SetChangeStatusIntoAttackInfo(atk, 0, ACTIVESTATUS_SLOW, 100, slowLevel, slowTime);
	}		
	
	
}


function allDestroy(obj)
{
	if(!obj)
		return;

	destroyObject(obj);
	destroyCrackObject(obj);
	
	local parentObj = obj.getParent();
	CNSquirrelAppendage.sq_RemoveAppendage(parentObj, "Character/ATMage/DarknessMantle/ap_ATDarknessMantle_suck.nut");	

	if(obj.isMyControlObject())
	{
		sq_SendDestroyPacketPassiveObject(obj);
	}
}

function destroy_po_ATDarknessMantle(obj)
{
	destroyObject(obj);
	destroyCrackObject(obj);
	
	local parentObj = obj.getParent();
	CNSquirrelAppendage.sq_RemoveAppendage(parentObj, "Character/ATMage/DarknessMantle/ap_ATDarknessMantle_suck.nut");
}

function reset_po_ATDarknessMantle(obj)
{
}

function procAppend_po_ATDarknessMantle(obj)
{
	if(!obj) return;	
	
	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);
	
	local passiveState = obj.getVar("state").get_vector(0);
	
	local objListSize = obj.getVar().get_obj_vector_size();	
	
	local pAni = sq_GetCurrentAnimation(obj);
	local frmIndex = sq_GetAnimationFrameIndex(pAni);
	//local currentT = sq_GetCurrentTime(pAni);
	//local currentT = obj.getStateTimer().Get();
	
	
	local t = obj.getVar("state").get_ct_vector(0);
	local currentT = 0;
	
	if(t)
	{
		currentT = t.Get();
	}
	
	
	if(passiveState == PASSIVEOBJ_SUB_STATE_0)
	{
		if(frmIndex > 1)
			procParticleCreaterMap(obj, currentT, "PassiveObject/Character/Mage/Particle/mmagic_dark.ptl", x, y, z); 
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		if(objListSize > 0)
		{
			local p1 = obj.getVar().get_obj_vector(0);	
			local p2 = obj.getVar().get_obj_vector(1);
			local p3 = obj.getVar().get_obj_vector(2);
			local p4 = obj.getVar().get_obj_vector(3);
		}
		
		if(currentT > 1000)
		{
			if(obj.isMyControlObject())
			{
				local pIntVec = sq_GetGlobalIntVector();
				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);	
				obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_2, pIntVec, STATE_PRIORITY_AUTO, false, "");
			}
		}
		else
		{
			procParticleCreaterMap(obj, currentT, "PassiveObject/Character/Mage/Particle/mmagic_dark.ptl", x, y, z); 
		}
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_2)
	{
		local darkCircleObj = obj.getVar().get_obj_vector(0); // 2
		
		local ani = sq_GetCurrentAnimation(darkCircleObj);
		
		if(sq_IsEnd(ani))
		{		
			if(obj.isMyControlObject())
			{
				local pIntVec = sq_GetGlobalIntVector();
				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);	
				obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_3, pIntVec, STATE_PRIORITY_AUTO, false, "");
			}
		}
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_3)
	{
		if(currentT > 20)
		{	
			local crack0 = obj.getVar().get_obj_vector(1);
			local crack1 = obj.getVar().get_obj_vector(2);
			local crack2 = obj.getVar().get_obj_vector(3);
			
			local cy = y + 11;
			
			if(!obj.getVar("flag").get_vector(0))
			{
				local p6 = createCrackPiece(obj, 0, x, cy, 0);
				obj.getVar().push_obj_vector(p6); // 1
				obj.getVar("flag").set_vector(0, 1);
			}
			
			if(obj.getVar("flag").get_vector(0) == 1)
			{		
				if(!obj.getVar("flag").get_vector(1))
				{				
					local ani = sq_GetCurrentAnimation(crack0);
					local frmIndex = sq_GetAnimationFrameIndex(ani);
					
					if(frmIndex >= 3)
					{
						local p6 = createCrackPiece(obj, 1, x, cy, 0);
						obj.getVar().push_obj_vector(p6); // 2
						obj.getVar("flag").set_vector(1, 1);
					}
				}
			}
			
			if(obj.getVar("flag").get_vector(1) == 1)
			{
				if(!obj.getVar("flag").get_vector(2))
				{
					local ani = sq_GetCurrentAnimation(crack1);
					local frmIndex = sq_GetAnimationFrameIndex(ani);
					
					if(frmIndex >= 3)
					{			
						local p6 = createCrackPiece(obj, 2, x, cy, 0);
						obj.getVar().push_obj_vector(p6); //3
						obj.getVar("flag").set_vector(2, 1);
					}
				}
			}
			
			if(!obj.getVar("flag").get_vector(3))
			{
				local ani = sq_GetCurrentAnimation(crack2);
				local frmIndex = sq_GetAnimationFrameIndex(ani);
				
				if(frmIndex >= 3)
				{
					obj.getVar("flag").set_vector(3, 1);
				}
			}
			
			procCrackDarknessCircle(obj);
			
			local objListSize = obj.getVar().get_obj_vector_size();	
			
			if(objListSize >= 4)
			{		
				local isEndAnimation = true; // 균열 애니메이션이 끝났는지 체크

				for(local i =1;i<objListSize;++i)
				{				
					local obj = obj.getVar().get_obj_vector(i);
					if(obj == null)
						continue;
						
					local ani = sq_GetCurrentAnimation(obj);
					
					local isEnd = sq_IsEnd(ani);
					
					if(!isEnd)
						isEndAnimation = false;
				}
				
				if(isEndAnimation)
				{
					if(obj.isMyControlObject())
					{
						local pIntVec = sq_GetGlobalIntVector();
						sq_IntVectorClear(pIntVec);
						sq_IntVectorPush(pIntVec, 0);	
						obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_4, pIntVec, STATE_PRIORITY_AUTO, false, "");
					}
				}
			}
		}
			
		// PASSIVEOBJ_SUB_STATE_3
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_4)
	{
		local expStartObj = obj.getVar().get_obj_vector(4); // exp
		
		if(expStartObj)
		{
			local ani = sq_GetCurrentAnimation(expStartObj);
			local isEnd = sq_IsEnd(ani);
			
			if(!obj.getVar("flag").get_vector(1))
			{
				local expFrmIndex = sq_GetAnimationFrameIndex(ani);
				
				if(expFrmIndex >= 2)
				{
					local fScreen = sq_flashScreen(obj,0,100,0,200, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
					obj.getVar("flag").set_vector(1, 1);
				}
			}
			
			if(isEnd)
			{
				print(" exp:" + obj.getVar("flag").get_vector(0));
				if(!obj.getVar("flag").get_vector(0))
				{
					destroyCrackObject(obj);

					if(obj.isMyControlObject())
					{
						local expAtkRate = obj.getVar("attack").get_vector(VECTOR_FLAG_2);
						sq_BinaryStartWrite();
						sq_BinaryWriteDword(expAtkRate); //
						// 크로니클 아이템 추가작업
						// 크로니클아이템 추가 기능 어둠서클 확대율 (100%)
						local size100Rate = 100;
						
						if(obj.getVar("sizerate").get_vector(0) > 0)
						{
							size100Rate = obj.getVar("sizerate").get_vector(0);
						}
						
						sq_BinaryWriteDword(size100Rate); //
						///////////////////////////////////
						
						
						sq_SendCreatePassiveObjectPacket(obj, 24253, 0, 0, 1, 0, obj.getDirection());
					}
					obj.getVar("flag").set_vector(0, 1);
					allDestroy(obj);
				}
			}
		}
		else
		{
			allDestroy(obj);
		}
		
	}

}

function onChangeSkillEffect_po_ATDarknessMantle(obj, skillIndex, reciveData)
{

	if(!obj) return;

}

function onDestroyObject_po_ATDarknessMantle(obj, object)
{
	if(!obj) return;

}

function onKeyFrameFlag_po_ATDarknessMantle(obj, flagIndex)
{

}

function onEndCurrentAni_po_ATDarknessMantle(obj)
{
	if(!obj) return;
	
	local passiveState = obj.getVar("state").get_vector(0);
	
	if(passiveState == PASSIVEOBJ_SUB_STATE_0)
	{
		local x = sq_GetXPos(obj);
		local y = sq_GetYPos(obj);
		local z = sq_GetZPos(obj);
		
		local area100Rate = obj.getVar("attack").get_vector(VECTOR_FLAG_1);
		
		local areaRate = area100Rate.tofloat() / 100.0;
		
		local po1 = createBackLoopDarknessArea(obj, x, y - 25, 0, areaRate, areaRate);
		local po2 = createFrontLoopDarknessArea(obj, x, y + 50, 0, areaRate, areaRate);
		local po3 = createBackLoopSDarknessArea(obj, x, y - 22, 0, areaRate, areaRate);
		local po4 = createFrontLoopSDarknessArea(obj, x, y + 20, 0, areaRate, areaRate);
			
		destroyObject(obj);
		
		local loopAni = po2.getCurrentAnimation();
		local size = sq_GetAniRealImageSize(loopAni, ENUM_DIRECTION_RIGHT);
		
		obj.getVar("attack").push_vector(size);

		obj.getVar().push_obj_vector(po1);
		obj.getVar().push_obj_vector(po2);
		obj.getVar().push_obj_vector(po3);
		obj.getVar().push_obj_vector(po4);
	
	
		if(obj.isMyControlObject())
		{
			local pIntVec = sq_GetGlobalIntVector();
			sq_IntVectorClear(pIntVec);
			sq_IntVectorPush(pIntVec, 0);	
			obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
		}
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_2)
	{
	}
	

}

function onAttack_po_ATDarknessMantle(obj, damager, boundingBox, isStuck)
{
	if(!obj) return 0;
	
	local pChr = obj.getTopCharacter();
	
	if(!pChr) return 0;
	
	local active_damager = sq_GetCNRDObjectToActiveObject(damager);
	
	if(!active_damager)
		return 0;
		
	CNSquirrelAppendage.sq_AppendAppendage(damager, damager, SKILL_DARKNESSMANTLE, 
	false, "Character/ATMage/DarknessMantle/ap_ATDarknessMantle_effect.nut", true);
	
	
	
	return 0;
}
