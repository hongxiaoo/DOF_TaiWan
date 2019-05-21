
function onAfterSetState_Buff(obj, state, datas, isResetTimer)
{
	local buffSkillIndex = obj.getBuffSkillIndex();
	
	if (buffSkillIndex == SKILL_MAGICAL_ATTACK_UP)
	{
		// 고대의 기억
		obj.sq_PlaySound("MW_ANCIENT");
	}
	else if (buffSkillIndex == SKILL_SUPER_ARMOR_ON_CAST)
	{
		// 불굴의 의지
		obj.sq_PlaySound("MW_WILL");
	}
	else if (buffSkillIndex == SKILL_JUMP_POWER_UP)
	{
		// 도약
		obj.sq_PlaySound("MW_LEAP_BUFF");
	}
}
