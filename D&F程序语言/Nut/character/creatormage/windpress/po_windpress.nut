
S_PO_ATCL_0 <- 10
S_PO_ATCL_1 <- 11
S_PO_ATCL_2 <- 12

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



function sendChangeRotateObject(obj)
{
	if (!obj)
		return;

	if (!obj.isMyControlObject())
		return;

	local chr = obj.getTopCharacter();
	
	if (!chr)
		return;

	local objectManager = obj.getObjectManager();
	
	if (!objectManager)
		return;

	local stage = sq_GetObjectManagerStage(obj);
	local control = stage.getMainControl();
	
	local zPos = obj.getZPos();
	local xPos = objectManager.getFieldXPos(IMouse.GetXPos(), ENUM_DRAWLAYER_NORMAL);
	local yPos = objectManager.getFieldYPos(IMouse.GetYPos(), zPos, ENUM_DRAWLAYER_NORMAL);
	
	// 바라보는 위치에 따라서 앞으로만 향하도록 합니다.	
	local offset = xPos - obj.getXPos();
	local len = sq_Abs(offset);
	local direction = sq_GetDirection(chr);
	
	if (direction == ENUM_DIRECTION_LEFT)
	{	
		xPos = obj.getXPos() - len;
	}
	else 
	{
		xPos = obj.getXPos() + len;
	}
	
	sq_BinaryStartWrite();
	sq_BinaryWriteDword(xPos);
	sq_BinaryWriteDword(yPos);
	sq_BinaryWriteDword(zPos);
	
	sq_SendChangeSkillEffectPacket(obj, SKILL_WINDPRESS);

}


function setCustomData_po_CreatorWindPress(obj, reciveData)
{
	if (!obj) return;
	
	// 다단히트 간격
	local multiHitTerm = reciveData.readDword();
	// 타격거리
	local hitLen = reciveData.readDword();
	// 소모량
	local consume = reciveData.readDword();
	// 타격각도
	local rangeDir = reciveData.readDword();
	// 공격력
	local power = reciveData.readDword();
	
	obj.getVar("rangeDir").clear_vector();
	obj.getVar("rangeDir").push_vector(rangeDir);

	obj.getVar("targetLen").clear_vector();
	obj.getVar("targetLen").push_vector(hitLen);
	
	obj.getVar("consume").clear_vector();
	obj.getVar("consume").push_vector(consume);
	
	obj.getVar("state").clear_vector();
	obj.getVar("state").push_vector(0);
	
	
	local atk = sq_GetCurrentAttackInfo(obj);
	
	if (atk)
	{
		sq_SetCurrentAttackPower(atk, power);
	}
	
	
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

		obj.addSetStatePacket(S_PO_ATCL_0, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
	
	obj.getVar().clear_ct_vector();
	obj.getVar().push_ct_vector();	
	
	local t = obj.getVar().get_ct_vector(0);
	t.Reset();
	t.Start(10000,0);
	
	local term = multiHitTerm;
	initGetVarTimer(obj, 2, term, -1);
	
	sendChangeRotateObject(obj);
}



function procRotateObjAnimation(obj, posX, posY, posZ)
{
	if (!obj) return;
	//if (!pTargetChr) return;

	local X = obj.getXPos();
	local Y = obj.getYPos();
	local Z = obj.getZPos();
	
	
	local pAni = obj.getCurrentAnimation();
	
	if (!pAni)
		return;
	
	if (posX == -1)
		return;
	
	local offset = posX - X;
	if (offset < 0)
	{
		obj.setCurrentDirection(ENUM_DIRECTION_LEFT);
	}
	else
	{
		obj.setCurrentDirection(ENUM_DIRECTION_RIGHT);
	}
	
	local distance = sq_GetDistance( X, Y - Z, posX, posY - posZ, true);	
	
	local w = posX - X;
	local h = (posY - posZ) - (Y - Z);
	
	// 실제각도를 구해본다.
	//local tan = sq_Atan2( h.tofloat(), w.tofloat());	
	
	
	
	
	if (w < 0) w = -w;
	//	화면상의 각도를 구해서 이펙트를 몇도나 돌려야 되는지 구한다.	
	local width = sq_Abs(posX - X);	
	local angle = sq_Atan2( h.tofloat(), width.tofloat());	
	
	local angleDir = sq_ToDegree(angle);
	//print( " angleDir:" + angleDir);
	
	// 범위 설정
	local rangeDir = obj.getVar("rangeDir").get_vector(0);
	
	local r = rangeDir / 2;
	local d = sq_Abs(angleDir.tointeger());
	
	if (angleDir < 0)
	{
		// 한계각도를 넘어간다면..
		if (d > r) 
			angleDir = -r;
	}
	else
	{
		if (d > r) 
			angleDir = r;
	}
	
	//print( " rangeDir:" + angleDir);
	
	angle = sq_ToRadian(angleDir.tofloat());
	//
	local orgAngle = angle;
	angle = -angle;
	
	local nRevision = distance;	
	
	// 공격렉트 등록 촘촘하게 등록한다..
	sq_ClearAttackBox(pAni);	
	//
	local dis = 580;
	//local realSize = 600;
	local targetLen = obj.getVar("targetLen").get_vector(0);
	local realSize = targetLen; // 
	local partNum = 10;
	
	local partLen = realSize.tofloat() / partNum.tofloat();
	local revision = 30;
	
	for (local i = 0; i < partNum; i++)
	{	
		local attackL = 100;	
		local zAttackL = 60;
		
		local attackPosX = revision.tofloat() * sq_Cos(orgAngle);
		local attackPosY = revision.tofloat() * sq_Sin(orgAngle);

		sq_AddAttackBox(pAni, 
		attackPosX.tointeger() - (attackL / 2), 
		attackPosY.tointeger(), 
		-zAttackL, 
		attackL, attackL, (zAttackL * 2) );
		
		revision = revision + partLen.tointeger();
	}
	
	
	//
	sq_SetfRotateAngle(pAni, angle);


	local cos_x = dis.tofloat() * sq_Cos(angle);
	local sin_y = dis.tofloat() * sq_Sin(angle);

	//print("angle:" + angle);
	 
	local nW = sq_Abs( cos_x.tointeger() );
	local nH = sq_Abs( sin_y.tointeger() );

	local wRate = 1.0;
	local hRate = 1.0;



	if (nW != 0.0 && realSize != 0.0)
	{
		wRate = realSize.tofloat() / nW.tofloat();
	}

	//if (nW != 0.0 && width != 0.0)
	//{
	//	wRate = width.tofloat() / nW.tofloat();
	//}
	//if (h != 0.0 && nH != 0.0)
	//{
		//hRate = h.tofloat() / nH.tofloat();
	//}
	
	//print(" wRate:" + wRate + " hRate:" + hRate + " nH:" + nH + " h:" + h + " angle:" + angle);
	
	pAni.setImageRateFromOriginal(wRate.tofloat(), hRate.tofloat());
}



function procAppend_po_CreatorWindPress(obj)
{
	if (!obj)
		return;
		
	
	local pChr = obj.getTopCharacter();
	
	local state = obj.getVar("state").get_vector(0);
	
	if (!pChr)
	{
		if (state == S_PO_ATCL_0)
		{
			if (obj.isMyControlObject())
			{
				local pIntVec = sq_GetGlobalIntVector();

				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);
				obj.addSetStatePacket(S_PO_ATCL_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
			}
			return;
		}
		else
		{
			if (obj.isMyControlObject())
				sq_SendDestroyPacketPassiveObject(obj);
			
			return;
		}
	}
	
	

	if (pChr.getState() != STATE_WINDPRESS)
	{
	
		if (state == S_PO_ATCL_0)
		{
			if (obj.isMyControlObject())
			{
				local pIntVec = sq_GetGlobalIntVector();

				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);

				obj.addSetStatePacket(S_PO_ATCL_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
			}
			return;
		}
		else if (state == S_PO_ATCL_1)
		{
			if (obj.isMyControlObject())
			{
				sq_SendDestroyPacketPassiveObject(obj);
				return;
			}
		}
	}

	sendChangeRotateObject(obj);
	
	
	if (state == S_PO_ATCL_0)	
	{
		// 스타트 애니메이션
		if (obj.isMyControlObject())
		{
			local ani = obj.getCurrentAnimation();	
			
			local isEnd = sq_IsEnd(ani);
			
			if (isEnd)
			{
				local pIntVec = sq_GetGlobalIntVector();

				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);

				obj.addSetStatePacket(S_PO_ATCL_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
			}
		}
	}
	else if (state == S_PO_ATCL_1)
	{
		// 루핑 애니메이션
		local t = obj.getVar().get_ct_vector(0);
		local currentT = 0;
		
		currentT = t.Get();
	
		local hitT = obj.getVar().get_timer_vector(0);
	
		if(hitT)
		{		
			if(hitT.isOnEvent(currentT) == true)
			{			
				local consumeValue = obj.getVar("consume").get_vector(0);
				useCreatorSkill(pChr, SKILL_WINDPRESS, 0, 0, consumeValue);
				
				obj.resetHitObjectList();
			}
		}	
		
		// 각도 잡기
		if (obj.isMyControlObject())
		{
			local objectManager = obj.getObjectManager();
			
			if (!objectManager)
				return;

			local stage = sq_GetObjectManagerStage(obj);
			local control = stage.getMainControl();
			
			local remainRate = getCreatorTypeGaugeRate(pChr);
			
			if (!control.IsLBDown() || remainRate == 0.0)
			{
				local pIntVec = sq_GetGlobalIntVector();

				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);

				obj.addSetStatePacket(S_PO_ATCL_2, pIntVec, STATE_PRIORITY_AUTO, false, "");
				//sq_SendDestroyPacketPassiveObject(obj);
			}
		}
	}
	else if (state == S_PO_ATCL_2)	
	{
		if (obj.isMyControlObject())
		{
			local ani = obj.getCurrentAnimation();	
			
			local isEnd = sq_IsEnd(ani);
			
			if (isEnd)
			{
				sq_SendDestroyPacketPassiveObject(obj);
			}
		}
	}
	
}



function destroy_po_CreatorWindPress(obj)
{
}


function setState_po_CreatorWindPress(obj, state, datas)
{

	if (!obj) return;

	local passiveState = state;
	
	obj.getVar("state").set_vector(0, passiveState);
	
	sendChangeRotateObject(obj);

	if (passiveState == S_PO_ATCL_0)
	{
	}
	else if (passiveState == S_PO_ATCL_1)	
	{
		local ani = obj.getCustomAnimation(0);
		obj.setCurrentAnimation(ani);
	}
	else if (passiveState == S_PO_ATCL_2)
	{
		local ani = obj.getCustomAnimation(1);
		obj.setCurrentAnimation(ani);
	}
}



function onChangeSkillEffect_po_CreatorWindPress(obj, skillIndex, reciveData)
{
	if (!obj) return;
	
	if (skillIndex != SKILL_WINDPRESS)
		return;

	local dstX = reciveData.readDword();
	local dstY = reciveData.readDword();
	local dstZ = reciveData.readDword();

	procRotateObjAnimation(obj, dstX, dstY, dstZ);

}


function onDestroyObject_po_CreatorWindPress(obj, object)
{

	if (!obj) return;	
	
	if (!obj.isValid())
		return;
}

function onKeyFrameFlag_po_CreatorWindPress(obj, flagIndex)
{

}

function onEndCurrentAni_po_CreatorWindPress(obj)
{
	if (!obj) return;
}
