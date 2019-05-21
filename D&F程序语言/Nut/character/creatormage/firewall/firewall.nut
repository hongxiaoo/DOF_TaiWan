
SUB_STATE_FIREWALL_0	<- 0
SUB_STATE_FIREWALL_1	<- 1


function onMouseMoveCharacter_Firewall(obj, x, y)
{
	if (!obj)
		return;
	
	local objectManager = obj.getObjectManager();
	
	local x1 = getCreatorBeforePosX(obj);
	local y1 = getCreatorBeforePosY(obj);	
	local x2 = objectManager.getFieldXPos(x, ENUM_DRAWLAYER_NORMAL);
	local y2 = objectManager.getFieldYPos(y, 0, ENUM_DRAWLAYER_NORMAL);	
	local zPos = 0;
	

	print(" x2:" + x2 + " y2:" + y2 + " TILE_FLOOR_START_Y:" + TILE_FLOOR_START_Y);

	if (y2 < TILE_FLOOR_START_Y)
	{ // 바닥이 시작하는 y좌표라면..
		return;
	}

	local appendage = getCreatorMageAppendageByType(obj, CREATOR_TYPE_FLAME);

	if (!appendage)
		return;
	
	local dist = getDist2(x1, y1, x2, y2);
	
	local term = obj.sq_GetIntData(SKILL_FIREWALL, 0); // 생성 간격

	local time = appendage.getTimer().Get();
	
	print( " term:" + term + " dist:" + dist + " time:" + time);
	if (term <= dist || time > 100)
	{		
		local consumeValue = getCreatorSkillConsumeValue(obj, SKILL_FIREWALL);
		
		if (useCreatorSkill(obj, SKILL_FIREWALL, x2, y2, consumeValue))
		{
			// 공격력 추가수치 작업
			local level = sq_GetSkillLevel(obj, SKILL_CREATORFLAME);
			// 1.공격력 추가 수치 (%)
			local addValue = sq_GetLevelData(obj, SKILL_CREATORFLAME, SKL_LV_1, level);
			local addRate = addValue.tofloat() / 100.0;

			// 0.공격력
			local power = obj.sq_GetPowerWithPassive(SKILL_FIREWALL, STATE_FIREWALL, SKL_LV_0,-1, addRate.tofloat());

			local skillLevel = sq_GetSkillLevel(obj, SKILL_FIREWALL);
			// 1.파이어월 사이즈
			local sizeRate = sq_GetLevelData(obj, SKILL_FIREWALL, SKL_LV_1, skillLevel); 
			
			sq_BinaryStartWrite();
			sq_BinaryWriteDword(power); // 힘
			sq_BinaryWriteDword(sizeRate); // 파이어월 사이즈
			
			sq_SendCreatePassiveObjectPacketPos(obj, 23500, 0, x2, y2, zPos);

		}
	}
}


