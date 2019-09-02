
S_FLOW_NORMAL <- 0 // 기본구조대로
S_FLOW_PRIEST <- 1 // 프리스트 쪽으로 곧장 빠져야한다..
S_FLOW_RETURN <- 2 // 

// Awakening.skl 스킬레벨 테이블
SL_PERFECT_CHANGE_HP <- 0 // (0) 완전 변신체 HP 
SL_CHANGE_TIME <- 1 // (1) 지속시간 
SL_DEF_INC <- 2 // (2) 방어력증가(+)
SL_ATK_SPD <- 3 // (3) 공격속도(+)
SL_MOV_SPD <- 4 // (4) 이동속도(+)
SL_1_HIT_MAGIC_ATK <- 5 // (5) 1타 마법공격력(+)
SL_2_HIT_MAGIC_ATK <- 6 // (6) 2타 마법공격력(+)
SL_3_HIT_MAGIC_ATK <- 7 // (7) 3타 마법공격력(+)
SL_DASH_MAGIC_ATK <- 8 // (8) 대시 마법공격력(+)
SL_JUMP_MAGIC_ATK <- 9 // (9) C(점프) 마법공격력(+)
SL_JUMP_FULLCHARGE_MAGIC_ATK <- 10 // (10) 풀충전 C(점프) 마법공격력(+)


// 
// DevilStrike.skl 스킬레벨 테이블
SL_DS_ATTACK1_GAUGE_COMSUME <- 0 // 0.z키 게이지 소모양
SL_DS_ATTACK2_GAUGE_COMSUME <- 1 // 1.x키 게이지 소모양
SL_DS_ATTACK3_GAUGE_COMSUME <- 2 // 2.c키 게이지 소모양
SL_DS_ATTACK1_ATTACK_RATE <- 3 // 3.z키 공격력(%)
SL_DS_ATTACK2_ATTACK_RATE <- 4 // 4.x키 공격력(%)
SL_DS_ATTACK3_ATTACK_RATE <- 5 // 5.c키 공격력(%)


// DevilStrike.skl 스킬레벨 테이블
SL_DS_ATTACK1_GAUGE_COMSUME <- 0 // 0.z키 게이지 소모양
SL_DS_ATTACK2_GAUGE_COMSUME <- 1 // 1.x키 게이지 소모양
SL_DS_ATTACK3_GAUGE_COMSUME <- 2 // 2.c키 게이지 소모양
SL_DS_ATTACK1_ATTACK_RATE <- 3 // 3.z키 공격력(%)
SL_DS_ATTACK2_ATTACK_RATE <- 4 // 4.x키 공격력(%)
SL_DS_ATTACK3_ATTACK_RATE <- 5 // 5.c키 공격력(%)


// 데빌스트라이커 인덱스
DEVILSTRIKE_ATTACK_1 <- 0
DEVILSTRIKE_ATTACK_2 <- 1
DEVILSTRIKE_ATTACK_3 <- 2

// 데빌스트라이커 어펜디지 VECTOR 인덱스 
DS_APEND_MAX_GAUGE <- 0 // 최대 악마게이지 수치
DS_APEND_GAUGE <- 1 // 현재 악마게이지 수치
DS_APEND_LAST_GAUGE <- 2 // 지난 악마게이지 수치
DS_APEND_ADD_FLAG <- 3 // using state 데빌스트라이커는 스킬 한번당 한번만 충전이 되기 때문에 체크플래그를 만들어둬야합ㄴ디ㅏ..
DS_APEND_BEFORE_ADD <- 4 // 바로 전 


// 어벤져 각성모드 인지 체크
function isAvengerAwakenning(obj)
{
	if(!obj) return false;
	
	local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_awakening.nut");
	
	if(appendage) {
		// 리얼 밸리드 플래그로 쓸 멤버입니다.. 왜 이런식이 됐냐면.. 
		// 어벤저가 state_stand상태에서만 변신해제가 되어야 합니다 
		// 그래서 valid가 false가 된다고 해서 곧장 변신해제 됐다고 간주해서는 안됩니다 여러방법을 생각해낸 결과 이 방법이 가장 깔끔할거 같아서 입니다.. 
		// 머 쓰이는 곳도 없으니까
		local isvalid = appendage.sq_var.get_vector(I_AVENGER_AWAKENING_VALID);
		if(isvalid) {
			return true;
		}
	}
	
	return false;	
}

function isGrowTypeAvenger(obj) // 파라미터로 넘겨진 객체가 프리스트-어벤저인지 체크하는 함수입니다..
{
	if(!obj) return false;
	
	if(sq_getJob(obj) == ENUM_CHARACTERJOB_PRIEST && sq_getGrowType(obj) == GROW_TYPE_AVENGER) return true; // 어벤져가 아니라면 또한 그려줄 필욘 없을겁니다..
	
	return false;
}

// 데빌스트라이커를 쓰는데 적당한 state인지 체크
function isExecutableStateDevilStrike(obj)
{
	if(!obj) return false;
	
	if(isAvengerAwakenning(obj)) return false;
	
	local skill = sq_GetSkill(obj, SKILL_DEVILSTRIKE);
	
	local bEnable = false;
	
	if(skill) {
		local state = obj.getState();
		bEnable = skill.isExcutableState(state);
		
		//print("isExecutableStateDevilStrike:" + bEnable + " state:" + state);
		
		if(bEnable) {
			if(state == STATE_THROW) { // 가능한 skill 중에 state_throw로 진행하는 몇개의 스킬이 있는데 이것에 관해서는 수동으로 체크한다..
				 if(obj.getThrowIndex() != SKILL_GRASP_HAND_OF_ANGER && obj.getThrowIndex() != SKILL_CHANGE_HP_TO_MP) {
					bEnable = false;
				 }
			}			
		}
		
		local var_devil = obj.getVar("devilStrike");
		
		if(bEnable) {
			
			local before_state = var_devil.get_vector(1); // 0번은 쿨타임 1번은 전 state
			if(state == before_state) {
				//var_devil.set_vector(2, 1); // 2번인덱스 플래그는 연속 데빌스트라이크 
			}
			else {
				var_devil.set_vector(2, 0); // 2번인덱스 플래그는 연속 데빌스트라이크 
				var_devil.set_vector(1, state);
			}
		}
		else {
			var_devil.set_vector(2, 0); // 2번 인덱스 플래그는 연속 데빌스트라이크 
			var_devil.set_vector(1, state);
		}
	}
	
	
	return bEnable;
}


// 데빌스트라이커의 악마소비량을 구합니다..
function getDevilStrikeConsumeValue(obj, attack_index)
{
	if(!obj) return 999999; // obj가 널이라면.. 일단 소비량을 엄청나게 불려서 날린다..
	
	local level = sq_GetSkillLevel(obj, SKILL_DEVILSTRIKE);
	local consumeValue = sq_GetLevelData(obj, SKILL_DEVILSTRIKE, SL_DS_ATTACK1_GAUGE_COMSUME + attack_index, level);	
	
	return consumeValue;
}


// 어벤저 데빌스트라이커 공격 가능한지 체크
function isInDevilStrike(obj)
{
	if(!obj) return false;
	
	local level = sq_GetSkillLevel(obj, SKILL_DEVILSTRIKE);
	
	if(level <= 0) return false;
	
	local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_devilstrike.nut"); // 데빌스트라이커 어펜디지
	
	if(appendage) {
		if(appendage.isValid() && level > 0) {
			if(!isExecutableStateDevilStrike(obj)) return false; // 데빌스트라이커를 쓰는데 적당한 state인지 체크
			
			return true;
		}
	}
	
	return false;	
}


// 어벤저 - 데빌스트라이커 스킬을 갖고 있는지 체크합니다..
function isInDevilStrikeSkill(obj)
{
	if(!obj) return false;
	
	local level = sq_GetSkillLevel(obj, SKILL_DEVILSTRIKE);
	
	if(level <= 0) return false;
	
	local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_devilstrike.nut"); // 데빌스트라이커 어펜디지
	
	
	
	if(appendage) {
		if(appendage.isValid() && level > 0) {
			return true;
		}
	}
	
	return false;	
}

// 기술을 쓰는 와중에 다단히트가 들어갔을 때 데빌게이지 고속충전이 이루어지는것을 막기위해 이미 충전되었는지 체크하는 함수 입니다..
// 인자는 state_throw에서 분기되는 부분도 있기 때문에 skl파일의 staticindex로 비교해봅니다..
function IsAddDevilGauge(obj, staticIndex)
{
	if(!obj) return false;
	
	local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_devilstrike.nut"); // 데빌스트라이커 어펜디지	
	
	local use_index = -1;
	
	if(appendage) {
		use_index = appendage.sq_var.get_vector(DS_APEND_ADD_FLAG);
	}
	//print("IsAddDevilGauge:" + use_index);
	
	if(use_index >= 0) { // -1이거나
		return true;
	}
	
	return false;
}



// 현재 남아있는 악마게이지와 요청하는 데빌스트라이커 인덱스의 악마게이지 소모량과 
// 비교해서 충분히 남아있다면 return true를 합니다.. 

function IsEnableDevilStrike(obj, index)
{
	if(!obj) return false; 
	
	if(!isInDevilStrike(obj)) return false;
	
	//SL_DS_ATTACK1_GAUGE_COMSUME <- 0 // 0.z키 게이지 소모양
	//SL_DS_ATTACK2_GAUGE_COMSUME <- 1 // 1.x키 게이지 소모양
	//SL_DS_ATTACK3_GAUGE_COMSUME <- 2 // 2.c키 게이지 소모양
	//SL_DS_ATTACK1_ATTACK_RATE <- 3 // 3.z키 공격력(%)
	//SL_DS_ATTACK2_ATTACK_RATE <- 4 // 4.x키 공격력(%)
	//SL_DS_ATTACK3_ATTACK_RATE <- 5 // 5.c키 공격력(%)
	//
	//
	//// 데빌스트라이커 인덱스
	//DEVILSTRIKE_ATTACK_1 <- 0
	//DEVILSTRIKE_ATTACK_2 <- 1
	//DEVILSTRIKE_ATTACK_3 <- 2
	
	local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_devilstrike.nut"); // 데빌스트라이커 어펜디지
	
	if(!appendage) return false;

	if(appendage.sq_var.size_vector() > 1) {
		//iKeyList[0] = E_ATTACK_COMMAND;
		//iKeyList[1] = E_JUMP_COMMAND;
		//iKeyList[2] = E_SKILL_COMMAND;
		local leve_column = 0;
		
		if(index == 0) { // attack (x)
			leve_column = 1;
		}
		else if(index == 1) { // jump (c)
			leve_column = 2;
		}
		else if(index == 2) { // skill (z)
			leve_column = 0;
		}
		
		local consumeValue = getDevilStrikeConsumeValue(obj, leve_column);
		
		//DS_APEND_MAX_GAUGE <- 0 // 최대 악마게이지 수치
		//DS_APEND_GAUGE <- 1 // 현재 악마게이지 수치
		
		local devil_gauge = appendage.sq_var.get_vector(DS_APEND_GAUGE); // gauge index 0
		
		if(devil_gauge >= consumeValue) return true;
		else {
			//obj.startCantUseSkillWarning();
			if (obj.isMessage()) {
				sq_AddMessage(29002); // 29002>악마게이지가 부족합니다.
			}
			return false;
		}
		
	}
	
	
	return false;
}

// 쿨타임이 끝나 작동가능한 타임을 리턴하는 함수. 
function getLoadSkillEnableTime(obj, skillIndex, intDataIndex)
{
	if(!obj) return 0;
	
	local skill = sq_GetSkill(obj, skillIndex);
	local level = sq_GetSkillLevel(obj, skillIndex);
	local enableTime = 0;

	if (skill == null)
		return enableTime;

	enableTime = obj.sq_getIntData(skillIndex, intDataIndex);
	
	//print("enableTime:" + enableTime);

	return enableTime;
	//return obj.sq_GetObjectWorldTime(obj).Get() + enableTime;
}



// 각 데빌스트라이커 스킬을 쏠 수 있는 기술들을 살펴본다.. 남아있는 악마게이지 수치로 체크해본다..
// 그 수치에 부합되는 스킬이 있다면 그 스킬에 매핑되어 있는 키를 sq_SetKeyxEnable로 누를 수 있는 상태로 만든 후에 

function isEnterDevilStrike(obj, commandIndex, devil_index)
{
	if(!obj) return false;
	
	local bEnable = false;
	
	
	local beforeCommandEnable = sq_GetKeyxEnable(obj, commandIndex);
	
	sq_SetKeyxEnable(obj, commandIndex, true);
	

	local bCommand = sq_IsEnterCommand(obj, commandIndex);
	
	//print("bCommand:" + bCommand + " commandIndex:" + commandIndex + " getstate:" +  obj.getState());

	if(bCommand) {
		bEnable = IsEnableDevilStrike(obj, devil_index); // 게이지 소모량 체크해서 가능한지		
	}	
	//sq_SetKeyxEnable(obj, commandIndex, beforeCommandEnable);
	//}	
	
	return bEnable;
}


// 악마게이지량을 얻어옵니다..
function getDevilGauge(obj)
{
	if(!obj) return 0;
	
	local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_devilstrike.nut"); // 데빌스트라이커 어펜디지
	
	local v = 0;
	
	if(!appendage) return 0;
	
	if(appendage.sq_var.size_vector() > 1) {
		//appendage.sq_var.set_vector(500);
		v = appendage.sq_var.get_vector(DS_APEND_GAUGE); // gauge index 1
	}
	
	return v;
}

function getDevilMaxGaugeValue(obj)
{
	if(!obj) return 0;
	
	local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_devilstrike.nut"); // 데빌스트라이커 어펜디지
	
	if(!appendage) return 0;
	
	local v = 0;
	if(appendage.sq_var.size_vector() > 1) {
		v = appendage.sq_var.get_vector(DS_APEND_MAX_GAUGE); // gauge index 0
	}
	
	return v;
}


// 악마게이지를 세팅합니다..
function setDevilGauge(obj, value)
{
	if(!obj) return 0;
	
	local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_devilstrike.nut"); // 데빌스트라이커 어펜디지
	
	if(!appendage) return 0;
	
	if(appendage.sq_var.size_vector() > 1) {
		appendage.sq_var.set_vector(DS_APEND_GAUGE, value); // gauge index 0
	}
}

// 악마게이지 소비량을 넘겨주면 알아서 깎아줍니다..
function consumeDevilGauge(obj, consumeValue)
{
	if(!obj) return;
	
	local devil_value = getDevilGauge(obj);	
	
	local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_devilstrike.nut"); // 데빌스트라이커 어펜디지
	
	if(appendage) {
		//DS_APEND_MAX_GAUGE <- 0 // 최대 악마게이지 수치
		//DS_APEND_GAUGE <- 1 // 현재 악마게이지 수치
		//DS_APEND_LAST_GAUGE <- 2 // 지난 악마게이지 수치
	
		appendage.sq_var.set_vector(DS_APEND_LAST_GAUGE, devil_value); // 지난 게이지수치를 저장한다..
		
		appendage.getTimer().Reset();
		appendage.getTimer().Start(0,0);
	}
	
	local value = devil_value - consumeValue;
	
	if(value < 0)
		value = 0;
		
	setDevilGauge(obj, value);
}

// 각성패시브 : 악몽(48레벨)
// 1. 각성 변신 동안 각성기 공격력이 증가함
// 2. 데빌 스트라이커의 악마 게이지 차는량 증가.
// 각성패시브 악몽을 갖고 있는지 체크하고 갖고 있다면 악마 게이지 차는량을 증가시켜서 리턴합니다..
function getDSGConvertbyNightmare(obj, addValue) // get DevilStrikeGauge Convert by Nightmare
{
	if(!obj) return 0;
	
	local level = sq_GetSkillLevel(obj, SKILL_NIGHTMARE);
	
	local gauge_bonus = sq_GetLevelData(obj, SKILL_NIGHTMARE, 0, level); // 0번 인덱스 칼럼 게이지보너스(+)
	
	if(gauge_bonus < 0)
		gauge_bonus = 0;
		
	local value = addValue + gauge_bonus;
	
	return value;
}


// 악마게이지를 충전합니다..
function addDevilGauge(obj, addValue)
{
	if(!obj) return;
	
	local devil_value = getDevilGauge(obj);
	
	// 각성패시브 악몽을 갖고 있는지 체크하고 갖고 있다면 악마 게이지 차는량을 증가시켜서 리턴합니다..
	local result_addValue =	getDSGConvertbyNightmare(obj, addValue);

	local add = result_addValue - addValue;
	//print("addValue:" + addValue + " add:" + add + " result_addValue:" + result_addValue);
	
	local value = devil_value + result_addValue;
	
	local  maxValue = getDevilMaxGaugeValue(obj);
	if(value >= maxValue)
		value = maxValue;
		
		
	setDevilGauge(obj, value);

}



// 어벤져가 기본 state가 nut파일로 기입되어 있을 상황일때 예를 들면 state_attack이라든지..
// 이것이 어벤져용 STATE_ATTACK이 있더라도 상황에 따라 CNPriest::setState 쪽으로 빠지게 하려면 기존 구조로는 방법이 없다.. 왜냐면 onSetState는 irdcharacter에 있으므로
// 다시 거꾸로 돌아가는 구조는 있을 수 없다 그래서 사전에 변신인지 체크해보고 그렇다면.. state_attack으로 빠지고 아니라면.. priest:: 로 빠지는 구조로 바꾸어야한다..
// 이것이 그 리턴값이다..

function isPriestFlow(obj, state)
{
	if(!obj) return true;
 // 이곳에서 true를 리턴하면 irdcharacter:: 쪽으로 가는것이 아니라 cnpriest 쪽으로 가게 됩니다..
	if(!isGrowTypeAvenger(obj)) // 어벤저가 아닌 경우 무조건 flowpriest로
		return true;
		
	if(isAvengerAwakenning(obj) == true) { // 각성변신상태라면..
		if(state == STATE_DASH_ATTACK) {
			return false;
		}
	}
	
	if(isAvengerAwakenning(obj) == false) {
		//if(state == STATE_ATTACK)
		//	return false;
			
		return true;
	}
	
	
	return false;
}

function flushCommandEnable_Avenger(obj)
{
	if(!obj) return S_FLOW_NORMAL;
	
	if(!obj.isInBattle()) {
		sq_SetAllCommandEnable(obj, false); // 전투중일땐 모든 스킬을 사용할 수 없습니다.
		return S_FLOW_RETURN;
	 }
	
	if(isAvengerAwakenning(obj) == true) { // 각성 변신상태라면 다른 스킬은 전부 비활성화 시켜야 한다..단 각성 변신에서 오는 스킬만 빼고 이를테면..단두대 ?
		// 처형스킬을 드디어 활성화시킨다..
		if(obj.isMyControlObject())
			sq_SetAllCommandEnable(obj, false); // 모든 state를 닫아놓는다..
			
		local skill = sq_GetSkill(obj, SKILL_EXECUTION);		
		if(skill) {
			if(obj.getState() != STATE_AVENGER_AWAKENING) // 변신동작이 아니어야합니다.. 
			{
				// 처형아이콘이 소모량보다 많을 때만 활성화되도록 합니다..
				local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_devilstrike.nut"); // 데빌스트라이커 어펜디지
				
				if(appendage) {
					local skillLevel = sq_GetSkillLevel(obj, SKILL_EXECUTION);
					local consumeValue = sq_GetLevelData(obj, SKILL_EXECUTION, 7, skillLevel);
					
					//DS_APEND_MAX_GAUGE <- 0 // 최대 악마게이지 수치
					//DS_APEND_GAUGE <- 1 // 현재 악
					local devil_gauge = appendage.sq_var.get_vector(DS_APEND_GAUGE); // gauge index 0
					
					if(devil_gauge >= consumeValue) {		
						skill.setCommandEnable(true); 
					}
				}
			}
		}
		
		skill = sq_GetSkill(obj, SKILL_EX_DISASTER);
		
		if(skill) {
			skill.setCommandEnable(true); 
		}
		
		skill = sq_GetSkill(obj, SKILL_PANDEMONIUM_EX);
		
		if(skill) {
			skill.setCommandEnable(true); 
		}
		
		return S_FLOW_RETURN;
	}
	
	return S_FLOW_NORMAL;
}

function setState_Avenger(obj, state, datas, isResetTimer)
{
	if(!obj) return S_FLOW_PRIEST;
	if(!isGrowTypeAvenger(obj)) return S_FLOW_PRIEST;
	
	// 데빌스트라이커 충전스킬 플래그 온
	if(isInDevilStrikeSkill(obj)) {	
		if(state != obj.getState() || state == STATE_ATTACK) { // 지난 state가 달라야 이제 데빌게이지를 충전할 수 있는것입니다..		
			local staticIndex = getStaticDataIndexDevilGauge(obj, -1, state); 
			
			
			// 현재 캐릭터의 state를 체크하여 리턴되는값이 -1이 아니라면 충전해줘야한다는 의미입니다..
			if(staticIndex != -1) { // 
				local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_devilstrike.nut"); // 데빌스트라이커 어펜디지			
				if(appendage) {
					//if(appendage.sq_var.get_vector(DS_APEND_ADD_FLAG) == -1) 
					//-2를 리턴해야 이제 게이지를 충전시킬 수 있도록한다..왜냐면.. 같은 state를 계속 요청하는 경우가 있기때문에..
						//print("\n setState_Avenger:" + obj.getState() + " DS_APEND_ADD_FLAG: staticIndex " + staticIndex);
						appendage.sq_var.set_vector(DS_APEND_ADD_FLAG, staticIndex); // 충전 시키는 체크플래그를 킵니다..
				}
			}
		}
	}
	
	if(state == STATE_THROW)
	{
		if(obj.getThrowIndex() == SKILL_CHANGE_HP_TO_MP && obj.getThrowState() == 0) {
			local level = sq_GetSkillLevel(obj, SKILL_CHANGE_HP_TO_MP);
			local gaugeUpValue = sq_GetLevelData(obj, SKILL_CHANGE_HP_TO_MP, 2, level);
			addDevilGauge(obj,gaugeUpValue);
		}
	}

	
	
	if(isPriestFlow(obj, state) == true) {
		return S_FLOW_PRIEST;
	}
	else {
		if(isAvengerAwakenning(obj) == true) {
		}
	}
	
	return S_FLOW_NORMAL;
}



function isRidingToObject_Avenger(obj)
{
	if(!obj) return -1;
	
	if(isAvengerAwakenning(obj) == true) { // 둠스가디언으로 변신했는데 탈것을 타면 안되징..
		//print("isRidingToObject_Avenger");
		return -1;
	}
	
	return 1;
	
}

// 이것을 오버라이딩 하는 이유는 프리스트-어벤져:둠스가디언에서 점프버튼을 눌렀을 때 공격이 나가야하므로
// 도중에 점프state 요청하는것을 후킹하기 위함입니다..
// 기본 flow는 avenger_common.nut 에서 addSetStatePacket_Avenger 리턴값이 -1이라면 IRDCollisionObject::addSetStatePacket를 호출하지 않습니다. 

function addSetStatePacket_Avenger(obj, state, datas)
{
	if(!obj)
		return -1;		
	
	
	if(state == STATE_JUMP_ATTACK) {
		//print("\n STATE_JUMP_ATTACK" + " now_state:" + obj.sq_GetSTATE());
	}
	
	if(!obj.isMyControlObject())
		return -1;
	
	if(isAvengerAwakenning(obj) == true) {
		if(state == STATE_JUMP) {
			if(obj.getState() == STATE_DASH || obj.getState() == STATE_STAND) {
			   local var_awakening = obj.getVar("awakening");
			   local t = var_awakening.get_ct_vector(0).Get();	

			   if(var_awakening.get_ct_vector(0).Get() > var_awakening.get_vector(0)) { // 자체 쿨타임 체크
					obj.sq_IntVectClear();
					obj.sq_IntVectPush(3); // substate세팅
					obj.sq_addSetStatePacket(STATE_ATTACK, STATE_PRIORITY_USER, true);
			   }
			   else { // 쿨타임이 덜 됐다..
					obj.startCantUseSkillWarning();
					if (obj.isMessage()) //
					{
						sq_AddMessage(414); // 414>쿨타임입니다.
					}
			   }
			}
			else {
				obj.sq_addSetStatePacket(STATE_SIT, STATE_PRIORITY_USER, false);
			}
			return -1;
		}
		else if(state == STATE_DIE) {
			local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_awakening.nut");
		
			if(appendage) {
				appendage.setValid(false);
				appendage.sq_var.set_vector(I_AVENGER_AWAKENING_VALID, 0);
				obj.setObjectHeight(-1);
			}
			
			return -1;
		}
		
		if(state == STATE_THROW) {
			//print("STATE_THROW");
			return -1;
		}
	}
	
	return 1;
}

function isEnableBackStepState_Avenger(obj)
{
	if(!obj) return false;
	
	if(isAvengerAwakenning(obj) == true) {
		return false; // 둠스가디언 상태에서는 백스텝을 막아놔야합니다..
	}
	
	
	//print("isEnableBackStepState");
	
	return obj.sq_isEnableBackStepState();
}

function getDefaultAttackInfo_Avenger(obj, index)
{
	local atk = null;
	if(isAvengerAwakenning(obj) == true) { // 각성 변신상태라면 다른 스킬은 전부 비활성화 시켜야 한다..단 각성 변신에서 오는 스킬만 빼고 이를테면..단두대 ?
	  atk = sq_GetCustomAttackInfo(obj, CUSTOM_ATTACKINFO_AW_ATTACK1 + index);	  
	}
	else {
	  if(isInDevilStrikeSkill(obj)) {
		atk = sq_GetCustomAttackInfo(obj, CUSTOM_ATTACKINFO_AVENGER_ATTACK_1 + index);
	  }
	}
	
	return atk;
}


// 파라미터로 넘겨진 키 인덱스와, 공격방법이 가능한지 체크하여 통과하면 패시브오브젝트를 만들어 등록합니다..
function procEnterDevilStrike(obj, keyIndex, attackIndex)
{
	if(!obj) return;
	
	local bEnable = isEnterDevilStrike(obj, keyIndex, attackIndex);
	
	if(bEnable) {					
		// 악마게이지를 깎아준다..
		if(obj.isMyControlObject()) {
			local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_devilstrike.nut"); // 데빌스트라이커 어펜디지
			
			if(appendage) {			
					
					//if (obj.getWorldTimer().Get() >= obj.getVar("devilStrike").get_vector(0)) {
					local var_devil = obj.getVar("devilStrike");
					
					local t = var_devil.get_ct_vector(0).Get();
					
					//print("get_ct_vector:" + t + "  get_vector(0):" + var_devil.get_vector(0));
					
					if(var_devil.get_ct_vector(0).Get() > var_devil.get_vector(0)) { // 자체 쿨타임 체크
						local leve_column = 0;
		
						if(attackIndex == 0) { // attack (x)
							leve_column = 1;
						}
						else if(attackIndex == 1) { // jump (c)
							leve_column = 2;
						}
						else if(attackIndex == 2) { // skill (z)
							leve_column = 0;
						}

						local consumeV = getDevilStrikeConsumeValue(obj, leve_column);
						consumeDevilGauge(obj, consumeV);


						// x키의 경우 
						// 같은 state내에서 발생하는 경우 어택인덱스를 늘려준다..
						local resultAttackIndex = attackIndex;
						
						if(keyIndex == E_ATTACK_COMMAND) {
							resultAttackIndex = obj.getVar("devilStrike").get_vector(2); // 2번인덱스 플래그는 연속 데빌스트라이크 
							//print("resultAttackIndex:" + resultAttackIndex);
							local Index = resultAttackIndex;
							Index = Index + 1;
							if(Index > 2)
								Index = 0;
							
							obj.getVar("devilStrike").set_vector(2, Index);
						}
					
						if(resultAttackIndex == 0) { // attack (x)
							leve_column = 1;
						}
						else if(resultAttackIndex == 1) { // jump (c)
							leve_column = 2;
						}
						else if(resultAttackIndex == 2) { // skill (z)
							leve_column = 0;
						}
						
						// 이제 공격발동
						local level = sq_GetSkillLevel(obj, SKILL_DEVILSTRIKE);
						
						//iKeyList[0] = E_ATTACK_COMMAND;
						//iKeyList[1] = E_JUMP_COMMAND;
						//iKeyList[2] = E_SKILL_COMMAND;
						
						//local firstAttackRate = obj.sq_getBonusRateWithPassive(SKILL_DEVILSTRIKE, state, 0, 1.0);
						
						// 데빌스트라이커의 공격력(%)
						//local attack_bonus_rate = sq_GetLevelData(obj, SKILL_DEVILSTRIKE, SL_DS_ATTACK1_ATTACK_RATE + leve_column, level);
						local devilSkill = sq_GetSkill(obj, SKILL_DEVILSTRIKE);
						local attack_bonus_rate = sq_GetAttackBonusRate(devilSkill, SL_DS_ATTACK1_ATTACK_RATE + leve_column, 1.0);
						
						//print("\n devilstrike attack_rate:" + attack_bonus_rate + " resultAttackIndex:" + leve_column);
						
						obj.sq_binaryData_startWrite();
						obj.sq_binaryData_writeDword(attack_bonus_rate); // 데빌스트라이커의 공격력(%)
						
						obj.sq_p00_sendCreatePassiveObjectPacket(24104 + resultAttackIndex, 0, 0, 1, 0);
						
						// 쿨타임 세팅
						var_devil.get_ct_vector(0).Reset();
						var_devil.get_ct_vector(0).Start(0,0);
						
						local cooltime = getLoadSkillEnableTime(obj, SKILL_DEVILSTRIKE, SI_DS_COOLTIME); // 디폴트 쿨타임
						var_devil.set_vector(0, cooltime);
				   }
				   else { // 쿨타임이 덜 됐다..
						//obj.startCantUseSkillWarning();
						if (obj.isMessage()) //
						{
							sq_AddMessage(29001); // 29001>데빌 스트라이커 쿨타임입니다.
							
						}
				   }
				//
			}
		}
		
		// 여기서 이제 주인공의 이펙트가 달라지는것이다..어두워졌다가 밝아지는 효과
		local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_DEVILSTRIKE, true, "Appendage/Character/ap_avenger_effect.nut", true);
		
	}
}

//sq_GetCustomAttackInfo

function procAppend_Avenger(obj)
{
	if(!obj) return S_FLOW_PRIEST;
	
	// 일반 어벤저인 경우
	// 이곳에서 데빌스트라이커 패시브 스킬이 있는지 체크해본다..
	if(isInDevilStrike(obj)) { // 데빌스트라이커 패시브스킬이 발동되어 있다면..		
		// 각 데빌스트라이커 스킬을 쏠 수 있는 기술들을 살펴본다.. 남아있는 악마게이지 수치로 체크해본다..
		// 그 수치에 부합되는 스킬이 있다면 그 스킬에 매핑되어 있는 키를 sq_SetKeyxEnable로 누를 수 있는 상태로 만든 후에 
		// 
		
		// 데빌스트라이커를 쏠 수 있는 상황이라면.. 
		// 1. 데빌스트라이커 패시브 스킬을 습득하였는지
		// 2. 데빌스트라이커가 발동할 수 있는 state상태인지 이 모든것이 통과가 되면..이제 키 체크를 해본다..
		if(isInDevilStrike(obj)) { 
		
			if(obj.getState() == STATE_ATTACK || obj.getState() == STATE_DASH_ATTACK) {
				// 평타라면 C키 체크합니다..
				procEnterDevilStrike(obj, E_JUMP_COMMAND, DEVILSTRIKE_ATTACK_2);
			}
			else {			
				local size = 3;
				local iKeyList =[];
				iKeyList.resize(size);
				
				iKeyList[0] = E_ATTACK_COMMAND;
				iKeyList[1] = E_JUMP_COMMAND;
				iKeyList[2] = E_SKILL_COMMAND;			
				
				for(local i=0;i<size;i+=1) {
					// 파라미터로 넘겨진 키 인덱스와, 공격방법이 가능한지 체크하여 통과하면 패시브오브젝트를 만들어 등록합니다..
					local devilstrikeAttackIndex = i;
					procEnterDevilStrike(obj, iKeyList[i], devilstrikeAttackIndex);
				}
			}
		}
		//24104	`Character/Priest/DevilStrike1.obj`	// 어벤저 - 데빌스트라이커 공격1
		//24105	`Character/Priest/DevilStrike2.obj`	// 어벤저 - 데빌스트라이커 공격2
		//24106	`Character/Priest/DevilStrike3.obj`	// 어벤저 - 데빌스트라이커 공격3
	}


	if(isPriestFlow(obj, obj.getState()) == true) {
		return S_FLOW_PRIEST;
	}


	if(obj.isMyControlObject()) {
		if(isAvengerAwakenning(obj) == true) {		
			local state = obj.getState();
			if(state == STATE_STAND) {		 
				local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_awakening.nut");
			
				if(appendage) {
					//if(appendage.isValid() && appendage.isEnd()) {
					//if(appendage.sq_var.get_vector(I_AVENGER_AWAKENING_VALID) && appendage.isEnd()) {
					if(appendage.sq_var.get_vector(I_AVENGER_AWAKENING_VALID) && appendage.isEnd()) {
						obj.sq_IntVectClear();
						obj.sq_IntVectPush(0); // substate세팅
						obj.sq_addSetStatePacket(STATE_AWAKENING_TURN_OFF, STATE_PRIORITY_IGNORE_FORCE, true);
						return S_FLOW_RETURN;
					}
				}
			}
			
			if(state == STATE_STAND || state == STATE_DASH) {
				if(obj.sq_IsEnterSkill(SKILL_BACK_STEP) != -1) {
				   local var_awakening = obj.getVar("awakening");
				   local t = var_awakening.get_ct_vector(0).Get();	

				   if(var_awakening.get_ct_vector(0).Get() > var_awakening.get_vector(0)) { // 자체 쿨타임 체크
						obj.sq_IntVectClear();
						obj.sq_IntVectPush(3); // substate세팅
						obj.sq_addSetStatePacket(STATE_ATTACK, STATE_PRIORITY_USER, true);
				   }
				   else { // 쿨타임이 덜 됐다..
						obj.startCantUseSkillWarning();
						if (obj.isMessage()) //
						{
							sq_AddMessage(414); // 414>쿨타임입니다.
						}
				   }
				}
			}
		}
	}
	
	return S_FLOW_NORMAL;
}

function drawAppend_Avenger(obj, isOver, x, y)
{
	if(!obj) return S_FLOW_PRIEST;
	
	if(isPriestFlow(obj, obj.getState()) == true) {
		return S_FLOW_PRIEST;
	}
	
	return S_FLOW_NORMAL;
}

function prepareDraw_Avenger(obj)
{
	if(!obj) return;
	if(isAvengerAwakenning(obj) == true) { // isPriestFlow 리턴값이 true라면.. 각성이 아니고 여러가지 조건이 프리스트 flow로 빠져야 한다..
		return S_FLOW_NORMAL;
	}
	
	return S_FLOW_PRIEST;
}

function getStayAni_Avenger(obj)
{
	if(!obj) return null;
	
	local sq_var = obj.getVar();
	local ani = null;
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		ani = sq_var.GetAnimationMap("Stay", "Character/Priest/Animation/AvengerAwakening/Stay.ani");		
	}
	else {
		ani = obj.sq_getStayAni();
	}
	
	return ani;
}

function getAttackAni_Avenger(obj, index)
{
	if(!obj) return null;
	
	local sq_var = obj.getVar();
	local ani = null;
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		if(index == 0) {
			ani = sq_var.GetAnimationMap("Attack1", "Character/Priest/Animation/AvengerAwakening/Attack1.ani");
		}
		else if(index == 1) {
			ani = sq_var.GetAnimationMap("Attack2", "Character/Priest/Animation/AvengerAwakening/Attack2.ani");
		}
		else if(index == 2) {
			ani = sq_var.GetAnimationMap("Attack3", "Character/Priest/Animation/AvengerAwakening/Attack3.ani");
		}
		else if(index == 3) {
			ani = sq_var.GetAnimationMap("Attack4", "Character/Priest/Animation/AvengerAwakening/Attack4.ani");
		}
		else if(index == 4) {
			ani = sq_var.GetAnimationMap("Attack5", "Character/Priest/Animation/AvengerAwakening/Attack5.ani");
		}
	}
	else {
		if(isInDevilStrikeSkill(obj)) { // 어벤저 - 데빌스트라이커 스킬을 갖고 있으면 평타가 바뀝니다..
			//print("getAttackAni_Avenger");
			if(index == 3) { // 어벤저 - 평막타는 무기 종류에 따라 2가지로 애니메이션이 바뀐다 엄밀히 말하면 효과가 다르다..
				// 십자가 - 염주
				// 나머지 낫
				if(obj.getWeaponSubType() == WEAPON_SUBTYPE_CROSS || obj.getWeaponSubType() == WEAPON_SUBTYPE_ROSARY) {
					ani = obj.sq_getCustomAni(CUSTOM_ANI_AVENGER_ATTACK_4_ROSARY);
				}
				else {
					ani = obj.sq_getCustomAni(CUSTOM_ANI_AVENGER_ATTACK_4_SCYTHE);
				}
			}
			else
				ani = obj.sq_getCustomAni(CUSTOM_ANI_AVENGER_ATTACK_1 + index);
			
		}
		else {
			//print("obj.sq_getAttackAni");
			ani = obj.sq_getAttackAni(index);
		}
	}
	
	return ani;
}


function getMoveAni_Avenger(obj)
{
	if(!obj) return null;
	
	local sq_var = obj.getVar();
	local ani = null;
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		ani = sq_var.GetAnimationMap("Move", "Character/Priest/Animation/AvengerAwakening/Move.ani");
	}
	else {
		ani = obj.sq_getMoveAni();
	}
	
	return ani;
}

function getSitAni_Avenger(obj)
{
	if(!obj) return null;
	
	local ani = null;
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		local sq_var = obj.getVar();
		ani = sq_var.GetAnimationMap("Sit", "Character/Priest/Animation/AvengerAwakening/Sit.ani"); 
		
	}
	else {
		ani = obj.sq_getSitAni();
	}	
	
	return ani;
}

function getDamageAni_Avenger(obj, index)
{
	if(!obj) return null;
	
	local ani = null;
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		ani = null;
	}
	else {
		ani = obj.sq_getDamageAni(index);
	}
	
	
	return ani;
}

function getDownAni_Avenger(obj)
{
	if(!obj) return null;
	
	local ani = null;
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		ani = null;
	}
	else {
		ani = obj.sq_getDownAni();
	}
	
	
	//local ani = obj.sq_getDownAni();
	
	return ani;
}

function getOverturnAni_Avenger(obj)
{
	if(!obj) return null;
	
	local ani = null;
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		ani = null;
	}
	else {
		ani = obj.sq_getOverturnAni();
	}
	
	return ani;
}

function getJumpAni_Avenger(obj)
{
	if(!obj) return null;
	
	local ani = null;
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		local sq_var = obj.getVar();
		ani = sq_var.GetAnimationMap("Sit", "Character/Priest/Animation/AvengerAwakening/Sit.ani"); 
	}
	else {
		ani = obj.sq_getJumpAni();
	}
	
	return ani;
}

function getJumpAttackAni_Avenger(obj)
{
	if(!obj) return null;
	
	local ani = null;
	
	//if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		//ani = null;
	//}
	//else {
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		print("\n warning \n ");
		print("\n warning \n ");
		print("\n warning \n ");
		print("\n warning \n ");
		print("\n warning \n ");
		print("\n warning \n ");
		print("\n warning \n ");
		print("(isAvengerAwakenning(obj) == true) getJumpAttackAni_Avenger");
	
	}
	
	ani = obj.sq_getJumpAttackAni();
	//}
	
	//local ani = obj.sq_getJumpAttackAni();
	
	return ani;
}

function getRestAni_Avenger(obj)
{
	if(!obj) return null;
	
	local sq_var = obj.getVar();
	local ani = null;
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		//ani = null;
		ani = sq_var.GetAnimationMap("Stay", "Character/Priest/Animation/AvengerAwakening/Stay.ani");
	}
	else {
		ani = obj.sq_getRestAni();
	}
	
//	local ani = obj.sq_getRestAni();
	
	return ani;
}

function getThrowChargeAni_Avenger(obj, index)
{
	if(!obj) return null;
	
	local ani = null;
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		ani = null;
	}
	else {
		ani = obj.sq_getThrowChargeAni(index);
	}
	
	//local ani = obj.sq_getThrowChargeAni(index);
	
	return ani;
}

function getThrowShootAni_Avenger(obj, index)
{
	if(!obj) return null;
	
	local ani = null;
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		ani = null;
	}
	else {
		ani = obj.sq_getThrowShootAni(index);
	}
	
	//local ani = obj.sq_getThrowShootAni(index);
	
	return ani;
}

function getDashAni_Avenger(obj)
{
	if(!obj) return null;
	
	local sq_var = obj.getVar();
	local ani = null;
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		ani = sq_var.GetAnimationMap("Dash", "Character/Priest/Animation/AvengerAwakening/Dash.ani");
	}
	else {
		ani = obj.sq_getDashAni();
	}
	
	//local ani = obj.sq_getDashAni();
	
	return ani;
}

function getAttackCancelStartFrame_Avenger(obj, index)
{
	if(!obj) return null;
	
	local frm = 0;
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		if(index == 0) {
			frm = 4; // 원투 공격은..프레임 3이상에서 변경
		}
		else if(index == 1) {
			frm = 2; // 원투 공격은..프레임 3이상에서 변경
		}
		else if(index == 2) {
			frm = 8; // 마지막 공격은 10프레임 이상에서 변경
		}
	}
	else {
		if(isInDevilStrikeSkill(obj)) { // 어벤저 - 데빌스트라이커 스킬을 갖고 있으면 평타가 바뀝니다..
			if(index == 0) {
				frm = 2; // 원투 공격은..프레임 2이상에서 변경
			}
			else if(index == 1) {
				frm = 3; // 원투 공격은..프레임 3이상에서 변경
			}
			else if(index == 2) {
				frm = 5; // 마지막 공격은 5프레임 이상에서 변경
			}
		}
		else
			frm = obj.sq_getAttackCancelStartFrame(index);
	}	
	
	return frm;
}


function getAttackCancelStartFrameSize_Avenger(obj)
{
	if(!obj) return null;
	
	local frmSize = 0;
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		//frmSize = 3; // 기본공격이 어벤져 각성 변신은 4개다..
		frmSize = 2; // 기본공격이 어벤져 각성 변신은 4개다..
	}
	else {
		if(isInDevilStrikeSkill(obj)) { // 어벤저인 경우 평타가 몇개인지
			frmSize = 3; // 어벤저는 기본공격이 4개 입니다..
		}
		else
			frmSize = obj.sq_getAttackCancelStartFrameSize();
	}
	
	return frmSize;
}


function getDashAttackAni_Avenger(obj)
{
	if(!obj) return null;

	local ani = null;
	local sq_var = obj.getVar();
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		ani = sq_var.GetAnimationMap("DashAttack", "Character/Priest/Animation/AvengerAwakening/DashAttack.ani");
	}
	else {
		ani = obj.sq_getDashAttackAni();
	}

	//local ani = obj.sq_getDashAttackAni();
	
	return ani;
}

function getGetItemAni_Avenger(obj)
{
	if(!obj) return null;
	
	local ani = null;
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		local sq_var = obj.getVar();
		ani = sq_var.GetAnimationMap("GetItem", "Character/Priest/Animation/AvengerAwakening/GetItem.ani"); 
	}
	else {
		ani = obj.sq_getGetItemAni();
	}
	
	//local ani = obj.sq_getGetItemAni();
	
	return ani;
}

function getBuffAni_Avenger(obj)
{
	if(!obj) return null;
	
	local ani = null;
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		ani = null;
	}
	else {
		ani = obj.sq_getBuffAni();
	}
	
	//local ani = obj.sq_getBuffAni();
	
	return ani;
}


function getJumpAttackInfo_Avenger(obj)
{
	if(!obj) return null;
	local atk = obj.sq_getJumpAttackInfo();
	
	return atk;
}


function getDashAttackInfo_Avenger(obj)
{
	if(!obj) return null;
		
	local atk = null;
	
	// 각성패시브 : 악몽(48레벨)
	// 1. 각성 변신 동안 각성기 공격력이 증가함
	// 2. 데빌 스트라이커의 악마 게이지 차는량 증가.
	// 각성패시브 악몽을 갖고 있는지 체크하고 갖고 있다면 악마 게이지 차는량을 증가시켜서 리턴합니다..
	
	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		atk = sq_GetCustomAttackInfo(obj, CUSTOM_ATTACKINFO_AW_DASHATTACK);
		
		local state = obj.sq_GetSTATE();
	    local power = obj.sq_getBonusRateWithPassive(SKILL_AVENGER_AWAKENING, state, SL_DASH_MAGIC_ATK,1.0);
	    obj.sq_setCurrentAttackBonusRate(power);
	    
		//sq_setAttackPowerWithPassive
	}
	
	return atk;
}

function getJumpUpStartFrame_Avenger(obj)
{
	if(!obj) return null;
	local index = obj.sq_getJumpUpStartFrame();
	
	return index;
}

function getJumpDownStartFrame_Avenger(obj)
{
	if(!obj) return null;
	local index = obj.sq_getJumpDownStartFrame();
	
	return index;
}

function getJumpLandStartFrame_Avenger(obj)
{
	if(!obj) return null;
	local index = obj.sq_getJumpLandStartFrame();
	
	return index;
}


// 슬라이딩 공격을 했을때 
function getDashAttackSlideStopFrame_Avenger(obj)
{
	if(!obj) return null;
	local index = -1;

	if(isAvengerAwakenning(obj) == true) { // 어벤져 각성모드라면
		index = 15;
	}
	else {
		index = obj.sq_getDashAttackSlideStopFrame();
	}
	
	return index;
}

function drawDevilStrikeGauge(obj)
{
	if(!obj) return;
	
	// 데빌스트라이커 게이지 그리기
	local level = sq_GetSkillLevel(obj, SKILL_DEVILSTRIKE);
	
	if(level <= 0) return; // 데빌스트라이커의 패시브스킬이 없다면 또 그려줄 필욘없을겁니다.. 그럴일이 있을까 모르겠지만..
	
	local sq_var = obj.getVar();
	
	local gaugebar_normal_base = sq_var.GetAnimationMap("4_gaugebar_normal_base", "Character/Priest/Effect/Animation/DevilStrike/gauge/4_gaugebar_normal_base.ani");
	local gaugebar_normal_flash = sq_var.GetAnimationMap("4_gaugebar_normal_flash", "Character/Priest/Effect/Animation/DevilStrike/gauge/4_gaugebar_normal_flash.ani");
	local gaugebar_normal_max = sq_var.GetAnimationMap("4_gaugebar_normal_max", "Character/Priest/Effect/Animation/DevilStrike/gauge/4_gaugebar_normal_max.ani");
	
	local gauge_normal_bar = sq_var.GetAnimationMap("5_gauge_normal_bar", "Character/Priest/Effect/Animation/DevilStrike/gauge/5_gauge_normal_bar.ani");
	local gauge_normal_flash = sq_var.GetAnimationMap("5_gauge_normal_flash", "Character/Priest/Effect/Animation/DevilStrike/gauge/5_gauge_normal_flash.ani");
	local gauge_normal_max = sq_var.GetAnimationMap("5_gauge_normal_max", "Character/Priest/Effect/Animation/DevilStrike/gauge/5_gauge_normal_max.ani");
	local gauge_normal_max_f = sq_var.GetAnimationMap("5_gauge_normal_max_f", "Character/Priest/Effect/Animation/DevilStrike/gauge/5_gauge_normal_max_f.ani");

	local x = 105;
	local y = 525;
	
	local line_buff_num = 9;


	if(sq_getMyBuffInfoCount() > line_buff_num) { // 2줄일땐 위로 올린다..	
		local line_offset = 20;
		local line_num = sq_getMyBuffInfoCount() / line_buff_num; // 버프아이콘으로 라인갯수
		
		y = y - (line_offset * line_num);
	}

	
	
	///////////////////////////////////////
	// 게이지 바 판 그리기
	sq_AnimationProc(gaugebar_normal_base);
	sq_drawCurrentFrame(gaugebar_normal_base, x, y, false);
	///////////////////////////////////////
	
	local gaugeValue = getDevilGauge(obj);
	local max_gaugeValue = getDevilMaxGaugeValue(obj);
	local rate = gaugeValue.tofloat() / max_gaugeValue.tofloat();
	
	// 게이지 쇼
	local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_devilstrike.nut"); // 데빌스트라이커 어펜디지
	
	if(appendage) {
		local lastValue = appendage.sq_var.get_vector(2); // 지난 게이지 
		
		//print("lastValue:" + lastValue + " gaugeValue:" + gaugeValue);
		
		local CURRENT_HIT_WHITE_FLASH_TIME = 500;
		
		if(lastValue == max_gaugeValue) { // 최대수치와 마지막 게이지가 같다면..흰색으로 
			CURRENT_HIT_WHITE_FLASH_TIME = 600;
		}
		
		if(lastValue > gaugeValue) { //마지막 게이지가 현재 게이지 보다 높다면.. 게이지쇼를 펼쳐야한다..
			//DS_APEND_MAX_GAUGE <- 0 // 최대 악마게이지 수치
			
			local time = appendage.getTimer().Get();

			local whitetrans = sq_GetUniformVelocity(255, 0, time, CURRENT_HIT_WHITE_FLASH_TIME);
			local lv = sq_GetUniformVelocity(lastValue, gaugeValue, time, CURRENT_HIT_WHITE_FLASH_TIME);
			
			local flahbar_rate = lv.tofloat() / max_gaugeValue.tofloat();
			
			if(lastValue == max_gaugeValue) { // 최대수치와 마지막 게이지가 같다면..흰색으로 
				if(time < 200) { // 흰색게이지만 보이도록 200 tick이하에서는 여기서 리턴해버립니다..
					sq_AnimationProc(gauge_normal_flash);
					gauge_normal_flash.setImageRate(flahbar_rate, 1.0);
					
					local rgb = sq_RGB(255,255,255);
					local alpha = sq_ALPHA(whitetrans);
					
					sq_drawCurrentFrameEffect_SIMPLE(gauge_normal_flash, x, y, rgb, alpha);
					
					// 흰색 게이지바도 그려준다..
					sq_AnimationProc(gaugebar_normal_max);
					sq_drawCurrentFrame(gaugebar_normal_max, x, y, false);
					return;
				}
			}
			
			//print("flahbar_rate:" + flahbar_rate);
			// 게이지 그리기
			sq_AnimationProc(gauge_normal_flash);
			gauge_normal_flash.setImageRate(flahbar_rate, 1.0);
			
			local rgb = sq_RGB(255,255,255);
			local alpha = sq_ALPHA(whitetrans);
			
			sq_drawCurrentFrameEffect_SIMPLE(gauge_normal_flash, x, y, rgb, alpha);			
			
			// 게이지 효과 끝
			if(lv == gaugeValue) {
				appendage.sq_var.set_vector(2, gaugeValue);
			}
		}
		
	}
	
	// 일반 게이지를 그리는데 맥스는 좀 다르게 그려줘야합니다..
	if(gaugeValue == max_gaugeValue) {
		// 일반 게이지 그리기
		sq_AnimationProc(gauge_normal_max);	
		gauge_normal_max.setImageRate(rate, 1.0);	
		sq_drawCurrentFrame(gauge_normal_max, x, y, false);
		//
		
		// 맥스치 게이지바도 그려준다..
		sq_AnimationProc(gaugebar_normal_flash);
		sq_drawCurrentFrame(gaugebar_normal_flash, x, y, false);
		//
		
		
		local max_gauge_offset_x = 150;
		// 맥스치 게이지바도 그려준다..
		local size = 8;
		local maxResWidth = 20;		
		local lineMoveLen = (max_gauge_offset_x + (maxResWidth * 2)); // 한라인 움직이는 거리

		local time = (appendage.getTimer().Get() / 20) % lineMoveLen;
		
		//print("x:" + x + " y:" + y);
		local xPos = x;
		local yPos = y - 10;
		setClip(xPos, yPos, xPos + max_gauge_offset_x + 16, yPos + 20);
		
		for(local i=0;i<size;i+=1) {
			// 맥스치 게이지바도 그려준다..
			sq_AnimationProc(gauge_normal_max_f);
			
			//local x1 = max_gauge_offset_x + maxResWidth + (i * 25) - time;
			local x1 = max_gauge_offset_x + maxResWidth + (i * 25) - time;
			local x2 = -maxResWidth + (i * 25) - time;
			
			sq_drawCurrentFrame(gauge_normal_max_f, x + x1, y, false);
			
			sq_drawCurrentFrame(gauge_normal_max_f, x + x2, y, false);
			//
		}
		//		
		releaseClip();
	}
	else {	
		// 일반 게이지 그리기
		sq_AnimationProc(gauge_normal_bar);	
		gauge_normal_bar.setImageRate(rate, 1.0);	
		sq_drawCurrentFrame(gauge_normal_bar, x, y, false);
		//
	}
	
	// 툴팁 출력
	local mouseX = sq_GetMouseXPos();
	local mouseY = sq_GetMouseYPos();
	
	local tipX = x - 20;
	local tipY = y - 15;
	local tipEndX = tipX + 195;
	local tipEndY = tipY + 20;
	if(mouseX > tipX && mouseY > tipY && mouseX < tipEndX && mouseY < tipEndY) {
		sq_drawToolTip(x - 35, y - 13, sq_RGB(255,255,255), 0, 1, 29003, 0, 260, true);
	}
	
}

// 어벤저용 drawcustomui 부분입니다.. 대표적으로 데빌스트라이커 게이지를 그리려고 만들었습니다..
function drawCustomUI_Avenger(obj)
{
	if(!obj) return;
	//if(obj.sq_isMyCharacter()) // 나의 캐릭터가 아니라면 이것을 그려줄 필욘 없을겁니다..
	//if(sq_getMyCharacter() != obj) {
	//	return;
	//}
	
	
	if(!obj.sq_isMyCharacter()) {
		//print("!obj.sq_isMyCharacter()");
		return;
	}	
		
		
	if(!isGrowTypeAvenger(obj)) return; // 어벤져가 아니라면 또한 그려줄 필욘 없을겁니다..
	
	
	
	// 데빌스트라이커 게이지 그리기
	drawDevilStrikeGauge(obj);
}




function getStaticDataIndexDevilGauge(obj, passiveobjectIndex, newState) { // 오브젝트 state 값에 따라 충전될 DevilStrike.skl 스태틱데이타 인덱스를 구해옵니다..
	if(!obj) return -1;
	
	local state = obj.getState();
	local staticIndex = -1;
	if(newState != -1) {
		state = newState;
	}
	
	
	if(state == STATE_THROW) { // 가능한 skill 중에 state_throw로 진행하는 몇개의 스킬이 있는데 이것에 관해서는 수동으로 체크한다..
			//print("\n state == STATE_THROW:" + obj.getThrowIndex());
		 if(obj.getThrowIndex() == SKILL_GRASP_HAND_OF_ANGER) { //GraspHandOfAnger // (분노의 움켜쥠)
			staticIndex = SI_DS_GRASP_HANDOFANGER;
		 }
		 else if(obj.getThrowIndex() == SKILL_CHANGE_HP_TO_MP) { // ChangeHpToMp (고통의 희열)
			staticIndex = SI_DS_CHANGE_HPTOMP;
		 }
		 else if(obj.getThrowIndex() == SKILL_SLOW_HEAL) { // SKILL_SLOW_HEAL
			//SI_DS_SLOW_HEAL <- 20 // 슬로우힐
			staticIndex = SI_DS_SLOW_HEAL;
		 }
		 else if(obj.getThrowIndex() == SKILL_STRIKING) { // SKILL_STRIKING
                //SKILL_STRIKING,						/// 스트라이킹
				//SI_DS_STRIKING <- 22 // 스트라이킹
			staticIndex = SI_DS_STRIKING;
		 }
		 else if(obj.getThrowIndex() == SKILL_CURE) { // SKILL_CURE
				//SKILL_CURE,							/// 큐어 - 파티시전
				//SI_DS_CURE <- 23 // 큐어
			staticIndex = SI_DS_CURE;
		 }
		 else if(obj.getThrowIndex() == SKILL_BLESS) { // SKILL_BLESS
				//SKILL_BLESS,						/// 블레스 - 개인시전
				//SI_DS_BLESS <- 25 // 지혜의 축복
			staticIndex = SI_DS_BLESS;
		 }
		 else if(obj.getThrowIndex() == SKILL_RISING_AREA) { // SKILL_RISING_AREA
				//SKILL_RISING_AREA
				//SI_DS_RISING_AREA <- 27 // 승천진
			staticIndex = SI_DS_RISING_AREA;
		 }				
	}
	else if(state == STATE_ATTACK) {
		if(isAvengerAwakenning(obj)) {
			if(obj.getAttackIndex() == 3) {
				staticIndex = SI_DS_DG_JUMP_ATTACK;
			}
			else {
				staticIndex = SI_DS_DG_ATTACK;
			}
		}
		else {
			staticIndex = SI_DS_ATTACK;
		}
	}
	else if(state == STATE_JUMP_ATTACK) {
		staticIndex = SI_DS_JUMP_ATTACK;
	}
	else if(state == STATE_DASH_ATTACK) {
		if(isAvengerAwakenning(obj)) {
			staticIndex = SI_DS_DG_DASH_ATTACK;
		}
		else {
			staticIndex = SI_DS_DASH_ATTACK;
		}
	}
	else if(state == STATE_HIGH_SPEED_SPLASH) {
		staticIndex = SI_DS_HIGH_SPEED_SLASH;
	}
	else if(state == STATE_EARTHQUAKE || passiveobjectIndex == 24103) { //24103	`Character/Priest/EarthQuakeRock.obj`
		staticIndex = SI_DS_EARTH_QUAKE;
	}
	else if(state == STATE_SPINCUTTER) {
		staticIndex = SI_DS_SPINCUTTER;
	}
	else if(state == STATE_HEDGEHOG) {
		staticIndex = SI_DS_HEDGEHOG;
	}
	else if(state == STATE_FASTMOVE) {
		staticIndex = SI_DS_FASTMOVE;
	}
	else if(state == STATE_EXECUTION) {
		staticIndex = SI_DS_EXECUTION;
	}
	else if(state == STATE_RIPPER) {
		staticIndex = SI_DS_RIPPER;
	}
	else if(state == STATE_POWER_OF_DARKNESS) {
		staticIndex = SI_DS_DARK;
	}
	else if(state == STATE_ANTIAIR_UPPER) {
//SI_DS_ANTIAIR_UPPER <- 18 // 공참타
		staticIndex = SI_DS_ANTIAIR_UPPER;
	}
	else if(state == STATE_SMASHER) {
//SI_DS_SMASHER <- 19// 스매셔
		staticIndex = SI_DS_SMASHER;
	}
	else if(state == STATE_LUCKY_STRAIGHT) {
//SI_DS_LUCKY_STRAIGHT <- 21 // 럭키 스트레이트
		staticIndex = SI_DS_LUCKY_STRAIGHT;
	}
	else if(state == STATE_SECOND_UPPER) {
	// STATE_SECOND_UPPER <- 30 		  //  세컨드어퍼
//SI_DS_SKILL_SECOND_UPPER <- 24 // 세컨드어퍼
		staticIndex = SI_DS_SKILL_SECOND_UPPER;
	}
	else if(state == STATE_LUCKY_STRAIGHT) {
//SI_DS_LUCKY_STRAIGHT <- 21 // 럭키 스트레이트
		staticIndex = SI_DS_LUCKY_STRAIGHT;
	}
	else if(state == STATE_QUAKE_AREA) {
	// STATE_QUAKE_AREA <- 26 		  //  낙봉추
//SI_DS_QUAKE_AREA <- 26 // 낙봉추
		staticIndex = SI_DS_QUAKE_AREA;
	}
	else if(state == STATE_EX_DISASTER) {
	// STATE_EX_DISASTER <- 74 		  //  ex스킬 - 재앙
		staticIndex = SI_DS_DISASTER;
	}
	else if(state == STATE_PANDEMONIUM_EX) {
	// STATE_PANDEMONIUM_EX <- 73 		  //  ex스킬 - 복마전
		staticIndex = SI_DS_PANDEMONI;
	}
	
		//
	
	//print("\n staticIndex:" + staticIndex);
	return staticIndex;

}

// 어벤저 state를 체크하여 충전이 필요한 상태라면 악마게이지를 충전시켜줍니다..
// 패시브오브젝트 인덱스를 추가한 이유는 주인공 state가 이미 다른상태로 변경했을 때 뒤늦게 데미지가 들어갔을 때를 처리하기 위해서 입니다..
function procDevilStrikeGauge(obj, passiveobjectIndex) 
{
	if(!obj) return;
	
	local staticIndex = getStaticDataIndexDevilGauge(obj, passiveobjectIndex, -1); 
	//local passive_attack_staticIndex = getStaticDataIndexDevilGauge(obj, passiveobjectIndex); 
	
	// 현재 캐릭터의 state를 체크하여 리턴되는값이 -1이 아니라면 충전해줘야한다는 의미입니다..
	//print("procDevilStrikeGauge:" + staticIndex);
	if(staticIndex != -1) { // 
		if(!IsAddDevilGauge(obj, staticIndex)) {
			//print(" \n IsAddDevilGauge(obj, staticIndex) == false");
		 return; // 충전플래그를 체크해서 -1이 리턴되면 FALSE를 리턴하는데 이럴땐 충전해서는 안됩니다..
		 }
		
		//print("addDevilGauge staticIndex :" + staticIndex);
		local addValue = sq_GetIntData(obj, SKILL_DEVILSTRIKE, staticIndex);
		//print("addValue:" + addValue + " maxValue:" +  getDevilMaxGaugeValue(obj));
		 addDevilGauge(obj, addValue); // 악마게이지를 각 state별로 맞게 충전합니다
		 		 
		//obj.getVar("devilStrike").set_vector(0, -1); // 충전이 됐으니..이제 충전그만~
		// 이 기술에 대해서는 이제 더이상 충전하면 안되기 때문에 플래그를 -1값으로 세팅
		local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_devilstrike.nut"); // 데빌스트라이커 어펜디지			
		
		if(appendage) {
			//print("appendage.sq_var.set_vector(DS_APEND_ADD_FLAG, -1);");
			appendage.sq_var.set_vector(DS_APEND_ADD_FLAG, -1);
		}
		
	}
}

// 어벤저 attack관련 콜백함수들 입니다..
function onBeforeAttack_Avenger(obj, damager, bounding_box, is_stuck)
{
	
	return 1;
}

function onAttack_Avenger(obj, damager, bounding_box, is_stuck)
{
	if(!obj) return -1;
	//print(" onAttack_Avenger" + isGrowTypeAvenger(obj));
	
	if(!isGrowTypeAvenger(obj)) return -1; // 어벤져가 아니라면 또한 그려줄 필욘 없을겁니다..	
	
	procDevilStrikeGauge(obj, -1); // 어벤저 state를 체크하여 충전이 필요한 상태라면 악마게이지를 충전시켜줍니다..
	
	return 1;
}

function onAfterAttack_Avenger(obj, damager, bounding_box, is_stuck)
{
	return 1;
}


function onAfterAttack_PassiveObject(passiveobj, damager, bounding_box, is_stuck)
{
	return 1;
}


function setEnableCancelSkill_Avenger(obj, isEnable)
{
	if(!obj) return false;
	
	if(!isGrowTypeAvenger(obj)) return false; // 어벤져가 아니라면 프리스트를 곧장 이동하도록
	
	
	if(!obj.isMyControlObject()) return false;


	if(!isEnable) {
		return true;
	}
	
	// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
	//if(sq_isPVPMode())
	{	
		//127 `Priest/CancelFastmove.skl` // 캔슬 고속이동
		obj.setSkillCommandEnable(SKILL_FASTMOVE, isEnable);		
		//128 `Priest/CancelHighSpeedSlash.skl` // 캔슬 고속베기
		obj.setSkillCommandEnable(SKILL_HIGH_SPEED_SLASH, isEnable);		
		//129 `Priest/CancelEarthQuake.skl` // 캔슬 지뢰진
		obj.setSkillCommandEnable(SKILL_EARTH_QUAKE, isEnable);		
		//130 `Priest/CancelHedgehog.skl` // 캔슬 보호의 가시(헤지호그)
		obj.setSkillCommandEnable(SKILL_HEDGEHOG, isEnable);		
		//132 `Priest/CancelSpincutter.skl`  // 캔슬 스핀커터
		obj.setSkillCommandEnable(SKILL_SPINCUTTER, isEnable);		
		//170	`Priest/CancelBackStep.skl`		// 캔슬 백스텝
		
//133 	`Priest/PandemoniumEx.skl`		// 특성 : 복마전
//SKILL_PANDEMONIUM_EX			<- 133 // 복마전 
		obj.setSkillCommandEnable(SKILL_PANDEMONIUM_EX, isEnable);		
//134 	`Priest/DisasterEx.skl` 		// 특성 : 재앙
//SKILL_EX_DISASTER			<- 134	// ex스킬 - 재앙
		obj.setSkillCommandEnable(SKILL_EX_DISASTER, isEnable);		
		//
	}
	// 캔슬기 삭제 작업입니다. (2012.04.12)
	return true;
	
	//local size = 5;
	local size = 4;
	local cancel_skill_l =[];
	local skill_l =[];
	cancel_skill_l.resize(size);
	skill_l.resize(size);
	
	cancel_skill_l[0] = SKILL_CANCEL_FASTMOVE;
	cancel_skill_l[1] = SKILL_CANCEL_HIGH_SPEED_SLASH;
	cancel_skill_l[2] = SKILL_CANCEL_EARTH_QUAKE;
	cancel_skill_l[3] = SKILL_CANCEL_HEDGEHOG;
	//cancel_skill_l[4] = SKILL_CANCEL_SPINCUTTER;

	skill_l[0] = SKILL_FASTMOVE;
	skill_l[1] = SKILL_HIGH_SPEED_SLASH;
	skill_l[2] = SKILL_EARTH_QUAKE;
	skill_l[3] = SKILL_HEDGEHOG;
	//skill_l[4] = SKILL_SPINCUTTER;

	for(local i=0;i<size;i+=1) {
		// 파라미터로 넘겨진 키 인덱스와, 공격방법이 가능한지 체크하여 통과하면 패시브오브젝트를 만들어 등록합니다..
		local level = sq_GetSkillLevel(obj, cancel_skill_l[i]);
		local bRet = false;
		
		if(level > 0) {
			if(isEnable) {
				// 여기에서 둠스가디언인지 체크해봐야한다.. 둠스가디언 변신상태에서 일반 캔슬기가 나가면 곤란하지 않는가..
				if(!isAvengerAwakenning(obj))
					bRet = true;
				else {
					return false;
				}
			}
		}
		
		//print("\n cancel_skill_l[i]:" + cancel_skill_l[i] + " level:" + level + " bRet:" + bRet + " skill_l[i]:" + skill_l[i]);
		obj.setSkillCommandEnable(skill_l[i], bRet);
	}
	
	
	return true;
}

function playDashAttackSound_Avenger(obj) // 대쉬사운드를 세팅하는 오버라이딩된 함수입니다..
{
	if(!obj) return 0;
	if(!isGrowTypeAvenger(obj)) return 0; // 어벤져가 아니라면 또한 그려줄 필욘 없을겁니다..
	
	if(isAvengerAwakenning(obj)) return 1; // 각성일땐 따로 대쉬사운드 세팅합니다..
	
	return 0;
}



function setActiveStatus_Avenger(obj, activeStatus, power)
{
	if(!obj) return 0;
	if(isAvengerAwakenning(obj))
	{
		return 0; // 각성일땐 따로 상태이상을 막아버립니다..
	}
	
	return 1;
}

// setcurrentanimation이 된 후에 이펙트투명도 과련 조절을 위해 모든 setcurrentanimation후에 콘트롤 할 수 있는 squirrel function호출을 합니다..
function setCurrentAnimation_Avenger(obj, animation) 
{
	if(!obj) return;
	if(!animation) return;
	
	if(isAvengerAwakenning(obj)) { // 각성 둠스가디언 변신 후라면 setcurrentanimation 되는 모든 animation은 투명도 조절관련 플래그를 오프시킵니다..
		if(animation) {
			animation.setNeverApplyAnotherPlayersEffectAlphaRate(false);
			animation.setIsApplyAnotherPlayersEffectAlphaRate(false);
		}
	}
}

//던전을 새로 시작할 때 호출되는 리셋 함수
function resetDungeonStart_Avenger(obj, moduleType, resetReason, isDeadTower, isResetSkillUserCount)
{
	if(!obj) return -1;	
	
	local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_devilstrike.nut"); // 데빌스트라이커 어펜디지
	
	if(appendage) {
		if(appendage.sq_var.size_vector() == 5) { // 새로 입장하는것이라면 악마게이지 수치를 리셋합니다..
			appendage.sq_var.set_vector(1, 0); // 현재 악마게이지 수치 인덱스 1
		}
	}
	
	local awakening_appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_awakening.nut");
	
	if(awakening_appendage) {
		if(isAvengerAwakenning(obj)) {
			awakening_appendage.setValid(false);
			awakening_appendage.sq_var.set_vector(I_AVENGER_AWAKENING_VALID, 0);
			obj.setObjectHeight(-1);
		}
	}
	
	return 1;
	
}

function takingAwakenSkillBack_Avenger(obj)
{	
	if(!obj) return false;
	if(!isGrowTypeAvenger(obj)) // 어벤저가 아닌 경우 무조건 flowpriest로
		return false;
		
	local state = obj.getState();
	
	print("\n takingAwakenSkillBack:" + state + " isAvengerAwakenning(obj):" + isAvengerAwakenning(obj));
	
	if(isAvengerAwakenning(obj) || state == STATE_AVENGER_AWAKENING) { // 각성 변신 - 둠스가디언 상태라면 혹은 // 변신 중일 상태일때도 이곳에 들어가야합니다..
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(0); // substate세팅
		obj.sq_addSetStatePacket(STATE_AWAKENING_TURN_OFF, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	
	if(obj.getVar("takingAwakenSkillBack").size_vector() == 0) {
		obj.getVar("takingAwakenSkillBack").push_vector(0);
		obj.getVar("takingAwakenSkillBack").push_vector(0);
	}
	
	obj.getVar("takingAwakenSkillBack").set_vector(0, 1);
	
	return true;
}