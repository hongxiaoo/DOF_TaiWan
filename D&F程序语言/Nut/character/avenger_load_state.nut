CNAvenger.pushScriptFiles("Character/Priest/avenger_header.nut"); // 어벤져  스크립트 개발을 위해 넣어둔 상수,enum값 모음  
CNAvenger.pushScriptFiles("Character/Priest/avenger_common.nut"); //  이곳은 state로 구분짓는것이 아닌 어벤져 공통 함수 입니다..

CNAvenger.pushScriptFiles("Character/Priest/passive_skill_priest.nut");


CNAvenger.pushState("Character/Priest/Spincutter.nut", "spincutter", STATE_SPINCUTTER, SKILL_SPINCUTTER);
CNAvenger.pushState("Character/Priest/hedgehog.nut", "Hedgehog", STATE_HEDGEHOG, SKILL_HEDGEHOG);
CNAvenger.pushState("Character/Priest/Ripper.nut", "Ripper", STATE_RIPPER, SKILL_RIPPER);
CNAvenger.pushState("Character/Priest/fastmove.nut", "fastmove", STATE_FASTMOVE, SKILL_FASTMOVE); // 고속이동
CNAvenger.pushState("Character/Priest/EarthQuake.nut", "EarthQuake", STATE_EARTHQUAKE, SKILL_EARTH_QUAKE );

CNAvenger.pushState("Character/Priest/Awakening.nut", "Awakening", STATE_AVENGER_AWAKENING, SKILL_AVENGER_AWAKENING); // 각성 어벤져
CNAvenger.pushState("Character/Priest/DashAttack.nut", "DashAttack", STATE_DASH_ATTACK, -1);
CNAvenger.pushState("Character/Priest/AwakenningTurnOff.nut", "AwakenningTurnOff", STATE_AWAKENING_TURN_OFF, -1);

CNAvenger.pushState("Character/Priest/AvengerAttack.nut", "AvengerAttack", STATE_ATTACK, -1); // 어벤져 - 각성 (공격)
CNAvenger.pushState("Character/Priest/PowerOfDarkness.nut", "PowerOfDarkness", STATE_POWER_OF_DARKNESS, SKILL_POWER_OF_DARKNESS); // 어벤져 - 각성 (공격)
CNAvenger.pushState("Character/Priest/FallingSoul.nut", "FallingSoul", STATE_FALLING_SOUL, SKILL_FALLING_SOUL); // 어벤져 - 각성 (공격)

CNAvenger.pushState("Character/Priest/DisasterEx.nut", "DisasterEx", STATE_EX_DISASTER, SKILL_EX_DISASTER); // 어벤져 -EX스킬 - 재앙
CNAvenger.pushState("Character/Priest/PandemoniumEx.nut", "PandemoniumEx", STATE_PANDEMONIUM_EX, SKILL_PANDEMONIUM_EX); // 어벤져 - 특성 : 복마전



CNAvenger.pushPassiveObj("PassiveObject/Character/Priest/po_ripperexplosion.nut", 24102); // 리퍼 패시브
CNAvenger.pushPassiveObj("PassiveObject/Character/Priest/po_earthquakerock.nut", 24103); // 어스퀘이크 패시브
CNAvenger.pushPassiveObj("PassiveObject/Character/Priest/po_spincutter.nut", 24100); // 24100	`Character/Priest/Spincutter.obj` 스핀커터 패시브 오브젝트
CNAvenger.pushPassiveObj("PassiveObject/Character/Priest/po_spincutterthrow.nut", 24101); // 24101	24101	`Character/Priest/SpincutterThrow.obj`

CNAvenger.pushPassiveObj("PassiveObject/Character/Priest/po_devilstrike_attack1.nut", 24104); // 24104	`Character/Priest/DevilStrike1.obj`	// 어벤저 - 데빌스트라이커 공격1
CNAvenger.pushPassiveObj("PassiveObject/Character/Priest/po_devilstrike_attack2.nut", 24105); // 24105	`Character/Priest/DevilStrike2.obj`	// 어벤저 - 데빌스트라이커 공격2
CNAvenger.pushPassiveObj("PassiveObject/Character/Priest/po_devilstrike_attack3.nut", 24106); // 24106	`Character/Priest/DevilStrike3.obj`	// 어벤저 - 데빌스트라이커 공격3

CNAvenger.pushPassiveObj("PassiveObject/Character/Priest/po_PowerOfDarknessCircle.nut", 24107); // 24107	`Character/Priest/PowerOfDarknessCircle.obj`	// 어벤저 - 어둠의 권능
CNAvenger.pushPassiveObj("PassiveObject/Character/Priest/po_PowerOfDarknessArrow.nut", 24108); // 24108	`Character/Priest/PowerOfDarknessCircle.obj`	// 어벤저 - 어둠의 권능 화살

CNAvenger.pushPassiveObj("PassiveObject/Character/Priest/po_disasterExp.nut", 24109); // 24109	`Character/Priest/DisasterExp.obj`	// 어벤저 - ex스킬 - 재앙폭발
CNAvenger.pushPassiveObj("PassiveObject/Character/Priest/po_PendemoniumExDevil.nut", 24110); // 24110	`Character/Priest/PowerOfDarknessCircle.obj`	// 어벤저 - 어둠의 권능 화살


CNAvenger.pushState("Character/Priest/Execution.nut", "Execution", STATE_EXECUTION, SKILL_EXECUTION); // 처형

CNAvenger.pushState("Character/Priest/HighSpeedSlash.nut", "HighSpeedSlash", STATE_HIGH_SPEED_SPLASH, SKILL_HIGH_SPEED_SLASH); // 처형



 


