DEBUG <- isDebugMode();
NULL <- null;


// 스킬레벨을 상승시키는 함수 부분입니다..특정 스킬에 대해서 동기화해야하는 스킬이 있다면 이곳에서 처리해줍니다..
// 스킬 구입 개선으로 flag 인자가 추가되었습니다.
// flag는 0이면 스킬레벨-, 1이면 스킬레벨+를 표시하는 값입니다.
function requestBuy(obj, skill, nIndex, flag, count)
{
	if(sq_getJob(obj) == ENUM_CHARACTERJOB_PRIEST && sq_getGrowType(obj) == GROW_TYPE_AVENGER) { // 어벤저라면 동기화해야할 스킬이 있습니다..
		if(nIndex == SKILL_AVENGER_AWAKENING) { // 각성 둠스가디언이 스킬레벨업이 되면..
			//print("\n requestBuy(obj, skill, nIndex, count) \n" + count);
			sq_requestBuySkill(SKILL_EXECUTION, flag, count); // 처형도 같이 레벨업을 시켜줍니다..
		}
	}
	
	return true;
}

// squirrel passiveobject 공통 콜백함수 부분입니다..어벤저가 아닌 모든 캐릭터의 패시브오브젝트가 들어옵니다..
function onAttack_PassiveObject(passiveobj, damager, bounding_box, is_stuck)
{
	if(!passiveobj) return -1;
	
	if(passiveobj) {
		local pChr = passiveobj.getTopCharacter();	
		
		if(!isGrowTypeAvenger(pChr)) return -1; // 어벤져가 다음으로 진행되서는 안됩니다..

		if(pChr) { 
			// 패시브오브젝트 공격중에 데빌스트라이커 공격은 빼야한다..이걸로 공격하는데 이걸로 충전이 되면 곤란하지 않는가..
			// 24104	`Character/Priest/DevilStrike1.obj`	// 어벤저 - 데빌스트라이커 공격1
			// 24105	`Character/Priest/DevilStrike2.obj`	// 어벤저 - 데빌스트라이커 공격2
			// 24106	`Character/Priest/DevilStrike3.obj`	// 어벤저 - 데빌스트라이커 공격3
			
			if(passiveobj.getPassiveObjectIndex() != 24104 && passiveobj.getPassiveObjectIndex() != 24105 &&
			passiveobj.getPassiveObjectIndex() != 24106)
				procDevilStrikeGauge(pChr, passiveobj.getPassiveObjectIndex()); // 어벤저 state를 체크하여 충전이 필요한 상태라면 악마게이지를 충전시켜줍니다..
		}
	}
	
	return 1;
}


// 캐릭터 선택창에 출력되는 전직효과 그리기
function drawGrowAvatarAniType(job, growtype, x, y, isOver, is_draw)
{
	//print("\n drawGrowAvatarAniType:" + job + " growtype:" + growtype);
	if(job == ENUM_CHARACTERJOB_PRIEST && growtype == GROW_TYPE_AVENGER) {
		if(isOver == true && is_draw == true) {
			local getvar = CNAvenger.getStaticVar();
			
			local auraAni = null;
			if(getvar) {
				auraAni = getvar.GetAnimationMap("1_aura_normal", "Character/Priest/Effect/Animation/ScytheMastery/1_aura_normal.ani");
			}
			
			//print("\n isOver:" + isOver + " is_draw:" + is_draw);
			
			sq_AnimationProc(auraAni);
			sq_drawCurrentFrame(auraAni, x, y, false);
		}
	}
}

// 마을에서 그려지는 전직효과 그리기
function drawAppend_VirtualCharacter(job, growtype, x, y, isOver, is_draw)
{
	if(job == ENUM_CHARACTERJOB_PRIEST && growtype == GROW_TYPE_AVENGER) {
		if(isOver == true) {
			local getvar = CNAvenger.getStaticVar();
			
			local auraAni = null;
			if(getvar) {
				auraAni = getvar.GetAnimationMap("1_aura_normal", "Character/Priest/Effect/Animation/ScytheMastery/1_aura_normal.ani");
			}
			
			//print("\n isOver:" + isOver + " is_draw:" + is_draw);
			
			sq_AnimationProc(auraAni);
			sq_drawCurrentFrame(auraAni, x, y, false);
		}
	}
}

function sqr_CreatePooledObject(obj, ani_filename, x, y, z, dir)
{
	if(!obj) return;
	
	local ani = obj.sq_createCNRDAnimation(ani_filename); // [create draw only object] 를 쓰면 안되기 때문에 이곳에 추가해야합니다..
	local pooledObj = obj.sq_createCNRDPooledObject(ani, true);
	if(pooledObj) {
		// 15 -2 75
		pooledObj.setCurrentDirection(dir);
		pooledObj.setCurrentPos(x, y, z);
		obj.sq_AddObject(pooledObj);
	}
}

// 넘겨지는 state파라미터가 평타인지 체크
function sqr_IsNormalAttack(state)
{
//STATE_ATTACK <- 8 		  //  공격
//STATE_JUMP_ATTACK <- 7 		  //  점프
//STATE_DASH_ATTACK <- 15 		  //  대쉬 어택
	if(state == STATE_ATTACK || state == STATE_JUMP_ATTACK || state == STATE_DASH_ATTACK) {
		return true;
	}
	
	return false;
}

// 스킬 사용 조준 리소스 로딩하는 부분을 추가하였습니다. 작업자: 정진수 (11.11.22)
// 리턴값은 crndanimation* 입니다.
function CreateAimPointMark(parentObj)
{
	local job = sq_getJob(parentObj);
	local ani = null;
	
	if(job == ENUM_CHARACTERJOB_AT_MAGE)
	{
		ani = sq_CreateAnimation("", "Common/CommonEffect/Animation/atmage_cussor/AimPointMark.ani");
		ani.setRGBA(0, 78, 255, 255);
	}
	
	return ani;
}

function CNAimPointMarkCustomAnimation(obj, parentObj)
{
	if(!obj)
		return false;
		
	local job = sq_getJob(parentObj);
	
	if(job == ENUM_CHARACTERJOB_AT_MAGE)
	{
		local ani1 = sq_CreateAnimation("", "Common/CommonEffect/Animation/atmage_cussor/AimPointMarkDisable.ani");
		local ani2 = sq_CreateAnimation("", "Common/CommonEffect/Animation/atmage_cussor/AimPointMarkVanish.ani");
		local ani3 = sq_CreateAnimation("", "Common/CommonEffect/Animation/atmage_cussor/AimPointMarkDisableVanish.ani");
		local ani4 = sq_CreateAnimation("", "Common/CommonEffect/Animation/atmage_cussor/AimPointMarkEnable.ani");
		
		if(ani1 && ani2 && ani3 && ani4)
		{
			ani1.setRGBA(0, 78, 255, 255);
			ani2.setRGBA(0, 78, 255, 255);
			ani3.setRGBA(0, 78, 255, 255);
			ani4.setRGBA(0, 78, 255, 255);
			
			obj.addCustomAnimation(ani1);
			obj.addCustomAnimation(ani2);
			obj.addCustomAnimation(ani3);
			obj.addCustomAnimation(ani4);
			
			return true;
		}
	}

	return false;
}

// aim타겟 움직일 수 잇는 범위를 정하는 함수입니다.
function isMovablePos_CNAimPointMark(obj, parentObj, xPos, yPos)
{
	if(!obj)
		return true;
		
	if(!parentObj)
		return true;
		
	local job = sq_getJob(parentObj);
	
	if(job == ENUM_CHARACTERJOB_AT_MAGE)
	{
		return sq_IsMovablePosCollisionObject(parentObj, xPos, yPos);
	}
	
	return true;
}

// 지금 전투모드인지 체크하는 함수입니다.
function isBattleMode()
{
	local isPvpMode = checkModuleType(MODULE_TYPE_PVP_TYPE);
	local isDungeonMode = checkModuleType(MODULE_TYPE_DUNGEON_TYPE);

	print(" isPvpMode:" + isPvpMode + " isDungeonMode:" + isDungeonMode);

	if(!isPvpMode && !isDungeonMode)
	{ // 전투중이 아니라면
		return false;
	}
	
	return true;
}

SKILL_HARD_ATTACK		<- 5;
SKILL_TRIPLE_SLASH		<- 8;
SKILL_MOMENTARY_SLASH	<- 9;
SKILL_ASHEN_FORK		<- 16;
SKILL_JUMP_ATTACK_MULTI	<- 17;
SKILL_NORMAL_WAVE		<- 20;
SKILL_ICE_WAVE			<- 21;
SKILL_DARK_FRIENDSHIP	<- 29;
SKILL_GRAB_BLAST_BLOOD	<- 31;
SKILL_UPPER_SLASH		<- 46;
SKILL_VANE_SLASH		<- 58;
SKILL_GHOST_STEP_SLASH  <- 60;
SKILL_GORE_CROSS		<- 64;
SKILL_HOP_SMASH			<- 65;
SKILL_CHARGE_CRASH		<- 68;
SKILL_RAPID_MOVE_SLASH	<- 72;
SKILL_ILLUSION_SLASH	<- 73;
SKILL_WAVE_SPIN_AREA	<- 74;
SKILL_MOONLIGHT_SLASH	<- 77;
SKILL_BLOODY_RAVE		<- 79;
SKILL_OUT_RAGE_BREAK	<- 81;
SKILL_KALLA				<- 82;
SKILL_FLOW_MIND			<- 105;

SKILL_SHOCK_WAVE_AREA	<- 57;
SKILL_GRAND_WAVE		<- 50;
SKILL_REFLECT_GUARD		<- 2;
SKILL_TRIPLE_STAB		<- 112;
SKILL_GHOST_SIDE_WIND	<- 111;
	
	
// 마검사 스킬 이펙트 에니메이션 로드
function sq_LoadSkillEffect_DemonicSwordman(obj, skillIndex)
{
	if (skillIndex == SKILL_GHOST_SIDE_WIND)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GhostSideWind_DS/00_sword_normal.ani"); // ghostSideWindAnimations_ 0
	}
	else if (skillIndex == SKILL_HARD_ATTACK)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/HardAttack1_DS.ani"); // hardAttackEffects_ 0
	}
	else if(skillIndex == SKILL_ICE_WAVE)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/RapidMoveSlash_DS/Move1.ani"); // 0 : rapidMoveSlashMoveAnimations_[0]
	}
	else if (skillIndex == SKILL_RAPID_MOVE_SLASH)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/RapidMoveSlash_DS/Move1.ani"); // 0 : rapidMoveSlashMoveAnimations_[0]
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/RapidMoveSlash_DS/Move2.ani"); // 1 : rapidMoveSlashMoveAnimations_[1]
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/RapidMoveSlash_DS/Slash1.ani"); // 2 : rapidMoveSlashSlashAnimations_[0]
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/RapidMoveSlash_DS/Slash2.ani"); // 3 : rapidMoveSlashSlashAnimations_[1]
	}
	else if (skillIndex == SKILL_GHOST_STEP_SLASH)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GhostStepSlash_DS/Move.ani"); // 0
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GhostStepSlash_DS/Slash1.ani"); // 1
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GhostStepSlash_DS/Slash2.ani"); // 2
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GhostStepSlash_DS/Skull.ani"); // 3
	}
	else if (skillIndex == SKILL_TRIPLE_SLASH)
	{
		// 단공참
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/TripleSlash_DS/Slash1.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/TripleSlash_DS/Slash2.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/TripleSlash_DS/Slash3.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/TripleSlash_DS/Slash4.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/TripleSlash_DS/Slash5.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/TripleSlash_DS/Move1.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/TripleSlash_DS/Move2.ani");
	}
	else if (skillIndex == SKILL_MOMENTARY_SLASH)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/momentaryslash_none_under.ani");			//0
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash_DS/momentaryslash_blue_ldodge_under.ani");	//1	
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/momentaryslash_none_upper.ani");			//2
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash_DS/momentaryslash_blue_ldodge_upper.ani");	//3
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/momentaryslash_white_ldodge_under.ani");	//4
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/momentaryslash_white_ldodge_upper.ani");	//5
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/momentaryslash_red_ldodge_under.ani");	//6
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/momentaryslash_red_ldodge_upper.ani");	//7		
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/Charge1.ani");							//8
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/Charge2.ani");							//9	
	}
	else if (skillIndex == SKILL_ASHEN_FORK)
	{
		// 에쉔포크
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackHold_DS.ani");
	}
	else if (skillIndex == SKILL_JUMP_ATTACK_MULTI)
	{
		// 공중 연속베기
		// jumpAttackMultiSlash1Sword_
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti_DS/jumpchainattackslash1_katana_under.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti_DS/jumpchainattackslash1_katana_upper.ani");
		// jumpAttackMultiSlash2Sword_
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti_DS/jumpchainattackslash2_katana_under.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti_DS/jumpchainattackslash2_katana_upper.ani");
		// jumpAttackMultiSlashSwordUnderEffects_
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti_DS/jumpchainattackslash1_under_effect.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti_DS/jumpchainattackslash2_under_effect.ani");
		// jumpAttackMultiSlashSwordUpperEffects_
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti_DS/jumpchainattackslash1_upper_effect.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti_DS/jumpchainattackslash2_upper_effect.ani");

		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti_DS/jumpchainattacknormal_upper_effect.ani");
	}
	else if (skillIndex == SKILL_NORMAL_WAVE)
	{
		// 파동검 지열
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/NormalWaveSlash_DS.ani");
	}
	else if (skillIndex == SKILL_GRAB_BLAST_BLOOD)
	{
		// 블러드 러스트
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GrabBlastBlood_DS.ani");
	}
	else if (skillIndex == SKILL_UPPER_SLASH)
	{
		// 어퍼슬래쉬
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/UpperSlash1_DS.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/UpperSlash2_DS.ani");
	}
	else if (skillIndex == SKILL_VANE_SLASH)
	{
		// 열파참
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/VaneSlash_DS/Upper.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/VaneSlash_DS/Dust.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/VaneSlash_DS/Smash.ani");
	}
	else if (skillIndex == SKILL_GORE_CROSS)
	{
		// 고어크로스
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GoreCross_DS/Slash1.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GoreCross_DS/Slash2.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GoreCross_DS/Slash3.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GoreCross_DS/Slash4.ani");
	}
	else if (skillIndex == SKILL_HOP_SMASH)
	{
		// 붕산격
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/HopSmash_DS/Sword.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/HopSmash_DS/Smash.ani");
	}
	else if (skillIndex == SKILL_MOONLIGHT_SLASH)
	{
		// 달빛베기
		// 만월 달빛베기 : MoonlightSlashFull.ani : 마검사는 사용하지 않음.
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MoonlightSlash1_DS.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MoonlightSlash2_DS.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MoonlightSlashFull.ani");
	}
	else if (skillIndex == SKILL_BLOODY_RAVE)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave_DS/Start1.ani");		// bloodyRaveStartAnis_		0
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave_DS/Start2.ani");		// bloodyRaveStartAnis_		1
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave_DS/Loop1.ani");			// bloodyRaveLoopAnis_		2
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave_DS/Loop2.ani");			// bloodyRaveLoopAnis_		3
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave_DS/Line1.ani");			// bloodyRaveLineAnis_		4
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave_DS/Line2.ani");			// bloodyRaveLineAnis_		5
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave_DS/Typhoon.ani");		// bloodyRaveTyphoonAni_	6
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave_DS/End.ani");			// bloodyRaveEndAni_		7
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave_DS/Sword1.ani");		// bloodyRaveSwordAnis_		8
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave_DS/Sword2.ani");		// bloodyRaveSwordAnis_		9
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave_DS/Sword3.ani");		// bloodyRaveSwordAnis_		10
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave_DS/Sword4.ani");		// bloodyRaveSwordAnis_		11		
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/(TN)Sword2.ani");		// bloodyRaveSwordAnis_		12
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/(TN)Sword4.ani");		// bloodyRaveSwordAnis_		13		
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave_DS/Hit.ani");		// 14
	}
	else if (skillIndex == SKILL_OUT_RAGE_BREAK)
	{
		// 아웃레이지 브레이크
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/OutRageBreak_DS/sword_ready_ldodge.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/OutRageBreak_DS/sword_ready_none.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/OutRageBreak_DS/sword_slash_ldodge.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/OutRageBreak_DS/sword_slash_none.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/OutRageBreak_DS/sword_slash_impact_ldodge.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/OutRageBreak_DS/sword_slash_impact_none.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/OutRageBreak_DS/sword_slash_stone.ani");
	}
	else if (skillIndex == SKILL_KALLA)
	{
		local i = 1;
		for(; i <= 4 ; ++i)
			obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/Kalla_DS/FinishReady" + i + ".ani");	//	0~3
			
		for(local j = 1 ; j <= 3 ; ++j)
		{
			for(i = 1 ; i <= 4 ; ++i)
			{
				obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/Kalla_DS/Finish" + j + "-" + i + ".ani");	//	4~16
			}
		}
	}
	else if (skillIndex == SKILL_WAVE_SPIN_AREA)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/WaveSpinArea_DS/Circle.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/WaveSpinArea_DS/CircleFront.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/WaveSpinArea_DS/CircleBack.ani");
	}
	else if (skillIndex == SKILL_CHARGE_CRASH)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/ChargeCrash_DS/dash.ani");			// 0
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/ChargeCrash_DS/up-slash.ani");		// 1
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/ChargeCrash_DS/charge.ani");		// 2
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/ChargeCrash_DS/down-slash.ani");	// 3	
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/ChargeCrash_DS/dustdash.ani");		// 4	
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/ChargeCrash_DS/dustdashlast.ani");	// 5	
	}
	else if (skillIndex == SKILL_ILLUSION_SLASH)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/IllusionSlash_DS/Upper.ani");		// 0
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/IllusionSlash_DS/Smash.ani");		// 1
	}
	else if (skillIndex == SKILL_SHOCK_WAVE_AREA)
	{
		obj.sq_LoadSkillEffectAni(skillIndex,"Effect/Animation/ShockWaveArea_DS/Cast.ani");
		obj.sq_LoadSkillEffectAni(skillIndex,"Effect/Animation/ShockWaveArea_DS/Smash.ani");
		obj.sq_LoadSkillEffectAni(skillIndex,"Effect/Animation/ShockWaveArea_DS/Area.ani");		
	}	
	else if (skillIndex == SKILL_GRAND_WAVE)
	{
		obj.sq_LoadSkillEffectAni(skillIndex,"Effect/Animation/grandWaveOnCharge1.ani"); // 0
		obj.sq_LoadSkillEffectAni(skillIndex,"Effect/Animation/grandWaveOnCharge2.ani"); // 1
		obj.sq_LoadSkillEffectAni(skillIndex,"Effect/Animation/grandWave_DS.ani"); // 2
	}	
	else if (skillIndex == SKILL_REFLECT_GUARD)
	{
		obj.sq_LoadSkillEffectAni(skillIndex,"Effect/Animation/ReflectGuard_DS/charge.ani");
		obj.sq_LoadSkillEffectAni(skillIndex,"Effect/Animation/ReflectGuard_DS/slash.ani");
	}	
	
}


// 귀검사 스킬 이펙트 에니메이션 로드
function sq_LoadSkillEffect_Swordman(obj, skillIndex)
{
	if (skillIndex == SKILL_GHOST_SIDE_WIND)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GhostSideWind/00_sword_normal.ani"); // ghostSideWindAnimations_ 0
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GhostSideWind/01_sword_dodge.ani");	  // ghostSideWindAnimations_ 1
	}
	else if (skillIndex == SKILL_HARD_ATTACK)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/HardAttack1.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/HardAttack2.ani");
	}
	else if (skillIndex == SKILL_RAPID_MOVE_SLASH)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/RapidMoveSlash/Move1.ani"); // 0 : rapidMoveSlashMoveAnimations_[0]
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/RapidMoveSlash/Move2.ani"); // 1 : rapidMoveSlashMoveAnimations_[1]
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/RapidMoveSlash/Slash1.ani"); // 2 : rapidMoveSlashSlashAnimations_[0]
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/RapidMoveSlash/Slash2.ani"); // 3 : rapidMoveSlashSlashAnimations_[1]
	}
	else if (skillIndex == SKILL_GHOST_STEP_SLASH)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GhostStepSlash/Move.ani"); // 0				
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GhostStepSlash/Slash1.ani"); // 1
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GhostStepSlash/Slash2.ani"); // 2
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GhostStepSlash/Skull.ani"); // 2
		
	}
	else if (skillIndex == SKILL_TRIPLE_SLASH)
	{
		// 단공참
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/TripleSlash/Slash1.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/TripleSlash/Slash2.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/TripleSlash/Slash3.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/TripleSlash/Slash4.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/TripleSlash/Slash5.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/TripleSlash/Move1.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/TripleSlash/Move2.ani");
	}
	else if (skillIndex == SKILL_MOMENTARY_SLASH)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/momentaryslash_none_under.ani");			//0
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/momentaryslash_blue_ldodge_under.ani");	//1	
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/momentaryslash_none_upper.ani");			//2
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/momentaryslash_blue_ldodge_upper.ani");	//3
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/momentaryslash_white_ldodge_under.ani");	//4
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/momentaryslash_white_ldodge_upper.ani");	//5
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/momentaryslash_red_ldodge_under.ani");	//6
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/momentaryslash_red_ldodge_upper.ani");	//7		
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/Charge1.ani");							//8
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MomentarySlash/Charge2.ani");							//9		
	}
	else if (skillIndex == SKILL_ASHEN_FORK)
	{
		// 에쉔포크
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackHold.ani");
	}
	else if (skillIndex == SKILL_JUMP_ATTACK_MULTI)
	{
		// 공중 연속베기
		// jumpAttackMultiSlash1Sword_
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti/jumpchainattackslash1_katana_under.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti/jumpchainattackslash1_katana_upper.ani");
		// jumpAttackMultiSlash2Sword_
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti/jumpchainattackslash2_katana_under.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti/jumpchainattackslash2_katana_upper.ani");
		// jumpAttackMultiSlashSwordUnderEffects_
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti/jumpchainattackslash1_under_effect.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti/jumpchainattackslash2_under_effect.ani");
		// jumpAttackMultiSlashSwordUpperEffects_
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti/jumpchainattackslash1_upper_effect.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti/jumpchainattackslash2_upper_effect.ani");

		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/JumpAttackMulti/jumpchainattacknormal_upper_effect.ani");
	}
	else if (skillIndex == SKILL_NORMAL_WAVE)
	{
		// 파동검 지열
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/NormalWaveSlash.ani");
	}
	else if (skillIndex == SKILL_GRAB_BLAST_BLOOD)
	{
		// 블러드 러스트
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GrabBlastBlood.ani");
	}
	else if (skillIndex == SKILL_UPPER_SLASH)
	{
		// 어퍼슬래쉬
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/UpperSlash1.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/UpperSlash2.ani");
	}
	else if (skillIndex == SKILL_VANE_SLASH)
	{
		// 열파참
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/VaneSlash/Upper.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/VaneSlash/Dust.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/VaneSlash/Smash.ani");
	}
	else if (skillIndex == SKILL_GORE_CROSS)
	{
		// 고어크로스
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GoreCross/Slash1.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GoreCross/Slash2.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GoreCross/Slash3.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/GoreCross/Slash4.ani");
	}
	else if (skillIndex == SKILL_HOP_SMASH)
	{
		// 붕산격
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/HopSmash/Sword.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/HopSmash/Smash.ani");
	}
	else if (skillIndex == SKILL_MOONLIGHT_SLASH)
	{
		// 달빛베기
		// 만월 달빛베기 : MoonlightSlashFull.ani : 마검사는 사용하지 않음.
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MoonlightSlash1.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MoonlightSlash2.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/MoonlightSlashFull.ani");
	}
	else if (skillIndex == SKILL_BLOODY_RAVE)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/Start1.ani");		// bloodyRaveStartAnis_		0
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/Start2.ani");		// bloodyRaveStartAnis_		1
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/Loop1.ani");			// bloodyRaveLoopAnis_		2
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/Loop2.ani");			// bloodyRaveLoopAnis_		3
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/Line1.ani");			// bloodyRaveLineAnis_		4
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/Line2.ani");			// bloodyRaveLineAnis_		5
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/Typhoon.ani");		// bloodyRaveTyphoonAni_	6
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/End.ani");			// bloodyRaveEndAni_		7
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/Sword1.ani");		// bloodyRaveSwordAnis_		8
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/Sword2.ani");		// bloodyRaveSwordAnis_		9
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/Sword3.ani");		// bloodyRaveSwordAnis_		10
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/Sword4.ani");		// bloodyRaveSwordAnis_		11		
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/(TN)Sword2.ani");		// bloodyRaveSwordAnis_		12
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/(TN)Sword4.ani");		// bloodyRaveSwordAnis_		13		
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/BloodyRave/Hit.ani");		// 14
	}
	else if (skillIndex == SKILL_OUT_RAGE_BREAK)
	{
		// 아웃레이지 브레이크
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/OutRageBreak/sword_ready_ldodge.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/OutRageBreak/sword_ready_none.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/OutRageBreak/sword_slash_ldodge.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/OutRageBreak/sword_slash_none.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/OutRageBreak/sword_slash_impact_ldodge.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/OutRageBreak/sword_slash_impact_none.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/OutRageBreak/sword_slash_stone.ani");
	}
	else if (skillIndex == SKILL_KALLA)
	{
		for(local i = 1 ; i <= 4 ; ++i)
			obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/Kalla/FinishReady" + i + ".ani");	//	0~3
			
		for(local j = 1 ; j <= 3 ; ++j)
			for(local i = 1 ; i <= 4 ; ++i)
				obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/Kalla/Finish" + j + "-" + i + ".ani");	//	0~3
	}
	else if (skillIndex == SKILL_WAVE_SPIN_AREA)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/WaveSpinArea/Circle.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/WaveSpinArea/CircleFront.ani");
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/WaveSpinArea/CircleBack.ani");
	}
	else if (skillIndex == SKILL_CHARGE_CRASH)
	{					
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/ChargeCrash/dash.ani");			// 0
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/ChargeCrash/up-slash.ani");		// 1
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/ChargeCrash/charge.ani");		// 2
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/ChargeCrash/down-slash.ani");	// 3	
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/ChargeCrash/dustdash.ani");		// 4	
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/ChargeCrash/dustdashlast.ani");	// 5	
	}
	else if (skillIndex == SKILL_ILLUSION_SLASH)
	{
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/IllusionSlash/Upper.ani");		// 0
		obj.sq_LoadSkillEffectAni(skillIndex, "Effect/Animation/IllusionSlash/Smash.ani");		// 1
	}
	else if (skillIndex == SKILL_SHOCK_WAVE_AREA)
	{
		obj.sq_LoadSkillEffectAni(skillIndex,"Effect/Animation/ShockWaveArea/Cast.ani");
		obj.sq_LoadSkillEffectAni(skillIndex,"Effect/Animation/ShockWaveArea/Smash.ani");
		obj.sq_LoadSkillEffectAni(skillIndex,"Effect/Animation/ShockWaveArea/Area.ani");
	}	
	else if (skillIndex == SKILL_GRAND_WAVE)
	{
		obj.sq_LoadSkillEffectAni(skillIndex,"Effect/Animation/grandWaveOnCharge1.ani"); // 0
		obj.sq_LoadSkillEffectAni(skillIndex,"Effect/Animation/grandWaveOnCharge2.ani"); // 1
		obj.sq_LoadSkillEffectAni(skillIndex,"Effect/Animation/grandWave.ani"); // 2
	}	
	else if (skillIndex == SKILL_REFLECT_GUARD)
	{
		obj.sq_LoadSkillEffectAni(skillIndex,"Effect/Animation/ReflectGuard/charge.ani");
		obj.sq_LoadSkillEffectAni(skillIndex,"Effect/Animation/ReflectGuard/slash.ani");
	}	
}


function getDist2(x1, y1, x2, y2)
{
	local i = 0;
	
	local dx = x1 - x2;
	
	local dy = y1 - y2;
	
	local sum = (dx * dx) + (dy * dy);

	if (dx < 0)
		dx = -dx;
		
	if (dy < 0)
		dy = -dy;
		
	if (dx > dy)
		i = dx;
	else
		i = dy;
	
	while ((i * i) < sum)
	{
		i = i + 2;
	}
	
	i = i - 1;
	
	if ((i * i) < sum)
		i = i + 1;
		
	return i;
		
}
