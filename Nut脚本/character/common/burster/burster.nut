


// 버스터 스킬을 쓸 수 있는 스킬인지 체크해봅니다.
function isEnableBursterSkill(chr, skillIndex)
{
	if (!chr)
		return false;

	local bursterSkill = sq_GetSkill(chr, SKILL_BURSTER);

	if (!bursterSkill)
		return false;
	
	local size = sq_GetCustomIntDataSize(bursterSkill, chr);

	for (local i = 0; i < size; i++)
	{
		// 금지된 스킬인덱스들을 얻어온다.
		local disableSkillIndex = sq_GetIntData(chr, SKILL_BURSTER, i);

		if (disableSkillIndex == skillIndex)
		{
			print(" disableSkillIndex:" + disableSkillIndex);
			return false;
		}
	}

	return true;
}


// 공통스킬 버스터모드에서 데미지율을 조정합니다. 버스터모드 혹은 다른 스킬에서 데미지레이트를 조정할때 이곳에서 조정을 합니다.
function getCurrentModuleDamageRate(obj)
{	
	if (!obj)
		return 1.0;

	local rate = 1.0;
	local appendage = obj.GetSquirrelAppendage("Character/Common/Burster/ap_Common_Burster.nut");

	if (appendage)
	{
		if (appendage.isValid())
		{
			local skillIndex = obj.getCurrentSkillIndex();

			// 버스터모드에 해당하는 공격이라면 데미지율을 낮추도록 값을 얻어옵니다.
			if (isEnableBursterSkill(obj, skillIndex))
			{
				local level = sq_GetSkillLevel(obj, SKILL_BURSTER);
				// (4) 데미지율 (%) (100%가 기본)
				local value = obj.sq_GetLevelData(SKILL_BURSTER, SKL_LVL_COLUMN_IDX_4, level);

				rate = value.tofloat() / 100.0;

				print(" burst level:" + level + " value:" + value + " getCurrentModuleDamageRate:" + rate.tofloat());
			}
		}
	}

	return rate.tofloat();
}

// 캐릭터 공통 쿨타임 조절 (버스터모드에서 쿨타임을 조절합니다.)
function startSkillCoolTime(obj, skillIndex, skillLevel, currentCoolTime)
{
	if (!obj)
		return -1;

	local appendage = obj.GetSquirrelAppendage("Character/Common/Burster/ap_Common_Burster.nut");
	
	if(appendage)
	{
		// 버스터모드가 활성화 상태이고 해당되는 스킬이라면 쿨타임이 조절 됩니다.
		if (appendage.isValid() && isEnableBursterSkill(obj, skillIndex))
		{
			local level = sq_GetSkillLevel(obj, SKILL_BURSTER);
			// (5) 기본 최소 쿨타임 (ms)
			local value = obj.sq_GetLevelData(SKILL_BURSTER, SKL_LVL_COLUMN_IDX_5, level);

			return value; // 버스터모드 쿨타임
		}
	}

	return -1;

}

function checkExecutableSkill_Burster(obj)
{
	if (!obj)
		return false;

	
	local isUseSkill = obj.sq_IsUseSkill(SKILL_BURSTER);

	if (isUseSkill)
	{
		obj.sq_AddSetStatePacket(STATE_BURSTER, STATE_PRIORITY_IGNORE_FORCE, false);
		return true;
	}	

	return false;
}



function checkCommandEnable_Burster(obj)
{
	if (!obj)
		return false;

	// 현재 타워던젼인지 체크합니다. (사망의 탑, 절망의 탑)
	// 사탑, 절탑에서는 버스터모드가 발동되지 않습니다.
	if (sq_IsTowerDungeon())
	{
		print(" here top dungeon");
		return false;
	}
	
	local state = sq_GetState(obj);
	
	if(state == STATE_ATTACK)
	{
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_BURSTER);
	}
	

	return true;

}

function onEndState_Burster(obj, state)
{
	// 스테이트 종료 혹은 취소 되었다면 캐스팅 게이지 없앰
	sq_EndDrawCastGauge(obj);
}


// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_Burster(obj, state, datas, isResetTimer)
{	
	if (!obj)
		return;

	print(" burster mode start");

	obj.getVar().clear_vector();
	obj.getVar().push_vector(0);

	obj.sq_StopMove();
	
	local buffAni = obj.sq_GetBuffAni();	
	
	
	obj.setCurrentAnimation(buffAni);

	//sq_var.set_vector(1, 1);

	local ani = sq_GetCurrentAnimation(obj);

	obj.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_INFO_RESONANCE);

	// 수속성 강화 버프를 걸어준다.
	local skillLevel = sq_GetSkillLevel(obj, SKILL_BURSTER);

	print(" Burster skillLevel:" + skillLevel);

	// 캐스팅 속도를 따라가도록 설정
	// 캐스팅 속도가 변경되면, 에니메이션 속도도 변경 됩니다.
	// 캐스팅 게이지도 표시를 해줍니다.
	local castTime = sq_GetCastTime(obj, SKILL_BURSTER, skillLevel);
	print(" Burster castTime:" + castTime);
	local animation = sq_GetCurrentAnimation(obj);
	local startTime = sq_GetDelaySum(animation);
	local speedRate = startTime.tofloat() / castTime.tofloat();
	
	print(" cast speedRate:" + speedRate);
		
	obj.sq_SetStaticSpeedInfo(SPEED_TYPE_CAST_SPEED, SPEED_TYPE_CAST_SPEED,
		SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, speedRate, speedRate);

	if (ani)
	{
		local posX = obj.getXPos();
		local posY = obj.getYPos();
		local posZ = obj.getZPos();

		local bodyBackEffAni = sq_CreateAnimation("","Character/Common/Animation/BusterMode/buster_start_back_light3.ani");
		local bodyBackEffObj = obj.sq_CreateCNRDPooledObject(bodyBackEffAni, true);
		bodyBackEffObj.setCurrentDirection(obj.getDirection());
		bodyBackEffObj.setCurrentPos(posX, posY - 1, 47);

		// 캐스팅 타임에 따라서 효과도 맞게 늘려줍니다.
		local effAniTime = sq_GetDelaySum(bodyBackEffAni);
		local speedrate = effAniTime.tofloat() / castTime.tofloat();
		local castSpeed = sq_GetCastSpeed(obj);
		local animationSpeedValue = castSpeed.tofloat() * speedrate.tofloat();
		local aniSpeedRate = animationSpeedValue.tofloat() * 100.0 / SPEED_VALUE_DEFAULT;

		bodyBackEffAni.setSpeedRate(aniSpeedRate.tofloat());
		print(" backAniSpeedRate:" + aniSpeedRate.tofloat());

		obj.sq_AddObject(bodyBackEffObj);

		local bodyFrontEffAni = sq_CreateAnimation("","Character/Common/Animation/BusterMode/buster_start_front_cross.ani");

		// 캐스팅 타임에 따라서 효과도 맞게 늘려줍니다.
		local effFrontAniTime = sq_GetDelaySum(bodyFrontEffAni);
		local sr = effFrontAniTime.tofloat() / castTime.tofloat();
		//local castSpeed = sq_GetCastSpeed(obj);
		local frontAnimationSpeedValue = castSpeed.tofloat() * sr.tofloat();
		local frontAniSpeedRate = frontAnimationSpeedValue.tofloat() * 100.0 / SPEED_VALUE_DEFAULT;
		bodyFrontEffAni.setSpeedRate(frontAniSpeedRate.tofloat());

		print(" frontAniSpeedRate:" + frontAniSpeedRate);

		local bodyFrontEffObj = obj.sq_CreateCNRDPooledObject(bodyFrontEffAni, true);
		bodyFrontEffObj.setCurrentDirection(obj.getDirection());
		bodyFrontEffObj.setCurrentPos(posX, posY + 2, 47);
		obj.sq_AddObject(bodyFrontEffObj);

		// 화면효과
		if (castTime > 100)
		{
			sq_flashScreen(obj, castTime - 100, 100, 0, 150, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
		}
	}
		
	sq_StartDrawCastGauge(obj, startTime, true);
}


function onProc_Burster(obj)
{
	if(!obj) return;

	local substate = obj.getSkillSubState();

	local pAni = obj.sq_GetCurrentAni();
	local frmIndex = obj.sq_GetCurrentFrameIndex(pAni);
	local currentT = sq_GetCurrentTime(pAni);

	local sq_var = obj.getVar();
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();		
}


function onEndCurrentAni_Burster(obj)
{
	if(!obj)
		return;
		
	if(obj.sq_IsMyControlObject())
	{
		obj.sq_SetShake(obj, 3, 250);
	}
	
	local skill_level = sq_GetSkillLevel(obj, SKILL_BURSTER);

	// 중복되면 안되기 때문에.. 다시 얻는다..
	local appendage = obj.GetSquirrelAppendage("Character/Common/Burster/ap_Common_Burster.nut");
	
	if(appendage)
	{
		// 있다면 기존 어펜디지 삭제
		local spectrumAppendage = appendage.sq_GetOcularSpectrum("ocularSpectrum");
		
		if(spectrumAppendage)
			spectrumAppendage.endCreateSpectrum();
	
		appendage.sq_DeleteAppendages();
		CNSquirrelAppendage.sq_RemoveAppendage(obj, "Character/Common/Burster/ap_Common_Burster.nut");
	}
	
	appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_BURSTER, false,
		 "Character/Common/Burster/ap_Common_Burster.nut", false);	

	 // (0) 지속시간
	local change_time = sq_GetLevelData(obj, SKILL_BURSTER, 0, skill_level);		
	
	print(" burst mode valid time:" + change_time);
	appendage.sq_SetValidTime(change_time); // 어펜디지 타임 세팅
		
	appendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, sq_getJob(obj), SKILL_BURSTER, skill_level);

	// 여기서 append 작업		
	CNSquirrelAppendage.sq_Append(appendage, obj, obj);
	
	
	// 중복되면 안되기 때문에.. 다시 얻는다..
	appendage = obj.GetSquirrelAppendage("Character/Common/Burster/ap_Common_Burster.nut");
	
	// 이속 감소
	if(appendage)
	{
		local change_appendage = appendage.sq_getChangeStatus("burstChangeStatus");
		
		local value = sq_GetLevelData(obj, SKILL_BURSTER, 1, skill_level); // (1) 공격 속도(+)

		if(!change_appendage)
			change_appendage = appendage.sq_AddChangeStatusAppendageID(obj, obj, change_time, 
			CHANGE_STATUS_TYPE_ATTACK_SPEED, 
			false, value, APID_COMMON);
		
		if(change_appendage) {
			local atk_spd = sq_GetLevelData(obj, SKILL_BURSTER, 1, skill_level); // (1) 공격 속도(+)
			local mov_spd = sq_GetLevelData(obj, SKILL_BURSTER, 2, skill_level); // (2) 이동 속도(+)
			local cast_spd = sq_GetLevelData(obj, SKILL_BURSTER, 3, skill_level); // (3) 캐스트 속도(+)
			
			change_appendage.clearParameter();
			change_appendage.addParameter(CHANGE_STATUS_TYPE_ATTACK_SPEED, false, atk_spd.tofloat());
			change_appendage.addParameter(CHANGE_STATUS_TYPE_MOVE_SPEED, false, mov_spd.tofloat());
			change_appendage.addParameter(CHANGE_STATUS_TYPE_CAST_SPEED, false, cast_spd.tofloat());
		}
	}



	if (obj.isMyControlObject())
	{
		obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);	
	}
}


function onAttack_Burster(obj, damager, boundingBox, isStuck)
{
	if(!obj) return;

}
