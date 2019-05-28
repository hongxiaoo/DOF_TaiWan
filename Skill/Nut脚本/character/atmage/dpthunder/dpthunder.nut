function checkExecutableSkill_DPThunder(obj)  
{
	if (!obj) return false;
	local isUse = obj.sq_IsUseSkill(SKILL_DP_THUNDER);

	if (isUse) {
		obj.sq_AddSetStatePacket(STATE_DP_THUNDER , STATE_PRIORITY_USER, false);
		return true;
	}

	return false;
}



function checkCommandEnable_DPThunder(obj)
{
	if (!obj) return false;
	local state = obj.sq_GetState();
	

	if (state == STATE_STAND)
		return true;

	if(state == STATE_ATTACK)
	{
		return obj.sq_IsCommandEnable(SKILL_DP_THUNDER);
	}	
	
	
	return true;
}
//ANI
function onSetState_DPThunder(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	local xpos = obj.getXPos()
	local ypos = obj.getYPos()
	local Zpos = obj.getZPos()

	obj.sq_SetfindNearLinearMovablePos(200, 200, xpos, ypos, 10);

	obj.sq_StopMove();									
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_WIND_STRIKE);
	obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
			SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
}

function onEndCurrentAni_DPThunder(obj)
{
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

function onKeyFrameFlag_DPThunder(obj,flagIndex)
{
	if(!obj)
		return false;

	local isMyControlObject = obj.sq_IsMyControlObject();

	if (isMyControlObject && flagIndex == 1)
	{
		local skillLevel = obj.sq_GetSkillLevel(SKILL_DP_THUNDER); //????n??m?
		local thunderCount = obj.sq_GetLevelData(SKILL_DP_THUNDER, 3, skillLevel);	

			
		local attackBonusRate = obj.sq_GetBonusRateWithPassive(SKILL_DP_THUNDER, STATE_DP_THUNDER, SKL_LVL_COLUMN_IDX_0, 1.0);    
		local power = obj.sq_GetPowerWithPassive(SKILL_DP_THUNDER, STATE_DP_THUNDER, SKL_LVL_COLUMN_IDX_1, SKL_LVL_COLUMN_IDX_0, 1.0);	
		//local upForce = obj.sq_GetLevelData(2);	
					
					
		obj.sq_StartWrite();
		obj.sq_WriteDword(attackBonusRate);
		obj.sq_WriteDword(power);	
		//obj.sq_WriteWord(upForce);	
		if (skillLevel < 6)
		{
		obj.sq_SendCreatePassiveObjectPacket(48132, 0, 0, 0, 0);
		}
		else if (skillLevel < 11)
		{
		obj.sq_SendCreatePassiveObjectPacket(48138, 0, 0, 0, 0);
		}
		else if (skillLevel < 70)
		{
		obj.sq_SendCreatePassiveObjectPacket(48138, 0, 0, 0, 0);
		obj.sq_SendCreatePassiveObjectPacket(48133, 0, 0, 0, 0);
			for(local i = 0; i < thunderCount; i++)
			{
				obj.sq_SendCreatePassiveObjectPacket(48134, 0, 0, 0, 0);		
			}
		}
	}
	return true;
}