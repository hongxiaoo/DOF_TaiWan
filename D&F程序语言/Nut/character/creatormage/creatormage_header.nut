// 이곳은 던파소스에 없는 순수 스크립트로만 개발하면서 필요한 스킬개발에 필요한 상수,enum 추가값을 선언하는 부분입니다. 
// 던파소스에 있는 값을 이곳에 넣으시면 안됩니다.

//******************************************************************************************
// STATE 인덱스 등록
//******************************************************************************************

//******************************************************************************************
// SKILL 인덱스 등록
//******************************************************************************************

//******************************************************************************************
// CUSTOM ANI 인덱스 등록
//******************************************************************************************

//******************************************************************************************
// ATTACK 인덱스 등록
//******************************************************************************************

//******************************************************************************************
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

CREATOR_TYPE_NONE <- 0
CREATOR_TYPE_FLAME	<- 1
CREATOR_TYPE_ICE	<- 2
CREATOR_TYPE_DISTURB	<- 3
CREATOR_TYPE_GUARDIAN	<- 4
CREATOR_TYPE_WIND	<- 5
CREATOR_TYPE_MAX	<- 6


SKL_LV_0 <- 0 
SKL_LV_1 <- 1 
SKL_LV_2 <- 2 
SKL_LV_3 <- 3 
SKL_LV_4 <- 4 


CUSTOM_ANI_FIRE_WALL <- 69	/// 크리에이터 : 파이어월
CUSTOM_ANI_FIRE_HURRICANE <- 70 // 크리에이터 : 파이어 허리케인
CUSTOM_ANI_ICE_ROCK <- 72 // 크리에이터 : 아이스락
CUSTOM_ANI_ICE_SHIELD <- 73 // 크리에이터 : 아이스쉴드
CUSTOM_ANI_ICE_PLATE <- 74 // 크리에이터 : 아이스 플레이트

CUSTOM_ANI_WINDPRESS_CAST <- 75 // 크리에이터 : 윈드프레스 캐스팅
CUSTOM_ANI_WINDPRESS_START <- 76 // 크리에이터 : 윈드프레스 발사
CUSTOM_ANI_WINDPRESS <- 77 // 크리에이터 : 윈드프레스 루핑
CUSTOM_ANI_WINDPRESS_END <- 78 // 크리에이터 : 윈드프레스 마무리

CUSTOM_ANI_CAST_GUARD <- 79 // 크리에이터 : 방어속성 캐스트 동작
CUSTOM_ANI_CAST_WIND <- 80 // 크리에이터 : 바람속성 캐스트 동작
CUSTOM_ANI_CAST_DISTURB <- 81 // 크리에이터 : 방해속성 캐스트 동작


CUSTOM_ATTACKINFO_FIRE_HURRICANE <- 38 /// 크리에이터 : 화염 허리케인

STATE_MGRAB <- 61
SKILL_MGRAB <- 137

STATE_FIREWALL <- 54
SKILL_FIREWALL <- 131

STATE_WOODFENCE <- 60
SKILL_WOODFENCE <- 138

STATE_ICEROCK <- 57
SKILL_ICEROCK <- 134

STATE_FIREMETEO <- 56
SKILL_FIREMETEO <- 133

STATE_FIREHURRICANE <- 55
SKILL_FIREHURRICANE <- 132

STATE_ICESHIELD <- 58
SKILL_ICESHIELD <- 135

STATE_ICEPLATE <- 59
SKILL_ICEPLATE <- 136

STATE_CREATORFLAME <- 62
SKILL_CREATORFLAME <- 250

STATE_CREATORICE <- 63
SKILL_CREATORICE <- 251

STATE_CREATORDISTURB <- 64
SKILL_CREATORDISTURB <- 252

STATE_CREATORGUARDIAN <- 65
SKILL_CREATORGUARDIAN <- 253

STATE_CREATORWIND <- 66
SKILL_CREATORWIND <- 254

STATE_WINDPRESS <- 67
SKILL_WINDPRESS <- 248



SKILL_WINDSTORM <- 249

TILE_FLOOR_START_Y <- 120 /// 타일에서 바닥이 시작되는 y좌표	


// 속성별 스킬 어펜디지 사용 인덱스 입니다.
I_REMAIN_COUNT <- 0 // 남아있는 스킬갯수
l_CHARGE_ON <- 1 // 충전 중 인지 체크
I_BEFORE_X <- 2 // 시간
I_BEFORE_Y <- 3 // 시간
I_MAX_COUNT <- 4 // 최대충전량
I_BEFORE_COUNT <- 5 // 지난 게이지
I_CHARGE_TIME <- 6 // 충전시간
I_CHARGE_INIT_COUNT <- 7 // 충전초기 시작 갯수
I_CURRENT_CHARGE_TIME <- 8 // 충전 흘러간 시간
I_SIZE <- 9 //

