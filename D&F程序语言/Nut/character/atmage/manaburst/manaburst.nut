
SUB_STATE_MANABURST_0	<- 0
SUB_STATE_MANABURST_1	<- 1
SUB_STATE_MANABURST_2	<- 2
SUB_STATE_MANABURST_3	<- 3
SUB_STATE_MANABURST_4	<- 4

function checkExecutableSkill_ManaBurst(obj)
{

	if(!obj) return false;
	
	local state = obj.sq_GetState();
	
	// 패시브틱한 액티브스킬이라 이곳에서 행동조건을 겁니다.
	// ManaBurst.skl [executable states] 은 -1을 세팅해줬습니다.
	// 이것은 모든스킬에서 공격력을 높여줘야한다는 스킬기능 때문입니다.
	if(state == STATE_STAND || state == STATE_ATTACK || state == STATE_DASH) 
	{	

		local b_useskill = obj.sq_IsUseSkill(SKILL_MANABURST);
		
		if (b_useskill)
		{
			/*
			# STATE_THROW
			[0]   Throw State (0:모으기, 1:던지기, 2:개인시전)
			* Throw State 0 *
			[1]   던지는 타입 (ENUM_THROW_TYPE)
			[2]   던지는 대상의 인덱스 (스킬 인덱스 or 아이템 인덱스)
			[3]   모으는 시간
			[4]   발사 시간
			[5]   던지기 애니메이션 타입 (0 or 1)
			[6]   모으기 속도 타입
			[7]   발사 속도 타입
			[8]   모으기 속도 (안넣으면 SPEED_VALUE_DEFAULT)
			[9]   발사 속도 (안넣으면 SPEED_VALUE_DEFAULT)
			[10]	개인시전 범위 (안넣거나 -1이면 개인시전 안함)
			* Throw State 1 *
			// Throw State 2에서 넘어왔을 경우에만
			[1]	개인 시전시 대상 Object Id
			* Throw State 2 *
			*/
			local skillLevel = sq_GetSkillLevel(obj, SKILL_MANABURST);
			local castTime = sq_GetCastTime(obj, SKILL_MANABURST, skillLevel);

			obj.sq_IntVectClear();				
			obj.sq_IntVectPush(0);		// throwState
			obj.sq_IntVectPush(0);		// throwType
			obj.sq_IntVectPush(SKILL_MANABURST);	// throwIndex
			obj.sq_IntVectPush(castTime);	// throwChargeTime
			obj.sq_IntVectPush(500);	// throwShootTime
			obj.sq_IntVectPush(0);		// throwAnimationIndex
			obj.sq_IntVectPush(4);		// chargeSpeedType
			obj.sq_IntVectPush(4);		// throwShootSpeedType
			obj.sq_IntVectPush(1000);	// chargeSpeedValue
			obj.sq_IntVectPush(1000);	// throwShootSpeedValue
			obj.sq_IntVectPush(-1);		// personalCastRange
			obj.sq_AddSetStatePacket(STATE_THROW, STATE_PRIORITY_USER, true);
			//obj.sq_AddSetStatePacket(STATE_ELEMENTAL_CHANGE, STATE_PRIORITY_USER, false);
			return true;
		}
	}

	return false;

}

function checkCommandEnable_ManaBurst(obj)
{

	if(!obj) return false;

	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK) {
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_MANABURST);
	}
	

	if(state == STATE_STAND || state == STATE_ATTACK || state == STATE_DASH) 
	{
		return true;
	}
	
	return false;

}

