
function createIceSmallRing(obj, dx, dy, dz)
{
	if(!obj)
		return;
		
	local x = sq_GetXPos(obj) + dx;
	local y = sq_GetYPos(obj) + dy;
	local z = sq_GetZPos(obj) + dz;
	local ani = 0;
	
	ani = sq_CreateAnimation("", "PassiveObject/Character/Mage/Animation/ATIceChakram/cast/04_schakra_normal.ani");
	
	local ring_obj = sq_CreatePooledObject(ani,false);
	
	ring_obj.setCurrentPos(x,y,z);
	obj.getVar().push_obj_vector(ring_obj); // 여기서 
	sq_AddObject(obj, ring_obj, OBJECTTYPE_DRAWONLY, false);
}

function procSmallRing(obj, currentT)
{
	local object_num = obj.getVar().get_obj_vector_size();
	
	local i = 0;
	local startLen = 140;
	local endLen = 210;
	
	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);

	local size = 5;

	local sr_angle_l = [];
	
	sr_angle_l.resize(size);
	
	sr_angle_l[0] = 90;
	sr_angle_l[1] = 60;
	sr_angle_l[2] = 120;
	sr_angle_l[3] = 70;
	sr_angle_l[4] = 110;
	
	local sr_len_l =[];
	sr_len_l.resize(size);
	
	sr_len_l[0] = 180;
	sr_len_l[1] = 160;
	sr_len_l[2] = 140;
	sr_len_l[3] = 245;
	sr_len_l[4] = 240;
	

	
	for(i = 0; i < object_num; i++)
	{ // 빔 오브젝트 애니메이션을 사라지도록 하는 애니메이션으로 모두 교체한다..
		local ringObj = obj.getVar().get_obj_vector(i);
		
		if(ringObj)
		{
			local angle = sr_angle_l[i%5];
			
		
			local len = sq_GetUniformVelocity(startLen, sr_len_l[i%5] + ((i/5)*10), currentT, 80);
			
			local upMovLen = len * sq_SinTable(angle.tointeger());	
			local lenMovLen = len * sq_CosTable(angle.tointeger());	
			
			
			sq_setCurrentAxisPos(ringObj, 0, x + lenMovLen.tointeger());
			//sq_setCurrentAxisPos(ringObj, 1, y + 1);
			//print( " angle:" + angle + " index:" + i + " lenMovLen:" + lenMovLen);
			sq_setCurrentAxisPos(ringObj, 2, upMovLen.tointeger());
			
		}
	}
	
}

function procFireSmallRing(obj, currentT, maxT)
{
	local object_num = obj.getVar().get_obj_vector_size();
	
	local i = 0;
	local startLen = 180;
	local endLen = 210;
	
	
	for(i = 0; i < object_num; i++)
	{ // 빔 오브젝트 애니메이션을 사라지도록 하는 애니메이션으로 모두 교체한다..
		local ringObj = obj.getVar().get_obj_vector(i);
		
		if(ringObj)
		{
			if(currentT > maxT)
			{
				if(obj.isMyControlObject())
				{
					local x_range = 600; //
					local y_range = 300; //
					local z_range = 100; //
				
					local pChr = obj.getTopCharacter();
					
					local targetObj = getPriorityTarget(pChr, -40, x_range, y_range, z_range, obj.getVar("target"), false);
					
					if(targetObj)
					{
						print( " find Target");
						obj.getVar("target").push_obj_vector(targetObj);
						obj.getVar("target").set_vector(0, 1);
					}
					else
					{ // 아무것도 타겟을 못찾았다면.. 원래 찾았던 타겟이 있는지 체크해보고 있다면 그것을 넣습니다.
						local backTarget = obj.getVar("target").get_obj_vector(0);
						print( " none find Target:" + backTarget);
						
						if(backTarget)
						{
							obj.getVar("target").push_obj_vector(backTarget);
							obj.getVar("target").set_vector(0, 1);
							
							targetObj = backTarget;
						}
					}
					
					local id = sq_GetObjectId(targetObj);
					

					//obj.getVar("chakram").clear_vector();
					//obj.getVar("chakram").push_vector(createSmallRingNum);
					//obj.getVar("chakram").push_vector(multiHitNum);
					
					//local power = reciveData.readDword(); // 0.작은 얼음고리 다단히트 공격력(+)
					
					local multiHitNum = obj.getVar("chakram").get_vector(1); // 1. 작은 얼음 고리 다단히트 횟수
					local power = obj.getVar("chakram").get_vector(2); // power

					
					local x = sq_GetXPos(ringObj);
					local y = sq_GetYPos(ringObj);
					local z = sq_GetZPos(ringObj);
					
					sq_BinaryStartWrite();
					sq_BinaryWriteDword(id);
					sq_BinaryWriteDword(multiHitNum);
					sq_BinaryWriteDword(power);
					//local moveMode = sq_getRandom(0, 2);
					local moveMode = 0;
					sq_BinaryWriteDword(moveMode);		
					sq_SendCreatePassiveObjectPacketPos(pChr, 24258, 0, x, y, z);
				}
				
				ringObj.setValid(false);
				obj.getVar().remove_obj_vector(ringObj);
				
				return true;
			}
			return false;
		}
	}
	
	return false;
	
}



function pushSmallRingFireTarget(obj, firstTargetXStartRange, firstTargetXEndRange, firstTargetYRange, targetMaxHeight, pushMaxNum)
{
	if(!obj)
		return null;
		
	local objectManager = obj.getObjectManager();
	

	if (objectManager == null)
		return null;

	obj.getVar("target").clear_obj_vector();

	local i;
	
	for(i = 0; i < pushMaxNum; i++)
	{ // 
		local targetObj = getPriorityTarget(obj, firstTargetXStartRange, firstTargetXEndRange, firstTargetYRange, targetMaxHeight, obj.getVar("target"));
		
		obj.getVar("target").push_obj_vector(targetObj);
	}
}



function setCustomData_po_ATIceChakramSmallMgr(obj, reciveData)
{
	if(!obj) return;
	
	//sq_BinaryWriteDword(createSmallRingNum); // 
	//sq_BinaryWriteDword(multiHitNum); // 
	//sq_BinaryWriteDword(power); // 
	
	local createSmallRingNum = reciveData.readDword(); // 0. 생성되는 얼음고리 갯수
	local multiHitNum = reciveData.readDword(); // 1. 작은 얼음 고리 다단히트 횟수		
	local power = reciveData.readDword(); // 0.작은 얼음고리 다단히트 공격력(+)
	
	obj.getVar("state").clear_vector(); // state vector
	obj.getVar("state").push_vector(0);
	
	obj.getVar("flag").clear_timer_vector();
	obj.getVar("flag").push_timer_vector();
	
	obj.getVar("flag").clear_vector();

	obj.getVar("chakram").clear_vector();
	obj.getVar("chakram").push_vector(createSmallRingNum);
	obj.getVar("chakram").push_vector(multiHitNum);
	obj.getVar("chakram").push_vector(power);

	local i;
	
	for(i = 0; i < createSmallRingNum; i++)
	{ // 
		obj.getVar("flag").push_vector(0);
	}

	
	local object_num = obj.getVar("cl").get_obj_vector_size();
	
	
	
	obj.getVar().clear_ct_vector();
	obj.getVar().push_ct_vector();	
	
	local t = obj.getVar().get_ct_vector(0);
	t.Reset();
	t.Start(10000,0);
	
	obj.getVar().clear_obj_vector();

	local t = obj.getVar("flag").get_timer_vector(0);
	t.setParameter(50, 1);
	t.resetInstant(0);
	
	obj.getVar("attack").clear_vector();
	
	obj.getVar().clear_vector();
	obj.getVar().push_vector(90);
	obj.getVar().push_vector(45);
	obj.getVar().push_vector(135);
	obj.getVar().push_vector(35);
	obj.getVar().push_vector(155);

	local atk = sq_GetCurrentAttackInfo(obj);
	
	if(atk)
	{
		sq_SetCurrentAttackPower(atk, power);
	}

	
	if(obj.isMyControlObject())
	{
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
		
		obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_0, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
}

function destroy_po_ATIceChakramSmallMgr(obj)
{
	destroyObject(obj);
}


function setState_po_ATIceChakramSmallMgr(obj, state, datas)
{
	if(!obj) return;
	
	local passiveState = state;
	
	obj.getVar("state").set_vector(0, passiveState);
	
	obj.getVar("flag").set_vector(VECTOR_FLAG_0, 0);

	initGetVarTimer(obj, 1, 400, 10);
	obj.getVar("target").clear_obj_vector();
	
	if(passiveState == PASSIVEOBJ_SUB_STATE_0)
	{
		obj.getVar("target").clear_vector();
		obj.getVar("target").push_vector(0);
		
		local x = sq_GetXPos(obj);
		local y = sq_GetYPos(obj);
		local z = sq_GetZPos(obj);
		
		
		//obj.getVar("chakram").push_vector(multiHitNum);

		local smallRingNum = obj.getVar("chakram").get_vector(0); // 0 createSmallRingNum
		
		local i;
		for(i = 0; i < smallRingNum; i++)
		{		
			createIceSmallRing(obj, 0, 1, 210);
		}
		
		local t = obj.getVar().get_ct_vector(0);
		t.Reset();
		t.Start(10000,0);		
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
	}
	

}

function procAppend_po_ATIceChakramSmallMgr(obj)
{

	if(!obj) return;
	
	local pChr = obj.getTopCharacter();
	
	if(!pChr)
	{
		if(obj.isMyControlObject())
		{
			sq_SendDestroyPacketPassiveObject(obj);
		}
		return;
	}
	
	local chr_state = pChr.getState();
	
	if(chr_state != STATE_ICECHAKRAM)
	{
		if(obj.isMyControlObject())
		{
			sq_SendDestroyPacketPassiveObject(obj);
		}
		return;
	}
	
	local objX = sq_GetXPos(obj);
	local objY = sq_GetYPos(obj);
	local objZ = sq_GetZPos(obj);
	
	local state = obj.getVar("state").get_vector(0);
	local passiveState = state;
	
	if(passiveState == 0)
		return;
	
	local t = obj.getVar().get_ct_vector(0);
	local currentT = 0;
	
	currentT = t.Get();
		
	if(passiveState == PASSIVEOBJ_SUB_STATE_0)
	{
		local parentState = obj.sq_GetParentState();
		local subState = obj.sq_GetParentSkillSubState();
	
		procSmallRing(obj, currentT);
		
		if(parentState == STATE_ICECHAKRAM && subState == SUB_STATE_ICECHAKRAM_2)
		{
			if(obj.isMyControlObject())
			{
				local frmIndex = sq_GetCurrentFrameIndex(pChr);
				if(frmIndex > 1)
				{
					local pIntVec = sq_GetGlobalIntVector();
					
					sq_IntVectorClear(pIntVec);
					sq_IntVectorPush(pIntVec, 0);
					
					obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
				}
			}
		}
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_1)	
	{
		local result = procFireSmallRing(obj, currentT, 100);

		if(result == true)
		{		
			t.Reset();
			t.Start(10000,0);
		}
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_2)	
	{
	}

}

function onChangeSkillEffect_po_ATIceChakramSmallMgr(obj, skillIndex, reciveData)
{
	if(!obj) return;

}

function onDestroyObject_po_ATIceChakramSmallMgr(obj, object)
{

	if(!obj) return;

}

function onKeyFrameFlag_po_ATIceChakramSmallMgr(obj, flagIndex)
{

}

function onEndCurrentAni_po_ATIceChakramSmallMgr(obj)
{

	if(!obj) return;

}
