
SUB_STATE_WOODFENCE_0	<- 0
SUB_STATE_WOODFENCE_1	<- 1

function checkExecutableSkill_WoodFence(obj)
{
	print(" checkExecutableSkill_WoodFence");

	if (!obj) return false;

	local b_useskill = obj.sq_IsUseSkill(SKILL_WOODFENCE);

	if (b_useskill)
	{
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_WOODFENCE_0); // substate세팅
		obj.sq_AddSetStatePacket(STATE_WOODFENCE, STATE_PRIORITY_USER, true);
		return true;
	}
	
	return false;

}

function checkCommandEnable_WoodFence(obj)
{
	if(!obj) return false;
	
	local state = obj.sq_GetState();

	local skill_level = obj.sq_GetSkillLevel(SKILL_WOODFENCE);
	print(" checkCommandEnable_WoodFence:" + skill_level);
	if(state == STATE_ATTACK)
	{
		return obj.sq_IsCommandEnable(SKILL_WOODFENCE); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_BROKENARROW);
	}

	return true;
}

function onSetState_WoodFence(obj,state,datas,isResetTimer)
{
	if(!obj) return;
	
	
	local substate = obj.sq_GetVectorData(datas, 0);
	obj.setSkillSubState(substate);

	obj.sq_StopMove();

	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();

	obj.getVar().clear_vector();
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);


	print(" onSetState_Firewall:" + substate);
		
	if (substate == SUB_STATE_FIREWALL_0)
	{
		print(" onSetState_Firewall on");
		
		local skill_level = obj.sq_GetSkillLevel(SKILL_WOODFENCE);
		local objectNum = obj.sq_GetLevelData(SKILL_WOODFENCE, SKL_LV_0, skill_level); // 0.생성되는 오브젝트 갯수
		
		setCreatorSkillStateSkillIndex(obj, SKILL_WOODFENCE);
		setCreatorSkillCount(obj, objectNum);
		
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_FIRE_WALL);
	}
	
	
	
	
}

function prepareDraw_WoodFence(obj)
{
	if(!obj) return;

}

function onMouseMoveCharacter_WoodFence(obj, x, y)
{
	local objectManager = obj.getObjectManager();
	
	local x1 = getCreatorBeforePosX(obj);
	local y1 = getCreatorBeforePosY(obj);	
	local x2 = objectManager.getFieldXPos(x, ENUM_DRAWLAYER_NORMAL);
	local y2 = objectManager.getFieldYPos(y, 0, ENUM_DRAWLAYER_NORMAL);	
	local zPos = 0;
	
	if (y2 < TILE_FLOOR_START_Y)
	{ // 바닥이 시작하는 y좌표라면..
		return;
	}
	
	
	local dist = getDist2(x1, y1, x2, y2);
	
	local term = obj.sq_GetIntData(SKILL_WOODFENCE, 0); // 생성 간격
	
	if (term <= dist)
	{	
		local consumeValue = getCreatorSkillConsumeValue(obj, SKILL_WOODFENCE);
		
		if (useCreatorSkill(obj, SKILL_WOODFENCE, x2, y2, consumeValue))
		{
			local skill_level = obj.sq_GetSkillLevel(SKILL_WOODFENCE);
			local time = obj.sq_GetLevelData(SKILL_WOODFENCE, SKL_LV_1, skill_level); // 1.오브젝트 지속시간
			
			sq_BinaryStartWrite();
			sq_BinaryWriteDword(time); // 1.오브젝트 지속시간
			sq_SendCreatePassiveObjectPacketPos(obj, 24354, 0, x2, y2, zPos);
		}		
	}
	
}

function onProc_WoodFence(obj)
{
	if(!obj) return;
	
	
	
}

function onProcCon_WoodFence(obj)
{

	if(!obj) return;

}

function onEndCurrentAni_WoodFence(obj)
{
	if(!obj) return;
	
	if(!obj.isMyControlObject()) {
		return;
	}
	
	local substate = obj.getSkillSubState();

	if (substate == SUB_STATE_WOODFENCE_0)
	{	
		obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	}
	

}

function onKeyFrameFlag_WoodFence(obj,flagIndex)
{

	if(!obj) return false;

	return true;

}

function onEndState_WoodFence(obj,new_state)
{

	if(!obj) return;

}

function onAfterSetState_WoodFence(obj,state,datas,isResetTimer)
{

	if(!obj) return;

}

function onBeforeAttack_WoodFence(obj,damager,boundingBox,isStuck)
{

	if(!obj) return;

}

function onAttack_WoodFence(obj,damager,boundingBox,isStuck)
{

	if(!obj) return;

}

function onAfterAttack_WoodFence(obj,damager,boundingBox,isStuck)
{

	if(!obj) return 0;

	return 1;

}

function onBeforeDamage_WoodFence(obj,attacker,boundingBox,isStuck)
{

	if(!obj) return;

}

function onDamage_WoodFence(obj,attacker,boundingBox)
{

	if(!obj) return;

}

function onAfterDamage_WoodFence(obj,attacker,boundingBox)
{

	if(!obj) return;

}
