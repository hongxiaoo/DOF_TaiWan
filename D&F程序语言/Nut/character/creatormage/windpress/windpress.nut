
SUB_STATE_WINDPRESS_0	<- 0
SUB_STATE_WINDPRESS_1	<- 1
SUB_STATE_WINDPRESS_2	<- 2
SUB_STATE_WINDPRESS_3	<- 3
SUB_STATE_WINDPRESS_4	<- 4

function checkExecutableSkill_WindPress(obj)
{

	if (!obj) return false;

	local b_useskill = obj.sq_IsUseSkill(SKILL_WINDPRESS);
	
	print("b_useskill : %d" + b_useskill);

	if (b_useskill) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_WINDPRESS_0); // substate세팅
		obj.sq_AddSetStatePacket(STATE_WINDPRESS, STATE_PRIORITY_IGNORE_FORCE, true);
		return true;
	}	

	return false;
}

function checkCommandEnable_WindPress(obj)
{

	if (!obj) return false;

	local state = obj.sq_GetState();
	
	if (state == STATE_ATTACK)
	{
		return obj.sq_IsCommandEnable(SKILL_WINDPRESS); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_BROKENARROW);
	}

	return true;

}

function onSetState_WindPress(obj,state,datas,isResetTimer)
{
	if (!obj) return;

	local substate = obj.sq_GetVectorData(datas, 0);
	obj.setSkillSubState(substate);
	obj.sq_StopMove();
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();
	
	obj.getVar().clear_vector();
	obj.getVar().push_vector(0);

	obj.getVar().clear_ct_vector();
	obj.getVar().push_ct_vector();	
	local t = obj.getVar().get_ct_vector(0);
	if (t)
	{
		t.Reset();
		t.Start(10000,0);
	}		
	
	print(" onSetState_WindPress");

	if (substate == SUB_STATE_WINDPRESS_0)
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_WINDPRESS_CAST);
		local pAni = obj.sq_GetCurrentAni();
		
		// 캐스팅 속도를 따라가도록 설정
		// 캐스팅 속도가 변경되면, 에니메이션 속도도 변경 됩니다.
		// 캐스팅 게이지도 표시를 해줍니다.
		local skillLevel = sq_GetSkillLevel(obj, SKILL_WINDPRESS);
		
		//local castTime = sq_GetCastTime(obj, SKILL_WINDPRESS, skillLevel);
		//local animation = sq_GetCurrentAnimation(obj);
		//local startTime = sq_GetFrameStartTime(animation, 16);
		//local speedRate = startTime.tofloat() / castTime.tofloat();
		//obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
			//SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, speedRate, speedRate);
//
		//sq_StartDrawCastGauge(obj, startTime, true);
 		obj.sq_PlaySound("R_CR_WINDPRESS");
		
	}
	else if (substate == SUB_STATE_WINDPRESS_1)
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_WINDPRESS_START);
 		obj.sq_PlaySound("WINDPRESS_READY");
	}
	else if (substate == SUB_STATE_WINDPRESS_2)
	{
		if (obj.isMyControlObject())
		{
			sq_flashScreen(obj,0,300,0,100, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
			obj.sq_SetShake(obj,1,300);
		}
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_WINDPRESS);
		obj.sq_PlaySound("WINDPRESS_BURST", 7571);
	}
	else if (substate == SUB_STATE_WINDPRESS_3)
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_WINDPRESS_END);
	}
}

function prepareDraw_WindPress(obj)
{

	if (!obj) return;

}

function onProc_WindPress(obj)
{

	if (!obj) return;

	local substate = obj.getSkillSubState();

	local pAni = obj.sq_GetCurrentAni();
	local frmIndex = obj.sq_GetCurrentFrameIndex(pAni);
	local currentT = sq_GetCurrentTime(pAni);

	if (substate == SUB_STATE_WINDPRESS_2)
	{
		if (obj.isMyControlObject())
		{
			local skill_level = obj.sq_GetSkillLevel(SKILL_WINDPRESS);
			
			//24355 `Character/Mage/CreatorWindPress.obj`			// 크리에이터 : 윈드프레스
			local passiveobj_cl = obj.sq_GetPassiveObject(24355);
			
			local objectManager = obj.getObjectManager();
			
			if (!objectManager)
				return;

			local stage = sq_GetObjectManagerStage(obj);
			local control = stage.getMainControl();
			
			if (!control.IsLBDown() || !passiveobj_cl)
			{
				obj.sq_IntVectClear();
				obj.sq_IntVectPush(SUB_STATE_WINDPRESS_3);
				obj.sq_AddSetStatePacket(STATE_WINDPRESS, STATE_PRIORITY_USER, true);
			}
			else 
			{
				local t = obj.getVar().get_ct_vector(0);

				if (t)
				{
					local currentT = 0;
		
					currentT = t.Get();

					print(" currentT:" + currentT);
					if (currentT >= 300)
					{
						if (obj.isMyControlObject())
						{
							print(" reset:" + currentT);
							sq_flashScreen(obj,0,300,0,100, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
							obj.sq_SetShake(obj,1,300);
						}
						t.Reset();
						t.Start(10000,0);
					}
				}
			}
		}
	}
}

function onProcCon_WindPress(obj)
{
	if (!obj) return;
	
	local substate = obj.getSkillSubState();

	local pAni = obj.sq_GetCurrentAni();
	local frmIndex = obj.sq_GetCurrentFrameIndex(pAni);
	local currentT = sq_GetCurrentTime(pAni);

	if (substate == SUB_STATE_WINDPRESS_1)
	{
		if (frmIndex >= 2)
		{
			if (!obj.getVar().get_vector(0))
			{
				obj.getVar().set_vector(0, 1);
				
				local posX = obj.getXPos();
				local posY = obj.getYPos();
				local posZ = obj.getZPos();
				
//100 // 0.다단히트 간격
//100 // 1.타격거리
//10	// 2. 소모량
//30 // 3. 타격각도 범위

				// 0.다단히트 간격
				local multiHitTerm = sq_GetIntData(obj, SKILL_WINDPRESS, 0);
				// 1.타격거리
				local targetLen = sq_GetIntData(obj, SKILL_WINDPRESS, 1);
				// 2.소모량
				local consume = sq_GetIntData(obj, SKILL_WINDPRESS, 2);
				// 3.타격각도
				local dir = sq_GetIntData(obj, SKILL_WINDPRESS, 3);
				
				// 공격력 추가수치 작업
				local level = sq_GetSkillLevel(obj, SKILL_CREATORWIND);

				// 1.공격력 추가 수치 (%)
				local addValue = sq_GetLevelData(obj, SKILL_CREATORWIND, SKL_LV_1, level);
				local addRate = addValue.tofloat() / 100.0;


				local power =  obj.sq_GetPowerWithPassive(SKILL_WINDPRESS, STATE_STAND, SKL_LV_0, -1,addRate.tofloat());
				
				obj.sq_StartWrite();
				sq_BinaryWriteDword(multiHitTerm);
				sq_BinaryWriteDword(targetLen);
				sq_BinaryWriteDword(consume);
				sq_BinaryWriteDword(dir);
				sq_BinaryWriteDword(power);
				
				local size = 50;				
				local offsetZ = 62;
				local offset = sq_GetDistancePos(0, obj.getDirection(), size);
				sq_SendCreatePassiveObjectPacketPos(obj, 24355, 0, posX + offset, posY - 1, posZ + offsetZ);
			}
		}
	}
}

function onEndCurrentAni_WindPress(obj)
{

	if (!obj) return;
	
	//local pSickleObj = obj.sq_GetPassiveObject(24101); // sickle 

	local substate = obj.getSkillSubState();

	if (substate == SUB_STATE_WINDPRESS_0)
	{
		if (obj.isMyControlObject()) {
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(SUB_STATE_WINDPRESS_1);
			obj.sq_AddSetStatePacket(STATE_WINDPRESS, STATE_PRIORITY_USER, true);
		}
	}
	else if (substate == SUB_STATE_WINDPRESS_1)
	{
		if (obj.isMyControlObject()) {
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(SUB_STATE_WINDPRESS_2);
			obj.sq_AddSetStatePacket(STATE_WINDPRESS, STATE_PRIORITY_USER, true);
		}
	}
	else if (substate == SUB_STATE_WINDPRESS_2)
	{
	}
	else if (substate == SUB_STATE_WINDPRESS_3)
	{
		if (obj.isMyControlObject())
		{
			obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
		}
	}
	else if (substate == SUB_STATE_WINDPRESS_4)
	{
	}
	

}

function onKeyFrameFlag_WindPress(obj,flagIndex)
{

	if (!obj) return false;

	return true;

}

function onEndState_WindPress(obj,new_state)
{

	if (!obj) return;

	obj.stopSound(7571);
	sq_EndDrawCastGauge(obj);
}

function onAfterSetState_WindPress(obj,state,datas,isResetTimer)
{

	if (!obj) return;

}

function onBeforeAttack_WindPress(obj,damager,boundingBox,isStuck)
{

	if (!obj) return;

}

function onAttack_WindPress(obj,damager,boundingBox,isStuck)
{

	if (!obj) return;

}

function onAfterAttack_WindPress(obj,damager,boundingBox,isStuck)
{

	if (!obj) return 0;

	return 1;

}

function onBeforeDamage_WindPress(obj,attacker,boundingBox,isStuck)
{

	if (!obj) return;

}

function onDamage_WindPress(obj,attacker,boundingBox)
{

	if (!obj) return;

}

function onAfterDamage_WindPress(obj,attacker,boundingBox)
{

	if (!obj) return;

}
