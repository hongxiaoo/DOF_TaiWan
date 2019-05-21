

STATE_SLOW_HEAL				<- 0 /// 천천히 회복중
STATE_REBIRTH_READY_DOWN	<- 1 /// HP 0이 됨. 그러나 아직 DOWN 은 안됐음
STATE_REBIRTH_DOWN			<- 2 /// HP 0이 되고 다운됐음.
STATE_REBIRTH_DELAY			<- 3 /// 부활 딜레이
STATE_DIEHARD_DIE			<- 4 // 다이

REBIRTH_STATE_NONE			<- 0
REBIRTH_STATE_ANGEL_DOWN	<- 1
REBIRTH_STATE_EFFECT		<- 2
REBIRTH_STATE_END			<- 3

VECTOR_I_STATE					<- 0
VECTOR_I_FLAG					<- 1
VECTOR_I_REBIRTH_STATE			<- 2
VECTOR_I_REBIRTH_TIME			<- 3


GHOST_TIME <- 2000
ANGEL_DOWN_TIME <- 1000
DOWN_PAUSE_TIME <- 100


function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_atmage_diehard")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_atmage_diehard")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_atmage_diehard")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_atmage_diehard")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_atmage_diehard")
	appendage.sq_AddFunctionName("onSetHp", "onSetHp_appendage_atmage_diehard")
}


function sq_AddEffect(appendage)
{
}

function pushSlowHeal(appendage)
{
	if(!appendage)
	{
		return;
	}
	
	local parentObj = appendage.getParent();
	
	local sqrChr = sq_GetCNRDObjectToSQRCharacter(parentObj);
	
	if(sqrChr)
	{
		local moduleType = sq_GetCurrentModuleType();
	
		local recoverTime = sq_GetIntData(sqrChr, SKILL_DIEHARD, SKL_STATIC_INT_IDX_2);  // 일반던전
		
		//print(" moduleType:" + moduleType);
		
		local stage = sq_GetGlobaludpModuleStage();
		
		local dungeon = sq_GetDungeonByStage(stage);
		
		local isDimensionDungeon = sq_IsDimensionDungeon(dungeon); // 이계던전인지
		local isDespairTower = sq_IsDespairTower(dungeon); // 절망의 탑인지
		local isAncientDungeon = sq_IsAncientDungeon(dungeon); // 고대던전인지
		
		if(isDimensionDungeon)
		{	// 이계던전이라면..
			//print( " DimensionDungeon");
			recoverTime = sq_GetIntData(sqrChr, SKILL_DIEHARD, SKL_STATIC_INT_IDX_3);
		}
		else if(isDespairTower)
		{ // 절망의 탑이라면..
			//print( " DespairTower");
			recoverTime = sq_GetIntData(sqrChr, SKILL_DIEHARD, SKL_STATIC_INT_IDX_4);
		}
		else if(isAncientDungeon)
		{// 고대던젼
			recoverTime = sq_GetIntData(sqrChr, SKILL_DIEHARD, SKL_LVL_COLUMN_IDX_6);
		}
		else
		{		
			if(moduleType == MODULE_TYPE_WARROOM)
			{ // 전쟁지역
				//print( " WARROOM");
				recoverTime = sq_GetIntData(sqrChr, SKILL_DIEHARD, SKL_STATIC_INT_IDX_5);
			}
			else if(moduleType == MODULE_TYPE_DEAD_TOWER)
			{ // 사탑
				//print( " DEAD_TOWER");
				recoverTime = sq_GetIntData(sqrChr, SKILL_DIEHARD, SKL_STATIC_INT_IDX_4); 
			}
		}
		
		// 상태이상이 걸렸다면 상태이상을 풀어줍니다. 중독, 출혈
		if(parentObj.isMyControlObject())
		{
			sq_ReleaseActiveStatus(parentObj, ACTIVESTATUS_POISON);
			sq_ReleaseActiveStatus(parentObj, ACTIVESTATUS_BLEEDING);
		}
		
		//print(" recoverTime:" + recoverTime);	
		sq_SendMessage(parentObj, OBJECT_MESSAGE_GHOST, 1, 0);
		sq_PostDelayedMessage(parentObj, OBJECT_MESSAGE_GHOST, 0, 0, 8000);
		
		appendage.getVar("diehard").set_vector(0, 1); // 불사를 한번 일어났었는지 체크하는 플래그입니다.
		local t = appendage.sq_var.get_ct_vector(0);
		
		if(t)
		{
			t.Reset();
			t.Start(10000,0);
		}
		
		
		local healAppendage = CNSquirrelAppendage.sq_AppendAppendage(sqrChr, sqrChr, SKILL_DIEHARD, 
			true, "Character/ATMage/DieHard/ap_ATMage_DieHardSlowHeal.nut", false);
		
		if(healAppendage)
		{
			local skillLevel = sqrChr.sq_GetSkillLevel(SKILL_DIEHARD);
			healAppendage.setAppendCauseSkill(BUFF_CAUSE_SKILL, sq_getJob(sqrChr), SKILL_DIEHARD, skillLevel);		
		
			print( " recoverTime:" + recoverTime);
			healAppendage.sq_SetValidTime(recoverTime);
			// 여기서 append 작업		
			CNSquirrelAppendage.sq_Append(healAppendage, sqrChr, sqrChr);
			
			//
			healAppendage.getVar("changehp").clear_vector();
			healAppendage.getVar("changehp").push_vector(sqrChr.getHpMax());
			healAppendage.getVar("changehp").push_vector(sqrChr.getMpMax());
			//print(" recoverTime:" + recoverTime);
			healAppendage.getVar("changehp").push_vector(recoverTime);
			healAppendage.getVar("changehp").push_vector(0);
			healAppendage.getVar("changehp").push_vector(0);

			//local change_appendage = healAppendage.sq_GetCNChangeHp("changehp");

			//if(!change_appendage)
			{
				//2. 일단던전 회복시간 (1/1000초)
				//3. 이계던전 회복시간 (1/1000초)
				//4. 탑 회복시간 (1/1000초)
				//5. 전쟁지역 회복시간 (1/1000초)
				// MODULE_TYPE_WARROOM			// 전쟁지역
				// MODULE_TYPE_MAIN_GAME 		// 일반던전(이계 포함)
				// MODULE_TYPE_PVP 				// 결장
				// MODULE_TYPE_FAIR_PVP 		// 공결
				
				//local recoverHp_ = sqrChr.getHpMax();
				
				//4000 //2. 일단던전 회복시간 (1/1000초)
				//4000 //3. 이계던전 회복시간 (1/1000초)
				//4000 //4. 탑 회복시간 (1/1000초)
				//4000 //5. 전쟁지역 회복시간 (1/1000초)					
				
				//change_appendage = healAppendage.sq_AddCNChangeHp("changehp",parentObj, parentObj, 0, 
				//recoverHp_.tofloat(), recoverTime);
			}
		}
	}

}




function proc_appendage_atmage_diehard(appendage)
{
	if(!appendage) {
		return;
	}
	
	local parentObj = appendage.getParent();
	if(!parentObj)
	{
		appendage.setValid(false);
		return;
	}
	
	local state_ = appendage.sq_var.get_vector(VECTOR_I_STATE);	
	
	
	if(state_ == STATE_SLOW_HEAL)
	{
		if(parentObj.isGhostMode())
		{ // 무적지속 상태라면..
			if (parentObj.getState() != STATE_DIEHARD)
			{
				if(appendage.getVar("diehard").get_vector(0) == 1)
				{
					local t = appendage.sq_var.get_ct_vector(0);
					
					local ghostCurrentTime = t.Get();
					
					if(ghostCurrentTime > 8000)
					{
						sq_SendMessage(parentObj, OBJECT_MESSAGE_GHOST, 0, 0);
						appendage.getVar("diehard").set_vector(0, 0);
					}
				}
			}
		}
		return;	
	}
	
	
	local currentT = appendage.getTimer().Get();
	local rebirthTime_ = appendage.sq_var.get_vector(VECTOR_I_REBIRTH_TIME);
	
	
	//print(" proc_appendage_atmage_diehard Ln:" + 163);
	//////////////////////////////////////////////////////////////////////////////
	if (state_ == STATE_REBIRTH_READY_DOWN)
	{
		//	다운 대기중
		////print(" state_ == STATE_REBIRTH_READY_DOWN");
		if (parentObj.getState() == STATE_DIEHARD)
		{
			appendage.sq_var.set_vector(VECTOR_I_STATE, STATE_REBIRTH_DOWN);
			// 날아가는 동안 다른 요소에 의해서 방해받지않도록 무적시간 처리
		}
		else if (parentObj.getSendState() != STATE_DIEHARD && 
			parentObj.getSendState() != STATE_HOLD && parentObj.getState() != STATE_HOLD &&
			parentObj.getSendState() != STATE_DOWN && parentObj.getState() != STATE_DOWN &&
			parentObj.getSendState() != STATE_DAMAGE && parentObj.getState() != STATE_DAMAGE
		)
		{
			if (parentObj.isMyControlObject())
			{
				local pIntVec = sq_GetGlobalIntVector();
				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, SUB_STATE_DIEHARD_0);
				parentObj.addSetStatePacket(STATE_DIEHARD, pIntVec, STATE_PRIORITY_FORCE, false, "");
				
				parentObj.flushSetStatePacket();
			}
		}
		else
		{
			////print(" it is hold died");
			////print(" state_hold");
		}
	}
	else if (state_ == STATE_REBIRTH_DOWN)
	{
		//print(" proc_appendage_atmage_diehard Ln:" + 201);	
		////print(" state_ == STATE_REBIRTH_DOWN");
		//	다운 상태
		if (parentObj.getState() == STATE_DIEHARD)
		{
			local sqrChr = sq_GetCNRDObjectToSQRCharacter(parentObj);
			
			if(sqrChr)
			{
				if(sqrChr.getSkillSubState() == SUB_STATE_DIEHARD_1)
				{
					//	다운에서 회복됐다면 : 경직 처리
					//	무적시간 처리
					//	일정시간 경직
					//sq_SetPause(parentObj, PAUSETYPE_OBJECT, DOWN_PAUSE_TIME);
					
					
					//	부활 시간 저장
					local rebirthTime = appendage.getTimer().Get() + GHOST_TIME;
					appendage.sq_var.set_vector(VECTOR_I_REBIRTH_TIME, rebirthTime);
					
					appendage.sq_var.set_vector(VECTOR_I_STATE, STATE_REBIRTH_DELAY);
					appendage.sq_var.set_vector(VECTOR_I_REBIRTH_STATE, REBIRTH_STATE_END);
				}
			}
		}
	}
	else if (state_ == STATE_REBIRTH_DELAY)
	{
		//	부활 딜레이
		if (currentT >= rebirthTime_)
		{
			//	HP 회복
			//	한번 회복됐다면 바로 종료
			
			print(" go rebirth");
			appendage.sq_var.set_vector(VECTOR_I_STATE, STATE_SLOW_HEAL);
			appendage.sq_var.set_vector(VECTOR_I_REBIRTH_STATE, STATE_SLOW_HEAL); // state
			
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////
	
	
}


function onStart_appendage_atmage_diehard(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();		


	appendage.sq_var.clear_timer_vector();
	appendage.sq_var.push_timer_vector();
	appendage.sq_var.push_timer_vector();
	
	//VECTOR_I_STATE					<- 0
	//VECTOR_I_REBIRTH_STATE			<- 1
	//VECTOR_I_REBIRTH_TIME			<- 2
	appendage.sq_var.clear_vector();
	appendage.sq_var.push_vector(STATE_SLOW_HEAL); // state
	appendage.sq_var.push_vector(STATE_SLOW_HEAL); // state
	appendage.sq_var.push_vector(0); // state
	appendage.sq_var.push_vector(0); // state
			
	local t = appendage.sq_var.get_timer_vector(0);
	t.setParameter(400, -1);
	t.resetInstant(0);

	local t2 = appendage.sq_var.get_timer_vector(1);
	t2.setParameter(500, -1);
	t2.resetInstant(0);	
	
	appendage.sq_var.clear_ct_vector();
	appendage.sq_var.push_ct_vector();	
	
	local time = appendage.sq_var.get_ct_vector(0);
	time.Reset();
	time.Start(10000,0);
	
	appendage.getVar("diehard").clear_vector();
	appendage.getVar("diehard").push_vector(0); // 불사를 한번 일어났었는지 체크하는 플래그입니다.
	
	local sqrObj = sq_GetCNRDObjectToSQRCharacter(obj);
	
	if(sqrObj)
	{
	}
}


function prepareDraw_appendage_atmage_diehard(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}


function onSetHp_appendage_atmage_diehard(appendage, hp, attacker)
{
	if(!appendage)
		return hp;
	
		
	local obj = appendage.getParent();
	
	if(!obj)
		return hp;
	
	local org_hp = -1;

	
	if (hp <= 0)
	{
		// 던전팀 요청사항 12.03.16
		// 불사를 무시하고 단방에 죽어버려야 하는 순간이 있다. 이것에 대한 처리를 위해
		// attacker (공격자)의 getCurrentAttackInfo 구조체에 
		// bool					isIgnoreDieHard_;						/// 불사 패시브 스킬 무시 여부 (피격시 바로 즉사)
		// 변수를 추가하였다.
		// 이것이 true라면.. 바로 죽어야할것
		if(attacker)
		{
			local attackInfo = sq_GetCurrentAttackInfo(attacker);
			
			if(attackInfo)
			{
				if(attackInfo.isIgnoreDieHard_)
					return 0;
			}
		}

		local isRelayTimeOut = sq_isSendTimeOutPacket(); // 결장 릴레이 타임아웃이라면 바로 죽어야 합니다.

		// 결장 릴레이 타임아웃이라면 바로 죽어야 합니다.
		if (isRelayTimeOut)
			return 0;




		
		//	HP를 1로 고정하고 STATE 변화
		local sqrChr = sq_GetCNRDObjectToSQRCharacter(obj);
		
		if(!sqrChr)
			return hp;
		
		
		if(!sq_IsInBattle())
		{ // 전투중이 아니라면
			return hp;
		}
		
		
		local state_ = appendage.sq_var.get_vector(VECTOR_I_STATE);	
		
		if(!CNSquirrelAppendage.sq_IsAppendAppendage(obj, "Character/ATMage/DieHard/ap_ATMage_DieHardSlowHeal.nut")) //
		{
			//1. 사망시 초기 회복되는 HP비율(%)
			local recoverHpRate = sq_GetIntData(sqrChr, SKILL_DIEHARD, SKL_STATIC_INT_IDX_1); 
			local maxHp = obj.getHpMax();
			
			local currentHp = maxHp.tofloat() * (recoverHpRate.tofloat() / 100);
			
			//print(" hp:" + currentHp);
			org_hp = currentHp.tointeger();
			
			pushSlowHeal(appendage);
			
			appendage.sq_var.set_vector(VECTOR_I_STATE, STATE_REBIRTH_READY_DOWN);
			
			print(" convert hp:" + org_hp);
		}
		else
		{
			if(state_ == STATE_REBIRTH_READY_DOWN || sqrChr.getState() == STATE_DIEHARD)
			{
				//print( " state_:" + state_ + " sqrChr.getState():" + sqrChr.getState() + " org_hp:" + org_hp);
				org_hp = 1;
			}
		} 
	}
	
	//print(" hp:" + org_hp);
	return org_hp;
}





function onEnd_appendage_atmage_diehard(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();		
	
	local sqrObj = sq_GetCNRDObjectToSQRCharacter(obj);
	
	if(sqrObj)
	{
	}
	
}

// 어벤져 각성 변신의 끝부분
function isEnd_appendage_atmage_diehard(appendage)
{
	if(!appendage)
		return false;
		
	local T = appendage.getTimer().Get();	
	
	return false;
}