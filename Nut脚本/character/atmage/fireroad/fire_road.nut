
function checkExecutableSkill_FireRoad(obj)
{
	if (!obj) return false;

	local isUseSkill = obj.sq_IsUseSkill(SKILL_FIRE_ROAD);
	if (isUseSkill) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(0);	// subState셋팅
		obj.sq_AddSetStatePacket(STATE_FIRE_ROAD, STATE_PRIORITY_USER, true);
		return true;
	}
	return false;

}

function checkCommandEnable_FireRoad(obj)
{
	if(!obj)
		return false;
	local state = obj.sq_GetState();
		
	if(state == STATE_ATTACK)
	{
		return obj.sq_IsCommandEnable(SKILL_FIRE_ROAD); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_BROKENARROW);
	}
		
	return true;
}

function onEndState_FireRoad(obj, state)
{
	// 스테이트 종료 혹은 취소 되었다면 캐스팅 게이지 없앰
	sq_EndDrawCastGauge(obj);
}


function onSetState_FireRoad(obj, state, datas, isResetTimer)
{
	if (!obj) return;

	obj.sq_StopMove();
	
	
	local subState = obj.sq_GetVectorData(datas, 0);	// subState
	obj.sq_SetSkillSubState(obj, subState);
	
	if (subState == 0)
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_FIRE_ROAD_CAST1);
		obj.sq_PlaySound("MW_FIREROAD");
		
		// 캐스팅 속도를 따라가도록 설정
		// 캐스팅 속도가 변경되면, 에니메이션 속도도 변경 됩니다.
		// 캐스팅 게이지도 표시를 해줍니다.
		local skillLevel = sq_GetSkillLevel(obj, SKILL_FIRE_ROAD);
		local castTime = sq_GetCastTime(obj, SKILL_FIRE_ROAD, skillLevel);
		local animation = sq_GetCurrentAnimation(obj);
		obj.sq_Rewind(animation);
		sq_SetFrameDelayTime(animation, 0, castTime);
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
			SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
		sq_StartDrawCastGauge(obj, castTime, true);
		
		addElementalChain_ATMage(obj, ENUM_ELEMENT_FIRE);
	}
	else if (subState == 1)
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_FIRE_ROAD_CAST2);
	}
}



// prepareDraw
function prepareDraw_FireRoad(obj)
{
	if (!obj) return;
}



// onEndCurrentAni
function onEndCurrentAni_FireRoad(obj)
{
	if (!obj) return;
	
	
	if (obj.sq_GetSkillSubState(obj) == 0) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(1);	// subState셋팅
		obj.sq_AddSetStatePacket(STATE_FIRE_ROAD, STATE_PRIORITY_USER, true);
	}
	else if (obj.sq_GetSkillSubState(obj) == 1) {
		obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	}
}




// onKeyFrameFlag
function onKeyFrameFlag_FireRoad(obj, flagIndex)
{
	if (!obj) return true;

	local skillSubState = obj.sq_GetSkillSubState(obj);

	if (skillSubState == 0) {

		local skillLevel = obj.sq_GetSkillLevel(SKILL_FIRE_ROAD);	
		local pauseTime = obj.sq_GetIntData(SKILL_FIRE_ROAD, 0);	// 오브젝트 생성간격(시간)
		local xPos = obj.sq_GetIntData(SKILL_FIRE_ROAD, 1);			// 오브젝트 생성위치(캐릭터로 부터 몇픽셀 떨어져 생성되는지?)
		local xOffset = obj.sq_GetIntData(SKILL_FIRE_ROAD, 2);		// 오브젝트 생성간격(오브젝트간의 생성 간격)
		local maxHit = obj.sq_GetIntData(SKILL_FIRE_ROAD, 3);		// 오브젝트당 최대 히트수
		local sizeRate = obj.sq_GetIntData(SKILL_FIRE_ROAD, 5);		// 오브젝트의 확대율(%)

		// 오브젝트 생성 갯수
		local createCount = obj.sq_GetLevelData(SKILL_FIRE_ROAD, 0, skillLevel);
		local damage1 = obj.sq_GetBonusRateWithPassive(SKILL_FIRE_ROAD, STATE_FIRE_ROAD, 1, 1.0);	// 공격력1(%)
		local damage2 = obj.sq_GetBonusRateWithPassive(SKILL_FIRE_ROAD, STATE_FIRE_ROAD, 2, 1.0);	// 공격력2(%)
	
		printc("createCount " + createCount);
		
		// 특성 스킬을 배웠다면 여러줄이(세로) 생성된다.
		local rowNumber = obj.sq_GetIntData(SKILL_FIRE_ROAD, 4);
		local yAxisDistance = 55;
		
		for (local i = 0; i < createCount; i++)
		{
			if (obj.isMyControlObject())
			{
				obj.sq_StartWrite();
				obj.sq_WriteWord(pauseTime * i);// 생성간격(시간)
				obj.sq_WriteDword(damage1);		// 데미지1
				obj.sq_WriteDword(damage2);		// 데미지2
				obj.sq_WriteByte(maxHit);		// 오브젝트당 최대 히트수
				obj.sq_WriteByte(i);			// 현재 생성한 번째. (사운드 출력용)
				obj.sq_WriteWord(sizeRate);		// 오브젝트의 확대율(%)
				
				printc("number " +i);
				// 24212, 24213을 번갈아가면서 생성한다.
				local passiveObjectIndex = 24212 + i % 2;
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndex, 0, xPos + xOffset * i, 1, 0);
				
				
				// 특성 스킬을 배웠다면 여러줄이(세로) 생성된다.
				if (rowNumber > 0)
				{
					for (local j = 0; j < rowNumber; j+=1)
					{
						local row = (j + 2) / 2;
						row = row.tointeger();
	
						if ((j % 2) == 0)
						{	// 위쪽
							local y = row * yAxisDistance;
							obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndex, 0, xPos + xOffset * i, -y, 0);
						}
						else
						{	// 아래쪽
							local y = row * yAxisDistance;
							obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndex, 0, xPos + xOffset * i, y, 0);
						}
					}
				}
			}
		}
	}

	return true;

}


