
S_PO_ATCL_0 <- 10
S_PO_ATCL_1 <- 11

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


function setAnimationEmptyLightning(obj)
{
	if(!obj)
		return;

	local i = 0;
	local object_num = obj.getVar("cl").get_obj_vector_size();
	
	for(i = 0; i < object_num; i++)
	{ // 빔 오브젝트 애니메이션을 사라지도록 하는 애니메이션으로 모두 교체한다..
		local pObj = obj.getVar("cl").get_obj_vector(i);
		if(pObj)
		{
			local currentAni = sq_GetCurrentAnimation(pObj);
			if(currentAni)
			{
				if(currentAni.isLoop())
				{
					local ani = sq_CreateAnimation("", "PassiveObject/Character/Mage/Animation/ATChainLightning/Firing/6_lightning_dodge_empty.ani");
					
					pObj.setCurrentAnimation(ani);
				}
			}
		}
	}
}


function setAnimationDiableLightning(obj)
{
	if(!obj)
		return;
		
	local i = 0;
	local object_num = obj.getVar("cl").get_obj_vector_size();
	
	for(i = 0; i < object_num; i++)
	{ // 빔 오브젝트 애니메이션을 사라지도록 하는 애니메이션으로 모두 교체한다..
		local pObj = obj.getVar("cl").get_obj_vector(i);
		if(pObj)
		{
			pObj.setValid(false);
		}
	}
}


function setCustomData_po_ATChainLightning(obj, reciveData)
{
	if(!obj) return;
	
	print("\n create chainlightning");
	
	local firstTargetYRange = reciveData.readWord();
	local firstTargetXStartRange = reciveData.readWord();
	local firstTargetXEndRange = reciveData.readWord();
	local nextTargetRange = reciveData.readWord();
	local targetMaxHeight = reciveData.readWord();
	
	local link_sum_num = reciveData.readWord() + 1;
	local attack_time = reciveData.readWord();
	local firstAttackRate = reciveData.readDword();
	local multi_hit_num = reciveData.readWord();
	//local multi_hit_term = reciveData.readWord();

	obj.getVar("skl").clear_vector(); // 스킬파일 관련 정보 변수들
	obj.getVar("skl").push_vector(firstTargetYRange);		// 0. 처음 타겟팅시 Y축 범위 (상하 포함)
	obj.getVar("skl").push_vector(firstTargetXStartRange);  // 1.처음 타겟팅시 X축 시작 거리
	obj.getVar("skl").push_vector(firstTargetXEndRange);	// 2.처음 타겟팅시 X축 끝 거리
	obj.getVar("skl").push_vector(nextTargetRange);			// 3.체인시 다음 타겟까지의 최대 거리
	obj.getVar("skl").push_vector(targetMaxHeight);			// 4.타격할 적의 최대 높이

	obj.getVar("skl").push_vector(link_sum_num);				// 5.링크 최대 갯수 
	obj.getVar("skl").push_vector(attack_time);				// 6.지속시간
	obj.getVar("skl").push_vector(firstAttackRate);			// 7.공격력(%)
	obj.getVar("skl").push_vector(multi_hit_num);			// 8.다단히트 횟수
	//obj.getVar("skl").push_vector(multi_hit_term);			// 9.다단히트 간격


	obj.getVar("nograb").clear_vector();
	obj.getVar("nograb").push_vector(0);
	
	
	
	local link_num = link_sum_num;
	
	obj.sq_var.clear_vector();
	obj.sq_var.push_vector(link_num); // 갯수
	
	local x = obj.getXPos();
	local y = obj.getYPos();
	local z = obj.getZPos();
	
	

	

	obj.sq_var.push_vector(0); // 카운트
	obj.getVar("cl").clear_obj_vector();
	
	obj.getVar("state").clear_vector(); // state vector
	obj.getVar("state").push_vector(0);

	// 패시브오브젝트 발생 플래그	
	obj.getVar("cl").clear_vector(); 
	obj.getVar("target").clear_vector();
	
	local i = 0;
	for(i = 0; i < link_num; i++) {
		obj.getVar("cl").push_vector(0);
		obj.getVar("target").push_vector(-1); // x
		obj.getVar("target").push_vector(-1); // y
		obj.getVar("target").push_vector(-1); // z
	}
	//
	
	
	local isMyControl = obj.isMyControlObject();
	
	if(isMyControl) {
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, x);
		sq_IntVectorPush(pIntVec, y);
		sq_IntVectorPush(pIntVec, z);
		
//VI_SKL_0 <- 0 // 0. 처음 타겟팅시 Y축 범위 (상하 포함)
//VI_SKL_1 <- 1 // 1.처음 타겟팅시 X축 시작 거리
//VI_SKL_2 <- 2 // 2.처음 타겟팅시 X축 끝 거리
//VI_SKL_3 <- 3 // 3.체인시 다음 타겟까지의 최대 거리
//VI_SKL_4 <- 4 // 4.타격할 적의 최대 높이
//
//VI_SKL_5 <- 5 // 5.링크 최대 갯수 
//VI_SKL_6 <- 6 // 6.지속시간
//VI_SKL_7 <- 7 // 7.공격력(%)
//VI_SKL_8 <- 8 // 8.다단히트 횟수
//VI_SKL_9 <- 9 // 9.다단히트 간격
		
		local start_x = obj.getVar("skl").get_vector(VI_SKL_1);
		local start_end_x = obj.getVar("skl").get_vector(VI_SKL_2);
		
		local y_range = obj.getVar("skl").get_vector(VI_SKL_0);
		local z_range = obj.getVar("skl").get_vector(VI_SKL_4);
		
		local pTargetChr = obj.sq_FindFirstTarget(start_x, start_end_x, y_range, z_range);
		
		print( " pTargetChr:" + pTargetChr);
		//print( " start_x:" + start_x + " start_end_x:" + start_end_x + " y_range:" + y_range + " z_range:" + z_range);
		
		local id = sq_GetObjectId(pTargetChr);
		
		sq_IntVectorPush(pIntVec, id);
		
		if(id == -1) {		
			//print("nograb");
			obj.getVar("nograb").set_vector(0, 1);
		}
			
		obj.addSetStatePacket(S_PO_ATCL_0, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
}

function destroy_po_ATChainLightning(obj)
{
	setAnimationDiableLightning(obj);
	//setAnimationEmptyLightning(obj);
}


function setState_po_ATChainLightning(obj, state, datas)
{

	if(!obj) return;

	local passiveState = state;
	
	obj.getVar("state").set_vector(0, passiveState);
	
	print( " setstate:" + passiveState);

	if(passiveState == S_PO_ATCL_0)
	{
		//////////////////////////////////////////
		// 카운트 올리기
		local cnt = obj.sq_var.get_vector(1);
		cnt = cnt + 1;
		obj.sq_var.set_vector(1, cnt); // 카운트
		//////////////////////////////////////////
		print(" setState_po_ATChainLightning S_PO_ATCL_0:" + obj.sq_var.get_vector(1));
		
		
		if(obj.sq_var.get_vector(0) > obj.sq_var.get_vector(1)) // 빔 링크 갯수 제한
		{
		
			local x = sq_GetVectorData(datas, 0); // x pos
			local y = sq_GetVectorData(datas, 1); // y pos
			local z = sq_GetVectorData(datas, 2); // z pos	
			local id = sq_GetVectorData(datas, 3); // id
	
		
			local target_chr = sq_GetObjectByObjectId(obj, id);
			
			if(target_chr)
			{
				// 빔 리소스 로딩
				local ani = sq_CreateAnimation("", "PassiveObject/Character/Mage/Animation/ATChainLightning/Firing/6_lightning_dodge.ani");
				local lightObj = sq_CreatePooledObject(ani,true);
				
				
				lightObj.setCurrentPos(x,y + 5,z);
				lightObj.setCurrentDirection(obj.getDirection());
				obj.getVar("cl").push_obj_vector(lightObj); // 여기서 
				sq_AddObject(obj, lightObj, OBJECTTYPE_DRAWONLY, false);
				///////////////////////////////////////////////////
				
				obj.sq_var.remove_obj_vector(target_chr);
				obj.sq_var.push_obj_vector(target_chr);
				
				local pActiveTarget = sq_GetCNRDObjectToActiveObject(target_chr);
				
				procChainLightning(obj, lightObj, pActiveTarget, obj.sq_var.get_vector(1));
			}
			else
			{ // 맞는애가 없을때..
				print(" obj.sq_var.get_vector(1):" + obj.sq_var.get_vector(1));
				if(obj.sq_var.get_vector(1) == 1)
				{
					// 빔 리소스 로딩
					local ani = sq_CreateAnimation("", "PassiveObject/Character/Mage/Animation/ATChainLightning/Firing/6_lightning_dodge_empty.ani");
					local lightObj = sq_CreatePooledObject(ani,true);
					
					lightObj.setCurrentPos(x,y + 5,z);
					lightObj.setCurrentDirection(obj.getDirection());
					obj.getVar("cl").push_obj_vector(lightObj); // 여기서 
					sq_AddObject(obj, lightObj, OBJECTTYPE_DRAWONLY, false);
					///////////////////////////////////////////////////
				}
			}
		}
	}
	else if(passiveState == S_PO_ATCL_1)
	{
		local object_num = obj.getVar("cl").get_obj_vector_size();
				
		local i = 0;
		for(i = 0; i < object_num; i++)
		{ // 빔 오브젝트 애니메이션을 사라지도록 하는 애니메이션으로 모두 교체한다..
			local pObj = obj.getVar("cl").get_obj_vector(i);
			local ani = sq_CreateAnimation("", "PassiveObject/Character/Mage/Animation/ATChainLightning/Firing/6_lightning_dodge_empty.ani");
			
			pObj.setCurrentAnimation(ani);
		}
		
		for(i = 0; i < object_num; i++)
		{	
			local target_obj_num = obj.sq_var.get_obj_vector_size();
			local pObj = obj.getVar("cl").get_obj_vector(i);
			
			if(target_obj_num > i)
			{
				local pTargetObj = obj.sq_var.get_obj_vector(i);
				local pActiveTarget = sq_GetCNRDObjectToActiveObject(pTargetObj);
				
				local target_x = sq_GetXPos(pActiveTarget);
				local target_y = sq_GetYPos(pActiveTarget) + 5;
				local target_z = sq_GetZPos(pActiveTarget) + (sq_GetObjectHeight(pActiveTarget) / 2);		
			
				if((i + 1) < object_num)
				{
					local next_obj = obj.getVar("cl").get_obj_vector(i + 1);
					sq_SetCurrentPos(next_obj, target_x, target_y, target_z);
				}
				
				procChainLightning(obj, pObj, pActiveTarget, i);
			}
			else
			{
				procChainLightning(obj, pObj, null, i);
			}
		}		
	}

}


// 체인라이트닝 한조각 처리
function procChainLightning(thisObj, obj, pTargetChr, targetIndex)
{
	if(!obj) return;
	//if(!pTargetChr) return;

	local X = obj.getXPos();
	local Y = obj.getYPos();
	local Z = obj.getZPos();
	
	
	local pAni = obj.getCurrentAnimation();
	local frameIndex = pAni.GetCurrentFrameIndex();

	local targetI = targetIndex * 3;
	
	local posX = thisObj.getVar("target").get_vector(targetI);
	local posY = thisObj.getVar("target").get_vector(targetI + 1);
	local posZ = thisObj.getVar("target").get_vector(targetI + 2);
	
	if(pTargetChr)
	{
		posX = pTargetChr.getXPos();
		posY = pTargetChr.getYPos();
		posZ = pTargetChr.getZPos() + (sq_GetObjectHeight(pTargetChr) / 2);
	
		thisObj.getVar("target").set_vector(targetI, posX);
		thisObj.getVar("target").set_vector(targetI + 1, posY);
		thisObj.getVar("target").set_vector(targetI + 2, posZ);
	}
	
	if(posX == -1)
		return;
	
	local offset = posX - X;
	
	if(offset < 0) {
		//print(" ENUM_DIRECTION_LEFT");
		obj.setCurrentDirection(ENUM_DIRECTION_LEFT);
	}
	else {
		//print(" ENUM_DIRECTION_RIGHT");
		obj.setCurrentDirection(ENUM_DIRECTION_RIGHT);
	}
	
	
	local distance = sq_GetDistance( X, Y - Z, posX, posY - posZ, true);
	
	local w = posX - X;		
	if(w < 0) w = -w;
	//	화면상의 각도를 구해서 이펙트를 몇도나 돌려야 되는지 구한다.
	
	local h = (posY - posZ) - (Y - Z);
	local width = sq_Abs(posX - X);
	local angle = sq_Atan2( h.tofloat(), width.tofloat());

	if((posY - posZ) > (Y - Z)) {
		angle = -angle;
	}

	local nRevision = distance;

	local cos = nRevision.tofloat() * sq_Cos(angle);
	local sin = nRevision.tofloat() * sq_Sin(angle);

	local nX = sq_Abs( cos.tointeger() );
	local nY = sq_Abs( sin.tointeger() );

	sq_SetfRotateAngle(pAni, angle);		

	pAni.setImageRate(1.0, 1.0);
	

	local dis = 246;
	

	local cos_x = dis.tofloat() * sq_Cos(angle);
	local sin_y = dis.tofloat() * sq_Sin(angle);

	//print("angle:" + angle);
	 
	local nW = sq_Abs( cos_x.tointeger() );
	local nH = sq_Abs( sin_y.tointeger() );

	//print(" nW:" + nX + "nH:" + nY);

	local wRate = width.tofloat() / nW.tofloat();
	local hRate = h.tofloat() / nH.tofloat();
	
	//
	pAni.setImageRate(wRate.tofloat(), hRate.tofloat());
}



function procAppend_po_ATChainLightning(obj)
{
	if(!obj)
		return;
	
	local pChr = obj.getTopCharacter();
	
	local state = obj.getVar("state").get_vector(0);
	
	if(!pChr)
	{
		//sq_SendDestroyPacketPassiveObject(obj);
		if(state == S_PO_ATCL_0)
		{
			if(obj.isMyControlObject())
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
			if(obj.isMyControlObject())
				sq_SendDestroyPacketPassiveObject(obj);
			
			return;
		}
	}
	
	

		local lightNum = obj.getVar("cl").get_obj_vector_size();
		//print(" chain:" + lightNum);
	if(pChr.getState() != STATE_CHAINLIGHTNING)
	{
		//sq_SendDestroyPacketPassiveObject(obj);
		if(state == S_PO_ATCL_0)
		{
			if(obj.isMyControlObject())
			{
				local pIntVec = sq_GetGlobalIntVector();

				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);

				//print(" setstaet:" + S_PO_ATCL_1);
				obj.addSetStatePacket(S_PO_ATCL_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
			}
			return;
		}
		else if(state == S_PO_ATCL_1)
		{
			local clNum = obj.getVar("cl").get_obj_vector_size();
			print(" state == S_PO_ATCL_1");
			print(" clNum:" + clNum);
			if(clNum == 0)
			{
				if(obj.isMyControlObject())
				{
					sq_SendDestroyPacketPassiveObject(obj);
					return;
				}
			}
			else
			{
				setAnimationEmptyLightning(obj);
			}
		}
	}	
	

	local i = 0;
	local object_num = obj.getVar("cl").get_obj_vector_size(); // 빔 오브젝트

	for(i = 0; i < object_num; i++)
	{	
		local pObj = obj.getVar("cl").get_obj_vector(i);
		
		local target_obj_num = obj.sq_var.get_obj_vector_size();
		
		if(target_obj_num > i)
		{
			local pTargetObj = obj.sq_var.get_obj_vector(i);
			local pActiveTarget = sq_GetCNRDObjectToActiveObject(pTargetObj);
			
			local target_x = sq_GetXPos(pActiveTarget);
			local target_y = sq_GetYPos(pActiveTarget) + 5;
			local target_z = sq_GetZPos(pActiveTarget) + (sq_GetObjectHeight(pActiveTarget) / 2);
		
			if((i + 1) < object_num) {
				local next_obj = obj.getVar("cl").get_obj_vector(i + 1);
				sq_SetCurrentPos(next_obj, target_x, target_y, target_z);
			}

			local pAni = pObj.getCurrentAnimation();

			if(state == S_PO_ATCL_0) {
			
				procChainLightning(obj, pObj, pActiveTarget, i);
				if(pAni.GetCurrentFrameIndex() >= 2)
				{ // 현재 빔 오브젝트의 프레임인덱스가 2프레임을 넘어간다면..
					if(obj.getVar("cl").get_vector(i) == 0)
					{ // 현재 빔 타겟팅이 다음으로 링크되지 않았다면..
					
						if(obj.isMyControlObject())
						{
							local id = sq_GetObjectId(pTargetObj);
							if(id != -1) {
//VI_SKL_6 <- 6 // 6.지속시간
//VI_SKL_7 <- 7 // 7.공격력(%)
//VI_SKL_8 <- 8 // 8.다단히트 횟수
//VI_SKL_9 <- 9 // 9.다단히트 간격
								local attack_time = obj.getVar("skl").get_vector(VI_SKL_6);
								local attack_rate = obj.getVar("skl").get_vector(VI_SKL_7);
								local multi_hit_num = obj.getVar("skl").get_vector(VI_SKL_8);
								//local multi_hit_term = obj.getVar("skl").get_vector(VI_SKL_9);
								
								sq_BinaryStartWrite();
								sq_BinaryWriteDword(id);
								sq_BinaryWriteDword(attack_time);
								sq_BinaryWriteDword(attack_rate);
								sq_BinaryWriteDword(multi_hit_num);
								//sq_BinaryWriteDword(multi_hit_term);
								
								sq_SendCreatePassiveObjectPacketFromPassivePos( obj, 24242, 0, target_x, target_y - 1, target_z);
							}

							local pIntVec = sq_GetGlobalIntVector();

							sq_IntVectorClear(pIntVec);
							sq_IntVectorPush(pIntVec, target_x);
							sq_IntVectorPush(pIntVec, target_y + 1);
							sq_IntVectorPush(pIntVec, target_z);					

							//VI_SKL_0 <- 0 // 0. 처음 타겟팅시 Y축 범위 (상하 포함)
							//VI_SKL_1 <- 1 // 1.처음 타겟팅시 X축 시작 거리
							//VI_SKL_2 <- 2 // 2.처음 타겟팅시 X축 끝 거리
							//VI_SKL_3 <- 3 // 3.체인시 다음 타겟까지의 최대 거리
							//VI_SKL_4 <- 4 // 4.타격할 적의 최대 높이
							local next_x_range = obj.getVar("skl").get_vector(VI_SKL_3);
							local z_range = obj.getVar("skl").get_vector(VI_SKL_4);

							local pTargetChr = obj.sq_FindNextTarget(pActiveTarget, next_x_range, z_range);

							local id = sq_GetObjectId(pTargetChr);					
							sq_IntVectorPush(pIntVec, id);

							obj.addSetStatePacket(S_PO_ATCL_0, pIntVec, STATE_PRIORITY_AUTO, false, "");
						}

						obj.getVar("cl").set_vector(i, 1); // 
						return;
					}
				}
			}
			else if(state == S_PO_ATCL_1) {
				procChainLightning(obj, pObj, pActiveTarget, i);
			}
		}
		else
		{
			if(state == S_PO_ATCL_1)
			{
				//print(" procChainLightning(obj, pObj, pActiveTarget, i):" + pObj);
				procChainLightning(obj, pObj, null, i);
			}		
		}
	}
	
	
	local substate = pChr.getSkillSubState();
	
	if(substate == SUB_STATE_ATCHAINLIGHTNING_2) {
		if(state == S_PO_ATCL_0)
		{
			if(obj.isMyControlObject())
			{
				local pIntVec = sq_GetGlobalIntVector();

				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);

				print(" ln546 setstate");
				obj.addSetStatePacket(S_PO_ATCL_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
			}
			return;
		}
	}
	
	
	if(object_num <= 0)
	{
		if(obj.sq_var.get_vector(1) > 0)
		{
			if(obj.getVar("cl").get_obj_vector_size() == 0)
			{
				if(obj.isMyControlObject())
				{
					sq_SendDestroyPacketPassiveObject(obj);
				}
			}
		}
	}
}

function onChangeSkillEffect_po_ATChainLightning(obj, skillIndex, data, dataSize)
{

	if(!obj) return;

}

function getDestroyObjectByCIObjectIndex(obj, diedObject)
{ // 사라지는 오브젝트로 사라져야하는 빔오브젝트를 리턴합니다.

	if(!diedObject || !obj)
		return null;
	
	local objectNum = obj.sq_var.get_obj_vector_size();
	
	local index = obj.sq_var.get_obj_vector_index(diedObject);
	
	return index;
}

function setDiableAnimationCIObject(obj, index)
{ // 사라져야할 필요가 있는 빔 오브젝트를 사라지도록 세팅합니다.
	if(!obj)
		return;
		
	//local ani = sq_CreateAnimation("", "PassiveObject/Character/Mage/Animation/ATChainLightning/Firing/6_lightning_dodge_empty.ani");
	
	local destroyIndex = index + 1;
	
	if(destroyIndex >= obj.getVar("cl").get_obj_vector_size())
		destroyIndex = index;
	
	local clObject = obj.getVar("cl").get_obj_vector(destroyIndex);
	
	//print( " setDiableAnimationCIObject:" + (destroyIndex);
	
	if(clObject)
	{
		if(destroyIndex < obj.getVar("cl").get_obj_vector_size())
		{ // 패시브오브젝트 파이어 플래그를 인덱스동기화 하기위해..좀 맘에 안드는 동기화 방법 정수벡터는 erase하기엔 너무 짜증난다..
			for (local i = destroyIndex;i < obj.getVar("cl").size_vector(); i+=1)
			{
				if( (i + 1) < obj.getVar("cl").size_vector())
				{
					local flagValue = obj.getVar("cl").get_vector(i + 1);
					obj.getVar("cl").set_vector(i, flagValue);
				}
			}
		}
		
		obj.getVar("cl").remove_obj_vector(clObject); // 빔

		clObject.setValid(false);
	}
		//clObject.setCurrentAnimation(ani);	
}


function onDestroyObject_po_ATChainLightning(obj, object)
{

	if(!obj) return;	
	
	if(!obj.isValid())
		return;

	local state = obj.getVar("state").get_vector(0);
	
	if(state != S_PO_ATCL_1 && state != S_PO_ATCL_0)
	{
		return;
	}
	
	if(obj.getVar("cl").get_obj_vector_size() == 0)
	{ // 
		//print(" nograb on");
		obj.getVar("nograb").set_vector(0, 1);
	}
	
	local index = getDestroyObjectByCIObjectIndex(obj, object);
	
	if(index != -1)
	{
		setDiableAnimationCIObject(obj, index);
	}
	
	obj.sq_var.remove_obj_vector(object); // 맞고있는 몹
	
	
	//sq_SendDestroyPacketPassiveObject(obj);

	obj.getVar("cl").remove_obj_vector(object); // 빔

	
	//print(" ondestroy");
	
	if(obj.isMyControlObject())
	{
		
		if(state == S_PO_ATCL_0)
		{
			if(!obj.sq_var.get_obj_vector_size())
			{
				local pIntVec = sq_GetGlobalIntVector();

				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);

				print(" ln671 setstate");
				obj.addSetStatePacket(S_PO_ATCL_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
			}
		}
		//print(" obj.addSetStatePacket(S_PO_ATCL_1 ");
	}
	
	
	//obj.setValid(false);
	

}

function onKeyFrameFlag_po_ATChainLightning(obj, flagIndex)
{

}

function onEndCurrentAni_po_ATChainLightning(obj)
{
	if(!obj) return;
	
	//print("onEndCurrentAni_po_ATChainLightning");
	
	//if(obj.isMyControlObject()) {
		//sq_SendDestroyPacketPassiveObject(obj);
	//}
	
}
