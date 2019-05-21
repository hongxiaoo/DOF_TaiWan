
SUB_STATE_FIREHURRICANE_0	<- 0
SUB_STATE_FIREHURRICANE_1	<- 1

function checkExecutableSkill_FireHurricane(obj)
{
	if (!obj) return false;

	local b_useskill = obj.sq_IsUseSkill(SKILL_FIREHURRICANE);

	if (b_useskill)
	{
		print(" checkExecutableSkill_FireHurricane");
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_FIREHURRICANE_0); // substate세팅
		obj.sq_AddSetStatePacket(STATE_FIREHURRICANE, STATE_PRIORITY_USER, true);
		return true;
	}
	
	return false;

}

function checkCommandEnable_FireHurricane(obj)
{
	if(!obj) return false;
	
	local state = obj.sq_GetState();

	local skill_level = obj.sq_GetSkillLevel(SKILL_FIREHURRICANE);
	if(state == STATE_ATTACK)
	{
		return obj.sq_IsCommandEnable(SKILL_FIREHURRICANE); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_BROKENARROW);
	}
	
	return true;
}

function onSetState_FireHurricane(obj,state,datas,isResetTimer)
{
	if(!obj) return;
	
	local substate = obj.sq_GetVectorData(datas, 0);
	obj.setSkillSubState(substate);

	obj.sq_StopMove();

	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();

	obj.getVar().clear_vector();
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	
	print(" onSetState_FireHurricane:" + substate);

	if (substate == SUB_STATE_FIREHURRICANE_0)
	{
		//setCreatorSkillStateSkillIndex(obj, -1);
		
		local skill_level = obj.sq_GetSkillLevel(SKILL_FIREHURRICANE);
		
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_FIRE_HURRICANE);
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATTACKINFO_FIRE_HURRICANE);
		
		//local speedRate = 1.0;
		//
		//obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
			//SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, speedRate, speedRate);
			//
		obj.getVar("state").clear_ct_vector();
		
		obj.getVar("state").push_ct_vector();
		local t = obj.getVar("state").get_ct_vector(0);
		t.Reset();
		t.Start(100000,0);
		
		
		local multiHitTerm = obj.sq_GetIntData(SKILL_FIREHURRICANE, 0); // 0.다단히트 간격
			
		obj.sq_timer_.setParameter(multiHitTerm, -1);
		obj.sq_timer_.resetInstant(0);
		
		local skill_level = obj.sq_GetSkillLevel(SKILL_FIREHURRICANE);
		// 1.지속시간
		local attackTime = obj.sq_GetLevelData(SKILL_FIREHURRICANE, SKL_LV_1, skill_level);			
			
		local power =  obj.sq_GetPowerWithPassive(SKILL_FIREHURRICANE, STATE_FIREHURRICANE, SKL_LV_0, -1,1.0);
		obj.sq_SetCurrentAttackPower(power);


		local ani = sq_GetCurrentAnimation(obj);

		if (ani)
		{
			// 2.허리케인 사이즈 (%) (100이 기본)
			local imageRate = sq_GetLevelData(obj, SKILL_FIREHURRICANE, SKL_LV_2, skill_level);
			print(" imageRate:" + imageRate);
			ani.setImageRateFromOriginalOnlyChild(imageRate.tofloat() / 100.0, imageRate.tofloat() / 100.0);
			sq_SetAttackBoundingBoxSizeRate(ani, imageRate.tofloat() / 100.0, imageRate.tofloat() / 100.0, 1.0);
		}


 		obj.sq_PlaySound("R_CR_HURRICANE");
		
	}
	else if (substate == SUB_STATE_FIREHURRICANE_1)
	{
		local ani = sq_GetCurrentAnimation(obj);
	}
	
}

function prepareDraw_FireHurricane(obj)
{

	if(!obj) return;

}

function onEnterFrame_FireHurricane(obj, frameIndex)
{
	if (!obj)
		return;
		
	local t = obj.getVar("state").get_ct_vector(0);
	local time = 0;
	
	if(t)
		time = t.Get();
		
	local ani = sq_GetCurrentAnimation(obj);
	
	if(!ani)
		return;
		
	
	if (frameIndex == 2)
	{
		obj.sq_PlaySound("FIREHURRICANE_BURST");
	}
	
	local loopStartFrameIndex = 15;	
	local loopEndFrameIndex = loopStartFrameIndex + 3;
	local endFrameIndex = 24;	
	
	local frmIndex = ani.GetCurrentFrameIndex();
	
	if (frmIndex > loopEndFrameIndex && frmIndex < endFrameIndex)
	{
		local skill_level = obj.sq_GetSkillLevel(SKILL_FIREHURRICANE);
		local attackTotalTime = obj.sq_GetLevelData(SKILL_FIREHURRICANE, SKL_LV_1, skill_level); // 1.지속시간
	
		if (time > attackTotalTime)
		{
			print(" frmIndex:" + frmIndex + " endFrameIndex:" + endFrameIndex + " Time:" + attackTotalTime);

			if (obj.isMyControlObject())
			{
				sq_SendChangeSkillEffectPacket(obj, SKILL_FIREHURRICANE);
				//ani.setEnd(false);
				//ani.setCurrentFrameWithChildLayer(endFrameIndex + 1);
			}
		}
		else
		{
			print(" loopStartFrameIndex:" + loopStartFrameIndex);
			ani.setEnd(false);
			ani.setCurrentFrameWithChildLayer(loopStartFrameIndex);
			sq_AnimationProc(ani);
		}
	}
}

function onProc_FireHurricane(obj)
{
	if (!obj) return;
	
	local t = obj.getVar("state").get_ct_vector(0);
	local time = 0;
	
	if(t)
		time = t.Get();
		
	if (obj.sq_timer_.isOnEvent(time) == true)
	{
		obj.resetHitObjectList();    
	}
	
	//obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);


}

function onProcCon_FireHurricane(obj)
{
	if(!obj) return;

	local substate = obj.getSkillSubState();

	if (substate == SUB_STATE_FIREHURRICANE_0)
	{
		if (sq_IsDownKey(obj, 1, true))
		{
			print(" Enter jump Command");
			sq_SendChangeSkillEffectPacket(obj, SKILL_FIREHURRICANE);
		}
	}

}

function onEndCurrentAni_FireHurricane(obj)
{
	if (!obj.isMyControlObject())
	{
		return;
	}
	
	local substate = obj.getSkillSubState();
	
	print(" endani");
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
}

function onChangeSkillEffect_FireHurricane(obj, skillIndex, reciveData)
{
	if (!obj)
		return;


	local substate = obj.getSkillSubState();

	if (substate == SUB_STATE_FIREHURRICANE_0)
	{
		local endFrameIndex = 24;
		local ani = sq_GetCurrentAnimation(obj);
	
		if(!ani)
			return;

		obj.setSkillSubState(SUB_STATE_FIREHURRICANE_1);

		ani.setEnd(false);
		ani.setCurrentFrameWithChildLayer(endFrameIndex + 1);
	}

}
	


function onKeyFrameFlag_FireHurricane(obj,flagIndex)
{

	if(!obj) return false;

	return true;

}

function onEndState_FireHurricane(obj,new_state)
{

	if(!obj) return;

}

function onAfterSetState_FireHurricane(obj,state,datas,isResetTimer)
{

	if(!obj) return;

}

function onBeforeAttack_FireHurricane(obj,damager,boundingBox,isStuck)
{

	if(!obj) return;

}

function onAttack_FireHurricane(obj,damager,boundingBox,isStuck)
{

	if(!obj) return;

}

function onAfterAttack_FireHurricane(obj,damager,boundingBox,isStuck)
{

	if(!obj) return 0;

	return 1;

}

function onBeforeDamage_FireHurricane(obj,attacker,boundingBox,isStuck)
{

	if(!obj) return;

}

function onDamage_FireHurricane(obj,attacker,boundingBox)
{

	if(!obj) return;

}

function onAfterDamage_FireHurricane(obj,attacker,boundingBox)
{

	if(!obj) return;

}
