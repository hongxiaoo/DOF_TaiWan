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