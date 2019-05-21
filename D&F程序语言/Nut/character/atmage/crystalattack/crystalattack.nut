getroottable()["CrystalAttackCreatePos"] <- {};
getroottable()["CrystalAttackCreatePos"] = [[0,0],[-10,15],[10,-15],  // 처음 세개의 생성 포지션
											[-5,8],[5,-8],[-15,23],[15,-23],
											[0,0],[-10,15],[10,-15],[-15,30],[15,-30]];
																						
function checkExecutableSkill_CrystalAttack(obj)
{

	if(!obj) return false;

	local b_useskill = obj.sq_IsUseSkill(SKILL_CRYSTALATTACK);
	if(b_useskill) {
		obj.sq_AddSetStatePacket(STATE_CRYSTALATTACK , STATE_PRIORITY_USER, false);
		return true;
	}	
	return false;

}


function onTimeEvent_CrystalAttack(obj, timeEventIndex, timeEventCount)
{	
	if(!obj)
		return true;

	if(!obj.isMyControlObject())
		return true;
		
	local maxCreateCount = ::CrystalAttackCreatePos.len();
	local createCount = obj.sq_GetIntData(SKILL_CRYSTALATTACK, 1);
	local currentIndex = timeEventCount-1;
	if(timeEventCount > createCount)
		return true;
	

	local dmg = obj.sq_GetBonusRateWithPassive(SKILL_CRYSTALATTACK , STATE_CRYSTALATTACK, 0, 1.0);
	local attackSpeedRate = obj.sq_GetIntData(SKILL_CRYSTALATTACK, 0);

	local pos		= ::CrystalAttackCreatePos[currentIndex];			
	local xDistance = pos[0];
	local angle		= pos[1];
	
	obj.sq_StartWrite();
	obj.sq_WriteDword(dmg);		// 데미지
	obj.sq_WriteFloat(angle.tofloat());	// 각도
	obj.sq_WriteWord(attackSpeedRate); 
	obj.sq_WriteWord(currentIndex);  // 얼음 인덱스
	
	obj.sq_SendCreatePassiveObjectPacket(24221, 0, 120 + xDistance, 1, 0);
	
	return false;
}

function onProc_CrystalAttack(obj)
{
	if (!obj) return;	
	
	local var = obj.getVar();	
	if(obj.sq_GetCurrentFrameIndex() > 1 && var.getBool(1) == false) // 발사된적이 없다면
	{
		var.setBool(1,true); // 발사 했음.			
		
		local maxCreateCount = ::CrystalAttackCreatePos.len();
		obj.setTimeEvent(0,50,maxCreateCount,false);
		
	}
}
	
function checkCommandEnable_CrystalAttack(obj)
{
	if(!obj) return false;
	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK) {
		return obj.sq_IsCommandEnable(SKILL_CRYSTALATTACK);
	}
	
	return true;
}

function onSetState_CrystalAttack(obj, state, datas, isResetTimer)
{
	if(!obj) return;

	obj.sq_StopMove();
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_CRYSTALATTACK);	
	
	local attackSpeedRate = obj.sq_GetIntData(SKILL_CRYSTALATTACK, 0);	
	if(attackSpeedRate != 100) {
		obj.sq_SetAnimationSpeedRate(obj.sq_GetCurrentAni(),attackSpeedRate.tofloat());
	}
	
	obj.sq_PlaySound("MW_CRYSTALATK");
	local var = obj.getVar();
	var.setBool(1,false); // 크리스탈 어택이 발동 됐는지 유무. 변수 초기화.
	
	//obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
	//		SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);	
	addElementalChain_ATMage(obj, ENUM_ELEMENT_WATER);
}	


function prepareDraw_CrystalAttack(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

}

function onEndCurrentAni_CrystalAttack(obj)
{
	if(!obj) return;
	
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}
//
//function onKeyFrameFlag_CrystalAttack(obj, flagIndex)
//{
	//if(!obj) return true;
	//
	//
	//local currentCreateCount = ::CrystalAttackCreatePos.len();
	//
	//local angle = 0.0;
	//local xDistance = 0;
	//if(flagIndex == 2) {
		//local rand = sq_getRandom(10,20);
		//angle = sq_ToRadian(rand.tofloat());
		//xDistance = -10;
	//}
	//else if(flagIndex == 3) {
		//local rand = sq_getRandom(10,20) * -1;
		//angle = sq_ToRadian(rand.tofloat());
		//xDistance = 10;
	//}
		//
	//local dmg = obj.sq_GetBonusRateWithPassive(SKILL_CRYSTALATTACK , STATE_CRYSTALATTACK, 0, 1.0);
	//local attackSpeedRate = obj.sq_GetIntData(SKILL_CRYSTALATTACK, 0);
	//
	//if(obj.isMyControlObject())
	//{
		//obj.sq_StartWrite();
		//obj.sq_WriteDword(dmg);		// 데미지
		//obj.sq_WriteFloat(angle);	// 각도
		//obj.sq_WriteWord(attackSpeedRate); 
		//obj.sq_WriteBool(false);  // 특성 스킬 유무
		//
		//obj.sq_SendCreatePassiveObjectPacket(24221, 0, 120 + xDistance, 1, 0);
		//
		//
		//// 특성 스킬을 위함
		//// 크리스탈 어택 강화를 익혔다면 크리스탈이 4개 더 생성됩니다.
		//local skillLevel = sq_GetSkillLevel(obj, SKILL_CRYSTALATTACK_EX);
		//if (flagIndex == 3 && skillLevel > 0)
		//{
			//local angles = [0.5, 0.15, -0.20, -0.40];
			//local xDistances = [-130, -110, -90, -70];
			//
			//// 위쪽에 4개가 배열되어 생성이 되도록 함
			//for (local i = 0; i < 4; i++)
			//{
			//
				//obj.sq_StartWrite();
				//obj.sq_WriteDword(dmg);		// 데미지
				//obj.sq_WriteFloat(angles[i]);	// 각도
				//obj.sq_WriteWord(attackSpeedRate); 		
				//obj.sq_WriteBool(true);	 // 특성 스킬 유무
				//obj.sq_SendCreatePassiveObjectPacket(24221, 0, 220 + xDistances[i], 1, 0);
			//}
		//}
	//}
//
	//return true;
//
//}
//