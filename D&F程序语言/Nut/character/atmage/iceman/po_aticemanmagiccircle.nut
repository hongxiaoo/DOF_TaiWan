


function setCustomData_po_ATIceManMagicCircle(obj, reciveData)
{
	if(!obj) return;

				//sq_BinaryWriteDword(freezeRate); // 
				//sq_BinaryWriteDword(multiHitAttackRate); // 
				//sq_BinaryWriteDword(smashAttackRate); // 
				//sq_BinaryWriteDword(expPower); // 
	local freezeRate = reciveData.readDword(); //
	local multiHitAttackRate = reciveData.readDword(); //
	local smashAttackRate = reciveData.readDword(); //
	local expPower = reciveData.readDword(); //
	
	obj.getVar("freezeRate").clear_vector(); // 
	obj.getVar("freezeRate").push_vector(freezeRate);
	
	obj.getVar("attack").clear_vector(); // 
	obj.getVar("attack").push_vector(multiHitAttackRate);
	obj.getVar("attack").push_vector(smashAttackRate);
	obj.getVar("attack").push_vector(expPower);
	
	
	obj.getVar("state").clear_vector(); // state vector
	obj.getVar("state").push_vector(0);
	
	obj.getVar("flag").clear_vector();
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);
	obj.getVar("flag").push_vector(0);

	obj.getVar("casting").clear_obj_vector();

	local pChr = obj.getTopCharacter();
	
	print(" pChr:" + pChr);
	sq_SetCurrentDirection(obj, obj.getDirection());
	
	if(obj.isMyControlObject())
	{
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
		obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_0, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
}

function destroy_po_ATIceManMagicCircle(obj)
{
	if(!obj)
		return;
		
	destroyObjectByVar(obj, "casting");
	destroyObject(obj);
	
	
}


function setState_po_ATIceManMagicCircle(obj, state, datas)
{
	if(!obj) return;
	
	local pChr = obj.getTopCharacter();
	
	local passiveState = state;
	
	obj.getVar("state").set_vector(0, passiveState);

	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);

	
	obj.getVar("state").clear_ct_vector();
	obj.getVar("state").push_ct_vector();	
// 초기화	
	local t = obj.getVar("state").get_ct_vector(0);
	t.Reset();
	t.Start(10000,0);
	
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();
		
	if(passiveState == PASSIVEOBJ_SUB_STATE_0)
	{	
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		local ani = obj.getCustomAnimation(0);
		obj.setCurrentAnimation(ani);		
		
		local pooledBackObj = createAnimationPooledObject(obj, 
		"PassiveObject/Character/Mage/Animation/ATIceMan/01_casting/casting_base_back.ani", false, 
		posX, posY - 1, 0);
		
		local pooledFrontObj = createAnimationPooledObject(obj, 
		"PassiveObject/Character/Mage/Animation/ATIceMan/01_casting/casting_base_front.ani", false, 
		posX, posY + 2, 0);
		
		obj.getVar("casting").push_obj_vector(pooledBackObj);
		obj.getVar("casting").push_obj_vector(pooledFrontObj);
		

		createAnimationPooledObject(obj, 
		"PassiveObject/Character/Mage/Animation/ATIceMan/01_casting/02_roadappear_dodge_00.ani", true,
		posX, posY + 2, 0);
		
		createAnimationPooledObject(obj, 
		"PassiveObject/Character/Mage/Animation/ATIceMan/01_casting/02_roadappear_dodge_f_00.ani", true, 
		posX, posY - 1, 0);

	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_2)
	{
		//pChr.setDirection(
		local ani = obj.getCustomAnimation(1);
		obj.setCurrentAnimation(ani);			
			
		
		local pooledFrontObj = createAnimationPooledObject(obj, 
		"PassiveObject/Character/Mage/Animation/ATIceMan/02_pole/pole_base.ani", false, posX, posY, 0);
		
		obj.getVar().push_obj_vector(pooledFrontObj); // index 2
		
		// 먼지
		createAnimationPooledObject(obj, 
		"PassiveObject/Character/Mage/Animation/ATIceMan/02_pole/dust/19smoke_dodge_11.ani", true, 
		posX, posY + 1, 0);		
		//	
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_3)
	{ // 얼음파괴 1
		local ani = obj.getCustomAnimation(2);
		obj.setCurrentAnimation(ani);
	
		local attackInfo = sq_GetCustomAttackInfo(obj, 0);
		sq_SetCurrentAttackInfo(obj, attackInfo);
		
		////////////////////////////////////////////////////////
		// 쇼크웨이브 추가
		local pooledObj = null;
		
				
		pooledObj = sq_CreateDrawOnlyObject(obj, 
		"PassiveObject/Character/Mage/Animation/ATIceMan/03_destroy/common/18_shockwave_dodge_0.ani", 
		ENUM_DRAWLAYER_BOTTOM, true);
		
		pooledObj.setCurrentPos(posX, posY, 0);
		
		sq_AddObject(obj, pooledObj, OBJECTTYPE_DRAWONLY, false);
		////////////////////////////////////////////////////////
	

		local pooledFrontObj = createAnimationPooledObject(obj, 
		"PassiveObject/Character/Mage/Animation/ATIceMan/03_destroy/destroy_base_0.ani", false, posX, posY, 0);
		
		destroyObject(obj);
		
		obj.getVar().push_obj_vector(pooledFrontObj);
		
		local particleCreater = obj.getVar().GetparticleCreaterMap("AtIceManD0", "PassiveObject/Character/Mage/Particle/ATIceManDestroy0.ptl", obj);
			//
		particleCreater.Restart(0);
		particleCreater.SetPos(posX, posY + 5, posZ);	
		
		sq_AddParticleObject(obj, particleCreater);
		
		
		createAnimationPooledObject(obj, 
		"PassiveObject/Character/Mage/Animation/ATIceMan/03_destroy/02_broken/23_glow_dodge.ani", true, 
		posX, posY + 1, 0);
		
		local particle = obj.getVar().GetparticleCreaterMap("AtIceManD1", "PassiveObject/Character/Mage/Particle/ATIceManDestroy1.ptl", obj);
			//
		particle.Restart(0);
		particle.SetPos(posX, posY + 5, 55);	
		
		sq_AddParticleObject(obj, particle);
		
		local atk = sq_GetCurrentAttackInfo(obj);
		local smashAttackRate = obj.getVar("attack").get_vector(1);		
		sq_SetCurrentAttackBonusRate(atk, smashAttackRate);

		
		if(obj.isMyControlObject())
		{
			// 화면효과
			local fScreen = sq_flashScreen(obj,0,80,0,80, sq_RGB(255,255,255), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
			sq_addFlashScreen(fScreen, 0, 400, 240, 150, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
			//		
			
			sq_SetMyShake(obj,4,300);
		}
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_4)
	{ // 얼음파괴 2
		local pooledFrontObj = createAnimationPooledObject(obj, 
		"PassiveObject/Character/Mage/Animation/ATIceMan/03_destroy/destroy_base_1.ani", false, 
		posX, posY, 0);
		
		destroyObject(obj);
		
		obj.getVar().push_obj_vector(pooledFrontObj);
		
		// 글로우		
		createAnimationPooledObject(obj, 
		"PassiveObject/Character/Mage/Animation/ATIceMan/03_destroy/02_broken/23_glow_dodge.ani", true, 
		posX, posY + 1, 0);
		
		
		// 먼지
		createAnimationPooledObject(obj, 
			"PassiveObject/Character/Mage/Animation/ATIceMan/03_destroy/02_broken/dust/19smoke_dodge_00.ani", true, 
		posX, posY + 1, 0);		
		//
		
		local ani = obj.getCustomAnimation(2);
		obj.setCurrentAnimation(ani);
		
		local atk = sq_GetCurrentAttackInfo(obj);
		local smashAttackRate = obj.getVar("attack").get_vector(1);		
		sq_SetCurrentAttackBonusRate(atk, smashAttackRate);
		
		
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_5)
	{ // 얼음파괴 3
		local ani = obj.getCustomAnimation(2);
		obj.setCurrentAnimation(ani);
	
		local attackInfo = sq_GetCustomAttackInfo(obj, 1);
		
		sq_SetCurrentAttackInfo(obj, attackInfo);
	
		local pooledFrontObj = createAnimationPooledObject(obj, 
		"PassiveObject/Character/Mage/Animation/ATIceMan/03_destroy/destroy_base_2.ani", false, 
		posX, posY, 0);
		
		destroyObject(obj);
		
		local frontObj = obj.getVar("casting").get_obj_vector(0);
		local backObj = obj.getVar("casting").get_obj_vector(1);
		
		if(frontObj)
		{
			frontObj.setValid(false);
		}
		
		if(backObj)
		{
			backObj.setValid(false);
		}
		
		obj.getVar("casting").remove_obj_vector(frontObj);
		obj.getVar("casting").remove_obj_vector(backObj);
		
		
		obj.getVar().push_obj_vector(pooledFrontObj);
		
		// 글로우		
		createAnimationPooledObject(obj, 
		"PassiveObject/Character/Mage/Animation/ATIceMan/03_destroy/02_broken/23_glow_dodge.ani", true, 
		posX, posY + 1, 0);
		
		local particleCreater = obj.getVar().GetparticleCreaterMap("AtIceManD2", "PassiveObject/Character/Mage/Particle/ATIceManDestroy2.ptl", obj);
			//
		particleCreater.Restart(0);
		particleCreater.SetPos(posX, posY + 5, 55);	
		
		sq_AddParticleObject(obj, particleCreater);
		
		// 먼지
		createAnimationPooledObject(obj, 
		"PassiveObject/Character/Mage/Animation/ATIceMan/03_destroy/03_broken_02/dust/19smoke_dodge_00.ani", true, 
		posX, posY + 1, 0);		
		//
		if(obj.isMyControlObject())
		{
			sq_SetMyShake(obj,4,300);
		}
		
		local atk = sq_GetCurrentAttackInfo(obj);
		local expPower = obj.getVar("attack").get_vector(2);		
		sq_SetCurrentAttackPower(atk, expPower);
		
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_6)
	{ // 마법진삭제
		print(" passiveState == PASSIVEOBJ_SUB_STATE_6");
		local ani = obj.getCustomAnimation(3);
		obj.setCurrentAnimation(ani);
		
		
	}
	
	//local radiusRate = (radius100Rate.tofloat() / 100.0);	
	//local size = (sq_GetAniRealImageSize(currentAni, ENUM_DIRECTION_RIGHT) / 2) + 60;	
}

function procAppend_po_ATIceManMagicCircle(obj)
{
	if(!obj) return;
	
	local pChr = obj.getTopCharacter();
	
	if(!pChr)
	{
		if(obj.isMyControlObject())
		{
			sq_SendDestroyPacketPassiveObject(obj);
			return;
		}
	}
	
	local passiveState = obj.getVar("state").get_vector(0);
	
	if(pChr.getState() != STATE_ICEMAN)
	{
		if(passiveState <= PASSIVEOBJ_SUB_STATE_3)
		{
			if(obj.isMyControlObject())
			{
				sq_SendDestroyPacketPassiveObject(obj);
				return;
			}
		}
	}
	
	
	
	
	if(passiveState == PASSIVEOBJ_SUB_STATE_0)
	{
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		local sendState = false;
		local castingObj = obj.getVar("casting").get_obj_vector(0);
		
		if(castingObj)
		{
			local isEnd = sq_IsEnd(castingObj.getCurrentAnimation());
			
			if(isEnd)
			{
				if(pChr.getState() == STATE_ICEMAN && pChr.getSkillSubState() >= SUB_STATE_ICEMAN_1)
				{
					local frmIndex = sq_GetCurrentFrameIndex(pChr);
					
					if(frmIndex > 1)
					{
						//print(" pass");
						sendState = true;
					}
					
				}
				//
			}
		}
		else
		{
			//print(" castingObj is null");
			sendState = true;
		}
		
		if(obj.isMyControlObject())
		{
			if(sendState)
			{
				local pIntVec = sq_GetGlobalIntVector();
				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);

				obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_2, pIntVec, STATE_PRIORITY_AUTO, false, "");
			}
		}
	}
	else if(passiveState > PASSIVEOBJ_SUB_STATE_1 && passiveState < PASSIVEOBJ_SUB_STATE_6)
	{ // 얼음생성,  얼음파괴
		//PASSIVEOBJ_SUB_STATE_2	// 얼음생성
		//PASSIVEOBJ_SUB_STATE_3	// 얼음파괴 - 까만화면
		//PASSIVEOBJ_SUB_STATE_4	// 얼음파괴 - 파괴1
		//PASSIVEOBJ_SUB_STATE_5	// 얼음파괴 - 파괴2
		local sendState = false;
		local castingObj = obj.getVar().get_obj_vector(0);

		if(castingObj)
		{
			local isEnd = sq_IsEnd(castingObj.getCurrentAnimation()); // index 2
			
			if(isEnd)
			{
				if(passiveState == PASSIVEOBJ_SUB_STATE_2)
				{ // 얼음생성이 모두 끝났을 때
					if(pChr.getState() == STATE_ICEMAN && pChr.getSkillSubState() >= SUB_STATE_ICEMAN_4)
					{
						local frmIndex = sq_GetCurrentFrameIndex(pChr);
						
						//print( " now:" + frmIndex);
						
						if(frmIndex > 5)
						{
							sendState = true;
						}
					}
				}
				else
				{
					sendState = true;
				}
			}
			else
			{ // 애니메이션이 안끝났을 때
				if(passiveState == PASSIVEOBJ_SUB_STATE_2)				
				{ // 기둥과 몸이 프레임 동기화
					if(pChr.getSkillSubState() == SUB_STATE_ICEMAN_3)
					{
						local frmIndex = sq_GetCurrentFrameIndex(pChr);
						
						if(frmIndex <= 18)
						{
							local poleObj = obj.getVar().get_obj_vector(2); // index 2
							
							if(poleObj)
							{
								local poleFrmIndex = sq_GetCurrentFrameIndex(poleObj);
								
								if(poleFrmIndex != frmIndex)
								{
									sq_SetAnimationFrameIndex(poleObj.getCurrentAnimation(), frmIndex);
								}
							}
						}
					}
					else if(pChr.getState() == STATE_ICEMAN && pChr.getSkillSubState() >= SUB_STATE_ICEMAN_4)
					{
						local frmIndex = sq_GetCurrentFrameIndex(pChr);
						
						if(frmIndex > 5)
							sendState = true;
					}
				}
			}
		}
		else
		{
			sendState = true;
		}
		
		if(obj.isMyControlObject())
		{
			if(sendState)
			{
				local pIntVec = sq_GetGlobalIntVector();
				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);

				obj.addSetStatePacket(passiveState + 1, pIntVec, STATE_PRIORITY_AUTO, false, "");
			}
		}
	}
	
}

function onChangeSkillEffect_po_ATIceManMagicCircle(obj, skillIndex, reciveData)
{

	if(!obj) return;

}

function onDestroyObject_po_ATIceManMagicCircle(obj, object)
{

	if(!obj) return;

}

function onKeyFrameFlag_po_ATIceManMagicCircle(obj, flagIndex)
{

}

function onEndCurrentAni_po_ATIceManMagicCircle(obj)
{
	if(!obj) return;
	
	if(!obj.isMyControlObject())
		return;

	local passiveState = obj.getVar("state").get_vector(0);
	
	if(passiveState == PASSIVEOBJ_SUB_STATE_0)
	{
		local pIntVec = sq_GetGlobalIntVector();
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);

		obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_2)
	{
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_3)
	{
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_4)
	{
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_6)
	{ // 삭제
		print(" passiveState == PASSIVEOBJ_SUB_STATE_6 destroy");
		sq_SendDestroyPacketPassiveObject(obj);
	}
	
}

function onAttack_po_ATIceManMagicCircle(obj, damager, boundingBox, isStuck)
{
	if(!obj)
		return 0;
		
	local pChr = obj.getTopCharacter();
	
	if(!pChr)
		return 0;
	
	local active_damager = sq_GetCNRDObjectToActiveObject(damager);
	
	if(!active_damager)
		return 0;

	
	local passiveState = obj.getVar("state").get_vector(0);
	
	if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		local rand = sq_getRandom(0, 100); 
		
		local rate = obj.getVar("freezeRate").get_vector(0);
		print(" rate:" + rate + " rand" + rand);
		
		// 이속확율이 넘어가야 이속감소 어펜디지를 걸어줍니다..
		if(rand <= obj.getVar("freezeRate").get_vector(0))
		{	
			CNSquirrelAppendage.sq_AppendAppendage(damager, pChr, SKILL_ICEMAN, 
			true, "Character/ATMage/IceMan/ap_ATIceManMagicCircle.nut", true);
		}
	}
		
	return 0;
}
