/************************************************
************************************************
// 캐릭터 위치에서 생성되는 큰 폭발 오브젝트
************************************************
************************************************/

// 화수명암 순서로 발동됨
// 속성발동에 의해서 선택된 속성이 가장 마지막에 발동됩니다.
SUB_STATE_ELEMENTAL_BUSTER_START	<- 0

VAR_ELEMENTAL_BUSTER_COUNT			<- 0;
VAR_ELEMENTAL_BUSTER_TYPE			<- 1;
VAR_ELEMENTAL_BUSTER_IS_LAST		<- 2;

function isElementalBusterCastingState(subState)
{
	return subState%2 == 0;
}

function isLastElementalBusterAttack(obj)
{
	local var = obj.getVar();
	local count = var.getInt(VAR_ELEMENTAL_BUSTER_COUNT);		
	local maxCount = obj.sq_GetLevelData(SKILL_ELEMENTAL_BUSTER, 4);
	
	if(count+1 >= maxCount)
		return true;
	return false;
}

function getStartElementalBuster(element, totalCount)
{	
	if(element == ENUM_ELEMENT_NONE)
		return ENUM_ELEMENT_FIRE;
		
	if (element == ENUM_ELEMENT_FIRE)
		element = ENUM_ELEMENT_LIGHT;
	else if (element == ENUM_ELEMENT_WATER)
		element = ENUM_ELEMENT_FIRE;
	else if (element == ENUM_ELEMENT_DARK)
		element = ENUM_ELEMENT_WATER;
	else if (element == ENUM_ELEMENT_LIGHT)
		element = ENUM_ELEMENT_DARK;
				
	totalCount = totalCount-1;
	if(totalCount <= 1)
		return element;
		
	return getStartElementalBuster(element, totalCount)
}

// 엘레멘탈 버스터 스킬발동
function checkExecutableSkill_ElementalBuster(obj)
{
	if (!obj) return false;

	local isUseSkill = obj.sq_IsUseSkill(SKILL_ELEMENTAL_BUSTER);
	if (isUseSkill)
	{
		// 현재 선택된 속성은, 가장 마지막에 발동한다.
		local element = obj.getThrowElement();
		local maxCount = obj.sq_GetLevelData(SKILL_ELEMENTAL_BUSTER, 4);
		element = getStartElementalBuster(element, maxCount);
		
		printc("element : "+ element);
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_ELEMENTAL_BUSTER_START);		
		obj.sq_IntVectPush(element);
		obj.sq_AddSetStatePacket(STATE_ELEMENTAL_BUSTER, STATE_PRIORITY_IGNORE_FORCE, true);
		return true;
	}	

	return false;
}

function checkCommandEnable_ElementalBuster(obj)
{
	if(!obj) return false;

	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK)
	{
		return obj.sq_IsCommandEnable(SKILL_ELEMENTAL_BUSTER); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_BROKENARROW);
	}
	
	return true;
}


function onProc_ElementalBuster(obj)
{
	if (!obj) return;	
}


// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_ElementalBuster(obj, state, datas, isResetTimer)
{	
	if (!obj) return;
		
	local var = obj.getVar();
	local subState = obj.sq_GetVectorData(datas, 0);
	
	local count = 0;
	local isLast = false;
	local element = ENUM_ELEMENT_FIRE;
	if (subState == SUB_STATE_ELEMENTAL_BUSTER_START)
	{		
		element = obj.sq_GetVectorData(datas, 1);
		var.setInt(VAR_ELEMENTAL_BUSTER_COUNT,0);
		var.setInt(VAR_ELEMENTAL_BUSTER_TYPE, element);
		var.setBool(VAR_ELEMENTAL_BUSTER_IS_LAST, false);
	}
	else
	{
		element = var.getInt(VAR_ELEMENTAL_BUSTER_TYPE);
		count = var.getInt(VAR_ELEMENTAL_BUSTER_COUNT);
		isLast = var.getBool(VAR_ELEMENTAL_BUSTER_IS_LAST);	
	}	
	
	local isCast = isElementalBusterCastingState(subState);
	
	obj.setSkillSubState(subState);
	obj.sq_SetStaticMoveInfo(0, 0, 0, false);
	obj.sq_SetStaticMoveInfo(1, 0, 0, false);

	
	
	local animationIndex = 0;
	local soundTag = "";
	local passiveObjectIndex = 0;
	if (element == ENUM_ELEMENT_FIRE)
	{
		animationIndex = isCast ? 85 : 86;
		passiveObjectIndex = 24290;
		soundTag = "EBUSTER_FIRE";
	}
	else if (element == ENUM_ELEMENT_WATER)
	{
		animationIndex = isCast ? 87 : 88;
		passiveObjectIndex = 24293;
		soundTag = "EBUSTER_ICE";
	}
	else if (element == ENUM_ELEMENT_DARK)
	{
		animationIndex = isCast ? 91 : 92;
		passiveObjectIndex = 24299;
		soundTag = "EBUSTER_DARK";
	}
	else if (element == ENUM_ELEMENT_LIGHT)
	{
		animationIndex = isCast ? 89 : 90;
		passiveObjectIndex = 24296;
		soundTag = "EBUSTER_LIGHT";
	}
			

	if (subState != SUB_STATE_ELEMENTAL_BUSTER_START)
	{
		// 엘레멘탈 버스터는 4속성 모두 걸어준다.
		addElementalChain_ATMage(obj, -1);
	}
	
	local animation = obj.sq_GetCurrentAni();
	local flashTime = 0;

	// 캐스팅
	//animationIndex = ANIMATION_TABLE[animationIndex];
	obj.sq_SetCurrentAnimation(animationIndex);
	
	
	
	if (subState == SUB_STATE_ELEMENTAL_BUSTER_START)
	{
		local skillLevel = sq_GetSkillLevel(obj, SKILL_ELEMENTAL_BUSTER);
		local castTime  = sq_GetCastTime(obj, SKILL_ELEMENTAL_BUSTER, skillLevel);
		local animation = sq_GetCurrentAnimation(obj);
		local castAniTime = animation.getDelaySum(false);

		local speedRate = castAniTime.tofloat() / castTime.tofloat();
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
			SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, speedRate, speedRate);
		sq_StartDrawCastGauge(obj, castAniTime, true);
		obj.sq_PlaySound("MW_EBUSTER_READY");
	}
	else
	{
		obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CONST, SPEED_TYPE_CONST,
			SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
	}
	
	if (!isCast) // 발사
	{
		animation = obj.sq_GetCurrentAni();
		flashTime += animation.getDelaySum(false);
		obj.sq_PlaySound(soundTag);
		
		// 캐릭터 위치에 생성되는 커다란 폭발 오브젝트
		local powerIndex = count%3;				
		local sizeRate = obj.sq_GetLevelData(SKILL_ELEMENTAL_BUSTER, 5);

		local time = 640;
		local shake = 3;
		if (isLastElementalBusterAttack(obj))
		{	// 막타는 사이즈가 크다
			sizeRate = obj.sq_GetLevelData(SKILL_ELEMENTAL_BUSTER, 6);
			time = 800
			shake = 5;			
			powerIndex = 3; // 파워도 쎔
			
			print("isLast");
			// 막타 사운드
			obj.sq_PlaySound("MW_EBUSTER");
		}
		
		local power = obj.sq_GetBonusRateWithPassive(SKILL_ELEMENTAL_BUSTER, STATE_ELEMENTAL_BUSTER, powerIndex, 1.0);
													
													
		// 지정된 위치에 패시브 오브젝트들을 생성한다
		if (obj.sq_IsMyControlObject())
		{
			obj.sq_StartWrite();
			obj.sq_WriteDword(power);
			obj.sq_WriteWord(sizeRate);
			obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndex, 0, 0, 1, 0);
				
			sq_flashScreen(obj, 0, flashTime, 240, 200, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
			obj.sq_SetShake(obj, shake, time);
		}
	}
	else
	{
		if (element == ENUM_ELEMENT_FIRE)		
			obj.sq_PlaySound("EBUSTER_CAST_01");
		else if (element == ENUM_ELEMENT_WATER)		
			obj.sq_PlaySound("EBUSTER_CAST_02");
		else if (element == ENUM_ELEMENT_DARK)		
			obj.sq_PlaySound("EBUSTER_CAST_04");
		else if (element == ENUM_ELEMENT_LIGHT)
			obj.sq_PlaySound("EBUSTER_CAST_03");		
	}
}


// 에니메이션이 끝났음.
function onEndCurrentAni_ElementalBuster(obj)
{
	if (!obj) return;
	local subState = obj.getSkillSubState();
	
	local nextAnimationIndex = obj.getVar().get_vector(0) + 1;
	local nextSubState = subState + 1;
	local isLast = false;
	if(!isElementalBusterCastingState(subState)) // 공격 애니가 끝났다면
	{
		setNextElementalType(obj); // 서브스테이트가 공격이었다면 다음 원소로 변환
		
		local var = obj.getVar();
		local count = var.getInt(VAR_ELEMENTAL_BUSTER_COUNT);		
		local maxCount = obj.sq_GetLevelData(SKILL_ELEMENTAL_BUSTER, 4);
		
		count = count + 1;
		if(count >= maxCount)
		{
			var.setBool(VAR_ELEMENTAL_BUSTER_IS_LAST, true);
			isLast = true;
		}
			
		var.setInt(VAR_ELEMENTAL_BUSTER_COUNT, count);		
	}
		
	if (subState == SUB_STATE_ELEMENTAL_BUSTER_START)
	{
		sq_EndDrawCastGauge(obj);
	}
	
	
	if (!isLast)
	{
		if (obj.sq_IsMyControlObject())
		{
		
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(nextSubState);
			obj.sq_IntVectPush(nextAnimationIndex);
			obj.sq_AddSetStatePacket(STATE_ELEMENTAL_BUSTER, STATE_PRIORITY_IGNORE_FORCE, true);
		}
	}
	else
	{
		if (obj.sq_IsMyControlObject())
			obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	}
}	
	

function onEndState_ElementalBuster(obj, newState)
{
	if (!obj) return;
	
}

function createElementalBusterCircle(obj, element, isLast, flagIndex)
{
	if (obj.sq_IsMyControlObject())
	{
		local passiveObjectIndexBig = 24291;	// 화
		local passiveObjectIndexSmall = 24292;
		if (element == ENUM_ELEMENT_FIRE)
		{
			passiveObjectIndexBig = 24291;	// 화
			passiveObjectIndexSmall = 24292;
		}
		else if (element == ENUM_ELEMENT_WATER)
		{
			passiveObjectIndexBig = 24294;		// 수
			passiveObjectIndexSmall = 24295;
		}
		else if (element == ENUM_ELEMENT_LIGHT)
		{
			passiveObjectIndexBig = 24297;		// 명
			passiveObjectIndexSmall = 24298;
		}
		else if (element == ENUM_ELEMENT_DARK)
		{
			passiveObjectIndexBig = 24300;		// 암
			passiveObjectIndexSmall = 24301;
		}
		

		// 캐릭터 위치에 생성되는 커다란 폭발 오브젝트	
		local var = obj.getVar();
		local count = var.getInt(VAR_ELEMENTAL_BUSTER_COUNT);
		local powerIndex = count%3;		
		local sizeIndex = 5;
		if (isLastElementalBusterAttack(obj))
		{
			powerIndex = 3; // 막타용 파워
			sizeIndex = 6;
		}
			
		local power = obj.sq_GetBonusRateWithPassive(SKILL_ELEMENTAL_BUSTER,
											STATE_ELEMENTAL_BUSTER, powerIndex, 1.0);
		local sizeRate = obj.sq_GetLevelData(SKILL_ELEMENTAL_BUSTER, sizeIndex);
	
	
		obj.sq_StartWrite();
		obj.sq_WriteDword(power);
		obj.sq_WriteWord(sizeRate);
														
		local isLastAttack = isLastElementalBusterAttack(obj);							
		if (flagIndex == 1)
		{	// 큰 폭발 오브젝트
			obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexBig, 0, 150, 2, 110);
			if (isLastAttack && element != ENUM_ELEMENT_MAX)
			{	// 마지막 이라면 더 생성함
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexBig, 0, 100, 0, 110);
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexBig, 0, 80, 0, 110);
			}
		}
		else if (flagIndex == 2)
		{
			// 작은 폭발 오브젝트
			obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexSmall, 0, 187, 2, 229);
			
			// 큰 폭발 오브젝트
			obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexBig, 0, 308, 2, 208);
			
			if (isLastAttack && element != ENUM_ELEMENT_MAX)
			{	// 마지막 이라면 더 생성함
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexSmall, 0, -4, 2, 239);
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexSmall, 0, 157, 0, 229);
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexSmall, 0, 157, 0, 229);
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexBig, 0, 208, 0, 208);
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexBig, 0, 208, 0, 208);
			}
		}
		else if (flagIndex == 3)
		{	// 작은 폭발 오브젝트
			obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexSmall, 0, 310, 2, 98);
			
			if (isLastAttack && element != ENUM_ELEMENT_MAX)
			{	// 마지막 이라면 더 생성함
				// 큰 폭발 오브젝트
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexBig, 0, 278, 2, 328);
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexSmall, 0, 250, 0, 98);
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexSmall, 0, 250, 0, 98);
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexBig, 0, 278, 2, 110);
			}
		}
		else if (flagIndex == 4)
		{
			// 큰 폭발 오브젝트
			obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexBig, 0, 468, 2, 91);
			
			if (isLastAttack && element != ENUM_ELEMENT_MAX)
			{	// 마지막 이라면 더 생성함
				// 작은 폭발 오브젝트
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexSmall, 0, 569, 2, 242);
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexBig, 0, 358, 0, 200);
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexBig, 0, 418, 0, 150);
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexBig, 0, 550, 0, 250);
				obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndexBig, 0, 620, 0, 150);
				
			}
		}
	}
}

function setNextElementalType(obj)
{
	print("setNextElementalType");
	local var = obj.getVar();
	local element = var.getInt(VAR_ELEMENTAL_BUSTER_TYPE);
	
	if(element == ENUM_ELEMENT_NONE)
		return element;
			
	local newElement;
	
	switch(element)
	{
	case ENUM_ELEMENT_FIRE : newElement = ENUM_ELEMENT_WATER; break;
	case ENUM_ELEMENT_WATER : newElement = ENUM_ELEMENT_DARK; break;
	case ENUM_ELEMENT_DARK : newElement = ENUM_ELEMENT_LIGHT; break;
	case ENUM_ELEMENT_LIGHT : newElement = ENUM_ELEMENT_FIRE; break;	
	}
	
	var.setInt(VAR_ELEMENTAL_BUSTER_TYPE, newElement);
	
	return element;
}

// 공격시 마법 구체를 생성한다.
function onKeyFrameFlag_ElementalBuster(obj, flagIndex)
{
	if (!obj) return false;
	local var = obj.getVar();
	local subState = obj.getSkillSubState();
	local element = var.getInt(VAR_ELEMENTAL_BUSTER_TYPE);
	local isLast  = (var.getBool(VAR_ELEMENTAL_BUSTER_IS_LAST)) && (obj.getThrowElement() != ENUM_ELEMENT_NONE);	
	
	createElementalBusterCircle(obj, element, isLast, flagIndex);	
	return true;
}


function getScrollBasisPos_ElementalBuster(obj)
{
	if (!obj) return;
	local subState = obj.getSkillSubState();

	if (obj.isMyControlObject())
	{
		local destX = sq_GetDistancePos(obj.getXPos(), obj.getDirection(), 300);
		local xPos = obj.getXPos();
		local var = obj.getVar();
		local isLast  = var.getBool(VAR_ELEMENTAL_BUSTER_IS_LAST);
		
		if (subState == SUB_STATE_ELEMENTAL_BUSTER_START)
		{
			// 스킬 시전 : 스크롤 시작
			local stateTimer = obj.sq_GetStateTimer();
			xPos = sq_GetUniformVelocity(xPos, destX, stateTimer, 300);
		}
		else if (isLast)
		{
			// 스킬 종료 : 스크롤 종료
			local stateTimer = obj.sq_GetStateTimer();
			xPos = sq_GetUniformVelocity(destX, xPos, stateTimer, 300);
		}
		else
		{
			xPos = destX;
		}
		
		obj.sq_SetCameraScrollPosition(xPos, obj.getYPos(), 0);
		return true;
	}
	
	return false;
}
