

// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_ATMageDashAttack(obj, state, datas, isResetTimer)
{	
	if (!obj)
		return;

	local skillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);

	// 수인체를 배웠음.
	if (skillLevel > 0)
	{
		local isPress = sq_IsKeyDown(OPTION_HOTKEY_MOVE_UP, ENUM_SUBKEY_TYPE_ALL) || sq_IsKeyDown(OPTION_HOTKEY_MOVE_DOWN, ENUM_SUBKEY_TYPE_ALL);
		
		// 대시 공격시, 앞으로 전진 처리
		if(!isPress)
			obj.sq_SetStaticMoveInfo(0, 450, 450, false, -500, true);
		
		// 기본기 숙련 적용	
		obj.applyBasicAttackUp(sq_GetCurrentAttackInfo(obj),obj.getState());		
		sq_SetCurrentAttackInfo(obj, sq_GetCurrentAttackInfo(obj));
	}
	else
	{
		// 대시 공격시, 앞으로 전진 처리
		obj.sq_SetStaticMoveInfo(0, 450, 450, false, -500, true);
	}
}

// 대시 공격시 마법 구체를 생성한다.
function onKeyFrameFlag_ATMageDashAttack(obj, flagIndex)
{
	if(!obj)
		return false;
	if (flagIndex == 1)
	{
		// 마법구체를 생성한다.
		if (obj.sq_IsMyControlObject())
		{
			// 생성할 패시브 오브젝트의 인덱스
			local passiveObjectIndex = 24261;
			local power = -25;
			// 수인체 스킬의 레벨
			local skillLevel = sq_GetSkillLevel(obj, SKILL_ELEMENTAL_CHANGE);

			// 속성발동 appendage에 걸려있는지 체크함.
			local element = obj.getThrowElement();
			
			// 속성발동에 걸려있지 않다면 무속성 평타가 발사됨
			local appendage = obj.GetSquirrelAppendage("Character/ATMage/ElementalChange/ap_ATMage_Elemental_Change.nut");
			if (!appendage || !appendage.isValid())
				element = ENUM_ELEMENT_NONE;

			if (element != ENUM_ELEMENT_NONE)
			{
				if (element == ENUM_ELEMENT_FIRE)
					passiveObjectIndex = 24262;
				else if (element == ENUM_ELEMENT_WATER)
					passiveObjectIndex = 24263;
				else if (element == ENUM_ELEMENT_DARK)
					passiveObjectIndex = 24264;
				else if (element == ENUM_ELEMENT_LIGHT)
					passiveObjectIndex = 24265;
			}
			else 
			{
				//기본기 숙련
				sq_SetCurrentAttackBonusRate(sq_GetCurrentAttackInfo(obj),power);
				obj.applyBasicAttackUp(sq_GetCurrentAttackInfo(obj),obj.getState());					
				power = sq_GetCurrentAttackBonusRate(obj);
			}
			
			obj.sq_StartWrite();
			obj.sq_WriteWord(80);	// 폭발의 사이즈(%)
			obj.sq_WriteWord(power);	// 폭발의 공격력(%)
			obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndex, 0, 100, 1, 55);
		}
	}

	return true;
}
