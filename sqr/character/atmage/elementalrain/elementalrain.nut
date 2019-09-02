getroottable()["ElementalRainCreatePos"] <- {};
getroottable()["ElementalRainCreatePos"] = [[-76,27],[-108,44],[-129,67],[-79,57],[-50,66],
											[-93,83],[-120,118],[-58,109],[-121,152],[-82,145],
											[-92,180],[39,143],[-49,180],[-5,128],[-7,171],
											[-24,221],[25,184],[-5,128],[43,113],[58,143]];

// 엘레멘탈 레인 서브 스테이트
SUB_STATE_ELEMENTAL_RAIN_CAST		<- 0	// 캐스팅
SUB_STATE_ELEMENTAL_RAIN_JUMP		<- 1	// 점프
SUB_STATE_ELEMENTAL_RAIN_CHARGE		<- 2	// 충전(점프 대기)
SUB_STATE_ELEMENTAL_RAIN_FIRE		<- 3	// 마법구 발사
SUB_STATE_ELEMENTAL_RAIN_LAST		<- 4	// 충전 및 폭발구 생성, 땅으로의 착지


// 엘레멘탈 레인 스킬발동
function checkExecutableSkill_ElementalRain(obj)
{
	if (!obj) return false;

	local isUseSkill = obj.sq_IsUseSkill(SKILL_ELEMENTAL_RAIN);
	if (isUseSkill)
	{
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_ELEMENTAL_RAIN_CAST);
		obj.sq_AddSetStatePacket(STATE_ELEMENTAL_RAIN, STATE_PRIORITY_IGNORE_FORCE, true);
		return true;
	}	

	return false;
}

function checkCommandEnable_ElementalRain(obj)
{
	if(!obj) return false;

	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK)
	{
		return obj.sq_IsCommandEnable(SKILL_ELEMENTAL_RAIN); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_BROKENARROW);
	}

	return true
}


function onProc_ElementalRain(obj)
{
	if (!obj) return;	
	local subState = obj.getSkillSubState();
	
	// 일정 높이이상 점프했다면 멈춤
	if (subState == SUB_STATE_ELEMENTAL_RAIN_JUMP)
	{
		local zPos = obj.sq_GetIntData(SKILL_ELEMENTAL_RAIN, 2);
		
		if (sq_GetZPos(obj) >= zPos)
		{		
			obj.sq_SetCurrentPos(obj, obj.getXPos(), obj.getYPos(), zPos);
			
			if (obj.sq_IsMyControlObject())
			{
				obj.sq_IntVectClear();
				obj.sq_IntVectPush(SUB_STATE_ELEMENTAL_RAIN_CHARGE);
				obj.sq_AddSetStatePacket(STATE_ELEMENTAL_RAIN, STATE_PRIORITY_IGNORE_FORCE, true);
			}
		}
	}
}


// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_ElementalRain(obj, state, datas, isResetTimer)
{	
	if (!obj) return;
		
	local var = obj.getVar();
	local oldSubState = obj.getSkillSubState();
	local subState = obj.sq_GetVectorData(datas, 0);
	obj.setSkillSubState(subState);
	obj.sq_SetStaticMoveInfo(0, 0, 0, false);
	obj.sq_SetStaticMoveInfo(1, 0, 0, false);

	if (subState == SUB_STATE_ELEMENTAL_RAIN_CAST)
	{
		obj.sq_ZStop();
		// 캐스팅
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_ELEMENTAL_RAIN_CAST);
		
		// 이펙트 에니메이션
		obj.sq_AddStateLayerAnimation(1,
			obj.sq_CreateCNRDAnimation("Effect/Animation/ATElementalRain/Cast/1_under_dodge.ani"), 0, 0);
		obj.sq_AddStateLayerAnimation(2,
			obj.sq_CreateCNRDAnimation("Effect/Animation/ATElementalRain/Cast/20_body_dodge.ani"), 0, 0);
			
		// 캐스팅 속도를 따라가도록 설정
		// 캐스팅 속도가 변경되면, 에니메이션 속도도 변경 됩니다.
		// 캐스팅 게이지도 표시를 해줍니다.
		local skillLevel = sq_GetSkillLevel(obj, SKILL_ELEMENTAL_RAIN);
		local castTime  = sq_GetCastTime(obj, SKILL_ELEMENTAL_RAIN, skillLevel);
		local animation = sq_GetCurrentAnimation(obj);
		local castAniTime = animation.getDelaySum(false);
		
		local speedRate = castAniTime.tofloat() / castTime.tofloat();
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
			SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, speedRate, speedRate);

		sq_StartDrawCastGauge(obj, castAniTime, true);		
		obj.sq_PlaySound("MW_ERAIN_READY");

		// 엘레멘탈 레인은 4속성 모두 걸어준다.		
		addElementalChain_ATMage(obj, -1);
	}
	else if (subState == SUB_STATE_ELEMENTAL_RAIN_JUMP)
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_ELEMENTAL_RAIN_JUMP);
		
		sq_SetZVelocity(obj, 750, -1200);
	}
	else if (subState == SUB_STATE_ELEMENTAL_RAIN_CHARGE)
	{
		local zPos = obj.sq_GetIntData(SKILL_ELEMENTAL_RAIN, 2);
		obj.sq_SetCurrentPos(obj, obj.getXPos(), obj.getYPos(), zPos);
		obj.sq_PlaySound("MW_ERAIN");
		
		obj.sq_ZStop();
		// 충전
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_ELEMENTAL_RAIN_JUMP_STAY);
		
			
		// 이펙트 에니메이션
		obj.sq_AddStateLayerAnimation(1,
			obj.sq_CreateCNRDAnimation("Effect/Animation/ATElementalRain/Charge/26_handup_dodge.ani"), 0, 0);
		obj.sq_AddStateLayerAnimation(2,
			obj.sq_CreateCNRDAnimation("Effect/Animation/ATElementalRain/Charge/25_shoot_dodge.ani"), 0, 0);			
			
			
		local skillLevel = sq_GetSkillLevel(obj, SKILL_ELEMENTAL_RAIN);
		local maxNumber = obj.sq_GetLevelData(SKILL_ELEMENTAL_RAIN, 0, skillLevel);
		
		// 최소값과 최대값 사이의 랜덤한 숫자를 가져옴. 
		// 단, 한번 가져온 값은 첫번째 파라미터가 true가 되지 않는 한은 두번 다시 나오지 않음.
		// -1이 나오면 종료. 더이상 값이 없음.
		// min 값음 0 이하가 될수 없음.
		local index = sq_getRandomUnique(true, 0, ::ElementalRainCreatePos.len()); // 초기화				

		if (obj.sq_IsMyControlObject())
		{		
			for (local i = 0; i < maxNumber; ++i)
			{
				if (index < 0)
					break;
					
				local pos = ::ElementalRainCreatePos[index];	
				local x = pos[0];
				local y = sq_getRandom(0, 2)-1;
				local z = pos[1];

				local randElementalType = sq_getRandom(ENUM_ELEMENT_FIRE, ENUM_ELEMENT_MAX);				
				obj.sq_StartWrite();
				obj.sq_WriteWord(randElementalType);
				obj.sq_SendCreatePassiveObjectPacket(24233, 0, x, y, z);

				index = sq_getRandomUnique(false, 0, i % ::ElementalRainCreatePos.len());
			}
		}
	}
	else if (subState == SUB_STATE_ELEMENTAL_RAIN_FIRE)
	{		
		// 마법구 발사
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_ELEMENTAL_RAIN_SHOOT);
		
		// 이펙트 에니메이션
		local angle = sq_GetIntData(obj, SKILL_ELEMENTAL_RAIN, 5);
		local animation = obj.sq_CreateCNRDAnimation("Effect/Animation/ATElementalRain/Shoot/25_shoot_dodge.ani");
		sq_SetfRotateAngle(animation, sq_ToRadian(-angle.tofloat()));
		obj.sq_AddStateLayerAnimation(1, animation, 0, 0);
		sq_SetCustomRotate(obj, sq_ToRadian(-angle.tofloat()));
		
	}
	else if (subState == SUB_STATE_ELEMENTAL_RAIN_LAST)
	{
		// 충전 및 폭발구 생성, 땅으로의 착지
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_ELEMENTAL_RAIN_CHARGE_SHOOT);
		
		
		// 이펙트 에니메이션
		obj.sq_AddStateLayerAnimation(1,
			obj.sq_CreateCNRDAnimation("Effect/Animation/ATElementalRain/ChargeShoot/21_circle_normal.ani"), 0, 0);
		obj.sq_AddStateLayerAnimation(2,
			obj.sq_CreateCNRDAnimation("Effect/Animation/ATElementalRain/ChargeShoot/22_circle_dodge.ani"), 0, 0);
		obj.sq_AddStateLayerAnimation(3,
			obj.sq_CreateCNRDAnimation("Effect/Animation/ATElementalRain/ChargeShoot/23_circle1_normal.ani"), -62, -188);
		obj.sq_AddStateLayerAnimation(4,
			obj.sq_CreateCNRDAnimation("Effect/Animation/ATElementalRain/ChargeShoot/24_circle1_dodge.ani"), -62, -188);
			
		obj.sq_PlaySound("MW_ERAIN_FIN");
	}
}


// 에니메이션이 끝났음.
function onEndCurrentAni_ElementalRain(obj)
{
	if (!obj) return;
	local subState = obj.getSkillSubState();
	
	if (subState == SUB_STATE_ELEMENTAL_RAIN_CAST)
	{
		// 캐스팅 -> 충전
		if (obj.sq_IsMyControlObject())
		{
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(SUB_STATE_ELEMENTAL_RAIN_JUMP);
			obj.sq_AddSetStatePacket(STATE_ELEMENTAL_RAIN, STATE_PRIORITY_IGNORE_FORCE, true);
		}
		sq_EndDrawCastGauge(obj);
	}
	else if (subState == SUB_STATE_ELEMENTAL_RAIN_JUMP)
	{
		if (obj.sq_IsMyControlObject())
		{
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(SUB_STATE_ELEMENTAL_RAIN_CHARGE);
			obj.sq_AddSetStatePacket(STATE_ELEMENTAL_RAIN, STATE_PRIORITY_IGNORE_FORCE, true);
		}
	}
	else if (subState == SUB_STATE_ELEMENTAL_RAIN_CHARGE)
	{
		// 충전 -> 마법구 발사
		if (obj.sq_IsMyControlObject())
		{
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(SUB_STATE_ELEMENTAL_RAIN_FIRE);
			obj.sq_IntVectPush(0);
			obj.sq_AddSetStatePacket(STATE_ELEMENTAL_RAIN, STATE_PRIORITY_IGNORE_FORCE, true);
		}
	}
	else if (subState == SUB_STATE_ELEMENTAL_RAIN_FIRE)
	{
		// 마법구 발사
		local var = obj.getVar();
		local skillLevel = sq_GetSkillLevel(obj, SKILL_ELEMENTAL_RAIN);
		local maxNumber = obj.sq_GetLevelData(SKILL_ELEMENTAL_RAIN, 0, skillLevel);
		
		// 발사할게 남았음.
		local fireEnd = true;
		local ballCount = obj.getMyPassiveObjectCount(24233);			
		for (local i = 0; i < ballCount ; ++i) 
		{ 
			local magicBall = obj.getMyPassiveObject(24233,i)
			if (!magicBall || magicBall.getState() != SUBSTATE_PO_ELEMENTAL_CREATOR_FIRE) {
				fireEnd = false;
				break;
			}
		}
			
		if (!fireEnd)
		{
			if (obj.sq_IsMyControlObject())
			{
				// 마법구 계속 발사
				obj.sq_IntVectClear();
				obj.sq_IntVectPush(SUB_STATE_ELEMENTAL_RAIN_FIRE);			
				obj.sq_AddSetStatePacket(STATE_ELEMENTAL_RAIN, STATE_PRIORITY_IGNORE_FORCE, true);
			}
		}
		else
		{
			if (obj.sq_IsMyControlObject())
			{
				// 마법구 발사 -> 충전 및 폭발구 생성, 땅으로 착지
				obj.sq_IntVectClear();
				obj.sq_IntVectPush(SUB_STATE_ELEMENTAL_RAIN_LAST);
				obj.sq_AddSetStatePacket(STATE_ELEMENTAL_RAIN, STATE_PRIORITY_IGNORE_FORCE, true);
			}
		}
	}
	else if (subState == SUB_STATE_ELEMENTAL_RAIN_LAST)
	{
		// 충전 및 폭발구 생성, 땅으로의 착지
		if (obj.sq_IsMyControlObject())
		{
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(1);
			obj.sq_IntVectPush(0);
			obj.sq_IntVectPush(0);
			obj.sq_AddSetStatePacket(STATE_JUMP, STATE_PRIORITY_USER, true);
		}
	}
}	
	

function onEndState_ElementalRain(obj, newState)
{
	if (!obj) return;
		
	if (newState != STATE_ELEMENTAL_RAIN)
	{
		sq_SetCustomRotate(obj, 0.0);
		
		if (obj.sq_IsMyControlObject())
		{
			local ballCount = obj.getMyPassiveObjectCount(24233);			
			for (local i = 0; i<ballCount ; ++i) 
			{ 
				local magicBall = obj.getMyPassiveObject(24233,i)
				if (!magicBall)
					continue;
				
				if (obj.sq_IsMyControlObject())
					sq_SendDestroyPacketPassiveObject(magicBall);
			}
		}
	}
}


// 공격시 마법 구체를 생성한다.
function onKeyFrameFlag_ElementalRain(obj, flagIndex)
{
	if (!obj) return false;
	local subState = obj.getSkillSubState();
	
	if (subState == SUB_STATE_ELEMENTAL_RAIN_CAST)
	{
		if (flagIndex == 1)
			sq_EffectLayerAppendage(obj, sq_RGB(255,255,255), 255, 0, 0, 240);
	}
	else if (subState == SUB_STATE_ELEMENTAL_RAIN_FIRE)
	{		
		if (flagIndex == 1 && obj.sq_IsMyControlObject())
		{
			local ballCount = obj.getMyPassiveObjectCount(24233);
			printc("ballCount" + ballCount);			
			for (local i = 0; i<ballCount ; ++i)
			{ 
				local magicBall = obj.getMyPassiveObject(24233,i)
				if (!magicBall || magicBall.getState() == SUBSTATE_PO_ELEMENTAL_CREATOR_FIRE)
					continue;
				
				magicBall.sendStateOnlyPacket(SUBSTATE_PO_ELEMENTAL_CREATOR_FIRE);
				break;
			}					
		}				
	}
	else if (subState == SUB_STATE_ELEMENTAL_RAIN_LAST)
	{
		// 충전 및 폭발구 생성, 땅으로의 착지
		if (flagIndex == 1 && obj.sq_IsMyControlObject())
		{
			// 마지막 큰 마법구의 공격력 얻어오기
			local skill = sq_GetSkill(obj, SKILL_ELEMENTAL_RAIN);
			local attackBonusRate = obj.sq_GetBonusRateWithPassive(SKILL_ELEMENTAL_RAIN, STATE_ELEMENTAL_RAIN, 1, 1.0);
				
			obj.sq_StartWrite();
			obj.sq_WriteDword(attackBonusRate);
			print("onKeyFrameFlag_ElementalRain");
			obj.sq_SendCreatePassiveObjectPacket(24219, 0, -73, 1, 215);
		}
	}

	return true;
}

function onEndMap_ElementalRain(obj)
{
	if (obj.sq_IsMyControlObject())
	{
		local ballCount = obj.getMyPassiveObjectCount(24233);			
		printc("ballCount" + ballCount);
		for (local i = 0; i<ballCount ; ++i) 
		{ 
			local magicBall = obj.getMyPassiveObject(24233,i)
			if (!magicBall)
				continue;
			
			if (obj.sq_IsMyControlObject())
			{
				print("onEndMap_ElementalRain");
				sq_SendDestroyPacketPassiveObject(magicBall);
			}
		}
	}
}
