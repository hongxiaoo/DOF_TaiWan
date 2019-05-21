
VI_SKL_0 <- 0 // 0. 처음 타겟팅시 Y축 범위 (상하 포함)
VI_SKL_1 <- 1 // 1.처음 타겟팅시 X축 시작 거리
VI_SKL_2 <- 2 // 2.처음 타겟팅시 X축 끝 거리
VI_SKL_3 <- 3 // 3.체인시 다음 타겟까지의 최대 거리
VI_SKL_4 <- 4 // 4.타격할 적의 최대 높이

VI_SKL_5 <- 5 // 5.링크 최대 갯수 
VI_SKL_6 <- 6 // 6.지속시간
VI_SKL_7 <- 7 // 7.공격력(%)
VI_SKL_8 <- 8 // 8.다단히트 횟수
VI_SKL_9 <- 9 // 9.다단히트 간격


function procAppend_po_CreatorWindStorm(obj)
{
	if (!obj)
		return;
	
	local pChr = obj.getTopCharacter();
	
	local state = obj.getVar("state").get_vector(0);
	
	if (!pChr)
	{
		if (state == PASSIVEOBJ_SUB_STATE_1 || state == PASSIVEOBJ_SUB_STATE_2)
		{
			if (obj.isMyControlObject())
			{
				local pIntVec = sq_GetGlobalIntVector();

				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);
				obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_2, pIntVec, STATE_PRIORITY_AUTO, false, "");
			}
			return;
		}
	}	
	
	local ani = obj.getCurrentAnimation();
	local isEnd = sq_IsEnd(ani);
	


	local objectManager = obj.getObjectManager();
			
	if (!objectManager)
		return;

	local stage = sq_GetObjectManagerStage(obj);
	local control = stage.getMainControl();


	if (state == PASSIVEOBJ_SUB_STATE_0)	
	{
		// 스타트 애니메이션
		if (obj.isMyControlObject())
		{
			local skillState = getCreatorSkillStateSkillIndex(pChr);
			//print(" skillState:" + skillState);
			if (!control.IsRBDown() || skillState != CREATOR_TYPE_WIND)
			{
				local pIntVec = sq_GetGlobalIntVector();

				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);
				print(" wind PASSIVEOBJ_SUB_STATE_2");
				print(" wind PASSIVEOBJ_SUB_STATE_2");
				print(" wind PASSIVEOBJ_SUB_STATE_2");
				print(" wind PASSIVEOBJ_SUB_STATE_2");
				obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_2, pIntVec, STATE_PRIORITY_AUTO, false, "");
			}
			else
			{
				if (isEnd)
				{
					local pIntVec = sq_GetGlobalIntVector();
					sq_IntVectorClear(pIntVec);
					sq_IntVectorPush(pIntVec, 0);

					obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
				}
			}
		}
	}
	else if (state == PASSIVEOBJ_SUB_STATE_1)
	{
		// 루핑 애니메이션
		local t = obj.getVar().get_ct_vector(0);
		local currentT = 0;
		
		currentT = t.Get();
	
		local hitT = obj.getVar().get_timer_vector(0);
	
		if(hitT)
		{		
			if (hitT.isOnEvent(currentT) == true)
			{
				// 소모량 적용
				local consumeValue = obj.getVar("consume").get_vector(0);
				useCreatorSkill(pChr, SKILL_WINDSTORM, 0, 0, consumeValue);
			
				obj.resetHitObjectList();
			}
		}	
		
		// 각도 잡기
		if (obj.isMyControlObject())
		{
			
			local remainRate = getCreatorTypeGaugeRate(pChr);
			
			local skillState = getCreatorSkillStateSkillIndex(pChr);
			//print(" skillState:" + skillState);
			if (!control.IsRBDown() || remainRate <= 0.0 || skillState != CREATOR_TYPE_WIND)
			{
				local pIntVec = sq_GetGlobalIntVector();

				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);

				obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_2, pIntVec, STATE_PRIORITY_AUTO, false, "");
			}
		}
	}
	else if (state == PASSIVEOBJ_SUB_STATE_2)	
	{
		if (obj.isMyControlObject())
		{
			if (isEnd)
				sq_SendDestroyPacketPassiveObject(obj);
		}
	}
	
}


function setCustomData_po_CreatorWindStorm(obj, reciveData)
{
	if (!obj) return;
	
	
	// 다단히트 간격
	local multiHitTerm = reciveData.readDword();
	// 소모량
	local consume = reciveData.readDword();
	// 공격력
	local power = reciveData.readDword();
	// 확대율
	local imageRate = reciveData.readDword();

	

// 2.끌어당기는 X축 힘
	local xVel = reciveData.readDword();
// 3.끌어당기는 Y축 힘
	local yVel = reciveData.readDword();

	obj.getVar("vel").clear_vector();
	obj.getVar("vel").push_vector(xVel);
	obj.getVar("vel").push_vector(yVel);
	
	local atk = sq_GetCurrentAttackInfo(obj);
	
	if (atk)
	{
		sq_SetCurrentAttackPower(atk, power);
	}
	
	obj.getVar("imagerate").clear_vector();
	obj.getVar("imagerate").push_vector(imageRate);

	// 확대율 적용
	local ani = obj.getCurrentAnimation();
	
	if (ani)
	{
		ani.setImageRateFromOriginal(imageRate.tofloat() / 100.0, imageRate.tofloat() / 100.0);
		sq_SetAttackBoundingBoxSizeRate(ani, imageRate.tofloat() / 100.0, imageRate.tofloat() / 100.0, 1.0);
	}
	//
	

	obj.getVar("consume").clear_vector();
	obj.getVar("consume").push_vector(consume);
	
	
	obj.getVar("state").clear_vector();
	obj.getVar("state").push_vector(0);
	
	obj.getVar().clear_ct_vector();
	obj.getVar().push_ct_vector();	
	
	local t = obj.getVar().get_ct_vector(0);
	t.Reset();
	t.Start(10000,0);
	
	local term = multiHitTerm;
	initGetVarTimer(obj, 2, term, -1);
	
	
	if (obj.isMyControlObject())
	{
	
		local x = obj.getXPos();
		local y = obj.getYPos();
		local z = obj.getZPos();
	
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, x);
		sq_IntVectorPush(pIntVec, y);
		sq_IntVectorPush(pIntVec, z);

		obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_0, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
}

function destroy_po_CreatorWindStorm(obj)
{
	if (!obj)
		return;
		
	local parentObj = obj.getParent();
	//appendage.sq_DeleteAppendages();
	CNSquirrelAppendage.sq_RemoveAppendage(parentObj, "Appendage/Character/ap_common_suck.nut");

}


function setState_po_CreatorWindStorm(obj, state, datas)
{

	if (!obj) return;

	local passiveState = state;
	
	obj.getVar("state").set_vector(0, passiveState);
	
	if (passiveState == PASSIVEOBJ_SUB_STATE_0)
	{
		// start
		obj.sq_PlaySound("WINDSTORM_INHALE", 7570);

	}
	else if (passiveState == PASSIVEOBJ_SUB_STATE_1)	
	{
		// loop
		local ani = obj.getCustomAnimation(0);
		obj.setCurrentAnimation(ani);

		local imageRate = obj.getVar("imagerate").get_vector(0);
		if (ani)
		{
			print(" imageRate:" + imageRate);
			ani.setImageRateFromOriginal(imageRate.tofloat() / 100.0, imageRate.tofloat() / 100.0);
			sq_SetAttackBoundingBoxSizeRate(ani, imageRate.tofloat() / 100.0, imageRate.tofloat() / 100.0, 1.0);
		}


		// 끌어들이는 어펜디지 가동		
		local parentObj = obj.getParent();
		local appendage = CNSquirrelAppendage.sq_AppendAppendage(parentObj, obj, SKILL_WINDSTORM, false, "Appendage/Character/ap_common_suck.nut", false);

		local suckVel = 200;
		local ani = obj.getCurrentAnimation();
		local radiusSize = sq_GetAniRealImageSize(ani, 0);
		radiusSize = sq_Abs(radiusSize);

		local boundBox = sq_GetAttackBoundRect(ani);
		local bosXSize = sq_GetBoundingBoxXSize(boundBox);
		local range = bosXSize;
	
		if(appendage)
		{
			//print( "range:" + range.tointeger());
			//appendage.sq_SetValidTime(20000);
			// 여기서 append 작업
			CNSquirrelAppendage.sq_Append(appendage, obj, obj);
		
			local auraAppendage = appendage.sq_getAuraMaster("winstorm");
			if(!auraAppendage)
				auraAppendage = appendage.sq_AddAuraMaster("winstorm",parentObj, obj, 1200, 18, 5, 0);
		

			local suckXVel = obj.getVar("vel").get_vector(0);
			local suckYVel = obj.getVar("vel").get_vector(1);

			print(" suckXVel:" + suckXVel + " suckYVel:" + suckYVel + " range:" + range);

			auraAppendage.setAttractionInfo(suckXVel, suckYVel, range.tointeger(), 100);
		}
		//////////////////////////////////////////////////////////

	}
	else if (passiveState == PASSIVEOBJ_SUB_STATE_2)
	{
		// end
		local ani = obj.getCustomAnimation(1);
		obj.setCurrentAnimation(ani);

		local imageRate = obj.getVar("imagerate").get_vector(0);
		if (ani)
		{
			ani.setImageRateFromOriginal(imageRate.tofloat() / 100.0, imageRate.tofloat() / 100.0);
			sq_SetAttackBoundingBoxSizeRate(ani, imageRate.tofloat() / 100.0, imageRate.tofloat() / 100.0, 1.0);
		}

	}
}



function onDestroyObject_po_CreatorWindStorm(obj, object)
{

	if (!obj) return;	
	
	obj.stopSound(7570);

	if (!obj.isValid())
		return;
}

function onKeyFrameFlag_po_CreatorWindStorm(obj, flagIndex)
{

}

function onEndCurrentAni_po_CreatorWindStorm(obj)
{
	if (!obj) return;
}
