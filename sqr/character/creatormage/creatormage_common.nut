
// 신규 캐릭터 - 프로토타입 작업
// 현재로서 캐릭터 직업 영문명을 알 수 없는 관계로 여법사를 대상으로 작업을 하였습니다.
// 당분간 Thief가 신규 캐릭터 - 마우스콘트롤 직업이라고 간주합니다.
// 향후 Thief가 아닌 신규 직업 영문명으로 바꾸어야 합니다.
// 밑에 주석문에 Master라고 명칭되는것은 콘트롤 되는 오브젝트들의 MainCharacter입니다.


// 크리에이터 전투상황인지 체크하는 함수입니다.
function IsInBattleCreator(obj)
{
	if (!obj)
		return false;

	if (!obj.isMyControlObject())
		return false;

	//print(" isInBattle:" + obj.isInBattle());

	if (sq_GetCurrentModuleType() == MODULE_TYPE_SELECT_DUNGEON)
	{
		return false;
	}

	if (sq_IsInBattle() && !sq_IsPauseTypeWorld(obj))
	{
		if (!obj.isInActiveSkillBlockedMap())
		{ // 액티브 스킬을 쓸 수 있는 맵인지 체크합니다.
			if (obj.isInBattle())
				return true;
		}
	}

	return false;
}

function lockMouse(obj)
{
	if (!obj)
		return;

	if (sq_IsMyControlObject(obj) && sq_getJob(obj) == ENUM_CHARACTERJOB_CREATOR_MAGE)
	{
		sq_SetClipCursor(true);
		setEnableBattleInUI(false);
		obj.getVar("MouseLock").clear_vector();
		obj.getVar("MouseLock").push_vector(1);

		print(" lock mouse");
	}
}

function unLockMouse(obj)
{
	if (!obj)
		return;

	if (sq_IsMyControlObject(obj) && sq_getJob(obj) == ENUM_CHARACTERJOB_CREATOR_MAGE)
	{
		sq_SetClipCursor(false);
		setEnableBattleInUI(true);	
		obj.getVar("MouseLock").clear_vector();
		obj.getVar("MouseLock").push_vector(0);

		print(" un lock mouse");
	}
}


function getCreatorTypeGaugeRate(obj)
{
	local appendage = getCreatorMageStateAppendage(obj);

	if (appendage)
	{
		local max_gaugeValue = appendage.sq_var.get_vector(I_MAX_COUNT);
		local gaugeValue = appendage.sq_var.get_vector(I_REMAIN_COUNT);
		
		local rate = (gaugeValue.tofloat() * 100.0) / max_gaugeValue.tofloat();
		
		return rate;
	}
	
	return 0.0;
}

function getCreatorTypeColor(obj, type)
{
	local rgb = sq_RGB(255,50,50);
	switch (type)
	{
	case CREATOR_TYPE_FLAME:
		rgb = sq_RGB(255,50,50);
		break;
	case CREATOR_TYPE_ICE:
		rgb = sq_RGB(50,255,255);
		break;
	case CREATOR_TYPE_DISTURB:
		rgb = sq_RGB(110,30,230);
		break;
	case CREATOR_TYPE_GUARDIAN:
		rgb = sq_RGB(255,170,40);
		break;
	case CREATOR_TYPE_WIND:
		rgb = sq_RGB(255,250,150);
		break;
	}
	
	return rgb;

}


function getCreatorTypeAlphaColor(obj, type, alpha)
{
	local rgba = sq_RGBA(255,50,50,alpha);
	switch (type)
	{
	case CREATOR_TYPE_FLAME:
		rgba = sq_RGBA(255,50,50,alpha);
		break;
	case CREATOR_TYPE_ICE:
		rgba = sq_RGBA(50,255,255,alpha);
		break;
	case CREATOR_TYPE_DISTURB:
		rgba = sq_RGBA(110,30,230,alpha);
		break;
	case CREATOR_TYPE_GUARDIAN:
		rgba = sq_RGBA(255,170,40,alpha);
		break;
	case CREATOR_TYPE_WIND:
		rgba = sq_RGBA(255,250,150,alpha);
		break;
	}
	
	return rgba;

}




// 크리에이터의 타입에 따라 속성어펜디지를 리턴합니다.
function getCreatorMageAppendageByType(obj, type)
{
	local appendage = null;
	local appendageName = null;

	switch (type)
	{
	case CREATOR_TYPE_FLAME:
		appendageName = "Character/CreatorMage/ap_creatormage_flame.nut";
		break;
	case CREATOR_TYPE_ICE:
		appendageName = "Character/CreatorMage/ap_creatormage_ice.nut";
		break;
	case CREATOR_TYPE_DISTURB:
		appendageName = "Character/CreatorMage/ap_creatormage_disturb.nut";
		break;
	case CREATOR_TYPE_GUARDIAN:
		appendageName = "Character/CreatorMage/ap_creatormage_guardian.nut";
		break;
	case CREATOR_TYPE_WIND:
		appendageName = "Character/CreatorMage/ap_creatormage_wind.nut";
		break;
	}	
	
	if (appendageName != null)
		appendage = CNSquirrelAppendage.sq_GetAppendage(obj,appendageName);
	
	return appendage;
}

function getAniCreatorSkillOn(obj, type)
{
	if (!obj)
		return null;
		
	local sq_var = obj.getVar();
	
	local ani = null;
	switch (type)
	{
	case CREATOR_TYPE_FLAME:
		 ani = sq_var.GetAnimationMap("hud_skillicon_creator_fire", "Character/Mage/CreatorAnimation/ui/hud_skillicon/hud_skillicon_creator_fire.ani");
		break;
	case CREATOR_TYPE_ICE:
		 ani = sq_var.GetAnimationMap("hud_skillicon_creator_ice", "Character/Mage/CreatorAnimation/ui/hud_skillicon/hud_skillicon_creator_ice.ani");
		break;
	case CREATOR_TYPE_DISTURB:
		 ani = sq_var.GetAnimationMap("hud_skillicon_creator_defence", "Character/Mage/CreatorAnimation/ui/hud_skillicon/hud_skillicon_creator_defence.ani");
		break;
	case CREATOR_TYPE_GUARDIAN:
		 ani = sq_var.GetAnimationMap("hud_skillicon_creator_block", "Character/Mage/CreatorAnimation/ui/hud_skillicon/hud_skillicon_creator_block.ani");
		break;
	case CREATOR_TYPE_WIND:
		 ani = sq_var.GetAnimationMap("hud_skillicon_creator_wind", "Character/Mage/CreatorAnimation/ui/hud_skillicon/hud_skillicon_creator_wind.ani");
		break;
	}	
	
	return ani;
}


function getAniCreatorSkillOff(obj, type)
{
	if (!obj)
		return null;
		
	local sq_var = obj.getVar();
	
	local ani = null;
	switch (type)
	{
	case CREATOR_TYPE_FLAME:
		 ani = sq_var.GetAnimationMap("hud_skillicon_creator_fire02", "Character/Mage/CreatorAnimation/ui/hud_skillicon/hud_skillicon_creator_fire02.ani");
		break;
	case CREATOR_TYPE_ICE:
		 ani = sq_var.GetAnimationMap("hud_skillicon_creator_ice02", "Character/Mage/CreatorAnimation/ui/hud_skillicon/hud_skillicon_creator_ice02.ani");
		break;
	case CREATOR_TYPE_DISTURB:
		 ani = sq_var.GetAnimationMap("hud_skillicon_creator_defence02", "Character/Mage/CreatorAnimation/ui/hud_skillicon/hud_skillicon_creator_defence02.ani");
		break;
	case CREATOR_TYPE_GUARDIAN:
		 ani = sq_var.GetAnimationMap("hud_skillicon_creator_block02", "Character/Mage/CreatorAnimation/ui/hud_skillicon/hud_skillicon_creator_block02.ani");
		break;
	case CREATOR_TYPE_WIND:
		 ani = sq_var.GetAnimationMap("hud_skillicon_creator_wind02", "Character/Mage/CreatorAnimation/ui/hud_skillicon/hud_skillicon_creator_wind02.ani");
		break;
	}	

	if (ani)
	{
		
		local rate = getCreatorTypeGaugeRate(obj);
		
		local currentFrameIndex = ani.GetCurrentFrameIndex();
		
		if (rate < 50.0 && rate > 30.0)
		{
			if (currentFrameIndex > 3)
			{
				ani.setEnd(false);
				ani.setCurrentFrameWithChildLayer(0);
			}
		}
		else if (rate <= 30.0)
		{
			if (currentFrameIndex > 8)
			{
				ani.setEnd(false);
				ani.setCurrentFrameWithChildLayer(5);
			}
		}
			
	
	}

	
	return ani;
}


// 크리에터의 충전기능을 세팅합니다.
function setChargeCreatorMageGauge(obj, type, value)
{
	local appendage = getCreatorMageAppendageByType(obj, type);
	
	if (appendage)
	{
		if (value)
		{ // 충전시작이라면 타이머를 새로 세팅합니다.
			appendage.getTimer().Reset();
			appendage.getTimer().Start(10000,0);
			
			// 남아있는 갯수를 파악해서 풀로 채워질때까지의 시간을 구해냅니다.
			local initRemainCnt = appendage.sq_var.get_vector(I_REMAIN_COUNT);
			appendage.sq_var.set_vector(I_CHARGE_INIT_COUNT, initRemainCnt);
		}
			
		appendage.sq_var.set_vector(l_CHARGE_ON, value);
	}
}


// 크리에터의 각 세부스킬에 대한 게이지 소모량을 구합니다.
function getCreatorSkillConsumeValue(obj, skillIndex)
{
	local consumeValue = 10;
	local staticRowIndex = -1;
	
	switch (skillIndex)
	{
	case SKILL_FIREWALL:
		// 1. 소모량
		staticRowIndex = 1;
		break;
	case SKILL_WOODFENCE:
		// 1. 소모량
		staticRowIndex = 1;
		break;
	case SKILL_ICEROCK:
		// 2. 소모량
		staticRowIndex = 2;
		break;
	case SKILL_FIREHURRICANE:
		// 1. 소모량
		staticRowIndex = 1;
		break;
	case SKILL_ICESHIELD:
		// 1. 소모량
		staticRowIndex = 1;
		break;
	case SKILL_ICEPLATE:
		// 1. 소모량
		staticRowIndex = 1;
		break;
	case SKILL_MGRAB:
		// 2. 소모량
		staticRowIndex = 2;
		break;
	case SKILL_FIREMETEO:
		// 2. 소모량
		staticRowIndex = 2;
		break;
	case SKILL_WINDPRESS:
		// 2. 소모량
		staticRowIndex = 2;
		break;
	case SKILL_WINDSTORM:
		// 2. 소모량
		staticRowIndex = 1;
		break;
	}
	
	if (staticRowIndex != -1)
		consumeValue = sq_GetIntData(obj, skillIndex, staticRowIndex);
	
	return consumeValue;
	
}

// 크레이터의 모든 속성 게이지 충전을 시작합니다.
function onAllChargeCreatorMageGauge(obj)
{
	for (local i = CREATOR_TYPE_FLAME; i < CREATOR_TYPE_MAX; i++)
	{
		setChargeCreatorMageGauge(obj, i, 1);
	}
}



function getCreatorMageStateAppendage(obj)
{
	// 크리에이터 state 어펜디지 입니다.
	// 스킬을 쓰면 이동하면서 한번에 하나의 스킬만 쓸 수 있기때문에 어펜디지를 두는것입니다.
	// ap_creatormage_flame.nut
	// ap_creatormage_disturb.nut
	// ap_creatormage_guardian.nut
	// ap_creatormage_ice.nut
	
	// 크리에이터의 공격타입을 얻어옵니다.
	local type = obj.getVar("state").get_vector(0);
	
	if (type < 0)
		return null;
		
	local appendage = getCreatorMageAppendageByType(obj, type);
	
	if (!appendage)
		return null;
	
	
	if (appendage.sq_var.size_vector() == 0)
	{
		for (local i = 0; i < I_SIZE; i++)
			appendage.sq_var.push_vector(-1);
	}
	
	return appendage;
}

function getCreatorBeforePosX(obj)
{
	local appendage = getCreatorMageStateAppendage(obj);
	
	if(appendage)
	{
		return appendage.sq_var.get_vector(I_BEFORE_X);
	}
	
	return -1;
}

function getCreatorBeforePosY(obj)
{
	local appendage = getCreatorMageStateAppendage(obj);
	
	if(appendage)
	{
		return appendage.sq_var.get_vector(I_BEFORE_Y);
	}
	
	return -1;
}


function setCreatorBeforePos(obj, x, y)
{
	local appendage = getCreatorMageStateAppendage(obj);
	
	if(appendage)
	{
		if (appendage.sq_var.size_vector() == 0)
		{
			for (local i = 0; i < I_SIZE; i++)
				appendage.sq_var.push_vector(0);
		}
	
		appendage.sq_var.set_vector(I_BEFORE_X, x);
		appendage.sq_var.set_vector(I_BEFORE_Y, y);
	}
}

function setCreatorBeforeCount(obj, cnt)
{
	local appendage = getCreatorMageStateAppendage(obj);
	
	if(appendage)
	{
		if (appendage.sq_var.size_vector() == 0)
		{
			for (local i = 0; i < I_SIZE; i++)
				appendage.sq_var.push_vector(0);
		}
	
		appendage.sq_var.set_vector(I_BEFORE_COUNT, cnt);
	}
}




// 크리에이터의 스킬인덱스를 세팅합니다.
function setCreatorSkillStateSkillIndex(obj, index)
{	
	if (!obj)
		return;

	local oldStateIndex = getCreatorSkillStateSkillIndex(obj);

	if (oldStateIndex == CREATOR_TYPE_DISTURB)
	{
		// 방해모드에서 드로우를 놔주는것을 한번 호출해줍니다.
		// 누른상태에서 스킬인덱스를 변경하면 멈춰있는 버그발생
		onMouseButtonUp_Mgrab(obj);
	}


	obj.getVar("state").clear_vector();
	obj.getVar("state").push_vector(index);

	if (index != -1)
	{
		local ani = getAniCreatorSkillOn(obj, index);
		
		if (obj.getVar("gauge_ani").size_vector() == 0)
			obj.getVar("gauge_ani").push_vector(1);
		else
			obj.getVar("gauge_ani").set_vector(0, 1);
			
		if (ani)
		{
			obj.sq_PlaySound("PCHANGE");
			sq_Rewind(ani);
		}
	}
}

// 크리에이터의 스킬갯수를 세팅합니다.
function setCreatorSkillCount(obj, cnt)
{

	local appendage = getCreatorMageStateAppendage(obj);
	
	if (appendage)
	{
		if (appendage.sq_var.size_vector() == 0)
		{
			for (local i = 0; i < I_SIZE; i++)
				appendage.sq_var.push_vector(0);
		}
		
		appendage.sq_var.set_vector(I_REMAIN_COUNT, cnt);
	}
}




// 현재쓰고 있는 스킬인덱스 입니다.
function getCreatorSkillStateSkillIndex(obj)
{
	if (!obj)
		return -1;
		
	if (obj.getVar("state").size_vector() == 0)
	{
		obj.getVar("state").push_vector(-1);
	}
	
	return obj.getVar("state").get_vector(0);
}

// 남아있는 스킬갯수
function getCreatorRemainSkillCount(obj)
{
	local remainCount = 0;
	
	local appendage = getCreatorMageStateAppendage(obj);
	
	if(appendage)
	{
		if (appendage.sq_var.size_vector() == 0)
		{
			for (local i = 0; i < I_SIZE; i++)
				appendage.sq_var.push_vector(0);
		}
	
		remainCount = appendage.sq_var.get_vector(I_REMAIN_COUNT);
	}
	
	return remainCount;
}

// 크레이터의 시전사운드를 발동합니다.
function playCreatorCastSound(obj, skillIndex)
{
	switch (skillIndex)
	{
	case SKILL_FIREWALL:
		obj.sq_PlaySound("R_CR_FIREWALL");
		break;
	case SKILL_FIREMETEO:
		obj.sq_PlaySound("R_CR_METEO");
		break;
	case SKILL_ICEROCK:
		obj.sq_PlaySound("R_CR_ICESTONE");
		break;
	case SKILL_ICEPLATE:
		obj.sq_PlaySound("R_CR_ICEPLATE");
		break;
	case SKILL_WOODFENCE:
		obj.sq_PlaySound("R_CR_WOODFENCE");
		break;
	case SKILL_MGRAB:
		obj.sq_PlaySound("R_CR_THROW_MONSTER");
		break;
	case SKILL_WINDSTORM:
		obj.sq_PlaySound("R_CR_WINDSTORM");
		break;
	}
}

function useCreatorSkill(obj, skillIndex, x, y, consumeValue)
{
	local appendage = getCreatorMageStateAppendage(obj);
	
	if(appendage)
	{
		switch (skillIndex)
		{
		case SKILL_FIREWALL:
		case SKILL_WOODFENCE:
		case SKILL_ICEROCK:
		case SKILL_FIREMETEO:
		case SKILL_ICEPLATE:
			{
				// 상기 스킬들은 바닥y축검색을 해봐야 합니다.
				if (y < TILE_FLOOR_START_Y)
					return false;
			}
			break;
		}
		

		local cnt = getCreatorRemainSkillCount(obj);
		
		local remainCnt = (cnt - consumeValue);
		
		if(remainCnt < 0)
		{
			remainCnt = 0;

			if (obj.isMessage())
			{
				//29004>게이지가 부족하여 %s스킬이 해제됩니다.

				local type = getCreatorSkillStateSkillIndex(obj);

				local typeStrIndex = 0;

				switch (type)
				{
				case CREATOR_TYPE_FLAME:
					typeStrIndex = 29005;
					break;
				case CREATOR_TYPE_ICE:
					typeStrIndex = 29006;
					break;
				case CREATOR_TYPE_DISTURB:
					typeStrIndex = 29007;
					break;
				case CREATOR_TYPE_GUARDIAN:
					typeStrIndex = 29008;
					break;
				case CREATOR_TYPE_WIND:
					typeStrIndex = 29009;
					break;
				}	

				if (typeStrIndex)
				{
					sq_AddMessagePrintf(29004, typeStrIndex);
				}
			}

			setCreatorSkillStateSkillIndex(obj, -1);
			// 모든 크레이터의 속성 충전을 시작합니다.
			//setCreatorBeforeCount(obj, remainCnt);
			onAllChargeCreatorMageGauge(obj);


			return false;
		}

		setCreatorBeforePos(obj, x, y);
		setCreatorBeforeCount(obj, cnt);
		setCreatorSkillCount(obj, remainCnt);

		// 
		appendage.getTimer().Reset();
		appendage.getTimer().Start(10000,0);


		// 썼던 기술을 비교해서 최초로 쓰는것이라면..시전사운드 출력
		if (obj.getVar("useskill").size_vector() == 0)
		{
			obj.getVar("useskill").push_vector(skillIndex);
			playCreatorCastSound(obj, skillIndex);
		}
		else
		{		
			if (obj.getVar("useskill").get_vector(0) != skillIndex)
			{
				obj.getVar("useskill").set_vector(0, skillIndex);
				playCreatorCastSound(obj, skillIndex);
			}
		}
		//
		

		local rate = getCreatorTypeGaugeRate(obj);
		
		if (rate < 50)
		{
			if (obj.getVar("gauge_ani").get_vector(0) != 2)
			{
				local type = getCreatorSkillStateSkillIndex(obj);
				local ani = getAniCreatorSkillOff(obj, type);
				
				if (ani)
				{
					sq_Rewind(ani);
				}
				
				if (obj.getVar("gauge_ani").size_vector() == 0)
					obj.getVar("gauge_ani").push_vector(2);
				else
					obj.getVar("gauge_ani").set_vector(0, 2);
			}
		}
	}
	
	return true;
}



// 현재 요청한 타입 마우스 왼클릭을 했을 때 어떤 스킬인지 얻어냅니다.
function getLButtonSkillByType(obj, type)
{
	if (type < 0 || type >= CREATOR_TYPE_MAX)
		return -1;
		
	local size = CREATOR_TYPE_MAX; // 하나 더 추가해야함
	local skill_l =[];
	
	skill_l.resize(size);

	skill_l[CREATOR_TYPE_NONE] = -1;
	skill_l[CREATOR_TYPE_FLAME] = SKILL_FIREWALL;
	skill_l[CREATOR_TYPE_ICE] = SKILL_ICEROCK;
	skill_l[CREATOR_TYPE_DISTURB] = SKILL_WOODFENCE;
	skill_l[CREATOR_TYPE_GUARDIAN] = SKILL_FIREHURRICANE;
	skill_l[CREATOR_TYPE_WIND] = SKILL_WINDPRESS;

	return 	skill_l[type];
}

// 현재 요청한 타입 마우스 오른클릭을 했을 때 어떤 스킬인지 얻어냅니다.
function getRButtonSkillByType(obj, type)
{
	
	if (type < 0 || type >= CREATOR_TYPE_MAX)
		return -1;
	
	
	local size = CREATOR_TYPE_MAX; // 하나 더 추가해야함
	local skill_l =[];
	
	skill_l.resize(size);

	skill_l[CREATOR_TYPE_NONE] = -1;
	skill_l[CREATOR_TYPE_FLAME] = SKILL_FIREMETEO;
	skill_l[CREATOR_TYPE_ICE] = SKILL_ICEPLATE;
	skill_l[CREATOR_TYPE_DISTURB] = SKILL_MGRAB;
	skill_l[CREATOR_TYPE_GUARDIAN] = SKILL_ICESHIELD;
	skill_l[CREATOR_TYPE_WIND] = SKILL_WINDSTORM;
	
	return 	skill_l[type];
}



// 현재 마우스 왼클릭 버튼을 눌렀을 때 나오는 스킬을 리턴합니다.
function getLButtonSkill(obj)
{
	if (!obj)
		return -1;
		
	local type = obj.getVar("state").get_vector(0);
	
	local skillIndex = getLButtonSkillByType(obj, type);
	
	
	if (skillIndex != -1)
	{
		local level = sq_GetSkillLevel(obj, skillIndex);
		
		if (level <= 0)
			return -1;
	}
	
	return skillIndex;
}

// 현재 마우스 오른클릭 버튼을 눌렀을 때 나오는 스킬을 얻습니다.
function getRButtonSkill(obj)
{
	if (!obj)
		return -1;
		
	local type = obj.getVar("state").get_vector(0);
	
	
	local skillIndex = getRButtonSkillByType(obj, type);
	
	if (skillIndex != -1)
	{
		local level = sq_GetSkillLevel(obj, skillIndex);
		
		if (level <= 0)
			return -1;
	}
	
	return skillIndex;
}


// 현재 크리에이터 전투 ui 활성화 상태인지 체크해봅니다.
// 일반 ui가 활성화인지 체크하면 됩니다.
function isEnableCreatorBattleInUI()
{
	local mainControl = sq_GetGlobalMainControl();

	if (mainControl)
	{
		return mainControl.IsEnable();
	}
	
	return false;
	
}


function setEnableBattleInUI(enable)
{
	local quiestUI = sq_GetPopupWindowMainCotrol(1); // quest guide
	if (quiestUI)
	{
		quiestUI.SetEnable(enable);
		quiestUI.SetVisible(true);
	}

	local group = sq_GetUISystemChatControl(99);

	if (group)
	{
		group.SetEnable(enable);
		group.SetVisible(true);
	}


	local chatControl = sq_GetGlobalChatControl();

	if (chatControl)
	{
		chatControl.SetEnable(enable);
		chatControl.SetVisible(true);
	}

	local mainControl = sq_GetGlobalMainControl();

	if (mainControl)
	{
		mainControl.SetEnable(enable);
		mainControl.SetVisible(true);
	}
	
	local strikerUI = sq_GetStrikerSkillUi();

	if (strikerUI)
	{
		strikerUI.SetEnable(enable);
	//	strikerUI.SetVisible(enable);
	}
	
}



// 신규 캐릭터 - 크리에이터에서 전투 시 마우스 기능을 극대화하기 위해 
// 화면내 ui들 마우스 활성화가 되는지 안되는지 기준이 되는 위치입니다. 이곳에 콜백or sqr 바인딩을 합니다.
function onOpenPopupWindow_CreatorMage(obj, popupType, windowTileType)
{
	if (!obj)
		return;

	if (!IsInBattleCreator(obj))
	{
		return;
	}
	
	// 인포 윈도우와 기타 하나하나 팝업을 무시합니다.
	if (sq_IsIgnoreOpenPopupCreator(popupType, windowTileType))
		return;
		


	local isEsc = sq_IsESCClosableWindow(popupType);
	
	local windowsNum = sq_GetPopupWindows();	
	
	
	// 신규 캐릭터 - 크리에이터에서 전투 시 마우스 기능을 극대화하기 위해 
	// 화면내 ui들 마우스 활성화가 되는지 안되는지 기준이 되는 위치입니다. 이곳에 콜백or sqr 바인딩을 합니다.
	unLockMouse(obj);
}

function onClosePopupWindow_CreatorMage(obj, popupType, windowTileType)
{
	if (!obj)
		return;
		
	if (!IsInBattleCreator(obj))
		return;
	
		
	// 인포 윈도우와 기타 하나하나 팝업을 무시합니다.
	if (sq_IsIgnoreOpenPopupCreator(popupType, windowTileType))
		return;

	local isEsc = sq_IsESCClosableWindow(popupType);
	
	// 열린 윈도우가 하나라도 있으면 무시합니다.	
	
	//if (!isEsc)
		//return;

	local windowsNum = sq_GetPopupWindows();	
	//
	
	// 크리에이터가 무시할 수 없는 콘트롤해야하는 팝업이 열려있는지 체크하는 함수입니다.
	if (sq_IsOpenCreatorControlPopupWindows())
		return;
	
	print(" onClose popupType:" + popupType + " windowTileType:" + windowTileType);
	//print(" clip on");
	lockMouse(obj);
}

// 대쉬사운드를 세팅하는 오버라이딩된 함수입니다..
// 크리에이터는 대쉬어택사운드가 나오면 안됩니다.
function playDashAttackSound_CreatorMage(obj) 
{
	return 1;
}


// 오버된 아이템을 찾기위한 함수 입니다.
function checkOverItemObject_CreatorMage(obj)
{
	if (!obj)
		return null;
	
	
	
	local itemObj = null;
	
	local objMgr = obj.getObjectManager();
	
	if (objMgr)
	{
		itemObj = objMgr.getMeetItemObject(IMouse.GetXPos(), IMouse.GetYPos());
	}
	
	return itemObj;
}




// 크리에이터의 타입별 스킬인덱스를 얻습니다.
function getTypeSkillIndex(obj, type)
{
	local idx = SKILL_CREATORFLAME;
	switch (type)
	{
	case CREATOR_TYPE_FLAME:
		idx = SKILL_CREATORFLAME;
		break;
	case CREATOR_TYPE_ICE:
		idx = SKILL_CREATORICE;
		break;
	case CREATOR_TYPE_DISTURB:
		idx = SKILL_CREATORDISTURB;
		break;
	case CREATOR_TYPE_GUARDIAN:
		idx = SKILL_CREATORGUARDIAN;
		break;
	case CREATOR_TYPE_WIND:
		idx = SKILL_CREATORWIND;
		break;
	}	
	
	return idx;
}

function drawMainCustomUI_CreatorMage(obj)
{
	if (!obj)
		return;
	local sq_var = obj.getVar();
			
	// 스킬슬롯
	local hud_creator_b_gauge = sq_var.GetAnimationMap("hud_creator_b_gauge", "Character/Mage/CreatorAnimation/ui/hud_creator_b_gauge.ani");
	local hud_creator_b_select = sq_var.GetAnimationMap("hud_creator_b_select", "Character/Mage/CreatorAnimation/ui/hud_creator_b_select.ani");
	
	local skill_ui_index = 0;


	local x = 626;
	local y = 588;
	local offset = 36;

	// 판그리기
	local hudCreatorAni = sq_var.GetAnimationMap("hud_creator_back", "Character/Mage/CreatorAnimation/ui/hud_creator_back.ani");	
	sq_DrawSpecificFrame(hudCreatorAni, x, y, false, 0, false, 1.0);
	//
	
	// 싸우자가 있을 수 있으므로 이곳에서 배틀인지 아닌지를 체크하여 
	// 배틀이 아닌 경우 커서와 ui를 풀어줍니다.
	if (!IsInBattleCreator(obj))
	{
		local isEnable = isEnableCreatorBattleInUI();
		
		if (!isEnable)
		{
			unLockMouse(obj);
		}
		
		//return;
	}
	
	
	
	// 선택한 테두리 그리기
	if (getCreatorSkillStateSkillIndex(obj) != -1)
	{	
		local type = getCreatorSkillStateSkillIndex(obj);
		
		local skillmgr = obj.getSkillManager();
		
		local slot = -1;
		if (skillmgr)
		{
			local index = getTypeSkillIndex(obj, type);
			slot = skillmgr.getSlotindex(index);
		}
		
		if (slot != -1)
		{	
			// 선택지 그리기
			sq_AnimationProc(hud_creator_b_select);
			sq_drawCurrentFrame(hud_creator_b_select, x + (slot * offset), y, false);
		}
	}
	
	// 게이지 그리기
	local hud_creator_b_gauge = sq_var.GetAnimationMap("hud_creator_b_gauge", "Character/Mage/CreatorAnimation/ui/hud_creator_b_gauge.ani");

	// 속성스킬 게이지 그리기 부분입니다.	
	
	local skillmgr = obj.getSkillManager();
	
	if (!skillmgr)
		return;
	
	for (local i = CREATOR_TYPE_FLAME; i < CREATOR_TYPE_MAX; i++)
	{	
		local slot = -1;
		
		if (skillmgr)
		{
			local index = getTypeSkillIndex(obj, i);
			slot = skillmgr.getSlotindex(index);
		}
	
		if (slot != -1)
		{
			local appendage = getCreatorMageAppendageByType(obj, i);
			if (appendage)
			{
				local gaugeValue = 0;
				local max_gaugeValue = 0;
				
				max_gaugeValue = appendage.sq_var.get_vector(I_MAX_COUNT);
				
				gaugeValue = appendage.sq_var.get_vector(I_REMAIN_COUNT);
				local rate = gaugeValue.tofloat() / max_gaugeValue.tofloat();			
				local rgb = getCreatorTypeColor(obj, i);
				local alpha = sq_ALPHA(255);
				hud_creator_b_gauge.setImageRate(rate, 1.0);	
				local gaugePosX = x - 87;
				sq_DrawSpecificFrameEffect_SIMPLE(hud_creator_b_gauge, gaugePosX + (slot * offset), y, 0, rgb, alpha, true);
			}
		}
	}
}

function onProcSkillShop_CreatorMage(obj, control)
{
	local x = 573;
	local y = 538;
	local offset = 46;

	//print(" control x:" + control.GetXPos() + " y:" + control.GetYPos());

	local sq_var = obj.getVar();
	// 게이지 그리기
	local hud_creator_b_gauge = sq_var.GetAnimationMap("hud_creator_b_gauge", "Character/Mage/CreatorAnimation/ui/hud_creator_b_gauge.ani");

	// 속성스킬 게이지 그리기 부분입니다.	
	
	local skillmgr = obj.getSkillManager();
	
	if (!skillmgr)
		return;
	
	for (local i = CREATOR_TYPE_FLAME; i < CREATOR_TYPE_MAX; i++)
	{	
		local slot = -1;
		
		if (skillmgr)
		{
			local index = getTypeSkillIndex(obj, i);
			slot = skillmgr.getSlotindex(index);
		}
	
		if (slot != -1)
		{
			local appendage = getCreatorMageAppendageByType(obj, i);
			if (appendage)
			{
				local gaugeValue = 0;
				local max_gaugeValue = 0;
				
				max_gaugeValue = appendage.sq_var.get_vector(I_MAX_COUNT);
				
				gaugeValue = appendage.sq_var.get_vector(I_REMAIN_COUNT);
				local rate = gaugeValue.tofloat() / max_gaugeValue.tofloat();			
				local rgb = getCreatorTypeColor(obj, i);
				local alpha = sq_ALPHA(255);
				hud_creator_b_gauge.setImageRate(rate, 1.0);	
				local gaugePosX = x;
				sq_DrawSpecificFrameEffect_SIMPLE(hud_creator_b_gauge, gaugePosX + (slot * offset), y, 0, rgb, alpha, true);
			}
		}
	}

}

function drawCustomUI_CreatorMage(obj)
{
	// 마우스그랩 처리
	
	if (!obj)
		return;
	
	
	if (!IsInBattleCreator(obj))
	{
		return;
	}
	// 커서그리기	
	// 커서 그리기 부분입니다.
	
	
	local isLock = sq_IsClipCursor();

	
	if (!isLock)
	{
		if (!sq_IsVisibleCursor())
		{
			sq_SetVisibleCursor(true);
		}
		
		return;
	}

		
	if (sq_IsVisibleCursor())
	{
		sq_SetVisibleCursor(false);
	}
	
	local ani = obj.getVar().GetAnimationMap("NORMAL", 
	"Character/Mage/Effect/Animation/CreatorMagicSphere/normal.ani"); // 일반커서

	local usingSkillIndex = getCreatorSkillStateSkillIndex(obj);
	
	if (usingSkillIndex == CREATOR_TYPE_DISTURB)
	{
		local stage = sq_GetObjectManagerStage(obj);
		
		if (!stage)
			return;
		
		local control = stage.getMainControl();		

		if (control.IsRBDown())
		{ // 드로우일땐 커서를 바꿉니다.
			ani = obj.getVar().GetAnimationMap("THROW", 
			"Character/Mage/Effect/Animation/CreatorMagicSphere/draw_cursor.ani"); //
		}
		else
		{
			ani = obj.getVar().GetAnimationMap("BLOCK", 
			"Character/Mage/Effect/Animation/CreatorMagicSphere/block.ani"); //
		}
	}
	else if (usingSkillIndex == CREATOR_TYPE_GUARDIAN)
	{
		ani = obj.getVar().GetAnimationMap("GUARD", 
		"Character/Mage/Effect/Animation/CreatorMagicSphere/guard.ani"); //
	}
	else if (usingSkillIndex == CREATOR_TYPE_ICE)
	{
		ani = obj.getVar().GetAnimationMap("ICE", 
		"Character/Mage/Effect/Animation/CreatorMagicSphere/icesphere.ani"); //
	}
	else if (usingSkillIndex == CREATOR_TYPE_FLAME)
	{
		ani = obj.getVar().GetAnimationMap("FIRE", 
			"Character/Mage/Effect/Animation/CreatorMagicSphere/firesphere.ani"); //		
	}
	else if (usingSkillIndex == CREATOR_TYPE_WIND)	
	{
		ani = obj.getVar().GetAnimationMap("WIND", 
		"Character/Mage/Effect/Animation/CreatorMagicSphere/wind.ani"); //
	}		

	local state = obj.getState();

	if (state == STATE_ICESHIELD)
	{	
		ani = obj.getVar().GetAnimationMap("SHIELD", 
		"Character/Mage/Effect/Animation/CreatorMagicSphere/shield_cursor_dodge.ani"); //
	}
	else if (state == STATE_FIREHURRICANE)
	{
		ani = obj.getVar().GetAnimationMap("HURRICANE", 
		"Character/Mage/Effect/Animation/CreatorMagicSphere/hurricane_cursor.ani"); //
	}
	
	if (ani)
	{
		local posX = IMouse.GetXPos();
		local posY = IMouse.GetYPos();
		
		sq_AnimationProc(ani);
		sq_drawCurrentFrame(ani, posX, posY, false);
	}
	
	
	////////////// 메인ui
	if (getCreatorSkillStateSkillIndex(obj) == -1)
		return;

	local sq_var = obj.getVar();
	local skill_ui_index = 0;


	local x = 400;
	local y = 470;
	local offset = 36;

	local alpha = sq_ALPHA(200);
	local baseRGB = sq_RGB(255,255,255);

	// 판그리기
	local main_gauge_b = sq_var.GetAnimationMap("main_gauge_b", 
	"Character/Mage/CreatorAnimation/ui/main_gauge_b.ani");	
	local main_gauge_b_select = sq_var.GetAnimationMap("main_gauge_b_select", 
	"Character/Mage/CreatorAnimation/ui/main_gauge_b_select.ani");	


	sq_AnimationProc(main_gauge_b);

	local currentFrameIndex = main_gauge_b.GetCurrentFrameIndex();
	sq_DrawSpecificFrameEffect_SIMPLE(main_gauge_b, x, y, currentFrameIndex, baseRGB, alpha, false);
	//sq_drawCurrentFrame(main_gauge_b, x, y, false);
	
	// 게이지 그리기
	local hud_creator_b_gauge = sq_var.GetAnimationMap("hud_creator_b_gauge", "Character/Mage/CreatorAnimation/ui/hud_creator_b_gauge.ani");
	
	if (getCreatorSkillStateSkillIndex(obj) != -1)
	{
		local creator_guage_1 = sq_var.GetAnimationMap("creator_guage_1", "Character/Mage/CreatorAnimation/ui/creator_guage_1.ani");	
		local creator_guage_2 = sq_var.GetAnimationMap("creator_guage_2", "Character/Mage/CreatorAnimation/ui/creator_guage_2.ani");	
		local creator_guage_3 = sq_var.GetAnimationMap("creator_guage_3", "Character/Mage/CreatorAnimation/ui/creator_guage_3.ani");	
		local creator_guage_4 = sq_var.GetAnimationMap("creator_guage_4", "Character/Mage/CreatorAnimation/ui/creator_guage_4.ani");
		local type = getCreatorSkillStateSkillIndex(obj);
		
		local appendage = getCreatorMageAppendageByType(obj, type);
		if (appendage)
		{
			local gaugeValue = 0;
			local max_gaugeValue = 0;
			
		//I_REMAIN_COUNT <- 0 // 남아있는 스킬갯수
		//l_CHARGE_ON <- 1 // 충전 중 인지 체크
		//I_BEFORE_X <- 2 // 시간
		//I_BEFORE_Y <- 3 // 시간
		//I_MAX_COUNT <- 4 // 최대충전량
		//I_SIZE <- 5 // 시간
			max_gaugeValue = appendage.sq_var.get_vector(I_MAX_COUNT);
			gaugeValue = appendage.sq_var.get_vector(I_REMAIN_COUNT);
			local rate = gaugeValue.tofloat() / max_gaugeValue.tofloat();
			local maxFrameIndex = 156;
			local frameRate = maxFrameIndex.tofloat() * rate.tofloat();
			
			local frameIndex = maxFrameIndex - frameRate.tointeger();
			
			local rgb = getCreatorTypeColor(obj, type);

			//local rgba = getCreatorTypeAlphaColor(obj, type, 50);
			
			sq_DrawSpecificFrameEffect_SIMPLE(creator_guage_1, x, y, frameIndex, rgb, alpha, true);
			sq_DrawSpecificFrameEffect_SIMPLE(creator_guage_2, x, y, frameIndex, rgb, alpha, true);
			sq_DrawSpecificFrameEffect_SIMPLE(creator_guage_3, x, y, frameIndex, rgb, alpha, true);
			sq_DrawSpecificFrameEffect_SIMPLE(creator_guage_4, x, y, frameIndex, rgb, alpha, true);
		}
	}
	
	//선택한 스킬들
	local main_gauge_lb = sq_var.GetAnimationMap("main_gauge_lb", "Character/Mage/CreatorAnimation/ui/main_gauge_lb.ani");	
	local main_gauge_rb = sq_var.GetAnimationMap("main_gauge_rb", "Character/Mage/CreatorAnimation/ui/main_gauge_rb.ani");	

	//sq_DrawSpecificFrame(main_gauge_lb, x, y, false, 0, false, 1.0);
	//sq_DrawSpecificFrame(main_gauge_rb, x, y, false, 0, false, 1.0);	
	sq_DrawSpecificFrameEffect_SIMPLE(main_gauge_lb, x, y, 0, baseRGB, alpha, false);
	sq_DrawSpecificFrameEffect_SIMPLE(main_gauge_rb, x, y, 0, baseRGB, alpha, false);

	
	// 선택한 스킬인덱스 그리기	
	local main_gauge_b_select = sq_var.GetAnimationMap("main_gauge_b_select", "Character/Mage/CreatorAnimation/ui/main_gauge_b_select.ani");	
	
	if (getCreatorSkillStateSkillIndex(obj) != -1)
	{		
		local off = 32;
		local type = getCreatorSkillStateSkillIndex(obj);

		local skill_icon_mode = obj.getVar("gauge_ani").get_vector(0);
		if (skill_icon_mode == 1)
		{
			local hud_creatorskill_icon = getAniCreatorSkillOn(obj, type);
			
			sq_AnimationProc(hud_creatorskill_icon);
			sq_drawCurrentFrame(hud_creatorskill_icon, x, y, false);
			//sq_DrawCurrentFrameEffect_SIMPLE(hud_creatorskill_icon, x, y, baseRGB, alpha, false);
		}
		else if (skill_icon_mode == 2)
		{
			local hud_creatorskill_icon = getAniCreatorSkillOff(obj, type);
			
			sq_AnimationProc(hud_creatorskill_icon);
			sq_drawCurrentFrame(hud_creatorskill_icon, x, y, false);
			//sq_DrawCurrentFrameEffect_SIMPLE(hud_creatorskill_icon, x, y, baseRGB, alpha, false);
		}
		
		
		// 선택한 스킬아이콘 그리기
		local lbuttonSkl = getLButtonSkillByType(obj, type);
		local rbuttonSkl = getRButtonSkillByType(obj, type);
		
		local ls = sq_GetSkill(obj, lbuttonSkl);
		local rs = sq_GetSkill(obj, rbuttonSkl);
		
		local sx = x - 29;
		local sy = y - 16;
		
		if (ls)
		{
			if (sq_GetSkillLevel(obj, lbuttonSkl) > 0)
			{
				sq_DrawSkillIcon(ls, sx, sy, alpha);
			}
		}

		if (rs)
		{
			if (sq_GetSkillLevel(obj, rbuttonSkl) > 0)
			{
				sq_DrawSkillIcon(rs, sx + off, sy, alpha);
			}
		}
		
		// 선택했을때
		
		local stage = sq_GetObjectManagerStage(obj);
		
		if (!stage)
			return;
		
		local control = stage.getMainControl();		
		
		if (control.IsLBDown())
		{
			sq_AnimationProc(main_gauge_b_select);
			sq_drawCurrentFrame(main_gauge_b_select, x, y, false);
		}
		else if(control.IsRBDown())	
		{
			sq_AnimationProc(main_gauge_b_select);
			sq_drawCurrentFrame(main_gauge_b_select, x + off, y, false);
		}
		
	}
	
	
}

function onStartMap_CreatorMage(obj)
{
	if(!obj)
		return;
	
	lockMouse(obj);

	obj.getVar("dstpos").clear_vector();
	
	// 방이 넘어갔는데 흡수 어펜디지가 있다면..
	// 삭제해줍니다.
	// 다음방에서도 효과가 지속되기 때문입니다.
	local appendage = CNSquirrelAppendage.sq_GetAppendage(obj, "Appendage/Character/ap_common_suck.nut");
	
	if (appendage)
	{
		appendage.sq_DeleteAppendages();
		CNSquirrelAppendage.sq_RemoveAppendage(obj, "Appendage/Character/ap_common_suck.nut");
	}
}


function resetDungeonStart_CreatorMage(obj, moduleType, resetReason, isDeadTower, isResetSkillUserCount)
{
	if (!obj) return -1;	

	if (!obj.isMyControlObject())
		return -1;
		
	local isReset = true; // 기본적으론 전부 리셋입니다.
	
	setCreatorSkillStateSkillIndex(obj, -1);
	onAllChargeCreatorMageGauge(obj);
	
	if (sq_GetCurrentModuleType() == MODULE_TYPE_ROOM_LIST || sq_GetCurrentModuleType() == MODULE_TYPE_ENTRANCE || sq_GetCurrentModuleType() == MODULE_TYPE_SELECT_DUNGEON)
	{
		unLockMouse(obj);
	}	
	else
	{
		print(" game module:" + sq_GetCurrentModuleType());
		lockMouse(obj);
	}

	print(" resetDungeonStart_CreatorMage game module:" + sq_GetCurrentModuleType());

	if (!sq_IsTowerDungeon())
	{
		for (local i = CREATOR_TYPE_FLAME; i < CREATOR_TYPE_MAX; i++)
		{	
			local slot = -1;
		
			local skillmgr = obj.getSkillManager();
		
			if (skillmgr)
			{
				local index = getTypeSkillIndex(obj, i);
				slot = skillmgr.getSlotindex(index);
			}
	
			if (slot != -1)
			{
				local appendage = getCreatorMageAppendageByType(obj, i);
				if (appendage)
				{
					local max_gaugeValue = appendage.sq_var.get_vector(I_MAX_COUNT);
					appendage.sq_var.set_vector(I_REMAIN_COUNT, max_gaugeValue);
					appendage.sq_var.set_vector(l_CHARGE_ON, 0);
					appendage.sq_var.set_vector(I_CHARGE_INIT_COUNT, 0);
					appendage.sq_var.set_vector(I_CURRENT_CHARGE_TIME, 0);
				}
			}
		}
	}
	
	
	return 1;
}


function onStartDungeon_CreatorMage(obj)
{
	if (!obj)
		return;
		
	if (sq_IsMyCharacter(obj))
	{
		lockMouse(obj);
		//////////////////////////////////////////////////////
		obj.getVar("lbdown").clear_timer_vector();
		obj.getVar("lbdown").push_timer_vector();
		obj.getVar("lbdown").push_timer_vector();
				
		local t = obj.getVar("lbdown").get_timer_vector(0);
		t.setParameter(20, -1);
		t.resetInstant(0);
		
		obj.getVar("lbdown").clear_ct_vector();
		obj.getVar("lbdown").push_ct_vector();
		local timer = obj.getVar("lbdown").get_ct_vector(0);
		timer.Reset();
		timer.Start(10000,0);
		//////////////////////////////////////////////////////

		// 크레이터의 모든 속성 게이지 충전을 시작합니다.
		onAllChargeCreatorMageGauge(obj);
	}
}


// 윈도우가 활성화 됐을때 호출되는 콜백함수 입니다.
function onActiveWindow_CreatorMage(obj, activeState)
{
	if (!obj)
		return;
	if (IsInBattleCreator(obj))
	{
//#define     WA_INACTIVE     0
//#define     WA_ACTIVE       1
//#define     WA_CLICKACTIVE  2
		local isOpen = sq_IsOpenCreatorControlPopupWindows();
		local hotKey = sq_IsDownHotKeyCreatorCursor();
		if (isOpen || hotKey)
		{
			return;
		}

		lockMouse(obj);
	}
}

// 윈도우가 비활성화 됐을때 호출되는 콜백함수 입니다.
function onInActiveWindow_CreatorMage(obj)
{
	unLockMouse(obj);
}



function onChangeSkillEffect_CreatorMage(obj, skillIndex, reciveData)
{
	if (!obj)
		return;
	
	if (skillIndex == SKILL_MGRAB)
	{
		onChangeSkillEffect_Mgrab(obj, skillIndex, reciveData);
	}
}


function procAppend_CreatorMage(obj)
{
	if (!obj)
		return 0;

	local type = getCreatorSkillStateSkillIndex(obj);

	if (type == CREATOR_TYPE_DISTURB)
	{
		onProc_Mgrab(obj);
	}

	if (!obj.isMyControlObject())
		return 0;

	local STATE_ACTIVE = 1;		
	
	local cashState = sq_GetStateCashShop();
	local isClipCursor = sq_IsClipCursor(); // 커서가 갇혀있는지 체크합니다.
	
	if (cashState == STATE_ACTIVE)
	{
		// 세라샵이 열렸는데 커서가 off모드가 되어서는 안됩니다.
		if (isClipCursor)
			unLockMouse(obj);
	}
	else
	{
		// 마우스락이 풀리지 않은 경우 마지막 던전 클리어상태인지 체크해봅니다.
		if (sq_GetResultState() || sq_GetRewardState())
		{
			// 결과창이 나오는 동안에도 상자등을 부셔버리기 위해
			// 이번엔 역으로 ui활성화키를 누르면 마우스를 잠궈버립니다.
			local hotKey = sq_IsDownHotKeyCreatorCursor();

			if (hotKey)
			{
				// ui활성화키가 눌린상태에서는 클립이 풀려있다면..
				// 다시 잠궈버립니다.
				if (!isClipCursor)
					lockMouse(obj);
			}
			else
			{
				if (isClipCursor)
				{
					unLockMouse(obj);
				}
			}
			return 0;
		}

		if (IsInBattleCreator(obj))
		{ // 전장중이라면..
			local hotKey = sq_IsDownHotKeyCreatorCursor();

			if (hotKey)
			{
				// ui활성화 키를 누른 상태에엇 마우스가 잠겼는지 체크해봅니다.
				if (isClipCursor)
				{
					// 마우스가 잠겼다면
					unLockMouse(obj);
				}
			}
			else
			{
				// 현재 마우스 좌표가 윈도우 화면안쪽에 있는 체크합니다.
				//print(" isClipCursor:" + isClipCursor);
				if (!isClipCursor)
				{ // 마우스락이 풀린 상태라면					
					//print(" isopencreator:" + sq_IsOpenCreatorControlPopupWindows());
					if (!sq_IsOpenCreatorControlPopupWindows())
					{
						if (sq_IsMousePtInWindowRect())
						{ // 마우스가 내부에 좌표를 향해있다면..
							// ui활성화 키를 누른 상태에서 외부채팅창을 누르면 일시적으로 
							// ui활성화 키가 false로 되는데 이때 마우스락을 걸어주면 안됩니다.
							lockMouse(obj);
						}
					}
				}
			}
		}
		else
		{
			if (isClipCursor == true)
			{
				unLockMouse(obj);
			}
		}
	}

		

	return 1;
}


// 공격간격을 정하기 위해 인터벌을 정해서 리턴합니다.
function IsInterval(obj, interval)
{
	if (!obj)
		return false;

	// 기본공격 타이머 
	local t = obj.getVar().get_ct_vector(0);

	if (!t)
	{
		obj.getVar().clear_ct_vector();
		obj.getVar().push_ct_vector(); 
		t = obj.getVar().get_ct_vector(0);
		t.Reset();
		t.Start(10000,0);

		return true;
	}

	local currentT = t.Get();
	if(currentT > interval)
	{ 
		t.Reset();
		t.Start(10000,0);

		return true;
	}

	//print(" not interval");

	return false;
}


// 마우스버튼을 눌렀을 때 처리되어야 하는 스킬프로세스 부분입니다.
function onMouseButtonDown_ProcSkill(obj, usingSkillIndex)
{
	if (!obj)
		return;
	
	if (!obj.isMyControlObject())
		return;

	if (!IsInBattleCreator(obj))
		return;

	if (!sq_IsClipCursor())
		return;
	
	// 탈것을 타고 있으면 마우스 공격을 할 수 없습니다.
	if (sq_IsRidingObject(obj))
		return;
	
	local objectManager = obj.getObjectManager();

	if (!objectManager)
		return;

	local xPos = objectManager.getFieldXPos(IMouse.GetXPos(), ENUM_DRAWLAYER_NORMAL);
	local yPos = objectManager.getFieldYPos(IMouse.GetYPos(), 0, ENUM_DRAWLAYER_NORMAL);

	//print(" onMouseButtonDown_ProcSkill:" + usingSkillIndex);
	if (usingSkillIndex == SKILL_WOODFENCE)
	{
		// 우드펜스의 경우는 드래그방식이기 때문에 
		// 여기서 처리되지 않습니다.
	}
	else if (usingSkillIndex == SKILL_FIREWALL)
	{
		//print(" onMouseMoveCharacter_Firewall:" + usingSkillIndex);
		onMouseMoveCharacter_Firewall(obj, IMouse.GetXPos(), IMouse.GetYPos());
	}
	else if (usingSkillIndex == SKILL_ICEROCK)
	{
		local consumeValue = getCreatorSkillConsumeValue(obj, usingSkillIndex);
		
		if (useCreatorSkill(obj, usingSkillIndex, xPos, yPos, consumeValue))
			onMouseButtonDown_IceRock(obj);
	}
	else if (usingSkillIndex == SKILL_FIREMETEO)
	{
		local consumeValue = getCreatorSkillConsumeValue(obj, usingSkillIndex);
		
		if (useCreatorSkill(obj, usingSkillIndex, xPos, yPos, consumeValue))
			onMouseButtonDown_FireMeteo(obj);
	}
	else if (usingSkillIndex == SKILL_ICEPLATE)	
	{
		local consumeValue = getCreatorSkillConsumeValue(obj, usingSkillIndex);
		
		if (useCreatorSkill(obj, usingSkillIndex, xPos, yPos, consumeValue))
			onMouseButtonDown_IcePlate(obj);
	}
	else if (usingSkillIndex == SKILL_FIREHURRICANE)
	{
		local isExcute = obj.isExcutableState(SKILL_CREATORGUARDIAN);
		if (isExcute)
		{
			local consumeValue = getCreatorSkillConsumeValue(obj, usingSkillIndex);
			
			if (useCreatorSkill(obj, usingSkillIndex, xPos, yPos, consumeValue))
			{
				obj.sq_IntVectClear();
				obj.sq_IntVectPush(SUB_STATE_FIREHURRICANE_0); // substate세팅
				obj.sq_AddSetStatePacket(STATE_FIREHURRICANE, STATE_PRIORITY_USER, true);
			}
		}
	}
	else if (usingSkillIndex == SKILL_ICESHIELD)
	{	
		if (obj.isExcutableState(SKILL_CREATORGUARDIAN))
		{
			local consumeValue = getCreatorSkillConsumeValue(obj, usingSkillIndex);
			
			if (useCreatorSkill(obj, usingSkillIndex, xPos, yPos, consumeValue))
			{
				obj.sq_IntVectClear();
				obj.sq_IntVectPush(SUB_STATE_ICESHIELD_0); // substate세팅
				obj.sq_AddSetStatePacket(STATE_ICESHIELD, STATE_PRIORITY_USER, true);
			}
		}
	}
	else if (usingSkillIndex == SKILL_WINDPRESS)
	{
		local isExcute = obj.isExcutableState(SKILL_CREATORWIND);
		if (isExcute)
		{
			local consumeValue = getCreatorSkillConsumeValue(obj, usingSkillIndex);
			
			if (useCreatorSkill(obj, usingSkillIndex, xPos, yPos, consumeValue))
			{
				obj.sq_IntVectClear();
				obj.sq_IntVectPush(SUB_STATE_WINDPRESS_0); // substate세팅
				obj.sq_AddSetStatePacket(STATE_WINDPRESS, STATE_PRIORITY_IGNORE_FORCE, true);
			}
		}
	}
	else if (usingSkillIndex == SKILL_WINDSTORM)	
	{
		local consumeValue = getCreatorSkillConsumeValue(obj, usingSkillIndex);

		if (yPos >= TILE_FLOOR_START_Y)
		{
			if (useCreatorSkill(obj, usingSkillIndex, xPos, yPos, consumeValue))
			{
				onMouseButtonDown_WindStorm(obj);
			}
		}
	}
	else if (usingSkillIndex == SKILL_MGRAB)
	{
		// 초기화
		setStateMouseGrab(obj);
		grabThrowObject(obj);
	}
	else if (usingSkillIndex == -1)
	{
		// 이외의 경우 대표적으로 -1인 경우에는
		// 기본공격으로 전환합니다.

		// http://jira.in.neople.co.kr/jira/browse/DNF-8531
		// [크리에이터] 아이스 실드를 습득하지 않은 상태에서 플레임 허리케인 사용 중 오른쪽 클릭을 할 경우 데미지가 낮아지는 현상
		local state = obj.getState();
		if (state == STATE_ICESHIELD || state == STATE_FIREHURRICANE)
			return;

		// 평타공격을 쓸 수 있는 상황인지 체크합니다.
		if (!obj.isEnableBasicAttack())
			return;


		local hitInterval = 500; // 간격수치 (ms)
		if (IsInterval(obj, hitInterval))
		{ // 발사하고 이후 발사 간격이 요청한 수치 이후가 되어야 기본발사가 가능합니다. (연발방지)
			local objectManager = obj.getObjectManager();
		
			if (!objectManager)
				return;

			
			local xPos = objectManager.getFieldXPos(IMouse.GetXPos(), ENUM_DRAWLAYER_NORMAL);
			local yPos = objectManager.getFieldYPos(IMouse.GetYPos(), 0, ENUM_DRAWLAYER_NORMAL);
			local zPos = 0;
		
			local hoverEnemyObject = getOverClickableEnemyObject(obj, IMouse.GetXPos(), IMouse.GetYPos());
		
			if (hoverEnemyObject)
			{
				yPos = hoverEnemyObject.getYPos();							
			
				if (hoverEnemyObject.getZPos() > 0)
				{
					zPos = hoverEnemyObject.getZPos();
				}
			
				zPos = objectManager.getFieldZPos(IMouse.GetYPos(), yPos, ENUM_DRAWLAYER_NORMAL);
			}
		
			sq_SetCurrentAttackInfo(obj, obj.sq_GetDefaultAttackInfo(0));
			obj.applyBasicAttackUp(sq_GetCurrentAttackInfo(obj),STATE_ATTACK);
			sq_SetCurrentAttackInfo(obj, sq_GetCurrentAttackInfo(obj));

			obj.sq_StartWrite();
			sq_BinaryWriteWord(0);		// 더미
			sq_SendCreatePassiveObjectPacketPos(obj, 24353, 0, xPos, yPos, zPos);
		}
	}
}


// 마우스 버튼이 업됐을때 처리되어야 하는 스킬프로세스 입니다.
function onMouseButtonUp_ProcSkill(obj, usingSkillIndex)
{
	if (!obj)
		return;
	
	if (usingSkillIndex == SKILL_MGRAB)
	{
		//onMouseButtonUp_Mgrab(obj);
	}
}



function onMouseLeftButtonDown_CreatorMage(obj)
{
	if (!obj)
		return;
	
	// 죽었을 땐 들어와선 안됩니다.
	if (obj.isDead())
		return;

	local objectManager = obj.getObjectManager();
	
	if (!objectManager)
		return;
	
	// 마우스로 오버된 아이템
	local overItem = obj.getOverItemObject();
	
	if (overItem)
	{
		// 보안모듈때문에 잠시 아이템있는 좌표로 갔다가 돌아옵니다.
		local beforePosX = obj.getXPos();
		local beforePosY = obj.getYPos();
		local beforePosZ = obj.getZPos();
		
		local itemPosX = overItem.getXPos();
		local itemPosY = overItem.getYPos();

		sq_SetCurrentPos(obj, itemPosX, itemPosY, 0);
		
		obj.procGetItem();
		
		sq_SetCurrentPos(obj, beforePosX, beforePosY, beforePosZ);
		return;
	}
	
	local usingSkillIndex = getLButtonSkill(obj);
	
	onMouseButtonDown_ProcSkill(obj, usingSkillIndex);
}


function onMouseLeftButtonUp_CreatorMage(obj)
{
	if (!obj)
		return;
	
	// 죽었을 땐 들어와선 안됩니다.
	if (obj.isDead())
		return;

	local usingSkillIndex = getLButtonSkill(obj);
	
	
	onMouseButtonUp_ProcSkill(obj, usingSkillIndex);
}

function onMouseRightButtonDown_CreatorMage(obj)
{
	if (!obj)
		return;	

	// 죽었을 땐 들어와선 안됩니다.
	if (obj.isDead())
		return;

	local usingSkillIndex = getRButtonSkill(obj);
	
	//임시 팝업
	//sq_OpenPopupWindow(379, 279, 499, 1000);
	//

	onMouseButtonDown_ProcSkill(obj, usingSkillIndex);
	
}


function onMouseRightButtonUp_CreatorMage(obj)
{
	if (!obj)
		return;

	// 죽었을 땐 들어와선 안됩니다.
	if (obj.isDead())
		return;

	local usingSkillIndex = getRButtonSkill(obj);
	
	onMouseButtonUp_ProcSkill(obj, usingSkillIndex);	
		
}


function onMouseMoveCharacter_CreatorMage(obj, x, y)
{
	if (!obj)
		return;
	
	// 죽었을 땐 들어와선 안됩니다.
	if (obj.isDead())
		return;

	if (!obj.isMyControlObject())
		return;

	if (!IsInBattleCreator(obj))
		return;

	if (!sq_IsClipCursor())
		return;

	// 탈것을 타고 있으면 마우스 공격을 할 수 없습니다.
	if (sq_IsRidingObject(obj))
		return;
	
	local stage = sq_GetObjectManagerStage(obj);
	
	if (!stage)
		return;
	
	x = IMouse.GetXPos();
	y = IMouse.GetYPos();	
	
	local control = stage.getMainControl();	
	
	local usingSkillIndex = -1;
	
	if (control.IsLBDown())
	{
		usingSkillIndex = getLButtonSkill(obj);
	}
	else if(control.IsRBDown())	
	{
		usingSkillIndex = getRButtonSkill(obj);
	}
	
	// 현재 쓰고있는 스킬이 있는지 파악해봅니다.
	if (usingSkillIndex == SKILL_FIREWALL)
	{
		onMouseMoveCharacter_Firewall(obj, x, y);
	}
	else if (usingSkillIndex == SKILL_WOODFENCE)	
	{
		onMouseMoveCharacter_WoodFence(obj, x, y);
	}
	else if (usingSkillIndex == SKILL_MGRAB)
	{
	}
	
}



function drawAppend_CreatorMage(obj, isOver, x, y)
{
	if (!obj.isMyControlObject())
		return 0;

	
	return 0;
	
}


