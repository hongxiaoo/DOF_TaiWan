// 이곳은 던파소스에 없는 순수 스크립트로만 개발하면서 필요한 스킬개발에 필요한 상수,enum 추가값을 선언하는 부분입니다. 
// 던파소스에 있는 값을 이곳에 넣으시면 안됩니다.


STATE_ATTACK					<- 8
STATE_WIND_STRIKE				<- 20	// 윈드 스트라이크
STATE_CRYSTALATTACK 			<- 21   // 크리스탈 어택
STATE_ELEMENTAL_CHANGE 			<- 22	// 속성발동
STATE_DARK_CHANGE 				<- 23	// 암전
STATE_FIRE_ROAD					<- 24	// 파이어로드
STATE_CHAINLIGHTNING			<- 25   // 체인라이트닝
STATE_ICEROAD 					<- 26	// 얼음길
STATE_ICE_SWORD					<- 27	// 빙검
STATE_HOLONG_LIGHT				<- 28	// 호롱불
STATE_PIECE_OF_ICE				<- 29	// 얼음파편
STATE_FLAMECIRCLE				<- 30	// 프레임서클
STATE_BLUEDRAGONWILL			<- 31	// 수룡의 의지
STATE_FROZENLAND				<- 32	// 얼어붙은 대지
STATE_ICE_AREA					<- 33	// 아이스 에어리어
STATE_ICE_CRASH					<- 34	// 아이스 크래쉬
STATE_BROKENARROW				<- 35	// 브로큰애로우
STATE_PUSH_OUT					<- 36	// 밀어내기
STATE_MAGIC_CANNON				<- 37	// 매직 캐넌
STATE_MAGIC_SHIELD				<- 38	// 보호막 형성
STATE_TELEPORT					<- 39	// 텔레포트
STATE_FALLENBLOSSOMS			<- 40	// 공통:낙화연창
STATE_TURNWINDMILL				<- 41	// 풍차돌리기
STATE_DARKNESSMANTLE			<- 42	// 다크니스맨틀
STATE_WATER_CANNON				<- 43	// 물대포
STATE_MANABURST					<- 44	// 마나폭주
STATE_RESONANCE					<- 45	// 공명
STATE_LIGHTNING_WALL			<- 46	// 라이트닝 월
STATE_FIREPILLAR				<- 47	// 불기둥
STATE_ICEMAN					<- 48	// 아이스맨
STATE_ELEMENTAL_RAIN			<- 49	// 엘레멘탈 레인
STATE_MULTI_SHOT				<- 50	// 연속구 발사
STATE_DIEHARD					<- 51	// 불사
STATE_ATMAGE_DASH_ATTACK		<- 52	// 수인체
STATE_ICECHAKRAM				<- 53	// 빙류환 (빙결사:각성액티브)

STATE_ELEMENTAL_BUSTER			<- 54	// 엘레멘탈 버스터

STATE_ICE_ORB_EX				<- 60 	// 특성 아이스 오브
STATE_CONCENTRATE_EX			<- 61	// 컨센트레이트(농축)
STATE_ELEMENTAL_STRIKE_EX		<- 62	// 엘레멘탈 스트라이크(ex)
STATE_ICE_FIELD_EX				<- 63	// 아이스 필드

// 남법사 skill관련 부분입니다.
// 
SKILL_WIND_STRIKE				<- 1	// 윈드 스트라이크
SKILL_ATCHAINLIGHTNING			<- 2	// 체인라이트닝
SKILL_CRYSTALATTACK 			<- 3	// 크리스탈 어택
SKILL_DARK_CHANGE				<- 4	// 암전
SKILL_ELEMENTAL_CHANGE 			<- 5	// 속성발동
SKILL_FIRE_ROAD					<- 6	// 파이어로드
SKILL_ICEROAD 					<- 7	// 얼음길
SKILL_ICE_SWORD					<- 8	// 빙검
SKILL_HOLONG_LIGHT				<- 9	// 호롱불
SKILL_PIECE_OF_ICE				<- 10	// 얼음파편
SKILL_FLAMECIRCLE				<- 11	// 프레임서클
SKILL_BLUEDRAGONWILL			<- 12	// 수룡의 의지
SKILL_FROZENLAND				<- 13	// 얼어붙은 대지
SKILL_ICE_AREA					<- 14	// 아이스에어리어
SKILL_ICE_CRASH					<- 15	// 아이스크래쉬
SKILL_BROKENARROW				<- 16	// 얼어붙은 대지
SKILL_PUSH_OUT					<- 17	// 밀어내기
SKILL_MAGIC_CANNON				<- 18	// 매직 캐넌
SKILL_MAGIC_SHIELD				<- 19	// 보호막 형성
SKILL_TELEPORT					<- 20	// 텔레포트
SKILL_FALLENBLOSSOMS			<- 21   // 공통:낙화연창
SKILL_EXPRESSION				<- 22   // 발현 (패시브)
SKILL_TURNWINDMILL				<- 23	// 풍차돌리기
SKILL_DARKNESSMANTLE			<- 24	// 다크니스 맨틀
SKILL_MULTI_SHOT				<- 25	// 연속 마법구 발사
SKILL_WATER_CANNON				<- 26	// 물대포
SKILL_FIREPILLAR				<- 27	// 불기둥
SKILL_MANABURST					<- 28	// 마나폭주
SKILL_LIGHTNING_WALL			<- 29	// 라이트닝월
SKILL_ELEMENTAL_RAIN			<- 30	// 엘레메날 레인
SKILL_RESONANCE					<- 31	// 공명
SKILL_ICEMAN					<- 32	// 아이스맨
SKILL_DIEHARD					<- 33	// 불사
SKILL_ELEMENTAL_SHIELD			<- 34	// 속성보호
SKILL_ICE_ELEMENTAL_ATTACK		<- 35	// 수인체


SKILL_CANCEL_WIND_STRIKE		<- 38	// 윈드 스트라이크
SKILL_CANCEL_PUSH_OUT			<- 39	// 밀어내기
SKILL_CANCEL_FALLENBLOSSOMS		<- 40   // 공통:낙화연창
SKILL_CANCEL_TURNWINDMILL		<- 41	// 풍차돌리기
SKILL_CANCEL_BROKENARROW		<- 42	// 얼어붙은 대지
SKILL_CANCEL_ICE_CRASH			<- 43	// 아이스크래쉬
SKILL_CANCEL_FROZENLAND			<- 44	// 얼어붙은 대지
SKILL_CANCEL_ICE_SWORD			<- 45	// 빙검
SKILL_CANCEL_MULTI_SHOT			<- 46	// 캔슬 연속 마법구 날리기
SKILL_CANCEL_FLAMECIRCLE		<- 47	// 프레임서클
SKILL_ICECHAKRAM				<- 48	// 빙류환 (빙결사:각성액티브)
SKILL_ELEMENTAL_BUSTER			<- 49	// 엘레멘탈 버스터(각성기)
SKILL_TUNDRASOUL				<- 50	// 툰드라의 가호 (빙결사:각성패시브)
SKILL_ELEMENTAL_CHAIN			<- 51	// 엘레멘탈 체인 (엘레멘탈바머:각성패시브)

SKILL_ICE_ORB_EX				<- 60	// 특성 아이스 오브
SKILL_CONCENTRATE_EX			<- 61	// 컨센트레트(농축)
SKILL_ELEMENTAL_STRIKE_EX		<- 62	// 엘레멘탈 스트라이크 (특성스킬)
SKILL_ICE_FIELD_EX				<- 63	// 아이스 필드


//211	`ATMage/WindStrikeEx.skl`	// 윈드스트라이크 강화
//212	`ATMage/ChainLightningEx.skl`	// 체인라이트닝 강화
SKILL_CRYSTALATTACK_EX			<- 213	//크리스탈 어택 강화
//214	`ATMage/DarkChangeEx.skl`	// 암전 강화//
SKILL_FIRE_ROAD_EX				<- 216	// 파이어로드 강화
SKILL_ICEROAD_EX				<- 217	// 얼음길 강화
SKILL_ICE_SWORD_EX				<- 218	// 빙백검 강화
//219	`ATMage/HolongLightEx.skl`	// 호롱불(귀설화) 강화
//220	`ATMage/PieceOfIceEx.skl`	// 피어스 오브 아이스 강화
//221	`ATMage/FlameCircleEx.skl`	// 프레임서클 강화
//222	`ATMage/BlueDragonWillEx.skl`	// 수룡의 의지(아이스 빅해머) 강화
//223	`ATMage/FrozenLandEx.skl`	// 얼어붙은 대지(극한의 물기둥) 강화
SKILL_ICE_AREA_EX				<- 224 // 아이스에어리어(아이스크리스탈샤워) 강화
//225	`ATMage/IceCrashEx.skl`		// 아이스크래쉬 강화
//226	`ATMage/BrokenArrowEx.skl`	// 브로큰에로우 강화
SKILL_PUSH_OUT_EX				<- 227	// 밀어내기(금나장) 강화
//228	`ATMage/MagicCannonEx.skl`	// 매직캐넌 강화
//229	`ATMage/MagicShieldEx.skl`	// 보호막형성 강화
//
//231	`ATMage/FallenBlossomsEx.skl`	// 낙화연창(설화연창) 강화
//
//233	`ATMage/TurnWindmillEx.skl`	// 풍차돌리기(회전투창) 강화
//234	`ATMage/DarknessMantleEx.skl`	// 다크니스 맨틀 강화
//235	`ATMage/MultiShotEx.skl`	// 연속발사 강화
//236	`ATMage/WaterCannonEx.skl`	// 물대포 강화
//237	`ATMage/FirePillarEx.skl`	// 불기둥 강화
//
SKILL_LIGHTNING_WALL_EX			<- 239	// 라이트닝 월 강화
//
//240	`ATMage/ElementalRainEx.skl`	// 엘레멘탈 레인 강화
//241	`ATMage/ResonanceEx.skl`	// 공명 강화
//242	`ATMage/IceManEx.skl`		// 아이스맨 강화



SKILL_BASIC_ATTACK_UP			<- 174  // 기본기 강화				


// 남법사 animation 관련 부분입니다.
//
CUSTOM_ANI_WIND_STRIKE				<- 0	// 윈드 스트라이크
CUSTOM_ANI_CRYSTALATTACK 			<- 1	// 크리스탈 어택
CUSTOM_ANI_DARK_CHANGE_READY 		<- 2	// 암전 : 캐스팅
CUSTOM_ANI_DARK_CHANGE_START		<- 3	// 암전 : 발동
CUSTOM_ANI_ELEMENTAL_CHANGE			<- 4	// 속성발동
CUSTOM_ANI_FIRE_ROAD_CAST1			<- 5	// 파이어로드 - 캐스팅1
CUSTOM_ANI_FIRE_ROAD_CAST2			<- 6	// 파이어로드 - 캐스팅2
CUSTOM_ANI_CHAINLIGHTNING_CAST		<- 7	// 7.체인라이트닝
CUSTOM_ANI_CHAINLIGHTNING			<- 8	// 8.체인라이트닝
CUSTOM_ANI_CHAINLIGHTNING_END		<- 9	// 9.체인라이트닝
CUSTOM_ANI_ICE_SWORD				<- 10	// 빙검
CUSTOM_ANI_HOLONG_LIGHT				<- 11	// 호롱불
CUSTOM_ANI_PIECE_OF_ICE				<- 12	// 얼음파편
CUSTOM_ANI_ICEROAD					<- 13	// 얼음길
CUSTOM_ANI_FLAMECIRCLE1				<- 14	// 프레임서클1 - 시동
CUSTOM_ANI_FLAMECIRCLE2				<- 15	// 프레임서클2 - 준비
CUSTOM_ANI_FLAMECIRCLE3				<- 16	// 프레임서클3 - 발사
CUSTOM_ANI_BLUEDRAGONWILL1			<- 17	// 수룡의 의지1
CUSTOM_ANI_BLUEDRAGONWILL2			<- 18	// 수룡의 의지2
CUSTOM_ANI_BLUEDRAGONWILL3			<- 19	// 수룡의 의지3
CUSTOM_ANI_FROZENLAND1				<- 20	// 얼어붙은 대지1
CUSTOM_ANI_FROZENLAND2				<- 21	// 얼어붙은 대지2

CUSTOM_ANI_ICE_AREA					<- 22	// 아이스 에어리어
CUSTOM_ANI_ICE_CRASH_START			<- 23	// 아이스 크래쉬 시작
CUSTOM_ANI_ICE_CRASH_LOOP			<- 24	// 아이스 크래쉬 반복
CUSTOM_ANI_ICE_CRASH_LOOP_ATTACK	<- 25	// 아이스 크래쉬 반복 공격시
CUSTOM_ANI_ICE_CRASH_END			<- 26	// 아이스 크래쉬 막타
CUSTOM_ANI_FROZENLAND3				<- 27	// 얼어붙은 대지3
CUSTOM_ANI_BROKENARROW1				<- 28	// 브로큰에로우 1
CUSTOM_ANI_BROKENARROW_LOOP1		<- 29	// 브로큰에로우 1 loop
CUSTOM_ANI_PUSH_OUT_GRAB			<- 30	// 밀어내기 : 밀기전 잡기

CUSTOM_ANI_PUSH_OUT					<- 31	// 밀어내기
CUSTOM_ANI_BROKENARROW_DASH1		<- 32	// 브로큰에로우 2
CUSTOM_ANI_BROKENARROW_DASH2		<- 33	// 브로큰에로우 3
CUSTOM_ANI_AT_MAGIC_CANNON_1		<- 34	// 매직 캐넌 수평
CUSTOM_ANI_AT_MAGIC_SHIELD			<- 35	// 보호막 형성
CUSTOM_ANI_TELEPORT1				<- 36	// 텔레포트1
CUSTOM_ANI_TELEPORT2				<- 37	// 텔레포트2
CUSTOM_ANI_FALLENBLOSSOMS1			<- 38	// 낙화연창1
CUSTOM_ANI_FALLENBLOSSOMS2			<- 39	// 낙화연창2
CUSTOM_ANI_FALLENBLOSSOMS3			<- 40	// 낙화연창3

CUSTOM_ANI_AT_MAGIC_CANNON_2		<- 41	// 매직 캐넌 대각선
CUSTOM_ANI_AT_MAGIC_CANNON_3		<- 42	// 매직 캐넌 수직
CUSTOM_ANI_TURNWINDMILL1			<- 43	// 풍차 돌리기1
CUSTOM_ANI_TURNWINDMILL2			<- 44	// 풍차 돌리기2
CUSTOM_ANI_DARKNESSMANTLE			<- 45	// 다크니스맨틀
CUSTOM_ANI_AT_MAGIC_CANNON_READY	<- 46	// 매직 캐넌 준비
CUSTOM_ANI_WATER_CANNON				<- 47	// 물대포
CUSTOM_ANI_ICE_ELEMENTAL_ATTACK1	<- 48	// 수인체 공격1
CUSTOM_ANI_ICE_ELEMENTAL_ATTACK2	<- 49	// 수인체 공격2
CUSTOM_ANI_ICE_ELEMENTAL_ATTACK3	<- 50	// 수인체 공격3

CUSTOM_ANI_ICE_ELEMENTAL_DASH_ATTACK	<- 51	// 수인체 대쉬 공격
CUSTOM_ANI_ICE_ELEMENTAL_JUMP_ATTACK	<- 52	// 수인체 점프 공격
CUSTOM_ANI_LIGHTNING_WALL				<- 53	// 라이트닝 월
CUSTOM_ANI_RESONANCE					<- 54	// 공명
CUSTOM_ANI_FIREPILLAR1					<- 55	// 불기둥1
CUSTOM_ANI_FIREPILLAR2					<- 56	// 불기둥2
CUSTOM_ANI_FIREPILLAR3					<- 57	// 불기둥3
CUSTOM_ANI_ICEMAN1						<- 58	// 58. 아이스맨1 (타겟팅)
CUSTOM_ANI_ICEMAN2						<- 59	// 59. 아이스맨2 (캐스팅)
CUSTOM_ANI_ICEMAN3						<- 60	// 60. 아이스맨3 (이동)

CUSTOM_ANI_ICEMAN4						<- 61	// 61. 아이스맨4 (난타)
CUSTOM_ANI_ICEMAN5						<- 62	// 62. 아이스맨5 (강타)
CUSTOM_ANI_ELEMENTAL_RAIN_CAST			<- 63	// 63. 엘레멘탈 레인 캐스팅 시작
CUSTOM_ANI_ELEMENTAL_RAIN_JUMP			<- 64	// 64. 엘레멘탈 레인 점프
CUSTOM_ANI_ELEMENTAL_RAIN_JUMP_STAY		<- 65	// 65. 엘레멘탈 레인 점프 대기
CUSTOM_ANI_ELEMENTAL_RAIN_SHOOT			<- 66	// 66. 엘레멘탈 레인 속성 발사.
CUSTOM_ANI_ELEMENTAL_RAIN_CHARGE_SHOOT	<- 67	// 67. 엘레멘탈 레인 차지슛 발사.
CUSTOM_ANI_MULTI_SHOT					<- 68	// 68. 연속 마법구 발사.
CUSTOM_ANI_ICEMAN6						<- 69	// 69. 아이스맨6 (웨이트)
CUSTOM_ANI_DIEHARD1						<- 70	// 70. 불사1

CUSTOM_ANI_DIEHARD2						<- 71	// 71. 불사2
CUSTOM_ANI_DIEHARD3						<- 72	// 72. 불사3
CUSTOM_ANI_FROZENLAND_CASTING			<- 73	// 73. 얼어붙은 대지 캐스팅
CUSTOM_ANI_FLAMECIRCLE_CASTING			<- 74	// 74. 프레임서클 캐스팅
CUSTOM_ANI_DARKNESSMANTLE_CASTING		<- 75	// 75. 다크니스맨틀 캐스팅
CUSTOM_ANI_ICEROAD_CASTING				<- 76	// 76. 얼음길 캐스팅
CUSTOM_ANI_PUSH_OUT_ATTACK				<- 77	// 77. 밀어내기 밀기
CUSTOM_ANI_AT_MAGIC_CANNON_4			<- 78	// 78. 매직캐넌 지상타
CUSTOM_ANI_ICECHAKRAM_1					<- 79	// 79. 빙류환1

CUSTOM_ANI_ICECHAKRAM_2					<- 80	// 80. 빙류환2
CUSTOM_ANI_ICECHAKRAM_3					<- 81	// 81. 빙류환3
CUSTOM_ANI_ICECHAKRAM_4					<- 82	// 82. 빙류환4
CUSTOM_ANI_ICECHAKRAM_5					<- 83	// 83. 빙류환5
CUSTOM_ANI_ICECHAKRAM_6					<- 84	// 84. 빙류환6
CUSTOM_ANI_ELEMENTAL_BUSTER_FIRE_CAST	<- 85	// 85. 엘레멘탈 버스터 (화속성 발동)
CUSTOM_ANI_ELEMENTAL_BUSTER_FIRE		<- 86	// 86. 엘레멘탈 버스터
CUSTOM_ANI_ELEMENTAL_BUSTER_WATER_CAST	<- 87	// 87. 엘레멘탈 버스터 (수속성 발동)
CUSTOM_ANI_ELEMENTAL_BUSTER_WATER		<- 88	// 88. 엘레멘탈 버스터
CUSTOM_ANI_ELEMENTAL_BUSTER_LIGHT_CAST	<- 89	// 89. 엘레멘탈 버스터 (명속성 발동)
CUSTOM_ANI_ELEMENTAL_BUSTER_LIGHT		<- 90	// 90. 엘레멘탈 버스터
CUSTOM_ANI_ELEMENTAL_BUSTER_DARK_CAST	<- 91	// 91. 엘레멘탈 버스터 (암속성 발동)

CUSTOM_ANI_ELEMENTAL_BUSTER_DARK		<- 92	// 92. 엘레멘탈 버스터
CUSTOM_ANI_ICE_ORB_EX					<- 93	// 93. 아이스 오브 애니(특성) 인덱스
CUSTOM_ANI_CONCENTRATE_EX				<- 94	// 94. 컨센트레이트(특성)
CUSTOM_ANI_ELEMENTAL_STRIKE_EX			<- 95	// 95. 엘레멘탈 스트라이크(특성)
CUSTOM_ANI_ICE_FIELD_EX					<- 96	// 96. 아이스 필드(특성)


// 남법사 atk파일 관련 부분입니다.
// 
CUSTOM_ATTACK_INFO_DARK_CHANGE		<- 0	// 암전 : 공격정보
CUSTOM_ATTACK_INFO_ICE_SWORD		<- 1	// 빙검 : 공격정보
CUSTOM_ATTACK_INFO_ICE_SWORD_LAST	<- 2	// 빙검막타 : 공격정보
CUSTOM_ATTACK_INFO_PIECE_OF_ICE		<- 3	// 얼음파판 : 공격정보
CUSTOM_ATTACK_INFO_FLAMECIRCLE		<- 4	// 프레임서클 : 공격정보
CUSTOM_ATTACK_INFO_ICE_CRASH		<- 5	// 아이스크래쉬
CUSTOM_ATTACK_INFO_ICE_CRASH_LAST	<- 6	// 아이스크래쉬
CUSTOM_ATTACK_INFO_PUSH_OUT_GRAB<- 7	// 밀어내기 잡기
CUSTOM_ATTACK_INFO_PUSH_OUT		<- 8	// 밀어내기
CUSTOM_ATTACK_INFO_AT_MAGE_BROKENARROW			<- 9	// 브로큰애로우 막타 `ATAttackInfo/BrokenArrow.atk` 
CUSTOM_ATTACK_INFO_FALLENBLOSSOMS				<- 10	// 낙화연창 `ATAttackInfo/FallenBlossoms.atk`		
CUSTOM_ATTACK_INFO_AT_MAGE_MAGIC_SHIELD_FIRE	<- 11	// 보호막 형성 화속성
CUSTOM_ATTACK_INFO_AT_MAGE_MAGIC_SHIELD_LIGHT	<- 12	// 보호막 형성 명속성
CUSTOM_ATTACK_INFO_TURN_WINDMILL				<- 13	// 1ATAttackInfo/TurnWindmill.atk`
CUSTOM_ATTACK_INFO_ICE_ELEMENTAL_ATTACK1		<- 14	// 수인체 공격1
CUSTOM_ATTACK_INFO_ICE_ELEMENTAL_ATTACK2		<- 15	// 수인체 공격1
CUSTOM_ATTACK_INFO_ICE_ELEMENTAL_ATTACK3		<- 16	// 수인체 공격1
CUSTOM_ATTACK_INFO_ICE_ELEMENTAL_DASH_ATTACK	<- 17	// 수인체 대쉬 공격
CUSTOM_ATTACK_INFO_ICE_ELEMENTAL_JUMP_ATTACK	<- 18	// 수인체 점프 공격
CUSTOM_ATTACK_INFO_RESONANCE					<- 19	// 공명
CUSTOM_ATTACK_INFO_ICEMAN						<- 20	// 아이스맨
CUSTOM_ATTACK_INFO_ICE_CHAKRAM					<- 21	// 아이스맨


ENUM_ELEMENT_FIRE	<- 0	/// 화
ENUM_ELEMENT_WATER	<- 1	/// 수
ENUM_ELEMENT_DARK	<- 2	/// 암
ENUM_ELEMENT_LIGHT	<- 3	/// 명
ENUM_ELEMENT_NONE	<- 4	/// 무
ENUM_ELEMENT_MAX	<- 4	/// 속성 최대 값

VECTOR_FLAG_0	<- 0
VECTOR_FLAG_1	<- 1
VECTOR_FLAG_2	<- 2
VECTOR_FLAG_3	<- 3
VECTOR_FLAG_4	<- 4
VECTOR_FLAG_5	<- 5

SKL_STATIC_INT_IDX_0	<- 0
SKL_STATIC_INT_IDX_1	<- 1
SKL_STATIC_INT_IDX_2	<- 2
SKL_STATIC_INT_IDX_3	<- 3
SKL_STATIC_INT_IDX_4	<- 4
SKL_STATIC_INT_IDX_5	<- 5
SKL_STATIC_INT_IDX_6	<- 6
SKL_STATIC_INT_IDX_7	<- 7
SKL_STATIC_INT_IDX_8	<- 8

SKL_LVL_COLUMN_IDX_0	<- 0
SKL_LVL_COLUMN_IDX_1	<- 1
SKL_LVL_COLUMN_IDX_2	<- 2
SKL_LVL_COLUMN_IDX_3	<- 3
SKL_LVL_COLUMN_IDX_4	<- 4
SKL_LVL_COLUMN_IDX_5	<- 5
SKL_LVL_COLUMN_IDX_6	<- 6

PASSIVEOBJ_SUB_STATE_0	<- 10
PASSIVEOBJ_SUB_STATE_1	<- 11
PASSIVEOBJ_SUB_STATE_2	<- 12
PASSIVEOBJ_SUB_STATE_3	<- 13
PASSIVEOBJ_SUB_STATE_4	<- 14
PASSIVEOBJ_SUB_STATE_5	<- 15
PASSIVEOBJ_SUB_STATE_6	<- 16
PASSIVEOBJ_SUB_STATE_7	<- 17

BROKENARROW_UNIQUE_ID <- 9001



VECTOR_I_STATE					<- 0
VECTOR_I_FLAG					<- 1
VECTOR_I_REBIRTH_STATE			<- 2
VECTOR_I_REBIRTH_TIME			<- 3


GHOST_TIME <- 2000
ANGEL_DOWN_TIME <- 1000
DOWN_PAUSE_TIME <- 100






