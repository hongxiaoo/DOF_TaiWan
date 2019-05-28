IRDSQRCharacter.pushScriptFiles("Character/CreatorMage/creatormage_header.nut");
//******************************************************************************************
// CreatorMage 공통
//******************************************************************************************
IRDSQRCharacter.pushScriptFiles("Character/CreatorMage/CreatorMage_header.nut");	// CreatorMage 스크립트 개발을 위해 넣어둔 상수(enum값 모음)
IRDSQRCharacter.pushScriptFiles("Character/CreatorMage/mousecontrol_lib.nut"); // 
IRDSQRCharacter.pushScriptFiles("Character/CreatorMage/CreatorMage_common.nut"); //  이곳은 state로 구분짓는것이 아닌 남법사 공통 함수 입니다

IRDSQRCharacter.pushScriptFiles("Character/CreatorMage/passive_skill_CreatorMage.nut"); // 기본적인 패시브 스킬을 처리하는 부분입니다.


//******************************************************************************************
// 스킬개별 NUT파일 로드
//******************************************************************************************


//******************************************************************************************
// 스킬관련 패시브 오브젝트 NUT파일 로드
//******************************************************************************************
IRDSQRCharacter.pushPassiveObj("Character/CreatorMage/MicroAttack/po_microAttack.nut", 24353);
IRDSQRCharacter.pushPassiveObj("Character/CreatorMage/WoodFence/po_WoodFence.nut", 24354);
// 24355 `Character/Mage/CreatorWindPress.obj`			// 크리에이터 : 윈드프레스
IRDSQRCharacter.pushPassiveObj("Character/CreatorMage/WindPress/po_WindPress.nut", 24355);
// 24356 `Character/Mage/CreatorWindStorm.obj`			// 크리에이터 : 윈드스톰
IRDSQRCharacter.pushPassiveObj("Character/CreatorMage/WindStorm/po_WindStorm.nut", 24356);


IRDSQRCharacter.pushState(ENUM_CHARACTERJOB_CREATOR_MAGE, "Character/CreatorMage/FireHurricane/FireHurricane.nut", "FireHurricane", STATE_FIREHURRICANE, SKILL_FIREHURRICANE);
IRDSQRCharacter.pushState(ENUM_CHARACTERJOB_CREATOR_MAGE, "Character/CreatorMage/IceShield/IceShield.nut", "IceShield", STATE_ICESHIELD, SKILL_ICESHIELD);
IRDSQRCharacter.pushState(ENUM_CHARACTERJOB_CREATOR_MAGE, "Character/CreatorMage/WindPress/WindPress.nut", "WindPress", STATE_WINDPRESS, SKILL_WINDPRESS);

IRDSQRCharacter.pushScriptFiles("Character/CreatorMage/Mgrab/Mgrab.nut");
IRDSQRCharacter.pushScriptFiles("Character/CreatorMage/Firewall/Firewall.nut");
IRDSQRCharacter.pushScriptFiles("Character/CreatorMage/WoodFence/WoodFence.nut");
IRDSQRCharacter.pushScriptFiles("Character/CreatorMage/IceRock/IceRock.nut");
IRDSQRCharacter.pushScriptFiles("Character/CreatorMage/FireMeteo/FireMeteo.nut");
IRDSQRCharacter.pushScriptFiles("Character/CreatorMage/IcePlate/IcePlate.nut");
IRDSQRCharacter.pushScriptFiles("Character/CreatorMage/WindStorm/WindStorm.nut");

IRDSQRCharacter.pushState(ENUM_CHARACTERJOB_CREATOR_MAGE, "Character/CreatorMage/CreatorFlame/CreatorFlame.nut", "CreatorFlame", STATE_CREATORFLAME, SKILL_CREATORFLAME);

IRDSQRCharacter.pushState(ENUM_CHARACTERJOB_CREATOR_MAGE, "Character/CreatorMage/CreatorIce/CreatorIce.nut", "CreatorIce", STATE_CREATORICE, SKILL_CREATORICE);

IRDSQRCharacter.pushState(ENUM_CHARACTERJOB_CREATOR_MAGE, "Character/CreatorMage/CreatorDisturb/CreatorDisturb.nut", "CreatorDisturb", STATE_CREATORDISTURB, SKILL_CREATORDISTURB);

IRDSQRCharacter.pushState(ENUM_CHARACTERJOB_CREATOR_MAGE, "Character/CreatorMage/CreatorGuardian/CreatorGuardian.nut", "CreatorGuardian", STATE_CREATORGUARDIAN, SKILL_CREATORGUARDIAN);

IRDSQRCharacter.pushState(ENUM_CHARACTERJOB_CREATOR_MAGE, "Character/CreatorMage/CreatorWind/CreatorWind.nut", "CreatorWind", STATE_CREATORWIND, SKILL_CREATORWIND);
