// 스킬 세부발동 조건을 만들어주는 함수입니다.. 발동 조건 state는 이미 소스에서 구현되어 있습니다. 이곳에서 useskill과 setstate를 지정해주면 됩니다.
function checkExecutableSkill_Hedgehog(obj)  
{
	if(!obj) return false;
	local b_useskill = obj.sq_IsUseSkill(SKILL_HEDGEHOG);
	if(b_useskill) {
		obj.sq_addSetStatePacket(STATE_HEDGEHOG, STATE_PRIORITY_IGNORE_FORCE, false);
		return true;
	}	
	
	return false;
}

// 스킬아이콘 활성화 조건을 따지는 함수입니다. true를 리턴하면 스킬 아이콘이 활성화가 됩니다. (발동조건 state는  소스에서 처리됩니다.)
function checkCommandEnable_Hedgehog(obj)
{
	if(!obj) return false;

	local state = obj.sq_GetSTATE();
	
	if(state == STATE_ATTACK) {
		return obj.sq_IsCommandEnable(SKILL_HEDGEHOG); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_HEDGEHOG);
	}
	
	return true;
}

//------------------------------------------------------------------------------


// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_Hedgehog(obj, state, datas, isResetTimer)
{
	if(!obj) return;
	obj.sq_stopMove();
	obj.sq_setCurrentAnimation(CUSTOM_ANI_HEDGEHOG);
	obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_HEDGEHOG);	
	obj.sq_setAttackPowerWithPassive(SKILL_HEDGEHOG, state, -1,0,1.0);
	obj.sq_PlaySound("PR_HEDGEHOG");	
}

function onEndCurrentAni_Hedgehog(obj)
{
	obj.sq_addSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

function onKeyFrameFlag_Hedgehog(obj,flagIndex)
{		
	if(flagIndex == 2)
		obj.sq_setShake(obj,3,150);
		
	return true;

}
