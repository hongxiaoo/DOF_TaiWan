
SUB_STATE_ICEROCK_0	<- 0


function onMouseButtonDown_IceRock(obj)
{
	if (!obj) return;
	
	local objectManager = obj.getObjectManager();
	local xPos = objectManager.getFieldXPos(IMouse.GetXPos(), ENUM_DRAWLAYER_NORMAL);
	local yPos = objectManager.getFieldYPos(IMouse.GetYPos(), 0, ENUM_DRAWLAYER_NORMAL) + 20;
	local zPos = 61;
	
	
	if (yPos < TILE_FLOOR_START_Y)
	{ // 바닥이 시작하는 y좌표라면..
		return;
	}
	
	// 0.공격력

	// 공격력 추가수치 작업
	local level = sq_GetSkillLevel(obj, SKILL_CREATORICE);

	// 1.공격력 추가 수치 (%)
	local addValue = sq_GetLevelData(obj, SKILL_CREATORICE, SKL_LV_1, level);
	local addRate = addValue.tofloat() / 100.0;

	local power = obj.sq_GetPowerWithPassive(SKILL_ICEROCK, STATE_ICEROCK, 0,-1,addRate.tofloat());

	// 1. 다단히트 간격
	local multiHitTerm = sq_GetIntData(obj, SKILL_ICEROCK, 1); 

	sq_BinaryStartWrite();
	sq_BinaryWriteDword(power); // 힘
	sq_BinaryWriteDword(multiHitTerm); // 다단히트
	sq_SendCreatePassiveObjectPacketPos(obj, 23503, 0, xPos, yPos, zPos);

	obj.sq_PlaySound("ICESTONE_READY");
}

