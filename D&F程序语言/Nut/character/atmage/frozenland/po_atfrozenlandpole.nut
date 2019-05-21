
S_PO_FROZENLAND_POLE_0 <- 10
S_PO_FROZENLAND_POLE_1 <- 11
S_PO_FROZENLAND_POLE_2 <- 12
S_PO_FROZENLAND_POLE_3 <- 13



function procCreateShockWaveAnimation(obj, currentT)
{
	if(!obj)
		return;
		
	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);
	
	local t = obj.getVar("state").get_timer_vector(0);

	if (t.getEventTerm() == -1) {
		print(" return:" + t.getEventTerm());
		return;
	}

	if (t.isOnEvent(currentT) == true)
	{
		createShockWaveAnimation(obj, x, y, z);
	}

}



function setCustomData_po_ATFrozenLandPole(obj, reciveData)
{

	if(!obj) return;
	
	local angle = reciveData.readDword() * 100;
	local flip = reciveData.readDword();	
	local radiusSize = reciveData.readDword(); // 반지름
	
	local spinNum = reciveData.readDword(); // 기둥이 나타나서 제자리에서 스핀을 도는 수
	local spinTime = reciveData.readDword(); // 소용돌이 쳐서 가운데로 들어오는 시간
	
	local multiHitTerm = reciveData.readDword(); // 기둥 다단히트 간격
	local multiHitAttackRate = reciveData.readDword(); // 기둥 다단히트 공격력 (%)
	
	local spinAddTime = reciveData.readDword(); // 소용돌이가 캐릭터 주변을 회전하는 시간 (0.001초단위)

	local atk = sq_GetCurrentAttackInfo(obj);
	
	if(atk)
	{
		sq_SetCurrentAttackBonusRate(atk, multiHitAttackRate);
	}

	obj.getVar("state").clear_vector(); // state vector
	obj.getVar("state").push_vector(0);
	
	obj.getVar("spin_dir").clear_vector(); // state vector
	obj.getVar("spin_dir").push_vector(angle); // state vector
	
	obj.getVar("flip").clear_vector(); // state vector
	obj.getVar("flip").push_vector(0);

	obj.getVar("radius").clear_vector(); // state vector
	obj.getVar("radius").push_vector(radiusSize);
	
	obj.getVar("pole").clear_vector();
	obj.getVar("pole").push_vector(spinNum);
	obj.getVar("pole").push_vector(spinTime);
	
	
	obj.getVar().clear_vector();
	
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	
	
	if(obj.isMyControlObject()) {
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
		
		obj.addSetStatePacket(S_PO_FROZENLAND_POLE_0, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
	
	if(flip)
	{
		obj.getVar("flip").set_vector(0, 1);
	}
	
	
	obj.getVar("state").clear_timer_vector();
	obj.getVar("state").push_timer_vector();
			
	local t = obj.getVar("state").get_timer_vector(0);
	t.setParameter(200, -1);
	t.resetInstant(0);
	
	local hitCnt = obj.sq_var.get_vector(VECTOR_I_MULTI_HIT_COUNT);

	print("\n\n multiHitTerm:" + multiHitTerm);
	
	obj.timer_.setParameter(multiHitTerm, -1);
	obj.timer_.resetInstant(0);

	// 추가 크로니클 작업
	// 크로니클 아이템 추가 작업 제자리에서 돌고있는 시간이 0보다 크다면 주위를 선회하는 state로 변경해야 합니다.
	obj.getVar("spin").clear_vector();
	obj.getVar("spin").push_vector(spinAddTime); // 최대갯수
	obj.getVar("spin").push_vector(0);
	

}

function setState_po_ATFrozenLandPole(obj, state, datas)
{

	if(!obj) return;
	
	local passiveState = state;
	
	obj.getVar("state").set_vector(0, passiveState);

	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);
	
	if(passiveState == S_PO_FROZENLAND_POLE_0)
	{
		// 기준좌표
		obj.getVar().set_vector(0, x);
		obj.getVar().set_vector(1, y);
		obj.getVar().set_vector(2, z);
	
		local radius = obj.getVar("radius").get_vector(0);
		local current100Angle = obj.getVar("spin_dir").get_vector(0);
		current100Angle = current100Angle % 36000;
		
		local angle = (current100Angle.tofloat() / 100.0);
		
		local disMovLen = radius * sq_CosTable(angle.tointeger());
		local mov_x = sq_GetDistancePos(x, obj.getDirection(), disMovLen.tointeger());		
		
		local axisMagnifyRate = 29.0;
		local upMovLen = radius * sq_SinTable(angle.tointeger()) * axisMagnifyRate / 100;
		local mov_y = y + upMovLen.tointeger();
		
		sq_setCurrentAxisPos(obj, 1, mov_y);
		sq_setCurrentAxisPos(obj, 0, mov_x);
	}
	else if(passiveState == S_PO_FROZENLAND_POLE_1)
	{
		if(obj.getVar("flip").get_vector(0))
		{
			local ani = obj.getCustomAnimation(1);
			obj.setCurrentAnimation(ani);
		}
		else 
		{
			local ani = obj.getCustomAnimation(0);
			obj.setCurrentAnimation(ani);
		}
		
		//local hitCnt = 10;
		//local term = 4000 / hitCnt;	
		//print(" \n\n term:" + term);
		////obj.timer_.setParameter(term, hitCnt);
		//obj.timer_.resetInstant(0);
		
	}


	if(passiveState == S_PO_FROZENLAND_POLE_1 || passiveState == S_PO_FROZENLAND_POLE_3)
	{
		obj.getVar().clear_ct_vector();
		obj.getVar().push_ct_vector();	
		
		local t = obj.getVar().get_ct_vector(0);
		t.Reset();
		t.Start(10000,0);
		
		local stateTimer = obj.getVar("state").get_timer_vector(0);
		stateTimer.setParameter(200, -1);
		stateTimer.resetInstant(0);
	}

}

function procAppend_po_ATFrozenLandPole(obj)
{
	if(!obj) return;
	
	local pChr = obj.getTopCharacter();
	
	if(!pChr) {
		if(obj.isMyControlObject())
		{
			sq_SendDestroyPacketPassiveObject(obj);
		}
		return;
	}
	
	local state = obj.getVar("state").get_vector(0);
	local passiveState = state;
	
	local pAni = sq_GetCurrentAnimation(obj);
	local frmIndex = sq_GetAnimationFrameIndex(pAni);
	//local currentT = sq_GetCurrentTime(pAni);
	
	local t = obj.getVar().get_ct_vector(0);
	local currentT = 0;
	
	if(t)
		currentT = t.Get();
	
	
	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);

	if(passiveState == S_PO_FROZENLAND_POLE_0) {
	}
	else if(passiveState == S_PO_FROZENLAND_POLE_1)
	{
		local stopSpinNum = obj.getVar("pole").get_vector(0);
		if(obj.getVar().get_vector(2) >= stopSpinNum)
		{
			if(obj.isMyControlObject())
			{
				local pIntVec = sq_GetGlobalIntVector();
				
				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);
				
				// 크로니클 아이템 추가 작업 제자리에서 돌고있는 시간이 0보다 크다면 주위를 선회하는 state로 변경해야 합니다.
				if(obj.getVar("spin").get_vector(0) > 0)
					obj.addSetStatePacket(S_PO_FROZENLAND_POLE_3, pIntVec, STATE_PRIORITY_AUTO, false, "");
				else
					obj.addSetStatePacket(S_PO_FROZENLAND_POLE_2, pIntVec, STATE_PRIORITY_AUTO, false, "");
					
			}
		}
		else
		{
			if(obj.getVar().get_vector(4) == 0) 
			{
				if(frmIndex >= 6)
				{
					local spinNum = obj.getVar().get_vector(2);
					
					obj.getVar().set_vector(2, spinNum + 1);
					obj.getVar().set_vector(4, 1);
				}
			}
			else
			{
				if(obj.getVar().get_vector(4) == 1)
				{
					if(frmIndex < 6)
					{
						obj.getVar().set_vector(4, 0);
					}
				}
			}
			
			obj.getVar().set_vector(3, currentT);
		}
		
		procCreateShockWaveAnimation(obj, currentT);
	}
	else if(passiveState == S_PO_FROZENLAND_POLE_3)
	{
		local baseX = obj.getVar().get_vector(0);
		local baseY = obj.getVar().get_vector(1);
		//	각도 갱신
		local currentSpeedRate = 1.0;
		local defaultRoundTime = obj.getVar("pole").get_vector(1);
		
		local radiusBaseSize = obj.getVar("radius").get_vector(0);
		local radius = radiusBaseSize;
		
		local base100Angle = obj.getVar("spin_dir").get_vector(0);
		local current100Angle = (base100Angle + (36000 * currentSpeedRate * (currentT) / defaultRoundTime)) % 36000;
		
		
		local angle = (current100Angle.tofloat() / 100.0);
		
		//print( " angle:" + angle);
		
		local disMovLen = radius * sq_CosTable(angle.tointeger());
		local mov_x = sq_GetDistancePos(baseX, obj.getDirection(), disMovLen.tointeger());		
		
		local axisMagnifyRate = 29.0;
		local upMovLen = radius * sq_SinTable(angle.tointeger()) * axisMagnifyRate / 100;
		local mov_y = baseY + upMovLen.tointeger();
		
		sq_setCurrentAxisPos(obj, 1, mov_y);
		sq_setCurrentAxisPos(obj, 0, mov_x);

		procCreateShockWaveAnimation(obj, currentT);
		
		// 크로니클 아이템 추가 작업 제자리에서 돌고있는 시간이 0보다 크다면 주위를 선회하는 state로 변경해야 합니다.
		local spinAddTime = obj.getVar("spin").get_vector(0);
		if(currentT > spinAddTime)
		{
			if(obj.isMyControlObject())
			{
				local pIntVec = sq_GetGlobalIntVector();
				
				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);
				
				obj.addSetStatePacket(S_PO_FROZENLAND_POLE_2, pIntVec, STATE_PRIORITY_AUTO, false, "");
			}
			
			//obj.getVar("spin_dir").set_vector(0, angle.tointeger());
			obj.getVar().set_vector(3, currentT);
		}
		
	
	}	
	else if(passiveState == S_PO_FROZENLAND_POLE_2)
	{
		local delaySum = obj.getVar().get_vector(3);
		//local delaySum = 0;
		
		local baseX = obj.getVar().get_vector(0);
		local baseY = obj.getVar().get_vector(1);
		//	각도 갱신
		local currentSpeedRate = 1.0;
		local defaultRoundTime = obj.getVar("pole").get_vector(1);
		
		local radiusBaseSize = obj.getVar("radius").get_vector(0);
		local radius = sq_GetUniformVelocity(radiusBaseSize, 0, currentT - delaySum, defaultRoundTime);
		
		local base100Angle = obj.getVar("spin_dir").get_vector(0);
		local current100Angle = (base100Angle + (36000 * currentSpeedRate * (currentT - delaySum) / defaultRoundTime)) % 36000;
		
		local angle = (current100Angle.tofloat() / 100.0);
		
		local disMovLen = radius * sq_CosTable(angle.tointeger());
		local mov_x = sq_GetDistancePos(baseX, obj.getDirection(), disMovLen.tointeger());		
		
		local axisMagnifyRate = 29.0;
		local upMovLen = radius * sq_SinTable(angle.tointeger()) * axisMagnifyRate / 100;
		local mov_y = baseY + upMovLen.tointeger();
		
		sq_setCurrentAxisPos(obj, 1, mov_y);
		sq_setCurrentAxisPos(obj, 0, mov_x);
		
		if(currentT > (defaultRoundTime + delaySum))
		{
			if(obj.isMyControlObject())
			{
				sq_SendDestroyPacketPassiveObject(obj);
			}
		}
		
		procCreateShockWaveAnimation(obj, currentT);
	}
	
	if (obj.timer_.isOnEvent(currentT) == true)
	{
		obj.resetHitObjectList();
	}
	
	

}


function onDestroyObject_po_ATFrozenLandPole(obj, object)
{

	if(!obj) return;

}

function onKeyFrameFlag_po_ATFrozenLandPole(obj, flagIndex)
{

}

function onEndCurrentAni_po_ATFrozenLandPole(obj)
{

	if(!obj) return;

	if(!obj.isMyControlObject()) return;
	
	
	local state = obj.getVar("state").get_vector(0);
	
	local passiveState = state;

	if(passiveState == S_PO_FROZENLAND_POLE_0) {
	
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
		
		obj.addSetStatePacket(S_PO_FROZENLAND_POLE_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
	else if(passiveState == S_PO_FROZENLAND_POLE_1) {
	}
	else if(passiveState == S_PO_FROZENLAND_POLE_2) {
	}

}
//*.obj;*.ani;*.als;*.lst;*.atk;*.skl;*.lst;*.ptl;*.nut;*.equ;*.ptl;*.etc
//*.obj;*.ani;*.als;*.lst;*.atk;*.skl;*.lst;*.ptl;*.nut;*.equ;*.ptl;*.etc
// *.obj;*.ani;*.als;*.lst;*.atk;*.skl;*.lst;*.ptl;*.nut;*.equ;*.ptl;*.etc;*.ui