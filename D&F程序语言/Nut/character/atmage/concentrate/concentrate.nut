
// 컨센트레이트 버스터 스킬발동
function checkExecutableSkill_Concentrate(obj)
{
	if (!obj) return false;

	local isUseSkill = obj.sq_IsUseSkill(SKILL_CONCENTRATE_EX);
	if (isUseSkill)
	{
		obj.sq_AddSetStatePacket(STATE_CONCENTRATE_EX, STATE_PRIORITY_IGNORE_FORCE, false);		
		return true;
	}	

	return false;
}


function checkCommandEnable_Concentrate(obj)
{
	if(!obj) return false;
	
	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK)
	{
		return obj.sq_IsCommandEnable(SKILL_CONCENTRATE_EX); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_BROKENARROW);
	}

	return true;
}


function onProc_Concentrate(obj)
{
	if (!obj) return;	
}


// state를 세팅하고 처음으로 들어오게 됩니다.
// 각종 리소스를 세팅합니다. 
function onSetState_Concentrate(obj, state, datas, isResetTimer)
{	
	if (!obj) return;
	
	obj.sq_SetStaticMoveInfo(0, 0, 0, false);
	obj.sq_SetStaticMoveInfo(1, 0, 0, false);
	
	
	// 엘레멘탈 버스터는 4속성 모두 걸어준다.
	local element = obj.getThrowElement();
	addElementalChain_ATMage(obj, element);
		
		
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_CONCENTRATE_EX);		

	// 사운드 플레이	
	obj.sq_PlaySound("MW_CONCENTRATE");
}


// 에니메이션이 끝났음.
function onEndCurrentAni_Concentrate(obj)
{
	if (!obj) return;

	if (obj.sq_IsMyControlObject())
		obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}	
	

function onEndState_Concentrate(obj, newState)
{
	if (!obj) return;
}


// 공격시 마법 구체를 생성한다.
function onKeyFrameFlag_Concentrate(obj, flagIndex)
{
	if (!obj) return false;
	
	if (flagIndex == 1)
	{
		obj.sq_PlaySound("BREAKING_RUSH");
		if (obj.sq_IsMyControlObject())
		{
			local level = obj.sq_GetSkillLevel(SKILL_CONCENTRATE_EX);
			
			// 바운딩되는 횟수
			// 이동속도는 파티클 정보를 수정하면 됩니다. (ATConcentrate.ptl)
			local maxBoundNumber = obj.sq_GetIntData(SKILL_CONCENTRATE_EX, 0);
			
			// 작은 폭발의 공격력
			local smallExpBonusRate = obj.sq_GetBonusRateWithPassive(SKILL_CONCENTRATE_EX, STATE_CONCENTRATE_EX, 0, 1.0);
			local bigExpBonusRate = obj.sq_GetBonusRateWithPassive(SKILL_CONCENTRATE_EX, STATE_CONCENTRATE_EX, 1, 1.0);
			local bigExpSizeRate = obj.sq_GetLevelData(SKILL_CONCENTRATE_EX, 2, level);
			
			
			// 캐스팅 게이지 설정하기
			
			obj.sq_StartWrite();
			obj.sq_WriteWord(maxBoundNumber);
			obj.sq_WriteDword(smallExpBonusRate);
			obj.sq_WriteDword(bigExpBonusRate);
			obj.sq_WriteWord(bigExpSizeRate);
			obj.sq_WriteByte(obj.getThrowElement());
			obj.sq_SendCreatePassiveObjectPacket(24286, 0, 73, 1, 47);
		}
	}
	
	return true;
}


