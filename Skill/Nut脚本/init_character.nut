
function sq_InitFrameIndices(obj)
{
	if (!obj)
		return -1;

	// 남법사
	if (sq_getJob(obj) == ENUM_CHARACTERJOB_AT_MAGE)
	{
		// 점프할때 각 서브 스테이트의 프레임 인섹스 설정
		obj.sq_JumpUpStartFrame(1);
		obj.sq_JumpDownStartFrame(3);
		obj.sq_JumpLandStartFrame(9);
	
	
		// 캐릭터 다운될때 각 서브 스테이트의 프레임 인덱스 설정
		obj.sq_SetDownUpFrame(2);
		obj.sq_SetDownDownFrame(2);
		obj.sq_SetDownBounceUpFrame(2);
		obj.sq_SetDownBounceDownFrame(3);
		obj.sq_SetDownLieFrame(4);


		obj.sq_AddAttackCancelStartFrame(3);	// 1타 캔슬 프레임
		obj.sq_AddAttackCancelStartFrame(3);	// 2타 캔슬 프레임
		obj.sq_AddAttackCancelStartFrame(3);	// 3타 캔슬 프레임
		
		
		
		// 남법사 기본 사운드 태그 등록
		obj.sq_SetSoundTagCreatureCommand("MW_CMDPET");
		obj.sq_SetSoundTagLackMp("MW_NOMANA");
		obj.sq_SetSoundTagCoolTime("R_MW_COOLTIME");
		obj.sq_SetSoundTagDie("MW_DIE");
		obj.sq_SetSoundTagBackStepStart("MW_BACK");
		obj.sq_SetSoundTagThrowItem("R_MW_THROW");
		
		
		// 아이템 던지기 설정
		obj.setThrowObjectAnimationIndex(3);
		obj.setThrowObjectZDistance(65);
		obj.setThrowObjectXDistance(45);
		obj.setThrowObjectFrameIndex(1);
	}
	else if (sq_getJob(obj) == ENUM_CHARACTERJOB_CREATOR_MAGE)
	{
		// 남법사 기본 사운드 태그 등록
		obj.sq_SetSoundTagCreatureCommand("CR_CMDPET");
		obj.sq_SetSoundTagLackMp("R_CR_NOMANA");
		obj.sq_SetSoundTagCoolTime("R_CR_COOLTIME");
		obj.sq_SetSoundTagDie("R_CR_DIE");
		obj.sq_SetSoundTagBackStepStart("R_CR_JUMP");
		obj.sq_SetSoundTagThrowItem("R_CR_THROW");
	}

	return 0;
}


// 크리에이터가 생성될때 해야할일들
function create_CreatorMage(obj)
{
}

// 처음 캐릭터를 셀렉트 했을때 호출되는 콜백함수 입니다.
function onSetCharacter(obj)
{
	print(" onSetCharacter:" + obj + " job:" + sq_getJob(obj));	
	
	if (sq_getJob(obj) == ENUM_CHARACTERJOB_CREATOR_MAGE)
	{
		sq_SetExSkillSlotVisible(false);	
		sq_SetSkillSlotVisible(5, false);
		sq_SetSkillSlotEnable(5, false);
		
		local SKILLICON_START_X = 540;
		local SKILLICON_START_Y = 555;
	
		for (local i = 0; i < 5; i++)
		{	
			sq_SetSkillSlotPos(i, SKILLICON_START_X + (i*36), SKILLICON_START_Y);
		}
	}
	else
	{	
		sq_SetExSkillSlotVisible(true);	
		sq_SetSkillSlotVisible(5, true);
		sq_SetSkillSlotEnable(5, true);
		
		local SKILLICON_START_X = 538;
		local SKILLICON_START_Y = 558;
		
		
		for (local i = 0; i < 6; i++)
		{	
			sq_SetSkillSlotPos(i, SKILLICON_START_X + (i*30), SKILLICON_START_Y);
		}
	}
}



