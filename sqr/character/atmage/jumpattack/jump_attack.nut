

// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_JumpAttack(obj, state, datas, isResetTimer)
{	
	if (!obj) return;
}


function onAfterSetState_JumpAttack(obj, state, datas, isResetTimer)
{
	if (!obj) return;
	
	local iceElementalAttackSkillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);
	
	if (state == STATE_JUMP_ATTACK && iceElementalAttackSkillLevel <= 0)
	{
		// 평타 이펙트를 붙인다.
		// 걸려있는 버프 스킬 인덱스 및 서브 스테이트에 따라서 보여지는 이펙트가 다름 (속성에따라서 붙는 이펙트가 다름)
		local element = obj.getThrowElement();
		local attackIndex = obj.getAttackIndex();
		
		local appendage = obj.GetSquirrelAppendage("Character/ATMage/ElementalChange/ap_ATMage_Elemental_Change.nut");
		if (!appendage || !appendage.isValid())
			element = ENUM_ELEMENT_NONE;
			
		
		if (element == ENUM_ELEMENT_FIRE)
		{
			obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATJumpAttack/fire/attack1_fire_normal.ani"), 0, 0);
			obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATJumpAttack/fire/attack1_fire_dodge.ani"), 0, 0);
		}
		else if (element == ENUM_ELEMENT_WATER)
		{
			obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATJumpAttack/water/attack1_water_normal.ani"), 0, 0);
			obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATJumpAttack/water/attack1_water_dodge.ani"), 0, 0);
		}
		else if (element == ENUM_ELEMENT_DARK)
		{
			obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATJumpAttack/dark/attack1_dark_normal.ani"), 0, 0);
			obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATJumpAttack/dark/attack1_dark_dodge.ani"), 0, 0);
		}
		else if (element == ENUM_ELEMENT_LIGHT)
		{
			obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATJumpAttack/light/attack1_light_normal.ani"), 0, 0);
			obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATJumpAttack/light/attack1_light_dodge.ani"), 0, 0);
		}
		else if (element == ENUM_ELEMENT_NONE)
		{
			obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATJumpAttack/attack1_none_normal.ani"), 0, 0);
			obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATJumpAttack/attack1_none_dodge.ani"), 0, 0);
		}
	}
}



// 공격시 마법 구체를 생성한다.
function onKeyFrameFlag_JumpAttack(obj, flagIndex)
{
	if(!obj)
		return false;

	if (obj.sq_IsMyControlObject() && (flagIndex == 1 || flagIndex == 2))
	{
		local xPos = 29, zPos = 54;
		if (flagIndex == 2)
		{
			xPos = 32, zPos = 76;
		}
		
		// 마법구체를 생성한다.
		createMiniMagicCircle(obj, xPos, zPos, 1, 0); // direction 0:정면  1:대각선  2:하단
		
		if (obj.getDirection() == ENUM_DIRECTION_LEFT)
			xPos = -xPos;

		local element = obj.getThrowElement();
		local effectFile = "Character/Mage/Effect/Animation/ATJumpAttack/attack1_none_dodge_obj.ani";
		
		if (element == ENUM_ELEMENT_FIRE)
			effectFile = "Character/Mage/Effect/Animation/ATJumpAttack/fire/attack1_fire_dodge_obj.ani";
		else if (element == ENUM_ELEMENT_WATER)
			effectFile = "Character/Mage/Effect/Animation/ATJumpAttack/water/attack1_water_dodge_obj.ani";
		else if (element == ENUM_ELEMENT_DARK)
			effectFile = "Character/Mage/Effect/Animation/ATJumpAttack/dark/attack1_dark_dodge_obj.ani";
		else if (element == ENUM_ELEMENT_LIGHT)
			effectFile = "Character/Mage/Effect/Animation/ATJumpAttack/light/attack1_light_dodge_obj.ani";
		
		createAnimationPooledObject(obj, effectFile, true, obj.getXPos() + xPos, obj.getYPos() + 1, obj.getZPos() + zPos);		
		
		local attackIndex = 0;
		playSoundForAtmageAttack(obj, element, attackIndex);
	}
	else if (flagIndex == 10)
	{
		// 수인체를 배웠을때, 공중에서 때리면 적이 2대를 맞게됨
		obj.resetHitObjectList();
	}

	return true;
}
