
function checkExecutableSkill_IceOrbEx(obj)
{
	if (!obj) return false;

	local useSkill = obj.sq_IsUseSkill(SKILL_ICE_ORB_EX);
	if (useSkill) {
		obj.sq_AddSetStatePacket(STATE_ICE_ORB_EX, STATE_PRIORITY_IGNORE_FORCE, false);
		return true;
	}
	return false;
}

function checkCommandEnable_IceOrbEx(obj)
{
	if(!obj) return false;
	local state = obj.sq_GetState();

	if(state == STATE_ATTACK) {
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_ICE_ORB_EX);
	}

	return true;
}

function onSetState_IceOrbEx(obj, state, datas, isResetTimer)
{
	if(!obj) return;	
	
	obj.sq_StopMove();
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_ICE_ORB_EX);
	obj.sq_PlaySound("MW_ICEORB");
}

function onEndCurrentAni_IceOrbEx(obj)
{
	if(!obj) return;

	local substate = obj.getSkillSubState();	
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);	// 애니 끝나면 스탠드로.
}

function onKeyFrameFlag_IceOrbEx(obj, flagIndex)
{

	if(!obj) return false;

	local substate = obj.getSkillSubState();	
	local level		  = sq_GetSkillLevel(obj, SKILL_ICE_ORB_EX);
	
	if(flagIndex == 1) {
		// 패시브 발사.
		if(obj.isMyControlObject())
		{
			local distance = sq_GetIntData(obj, SKILL_ICE_ORB_EX, 0); // 0. 무입력 거리 
			
			
			local leftPress = sq_IsKeyDown(OPTION_HOTKEY_MOVE_LEFT, ENUM_SUBKEY_TYPE_ALL);
			local rightPress = sq_IsKeyDown(OPTION_HOTKEY_MOVE_RIGHT, ENUM_SUBKEY_TYPE_ALL);
				
			if(leftPress && rightPress)  // 동시에 안눌렀을때 처리. 동시에 눌렀을 땐 중간으로.
			{
				//디폴트 값이기에 아무것도 하지않음.
			}			
			else if((sq_GetDirection(obj) == ENUM_DIRECTION_RIGHT && rightPress)  // 같은 방향을 눌렀을때.
				|| (sq_GetDirection(obj) == ENUM_DIRECTION_LEFT && leftPress)) 
			{
				distance = sq_GetIntData(obj, SKILL_ICE_ORB_EX, 1); // STATIC 1. 정방향 거리
			}
			else if(leftPress || rightPress) // 하나라도 입력 됐다면 역방향
			{
				distance = sq_GetIntData(obj, SKILL_ICE_ORB_EX, 2); // STATIC 2. 역방향 거리
			}
			
			
			local speed = sq_GetIntData(obj, SKILL_ICE_ORB_EX, 3);// STATIC 3. 구체 발사 속도 
			
			local level			= sq_GetSkillLevel(obj, SKILL_ICE_ORB_EX);	
			local gap			= sq_GetIntData(obj, SKILL_ICE_ORB_EX, 4); // STATIC 4. 가시 생성 시간 간격
			local pricklePower  = obj.sq_GetBonusRateWithPassive(SKILL_ICE_ORB_EX , STATE_ICE_ORB_EX, 0, 1.0);	// LEVEL 0. 가시 공격력
			local lastPower		= obj.sq_GetBonusRateWithPassive(SKILL_ICE_ORB_EX , STATE_ICE_ORB_EX, 1, 1.0);	// LEVEL 1. 막타 공격력
			local maxCount		= sq_GetLevelData(obj, SKILL_ICE_ORB_EX, 2, level);	// LEVEL 2. 가시 생성 횟수			
			local direction		= sq_GetDirection(obj);
			local targetPos		= sq_GetDistancePos(obj.getXPos(), direction, distance);
		
			// 시간 = 거리/속력
			obj.sq_StartWrite();
			obj.sq_WriteDword(speed);  // 날아가는 속도.	
			obj.sq_WriteDword(gap);
			obj.sq_WriteFloat(pricklePower.tofloat()); //음수일수도 있기때문에 float형으로 보낸다. sqr에선 DWORD 형을 자동으로 int형으로 바꿔 주질 않기 때문.
			obj.sq_WriteFloat(lastPower.tofloat());			
			obj.sq_WriteDword(maxCount);
			obj.sq_WriteWord(direction);
			obj.sq_WriteDword(targetPos);			
			
			obj.sq_SendCreatePassiveObjectPacket(24235, 0, 100, 0, 50);	// 얼음구 생성, 100,50의 좌표에 생성
		}
	}

	return true;

}
