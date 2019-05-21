
function checkExecutableSkill_IceSword(obj)
{
	if(!obj) return false;

	local b_useskill = obj.sq_IsUseSkill(SKILL_ICE_SWORD);
	if(b_useskill) {		
		obj.sq_AddSetStatePacket(STATE_ICE_SWORD, STATE_PRIORITY_USER, false);
		return true;
	}		
	return false;
}

function checkCommandEnable_IceSword(obj)
{
	if(!obj) return false;

	local state = obj.sq_GetState();	
	if(state == STATE_ATTACK) {
		return obj.sq_IsCommandEnable(SKILL_ICE_SWORD);
	} 

	return true;
}

function onSetState_IceSword(obj, state, datas, isResetTimer)
{
	if(!obj) return;
	
	obj.sq_StopMove();
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_ICE_SWORD);
	
	// 크로니클 아이템 작업 스킬 공격속도 증가 데이타 (100~)
	local speed100Rate = obj.sq_GetIntData(SKILL_ICE_SWORD, 0); // 0. 크로니클 아이템 작업) 스킬 공격속도 증가 데이타 (100~)
	local speedRate = speed100Rate.tofloat() / 100.0;
	
	obj.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_INFO_ICE_SWORD);	
	obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
			SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, speedRate, speedRate);
	//obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
			//SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);	
	
	// 컨버전 스킬을 적용한다.
	obj.sq_SetApplyConversionSkill();
	
	local damage = obj.sq_GetBonusRateWithPassive(SKILL_ICE_SWORD , STATE_ICE_SWORD, 0, 1.0);
	obj.sq_SetCurrentAttackBonusRate(damage);		
	obj.sq_setCustomHitEffectFileName("Character/Mage/Effect/Animation/ATIceSword/05_2_smoke_dodge .ani");	
	
	addElementalChain_ATMage(obj, ENUM_ELEMENT_WATER);
	
	
	// 특성 스킬을 위함
	// 빙백검 강화를 익혔다면 3타가 작동하지 않고, 1, 2타를 한번더 반복한다.
	local skillLevel = sq_GetSkillLevel(obj, SKILL_ICE_SWORD_EX);
	if (skillLevel > 0)
	{
		local var = obj.getVar();
		var.clear_vector();
		var.push_vector(0);
	}
}


function onEndCurrentAni_IceSword(obj)
{
	if(!obj) return;

	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

function onAttack_IceSword(obj, damager, boundingBox, isStuck)
{
	if (!obj || !damager) return;
	
	sq_EffectLayerAppendage(damager,sq_RGB(0,144,255),150,0,0,240);	
}


function onKeyFrameFlag_IceSword(obj, flagIndex)
{
	if(!obj) return true;
	
	if (flagIndex == 1)
	{
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_INFO_ICE_SWORD);
		// 컨버전 스킬을 적용한다.
		obj.sq_SetApplyConversionSkill();
	
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_ICE_SWORD , STATE_ICE_SWORD, 0, 1.0);
		obj.sq_SetCurrentAttackBonusRate(damage);				
	}
	else if (flagIndex == 2)
	{
		//막타
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_INFO_ICE_SWORD_LAST);	
		// 컨버전 스킬을 적용한다.
		obj.sq_SetApplyConversionSkill();
		
		local skill_level	= sq_GetSkillLevel(obj, SKILL_ICE_SWORD);
		local damage = obj.sq_GetBonusRateWithPassive(SKILL_ICE_SWORD , STATE_ICE_SWORD, 1, 1.0);
		obj.sq_SetCurrentAttackBonusRate(damage);	
		
		local skill_level	= sq_GetSkillLevel(obj, SKILL_ICE_SWORD);	
		local attackInfo = sq_GetCurrentAttackInfo(obj);
		
		printc("attackInfo " + attackInfo);
		if (!attackInfo) return;
		
		// 0.1,2타 공격력%   1.막타 공격력%  2.이속 감소 레벨   3.이속감소 확률   4.이속감소 시간   
		local ice_power	= sq_GetLevelData(obj, SKILL_ICE_SWORD, 2, skill_level);
		local ice_prob	= sq_GetLevelData(obj, SKILL_ICE_SWORD, 3, skill_level);
		local ice_time	= sq_GetLevelData(obj, SKILL_ICE_SWORD, 4, skill_level);
		
		sq_SetChangeStatusIntoAttackInfo(attackInfo, 0, ACTIVESTATUS_SLOW, ice_prob, ice_power, ice_time);		
	}
	else if (flagIndex == 3)
	{
		// 특성 스킬을 위함
		// 빙백검 강화를 익혔다면 3타가 작동하지 않고, 1, 2타를 한번더 반복한다.
		local skillLevel = sq_GetSkillLevel(obj, SKILL_ICE_SWORD_EX);	
		if (skillLevel > 0)
		{
			// 결투장에서는 작동하지 않는다.
			if (checkModuleType(MODULE_TYPE_PVP_TYPE))
				return true;
			
			obj.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_INFO_ICE_SWORD);
			// 컨버전 스킬을 적용한다.
			obj.sq_SetApplyConversionSkill();
	
			local damage = obj.sq_GetBonusRateWithPassive(SKILL_ICE_SWORD , STATE_ICE_SWORD, 0, 1.0);
			obj.sq_SetCurrentAttackBonusRate(damage);
			
			// 0.1,2타 공격력%   1.막타 공격력%  2.이속 감소 레벨   3.이속감소 확률   4.이속감소 시간
			local skill_level = sq_GetSkillLevel(obj, SKILL_ICE_SWORD);
			local attackInfo = sq_GetCurrentAttackInfo(obj);
			local ice_power = sq_GetLevelData(obj, SKILL_ICE_SWORD, 2, skill_level);
			local ice_prob = sq_GetLevelData(obj, SKILL_ICE_SWORD, 3, skill_level);
			local ice_time = sq_GetLevelData(obj, SKILL_ICE_SWORD, 4, skill_level);
			sq_SetChangeStatusIntoAttackInfo(attackInfo, 0, ACTIVESTATUS_SLOW, ice_prob, ice_power, ice_time);		
		
		
			local var = obj.getVar();
			local flag = var.get_vector(0);
			
			if (flag <= 0)
			{	// 첫 프레임으로 되돌린다.
				local animation = sq_GetCurrentAnimation(obj);
				obj.sq_SetCurrentTimeByFrame(animation, 0);
				var.set_vector(0, 1);
			}
			else
			{
				// 스킬을 종료시킨다.
				if (obj.isMyControlObject())
					obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
			}
		}
	}
		
	return true;
}