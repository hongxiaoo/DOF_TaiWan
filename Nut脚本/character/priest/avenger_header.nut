
// 이곳은 던파소스에 없는 순수 스크립트로만 개발하면서 필요한 스킬개발에 필요한 상수,enum 추가값을 선언하는 부분입니다. 
// 던파소스에 있는 값을 이곳에 넣으시면 안됩니다..

// 어벤져 state 관련 부분입니다
STATE_PRIEST_TEST			<- 60	// 디플렉트 월[강화]
STATE_SPINCUTTER			<- 61  	// 스핀커터(어벤져)
STATE_PRIEST_SCYTHE_MASTERY <- 62	// 어벤져 : 사이드 마스터리
STATE_HEDGEHOG				<- 63	// 헤지호그
STATE_FASTMOVE				<- 64  	// 어벤져 : 빠른이동
STATE_RIPPER				<- 65	// 어벤져 : 리퍼
STATE_EARTHQUAKE			<- 66	// 어벤져 : 어스퀘이크
STATE_AVENGER_AWAKENING		<- 67	// 어벤져 : 각성변신
STATE_EXECUTION				<- 68	// 어벤져 : 처형 

STATE_AWAKENING_TURN_OFF	<- 69	// 어벤져 : 각성 - 돌아오기
STATE_HIGH_SPEED_SPLASH		<- 70   // 고속베기
STATE_POWER_OF_DARKNESS		<- 71	// 어둠의 권능
STATE_FALLING_SOUL			<- 72	// 추락하는 영혼

STATE_PANDEMONIUM_EX		<- 73	// 어벤져 특성 : 복마전
STATE_EX_DISASTER			<- 74	// EX 스킬 : 재앙


// 어벤져 skill관련 부분입니다.
SKILL_CHANGE_HP_TO_MP		<- 10	// 고통의 희열
SKILL_SPINCUTTER			<- 113	// 스핀커터 (어벤져)
SKILL_SCYTHE_MASTERY		<- 114	// 어벤져 : 사이드 마스터리
SKILL_FASTMOVE				<- 115	// 고속이동(어벤져)
SKILL_HEDGEHOG				<- 116	// 헤지호그
SKILL_RIPPER				<- 117	// 찢어발기기
SKILL_EARTH_QUAKE			<- 118	// 어스퀘이크
SKILL_AVENGER_AWAKENING		<- 119 	// 어벤져 각성
SKILL_EXECUTION				<- 120	// 처형
SKILL_HEARTHINGS			<- 121	// 환청
SKILL_NIGHTMARE					<- 122 // 각성 패시브악몽(48레벨)
SKILL_DEVILSTRIKE			<- 123  // 데빌스트라이커
SKILL_HIGH_SPEED_SLASH		<- 124 // 고속베기
SKILL_POWER_OF_DARKNESS		<- 125 // 엄둠의 권능

SKILL_CANCEL_FASTMOVE			<- 127 // 캔슬 고속이동
SKILL_CANCEL_HIGH_SPEED_SLASH	<- 128 // 캔슬 고속베기
SKILL_CANCEL_EARTH_QUAKE		<- 129 // 캔슬 지뢰진
SKILL_CANCEL_HEDGEHOG			<- 130 // 캔슬 보호의 가시(헤지호그)
SKILL_FALLING_SOUL				<- 131	// 추락하는 영혼
SKILL_CANCEL_SPINCUTTER			<- 132	// 캔슬 스핀커터

SKILL_PANDEMONIUM_EX			<- 133 // 복마전 

SKILL_EX_DISASTER			<- 134	// ex스킬 - 재앙

SKILL_FASTMOVE_EX			<- 164	// ex스킬 - 고속이동 강화
SKILL_RIPPER_EX				<- 165	// ex스킬 - 리퍼강화

// 어벤져 animation 관련 부분입니다..
CUSTOM_ANI_SPINCUTTER1		<- 79 	//  스핀커터 THROW
CUSTOM_ANI_SPINCUTTER2		<- 80	//  스핀커터 RE CALL
CUSTOM_ANI_SPINCUTTER3		<- 81 	//  스핀커터 ARRIVAL
CUSTOM_ANI_FASTMOVE1		<- 82 	//  고속이동 시동
CUSTOM_ANI_FASTMOVE2		<- 83 	//  고속이동 루프
CUSTOM_ANI_FASTMOVE3		<- 84 	//  고속이동 진행
CUSTOM_ANI_FASTMOVE4		<- 85 	//  고속이동 종료
// 각성 어벤져 변신
CUSTOM_ANI_AVENGER_AWAKENING1	<- 86	  // 각성 어벤져 
CUSTOM_ANI_AVENGER_AWAKENING2	<- 87	  // 각성 어벤져 
CUSTOM_ANI_AVENGER_AWAKENING3	<- 88	  // 각성 어벤져 
CUSTOM_ANI_AVENGER_AWAKENING4	<- 89	  // 각성 어벤져 
CUSTOM_ANI_HEDGEHOG 			<- 90	  // 헤지호그
CUSTOM_ANI_RIPPER 				<- 91	  // 리퍼
CUSTOM_ANI_EARTH_QUAKE 			<- 92	  // 어스퀘이크 

CUSTOM_ANI_EXC_GRAB 			<- 93	  // 익스큐션 잡기
CUSTOM_ANI_EXC_GRAB_EX			<- 94	  // 익스큐션 뒤로 던지기	
CUSTOM_ANI_EXC_TURNOVER			<- 95	  // 익스큐션 뒤로 던지기	
CUSTOM_ANI_EXC_RUN 				<- 96	  // 익스큐션 달리기	
CUSTOM_ANI_EXC_LAST 			<- 97	  // 익스큐션 막타
CUSTOM_ANI_EXC_FAILED 			<- 98	  // 익스큐션 실패

CUSTOM_ANI_AWAKENING_TURN_OFF	<- 99	  // 각성-변신 해제

CUSTOM_ANI_HIGH_SPEED_READY		<- 100	  // 고속 베기
CUSTOM_ANI_HIGH_SPEED_ATTACK_1	<- 101	  // 고속 베기
CUSTOM_ANI_HIGH_SPEED_ATTACK_2	<- 102	  // 고속 베기
CUSTOM_ANI_HIGH_SPEED_ATTACK_3	<- 103	  // 고속 베기
CUSTOM_ANI_HIGH_SPEED_ATTACK_4	<- 104	  // 고속 베기
CUSTOM_ANI_HIGH_SPEED_LAST		<- 105	  // 고속 베기

CUSTOM_ANI_AVENGER_ATTACK_1		<- 106	  // 어벤저 - 평타1
CUSTOM_ANI_AVENGER_ATTACK_2		<- 107	  // 어벤저 - 평타2
CUSTOM_ANI_AVENGER_ATTACK_3		<- 108	  // 어벤저 - 평타3
CUSTOM_ANI_AVENGER_ATTACK_4_SCYTHE		<- 109	  // 어벤저 평타 4 (낫 버전)
CUSTOM_ANI_AVENGER_ATTACK_4_ROSARY		<- 110	  // 어벤저 평타 4 (염주 버전)

CUSTOM_ANI_POWER_OF_DARKNESS_START	<- 111	  // 어둠의 권능
CUSTOM_ANI_POWER_OF_DARKNESS_STAY	<- 112	  // 어둠의 권능
CUSTOM_ANI_POWER_OF_DARKNESS_END	<- 113	  // 어둠의 권능

CUSTOM_ANI_AWAKENING_TURN_OFF_2		<- 114	  // 각성-변신 해제2

CUSTOM_ANI_PANDEMONIUM_START		<- 115	  // 복마전
CUSTOM_ANI_PANDEMONIUM_END		<- 116	  // 복마전

CUSTOM_ANI_EX_DISASTER_1		<- 117	  // EX스킬 - 재앙1
CUSTOM_ANI_EX_DISASTER_2		<- 118	  // EX스킬 - 재앙1
CUSTOM_ANI_EX_DISASTER_3		<- 119	  // EX스킬 - 재앙1
CUSTOM_ANI_EX_DISASTER_4		<- 120	  // EX스킬 - 재앙1
CUSTOM_ANI_EX_DISASTER_5		<- 121	  // EX스킬 - 재앙1



// 어벤져 atk파일 관련 부분입니다.
CUSTOM_ATTACKINFO_SPINCUTTER 	 <- 70	  //  스핀커터  초기타
CUSTOM_ATTACKINFO_FASTMOVE	 <- 71	  //  고속이동
CUSTOM_ATTACKINFO_HEDGEHOG	 <- 72	  //  헤지호그
CUSTOM_ATTACKINFO_RIPPER	 <- 73	  //  리퍼

CUSTOM_ATTACKINFO_EXCUTION_1	 <- 74    // 잡기
CUSTOM_ATTACKINFO_EXCUTION_2	 <- 75	  // 잡기 폭발
CUSTOM_ATTACKINFO_EXCUTION_3	 <- 76	  // 돌려서 찍기
CUSTOM_ATTACKINFO_EXCUTION_4	 <- 77	  // 달리기
CUSTOM_ATTACKINFO_EXCUTION_5	 <- 78	  // 바닥에 누르기	
CUSTOM_ATTACKINFO_EXCUTION_6	 <- 79	  // 막타

CUSTOM_ATTACKINFO_AW_ATTACK1	 <- 80	  //  각성 - 변신 기본공격1 80
CUSTOM_ATTACKINFO_AW_ATTACK2	 <- 81	  //  각성 - 변신 기본공격2 81
CUSTOM_ATTACKINFO_AW_ATTACK3	 <- 82	  //  각성 - 변신 기본공격3 82
CUSTOM_ATTACKINFO_AW_ATTACK4	 <- 83	  //  각성 - 변신 기본공격4 83


CUSTOM_ATTACKINFO_AW_DASHATTACK	 <- 84	  //  각성 - 변신 기본공격4 84
CUSTOM_ATTACKINFO_RIPPER_EXPLOSION <-85
CUSTOM_ATTACKINFO_HIGH_SPEED_SLASH <-86   // 고속베기

CUSTOM_ATTACKINFO_AVENGER_ATTACK_1 <-87
CUSTOM_ATTACKINFO_AVENGER_ATTACK_2 <-88
CUSTOM_ATTACKINFO_AVENGER_ATTACK_3 <-89
CUSTOM_ATTACKINFO_AVENGER_ATTACK_4 <-90

CUSTOM_ATTACKINFO_HIGH_SPEED_SLASH_LAST <-91   // 고속베기
CUSTOM_ATTACKINFO_POWER_OF_DARKNESS	<- 92

CUSTOM_ATTACKINFO_AVENGER_ATTACK_3_2 <-93	// 어벤저 - 평타 막타찍기 어택
CUSTOM_ATTACKINFO_AVENGER_ATTACK_4_2 <-94	// 어벤저 - 평타 막타찍기 어택

CUSTOM_ATTACKINFO_DISASTER <-95	// 어벤저 ex스킬 재앙

CUSTOM_ATTACKINFO_PANDEMONIUM_EX_ON_START <- 96		// 어벤져 복마전 첫타 공격
CUSTOM_ATTACKINFO_AWAKENING_PANDEMONIUM_START <- 97 // 어벤져 복마전 첫타 공격 (각성)


E_ATTACK_COMMAND <- 0
E_JUMP_COMMAND <- 1
E_DASH_COMMANDS_1 <- 2
E_DASH_COMMANDS_2 <- 3
E_CREATURE_COMMAND <- 4
E_BUFF_COMMAND <- 5
E_SKILL_COMMAND <- 6
E_COMMAND_COUNT <- 7

// 어벤저 - 데빌스트라이커(패시브스킬) 스태택 데이타 ENUM INDEX
SI_DS_MAX_DEVIL_GAUGE <- 0 // 최대 악마게이지 수치
// 이하 데빌스트라이커 각 스킬별 게이지 차는 양
SI_DS_ATTACK <- 1 // (평타)
SI_DS_JUMP_ATTACK <- 2 // (점프공격)
SI_DS_DASH_ATTACK <- 3 // (대시공격)
SI_DS_DG_ATTACK <- 4 // (변신 평타공격)
SI_DS_DG_DASH_ATTACK <- 5 // (변신 대시공격)
SI_DS_DG_JUMP_ATTACK <- 6 // (변신 점프공격)
SI_DS_HIGH_SPEED_SLASH <- 7 // (고속베기)
SI_DS_GRASP_HANDOFANGER <- 8 // GraspHandOfAnger // (분노의 움켜쥠)
SI_DS_CHANGE_HPTOMP <- 9 // ChangeHpToMp (고통의 희열)
SI_DS_EARTH_QUAKE <- 10 // EarthQuake (어스퀘이크)
SI_DS_SPINCUTTER <- 11 // (스핀커터)
SI_DS_HEDGEHOG <- 12 // Hedgehog (헤지호그)
SI_DS_FASTMOVE <- 13 // (고속이동)
SI_DS_RIPPER <- 14 // (리퍼)
SI_DS_EXECUTION <- 15 // (처형)
SI_DS_DARK <- 16 // (어둠의 권능)
SI_DS_COOLTIME <- 17 // 디폴트 쿨타임
SI_DS_ANTIAIR_UPPER <- 18 // 공참타
SI_DS_SMASHER <- 19// 스매셔
SI_DS_SLOW_HEAL <- 20 // 슬로우힐
SI_DS_LUCKY_STRAIGHT <- 21 // 럭키 스트레이트
SI_DS_STRIKING <- 22 // 스트라이킹
SI_DS_CURE <- 23 // 큐어
SI_DS_SKILL_SECOND_UPPER <- 24 // 세컨드어퍼
SI_DS_BLESS <- 25 // 지혜의 축복
SI_DS_QUAKE_AREA <- 26 // 낙봉추
SI_DS_RISING_AREA <- 27 // 승천진
SI_DS_DISASTER <- 28 // EX스킬 - 재앙
SI_DS_PANDEMONI <- 29 // EX스킬 - 복마전
//PandemoniumEx


// 어벤저 - 각성 어펜디지 sq_var 벡터 인덱스 입니다..
I_AVENGER_AWAKENING_TIME	<- 0	// 변신 시간 
I_DOOMS_HP	<- 1	// 둠스가디언 HP
I_AVENGER_AWAKENING_VALID	<- 2 
// 리얼 밸리드 플래그로 쓸 멤버입니다.. 왜 이런식이 됐냐면.. 
// 어벤저가 state_stand상태에서만 변신해제가 되어야 합니다 
// 그래서 valid가 false가 된다고 해서 곧장 변신해제 됐다고 간주해서는 안됩니다 여러방법을 생각해낸 결과 이 방법이 가장 깔끔할거 같아서 입니다.. 
// 머 쓰이는 곳도 없으니까
