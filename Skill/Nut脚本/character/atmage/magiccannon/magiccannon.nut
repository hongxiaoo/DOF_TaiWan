ENUM_MAGIC_CANNON_SUBSTATE_CHARGE   <- 0;  // 준비
ENUM_MAGIC_CANNON_SUBSTATE_HORIZON  <- 1;  // 수평(점프)
ENUM_MAGIC_CANNON_SUBSTATE_VERTICAL <- 2; // 수직(점프)
ENUM_MAGIC_CANNON_SUBSTATE_DIAGONAL <- 3; // 대각선(점프)
ENUM_MAGIC_CANNON_SUBSTATE_LAND		<- 4; // 나중에 추가된 지상타.

function checkExecutableSkill_MagicCannon(obj)
{
	if(!obj) return false;
	
	local b_useskill = obj.sq_IsUseSkill(SKILL_MAGIC_CANNON);
	if(b_useskill) {
		// 점프상태였다면 공중 타
		obj.sq_IntVectClear();		
		if(obj.getState() == STATE_JUMP)
			obj.sq_IntVectPush(ENUM_MAGIC_CANNON_SUBSTATE_CHARGE); 
		else //점프가 아니면 평타			
			obj.sq_IntVectPush(ENUM_MAGIC_CANNON_SUBSTATE_LAND);
			 		
		obj.sq_IntVectPush(obj.getXPos()); 
		obj.sq_IntVectPush(obj.getYPos()); 
		obj.sq_IntVectPush(obj.getZPos()); 
		obj.sq_AddSetStatePacket(STATE_MAGIC_CANNON , STATE_PRIORITY_USER, true);
		return true;
	}	
	return false;

}

function checkCommandEnable_MagicCannon(obj)
{
	if(!obj)
		return false;
	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK) {
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_MAGIC_CANNON);
	}
	
	return true;
}

function onProc_MagicCannon(obj)
{
	if(!obj)
		return;
		
	local myCannon = obj.getMyPassiveObject(24227,0);
	if(myCannon) {
		if(sq_GetCurrentFrameIndex(myCannon) == 7) {
		}		
	}
}

function onSetState_MagicCannon(obj, state, datas, isResetTimer)
{
	if(!obj) return;

	local subState = sq_GetVectorData(datas, 0);
	obj.setSkillSubState(subState);	
	
	
	if(subState == ENUM_MAGIC_CANNON_SUBSTATE_CHARGE) {
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_AT_MAGIC_CANNON_READY);		
		obj.sq_PlaySound("MW_MCANNON");		
	}
	else if(subState == ENUM_MAGIC_CANNON_SUBSTATE_HORIZON) {
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_AT_MAGIC_CANNON_1);		
	}
	else if(subState == ENUM_MAGIC_CANNON_SUBSTATE_VERTICAL) {
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_AT_MAGIC_CANNON_3);
	}
	else if(subState == ENUM_MAGIC_CANNON_SUBSTATE_DIAGONAL) {
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_AT_MAGIC_CANNON_2);
	}
	else if(subState == ENUM_MAGIC_CANNON_SUBSTATE_LAND) {
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_AT_MAGIC_CANNON_4);
		obj.sq_StopMove();
		obj.sq_PlaySound("MW_MCANNON");
	}
	
	//obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
	//		SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
		
	local x = sq_GetVectorData(datas, 1);
	local y = sq_GetVectorData(datas, 2);
	local z = sq_GetVectorData(datas, 3);
	sq_SetCurrentPos(obj,x,y,z);
	
	
	local element = obj.getThrowElement();
	addElementalChain_ATMage(obj, element);
}

function onEndCurrentAni_MagicCannon(obj)
{
	if(!obj) return;
	
	local subState = obj.getSkillSubState();
	
	if(subState == ENUM_MAGIC_CANNON_SUBSTATE_LAND) {
		obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
		//sq_GetOppositeDirection
		//setStaticMoveInfo(0, skill->getIntData(3, this), skill->getIntData(3, this), false, skill->getIntData(4, this), true);
		//setMoveDirection(getDirection(), ENUM_DIRECTION_NEUTRAL);
	}
	else if(subState == ENUM_MAGIC_CANNON_SUBSTATE_CHARGE) {	// 점프 중 시전 - 준비 동작 끝
		local isHorizon = sq_IsKeyDown(OPTION_HOTKEY_MOVE_LEFT, ENUM_SUBKEY_TYPE_ALL) || sq_IsKeyDown(OPTION_HOTKEY_MOVE_RIGHT, ENUM_SUBKEY_TYPE_ALL);
		local isVertical = sq_IsKeyDown(OPTION_HOTKEY_MOVE_DOWN, ENUM_SUBKEY_TYPE_ALL);
		local subState = ENUM_MAGIC_CANNON_SUBSTATE_DIAGONAL; // 대각선이 기본
		
		if(isHorizon && !isVertical)
			subState = ENUM_MAGIC_CANNON_SUBSTATE_HORIZON;
		else if(!isHorizon && isVertical)
			subState = ENUM_MAGIC_CANNON_SUBSTATE_VERTICAL;	
			
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(subState); 
		obj.sq_IntVectPush(obj.getXPos()); 
		obj.sq_IntVectPush(obj.getYPos()); 
		obj.sq_IntVectPush(obj.getZPos()); 
		obj.sq_AddSetStatePacket(STATE_MAGIC_CANNON , STATE_PRIORITY_USER, true);		
	}
	else { // 매직캐넌 발사가 끝났으면 자유 낙하.
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(1);
		obj.sq_IntVectPush(0);
		obj.sq_IntVectPush(0);
		obj.sq_AddSetStatePacket(STATE_JUMP, STATE_PRIORITY_USER, true);	
	}
}


function onKeyFrameFlag_MagicCannon(obj, flagIndex)
{
	if(!obj) return true;
	
	local subState = obj.getSkillSubState();
	if(flagIndex == 1) {		
		local x = 0;
		local z = 0;
		
		obj.sq_SetStaticMoveInfo(0, 0, 0, false);	
		obj.sq_SetStaticMoveInfo(1, 0, 0, false);	
		sq_SetZVelocity(obj,1,0);
		
		if(subState == ENUM_MAGIC_CANNON_SUBSTATE_LAND) {
			x = 43;
			z = 70;
		}	
		else if(subState == ENUM_MAGIC_CANNON_SUBSTATE_HORIZON) {
			x = 54;
			z = 82;
		}
		else if(subState == ENUM_MAGIC_CANNON_SUBSTATE_DIAGONAL) {
			x = 40;
			z = 40;	
		}
		
		obj.sq_SetMoveDirection(obj.getDirection(), ENUM_DIRECTION_NEUTRAL);
				
		local currentElementalType = obj.getThrowElement();
		if(obj.isMyControlObject())
		{
			sq_BinaryStartWrite();
			sq_BinaryWriteWord(subState);
			sq_BinaryWriteWord(currentElementalType); 
			obj.sq_SendCreatePassiveObjectPacket(24227, 0, x, 1, z);
			printc("MW_MCANNON");
		}
	}
	else if(flagIndex == 2) {
		if(subState == ENUM_MAGIC_CANNON_SUBSTATE_HORIZON) {
			obj.sq_SetStaticMoveInfo(0,  -400,  -400, false);	
			obj.sq_SetStaticMoveInfo(1, 0, 0, false);	
			sq_SetZVelocity(obj,1,0);		
		}
		else if(subState == ENUM_MAGIC_CANNON_SUBSTATE_VERTICAL) {
			sq_SetZVelocity(obj,400,-400);			
		}
		else if(subState == ENUM_MAGIC_CANNON_SUBSTATE_DIAGONAL) {
			obj.sq_SetStaticMoveInfo(0, -200, -200, false);	
			sq_SetZVelocity(obj,200,-200);			
		}
	}
	else if(flagIndex == 3) {	
		obj.sq_SetStaticMoveInfo(0, -800, -800, false, 3500, true);
		obj.sq_SetMoveDirection(obj.getDirection(), ENUM_DIRECTION_NEUTRAL);
		local x = sq_GetDistancePos(0, obj.getDirection(), -20);
		sq_CreateParticleByGlobal(obj.getDustParticleType(LANDPARTICLE_MOVE), obj, x, 0, 0, true, 80, 120, 5);	
	}
	
	return true;

}
