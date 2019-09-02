// 어펜디지만을 붙이고 상세기능은 어펜디지에서 다 한다.


function checkExecutableSkill_LightningWall(obj)
{
	if(!obj) return false;

	local b_useskill = obj.sq_IsUseSkill(SKILL_LIGHTNING_WALL);
	if(b_useskill) {
		obj.sq_AddSetStatePacket(STATE_LIGHTNING_WALL , STATE_PRIORITY_USER, false);
		return true;
	}	
	return false;

}

function checkCommandEnable_LightningWall(obj)
{
	if(!obj)
		return false;

	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK) {
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_LIGHTNING_WALL);
	}
	
	return true;
}

function onEndState_LightningWall(obj, newState)
{
	if(!obj)
		return;

	if(newState != STATE_LIGHTNING_WALL) 
		setLightningWallState(obj, PO_LIGHTNING_WALL_DESTROY);
}

function onSetState_LightningWall(obj, state, datas, isResetTimer)
{
	if(!obj) return;
	
	obj.sq_StopMove();
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_LIGHTNING_WALL);
	
	// 캐스팅 속도를 따라가도록 설정
	// 캐스팅 속도가 변경되면, 에니메이션 속도도 변경 됩니다.
	// 캐스팅 게이지도 표시를 해줍니다.
	local skillLevel = sq_GetSkillLevel(obj, SKILL_LIGHTNING_WALL);
	local castTime  = sq_GetCastTime(obj, SKILL_LIGHTNING_WALL, skillLevel);
	local animation = sq_GetCurrentAnimation(obj);
	local castAniTime = sq_GetFrameStartTime(animation, 6);
	local speedRate = castAniTime.tofloat() / castTime.tofloat();
	obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
		SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, speedRate, speedRate);

	sq_StartDrawCastGauge(obj, castAniTime, true);
	
	local var = obj.getVar();
	var.setBool(0,false);
	addElementalChain_ATMage(obj, ENUM_ELEMENT_LIGHT);
}

function setLightningWallState(obj, state)
{
	if(!obj || !obj.isMyControlObject())
		return;
		
	local count = obj.getMyPassiveObjectCount(24218);
	
	for(local i =0; i<count ; ++i) {
		local wall = obj.getMyPassiveObject(24218,i);
		if(wall) {
			local var = obj.getVar();	
			local isSendMove = var.getBool(0);
	
			if(state == PO_LIGHTNING_WALL_DESTROY) // 이미 이동중일땐 모션이 취소 됐다고 사라지지 않는다.
			{
				if(wall.getState() != PO_LIGHTNING_WALL_MOVE)
					wall.sendStateOnlyPacket(PO_LIGHTNING_WALL_DESTROY);
			}
			else
			{
				wall.sendStateOnlyPacket(state);
			}
		}
	}
}

function onEndCurrentAni_LightningWall(obj)
{
	if(!obj) return;
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

function onProc_LightningWall(obj)
{
	if(!obj)
		return;
	local var = obj.getVar();	
	
	if(obj.isMyControlObject() && var.getBool(0) == false && sq_GetCurrentFrameIndex(obj) > 20)
	{
		setLightningWallState(obj,PO_LIGHTNING_WALL_MOVE);			
		sq_flashScreen(obj, 0, 1000,500, 180, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);

		var.setBool(0,true);
		obj.sq_PlaySound("LIGHTWALL_SHOT");
	}	
}

function onKeyFrameFlag_LightningWall(obj, flagIndex)
{
	if(!obj) return true;	
	if (flagIndex == 1) {
		sq_EndDrawCastGauge(obj);
		sq_EffectLayerAppendageOnlyBody(obj, sq_RGB(255,255,255), 255, 0, 0, 320);
		
		if(obj.isMyControlObject()) {			
			local yByDirection = -1; 
			if(obj.getDirection() != ENUM_DIRECTION_RIGHT)
				yByDirection = 1;
						
			local moveDistance	= sq_GetIntData(obj, SKILL_LIGHTNING_WALL, 2); //2: 이동 거리
			local attackPower	= obj.sq_GetBonusRateWithPassive(SKILL_LIGHTNING_WALL , STATE_LIGHTNING_WALL, 0, 1.0);		
			local skill_level	= sq_GetSkillLevel(obj, SKILL_LIGHTNING_WALL);
			local prob			= sq_GetLevelData(obj, SKILL_LIGHTNING_WALL, 2, skill_level)/10.0; // 2. 감전 확률 (0.1%)
			local level			= sq_GetLevelData(obj, SKILL_LIGHTNING_WALL, 1, skill_level); // 1. 감전 레벨
			local duration		= sq_GetLevelData(obj, SKILL_LIGHTNING_WALL, 4, skill_level); // 4. 지속시간
			local lightDamage	= sq_GetLevelData(obj, SKILL_LIGHTNING_WALL, 3, skill_level); // 3. 감전 공격력
	
							
			// 라이트닝 월 생성
			obj.sq_StartWrite();
			obj.sq_WriteDword(moveDistance); // 목적지 x 좌표
			obj.sq_WriteDword(attackPower);
			obj.sq_WriteDword(skill_level);
			obj.sq_WriteFloat(prob);
			obj.sq_WriteDword(level);
			obj.sq_WriteDword(duration);
			obj.sq_WriteDword(lightDamage);
			obj.sq_SendCreatePassiveObjectPacket(24218, 0, 50, -1, 0);
		}
	}
	else if (flagIndex == 2) {		
		sq_EffectLayerAppendageOnlyBody(obj, sq_RGB(255,255,255), 255, 0, 0, 400);
	}
	else if (flagIndex == 3) {
		// 라이트닝 월 이동	
		sq_SetMyShake(obj,4,300);
	}	
	return true;
}

