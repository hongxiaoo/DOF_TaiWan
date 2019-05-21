
SUB_STATE_FIREMETEO_0	<- 0


function onMouseButtonDown_FireMeteo(obj)
{
	if (!obj) return;
	
	local objectManager = obj.getObjectManager();
	local xPos = objectManager.getFieldXPos(IMouse.GetXPos(), ENUM_DRAWLAYER_NORMAL);
	local yPos = objectManager.getFieldYPos(IMouse.GetYPos(), 0, ENUM_DRAWLAYER_NORMAL);
	local zPos = 61;
	
	if (yPos < TILE_FLOOR_START_Y)
	{ // 바닥이 시작하는 y좌표라면..
		return;
	}
	
	
	local ptl = sq_GetParticleInfo(obj, "Particle/CreatorFireMeteo.ptl");
	
	sq_BinaryParameterStartWrite();
	// 파라미터가 너무 많아 바이너리 데이타를 이용합니다.
	// x, y, z == 새끼패시브오브젝트가 출력될 곳
	// wx, wy == 경고표시가 출력될 곳
	// delay ControlRate 경고표시의 스피드 조절용 %값
	// warningMarkIndex == 경고표시의 종류 : 0 안보임, 1 보통, 2 대형, 3 보통 (아군Only), 4 대형 (아군Only)
	local moveVariable1 = 500;
	local naaMoveVariable1 = -400; // -800
	local createXDistance = xPos - moveVariable1;
	local createYDistance = yPos;
	local createZDistance = -naaMoveVariable1;
	
	local dir = sq_GetDirection(obj);
	if (dir == ENUM_DIRECTION_LEFT)
	{
		createXDistance = xPos + moveVariable1;
	}
	
	sq_BinaryParameterWriteDword(createXDistance);
	sq_BinaryParameterWriteDword(createYDistance);
	sq_BinaryParameterWriteDword(createZDistance);
	
	sq_BinaryParameterWriteDword(xPos);
	sq_BinaryParameterWriteDword(yPos);
	
	sq_BinaryParameterWriteDword(ENUM_DIRECTION_NEUTRAL);
	sq_BinaryParameterWriteDword(200); // int delayControlRate
	
	local markType = obj.sq_GetIntData(SKILL_FIREMETEO, 0); // 타게팅 마크 종류(변경하지 말것!)
	sq_BinaryParameterWriteDword(markType); //int warningMarkIndex

	
	// 공격력 추가수치 작업
	local level = sq_GetSkillLevel(obj, SKILL_CREATORFLAME);

	// 1.공격력 추가 수치 (%)
	local addValue = sq_GetLevelData(obj, SKILL_CREATORFLAME, SKL_LV_1, level);
	local addRate = addValue.tofloat() / 100.0;

	print(" addRate:" + addRate);

	local skillLevel = sq_GetSkillLevel(obj, SKILL_FIREMETEO);

	local power = obj.sq_GetPowerWithPassive(SKILL_FIREMETEO, STATE_FIREMETEO, SKL_LV_0,-1,addRate.tofloat());
	local sizeRate = sq_GetLevelData(obj, SKILL_FIREMETEO, SKL_LV_1, skillLevel);

	
	// 메테오 공격력 푸시	
	sq_BinaryStartWrite();
	 // 공격력 세팅
	sq_BinaryWriteDword(power);
	 // size rate
	sq_BinaryWriteDword(sizeRate);
	
	
	local skill_level = obj.sq_GetSkillLevel(SKILL_FIREMETEO);
	sq_CreatePassiveObjectAfterWarning(obj, 23501, skill_level, ptl);	
	
	obj.sq_PlaySound("R_METEO_CASTING");
}

