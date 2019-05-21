
MODE_NORMAL <- 0
MODE_FREEZE <- 1

function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_atmage_tundra_cs")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_atmage_tundra_cs")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_atmage_tundra_cs")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_atmage_tundra_cs")
	appendage.sq_AddFunctionName("drawAppend", "drawAppend_appendage_atmage_tundra_cs")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_atmage_tundra_cs")
	appendage.sq_AddFunctionName("isDrawAppend", "isDrawAppend_appendage_atmage_tundra_cs")
	appendage.sq_AddFunctionName("onApplyHpDamage", "onApplyHpDamage_appendage_atmage_tundra_cs")
}


function sq_AddEffect(appendage)
{
}

function drawAppend_appendage_atmage_tundra_cs(appendage, isOver, x, y, isFlip)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();
	
	if(!obj) {
		appendage.setValid(false);
		return;
	}

	local mode = appendage.getVar("mode").get_vector(0);
	
	if(sq_IsValidActiveStatus(obj, ACTIVESTATUS_FREEZE) || mode == MODE_FREEZE)
	{
		return;
	}
	
	
	local pAni = sq_GetCurrentAnimation(obj);
	
	if(!pAni) {
		appendage.setValid(false);
		return;
	}
	
	local t = appendage.sq_var.get_ct_vector(0);
	local currentT = 0;	
	currentT = t.Get();
	
	
	//print(" currentT:" + currentT);
	
	local startT = 259;
	local endT = 210;
	local effectT = 800;
	local effectType = GRAPHICEFFECT_DODGE;
	local rgb = sq_RGB(0, 0, 255);
	
	local targetV = endT;

	local al = sq_GetUniformVelocity(startT, targetV, currentT, effectT);
	
	local alpha = sq_ALPHA(al);
	pAni.setEffectLayer(true, effectType, true, rgb, alpha, true, false);
	
	
	local size = sq_AniLayerListSize(pAni);	

	if(currentT > effectT)
	{	
		local t = appendage.sq_var.get_ct_vector(0);
		t.Reset();
		t.Start(1000000,0);
	}
	
}




function proc_appendage_atmage_tundra_cs(appendage)
{
	if(!appendage)
	{
		return;
	}

	//print( " tundra_cs");
	local obj = appendage.getParent();
	
	if(!obj)
	{
		appendage.setValid(false);
		return;
	}
	
	local mode = appendage.getVar("mode").get_vector(0);
	
	if(sq_IsValidActiveStatus(obj, ACTIVESTATUS_FREEZE))
	{
		if(mode == MODE_NORMAL)
		{
			appendage.getVar("mode").set_vector(0, MODE_FREEZE);
		}
	}
	else
	{
		if(mode == MODE_FREEZE)
		{
			appendage.setValid(false);
			return;
		}
	}
	

	local t = appendage.sq_var.get_ct_vector(1); // 얼기까지 걸리는 시간이 지나면 빙결공격이 들어갑니다.
	local currentT = 0;	
	
	if(t)
	{
		currentT = t.Get();
	}
	
	
	local frozenWaitTime = appendage.getVar("skl").get_vector(0);	// 0.얼기까지 걸리는 시간
	local frozenLevel = appendage.getVar("skl").get_vector(1);	// 1.빙결레벨
	local frozenRate = appendage.getVar("skl").get_vector(2);		// 2.빙결확율
	local frozenTime = appendage.getVar("skl").get_vector(3);		// 3.빙결시간
	
	if(currentT > frozenWaitTime)
	{	
		if(t)
		{
			t.Reset();
			t.Start(1000000,0);
		}
		
		local obj = appendage.getParent();	
		
		if(!sq_IsValidActiveStatus(obj, ACTIVESTATUS_FREEZE))
		{
			if(appendage.getSource())
			{
				local attackerObj = appendage.getSource();
				
				if(attackerObj.isMyControlObject())
				{
					local id = sq_GetObjectId(obj);
					
					local x = sq_GetXPos(obj);
					local y = sq_GetYPos(obj);
					local z = sq_GetZPos(obj);
					
					sq_BinaryStartWrite();
					sq_BinaryWriteDword(id); //
					sq_BinaryWriteDword(frozenLevel); //
					sq_BinaryWriteDword(frozenRate); //
					sq_BinaryWriteDword(frozenTime); //
					
					//24259	`Character/Mage/ATTundraSoulFrozen.obj`	// 남법사 툰드라의 가호 패시브오브젝트
					sq_SendCreatePassiveObjectPacketPos(attackerObj, 24259, 0, x, y, z);
				}
			}
		}
	}


	if(appendage.sq_var.get_vector(1) == 0)
	{
		local T = appendage.getTimer().Get();	
		local maxT = appendage.sq_var.get_vector(0);
		
		if(T >= maxT)
		{ // 시간이 다 됐거나
			//appendage.sq_DeleteEffectFront();
			//appendage.setValid(false);
			return;
		}
	}
}


function onStart_appendage_atmage_tundra_cs(appendage)
{
	if(!appendage) {
		return;
	}
	
	print(" tundra cs start");
	appendage.sq_DeleteEffectFront();
	appendage.sq_AddEffectFront("Character/Mage/Effect/Animation/ATTundraSoul/passive_dodge.ani")
	
	appendage.sq_var.clear_vector();		
	
	appendage.sq_var.push_vector(0); // 기본모드
	
	appendage.sq_var.clear_ct_vector();
	appendage.sq_var.push_ct_vector();	
	appendage.sq_var.push_ct_vector();
	
	appendage.getVar("mode").clear_vector();
	appendage.getVar("mode").push_vector(0);
	
	local t = appendage.sq_var.get_ct_vector(0);
	t.Reset();
	t.Start(1000000,0);
	
	local frozenT = appendage.sq_var.get_ct_vector(1);
	
	if(frozenT)
	{
		frozenT.Reset();
		frozenT.Start(1000000,0);
	}
	
	local obj = appendage.getParent();	
	
}

function isDrawAppend_appendage_atmage_tundra_cs(appendage)
{
	local obj = appendage.getParent();
	
	if(!obj) {
		appendage.setValid(false);
		return false;
	}

	local mode = appendage.getVar("mode").get_vector(0);
	
	if(sq_IsValidActiveStatus(obj, ACTIVESTATUS_FREEZE) || mode == MODE_FREEZE)
	{
		return false;
	}
	
	return true;
	
}

function onApplyHpDamage_appendage_atmage_tundra_cs(appendage, newHpDamage, attacker)
{
	local obj = appendage.getParent();
	
	if(!obj)
		return newHpDamage;
	
	local damage = newHpDamage;
	
	if(sq_IsValidActiveStatus(obj, ACTIVESTATUS_FREEZE))
	{
		local frozenAddDamageRate = appendage.getVar("skl").get_vector(4);		// 4.얼어있는 적 추가 데미지
		
		local addDamage = newHpDamage.tofloat() * frozenAddDamageRate.tofloat() / 100.0;
		
		print(" addDamage:" + addDamage);
		
		damage = damage + addDamage.tointeger();
	}
	
	return damage;
}



function prepareDraw_appendage_atmage_tundra_cs(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}




function onEnd_appendage_atmage_tundra_cs(appendage)
{
	if(!appendage)
	{
		return;
	}
	print(" tundra cs end");
	appendage.sq_DeleteEffectFront();
	
}


// 어벤져 각성 변신의 끝부분
function isEnd_appendage_atmage_tundra_cs(appendage)
{
	return false;
}