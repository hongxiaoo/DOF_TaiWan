// 던파소스내 enum값을 squirrel script에서도 사용하기 위해 변환해놓은 값들입니다. 
// 순수 스크립트로 작업하면서 추가해야할 값들이 있다면.. 각 직업_header.nut파일에 삽입해주세요.. 이곳에 추가금지

LANDTYPE_GRASS <- 0 		  //  풀밭
LANDTYPE_WETGRASS <- 1 		  //  물에 젙은 풀밭
LANDTYPE_SWAMP <- 2 		  //  늪지의 위
LANDTYPE_POISONSWAMP <- 3 		  //  독늪지의 위
LANDTYPE_BROWNDIRT <- 4 		  //  갈색 흙밭
LANDTYPE_BLUEDIRT <- 5 		  //  푸른 흙밭
LANDTYPE_BONEYARD <- 6 		  //  뼈조각들의 위
LANDTYPE_WATER <- 7 		  //  물속
LANDTYPE_MAGMA <- 8 		  //  용암 위
LANDTYPE_SNOW <- 9 		  //  눈 위
LANDTYPE_RED_SWAMP <- 10 
LANDTYPE_PURPLE_POISONSWAMP <- 11 		  //  보라색 독늪
LANDPARTICLE_DOWNLARGE <- 0 
LANDPARTICLE_DOWNSMALL <- 1 
LANDPARTICLE_MOVE <- 2 
LANDSOUND_JUMPSTART <- 0 
LANDSOUND_JUMPLAND <- 1 
LANDSOUND_MOVE <- 2 
LANDSOUND_DASH <- 3 
LANDSOUND_BACKSTEP <- 4 
LANDSOUND_FASTTHROUGH <- 5 

CATEGORY_TRIBE_HUMAN <- 0 		  //  인간형
CATEGORY_TRIBE_BEAST <- 1 		  //  야수
CATEGORY_TRIBE_PLANT <- 2 		  //  식물
CATEGORY_TRIBE_INSECT <- 3 		  //  곤충
CATEGORY_TRIBE_MACHINE <- 4 		  //  기계
CATEGORY_TRIBE_ORGANIC <- 5 		  //  유기체
CATEGORY_TRIBE_HYBRID <- 6 		  //  복합체
CATEGORY_TRIBE_UNDEAD <- 7 		  //  언데드
CATEGORY_TRIBE_DEVIL <- 8 		  //  악마
CATEGORY_TRIBE_SPIRIT <- 9 		  //  정령
CATEGORY_TRIBE_DRAGON <- 10 		  //  용족
CATEGORY_AI_MELEE_ATTACK <- 11 		  //  접근전용 몬스터
CATEGORY_AI_RANGE_ATTACK <- 12 		  //  사격전용 몬스터
CATEGORY_AI_NEGATIVE <- 13 		  //  소극적인 몬스터
CATEGORY_AI_CAREFUL <- 14 		  //  주의깊은 몬스터
CATEGORY_AI_FULLSUPERARMOR <- 15 		  //  접근AI 저돌,위협 몬스터일때 풀슈퍼아머 (몬스터 개편에 AI category가 사라지므로 잠시 넣어둔 항목임) `08. 02, 20 임수홍
CATEGORY_AI_RASH <- 16 		  //  저돌적인 몬스터
CATEGORY_AI_MANACE <- 17 		  //  위협적인 몬스터
CATEGORY_ARMOR_HUMAN <- 18 		  //  인간 아머 (살상 옵션 적용)
CATEGORY_ARMOR_FORT <- 19 		  //  건물 아머 (파괴 옵션 적용)
CATEGORY_ARMOR_DIVINE <- 20 		  //  성령 아머 (방어력 비약적 증가)
CATEGORY_ETC_GOBLIN <- 21 		  //  고블린
CATEGORY_ETC_TAU <- 22 		  //  타우
CATEGORY_ETC_LUGARU <- 23 		  //  루가루
CATEGORY_ETC_FIXTURE <- 24 		  //  붙박이형 (허리케인 롤 등에 의해 끌려오지 않는다)
CATEGORY_ETC_STAY <- 25 		  //  초기 위치에서 움직이지 않음
CATEGORY_PASSIVEOBJECT_TYPE_MELEE <- 26 
CATEGORY_PASSIVEOBJECT_TYPE_MISSILE <- 27 
CATEGORY_PASSIVEOBJECT_TYPE_ENERGY <- 28 
CATEGORY_PASSIVEOBJECT_TYPE_PHYSICAL <- 29 
CATEGORY_PASSIVEOBJECT_TYPE_MAGICAL <- 30 
CATEGORY_PASSIVEOBJECT_TYPE_BULLET <- 31 
CATEGORY_PASSIVEOBJECT_TYPE_CANON <- 32 
CATEGORY_PASSIVEOBJECT_TYPE_EXPLOSION <- 33 
CATEGORY_PASSIVEOBJECT_TYPE_INFLAME <- 34 
CATEGORY_PASSIVEOBJECT_TYPE_NONINFLAME <- 35 
CATEGORY_PASSIVEOBJECT_TYPE_LIGHT <- 36 
CATEGORY_PASSIVEOBJECT_TYPE_DARK <- 37 
CATEGORY_PASSIVEOBJECT_TYPE_WATER <- 38 
CATEGORY_PASSIVEOBJECT_TYPE_FIRE <- 39 
CATEGORY_PASSIVEOBJECT_TYPE_FORT <- 40 
CATEGORY_ETC_UNBEATABLE <- 41 		  //  무적, 그러나 암흑의 문장 어펜디지에 걸린 놈이면 공격가능
CATEGORY_TRIBE_ANGEL <- 42 		  //  천사
CATEGORY_MAX <- 43 

DOWN_PARAM_TYPE_VALUE <- 0 		  //  뜨는 높이와 날리는 속도를 넣는다.
DOWN_PARAM_TYPE_FORCE <- 1 		  //  힘을 넣는다.
DOWN_PARAM_TYPE_BOUNCE_VALUE <- 2 		  //  바운스. 값을 넣지만 바로 쓰지 않고 땅에 튀길 때 쓴다.
DOWN_PARAM_TYPE_BOUNCE_FORCE <- 3 		  //  바운스. 힘을 넣지만 바로 쓰지 않고 땅에 튀길 때 쓴다.
DOWN_PARAM_TYPE_BOUNCE <- 4 		  //  바운스. 힘을 넣지만 바로 쓰지 않고 땅에 튀길 때 쓴다.

ENUM_DIRECTION_LEFT <- 0 
ENUM_DIRECTION_RIGHT <- 1 
ENUM_DIRECTION_UP <- 2 
ENUM_DIRECTION_DOWN <- 3 
ENUM_DIRECTION_NEUTRAL <- 4 
ENUM_DIRECTION_MAX <- 5 

GRAPHICEFFECT_NONE <- 0 		  //  없음
GRAPHICEFFECT_DODGE <- 1 		  //  닷지
GRAPHICEFFECT_LINEARDODGE <- 2 		  //  리니어 닷지
GRAPHICEFFECT_DARK <- 3 		  //  다크
GRAPHICEFFECT_XOR <- 4 		  //  XOR
GRAPHICEFFECT_MONOCHROME <- 5 		  //  단색
GRAPHICEFFECT_SPACE_DISTORT <- 6 		  //  공간외곡
GRAPHICEFFECT_MAX <- 7 

ENUM_DRAWLAYER_CONTACT <- 0 		  //  접경 레이어
ENUM_DRAWLAYER_NORMAL <- 1 		  //  일반 레이어
ENUM_DRAWLAYER_BOTTOM <- 2 		  //  바닥 레이어
ENUM_DRAWLAYER_CLOSEBACK <- 3 		  //  근경 레이어
ENUM_DRAWLAYER_MIDDLEBACK <- 4 		  //  중경 레이어
ENUM_DRAWLAYER_DISTANTBACK <- 5 		  //  원경 레이어
ENUM_DRAWLAYER_COVER <- 6 		  //  화면을 덮는 레이어 ex : Blind
ENUM_DRAWLAYER_MAX <- 7 

STATE_STAND <- 0 		  //  서있기, 이동
STATE_SIT <- 1 		  //  앉기 (일어나기 전)
STATE_SIT_FOREVER <- 2 		  //  앉아있기
STATE_DAMAGE <- 3 		  //  맞기
STATE_DOWN <- 4 		  //  다운 
STATE_DIE <- 5 		  //  죽기
STATE_JUMP <- 6 		  //  점프
STATE_JUMP_ATTACK <- 7 		  //  점프
STATE_ATTACK <- 8 		  //  공격
STATE_HOLD <- 9 		  //  동작 불능 상태
STATE_SUMMONSTART <- 10 		  //  소환 시작
STATE_SUMMONEND <- 11 		  //  소환 완료
STATE_UNSUMMON <- 12 		  //  역소환되서 사라짐
STATE_THROW <- 13 		  //  투척
STATE_DASH <- 14 		  //  대쉬 
STATE_DASH_ATTACK <- 15 		  //  대쉬 어택
STATE_GET_ITEM <- 16 		  //  아이템 줍기
STATE_BUFF <- 17 		  //  버프
STATE_QUICK_STANDING <- 18 		  //  퀵스탠딩							
STATE_CROUCH <- 19 		  //  크라우치
STATE_CROUCH_ATTACK <- 20 		  //  크라우치 어깨치기
STATE_LOW_KICK <- 21 		  //  로킥, 본 크러셔, 사로킥
STATE_TRY_GRAB <- 22 		  //  잡기 시도
STATE_SUPLEX <- 23 		  //  수플렉스
STATE_JUMP_SUPLEX <- 24 		  //  스파이어
STATE_JUMP_SUPLEX_LARIAT <- 25 		  //  스파이어 회전 추가타
STATE_MOUNT_TRY <- 26 		  //  마운트 시도
STATE_MOUNT <- 27 		  //  마운트
STATE_STOMP <- 28 		  //  밟기
STATE_CLOSE_PUNCH <- 29 		  //  원인치 펀치
STATE_LIFT_UPPER <- 30 		  //  무즈 어퍼
STATE_GRAB_EXPLOSION <- 31 		  //  일발화약성
STATE_VIRTUAL_ATTACK <- 32 		  //  일반 공격 -> 해머킥 등을 위한 가상 STATE
STATE_SHOULDER_TACKLE <- 33 		  //  숄더 태클
STATE_WHIRL_WIND_KICK <- 34 		  //  선풍각
STATE_BLOCK_BUSTER <- 35 		  //  블록 버스터
STATE_TRY_LEG_SUPLEX <- 36 		  //  에어슈타이너 시도
STATE_LEG_SUPLEX <- 37 		  //  에어슈타이너 실행
STATE_LIGHTNING_DANCE <- 38 		  //  라이트닝 댄스
STATE_THROW_WEB <- 39 		  //  천라지망
STATE_HIDDEN_STING <- 40 		  //  바늘 장전(히든스팅)
STATE_VENOM_MINE <- 41 		  //  베놈마인
STATE_JUNK_SPIN <- 42 		  //  정크스핀
STATE_SHOULDER_CHARGE <- 43 		  //  철산고
STATE_SINGLE_KICK <- 44 		  //  해머킥
STATE_NEN_FLOWER <- 45 		  //  넨화
STATE_THROW_ENEMY <- 46 		  //  로플링
STATE_DASH_PUNCH <- 47 		  //  정권 찌르기
STATE_PUNCH_AFTER_RETURN <- 48 		  //  타격후 뒤로돌리기
STATE_RANDOM_KICK <- 49 		  //  백열각 난타
STATE_RISING_UPPER <- 50 		  //  승룡권
STATE_DASH_AFTER_DASH <- 51 		  //  호신연격
STATE_EARTH_BREAK <- 52 		  //  금강쇄
STATE_HOLD_UP <- 53 		  //  홀드업
STATE_WILD_CANNON_SPIKE <- 54 		  //  와일드 캐논 스파이크
STATE_SUPLEX_CYCLONE <- 55 		  //  수플렉스 사이클론
STATE_LIGHTNING_DRAGON <- 56 		  //  광충노도
STATE_STRONGEST_LOW_KICK <- 57 		  //  사상 최강의 로킥
STATE_GROUND_KICK <- 58 		  //  그라운드킥
STATE_FAST_DASH <- 59 		  //  순보
STATE_DESTROY_EARTH_SKY_DROP <- 60 		  //  스트리트 파이터 각성기 - 천붕지괴
STATE_TYPHOON <- 61 		  //  그래플러 각성기
STATE_FLAME_LEGS <- 62 		  //  스트라이커 각성기 - 화염의각
STATE_THROW_SAND <- 63 		  //  헬터스켌터
STATE_ENCHANT_POISON <- 64 		  //  독장전
STATE_SPIRAL_NEN_SHOOT <- 65 		  //  나선의 넨 : 출
STATE_NEN_SPEAR_EX <- 66 		  //  넨 스피어(특성) proc에서 플래그1에 몸 오버레이,화면 플래쉬    플래그2 에 꽂히는 어펜디지 소환 
STATE_HURRICANE_SPEAR <- 67 		  //  허리케인 스피어 (특성)
STATE_CRASH_ROPE <- 68 		  //  광폭혈사 (특성)
STATE_CHARGE_SPEAR_EX <- 69 		  //  차지 스피어(특성)
STATE_SPIRAL_COLUMN_EX <- 70 		  //  나선환(특성)
STATE_GLUEY_FRUIT_EX <- 71 		  //  끈적끈적 열매(특성)
STATE_CHAIN_KICK_EX <- 72 		  //  연환퇴 (특성)
STATE_108_STAIRS_EX <- 73 		  //  108계단 (특성)
STATE_INHERIT_START <- 74 
STATE_MAX <- 75 

SKILL_SHOULDER_CHARGE <- 1 		  //  001.철산고
SKILL_CROUCH <- 2 		  //  002.크라우치
SKILL_GRAB_EXPLOSION <- 3 		  //  003.일발화약성
SKILL_CRASH_LOW_KICK <- 4 		  //  004.본 크러셔
SKILL_LIFT_UPPER <- 5 		  //  005.무즈 어퍼
SKILL_DAMAGE_LOW_KICK <- 6 		  //  006.로킥
SKILL_PHYSICAL_DEFENSE_UP <- 7 		  //  007.철금강
SKILL_CREATE_ILLUSION <- 8 		  //  008.분신
SKILL_SUPLEX <- 9 		  //  009.수플렉스
SKILL_BACK_SUPLEX <- 10 		  //  010.백브레이커
SKILL_THUNDER_SUPLEX <- 11 		  //  011.수플렉스 썬더
SKILL_ENERGY_BALL <- 12 		  //  012.넨탄
SKILL_THROW_SAND <- 13 		  //  013.헬터 스켈터
SKILL_MOUNT <- 14 		  //  014.마운트
SKILL_ROAR_STUN <- 15 		  //  015.사자후
SKILL_ENERGY_FIELD <- 16 		  //  016.기공장
SKILL_STOMP <- 17 		  //  017.공중 밟기
SKILL_JUMP_SUPLEX <- 18 		  //  018.스파이어
SKILL_CLOSE_PUNCH <- 19 		  //  019.원인치 펀치
SKILL_SUPER_ARMOR <- 20 		  //  020.슈퍼아머
SKILL_CANCEL_ENERGY_BALL <- 21 		  //  021.캔슬 넨탄
SKILL_SUPLEX_SUB_POWER_UP <- 22 		  //  022.강렬한 테이크 다운
SKILL_CANCEL_LIFT_UPPER <- 23 		  //  023.캔슬 무즈 어퍼
SKILL_CANCEL_LOW_KICK <- 24 		  //  024.캔슬 로킥
SKILL_CANCEL_THROW_SAND <- 25 		  //  025.캔슬 헬터 스켈터
SKILL_CANCEL_CLOSE_PUNCH <- 26 		  //  026.캔슬 원인치 펀치
SKILL_CANCEL_SUPLEX <- 27 		  //  027.캔슬 수플렉스
SKILL_CANCEL_JUMP_SUPLEX <- 28 		  //  028.캔슬 스파이어
SKILL_LIGHT_FRIENDSHIP <- 29 		  //  029.빛의 친화
SKILL_LIGHT_ENCHANT_WEAPON <- 30 		  //  030.카이
SKILL_ATTACK_SPEED_UP <- 31 		  //  031.활성화 숨결
SKILL_POISON_TOLERANCE_UP <- 32 		  //  032.독에 익숙함
SKILL_STUN_ON_USE_SKILL <- 33 		  //  033.주화입마
SKILL_EQUIP_BOXING_GLOVE <- 34 		  //  034.권투글러브 사용 가능
SKILL_BLIND_TOLERANCE_UP <- 35 		  //  035.넨으로 느낀다
SKILL_LIGHT_TOLERANCE_UP <- 36 		  //  036.태양의 커튼
SKILL_SLOW_DOWN_POWER_UP <- 37 		  //  037.강권
SKILL_ENCHANT_POISON <- 38 		  //  038.독 장전(독바르기)
SKILL_AIM_VITAL_POINT <- 39 		  //  039.급소 지정
SKILL_SPIRAL_NEN <- 40 		  //  040.나선의 넨
SKILL_FLAME_LEGS <- 41 		  //  041.스트라이커 각성기 - 화염의각
SKILL_NEN_GUARD <- 42 		  //  042.넨가드
SKILL_DOUBLE_THROW <- 43 		  //  043.이중 투척
SKILL_PROVOCATION <- 44 		  //  044.도발
SKILL_CLAW_MASTERY <- 45 		  //  045.클로 마스터리
SKILL_SINGLE_KICK <- 46 		  //  046.해머 킥
SKILL_CANCEL_SINGLE_KICK <- 47 		  //  047.캔슬 해머 킥
SKILL_CANCEL_GRAB_EXPLOSION <- 48 		  //  048.캔슬 일발화약성
SKILL_THROW_ENEMY <- 49 		  //  049.로플링
SKILL_DEFINITE_GRAB <- 50 		  //  050.반드시 잡는다!
SKILL_SLIDE_GRAB <- 51 		  //  051.슬라이딩 그랩
SKILL_THROW_WEB <- 52 		  //  052.천라지망
SKILL_CANCEL_THROW_ENEMY <- 53 		  //  053.캔슬 로플링
SKILL_SHOULDER_TACKLE <- 54 		  //  054.숄더 태클
SKILL_GRAB_CANNON <- 55 		  //  055.그랩 캐논
SKILL_ARMOR_MASTERY_LIGHT_SK <- 56 		  //  056.넘치는 힘의 경갑 마스터리
SKILL_ARMOR_MASTERY_LIGHT_GP <- 57 		  //  057.강인한 근성의 경갑 마스터리
SKILL_WHIRL_WIND_KICK <- 58 		  //  058.질풍각
SKILL_CANCEL_WHIRL_WIND_KICK <- 59 		  //  059.캔슬 질풍각
SKILL_BLOCK_BUSTER <- 60 		  //  060.블록 버스터
SKILL_CANCEL_THROW <- 61 		  //  061.캔슬 투척
SKILL_LEG_SUPLEX <- 62 		  //  062.에어슈타이너
SKILL_TYPHOON <- 63 		  //  063.그래플러 각성기
SKILL_DUMMY <- 64 		  //  064.사용하지 않음.
SKILL_EFFICIENT_BURN <- 65 		  //  065.스트라이터 각성 패시브 - 효율적인 연소
SKILL_GRAB_MASTERY <- 66 		  //  066.잡기 마스터리
SKILL_NEN_FLOWER <- 67 		  //  067.넨화
SKILL_LIGHTNING_DANCE <- 68 		  //  068.라이트닝 댄스
SKILL_ILLUSION_BOMB <- 69 		  //  069.환영폭쇄
SKILL_POWER_UP_ON_DASH <- 70 		  //  070.스탬피드
SKILL_STRONGEST_LOW_KICK <- 71 		  //  071.사상최강의 로킥
SKILL_NEN_SHIELD <- 72 		  //  072.흩날리는 천염화
SKILL_ARMOR_MASTERY_HEAVY_SP <- 73 		  //  073.중갑 마스터리
SKILL_CRAZY_MOUNT <- 74 		  //  074.지랄 마운트
SKILL_HIDDEN_STING <- 75 		  //  075.히든스팅
SKILL_VENOM_MINE <- 76 		  //  076.베놈마인
SKILL_JUNK_SPIN <- 77 		  //  077.정크스핀
SKILL_ENERGY_BALL_CHARGE <- 78 		  //  078.넨탄 모아쏘기
SKILL_NEN_MONSTER_WHITE_TIGER <- 79 		  //  079.넨수 : 백호
SKILL_DASH_PUNCH <- 80 		  //  080.정권찌르기
SKILL_PUNCH_AFTER_RETURN <- 81 		  //  081.타격후 뒤로돌리기
SKILL_RANDOM_KICK <- 82 		  //  082.백열각 난타
SKILL_RISING_UPPER <- 83 		  //  083.승룡권
SKILL_DASH_AFTER_DASH <- 84 		  //  084.호신연격
SKILL_DASH_AFTER_DASH_EXTENSION <- 85 		  //  085.호포
SKILL_EARTH_BREAK <- 86 		  //  086.금강쇄
SKILL_HOLD_UP <- 87 		  //  087.홀드업
SKILL_WILD_CANNON_SPIKE <- 88 		  //  088.와일드 캐논 스파이크
SKILL_SUPLEX_CYCLONE <- 89 		  //  089.수플렉스 사이클론
SKILL_LIGHTNING_DRAGON <- 90 		  //  090.광충노도
SKILL_MUSCLE_SHIFT <- 91 		  //  091.머슬 시프트	
SKILL_CANCEL_EARTH_BREAK <- 92 		  //  092.캔슬 금강쇄
SKILL_CANCEL_DASH_PUNCH <- 93 		  //  093.캔슬 붕권
SKILL_CANCEL_SHOULDER_CHARGE <- 94 		  //  094.캔슬 철산고
SKILL_CANCEL_PUNCH_AFTER_RETURN <- 95 		  //  095.캔슬 타격후 뒤로돌리기
SKILL_CANCEL_SUPLEX_CYCLONE <- 96 		  //  096.캔슬 수플렉스 사이클론
SKILL_ARMOR_MASTERY_CLOTH_NM <- 97 		  //  097.천 마스터리:넨마스터
SKILL_CANCEL_NEN_GUARD <- 98 		  //  098.캔슬 넨가드
SKILL_CANCEL_ROAR_STUN <- 99 		  //  099.캔슬 사자후
SKILL_CANCEL_ENERGY_FIELD <- 100 		  //  100.캔슬 기공장
SKILL_CANCEL_ENCHANT_POISON <- 101 		  //  101.사용하지 않음.
SKILL_CANCEL_VENOM_MINE <- 102 		  //  102.캔슬 베놈마인
SKILL_CANCEL_RANDOM_KICK <- 103 		  //  103.캔슬 비트드라이브
SKILL_BLOCK_BUSTER_EX <- 104 		  //  104.블록 버스터[강화]
SKILL_DESTROY_EARTH_SKY_DROP <- 105 		  //  105.스트리트 파이터 각성기 - 천붕지괴
SKILL_GROUND_KICK <- 106 		  //  106.그라운드킥
SKILL_CANCEL_GROUND_KICK <- 107 		  //  107.캔슬 그라운드킥
SKILL_FAST_DASH <- 108 		  //  108.순보
SKILL_SMART_THROW <- 109 		  //  간지투척 소스 작업 - 정진수
SKILL_AUTO_LOAD <- 110 		  //  110.자동장전
SKILL_SPIRAL_NEN_SHOOT <- 111 		  //  111.나선의 넨 : 출
SKILL_SPIRAL_NEN_SPIN <- 112 		  //  112.나선의 넨 : 주
SKILL_CANCEL_SPIRAL_NEN_SHOOT <- 113 		  //  113.캔슬 나선의 넨 : 출
SKILL_NEN_POLE <- 114 		  //  114.넨의 극의
SKILL_TYPHOON_COUNTER_STRIKE <- 115 		  //  115.역습 : 그래플러 각성기 패시브
SKILL_1000HANDS_1000EYES <- 116 		  //  116.천수천안 : 스파 각성기 패시브
SKILL_NEN_SPEAR_EX <- 117 		  //  117.넨 스피어(특성)
SKILL_CHARGE_SPEAR_EX <- 118 		  //  118.차지 스피어(특성)
SKILL_GLUEY_FRUIT_EX <- 119 		  //  119.끈적끈적열매 (특성)
SKILL_SPIRAL_COLUMN_EX <- 120 		  //  120.나선환(특성) 정진수
SKILL_108_STAIRS_EX <- 121 		  //  121.108계단 (특성)
SKILL_HURRICANE_SPEAR <- 122 		  //  122.허리케인 스피어 (특성)
SKILL_CRASH_ROPE <- 123 		  //  123.광폭혈사 (특성)
SKILL_CHAIN_KICK_EX <- 124 		  //  124.연환퇴 (특성)

CUSTOM_ANI_CROUCH <- 0 		  //  크라우치 동작
CUSTOM_ANI_CRASH_LOW_KICK <- 1 		  //  본 크러셔
CUSTOM_ANI_LIFT_UPPER <- 2 		  //  무즈 어퍼
CUSTOM_ANI_DAMAGE_LOW_KICK <- 3 		  //  로킥
CUSTOM_ANI_TRY_SUPLEX <- 4 		  //  수플렉스 시도
CUSTOM_ANI_SUPLEX <- 5 		  //  수플렉스
CUSTOM_ANI_BACK_SUPLEX <- 6 		  //  백브레이커
CUSTOM_ANI_MOUNT_TRY <- 7 		  //  마운트 시도
CUSTOM_ANI_MOUNT <- 8 		  //  마운트 - 적을 눕히고 때리기 전까지 모션
CUSTOM_ANI_MOUNT_PUNCH <- 9 		  //  마운트 - 펀치
CUSTOM_ANI_NOT_USE <- 10 		  //  사용하지 않음.
CUSTOM_ANI_STOMP <- 11 		  //  공중 밟기
CUSTOM_ANI_TRY_JUMP_SUPLEX <- 12 		  //  스파이어 시도
CUSTOM_ANI_JUMP_SUPLEX <- 13 		  //  스파이어
CUSTOM_ANI_JUMP_SUPLEX_LARIAT <- 14 		  //  스파이어 회전 추가타
CUSTOM_ANI_CLOSE_PUNCH <- 15 		  //  원인치 펀치
CUSTOM_ANI_GRAB_EXPLOSION <- 16 		  //  일발화약성
CUSTOM_ANI_SHOULDER_TACKLE <- 17 		  //  숄더 태클
CUSTOM_ANI_WHIRL_WIND_KICK <- 18 		  //  선풍각
CUSTOM_ANI_BLOCK_BUSTER_READY <- 19 		  //  블록 버스터 - 준비 (강화투척 시전중 일때만 발동됨)
CUSTOM_ANI_BLOCK_BUSTER_JUMP <- 20 		  //  블록 버스터 - 점프 (강화투척 시전중 일때만 발동됨)
CUSTOM_ANI_BLOCK_BUSTER_SHOOT <- 21 		  //  블록 버스터 - 점프 (강화투척 시전중 일때만 발동됨)
CUSTOM_ANI_BLOCK_BUSTER_NORMAL <- 22 		  //  블록 버스터 - 일반 벽돌 던지기		
CUSTOM_ANI_TRY_LEG_SUPLEX <- 23 		  //  에어슈타이너 시도
CUSTOM_ANI_LEG_SUPLEX_THROW <- 24 		  //  에어슈타이너 : 던지기
CUSTOM_ANI_LEG_SUPLEX_KICK <- 25 		  //  내려찍기 킥 모션
CUSTOM_ANI_TYPHOON_GRAB <- 26 		  //  그래플러 각성기 : 잡기
CUSTOM_ANI_TYPHOON_ATTACK1 <- 27 		  //  그래플러 각성기 : 1타
CUSTOM_ANI_TYPHOON_ATTACK2 <- 28 		  //  그래플러 각성기 : 2타
CUSTOM_ANI_TYPHOON_ATTACK3 <- 29 		  //  그래플러 각성기 : 3타
CUSTOM_ANI_TYPHOON_KICKUP <- 30 		  //  그래플러 각성기 : 차올리기
CUSTOM_ANI_TYPHOON_JUMP <- 31 		  //  그래플러 각성기 : 점프
CUSTOM_ANI_TYPHOON_LAST <- 32 		  //  그래플러 각성기 : 막타		
CUSTOM_ANI_TYPHOON_STAY <- 33 		  //  그래플러 각성기 : 막타 후 대기
CUSTOM_ANI_CRAZY_MOUNT_START <- 34 		  //  지랄 마운트
CUSTOM_ANI_CRAZY_MOUNT_PUNCH <- 35 		  //  지랄 마운트 일반 타격
CUSTOM_ANI_CRAZY_MOUNT_NOT_USE <- 36 		  //  사용하지 않음.
CUSTOM_ANI_CRAZY_MOUNT_END <- 37 		  //  지랄 마운트 막타
CUSTOM_ANI_THROW_WEB <- 38 		  //  천라지망
CUSTOM_ANI_HIDDEN_STING <- 39 		  //  히든스팅
CUSTOM_ANI_VENOM_MINE <- 40 		  //  베놈마인
CUSTOM_ANI_FLAME_LEGS_CAST <- 41 		  //  스트라이커 각성기 - 화염의각(시전)
CUSTOM_ANI_JUNK_SPIN_LOOP <- 42 		  //  정크스핀
CUSTOM_ANI_JUNK_SPIN_FINISH <- 43 
CUSTOM_ANI_MOUNT_END <- 44 		  //  마운트 마지막 펀치
CUSTOM_ANI_SHOULDER_CHARGE <- 45 		  //  철산고
CUSTOM_ANI_SINGLE_KICK <- 46 		  //  해머킥
CUSTOM_ANI_NEN_FLOWER <- 47 		  //  넨화
CUSTOM_ANI_TRY_THROW_ENEMY <- 48 		  //  로플링 시도
CUSTOM_ANI_THROW_ENEMY_HOLD <- 49 		  //  로플링 잡고있기
CUSTOM_ANI_THROW_ENEMY_THROW <- 50 		  //  로플링 던지기
CUSTOM_ANI_WHITE_TIGER_COMBO1 <- 51 		  //  넨수:백호 1타
CUSTOM_ANI_WHITE_TIGER_COMBO2 <- 52 		  //  넨수:백호 2타
CUSTOM_ANI_WHITE_TIGER_COMBO3 <- 53 		  //  넨수:백호 3타
CUSTOM_ANI_WHITE_TIGER_COMBO4 <- 54 		  //  넨수:백호 4타
CUSTOM_ANI_WHITE_TIGER_COMBO5 <- 55 		  //  넨수:백호 5타
CUSTOM_ANI_WHITE_TIGER_DASH_ATTACK <- 56 		  //  넨수:백호 대쉬공격
CUSTOM_ANI_WHITE_TIGER_JUMP_ATTACK <- 57 		  //  넨수:백호 점프공격
CUSTOM_ANI_DASH_PUNCH <- 58 		  //  정권 찌르기
CUSTOM_ANI_PUNCH_AFTER_RETURN <- 59 		  //  타격후 뒤로돌리기
CUSTOM_ANI_RANDOM_KICK1 <- 60 		  //  비트 드라이브 1타
CUSTOM_ANI_RANDOM_KICK2 <- 61 		  //  비트 드라이브 2타
CUSTOM_ANI_RANDOM_KICK3 <- 62 		  //  비트 드라이브 3타
CUSTOM_ANI_RANDOM_KICK_FINISH <- 63 		  //  비트 드라이브 막타
CUSTOM_ANI_RISING_UPPER_DASH <- 64 		  //  승룡권 : 대쉬
CUSTOM_ANI_RISING_UPPER <- 65 		  //  승룡권 : 어퍼
CUSTOM_ANI_DASH_AFTER_DASH_COMBO1 <- 66 		  //  호신연격 : 1타
CUSTOM_ANI_DASH_AFTER_DASH_COMBO2 <- 67 		  //  호신연격 : 2타
CUSTOM_ANI_DASH_AFTER_DASH_COMBO3 <- 68 		  //  호신연격 : 3타 - 남격가는 호신연격 3타 없음 
CUSTOM_ANI_DASH_AFTER_DASH_COMBO4 <- 69 		  //  호신연격 : 4타 - 남격가는 호신연격 4타 없음 
CUSTOM_ANI_EARTH_BREAK <- 70 		  //  금강쇄
CUSTOM_ANI_HOLD_UP_TRY <- 71 		  //  홀드업 : 시도
CUSTOM_ANI_HOLD_UP_HOLD <- 72 		  //  홀드업 : 잡기
CUSTOM_ANI_HOLD_UP_HIT <- 73 		  //  홀드업 : 때리기
CUSTOM_ANI_WILD_CANNON_SPIKE_CHARGE <- 74 		  //  와일드 캐논 스파이크 : 충전
CUSTOM_ANI_WILD_CANNON_SPIKE_FALL <- 75 		  //  와일드 캔논 스파이크 : 떨어지기
CUSTOM_ANI_THROW_SAND <- 76 		  //  헬터스켈터
CUSTOM_ANI_THROW_SAND_DOUBLE <- 77 		  //  헬터스켈터 (이중투척)
CUSTOM_ANI_TRY_SUPLEX_CYCLONE <- 78 		  //  수플렉스 사이클론 : 시도
CUSTOM_ANI_TURN_SUPLEX_CYCLONE <- 79 		  //  수플렉스 사이클론 : 잡고돌기
CUSTOM_ANI_WILD_CANNON_SPIKE_EXP <- 80 		  //  와일드 캐논 스파이크 : 막타
CUSTOM_ANI_FINISH_SUPLEX_CYCLONE <- 81 		  //  사용하지 않음.
CUSTOM_ANI_LIGHTNING_DRAGON <- 82 		  //  광충노도 시전
CUSTOM_ANI_DESTROY_EARTH_SKY_DROP_START <- 83 		  //  스트리트 파이터 각성기 - 천붕지괴 시작
CUSTOM_ANI_DESTROY_EARTH_SKY_DROP_ON_SKY <- 84 		  //  스트리트 파이터 각성기 - 천붕지괴 : 공중모션
CUSTOM_ANI_DESTROY_EARTH_SKY_DROP_FINISH <- 85 		  //  강화 에어슈타이너 1차 찍기
CUSTOM_ANI_TRY_LEG_SUPLEX_EX_SECOND <- 86 		  //  강화 에어슈타이너 2차 시도하러 점프
CUSTOM_ANI_LEG_SUPLEX_EX_2 <- 87 		  //  강화 에어슈타이너 2차 찍기
CUSTOM_ANI_RISING_UPPER_EX_START <- 88 		  //  강화 라이징 너클 시작
CUSTOM_ANI_RISING_UPPER_EX <- 89 		  //  강화 라이징 너클
CUSTOM_ANI_RISING_UPPER_EX_FINISH <- 90 		  //  강화 라이징 너클 막타
CUSTOM_ANI_BLOCK_BUSTER_EX_TRY <- 91 		  //  강화 블록 버스터 시작
CUSTOM_ANI_BLOCK_BUSTER_EX_JUMP <- 92 		  //  강화 블록 버스터 점프
CUSTOM_ANI_BLOCK_BUSTER_EX_FINISH <- 93 		  //  강화 블록 버스터 막타
CUSTOM_ANI_SUPLEX_CYCLONE_JUMP_EX <- 94 		  //  강화 수플렉스 사이클론 : 점프
CUSTOM_ANI_SUPLEX_CYCLONE_SPIN_EX <- 95 		  //  강화 수플렉스 사이클론 : 스핀
CUSTOM_ANI_DASH_PUNCH_EX <- 96 		  //  강화 붕권
CUSTOM_ANI_STOMP_FINISH <- 97 		  //  공중밟기 막타
CUSTOM_ANI_GROUND_KICK_JUMP <- 98 		  //  그라운드킥 - 점프
CUSTOM_ANI_GROUND_KICK_ATTACK <- 99 		  //  그라운드킥 - 공격
CUSTOM_ANI_GROUND_KICK_FINISH <- 100 		  //  그라운드킥 - 피니쉬
CUSTOM_ANI_FAST_DASH <- 101 		  //  순보
CUSTOM_ANI_CRASH_LOW_KICK_SECOND <- 102 		  //  본 크러셔 두번째 타격
CUSTOM_ANI_THROW_ENEMY_SIDEKICK <- 103 		  //  남격 로플링 사이드킥
CUSTOM_ANI_THROW_ENEMY_DOWNKICK <- 104 		  //  남격 로플링 내려찍기킥
CUSTOM_ANI_THROW_GRAB_CANNON_ENEMY_SIDEKICK <- 105 		  //  남격 로플링 그랩캐넌 사이드킥
CUSTOM_ANI_SUPLEX_FINAL_ATTACK <- 106 		  //  남격 수플렉스 그랩캐넌 무릎찍기
CUSTOM_ANI_SUPLEX_THROW_FINAL_ATTACK <- 107 		  //  남격 수플렉스 플라이 무릎찍기
CUSTOM_ANI_DOUBLE_THROW_WEB <- 108 		  //  남격 그물투척 (이중투척)
CUSTOM_ANI_LEG_SUPLEX_FIRST_KICK <- 109 		  //  남격 에어슈타이너 초기 찍기 공격동작
CUSTOM_ANI_JUMP_SUPLEX_HOLD_IMPRESSKICK <- 110 		  //  남격 스파이어 - 잡기불가적 - 내려찍기 킥 모션 
CUSTOM_ANI_LIGHTNING_DANCE_KICK <- 111 		  //  남격 라이트닝 댄스 킥
CUSTOM_ANI_LIGHTNING_DANCE_LAST_LOW_KICK <- 112 		  //  남격 라이트닝 댄스 막타 로우킥
CUSTOM_ANI_GRAB_EXPLOSION_KICK <- 113 		  //  남격 일발화약성	- 잡고 차는 동작
CUSTOM_ANI_NEN_FLOWER_READY <- 114 		  //  넨마스터-각성 호랑이 타는 동작
CUSTOM_ANI_NEN_FLOWER_ATTACK <- 115 		  //  넨마스터-각성 호랑이 공격
CUSTOM_ANI_NEN_FLOWER_FINAL <- 116 		  //  넨마스터-각성 호랑이 마지막 공격
CUSTOM_ANI_ENCHANT_POISON <- 117 		  //  독장전 발사
CUSTOM_ANI_SPIRALNEN_SHOOT_PREPARE <- 118 		  //  나선의 넨:출 슛 준비동작
CUSTOM_ANI_SPIRALNEN_SHOOT <- 119 		  //  나선의 넨:출 슛
CUSTOM_ANI_BLOCK_BUSTER_DOUBLE <- 120 		  //  블록 버스터 - 이중투척
CUSTOM_ANI_ENCHANT_POISON_DOUBLE <- 121 		  //  독장전 - 이중투척
CUSTOM_ANI_HIDDEN_STING_DOUBLE <- 122 		  //  바늘장전 - 이중투척
CUSTOM_ANI_DEFINITE_GRAB <- 123 		  //  반드시 잡는다 - 특수그랩 동작
CUSTOM_ANI_NEN_SPEAR <- 124 		  //  넨 스피어 꽂기(특성)
CUSTOM_ANI_NEN_SPEAR_SUCCESS <- 125 		  //  넨 스피어 꽂기 성공시(특성)
CUSTOM_ANI_HURRICANE_SPEAR <- 126 		  //  남격투가 특성스킬 - 허리케인 스피어
CUSTOM_ANI_CHARGE_SPEAR_RECHARGE <- 127 		  //  차지스피어(특성) 충전		
CUSTOM_ANI_CHARGE_SPEAR_RUSH <- 128 		  //  차지스피어(특성) 돌격
CUSTOM_ANI_CHARGE_SPEAR_END <- 129 		  //  차지스피어(특성) 돌격 끝
CUSTOM_ANI_SPIRAL_COLUMN_EX <- 130 		  //  나선환(특성)
CUSTOM_ANI_CRASH_ROPE <- 131 		  //  광폭혈사 (특성)
CUSTOM_ANI_GLUEY_FRUIT <- 132 		  //  끈적끈적 열매(특성)
CUSTOM_ANI_CHAIN_KICK <- 133 		  //  연환퇴(특성)
CUSTOM_ANI_108_STAIRS_TRY_EX <- 134 		  //  108계단(특성)
CUSTOM_ANI_108_STAIRS_KICK_EX <- 135 		  //  108계단(특성)
CUSTOM_ANI_108_STAIRS_PUNCH_EX <- 136 		  //  108계단(특성)
CUSTOM_ANI_108_STAIRS_BLOW_EX <- 137 		  //  108계단(특성)
CUSTOM_ANI_108_STAIRS_THROW_EX <- 138 		  //  108계단(특성)
CUSTOM_ANI_108_STAIRS_FINAL_EX <- 139 		  //  108계단(특성)

CUSTOM_ATTACKINFO_CRASH_LOW_KICK <- 0 		  //  본 크러셔
CUSTOM_ATTACKINFO_LIFT_UPPER <- 1 		  //  무즈 어퍼
CUSTOM_ATTACKINFO_DAMAGE_LOW_KICK <- 2 		  //  로킥
CUSTOM_ATTACKINFO_TRY_GRAB <- 3 		  //  잡기 시도
CUSTOM_ATTACKINFO_SUPLEX <- 4 		  //  수플렉스의 간접 데미지
CUSTOM_ATTACKINFO_MOUNT <- 5 		  //  마운트 펀치
CUSTOM_ATTACKINFO_STOMP <- 6 		  //  공중 밟기
CUSTOM_ATTACKINFO_JUMP_SUPLEX <- 7 		  //  스파이어 (최초 킥)
CUSTOM_ATTACKINFO_JUMP_SUPLEX_HEADING <- 8 		  //  스파이어 마지막 회전킥
CUSTOM_ATTACKINFO_JUMP_SUPLEX_LARIAT <- 9 		  //  그랩캐넌 스파이어 마지막 회전킥 (잡기불가적)
CUSTOM_ATTACKINFO_CLOSE_PUNCH <- 10 		  //  원인치 펀치
CUSTOM_ATTACKINFO_SHOULDER_CHARGE <- 11 		  //  철산고
CUSTOM_ATTACKINFO_SINGLE_KICK <- 12 		  //  해머 킥
CUSTOM_ATTACKINFO_GRAB_EXPLOSION <- 13 		  //  일발화약성 타격
CUSTOM_ATTACKINFO_SHOULDER_TACKLE <- 14 		  //  숄더 태클
CUSTOM_ATTACKINFO_GRAB_CANNON <- 15 		  //  그랩 캐논
CUSTOM_ATTACKINFO_WHIRL_WIND_KICK <- 16 		  //  선풍각
CUSTOM_ATTACKINFO_JUNK_SPIN <- 17 		  //  바늘스핀 (정크스핀)
CUSTOM_ATTACKINFO_LEG_SUPLEX_KICK <- 18 		  //  에어슈타이너 : 차기
CUSTOM_ATTACKINFO_LIGHTNING_DANCE <- 19 		  //  라이트닝 댄스
CUSTOM_ATTACKINFO_STRONGEST_LOW_KICK <- 20 		  //  사상최강의 로킥
CUSTOM_ATTACKINFO_CRAZY_MOUNT <- 21 		  //  지랄 마운트
CUSTOM_ATTACKINFO_THROW_WEB <- 22 		  //  천라지망
CUSTOM_ATTACKINFO_HIDDEN_STING <- 23 		  //  히든스팅
CUSTOM_ATTACKINFO_DASH_PUNCH <- 24 		  //  정권 찌르기
CUSTOM_ATTACKINFO_PUNCH_AFTER_RETURN <- 25 		  //  타격후 뒤로돌리기
CUSTOM_ATTACKINFO_RANDOM_KICK_1 <- 26 		  //  비트 드라이브 1타
CUSTOM_ATTACKINFO_RANDOM_KICK_2 <- 27 		  //  비트 드라이브 2타
CUSTOM_ATTACKINFO_RANDOM_KICK_3 <- 28 		  //  비트 드라이브 3타
CUSTOM_ATTACKINFO_RANDOM_KICK_FINISH <- 29 		  //  비트 드라이브 막타
CUSTOM_ATTACKINFO_DUMMY_4 <- 30 		  //  사용되지 않고있음.
CUSTOM_ATTACKINFO_RISING_UPPER <- 31 		  //  승룡권 : 어퍼
CUSTOM_ATTACKINFO_DASH_AFTER_DASH_COMBO1 <- 32 		  // 	호신연격 : 1타
CUSTOM_ATTACKINFO_DASH_AFTER_DASH_COMBO2 <- 33 		  // 	호신연격 : 2타
CUSTOM_ATTACKINFO_VENOM_MINE <- 34 		  // 	베놈마인 공격력
CUSTOM_ATTACKINFO_DUMMY_2 <- 35 		  // 	사용되지 않고있음
CUSTOM_ATTACKINFO_HOLD_UP_TRY <- 36 		  //  홀드업 : 시도
CUSTOM_ATTACKINFO_HOLD_UP_HIT <- 37 		  //  홀드업 : 때리기
CUSTOM_ATTACKINFO_WILD_CANNON_SPIKE_FALL <- 38 		  //  와일드 캐논 스파이크 : 공중에서 떨어질때
CUSTOM_ATTACKINFO_WILD_CANNON_SPIKE_HIT <- 39 		  //  와일드 캐논 스파이크 : 바닥에서 적에게 데미지줄때
CUSTOM_ATTACKINFO_WHITE_TIGER_COMBO1 <- 40 		  //  넨수:백호 1타
CUSTOM_ATTACKINFO_WHITE_TIGER_COMBO2 <- 41 		  //  넨수:백호 2타
CUSTOM_ATTACKINFO_WHITE_TIGER_COMBO3 <- 42 		  //  넨수:백호 3타
CUSTOM_ATTACKINFO_WHITE_TIGER_COMBO4 <- 43 		  //  넨수:백호 4타
CUSTOM_ATTACKINFO_WHITE_TIGER_COMBO5 <- 44 		  //  넨수:백호 5타
CUSTOM_ATTACKINFO_WHITE_TIGER_DASH_ATTACK <- 45 		  //  넨수:백호 대쉬공격
CUSTOM_ATTACKINFO_WHITE_TIGER_JUMP_ATTACK <- 46 		  //  넨수:백호 점프공격
CUSTOM_ATTACKINFO_SUPLEX_CYCLONE_CRASH <- 47 		  //  수플렉스 사이클론 : 잡고찍기
CUSTOM_ATTACKINFO_SUPLEX_CYCLONE_FINISH <- 48 		  //  수플렉스 사이클론 : 마지막 타격
CUSTOM_ATTACKINFO_LEG_SUPLEX_EX_SPIN <- 49 		  //  강화 에어슈타이너 스핀
CUSTOM_ATTACKINFO_DASH_PUNCH_EX <- 50 		  //  강화 붕권
CUSTOM_ATTACKINFO_BLOCK_BUSTER_FINISH_EX <- 51 		  //  강화 블록 버스터 막타
CUSTOM_ATTACKINFO_RISING_UPPER_START_EX <- 52 		  //  강화 승룡권 : 시작
CUSTOM_ATTACKINFO_RISING_UPPER_EX <- 53 		  //  강화 승룡권 : 어퍼
CUSTOM_ATTACKINFO_RISING_UPPER_FINISH_EX <- 54 		  //  강화 승룡권 : 피니시
CUSTOM_ATTACKINFO_SUPLEX_CYCLONE_EX <- 55 		  //  강화 수플렉스 사이클론
CUSTOM_ATTACKINFO_SUPLEX_CYCLONE_SPIN_EX <- 56 		  //  강화 수플렉스 사이클론 : 회전	
CUSTOM_ATTACKINFO_STOMP_FINISH <- 57 		  //  공중밟기 막타
CUSTOM_ATTACKINFO_GROUND_KICK <- 58 		  //  그라운드킥
CUSTOM_ATTACKINFO_LIGHTNING_DRAGON <- 59 		  //  광충노도
CUSTOM_ATTACKINFO_CRASH_LOW_KICK_SECOND <- 60 		  //  본 크러셔 두번째 타격
CUSTOM_ATTACKINFO_THROW_ENEMY_UPKICK <- 61 		  //  남격 로플링 UP킥
CUSTOM_ATTACKINFO_THROW_ENEMY_SIDEKICK <- 62 		  //  남격 로플링 SIDE킥
CUSTOM_ATTACKINFO_THROW_ENEMY_DOWNKICK <- 63 		  //  남격 로플링 DOWN킥
CUSTOM_ATTACKINFO_TRY_GRAB_THROW_ENEMY <- 64 		  //  로풀링 
CUSTOM_ATTACKINFO_THROW_WEB_DOUBLE <- 65 		  //  그물투척 (이중투척일때)
CUSTOM_ATTACKINFO_LIGHTNING_LOW_KICK <- 66 		  //  그물투척 (이중투척일때)
CUSTOM_ATTACKINFO_SUPLEX_GRABCANNON <- 67 		  //  수플렉스 그랩캐넌 
CUSTOM_ATTACKINFO_NEN_FLOWER <- 68 		  //  넨마스터-각성
CUSTOM_ATTACKINFO_TYPHOON <- 69 		  //  그래플러 각성기
CUSTOM_ATTACKINFO_TYPHOON_LAST <- 70 		  //  그래플러 각성기
CUSTOM_ATTACKINFO_SPIRAL_NEN_SHOOT <- 71 		  //  나선의 넨:출
CUSTOM_ATTACKINFO_NEN_SPEAR <- 72 		  //  넨스피어(특성)	
CUSTOM_ATTACKINFO_CHARGE_SPEAR <- 73 		  //  차지스피어(특성)	
CUSTOM_ATTACKINFO_HURRICANE_SPEAR <- 74 		  // 	허리케인 스피어 (특성)
CUSTOM_ATTACKINFO_CRASH_ROPE <- 75 		  //  광폭혈사 (특성)
CUSTOM_ATTACKINFO_CHAIN_KICK1 <- 76 		  //  연환퇴 1타(특성)
CUSTOM_ATTACKINFO_CHAIN_KICK2 <- 77 		  //  연환퇴 2타(특성)
CUSTOM_ATTACKINFO_CHAIN_KICK3 <- 78 		  //  연환퇴 3타(특성)
CUSTOM_ATTACKINFO_108_STAIRS_KICK_EX <- 79 		  //  108계단(특성)
CUSTOM_ATTACKINFO_108_STAIRS_PUNCH_EX <- 80 		  //  108계단(특성)
CUSTOM_ATTACKINFO_108_STAIRS_BLOW_1_EX <- 81 		  //  108계단(특성)
CUSTOM_ATTACKINFO_108_STAIRS_BLOW_2_EX <- 82 		  //  108계단(특성)
CUSTOM_ATTACKINFO_108_STAIRS_BLOW_3_EX <- 83 		  //  108계단(특성)

WEAPON_SUBTYPE_KNUCKLE <- 0 		  //  너클
WEAPON_SUBTYPE_GAUNTLET <- 1 		  //  건틀렛
WEAPON_SUBTYPE_CLAW <- 2 		  //  클로
WEAPON_SUBTYPE_BOXING_GLOVE <- 3 		  //  권투글러브
WEAPON_SUBTYPE_DUMMY <- 4 		  //  UNKNOWN
WEAPON_SUBTYPE_TONFA <- 5 		  //  통파
WEAPON_SUBTYPE_MAX <- 6 

SOUND_ID_STATIC <- 0 		  //  맵에 있는 동안 계속 플레이
SOUND_ID_MOVE <- 1 		  //  걷는 소리
SOUND_ID_ACTIVESTATUS_POISON <- 2 		  //  포이즌 걸렸을 때
SOUND_ID_ACTIVESTATUS_BURN <- 3 		  //  번 걸렸을 때
SOUND_ID_ACTIVESTATUS_LIGHTNING <- 4 		  //  라이트닝 걸렸을 때
SOUND_ID_AURA_SHIELD <- 5 		  //  Appendage : 오라 실드
SOUND_ID_MAGICAL_TEMPO_UP <- 6 		  //  Appendage : 쇼타임
SOUND_ID_DOT_AREA <- 7 		  //  Appendage : 진동파
SOUND_ID_DOT_AREA_DAMAGE <- 8 		  //  Appendage : 진동파 피격
SOUND_ID_DIVINE_LIGHT <- 9 		  //  Appendage : 신성한 빛
SOUND_ID_SHADOW_BOXER <- 10 		  //  Appendage : 섀도우 박서
SOUND_ID_GUARD <- 11 		  //  가드 상태일때
SOUND_ID_CHAKRA_OF_PASSION <- 12 		  //  Appendage : 열정의 챠크라
SOUND_ID_CHAKRA_OF_CALMNESS <- 13 		  //  Appendage : 냉정의 챠크라
SOUND_ID_WAVE_MARK <- 14 		  //  Appendage : 파동인
SOUND_ID_KEIGA <- 15 		  //  Appendage : 잔영의 케이가
SOUND_ID_END <- 16 

STATE_PRIORITY_AUTO <- 0 		  //  시간이나 조건에 의해 자동으로 되는 것들 (공격 종료, 발사 -> 장전 등등)
STATE_PRIORITY_USER <- 1 		  //  유저의 커맨드에 의해 나가는 것들 (스킬, 공격 등)
STATE_PRIORITY_HALF_FORCE <- 2 		  //  원해서 나가는 것은 아니지만, 완전 강제보다는 낮은 것들. (이면 뒤집기 등)
STATE_PRIORITY_FORCE <- 3 		  //  강제로 하게 되는 것들. (다운, 데미지, 사망, 홀드 등)
STATE_PRIORITY_IGNORE_FORCE <- 4 		  //  강제 변경을 무시하는 것들. (수플렉스로 상대 잡기 등)

STATE_VIRTUAL_ATTACK <- 19 		  //  일반 공격 -> 공격스킬 등을 위한 가상 STATE
STATE_ANTIAIR_UPPER <- 20 		  //  어퍼
STATE_DUCKING <- 21 		  //  더킹
STATE_SWAY <- 22 		  //  스웨이
STATE_GIANT_SWING <- 23 		  //  대회전격
STATE_REPEATED_SMASH <- 24 		  //  난격
STATE_SMASHER <- 25 		  //  스매셔
STATE_QUAKE_AREA <- 26 		  //  낙봉추
STATE_WILL_DRIVER <- 27 		  //  윌 드라이버
STATE_DUCKING_SKILL <- 28 		  //  더킹상태의 스킬별 확장
STATE_LUCKY_STRAIGHT <- 29 		  //  럭키 스트레이트
STATE_SECOND_UPPER <- 30 		  //  세컨드어퍼
STATE_HOLY_COUNTER <- 31 		  //  홀리 카운터
STATE_GORGEOUS_COMBINATION <- 32 		  //  고저스 컴비네이션
STATE_CHOPPING_HAMMER <- 33 		  //  초핑 해머
STATE_HURRICANE_OF_JUDGEMENT <- 34 		  //  심판의 회오리
STATE_HOME_RUN <- 35 		  //  홈런
STATE_BLADE_OF_PURE_WHITE <- 36 		  //  순백의 칼날
STATE_HURRICANE_ROLL <- 37 		  //  허리케인 롤
STATE_THROW_WEAPON <- 38 		  //  거선풍
STATE_DEFLECT_WALL <- 39 		  //  디플렉트 월
STATE_SPEAR_OF_VICTORY <- 40 		  //  승리의 창
STATE_HAMMER_OF_CONTRITION <- 41 		  //  참회의 망치
STATE_HEAVENLY_COMBINATION <- 42 		  //  헤븐리 컴비네이션
STATE_DIVINE_CRUSH <- 43 		  //  디바인 크러시
STATE_SIDEWIND <- 44 		  //  사이드와인드
STATE_MACHINE_GUN_JAB <- 45 		  //  머신건 잽
STATE_THROW_TALISMAN <- 46 		  //  성불
STATE_APOCALYPSE <- 47 		  //  아포칼립스
STATE_GALE_SMASH <- 48 		  //  질풍타
STATE_ATOMIC_SMASH <- 49 		  //  무쌍격
STATE_BIG_BANG_PUNCH <- 50 		  //  빅뱅 펀치
STATE_BLUE_DRAGON <- 51 		  //  창룡격
STATE_HEAL_WIND <- 52 		  //  힐 윈드
STATE_CUTTING_DARKNESS <- 53 		  //  어둠가르기
STATE_MACHINE_GUN_JAB_EX <- 54 		  //  강화 머신건 잽
STATE_HEAVENLY_COMBINATION_EX <- 55 		  //  헤븐리 컴비네이션[강화]
STATE_REPEATED_SMASH_EX <- 56 		  //  강화 난격
STATE_DEFLECT_WALL_EX <- 57 		  //  디플렉트 월[강화]

SKILL_ANTIAIR_UPPER <- 1 		  //  공참타
SKILL_DUCKING <- 2 		  //  더킹 대시
SKILL_SWAY <- 3 		  //  스웨이
SKILL_HURRICANE_ROLL <- 4 		  //  허리케인 롤
SKILL_GIANT_SWING <- 5 		  //  대회전격
SKILL_CANCEL_ANTIAIR_UPPER <- 6 		  //  캔슬 공참타
SKILL_STRIKING <- 7 		  //  스트라이킹
SKILL_SMASHER <- 8 		  //  스매셔
SKILL_CANCEL_SMASHER <- 9 		  //  캔슬 스매셔
SKILL_CHANGE_HP_TO_MP <- 10 		  // 	고통의 희열
SKILL_QUAKE_AREA <- 11 		  //  낙봉추
SKILL_CANCEL_QUAKE_AREA <- 12 		  //  캔슬 낙봉추
SKILL_WILL_DRIVER <- 13 		  //  윌 드라이버
SKILL_TECHNICAL_MASTERY <- 14 		  //  테크니컬 마스터리
SKILL_BATTLE_AURA_MASTERY <- 15 		  //  배틀 오라 마스터리
SKILL_CORKSCREW_MASTERY <- 16 		  //  코크스크류 마스터리
SKILL_COMBINATION_MASTERY <- 17 		  //  컴비네이션 마스터리
SKILL_HARD_PUNCH_MASTERY <- 18 		  //  하드 펀치 마스터리
SKILL_HP_MAX_UP_PERSONAL <- 19 		  //  천상의 멜로디
SKILL_EMBLEM_OF_SAFEGUARD <- 20 		  //  보호의 징표
SKILL_FOUNTAIN_OF_LIFE <- 21 		  //  생명의 원천
SKILL_DIVINE_LIGHT <- 22 		  //  신성한 빛
SKILL_REVENGE_OF_LIGHT <- 23 		  //  빛의 복수
SKILL_HP_MAX_UP_PARTY <- 24 		  //  천상의 하모니
SKILL_SACRIFICE_OF_SOUL <- 25 		  //  영혼의 희생
SKILL_HEAL_WIND <- 26 		  //  힐 윈드
SKILL_DEFLECT_WALL <- 27 		  //  디플렉트 월
SKILL_FLASH_GLOBE <- 28 		  //  플래시 글로브
SKILL_EXTENDED_PUNCH <- 29 		  //  권기방출
SKILL_HOLY_COUNTER <- 30 		  //  홀리 카운터
SKILL_GORGEOUS_COMBINATION <- 31 		  //  고저스 컴비네이션
SKILL_CANCEL_GORGEOUS_COMBINATION <- 32 		  //  캔슬 고저스 컴비네이션
SKILL_CHOPPING_HAMMER <- 33 		  //  초핑 해머
SKILL_ARMOR_MASTERY_PLATE_CS <- 34 		  //  크루세이더 판금 마스터리
SKILL_SHADOW_BOXER <- 35 		  //  섀도우 박서
SKILL_DOUBLE_SHADOW_BOXER <- 36 		  //  더블 섀도우 박서
SKILL_HURRICANE_OF_JUDGEMENT <- 37 		  //  심판의 회오리
SKILL_ENTERING_NIRVANA <- 38 		  //  성불
SKILL_OPPRESSION_TALISMAN <- 39 		  //  제압부 (이펙트)
SKILL_THUNDERBOLT_TALISMAN <- 40 		  //  낙뢰부 (이펙트)
SKILL_HOME_RUN <- 41 		  //  저 하늘의 별
SKILL_QUICK_PARRY <- 42 		  //  퀵 패리
SKILL_BLADE_OF_PURE_WHITE <- 43 		  //  순백의 칼날
SKILL_CANCEL_BLADE_OF_PURE_WHITE <- 44 		  //  캔슬 순백의 칼날
SKILL_GLORIOUS_BLESS <- 45 		  //  영광의 축복
SKILL_CANCEL_HURRICANE_ROLL <- 46 		  //  캔슬 허리케인 롤
SKILL_CHAKRA_OF_PASSION <- 47 		  //  열정의 챠크라
SKILL_CHAKRA_OF_CALMNESS <- 48 		  //  냉정의 챠크라
SKILL_REPEATED_SMASH <- 49 		  //  난격
SKILL_THROW_WEAPON <- 50 		  //  거선풍
SKILL_SLOW_HEAL <- 51 		  //  슬로우 힐
SKILL_CURE <- 52 		  //  큐어
SKILL_BLESS <- 53 		  //  지혜의 축복
SKILL_GRACE_OF_GOD <- 54 		  //  신의 은총
SKILL_FAST_HEAL <- 55 		  //  패스트 힐
SKILL_DUCKING_STRAIGHT <- 56 		  //  더킹 스트레이트
SKILL_DUCKING_BODYBLOW <- 57 		  //  더킹 보디블로
SKILL_DUCKING_UPPER <- 58 		  //  더킹 어퍼
SKILL_CANCEL_DUCKING <- 59 		  //  캔슬 더킹
SKILL_CANCEL_SWAY <- 60 		  //  캔슬 스웨이
SKILL_LUCKY_STRAIGHT <- 61 		  //  럭키 스트레이트
SKILL_CANCEL_LUCKY_STRAIGHT <- 62 		  //  캔슬 럭키 스트레이트
SKILL_SECOND_UPPER <- 63 		  //  세컨드 어퍼
SKILL_GRASP_HAND_OF_ANGER <- 64 		  //  분노의 움켜쥠
SKILL_CANCEL_GRASP_HAND_OF_ANGER <- 65 		  //  캔슬 분노의 움켜쥠
SKILL_CHARGE_WEAPON <- 66 		  //  잠룡
SKILL_FORCE_OF_EXORCISM <- 67 		  //  퇴마의 기운
SKILL_ARMOR_MASTERY_CLOTH_EC <- 68 
SKILL_HYUN_MOO <- 69 		  //  지의 식신 - 현무
SKILL_BAEK_HO <- 70 		  //  공의 식신 - 백호
SKILL_CANCEL_REPEATED_SMASH <- 71 		  //  캔슬 난격
SKILL_CANCEL_HOME_RUN <- 72 		  //  캔슬 홈런
SKILL_SPEAR_OF_VICTORY <- 73 		  //  승리의 창
SKILL_HAMMER_OF_CONTRITION <- 74 		  //  참회의 망치
SKILL_HEAVENLY_COMBINATION <- 75 		  //  헤븐리 컴비네이션
SKILL_DIVINE_CRUSH <- 76 		  //  디바인 크러시
SKILL_SIDEWIND <- 77 		  //  사이드와인드
SKILL_MACHINE_GUN_JAB <- 78 		  //  머신건 잽
SKILL_CANCEL_SIDEWIND <- 79 		  //  캔슬 사이드와인드
SKILL_CANCEL_MACHINE_GUN_JAB <- 80 		  //  캔슬 머신건 잽
SKILL_JUDGEMENT <- 81 		  //  정의의 심판
SKILL_BIG_WEAPON_MASTERY <- 82 		  //  거병마스터리 생성
SKILL_BATTLE_AXE_MASTERY <- 83 		  //  배틀액스 마스터리
SKILL_APOCALYPSE <- 84 		  //  아포칼립스
SKILL_GALE_SMASH <- 85 		  //  질풍타
SKILL_AURA_OF_FAITH <- 86 		  //  신념의 오라
SKILL_DRYOUT <- 87 		  //  드라이아웃
SKILL_ATOMIC_SMASH <- 88 		  //  무쌍격
SKILL_RADIATE_FIGHTING_AURA <- 89 		  //  투기 발산
SKILL_BIG_BANG_PUNCH <- 90 		  //  빅뱅 펀치
SKILL_ARMOR_MASTERY_LIGHT_IF <- 91 		  //  경갑 마스터리:인파이터
SKILL_ARMOR_MASTERY_PLATE_EC <- 92 		  //  판금 마스터리:퇴마사
SKILL_BLUE_DRAGON <- 93 		  //  창룡격
SKILL_CANCEL_ENTERING_NIRVANA <- 94 		  //  캔슬 성불
SKILL_CANCEL_GALE_SMASH <- 95 		  //  캔슬 질풍타
SKILL_ARMOR_MASTERY_HEAVY_EC <- 96 		  //  중갑 마스터리:퇴마사
SKILL_GRACE_OF_COURAGE <- 97 		  //  용기의 은총
SKILL_GRACE_OF_PROTECTION <- 98 		  //  수호의 은총
SKILL_RISING_AREA <- 99 		  //  승천진
SKILL_CUTTING_DARKNESS <- 100 		  //  어둠가르기
SKILL_SHIKIGAMI <- 101 		  //  식신의 군
SKILL_CANCEL_RISING_AREA <- 102 		  //  캔슬 승천진
SKILL_MACHINE_GUN_JAB_EX <- 103 		  //  강화 머신건 잽
SKILL_HEAVENLY_COMBINATION_EX <- 104 		  //  헤븐리 컴비네미션[강화]
SKILL_REPEATED_SMASH_EX <- 105 		  //  강화 난격
SKILL_VERMILIONBIRD_TALISMAN <- 106 		  //  주작부
SKILL_CROSS_CRASH <- 107 		  //  크로스 크래쉬, 개발명 : 뜨거운 십자가, HotCross 등
SKILL_FLASH_GLOBE_EX <- 108 		  //  플래시 글로브[강화]
SKILL_DEFLECT_WALL_EX <- 109 		  //  디플렉트 월[강화]
SKILL_HYUN_MOO_EX <- 110 		  //  현무[강화]
SKILL_GROUND_CRASH <- 111 		  //  그라운드 스매시, 개발명 ox crash (한우돌파)
SKILL_CANCEL_GROUND_CRASH <- 112 		  //  캔슬 그라운드 스매시
SKILL_SLOW_HEAL_EX <- 140 		  //  슬로우 힐 패시브
SKILL_LUCKY_STRAIGHT_EX <- 141 		  //  럭키 스트레이트 패시브
SKILL_QUAKE_AREA_EX <- 142 		  //  낙봉추 패시브
SKILL_GRASP_HAND_OF_ANGER_EX <- 143 		  //  분노의 움켜쥠
SKILL_SPEAR_OF_VICTORY_EX <- 144 		  //  승리의 창 패시브
SKILL_REVENGE_OF_LIGHT_EX <- 145 		  //  빛의 복수 패시브
SKILL_DUCKING_STRAIGHT_EX <- 146 		  //  더킹 스트레이트 패시브
SKILL_WILL_DRIVER_EX <- 147 		  //  윌 드라이버 패시브
SKILL_OPPRESSION_TALISMAN_EX <- 148 		  //  제압부 패시브
SKILL_THROW_WEAPON_EX <- 149 		  //  거선풍 패시브

CUSTOM_ANI_JUMP_PUNCH <- 0 		  //  점프 펀치 (거병 없을때 점프공격)
CUSTOM_ANI_ANTIAIR_UPPER <- 1 		  //  어퍼
CUSTOM_ANI_DUCKING <- 2 		  //  더킹
CUSTOM_ANI_SWAY <- 3 		  //  스웨이
CUSTOM_ANI_GIANT_SWING_READY <- 4 		  //  대회전격 : 준비
CUSTOM_ANI_GIANT_SWING <- 5 		  //  대회전격 : 회전
CUSTOM_ANI_GIANT_SWING_FINAL <- 6 		  //  대회전격 : 막타
CUSTOM_ANI_SMASHER_TRY_GRAB <- 7 		  //  스매셔 : 잡기 기도
CUSTOM_ANI_SMASHER_SUCCESS_GRAB <- 8 		  //  스매셔 : 잡기 성공
CUSTOM_ANI_SMASHER_DASH <- 9 		  //  스매셔 : 대시 후 던지기
CUSTOM_ANI_DUCKING_BODYBLOW <- 10 		  //  보디블로
CUSTOM_ANI_QUAKE_AREA <- 11 		  //  낙봉추
CUSTOM_ANI_WILL_DRIVER <- 12 		  //  윌 드라이버
CUSTOM_ANI_WILL_DRIVER_SECOND <- 13 		  //  윌 드라이버 : 이미 꽂힌 상태
CUSTOM_ANI_LUCKY_STRAIGHT <- 14 		  //  럭키스트레이트
CUSTOM_ANI_DUCKING_STRAIGHT <- 15 		  //  더킹 스트레이트
CUSTOM_ANI_SECOND_UPPER <- 16 		  //  세컨드 어퍼
CUSTOM_ANI_DUCKING_UPPER <- 17 		  //  더킹 어퍼
CUSTOM_ANI_HOLY_COUNTER_PRAY <- 18 		  //  홀리 카운터 : 기도
CUSTOM_ANI_HOLY_COUNTER_BODYBLOW <- 19 		  //  홀리 카운터 : 바디블로
CUSTOM_ANI_GORGEOUS_COMBINATION <- 20 		  //  고저스 컴비네이션
CUSTOM_ANI_CHOPPING_HAMMER <- 21 		  //  초핑 해머
CUSTOM_ANI_HURRICANE_OF_JUDGEMENT <- 22 		  //  심판의 회오리
CUSTOM_ANI_HURRICANE_OF_JUDGEMENT2 <- 23 		  //  심판의 회오리 2타
CUSTOM_ANI_HOME_RUN_GRAB <- 24 		  //  홈런 : 잡기 시도
CUSTOM_ANI_HOME_RUN_CHARGE <- 25 		  //  홈런 : 잡기 & 차지
CUSTOM_ANI_HOME_RUN_SMASH <- 26 		  //  홈런 : 스윙
CUSTOM_ANI_BLADE_OF_PURE_WHITE <- 27 		  //  순백의 칼날
CUSTOM_ANI_HURRICANE_ROLL_HOOK <- 28 		  //  허리케인 롤 : 훅
CUSTOM_ANI_HURRICANE_ROLL_UPPER <- 29 		  //  허리케인 롤 : 어퍼
CUSTOM_ANI_REPEATED_SMASH_START <- 30 		  //  난격 : 첫타
CUSTOM_ANI_REPEATED_SMASH <- 31 		  //  난격 : 난타
CUSTOM_ANI_REPEATED_SMASH_FINAL <- 32 		  //  난격 : 막타
CUSTOM_ANI_THROW_WEAPON_READY <- 33 		  //  거선풍 : 준비
CUSTOM_ANI_THROW_WEAPON_SWING <- 34 		  //  거선풍 : 회전 (풀차지시 1회전 추가 모션)
CUSTOM_ANI_THROW_WEAPON_THROW <- 35 		  //  거선풍 : 투척 (풀차지가 아니면 준비 -> 투척)
CUSTOM_ANI_DEFLECT_WALL <- 36 		  //  디플렉트 월
CUSTOM_ANI_SPEAR_OF_VICTORY_READY <- 37 		  //  승리의 창 : 준비&충전
CUSTOM_ANI_SPEAR_OF_VICTORY_THROW <- 38 		  //  승리의 창 : 투척
CUSTOM_ANI_HAMMER_OF_CONTRITION <- 39 		  //  참회의 망치
CUSTOM_ANI_HEAVENLY_COMBINATION <- 40 		  //  헤븐리 컴비네이션
CUSTOM_ANI_DIVINE_CRUSH <- 41 		  //  디바인 크러시
CUSTOM_ANI_INFIGHTER_ATTACK12 <- 42 		  //  인파이터 평타 1,2타
CUSTOM_ANI_INFIGHTER_ATTACK3 <- 43 		  //  인파이터 평타 3타
CUSTOM_ANI_INFIGHTER_ATTACK4 <- 44 		  //  인파이터 평타 4타
CUSTOM_ANI_INFIGHTER_ATTACK5 <- 45 		  //  인파이터 평타 5타
CUSTOM_ANI_EXORCIST_ATTACK1 <- 46 		  //  퇴마사 평타 1타
CUSTOM_ANI_EXORCIST_ATTACK2 <- 47 		  //  퇴마사 평타 2타
CUSTOM_ANI_EXORCIST_ATTACK3 <- 48 		  //  퇴마사 평타 3타
CUSTOM_ANI_SIDEWIND <- 49 		  //  사이드와인드 기본
CUSTOM_ANI_SIDEWIND_SECOND <- 50 		  //  사이드와인드 추가타
CUSTOM_ANI_MACHINE_GUN_JAB <- 51 		  //  머신건 잽 : 연타
CUSTOM_ANI_MACHINE_GUN_JAB_FINISH <- 52 		  //  머신건 잽 : 피니시
CUSTOM_ANI_MACHINE_GUN_JAB_APPEND <- 53 		  //  머신건 잽 : 추가타
CUSTOM_ANI_THROW_TALISMAN1 <- 54 		  //  성불 : 던지기1
CUSTOM_ANI_THROW_TALISMAN2 <- 55 		  //  성불 : 던지기2
CUSTOM_ANI_APOCALYPSE <- 56 		  //  아포칼립스
CUSTOM_ANI_GALE_SMASH1 <- 57 		  //  질풍타 : 어깨치기
CUSTOM_ANI_GALE_SMASH2 <- 58 		  //  질풍타 : 휘두르기
CUSTOM_ANI_ATOMIC_SMASH <- 59 		  //  무쌍격
CUSTOM_ANI_BIG_BANG_PUNCH_READY <- 60 		  //  빅뱅 펀치 : 준비
CUSTOM_ANI_BIG_BANG_PUNCH1 <- 61 		  //  빅뱅 펀치 : 1타
CUSTOM_ANI_BIG_BANG_PUNCH2 <- 62 		  //  빅뱅 펀치 : 2타
CUSTOM_ANI_BIG_BANG_PUNCH3 <- 63 		  //  빅뱅 펀치 : 3타
CUSTOM_ANI_BIG_BANG_PUNCH4 <- 64 		  //  빅뱅 펀치 : 4타
CUSTOM_ANI_HEAL_WIND_CAST <- 65 		  //  힐 윈드 : 캐스팅
CUSTOM_ANI_HEAL_WIND_BLAST <- 66 		  //  힐 윈드 : 발동
CUSTOM_ANI_BLUE_DRAGON1 <- 67 		  //  창룡격 : 생성
CUSTOM_ANI_BLUE_DRAGON2 <- 68 		  //  창룡격 : 투척준비
CUSTOM_ANI_BLUE_DRAGON3 <- 69 		  //  창룡격 : 투척
CUSTOM_ANI_CUTTING_DARKNESS_CHARGE <- 70 		  //  어둠가르기 : 충전
CUSTOM_ANI_CUTTING_DARKNESS_SMASH <- 71 		  //  어둠가르기 : 휘두르기
CUSTOM_ANI_CUTTING_DARKNESS_FULL_SMASH <- 72 		  //  어둠 가르기 : 충전 휘두르기
CUSTOM_ANI_MACHINE_GUN_JAB_EX_LEFT <- 73 		  //  강화 머신건 잽 연타 좌
CUSTOM_ANI_MACHINE_GUN_JAB_EX_RIGHT <- 74 		  //  강화 머신건 잽 연타 우
CUSTOM_ANI_MACHINE_GUN_JAB_EX_FINISH <- 75 		  //  강화 머신건 잽 피니쉬
CUSTOM_ANI_HEAVENLY_COMBINATION_EX <- 76 		  //  헤븐리 컴비네이션[강화]
CUSTOM_ANI_REPEATED_SMASH_EX_FINISH <- 77 		  //  강화 난격 날리기
CUSTOM_ANI_GROUND_CRASH <- 78 		  //  그라운드 스매시

CUSTOM_ATTACKINFO_JUMP_PUNCH <- 0 		  //  점프 펀치 (공병 없을때 점프공격)
CUSTOM_ATTACKINFO_DASH_ATTACK_SMASH <- 1 		  //  대시 공격 2타째
CUSTOM_ATTACKINFO_ANTIAIR_UPPER <- 2 		  //  공참타
CUSTOM_ATTACKINFO_GIANT_SWING <- 3 		  //  대회전격 : 회전
CUSTOM_ATTACKINFO_GIANT_SWING_FINAL <- 4 		  //  대회전격 : 막타
CUSTOM_ATTACKINFO_SMASHER_TRY <- 5 		  //  스매셔 잡기 시도
CUSTOM_ATTACKINFO_SMASHER_DASH <- 6 		  //  스매셔 대시
CUSTOM_ATTACKINFO_SMASHER_THROW <- 7 		  //  스매셔 던지기
CUSTOM_ATTACKINFO_QUAKE_AREA <- 8 		  //  낙봉추
CUSTOM_ATTACKINFO_LUCKY_STRAIGHT <- 9 		  //  럭키 스트레이트
CUSTOM_ATTACKINFO_SECOND_UPPER <- 10 		  //  세컨드 어퍼
CUSTOM_ATTACKINFO_DUCKING_STRAIGHT <- 11 		  //  더킹 스트레이트
CUSTOM_ATTACKINFO_DUCKING_BODYBLOW <- 12 		  //  더킹 보디블로
CUSTOM_ATTACKINFO_DUCKING_UPPER <- 13 		  //  더킹 어퍼
CUSTOM_ATTACKINFO_HOLY_COUNTER <- 14 		  //  홀리 카운터
CUSTOM_ATTACKINFO_GORGEOUS_COMBINATION1 <- 15 		  //  고저스 컴비네이션 : 잽
CUSTOM_ATTACKINFO_GORGEOUS_COMBINATION2 <- 16 		  //  고저스 컴비네이션 : 스트레이트
CUSTOM_ATTACKINFO_GORGEOUS_COMBINATION3 <- 17 		  //  고저스 컴비네이션 : 훅
CUSTOM_ATTACKINFO_CHOPPING_HAMMER <- 18 		  //  초핑 해머
CUSTOM_ATTACKINFO_HURRICANE_OF_JUDGEMENT <- 19 		  //  심판의 회오리
CUSTOM_ATTACKINFO_HOME_RUN_GRAB <- 20 		  //  홈런 : 잡기 시도
CUSTOM_ATTACKINFO_HOME_RUN_HIT <- 21 		  //  홈런 : 잡기 성공 후 1타
CUSTOM_ATTACKINFO_HOME_RUN_SMASH <- 22 		  //  홈런 : 휘두르기
CUSTOM_ATTACKINFO_BLADE_OF_PURE_WHITE <- 23 		  //  순백의 칼날
CUSTOM_ATTACKINFO_HURRICANE_ROLL_HOOK <- 24 		  //  허리케인 롤 : 훅
CUSTOM_ATTACKINFO_HURRICANE_ROLL_UPPER <- 25 		  //  허리케인 롤 : 어퍼
CUSTOM_ATTACKINFO_REPEATED_SMASH <- 26 		  //  난격 : 난타
CUSTOM_ATTACKINFO_REPEATED_SMASH_FINAL <- 27 		  //  난격 : 막타
CUSTOM_ATTACKINFO_THROW_WEAPON <- 28 		  //  거선풍 : 근거리 타격
CUSTOM_ATTACKINFO_HAMMER_OF_CONTRITION <- 29 		  //  참회의 망치
CUSTOM_ATTACKINFO_HEAVENLY_COMBINATION1 <- 30 		  //  헤븐리 컴비네이션 : 1타
CUSTOM_ATTACKINFO_HEAVENLY_COMBINATION2 <- 31 		  //  헤븐리 컴비네이션 : 2타
CUSTOM_ATTACKINFO_HEAVENLY_COMBINATION3 <- 32 		  //  헤븐리 컴비네이션 : 3타
CUSTOM_ATTACKINFO_DIVINE_CRUSH <- 33 		  //  디바인 크러시
CUSTOM_ATTACKINFO_INFIGHTER_ATTACK1 <- 34 		  //  인파이터 평타 1타
CUSTOM_ATTACKINFO_INFIGHTER_ATTACK2 <- 35 		  //  인파이터 평타 2타
CUSTOM_ATTACKINFO_INFIGHTER_ATTACK3 <- 36 		  //  인파이터 평타 3타
CUSTOM_ATTACKINFO_INFIGHTER_ATTACK4 <- 37 		  //  인파이터 평타 4타
CUSTOM_ATTACKINFO_INFIGHTER_ATTACK5 <- 38 		  //  인파이터 평타 5타
CUSTOM_ATTACKINFO_EXORCIST_ATTACK1 <- 39 		  //  퇴마사 평타 1타
CUSTOM_ATTACKINFO_EXORCIST_ATTACK2 <- 40 		  //  퇴마사 평타 2타
CUSTOM_ATTACKINFO_EXORCIST_ATTACK3 <- 41 		  //  퇴마사 평타 3타
CUSTOM_ATTACKINFO_SIDEWIND <- 42 		  //  사이드와인드
CUSTOM_ATTACKINFO_SIDEWIND_SECOND <- 43 		  //  사이드와인드 추가타
CUSTOM_ATTACKINFO_MACHINE_GUN_JAB <- 44 		  //  머신건 잽 : 연타
CUSTOM_ATTACKINFO_MACHINE_GUN_JAB_FINISH <- 45 		  //  머신건 잽 : 피니시
CUSTOM_ATTACKINFO_MACHINE_GUN_JAB_APPEND <- 46 		  //  머신건 잽 : 추가타
CUSTOM_ATTACKINFO_THROW_TALISMAN1 <- 47 		  //  성불 : 던지기1
CUSTOM_ATTACKINFO_THROW_TALISMAN2 <- 48 		  //  성불 : 던지기2
CUSTOM_ATTACKINFO_GALE_SMASH1 <- 49 		  //  질풍타 : 어깨치기
CUSTOM_ATTACKINFO_GALE_SMASH2 <- 50 		  //  질풍타 : 휘두르기
CUSTOM_ATTACKINFO_ATOMIC_SMASH_SWING <- 51 		  //  무쌍격 : 휘두르기
CUSTOM_ATTACKINFO_ATOMIC_SMASH_SMASH <- 52 		  //  무쌍격 : 내려치기
CUSTOM_ATTACKINFO_BIG_BANG_PUNCH_READY <- 53 		  //  빅뱅 펀치 : 준비
CUSTOM_ATTACKINFO_BIG_BANG_PUNCH1 <- 54 		  //  빅뱅 펀치 : 1타
CUSTOM_ATTACKINFO_BIG_BANG_PUNCH2 <- 55 		  //  빅뱅 펀치 : 2타
CUSTOM_ATTACKINFO_BIG_BANG_PUNCH3 <- 56 		  //  빅뱅 펀치 : 3타
CUSTOM_ATTACKINFO_BIG_BANG_PUNCH4 <- 57 		  //  빅뱅 펀치 : 4타
CUSTOM_ATTACKINFO_BLUE_DRAGON <- 58 		  //  창룡격
CUSTOM_ATTACKINFO_CUTTING_DARKNESS <- 59 		  //  어둠가르기
CUSTOM_ATTACKINFO_MACHINE_GUN_JAB_EX <- 60 		  //  강화 머신건 잽 : 연타
CUSTOM_ATTACKINFO_MACHINE_GUN_JAB_EX_FINISH <- 61 		  //  강화 머신건 잽 : 피니시
CUSTOM_ATTACKINFO_HEAVENLY_COMBINATION_EX2 <- 62 		  //  헤븐리 컴비네이션 : 2타
CUSTOM_ATTACKINFO_HEAVENLY_COMBINATION_EX3 <- 63 		  //  헤븐리 컴비네이션 : 3타
CUSTOM_ATTACKINFO_HEAVENLY_COMBINATION_EX4 <- 64 		  //  헤븐리 컴비네이션 : 4타
CUSTOM_ATTACKINFO_HEAVENLY_COMBINATION_EX5 <- 65 		  //  헤븐리 컴비네이션 : 5타
CUSTOM_ATTACKINFO_REPEATED_SMASH_EX_LIFT <- 66 		  //  강화 난격 띄우기
CUSTOM_ATTACKINFO_REPEATED_SMASH_EX_FINAL <- 67 		  //  강화 난격 날리기
CUSTOM_ATTACKINFO_GROUND_CRASH1 <- 68 		  //  그라운드 스매시 1타
CUSTOM_ATTACKINFO_GROUND_CRASH2 <- 69 		  //  그라운드 스매시 2타


ATTACK_DIRECTION_UP <- 0 		  //  올려치기
ATTACK_DIRECTION_HORIZON <- 1 		  //  수평치기
ATTACK_DIRECTION_DOWN <- 2 		  //  내려치기
ATTACK_DIRECTION_MAX <- 3 

ATTACKTYPE_PHYSICAL <- 0 		  //  독립 물리 공격
ATTACKTYPE_MAGICAL <- 1 		  //  독립 마법 공격  
ATTACKTYPE_ABSOLUTE <- 2 		  //  방어 무시 공격
ATTACKTYPE_MAX <- 3 

ATTACKTARGET_OWN <- 0 		  //  자신
ATTACKTARGET_FRIEND <- 1 		  //  아군
ATTACKTARGET_ENEMY <- 2 		  //  (자신과 아군 이외의) 적

DAMAGEACT_NONE <- 0 		  //  반응 없음
DAMAGEACT_DAMAGE <- 1 		  //  데미지 모션
DAMAGEACT_DOWN <- 2 		  //  다운
DAMAGEACT_DAMAGE_EXCEPT_HUMAN <- 3 		  //  기본 데미지, 휴먼아머는 반응없음

KNOCK_BACK_TYPE_NORMAL <- 0 		  //  일반
KNOCK_BACK_TYPE_KNOCK_BACK <- 1 		  //  뒤로 많이 밀림 (넉백)
KNOCK_BACK_TYPE_SHORT_KNOCK_BACK_ <- 2 		  //  뒤로 약간 밀림 (넉백)
KNOCK_BACK_TYPE_PIXEL_WITHOUT_DAMAGE_TIME <- 3 		  //  NORMAL_DAMAGE_BACK_TIME 시간동안 지정한 픽셀만큼 뒤로 밀림, 이동중 경직이 풀리면 이동도 멈춤
KNOCK_BACK_TYPE_NOT_BACK <- -1 		  //  뒤로 안밀림

HIT_DIRECTION_AUTO <- 0 		  //  자동 판별
HIT_DIRECTION_FRONT <- 1 		  //  앞으로
HIT_DIRECTION_BACK <- 2 		  //  뒤로
HIT_DIRECTION_OUTER <- 3 		  //  바깥쪽으로
HIT_DIRECTION_INNER <- 4 		  //  안쪽으로

WEAPON_SUBTYPE_CROSS <- 0 		  //  십자가
WEAPON_SUBTYPE_ROSARY <- 1 		  //  염주
WEAPON_SUBTYPE_TOTEM <- 2 		  //  토템
WEAPON_SUBTYPE_SCYTHE <- 3 		  //  낫
WEAPON_SUBTYPE_BATTLE_AXE <- 4 		  //  배틀 액스
WEAPON_SUBTYPE_MAX <- 5 

GROW_TYPE_PRIEST <- 0 		  //  프리스트
GROW_TYPE_CRUSADER <- 1 		  //  크루세이더
GROW_TYPE_INFIGHTER <- 2 		  //  인파이터
GROW_TYPE_EXORCIST <- 3 		  //  퇴마사
GROW_TYPE_AVENGER <- 4 		  //  어벤저
GROW_TYPE_PRIEST_G <- 5 		  //  프리스트G

EXTENDED_PUNCH_MOTION_DASH_ATTACK <- 0 		  //  대시 공격
EXTENDED_PUNCH_MOTION_SECOND_UPPER <- 1 		  //  세컨드 어퍼
EXTENDED_PUNCH_MOTION_MAX <- 2 

BASE_ATTACK_TYPE_DEFAULT <- 0 		  //  기본
BASE_ATTACK_TYPE_INFIGHTER <- 1 		  //  인파이터 주먹
BASE_ATTACK_TYPE_EXORCIST <- 2 		  //  퇴마사 거병

BATTLE_AURA_MOTION_ATTACK_12 <- 0 		  //  평타1,2 (잽)
BATTLE_AURA_MOTION_ATTACK_3 <- 1 		  //  평타3 (스트레이트)
BATTLE_AURA_MOTION_ATTACK_4 <- 2 		  //  평타4 (어퍼)
BATTLE_AURA_MOTION_ATTACK_5 <- 3 		  //  평타5 (내려찍기)
BATTLE_AURA_MOTION_GORGEOUS_COMBINATION <- 4 		  //  고저스 컴비네이션
BATTLE_AURA_MOTION_SIDEWIND <- 5 		  //  사이드와인드
BATTLE_AURA_MOTION_SIDEWIND_SECOND <- 6 		  //  사이드와인드 추가타
BATTLE_AURA_MOTION_MAX <- 7 



CHANGE_STATUS_TYPE_PHYSICAL_ATTACK <- 0 		  //  물리 공격
CHANGE_STATUS_TYPE_MAGICAL_ATTACK <- 1 		  //  마법 공격
CHANGE_STATUS_TYPE_MAGICAL_DEFENSE <- 2 		  //  마법 방어력
CHANGE_STATUS_TYPE_PHYSICAL_DEFENSE <- 3 		  //  물리 방어
CHANGE_STATUS_TYPE_EQUIPMENT_PHYSICAL_ATTACK <- 4 		  //  장비 데미지
CHANGE_STATUS_TYPE_EQUIPMENT_PHYSICAL_DEFENSE <- 5 		  //  장비 물리 방어
CHANGE_STATUS_TYPE_PHYSICAL_ATTACK_BONUS <- 6 		  //  물리 공격 보너스
CHANGE_STATUS_TYPE_MAGICAL_ATTACK_BONUS <- 7 		  //  마법 공격 보너스
CHANGE_STATUS_TYPE_JUMP_POWER <- 8 		  //  점프력
CHANGE_STATUS_TYPE_JUMP_SPEED_RATE <- 9 		  //  점프 속도
CHANGE_STATUS_TYPE_ATTACK_SPEED <- 10 		  //  공격 속도
CHANGE_STATUS_TYPE_MOVE_SPEED <- 11 		  //  이동 속도
CHANGE_STATUS_TYPE_CAST_SPEED <- 12 		  //  캐스트 속도
CHANGE_STATUS_TYPE_HP_MAX <- 13 		  //  HP MAX
CHANGE_STATUS_TYPE_HP_REGEN_RATE <- 14 		  //  HP 회복속도
CHANGE_STATUS_TYPE_PHYSICAL_CRITICAL_HIT_RATE <- 15 		  //  물리 크리티컬 히트 확률
CHANGE_STATUS_TYPE_MAGICAL_CRITICAL_HIT_RATE <- 16 		  //  마법 크리티컬 히트 확률
CHANGE_STATUS_TYPE_PHYSICAL_BACK_ATTACK_CRITICAL <- 17 		  //  백어택 크리티컬 히트 확률
CHANGE_STATUS_TYPE_MAGICAL_BACK_ATTACK_CRITICAL <- 18 		  //  백어택 크리티컬 히트 확률
CHANGE_STATUS_TYPE_CRITICAL_TOLERANCE_RATE <- 19 		  //  크리티컬 내성
CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_FIRE <- 20 		  //  화속성저항
CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_WATER <- 21 		  //  수속성저항
CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_DARK <- 22 		  //  암속성저항
CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_LIGHT <- 23 		  //  명속성저항
CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_ALL <- 24 		  //  모든 속성저항
CHANGE_STATUS_TYPE_ELEMENT_TOLERANCE_ZERO <- 25 		  //  속성저항력 0
CHANGE_STATUS_TYPE_ACTIVESTATUS_TOLERANCE_ALL <- 26 		  //  모든 상태
CHANGE_STATUS_TYPE_ACTIVEPROPERTY_STUCK <- 27 		  //  스턱(회피)
CHANGE_STATUS_TYPE_BACK_ATTACK_STUCK_TOLERANCE <- 28 		  //  백어택 스턱 내성 [내가 맞을때] (% 단위)
CHANGE_STATUS_TYPE_MP_REGEN_RATE <- 29 		  //  MP 회복 속도
CHANGE_STATUS_TYPE_EXTRA_SPEED_RATE <- 30 		  //  히트시 경직
CHANGE_STATUS_TYPE_EQUIPMENT_MAGICAL_ATTACK <- 31 		  //  장비 마법 공격
CHANGE_STATUS_TYPE_EQUIPMENT_MAGICAL_DEFENSE <- 32 		  //  장비 마법 방어
CHANGE_STATUS_TYPE_STUCK <- 33 		  //  스턱 [내가 때릴때](적중)
CHANGE_STATUS_TYPE_HIT_RECOVERY <- 34 		  //  히트 리커버리
CHANGE_STATUS_TYPE_MELEE_HIT_DELAY <- 35 		  //  근거리 타격시 힛 딜레이
CAHNGE_STATUS_TYPE_EQUIPMENT_ALL_STAT <- 36 		  //  장비의 모든 능력치를 올려줄 때.
CHANGE_STATUS_TYPE_CUSTOM <- 37 
CHANGE_STATUS_TYPE_EXP_DOUBLE <- 38 		  //  경험치 2배
CHANGE_STATUS_TYPE_EVIL_UP <- 39 		  //  항마력 높음
CHANGE_STATUS_TYPE_EVIL_DOWN <- 40 		  //  92 항마력 낮음 
CHANGE_STATUS_TYPE_RIGIDITY <- 41 		  //  경직도
CHANGE_STATUS_TYPE_ELEMENT_ATTACK_FIRE <- 42 		  //  화속성 강화
CHANGE_STATUS_TYPE_ELEMENT_ATTACK_WATER <- 43 		  //  수속성 강화
CHANGE_STATUS_TYPE_ELEMENT_ATTACK_DARK <- 44 		  //  암속성 강화
CHANGE_STATUS_TYPE_ELEMENT_ATTACK_LIGHT <- 45 		  //  명속성 강화
CHANGE_STATUS_TYPE_ELEMENT_ATTACK_ALL <- 46 		  //  모든 속성 강화
CHANGE_STATUS_TYPE_DISEASE <- 47 		  //  질병
CHANGE_STATUS_TYPE_MP_MAX <- 48 		  //  MP MAX
CHANGE_STATUS_TYPE_COOLTIME_DECLINE <- 49 		  //  스킬 쿨타임
CHANGE_STATUS_TYPE_PHYSICAL_CRITICAL_DAMAGE_RATE <- 50 		  //  물리 크리티컬 데미지 증가 비율
CHANGE_STATUS_TYPE_MAGICAL_CRITICAL_DAMAGE_RATE <- 51 		  //  마법 크리티컬 데미지 증가 비율
CHANGE_STATUS_TYPE_BLOODWAR_GROW_ABILITY <- 52 		  //  블러드 던전(혈투의탑) 성장 
CHANGE_STATUS_TYPE_ADDITIONAL_PHYSICAL_GENUINE_ATTACK <- 53 		  //  독립 데미지 물리 공격력 변화
CHANGE_STATUS_TYPE_ADDITIONAL_MAGICAL_GENUINE_ATTACK <- 54 		  //  독립 데미지 마법 공격력 변화
CHANGE_STATUS_TYPE_SUMMON_SKILL_POWER_BONUS_RATE <- 55 		  //  마법사 소환수의 스킬 공격력 증가
CHANGE_STATUS_TYPE_ANTIEVIL <- 56 		  //  실제 항마력 수치 조정
CHANGE_STATUS_TYPE_PHYSICAL_ABSOLUTE_DAMAGE <- 57 		  //  물리 절대 데미지 or 물리 방어무시 데미지
CHANGE_STATUS_GHOST_TRAIN_NO_BREATH_TIME <- 58 		  //  유령열차 질식 시간 변경
CHANGE_STATUS_CHARACTER_LINK <- 59 		  //  캐릭터 링크
CHANGE_STATUS_GOLD_INCREASE <- 60 
CHANGE_STATUS_TYPE_MAX <- 61 


OBJECTTYPE_OBJECT <- 0 		  //  최상위 오브젝트
OBJECTTYPE_COLLISION <- 1 		  //  충돌 오브젝트 (OBJECTTYPE_OBJECT 하위)
OBJECTTYPE_ACTIVE <- 17 		  //  능동 오브젝트 (OBJECTTYPE_COLLISION 하위)
OBJECTTYPE_CHARACTER <- 273 		  //  캐릭터 오브젝트 (OBJECTTYPE_ACTIVE 하위)
OBJECTTYPE_MONSTER <- 529 		  //  몬스터 오브젝트 (OBJECTTYPE_ACTIVE 하위)
OBJECTTYPE_RIDABLEOBJECT <- 4625 		  //  탈것 관련 오브젝트 (OBJECTTYPE_MONSTER 하위)
OBJECTTYPE_PASSIVE <- 33 		  //  수동 오브젝트 (OBJECTTYPE_COLLISION 하위)
OBJECTTYPE_ITEM <- 289 		  //  아이템 오브젝트 (OBJECTTYPE_PASSIVE 하위)
OBJECTTYPE_TRAP <- 545 		  //  트랩 오브젝트 (OBJECTTYPE_PASSIVE 하위)
OBJECTTYPE_BREAKABLE <- 1057 		  //  파괴 가능한 오브젝트(보물상자 겸함) (OBJECTTYPE_PASSIVE 하위)
OBJECTTYPE_PET <- 65 		  //  신수 (OBJCTTYPE_COLLISION 하위)
OBJECTTYPE_CREATURE <- 129 		  //  크리쳐 (OBJCTTYPE_COLLISION 하위)
OBJECTTYPE_DRAWONLY <- 2 		  //  그리기 전용 오브젝트 (OBJECTTYPE_OBJECT 하위)
OBJECTTYPE_VIRTUALCHARACTER <- 18 		  //  대기실에서 쓰는 가상 캐릭터 (OBJECTTYPE_DRAWONLY 하위)
OBJECTTYPE_NPC <- 34 		  //  대기실의 NPC (OBJECTTYPE_DRAWONLY 하위)
OBJECTTYPE_DONKEY <- 66 		  //  대기실의 개인상점 (OBJECTTYPE_DRAWONLY 하위)
OBJECTTYPE_VIRTUALCREATURE <- 130 		  //  대기실에서 쓰는 가상 크리쳐(OBJECTTYPE_DRAWONLY 하위)
OBJECTTYPE_DISJOINTSHOP <- 258 		  //  대기실의 해체가 해체 상점(OBJECTTYPE_DRAWONLY 하위)
OBJECTTYPE_VIRTUALMONSTER <- 514 		  //  대기실에서 쓰는 가상 몬스터 (OBJECTTYPE_DRAWONLEY 하위)
OBJECTTYPE_NONE_DELETE <- 1026 		  //  오브젝트 삭제 시 삭제되지 않는 오브젝트 (OBJECTTYPE_DRAWONLEY 하위) 
OBJECTTYPE_DEFINE_END <- 61440 


CONVERT_TABLE_TYPE_DAMAGE <- 0 		  //  데미지
CONVERT_TABLE_TYPE_DEFENSE <- 1 		  //  방어력
CONVERT_TABLE_TYPE_HP <- 2 		  //  HP MAX
CONVERT_TABLE_TYPE_PHYSICAL_ATTACK <- 3 		  //  힘
CONVERT_TABLE_TYPE_PHYSICAL_DEFENSE <- 4 		  //  체력
CONVERT_TABLE_TYPE_MAGICAL_ATTACK <- 5 		  //  지능
CONVERT_TABLE_TYPE_MAGICAL_DEFENSE <- 6 		  //  정신력
CONVERT_TABLE_TYPE_PHYSICAL_ABSOLUTE_DAMAGE <- 7 		  //  물리 절대 데미지
CONVERT_TABLE_TYPE_PHYSICAL_DAMAGE_REDUCE <- 8 		  //  물리 데미지 보정
CONVERT_TABLE_TYPE_MAGICAL_ABSOLUTE_DAMAGE <- 9 		  //  마법 절대 데미지
CONVERT_TABLE_TYPE_MAGICAL_DAMAGE_REDUCE <- 10 		  //  마법 데미지 보정
CONVERT_TABLE_TYPE_ACTIVESTATUS_DAMAGE_REDUCE <- 11 		  //  상태이상 데미지 보정.
CONVERT_TABLE_TYPE_MP <- 12 		  //  MP MAX
CONVERT_TABLE_TYPE_SKILL_POWER <- 13 		  //  스킬 독립데미지
CONVERT_TABLE_TYPE_MAX <- 14 

ENUM_EQUIPMENTTYPE_AVATAR_HEADGEAR <- 0 		  //  모자 아바타
ENUM_EQUIPMENTTYPE_AVATAR_HAIR <- 1 		  //  머리 아바타
ENUM_EQUIPMENTTYPE_AVATAR_FACE <- 2 		  //  얼굴 아바타
ENUM_EQUIPMENTTYPE_AVATAR_JACKET <- 3 		  //  상의 아바타
ENUM_EQUIPMENTTYPE_AVATAR_PANTS <- 4 		  //  하의 아바타
ENUM_EQUIPMENTTYPE_AVATAR_SHOES <- 5 		  //  신발 아바타
ENUM_EQUIPMENTTYPE_AVATAR_BREAST <- 6 		  //  목가슴 아바타
ENUM_EQUIPMENTTYPE_AVATAR_WAIST <- 7 		  //  허리 아바타
ENUM_EQUIPMENTTYPE_AVATAR_SKIN <- 8 		  //  몸색깔 아바타
ENUM_EQUIPMENTTYPE_AVATAR_AURORA <- 9 		  //  오로라 아바타
ENUM_EQUIPMENTTYPE_WEAPON <- 10 		  //  무기
ENUM_EQUIPMENTTYPE_TITLE <- 11 		  //  칭호
ENUM_EQUIPMENTTYPE_JACKET <- 12 		  //  상의
ENUM_EQUIPMENTTYPE_SHOULDER <- 13 		  //  어깨
ENUM_EQUIPMENTTYPE_PANTS <- 14 		  //  하의
ENUM_EQUIPMENTTYPE_SHOES <- 15 		  //  신발
ENUM_EQUIPMENTTYPE_WAIST <- 16 		  //  허리
ENUM_EQUIPMENTTYPE_AMULET <- 17 		  //  목걸이
ENUM_EQUIPMENTTYPE_WRIST <- 18 		  //  팔찌
ENUM_EQUIPMENTTYPE_RING <- 19 		  //  반지
ENUM_EQUIPMENTTYPE_SUPPORT <- 20 		  //  보조
ENUM_EQUIPMENTTYPE_MAGIC_STONE <- 21 		  //  마법석
ENUM_EQUIPMENTTYPE_MAX <- 22 
ENUM_EQUIPMENTTYPE_AVATAR_START <- 0 		  //  아바타 시작
ENUM_EQUIPMENTTYPE_AVATAR_END <- 8 		  //  아바타 끝
ENUM_EQUIPMENTTYPE_AVATAR_SELL_END <- 8 		  //  세라샵 판매 아바타 끝
ENUM_EQUIPMENTTYPE_AVATAR_MAX <- 9 		  //  아바타 개수
ENUM_EQUIPMENTTYPE_ITEM_START <- 10 		  //  (아바타가 아닌) 아이템 시작
ENUM_EQUIPMENTTYPE_VISIBLE_END <- 11 		  //  외형 변화 장비 끝
ENUM_EQUIPMENTTYPE_CREATURE <- 22 		  //  크리쳐
ENUM_EQUIPMENTTYPE_ARTIFACT_RED <- 23 		  //  아티팩트 첫번째 슬롯
ENUM_EQUIPMENTTYPE_ARTIFACT_BLUE <- 24 		  //  아티팩트 두번째 슬롯
ENUM_EQUIPMENTTYPE_ARTIFACT_GREEN <- 25 		  //  아티팩트 세번째 슬롯
ENUM_EQUIPMENTTYPE_ARTIFACT_END <- 26 
ENUM_EQUIPMENTTYPE_CREATURE_END <- 25 
ENUM_EQUIPMENTTYPE_CREATURE_MAX <- 24 
ENUM_EQUIPMENTTYPE_ARTIFACT <- 0 		  //  아티팩트 대표인덱스
ENUM_EQUIPMENTTYPE_TOTAL_MAX <- 24 
ENUM_EQUIPMENTTYPE_VISIBLE_MAX <- 13 		  //  외형 변화 장비 개수
ENUM_EQUIPMENTTYPE_ARMOR_START <- 12 
ENUM_EQUIPMENTTYPE_ARMOR_END <- 21 
ENUM_EQUIPMENTTYPE_ARMOR_NUM <- 10 
ENUM_EQUIPMENTTYPE_EXPAND_EQUIPSLOT_REVISE <- 10 		  //  일반장착 슬롯과 공결장착 슬롯간의 보정치

SKILL_BACK_STEP <- 169 		  //  백스텝
SKILL_CANCEL_BACK_STEP <- 170 		  //  캔슬 백스텝
SKILL_CANCEL_THROW_ITEM <- 171 		  //  캔슬 아이템 투척
SKILL_ARMOR_MASTERY_LIGHT <- 172 		  //  경갑 마스터리
SKILL_ARMOR_MASTERY_HEAVY <- 173 		  //  중갑 마스터리
SKILL_BASIC_ATTACK_UP <- 174 		  // 평타 강화
SKILL_JUMP_POWER_UP <- 175 		  //  도약
SKILL_MAGICAL_ATTACK_UP <- 176 		  //  고대의 기억
SKILL_THROW_MASTERY <- 177 		  //  투척 마스터리
SKILL_PHYSICAL_BACK_ATTACK_CRITICAL <- 178 		  //  물리 백 어택
SKILL_DISJOINT_ITEM <- 179 		  //  아이템 해체
SKILL_SUPER_ARMOR_ON_CAST <- 180 		  //  불굴의 의지
SKILL_COMPOUND_CRAFT <- 181 		  //  조합:세공
SKILL_COMPOUND_WEAVING <- 182 		  //  조합:방직
SKILL_COMPOUND_MACHINE <- 183 		  //  조합:기계
SKILL_COMPOUND_CHEMISTRY <- 184 		  //  조합:화학
SKILL_ARMOR_MASTERY_LEATHER <- 185 		  //  가죽 갑옷 마스터리
SKILL_PHYSICAL_CRITICAL_HIT_UP <- 186 		  //  물리 크리티컬 히트
SKILL_ARMOR_MASTERY_CLOTH <- 187 		  //  천 방어구 마스터리
SKILL_MAGICAL_CRITICAL_HIT_UP <- 188 		  //  마법 크리티컬 히트
SKILL_MAGICAL_BACK_ATTACK_CRITICAL <- 189 		  //  마법 백 어택
SKILL_QUICK_STANDING <- 190 		  //  퀵 스탠딩
SKILL_BASIC_HP_MAX_UP <- 195 		  //  공평한 결투장 전용 스킬 - 생명력 숙련
SKILL_ARMOR_MASTERY_PLATE <- 196 		  //  판금 마스터리
SKILL_GUILD_STATUS_UP <- 200 		  //  길드 스킬
SKILL_FEATURE_STAT_PHYSICAL_ATTACK_UP <- 210 		  //  힘 특성
SKILL_FEATURE_STAT_PHYSICAL_DEFENCE_UP <- 211 		  //  체력 특성
SKILL_FEATURE_STAT_MAGICAL_ATTACK_UP <- 212 		  //  지능 특성
SKILL_FEATURE_STAT_MAGICAL_DEFENCE_UP <- 213 		  //  정신 특성
SKILL_FEATURE_STAT_STUCK_UP <- 214 		  //  적중률 특성
SKILL_FEATURE_STAT_ACTIVEPROPERTY_STUCK_UP <- 215 		  //  회피율 특성
SKILL_FEATURE_STAT_HP_REGEN_RATE_UP <- 216 		  //  HP 리젠 특성
SKILL_FEATURE_STAT_MP_REGEN_RATE_UP <- 217 		  //  MP 리젠 특성
SKILL_FEATURE_STAT_ELEMENT_ATTACK_ALL_UP <- 218 		  // 	모든 속성 강화
SKILL_FEATURE_STAT_ELEMENT_TOLERANCE_ALL_UP <- 219 		  //  모든 속성 저항
SKILL_MAX <- 220 
SKILL_FEATURE_STAT_START <- 210 
SKILL_FEATURE_STAT_MAX <- 10 		  // 스탯 특성 개수


ACTIVESTATUS_SLOW <- 0 		  //  슬로우
ACTIVESTATUS_FREEZE <- 1 		  //  프리즈
ACTIVESTATUS_POISON <- 2 		  //  포이즌
ACTIVESTATUS_STUN <- 3 		  //  스턴
ACTIVESTATUS_CURSE <- 4 		  //  커스
ACTIVESTATUS_BLIND <- 5 		  //  블라인드
ACTIVESTATUS_LIGHTNING <- 6 		  //  라이트닝
ACTIVESTATUS_STONE <- 7 		  //  스톤
ACTIVESTATUS_SLEEP <- 8 		  //  슬립
ACTIVESTATUS_BURN <- 9 		  //  화상
ACTIVESTATUS_WEAPON_BREAK <- 10 		  //  무기 파괴
ACTIVESTATUS_BLEEDING <- 11 		  //  블리딩
ACTIVESTATUS_HASTE <- 12 		  //  헤이스트
ACTIVESTATUS_BLESS <- 13 		  //  블레스
ACTIVESTATUS_ELEMENT <- 14 		  //  엘레먼트
ACTIVESTATUS_CONFUSE <- 15 		  //  혼란
ACTIVESTATUS_HOLD <- 16 		  //  홀드
ACTIVESTATUS_ARMOR_BREAK <- 17 		  //  갑옷 파괴
ACTIVESTATUS_MAX <- 18 


GROW_TYPE_PRIEST <- 0		/// 프리스트
GROW_TYPE_CRUSADER <- 1		/// 크루세이더
GROW_TYPE_INFIGHTER <- 2	/// 인파이터
GROW_TYPE_EXORCIST <- 3		/// 퇴마사
GROW_TYPE_AVENGER <- 4		/// 어벤저


ENUM_CHARACTERJOB_SWORDMAN <- 0     /// 검사
ENUM_CHARACTERJOB_FIGHTER <- 1      /// 격투가
ENUM_CHARACTERJOB_GUNNER <- 2       /// 거너
ENUM_CHARACTERJOB_MAGE <- 3			/// 마법사
ENUM_CHARACTERJOB_PRIEST <- 4		/// 프리스트
ENUM_CHARACTERJOB_AT_GUNNER <- 5	/// 여성 거너
ENUM_CHARACTERJOB_THIEF <- 6		/// 도둑
ENUM_CHARACTERJOB_AT_FIGHTER <- 7	/// 남성 격투가
ENUM_CHARACTERJOB_AT_MAGE <- 8		/// 남성 마법사
ENUM_CHARACTERJOB_DEMONIC_SWORDMAN <- 9	/// 마검사
ENUM_CHARACTERJOB_CREATOR_MAGE <- 10	/// 크리에이터
ENUM_CHARACTERJOB_MAX <- 11	/// 


ENUM_IS_REVERSE <- 0
ENUM_IS_START <- 1
ENUM_IS_PAUSE <- 2
ENUM_IS_END <- 3
ENUM_IS_INTERPOLATE_ATTACKBOX <- 4
ENUM_NEVER_APPLY_ANOTHER_PLAYERS_EFFECT_ALPHA_RATE <- 5
ENUM_IS_APPLY_ANOTHER_PLAYERS_EFFECT_ALPHA_RATE <- 6
ENUM_ANIMATION_BOOL_MAX <- 7


MODULE_TYPE_NONE <- -1
MODULE_TYPE_ENTRANCE <- 0
MODULE_TYPE_ROOM_LIST <- 1	// 마을
MODULE_TYPE_SELECT_DUNGEON <- 2				// 던전 선택화면
MODULE_TYPE_MAIN_GAME <- 3					// 일반던전(이계 포함)
MODULE_TYPE_PVP <- 4						// 결장
MODULE_TYPE_FAIR_PVP <- 5					// 공결
//MODULE_TYPE_LABYRINTH <- 7				// 사라짐
MODULE_TYPE_SELECT_CHANNEL <- 6             
MODULE_TYPE_WARROOM <- 7					// 전쟁지역
//MODULE_TYPE_CHAOS <- 8					
MODULE_TYPE_LOGIN <- 8
MODULE_TYPE_ASSAULT <- 9					// 싸우자
MODULE_TYPE_DEAD_TOWER <- 10					// 사탑
MODULE_TYPE_BLOOD_SYSTEM <- 11				// 무한의 제단
MODULE_TYPE_DESPAIR_TOWER <- 12			//절망의탑

// 글로벌실 컨텐츠
MODULE_TYPE_BOSS_TOWER <- 13			//심연의 투기장
MODULE_TYPE_ADVANCE_ALTAR <- 14			//진격의 제단

MODULE_TYPE_LOAD <- 15
MODULE_TYPE_TOURNAMENT <- 16
MODULE_TYPE_MAX <- 17
MODULE_TYPE_PVP_TYPE <- 18			// 결투장, 싸우자, 전쟁지역을 합쳐 지칭
MODULE_TYPE_DUNGEON_TYPE <- 19		// 던전, 사탑, 무제를 합쳐 지칭
MODULE_TYPE_ALL <- 20			

//MODULE_TYPE_LOAD <- 13
//MODULE_TYPE_TOURNAMENT <- 14
//MODULE_TYPE_MAX <- 15
//MODULE_TYPE_PVP_TYPE <- 16			// 결투장, 싸우자, 전쟁지역을 합쳐 지칭
//MODULE_TYPE_DUNGEON_TYPE <- 17		// 던전, 사탑, 무제를 합쳐 지칭
//MODULE_TYPE_ALL <- 18				// 모든 모듈을 지칭


ATTACKTYPE_PHYSICAL <- 0		/// 독립 물리 공격
ATTACKTYPE_MAGICAL  <- 1       /// 독립 마법 공격  
ATTACKTYPE_ABSOLUTE <- 2      /// 방어 무시 공격
ATTACKTYPE_LIGHT	<- 3
ATTACKTYPE_DARK		<- 4
ATTACKTYPE_WATER	<- 5
ATTACKTYPE_FIRE		<- 6
ATTACKTYPE_MAX		<- 7

BUFF_CAUSE_NORMAL <- 0// 일반 어펜디지 같은 타입
BUFF_CAUSE_ACTIVE_STATUS <- 1// 상태이상
BUFF_CAUSE_SKILL <- 2		// 스킬
BUFF_CAUSE_EXCEPTIONAL <- 3	// 예외처리를 위함(마을에서도 유지되는 버프 아이콘 같은 것)
BUFF_NONE <- 4				// 아무런것도 하지 않음
BUFF_CAUSE_MAX <- 5



PAUSETYPE_NONE		<- 0	/// 일시정지 안함
PAUSETYPE_OBJECT	<- 1	/// 오브젝트만 일시정지 (Appendage, 상태 변화, 이펙트는 계속 돌아감, 중력 미적용)
PAUSETYPE_WORLD		<- 2	/// 전 세계가 일시정지 (Appendage, 상태 변화, 이펙트도 정지)

ENUM_ELEMENT_FIRE	<- 0	/// 화
ENUM_ELEMENT_WATER	<- 1	/// 수
ENUM_ELEMENT_DARK	<- 2	/// 암
ENUM_ELEMENT_LIGHT	<- 3	/// 명
ENUM_ELEMENT_NONE	<- 4	/// 무
ENUM_ELEMENT_MAX	<- 4	/// == ENUM_ELEMENT_NONE


//  던지는 대상의 타입
THROW_TYPE_SKILL	<- 0	/// 스킬
THROW_TYPE_ITEM		<- 1	/// 투척 아이템
SETUP_TYPE_ITEM		<- 2	/// 설치 아이템

SPEED_TYPE_CONST						<- 0	/// 상수값. 변경해도 setStaticSpeedInfo를 재호출하기 전까지는 적용 안됨
SPEED_TYPE_MOVE_SPEED					<- 1	/// 이동 속도
SPEED_TYPE_ATTACK_SPEED					<- 2	/// 공격 속도
SPEED_TYPE_EXCEPT_WEAPON_ATTACK_SPEED	<- 3	/// 무기 빠진 공격 속도
SPEED_TYPE_CAST_SPEED					<- 4	/// 캐스트 속도

Z_ACCEL_TYPE_CONST				<- 0	/// 임의의 상수
Z_ACCEL_TYPE_GRAVITY_WORLD		<- 1	/// 중력 : 세계의 강제 중력
Z_ACCEL_TYPE_GRAVITY_OBJECT		<- 2	/// 중력 : 캐릭터별 중력
Z_ACCEL_TYPE_ANTIGRAVITY_OBJECT	<- 3	/// 반중력 : 중력에 반대되는 힘. 또는 양력.

STATICINFO_DEPTH				<- 4	/// Static Info의 최대 저장 깊이. (기본 -> 장비 적용 -> 상태변화 적용 -> 아이템, 스킬 적용)
X_NORMALMOVE_VELOCITY			<- 143	/// 가로 이동시 가로로 1초동안 이동 픽셀 수
X_SLANTMOVE_VELOCITY			<- 119	/// 대각선 이동시 가로로 1초동안 이동 픽셀 수
Y_NORMALMOVE_VELOCITY			<- 114	/// 세로 이동시 세로로 1초동안 이동 픽셀 수
Y_SLANTMOVE_VELOCITY			<- 95	/// 대각선 이동시 세로로 1초동안 이동 픽셀 수
FORCE_TO_VELOCITY_CONST			<- 4000	/// 힘에 의한 속도를 계산하는 상수. 속도 = 상수 * 힘 / 무게
SPEED_VALUE_DEFAULT				<- 1000	/// 이동 속도, 공격 속도등의 속도값 기본치. 이 값이면 100%임.
LIGHT_OBJECT_MAX_WEIGHT			<- 60000	/// 효과음에서 가벼운 무게의 상한선
MIDDLE_OBJECT_MAX_WEIGHT		<- 100000	/// 효과음에서 중간 무게의 상한선
DEFAULT_GRAVITY_ACCEL			<- -1500	/// 기본 중력 가속도


OBJECT_MESSAGE_INVINCIBLE		<- 0
OBJECT_MESSAGE_GHOST			<- 1
OBJECT_MESSAGE_SUPERARMOR		<- 2
OBJECT_MESSAGE_UNBREAKABLE		<- 3
OBJECT_MESSAGE_END				<- 4

RECOVER_TYPE_HP					<- 0
RECOVER_TYPE_MP					<- 1
RECOVER_TYPE_HP_MP				<- 2
RECOVER_TYPE_MAX				<- 3

REASON_NONE						<- 0
REASON_DEATH					<- 1
REASON_MOVING_VILLAGE			<- 2
REASON_LOGIN					<- 3
REASON_ALL						<- 4

OPTION_HOTKEY_MOVE_UP 	<- 0
OPTION_HOTKEY_MOVE_DOWN <- 2
OPTION_HOTKEY_MOVE_LEFT <- 1
OPTION_HOTKEY_MOVE_RIGHT <- 3
ENUM_SUBKEY_TYPE_ALL <- 7


GROW_TYPE_AT_MAGE			<- 0	//  남법사
GROW_TYPE_ELEMENTAL_BOMBER	<- 1	//  엘레멘탈 바머
GROW_TYPE_GRACIAL_MASTER	<- 2	//  빙결사

PARTICLE_CREATER_LARGE_HIT			<- 0		/// 큰 타격용
PARTICLE_CREATER_SMALL_HIT			<- 1		/// 작은 타격용
PARTICLE_CREATER_FIRE_HIT			<- 2		/// 화 속성 타격용
PARTICLE_CREATER_FIRE_HIT_LIGHT		<- 3		/// 화 속성 타격용
PARTICLE_CREATER_WATER_HIT			<- 4		/// 수 속성 타격용
PARTICLE_CREATER_WATER_HIT_LIGHT	<- 5		/// 수 속성 타격용
PARTICLE_CREATER_WATER_HIT_ICE		<- 6		/// 수 속성 타격용

OPTION_HOTKEY__UNDEFINED <- -1 		  //  정의되지 않음
OPTION_HOTKEY_MOVE_UP <- 0 		  //  (Up arrow)
OPTION_HOTKEY_MOVE_LEFT <- 1 		  //  (Left arrow)
OPTION_HOTKEY_MOVE_DOWN <- 2 		  //  (Down arrow)
OPTION_HOTKEY_MOVE_RIGHT <- 3 		  //  (Right arrow)
OPTION_HOTKEY_ATTACK <- 4 		  //  (X)
OPTION_HOTKEY_JUMP <- 5 		  //  (C)
OPTION_HOTKEY_SKILL <- 6 		  //  (Z)
OPTION_HOTKEY_SKILL2 <- 7 		  //  buff용 키(space)
OPTION_HOTKEY_CREATURE_SKILL <- 8 		  //  (V)
OPTION_HOTKEY_STATUS_WINDOW <- 9 		  //  (M)
OPTION_HOTKEY_SKILL_WINDOW <- 10 		  //  (K)
OPTION_HOTKEY_ITEM_INVENTORY <- 11 		  //  (I)
OPTION_HOTKEY_OPTION_WINDOW <- 12 		  //  (O)
OPTION_HOTKEY_NORMAL_QUEST_WINDOW <- 13 		  //  (Q)
OPTION_HOTKEY_AVATAR_INVENTORY <- 14 		  //  (U)
OPTION_HOTKEY_CERASHOP <- 15 		  //  (T)
OPTION_HOTKEY_MINIMAP <- 16 		  // 던전 미니맵(N)
OPTION_HOTKEY_CREATURE_WINDOW <- 17 		  //  (Y)
OPTION_HOTKEY_TOOLTIP_ <- 18 		  // 상세보기 전환키(R)
OPTION_HOTKEY_EPIC_QUEST_WINDOW <- 19 		  //  (W)
OPTION_HOTKEY_QUICK_SKILL1 <- 20 		  //  스킬 슬롯(A, S, D, F, G, H)
OPTION_HOTKEY_QUICK_SKILL2 <- 21 
OPTION_HOTKEY_QUICK_SKILL3 <- 22 
OPTION_HOTKEY_QUICK_SKILL4 <- 23 
OPTION_HOTKEY_QUICK_SKILL5 <- 24 
OPTION_HOTKEY_QUICK_SKILL6 <- 25 
OPTION_HOTKEY_EXSKILL1 <- 26 		  //  확장스킬 슬롯(F1 - F6)
OPTION_HOTKEY_EXSKILL2 <- 27 
OPTION_HOTKEY_EXSKILL3 <- 28 
OPTION_HOTKEY_EXSKILL4 <- 29 
OPTION_HOTKEY_EXSKILL5 <- 30 
OPTION_HOTKEY_EXSKILL6 <- 31 
OPTION_HOTKEY_ITEM_QUICKSLOT1 <- 32 		  //  아이템 퀵 슬롯(1 - 6)
OPTION_HOTKEY_ITEM_QUICKSLOT2 <- 33 
OPTION_HOTKEY_ITEM_QUICKSLOT3 <- 34 
OPTION_HOTKEY_ITEM_QUICKSLOT4 <- 35 
OPTION_HOTKEY_ITEM_QUICKSLOT5 <- 36 
OPTION_HOTKEY_ITEM_QUICKSLOT6 <- 37 
OPTION_HOTKEY_TOGGLE_ITEM_NAME_IN_DUNGEON <- 38 		  //  던전에서 아이템 이름보기(ctrl)
OPTION_HOTKEY_HIDE_MAIN_HUD <- 39 		  //  인터페이스 숨기기(Tab)
OPTION_HOTKEY_TOGGLE_TITLE_ANIMATION <- 40 		  //  닉네임 정보 모드 변환(E)
OPTION_HOTKEY_TOGGLE_SKILL_INFORMATION <- 41 		  //  스킬 툴팁 설명 모드 전환(F7)
OPTION_HOTKEY_PAUSE_IN_TOWER <- 42 		  //  사망의 탑 일시정지
OPTION_HOTKEY_CAPTURE_MOVING_PICTURE <- 43 		  //  동영상 캡쳐(Pause)
OPTION_HOTKEY_MENU_MY_INFO <- 44 		  //  내보관함 메뉴(7)
OPTION_HOTKEY_MENU_COMMUNITY <- 45 		  //  커뮤니티 메뉴(8)
OPTION_HOTKEY_MENU_CONTENTS <- 46 		  //  컨텐츠 메뉴(9)
OPTION_HOTKEY_MENU_SERVICE <- 47 		  //  서비스 메뉴(0)
OPTION_HOTKEY_MENU_SYSTEM__CLOSE_ALL_WINDOW <- 48 		  // 모든창닫기(Esc)
OPTION_HOTKEY_PVP <- 49 		  //  결투장(P)
OPTION_HOTKEY_RECOMMEND_USER <- 50 		  //  추천동료([)
OPTION_HOTKEY_PARTY_MATCHING <- 51 		  //  파티매칭(])
OPTION_HOTKEY_FRIEND <- 52 		  //  친구(L)
OPTION_HOTKEY_GUILD <- 53 		  //  길드(;)
OPTION_HOTKEY_MEMBER <- 54 		  //  멤버(')
OPTION_HOTKEY_BLACKLIST <- 55 		  //  차단
OPTION_HOTKEY_PVP_BUDDY <- 56 		  //  결투친구
OPTION_HOTKEY_WAR_AREA_LIST <- 57 		  //  전쟁지역목록창(,)
OPTION_HOTKEY_AUCTION_WINDOW <- 58 		  //  경매장(B)
OPTION_HOTKEY_GOBLIN_PAD <- 59 		  //  고블린패드
OPTION_HOTKEY_HOTKEY_SETTING_WINDOW <- 60 		  //  단축키 설정창
OPTION_HOTKEY_WAR_AREA_INFORMATION <- 61 		  //  전쟁지역 정보창(End)
OPTION_HOTKEY_HELLMODE_INFORMATION <- 62 		  //  더 이상 사용되지 않음
OPTION_HOTKEY_FAVOR_CHECK_WINDOW <- 63 		  //  더 이상 사용되지 않음
OPTION_HOTKEY_EXPERT_JOB <- 64 		  //  전문직업 기능
OPTION_HOTKEY_EMOTION_EXPRESSION <- 65 		  //  감정표현 기능
OPTION_HOTKEY_EVENT <- 66 		  //  이벤트키(shift)
OPTION_HOTKEY_PVP_MSSION <- 67 		  //  미션윈도우
OPTION_HOTKEY_PVP_RECORD <- 68 		  //  전적보기창
OPTION_HOTKEY_QUICK_CHAT_0 <- 69 
OPTION_HOTKEY_QUICK_CHAT_1 <- 70 
OPTION_HOTKEY_QUICK_CHAT_2 <- 71 
OPTION_HOTKEY_QUICK_CHAT_3 <- 72 
OPTION_HOTKEY_QUICK_CHAT_4 <- 73 
OPTION_HOTKEY_QUICK_CHAT_5 <- 74 
OPTION_HOTKEY_QUICK_CHAT_6 <- 75 
OPTION_HOTKEY_QUICK_CHAT_7 <- 76 
OPTION_HOTKEY_QUICK_CHAT_8 <- 77 
OPTION_HOTKEY_QUICK_CHAT_9 <- 78 
OPTION_HOTKEY_TOGGLE_ITEMINFO_COMPARE <- 79 		  //  아이템 비교창 전환키 (Default: F8)
OPTION_HOTKEY_TITLEBOOK <- 80 		  //  칭호북
OPTION_HOTKEY_THIS_DUNGEON <- 81 		  //  재도전
OPTION_HOTKEY_ANOTHER_DUNGEON <- 82 		  //  다른 던전 도전
OPTION_HOTKEY_RETURN_TO_TOWN <- 83 		  //  마을로 돌아가기
OPTION_HOTKEY_MERCENARY_SYSTEM <- 84 		  //  용병 시스템
OPTION_HOTKEY_ITEM_DICTIONARY <- 85 
OPTION_HOTKEY_QUICK_PARTY_REGISTER <- 86 		  //  빠른 파티 등록 요청


STATE_BURSTER				<- 100	// 공통스킬 state 버스터
// 공통 skill관련 부분입니다.
// 198	`ATMage/Buster.skl`				// 버스터
SKILL_BURSTER				<- 198	// 공통스킬 버스터
