
function destroyObject(obj)
{
	local objListSize = obj.getVar().get_obj_vector_size();	
	for(local i =0;i<objListSize;++i)
	{				
		local vObj = obj.getVar().get_obj_vector(i);
		if(vObj == null)
			continue;
			
		vObj.setValid(false);
	}
	
	obj.getVar().clear_obj_vector();
	
}

function destroyObjectByVar(obj, varStr)
{
	local objListSize = obj.getVar(varStr).get_obj_vector_size();	
	for(local i =0;i<objListSize;++i)
	{				
		local vObj = obj.getVar(varStr).get_obj_vector(i);
		if(vObj == null)
			continue;
			
		vObj.setValid(false);
	}
	
	obj.getVar(varStr).clear_obj_vector();
	
}


function getAngle(xPos1, yPos1, xPos2, yPos2)
{
	// 두 지점간의 거리를 구한다
	local xDistance = (xPos2 - xPos1);
	local yDistance = (yPos2 - yPos1);

	print(" xDistance:" + xDistance + " yDistance:" + yDistance);
	
	xDistance = sq_Abs(xDistance);
	yDistance = sq_Abs(yDistance);

	// 아크 탄젠트로 각도를 구한다
	local radian = sq_Atan2(yDistance.tofloat(), xDistance.tofloat());
	
	// 라디안을 degree 로 변환
	local angle = sq_ToDegree(radian);
	// 0 ~ 360 사이의 값을 구하기 위함
	// 360 을 더하는 이유는 360보다 낮은 값을 잉여연산을 하면
	// 0 이 나오므로
	print(" radian:" + radian + " angle:" + angle);
	return (angle + 360) % 360;
}

function getObjectAngle(orgObj, dstObj)
{
	if(!orgObj || !dstObj)
		return 9999.0;
		
	return getAngle(orgObj.getXPos(), orgObj.getYPos(), dstObj.getXPos(), dstObj.getYPos());
}



function isInFrontObject(orgObj, dstObj)
{ // 적이 내 앞에 있는지 체크하는 함수 입니다.
	if(orgObj.getDirection() == ENUM_DIRECTION_RIGHT)
	{
		if(orgObj.getXPos() < dstObj.getXPos())
			return true;
	}
	else
	{
		if(orgObj.getXPos() > dstObj.getXPos())
			return true;
	}
	
	return false;
}


// 거리와 각도로 타겟을 찾아내어 리턴하는 함수입니다.
function findAngleTarget(obj, distance, angle, targetMaxHeight)
{
	if(!obj)
		return null;
		
	local objectManager = obj.getObjectManager();
	

	if (objectManager == null)
		return null;

	local minDistance = 0;
	local target = null;
	

	for (local i = 0; i < objectManager.getCollisionObjectNumber(); i+=1)
	{
		local object = objectManager.getCollisionObject(i);
		if (object && obj.isEnemy(object) && object.isInDamagableState(obj) && object.isObjectType(OBJECTTYPE_ACTIVE) &&
			isInFrontObject(obj, object) && object.getZPos() <= targetMaxHeight)
		{
			local activeObj = sq_GetCNRDObjectToActiveObject(object);
			//	영역 내에서 가장 가까운 적을 고른다
			
			if(!activeObj.isDead())
			{
				//local testAngle = CNRDObject.getAngle(0, 0, 10, 10, false);
				
				print( " angle:" + getObjectAngle(obj, object));
				if(sq_GetDistanceObject(obj, object, false) < distance && getObjectAngle(obj, object) < angle)
				{
					if (target == null || sq_GetDistanceObject(obj, object, false) < minDistance)
					{
						target = activeObj;
						minDistance = sq_GetDistanceObject(obj, object, false);
					}
				}
			}
		}
	}

	return target;
}

// 요청한 벡터 getvar 오브젝트 리스트안에 같은 오브젝트가 있는지 체크하는 함수입니다.
// orgObj : 비교할 object입니다.
// sq_var get_obj_vector_size 비교할 리스트들
function isSameObjectBySqVar(orgObj, sq_var)
{
	if(!orgObj || !sq_var)
		return false;
	
	local i;
	local object_num = sq_var.get_obj_vector_size();
	
	for(i = 0; i < object_num; i++)
	{ // 빔 오브젝트 애니메이션을 사라지도록 하는 애니메이션으로 모두 교체한다..
		local dstObj = sq_var.get_obj_vector(i);
		
		local isSame = isSameObject(orgObj, dstObj);
		
		if(isSame) // 중복되는 것이 있다면..
			return true;
	}
	
	return false;
	
}

function getBossTarget(obj, firstTargetXStartRange, firstTargetXEndRange, firstTargetYRange, targetMaxHeight, exceptSqVar)
{
	if(!obj)
		return null;
		
	local objectManager = obj.getObjectManager();
	

	if (objectManager == null)
		return null;

	//local minDistance = 0;
	local target = null;
	

	for (local i = 0; i < objectManager.getCollisionObjectNumber(); i+=1)
	{
		local object = objectManager.getCollisionObject(i);
		if (object && obj.isEnemy(object) && object.isInDamagableState(obj) && object.isObjectType(OBJECTTYPE_ACTIVE) &&
			isInFrontObject(obj, object) && object.getZPos() <= targetMaxHeight )
		{
			if(sq_IsinMapArea(obj, object, firstTargetXStartRange, firstTargetXEndRange, firstTargetYRange))
			{
				local activeObj = sq_GetCNRDObjectToActiveObject(object);
				
				if(!activeObj.isDead())
				{ // 죽지 않은
					if(activeObj.isBoss())
					{ // 보스
						local isExist = isSameObjectBySqVar(object, exceptSqVar);
						
						if(!isExist || target == null)
						{
							target = activeObj;
						}
					}
				}
			}
		}
	}

	return target;

}

function getPriorityTarget(obj, firstTargetXStartRange, firstTargetXEndRange, firstTargetYRange, targetMaxHeight, exceptSqVar, isInFront)
{
	if(!obj)
		return null;
		
	local objectManager = obj.getObjectManager();
	

	if (objectManager == null)
		return null;

	//local minDistance = 0;
	local target = null;
	

	for (local i = 0; i < objectManager.getCollisionObjectNumber(); i+=1)
	{
		local object = objectManager.getCollisionObject(i);
		if (object && obj.isEnemy(object) && object.isInDamagableState(obj) && object.isObjectType(OBJECTTYPE_ACTIVE) &&
			object.getZPos() <= targetMaxHeight )
		{
			if(isInFront == true)
			{
				if(isInFrontObject(obj, object) == false)
				{
					continue;
				}
			}
			if(sq_IsinMapArea(obj, object, firstTargetXStartRange, firstTargetXEndRange, firstTargetYRange))
			{
				local activeObj = sq_GetCNRDObjectToActiveObject(object);
				
				if(!activeObj.isDead())
				{ // 죽지 않은
					local isExist = isSameObjectBySqVar(object, exceptSqVar);
					
					if(activeObj.isBoss())
					{
						if(target == null)
						{
							target = activeObj;
							
							if(!isExist)
								return target;
						}
					}
					
					if(activeObj.isSuperChampion())
					{ // 보스
						if(target == null || !isExist)
						{
							target = activeObj;
							
							if(!isExist)
								return target;
						}
					}
					
					if(activeObj.isCommonChampion())
					{
						if(target == null || !isExist)
						{
							target = activeObj;
							
							if(!isExist)
								return target;
						}
					}
					
					if(activeObj.isChampion())
					{
						if(target == null || !isExist)
						{
							target = activeObj;
							
							if(!isExist)
								return target;
						}
					}
					
					if(target == null || !isExist)
					{
						target = activeObj;
						
						if(!isExist)
							return target;
					}
				}
			}
		}
	}

	return target;

}



function createPaticleMap(obj, filename, x, y, z)
{
	local particleCreater = obj.getVar().GetparticleCreaterMap(filename, filename, obj);
		
	particleCreater.Restart(0);
	particleCreater.SetPos(x, y, z);
	sq_AddParticleObject(obj, particleCreater);
}

function initGetVarTimer(obj, maxTimerNum, eventTerm, eventMaxCount)
{
	if(maxTimerNum <= 0)
		return;
		
	local sq_var = obj.getVar();
	
	sq_var.clear_timer_vector();
	
	for (local i = 0;i < maxTimerNum; i+=1)
	{
		sq_var.push_timer_vector();
	}
	
	for (local i = 0;i < maxTimerNum; i+=1)
	{
		local t = sq_var.get_timer_vector(i);
		t.setParameter(eventTerm, eventMaxCount);
		t.resetInstant(i);
	}

}


function procParticleCreaterMap(obj, currentT, filename, x, y, z)
{
	local t = obj.getVar().get_timer_vector(0);
	
	if(!t)
		return;
	
	if(t.isOnEvent(currentT) == true)
	{
		local particleCreater = obj.getVar().GetparticleCreaterMap(filename, filename, obj);
			
		particleCreater.Restart(0);
		particleCreater.SetPos(x, y, z);	
		
		sq_AddParticleObject(obj, particleCreater);
	}
}


function createAnimationPooledObject(obj, aniFilename, isAutoDestroy, x, y, z)
{
	local ani = sq_CreateAnimation("",aniFilename);
	local pooledObj = sq_CreatePooledObject(ani,isAutoDestroy);
	
	pooledObj.setCurrentPos(x,y,z);
	sq_SetCurrentDirection(pooledObj, obj.getDirection());
	
	sq_AddObject(obj, pooledObj, OBJECTTYPE_DRAWONLY, false);
	
	return pooledObj;
}

function createAnimationImageRatePooledObject(obj, aniFilename, isAutoDestroy, widthRate, heightRate, x, y, z)
{
	local ani = sq_CreateAnimation("",aniFilename);
	
	if(!ani)
		return null;
	
	ani.setImageRateFromOriginal(widthRate, heightRate);
	
	local pooledObj = sq_CreatePooledObject(ani,isAutoDestroy);
	
	pooledObj.setCurrentPos(x,y,z);
	sq_SetCurrentDirection(pooledObj, obj.getDirection());
	
	sq_AddObject(obj, pooledObj, OBJECTTYPE_DRAWONLY, false);
	
	return pooledObj;
}




function procSkill_IceRoad(obj)
{
	local appendage = obj.GetSquirrelAppendage("Character/ATMage/IceRoad/ap_ATMage_IceRoad.nut");
	
	if(appendage) {
		local isvalid = appendage.isValid();
		if(isvalid) {
			local currentT = appendage.getTimer().Get();
			local t = appendage.sq_var.get_timer_vector(0);
			local t2 = appendage.sq_var.get_timer_vector(1); // 얼음조각을 만드는것과 별도로 엠피소모는 다른타이머로 돌아가서 mp소모를 시킵니다.
			
			if (t2.isOnEvent(currentT) == true)
			{
				local skill = sq_GetSkill(obj, SKILL_ICEROAD);
				if(skill)
				{
					local skill_level = obj.sq_GetSkillLevel(SKILL_ICEROAD);
					local spendMp = obj.sq_GetLevelData(SKILL_ICEROAD, SKL_LV_0, skill_level); // 0.시간당MP 소모량
					if (spendMp > obj.getMp())
					{
						appendage.setValid(false);
						skill.setSealActiveFunction(true);
						return;
					}
					else
					{
						// MP가 충분하다면 얼음의 길 한조각을 만든다..
						print( " spendMp:" + spendMp);
						obj.sendSetMpPacket(obj.getMp() - spendMp);
					}
				
				}
			}
			
			if (t.getEventTerm() == -1)
				return;
			
			if (t.isOnEvent(currentT) == true)
			{
				if(obj.isMyControlObject())
				{
					if(obj.getZPos() == 0)
					{
						local skill_level = sq_GetSkillLevel(obj, SKILL_ICEROAD);
						local change_time = sq_GetLevelData(obj, SKILL_ICEROAD, SKL_LV_1, skill_level); // 지속시간
						local rate = sq_GetLevelData(obj, SKILL_ICEROAD, SKL_LV_3, skill_level); // 이속 확율
						local movSpd = sq_GetLevelData(obj, SKILL_ICEROAD, SKL_LV_2, skill_level); // 
					
						sq_BinaryStartWrite();
						sq_BinaryWriteDword(change_time);	// 시간
						sq_BinaryWriteDword(rate);			// 확율
						sq_BinaryWriteDword(movSpd);		// 감소치 
						
						// 아이스 로드 특성 패시브 스킬을 배웠다면 맞은 적이 빙결 상태이상에 걸린다.
						local skillLevel = sq_GetSkillLevel(obj, SKILL_ICEROAD_EX);
						sq_BinaryWriteWord(skillLevel);
						
						if (skillLevel > 0)
						{
							local prob = sq_GetLevelData(obj, SKILL_ICEROAD_EX, 4, skillLevel) / 10.0;// 상태이상 빙결의 확률
							local asLevel = sq_GetLevelData(obj, SKILL_ICEROAD_EX, 5, skillLevel);	// 상태이상 빙결의 레벨
							local validTime = sq_GetLevelData(obj, SKILL_ICEROAD_EX, 6, skillLevel);	// 상태이상 빙결의 시간
							sq_BinaryWriteFloat(prob.tofloat());	// 확률
							sq_BinaryWriteWord(asLevel);			// 레벨
							sq_BinaryWriteDword(validTime);			// 시간
						}
						
						sq_SendCreatePassiveObjectPacket(obj, 24243, 0, 0, 0, 0, obj.getDirection());
					}
				}
			}
		}
	}	
}

function playMoveSound_ATMage(obj)
{
	//obj.sq_PlaySound("R_ICE_WALK");
	
	if(!obj)
		return;
	
	local result = CNSquirrelAppendage.sq_IsAppendAppendage(obj, "Character/ATMage/IceRoad/ap_ATMage_IceRoad.nut");

	if (result == true) // 아이스로드를 켜놨을 땐 발자국소리가 바뀝니다.
	{
		obj.sq_PlaySound("R_ICE_WALK_LOOP", SOUND_ID_MOVE);
	}
	else 
	{
		obj.sq_PlayMoveSound();
	}
}

function procDash_ATMage(obj)
{
	if(!obj)
		return;
	
	local ani = sq_GetCurrentAnimation(obj);
	
	if(!ani)
		return;
		
	local isFlag = obj.sq_IsKeyFrameFlag(ani, 1);
	
	
	local result = CNSquirrelAppendage.sq_IsAppendAppendage(obj, "Character/ATMage/IceRoad/ap_ATMage_IceRoad.nut");

	if (result == true) // 아이스로드를 켜놨을 땐 발자국소리가 바뀝니다.
	{
		
		if(isFlag)
		{
			obj.sq_PlaySound("R_ICE_WALK");
		}
		
		obj.sq_ClearKeyFrameFlag(ani);
	}
	else
	{
		//print(" procDash");
		
		if (isFlag)
		{
			local stage = sq_GetGlobaludpModuleStage();
			if(!stage)
				return;
			
			local dungeon = sq_GetDungeonByStage(stage);
			
			if(!dungeon)
				return;
				
			local dungeonIndex = sq_GetDuegonIndex(dungeon);			
			local mapIndex = sq_GetMapIndex(stage);

			//설산쪽 던전의 경우 40번, 설산의 추적 PVP맵의 경우 50019번.
			if (dungeonIndex == 40 || mapIndex == 50019)
			{
				obj.sq_PlaySound("R_RUN_SNOW");
			}
			else
			{
				local weight = sq_GetObjectWeight(obj);
				if (sq_GetShadowTypeByAnimation() != 0)
					obj.sq_PlaySound("R_RUN_FLOOR");
				else if (weight < LIGHT_OBJECT_MAX_WEIGHT)
					obj.sq_PlaySound("RUN_STONE");
				else if (weight < MIDDLE_OBJECT_MAX_WEIGHT)
					obj.sq_PlaySound("RUN_SOIL");
				else
					obj.sq_PlaySound("RUN_GRASS");
			}
		}
		obj.sq_ClearKeyFrameFlag(ani);
		
	}
}





function procSkill_MagicShield(obj)
{
}


function procSkill_MagicShield(obj)
{
}

function getImmuneTypeDamgeRate_ATMage(obj,damageRate, attacker)
{
	// 불기둥 원거리 공격의 데미지를 N%만큼 감소시키고, 경직을 받지 않습니다.
	if(obj.getVar("firepillar").size_vector() > 0)
	{
		if(obj.getVar("firepillar").get_vector(VECTOR_FLAG_2))
		{
			if(attacker)
			{
				print( " damageRate:" + damageRate);
				local skillLevel = obj.sq_GetSkillLevel(SKILL_FIREPILLAR);
				local N = obj.sq_GetLevelData(SKILL_FIREPILLAR, 0, skillLevel); // 0.원거리 피해줄여주는 감소치(%)
				// 원거리 공격이라면..
				damageRate = damageRate - N;
				//damageRate = 10;
				print( " convert damageRate:" + damageRate);
			}
		}
	}

	// 불사로 회복시엔 데미지가 2배(1.5배?) 들어간다.	
	if(CNSquirrelAppendage.sq_IsAppendAppendage(obj, "Character/ATMage/DieHard/ap_ATMage_DieHardSlowHeal.nut")) //
	{
		//0. 피격시 받는 데미지 증가율(%)
		local increaseDamageRate = sq_GetIntData(obj, SKILL_DIEHARD, SKL_STATIC_INT_IDX_0); 
		
		//increaseDamageRate.tofloat() / 100.0;
		damageRate = damageRate + increaseDamageRate;
	}
	
	return damageRate;
}

function getImmuneType_ATMage(obj,type, attacker)	
{
	local immuneType = type;
	
	return immuneType;
}

function procSkill_ATMage(obj)
{
	procSkill_IceRoad(obj);
	procSkill_MagicShield(obj);

}



function useSkill_before_ATMage(obj, skillIndex, consumeMp, consumeItem, oldSkillMpRate)
{	
	local bChangedMp = false;
	
	print(" consumpMp:" + consumeMp + " oldSkillMpRate:" + oldSkillMpRate);
	
	local appendage = obj.GetSquirrelAppendage("Character/ATMage/ManaBurst/ap_ATMage_ManaBurst.nut");
	
	if(appendage)
	{
		local isvalid = appendage.isValid();
		
		if(isvalid)
		{
			local skillLevel = obj.sq_GetSkillLevel(SKILL_MANABURST);
			local mpComsumeRate = sq_GetLevelData(obj, SKILL_MANABURST, SKL_LVL_COLUMN_IDX_0, skillLevel);
			local newMpRate = oldSkillMpRate.tofloat() * (100 + mpComsumeRate.tofloat()) / 100;
			
			print(" newMpRate:" + newMpRate);
			obj.setSkillMpRate(skillIndex, newMpRate.tofloat());
			bChangedMp = true;
		}		
	}
	
	if(obj.sq_GetSkillLevel(SKILL_EXPRESSION) > 0)
	{
		local skillLevel = obj.sq_GetSkillLevel(SKILL_EXPRESSION);
		local skillMpRate = obj.getSkillMpRate(skillIndex);
		local mpComsumeRate = sq_GetLevelData(obj, SKILL_EXPRESSION, 0, skillLevel);
		local newMpRate = skillMpRate.tofloat() * (100 - mpComsumeRate.tofloat()) / 100;
		
		//print(" expression consumeMp oldMpRate:" + skillMpRate.tofloat() + " skillIndex:" + skillIndex);
		//print(" expression consumeMp newMpRate:" + newMpRate.tofloat());
		//print(" expression consumeMp mpComsumeRate:" + mpComsumeRate.tofloat());

		obj.setSkillMpRate(skillIndex, newMpRate.tofloat());
	}
	
	print(" now consumpMp:" + obj.getSkillMpRate(skillIndex));
	
	return true;
}

function useSkill_after_ATMage(obj, skillIndex, consumeMp, consumeItem, oldSkillMpRate)
{
	if(!obj)
		return false;
		
	obj.setSkillMpRate(skillIndex, oldSkillMpRate.tofloat());
	print(" after set consumpMp:" + oldSkillMpRate);
	
	return true;
}



// getAttackAni()
// 필요에 따라 평타모션이 바뀔때, 이 함수에서 처리해줌
// 예) 수인체 스킬
function getAttackAni_ATMage(obj, index)
{
	if (!obj)
		return null;	
	
	local animation = obj.sq_GetAttackAni(index);

	// 수인체 스킬을 배웠다면, 평타 에니메이션이 바뀜
	// 마법구도 발사되지 않음.
	local skillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);
	if (skillLevel > 0)
		animation = obj.sq_GetCustomAni(CUSTOM_ANI_ICE_ELEMENTAL_ATTACK1 + index);
	
	return animation;
}



// getDashAttackAni()
// 필요에 따라 평타모션이 바뀔때, 이 함수에서 처리해줌
// 예) 수인체 스킬
function getDashAttackAni_ATMage(obj)
{
	if (!obj)
		return null;	
	
	local animation = obj.sq_GetDashAttackAni();

	// 수인체 스킬을 배웠다면, 평타 에니메이션이 바뀜
	// 마법구도 발사되지 않음.
	local skillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);
	if (skillLevel > 0)
		animation = obj.sq_GetCustomAni(CUSTOM_ANI_ICE_ELEMENTAL_DASH_ATTACK);
	
	return animation;
}



// getJumpAttackAni()
// 필요에 따라 평타모션이 바뀔때, 이 함수에서 처리해줌
// 예) 수인체 스킬
function getJumpAttackAni_ATMage(obj)
{
	if (!obj)
		return null;	
	
	local animation = obj.sq_GetJumpAttackAni();

	// 수인체 스킬을 배웠다면, 평타 에니메이션이 바뀜
	// 마법구도 발사되지 않음.
	local skillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);
	if (skillLevel > 0)
		animation = obj.sq_GetCustomAni(CUSTOM_ANI_ICE_ELEMENTAL_JUMP_ATTACK);
	
	return animation;
}

// 기본 공격이 최대 몇타인가?
// 수인체를 배우면 최대 3타까지 평타가 이루어짐
function getAttackCancelStartFrameSize_ATMage(obj)
{
	local maxAttackNumber = obj.sq_GetAttackCancelStartFrameSize();

	local skillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);
	// 최대개수보다 1작은 수를 리턴하면 됨
	if (skillLevel > 0)
		maxAttackNumber = 2;

	return maxAttackNumber;
}

function setState_ATMage(obj, state, datas, isResetTimer)
{
	if(state == STATE_DIE)
		obj.sq_RemoveSkillLoad(SKILL_HOLONG_LIGHT);	// 죽으면 호롱불 UI 제거
	return 0;
}

function getDefaultAttackInfo_ATMage(obj, index)
{
	if (!obj)
		return null;	
	
	local attackInfo = obj.sq_GetDefaultAttackInfo(index);

	// 평타 공격정보 변경
	local skillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);
	if (skillLevel > 0)
	{
		attackInfo = sq_GetCustomAttackInfo(obj, CUSTOM_ATTACK_INFO_ICE_ELEMENTAL_ATTACK1 + index);
	}
	
	return attackInfo;
}

function getDashAttackInfo_ATMage(obj)
{
	if (!obj)
		return null;
	
	local attackInfo = obj.sq_GetDashAttackInfo();

	// 평타 공격정보 변경
	local skillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);
	if (skillLevel > 0)
		attackInfo = sq_GetCustomAttackInfo(obj, CUSTOM_ATTACK_INFO_ICE_ELEMENTAL_DASH_ATTACK);
	
	return attackInfo;
}


function getJumpAttackInfo_ATMage(obj)
{
	if (!obj)
		return null;	
	
	local attackInfo = obj.sq_GetJumpAttackInfo();

	// 평타 공격정보 변경
	local skillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);
	if (skillLevel > 0)
		attackInfo = sq_GetCustomAttackInfo(obj, CUSTOM_ATTACK_INFO_ICE_ELEMENTAL_JUMP_ATTACK);
	
	return attackInfo;
}




function setEnableCancelSkill_ATMage(obj, isEnable)
{
	if(!obj)
		return false;
	
	if(!obj.isMyControlObject())
		return false;


	if(!isEnable)
		return true;
		
	// 캔슬기 삭제 작업입니다. (2012.04.12)
	// 남법사 - 빅뱅검은 빙결사로 전직하기 전까지 자동캔슬이 작동안합니다.
	
	local GROW_TYPE_AT_MAGE = 0; // 전직 무
	local GROW_TYPE_ELEMENTAL_BOMBER = 1; // 전직 엘리멘탈 바머
	local GROW_TYPE_GLACIALMASTER = 2; // 전직 빙결사
	
	//print( "  growtype:" +  sq_getGrowType(obj));
	
	
	
	// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
	//if(sq_isPVPMode())
	{	
//38	`ATMage/CancelWindStrike.skl`		// 캔슬 윈드스트라이크
		obj.setSkillCommandEnable(SKILL_WIND_STRIKE, isEnable);
//39	`ATMage/CancelAtMagePush.skl`		// 캔슬 밀어내기
		obj.setSkillCommandEnable(SKILL_PUSH_OUT, isEnable);
//40	`ATMage/CancelFallenBlossoms.skl`	// 캔슬 낙화연창
		obj.setSkillCommandEnable(SKILL_FALLENBLOSSOMS, isEnable);
//41	`ATMage/CancelTurnWindmill.skl`		// 캔슬 풍차돌리기
		obj.setSkillCommandEnable(SKILL_TURNWINDMILL, isEnable);
//42	`ATMage/CancelBrokenArrow.skl`		// 캔슬 브로큰애로우
		obj.setSkillCommandEnable(SKILL_BROKENARROW, isEnable);
//43	`ATMage/CancelIceCrash.skl`			// 캔슬 아이스 크래쉬
		obj.setSkillCommandEnable(SKILL_ICE_CRASH, isEnable);
//44	`ATMage/CancelFrozenLand.skl`		// 캔슬 얼어붙은 대지
		obj.setSkillCommandEnable(SKILL_FROZENLAND, isEnable);
//45	`ATMage/CancelIceSword.skl`			// 캔슬 빙검
		obj.setSkillCommandEnable(SKILL_ICE_SWORD, isEnable);
//46	`ATMage/CancelMultiShot.skl`		// 캔슬 연속 마법구 날리기
		obj.setSkillCommandEnable(SKILL_MULTI_SHOT, isEnable);
//47	`ATMage/CancelFlameCircle.skl`		// 캔슬 프레임서클
		obj.setSkillCommandEnable(SKILL_FLAMECIRCLE, isEnable);
//170	`ATMage/CancelBackStep.skl`			// 캔슬 백스텝	
		//obj.setSkillCommandEnable(SKILL_BROKENARROW, isEnable);
		
//60	`ATMage/IceOrbEx.skl`			// 아이스 오브 (특성)
//SKILL_ICE_ORB_EX				<- 60	// 특성 아이스 오브
		obj.setSkillCommandEnable(SKILL_ICE_ORB_EX, isEnable);
//61	`ATMage/Concentrate.skl`		// 컨센트레이트(특성 액티브 스킬)
//SKILL_CONCENTRATE_EX			<- 61	// 컨센트레트(농축)
		obj.setSkillCommandEnable(SKILL_CONCENTRATE_EX, isEnable);
//62 	`ATMage/ElementalStrikeEx.skl`		// 엘레멘탈스트라이크 (특성)
//SKILL_ELEMENTAL_STRIKE_EX		<- 62	// 엘레멘탈 스트라이크 (특성스킬)
//63	`ATMage/IceFieldEx.skl`			// 아이스 필드 (특성)
		obj.setSkillCommandEnable(SKILL_ELEMENTAL_STRIKE_EX, isEnable);
//SKILL_ICE_FIELD_EX				<- 63	// 아이스 필드
		obj.setSkillCommandEnable(SKILL_ICE_FIELD_EX, isEnable);
		//
		
		if(sq_getGrowType(obj) == GROW_TYPE_GLACIALMASTER)
		{	
			obj.setSkillCommandEnable(SKILL_ICE_SWORD, isEnable);
		}
	}
	//else
	//{
	//}
	
	
	
	return true;
	
	local size = 10; // 하나 더 추가해야함
	local cancel_skill_l =[];
	local skill_l =[];
	cancel_skill_l.resize(size);
	skill_l.resize(size);
//SKILL_WIND_STRIKE				<- 38	// 윈드 스트라이크
//SKILL_PUSH_OUT				<- 39	// 밀어내기
//SKILL_FALLENBLOSSOMS			<- 40   // 공통:낙화연창
//SKILL_TURNWINDMILL				<- 41	// 풍차돌리기
//SKILL_BROKENARROW				<- 42	// 얼어붙은 대지
//SKILL_ICE_CRASH					<- 43	// 아이스크래쉬
//SKILL_FROZENLAND				<- 44	// 얼어붙은 대지
//SKILL_ICE_SWORD					<- 45	// 빙검
//SKILL_FLAMECIRCLE				<- 47	// 프레임서클
//SKILL_MULTI_SHOT				<- 25	// 연속 마법구 발사
	cancel_skill_l[0] = SKILL_CANCEL_WIND_STRIKE;
	cancel_skill_l[1] = SKILL_CANCEL_PUSH_OUT;
	cancel_skill_l[2] = SKILL_CANCEL_FALLENBLOSSOMS;
	cancel_skill_l[3] = SKILL_CANCEL_TURNWINDMILL;
	cancel_skill_l[4] = SKILL_CANCEL_BROKENARROW;
	cancel_skill_l[5] = SKILL_CANCEL_ICE_CRASH;
	cancel_skill_l[6] = SKILL_CANCEL_FROZENLAND;
	cancel_skill_l[7] = SKILL_CANCEL_ICE_SWORD;
	cancel_skill_l[8] = SKILL_CANCEL_FLAMECIRCLE;
	cancel_skill_l[9] = SKILL_CANCEL_MULTI_SHOT;

	skill_l[0] = SKILL_WIND_STRIKE;
	skill_l[1] = SKILL_PUSH_OUT;
	skill_l[2] = SKILL_FALLENBLOSSOMS;
	skill_l[3] = SKILL_TURNWINDMILL;
	skill_l[4] = SKILL_BROKENARROW;
	skill_l[5] = SKILL_ICE_CRASH;
	skill_l[6] = SKILL_FROZENLAND;
	skill_l[7] = SKILL_ICE_SWORD;
	skill_l[8] = SKILL_FLAMECIRCLE;
	skill_l[9] = SKILL_MULTI_SHOT;

	for(local i=0;i<size;i+=1)
	{
		// 파라미터로 넘겨진 키 인덱스와, 공격방법이 가능한지 체크하여 통과하면 패시브오브젝트를 만들어 등록합니다..
		local level = sq_GetSkillLevel(obj, cancel_skill_l[i]);
		local bRet = false;
		
		if(level > 0)
		{
			if(isEnable)
			{
				bRet = true;
			}
		}
		
		obj.setSkillCommandEnable(skill_l[i], bRet);
	}
	
	
	return true;
}

function isUsableItem_ATMage(obj, itemIndex)
{
	if(CNSquirrelAppendage.sq_IsAppendAppendage(obj, "Character/ATMage/DieHard/ap_ATMage_DieHardSlowHeal.nut")) //
	{ // 불사로 슬로우힐 중이라면 회복계열 아이템을 쓸 수 없습니다.
		local isRecover = sq_IsItemRecover(itemIndex);

		if(isRecover == true)
		{
			return false;
		}
		
		if(itemIndex == 8)
		{ // 레미의 손길
			return false;
		}
	}
	//print( " is use itemIndex:" + itemIndex + " return true");
	
	return true;
}

function sendSetHpPacket_ATMage(obj, hp, sendInstant)
{
	if(CNSquirrelAppendage.sq_IsAppendAppendage(obj, "Character/ATMage/DieHard/ap_ATMage_DieHardSlowHeal.nut")) //
	{
		if(obj.getHp() < hp)
		{
			//print(" not send hp");
			return false;
		}
	}
	//print( " go send hp");
	return true;
}

function sendSetMpPacket_ATMage(obj, mp, sendInstant)
{	
	return true;
}



// 컨버전 스킬이 적용되어야 할 패시브 오브젝트 인덱스라면,
// `isApplyConversionSkillPassiveObject`함수에 추가를 해주도록 한다.
function isApplyConversionSkillPassiveObject_ATMage(passiveObjectIndex)
{
	if (passiveObjectIndex == 24201)
	{	// 윈드 스트라이크
		return true;
	}
	else if (passiveObjectIndex == 24222)
	{	// 호롱불
		return true;
	}
	else if (passiveObjectIndex == 24217)
	{	// 물대포
		return true;
	}
	else if (passiveObjectIndex == 24254)
	{	// 불기둥(화염방패)
		return true;
	}
	
	// 연속발사 패시브 오브젝트, 연속발사의 폭발 패시브 오브젝트
	
	local idx = passiveObjectIndex;
	if (idx >= 24266 && idx <= 24283)
	{
		return true;
	}
	
	return false;
}


//던전을 새로 시작할 때 호출되는 리셋 함수
// 던전에서 마을로 나올 때 역시 호출됩니다.
function resetDungeonStart_ATMage(obj, moduleType, resetReason, isDeadTower, isResetSkillUserCount)
{
	if(!obj) return -1;	

	local isReset = true; // 기본적으론 전부 리셋입니다.
		
	if (sq_GetCurrentModuleType() == MODULE_TYPE_WARROOM || sq_GetCurrentModuleType() == MODULE_TYPE_DEAD_TOWER)
	{
		// 리셋의 이유가 죽는이유가 아니라면..
		if (resetReason != REASON_DEATH)
		{
			isReset = false; // 리셋시키지 않습니다.
		}
	}
	
	
	if(isReset)
	{ // 리셋을 해야한다면..
		local appendage = obj.GetSquirrelAppendage("Character/ATMage/IceRoad/ap_ATMage_IceRoad.nut");
		

		if(appendage)
		{
			local skill = sq_GetSkill(obj, SKILL_ICEROAD);
			local isvalid = appendage.isValid();
			
			if(skill)
			{
				print(" isSeal:" + skill.isSealActiveFunction());
				if(!skill.isSealActiveFunction())
				{
					skill.setSealActiveFunction(true);
				}
			}
			
			if(isvalid)
			{
				appendage.setValid(false);
			}
		}
		
		obj.sq_RemoveSkillLoad(SKILL_HOLONG_LIGHT);	// 호롱불 UI 제거
	}
	
	return 1;
	
}


// 남법사 : 엘레멘탈 체인
// parameter로 전달된 element속성을 제외한 다른3속성을 강화한다.
// appendage는 중첩되지 않음.
function addElementalChain_ATMage(obj, element)
{
	if (!obj) return;
	if (element == ENUM_ELEMENT_MAX) return;
	local skillLevel = sq_GetSkillLevel(obj, SKILL_ELEMENTAL_CHAIN);
	if (skillLevel <= 0) return;
	
	local skill = sq_GetSkill(obj, SKILL_ELEMENTAL_CHAIN);
	if (!skill) return;
	local changeValue = obj.sq_GetLevelData(SKILL_ELEMENTAL_CHAIN, 0, skillLevel);
	local validTime = obj.sq_GetLevelData(SKILL_ELEMENTAL_CHAIN, 1, skillLevel);
	
	local apFire = null;
	local apWater = null;
	local apDark = null;
	local apLight = null;
	
	if (element == ENUM_ELEMENT_FIRE)
	{
		apWater = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_WATER, false, changeValue.tofloat(), validTime);
		apDark = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_DARK, false, changeValue.tofloat(), validTime);
		apLight = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_LIGHT, false, changeValue.tofloat(), validTime);
	}
	else if (element == ENUM_ELEMENT_WATER)
	{
		apFire = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_FIRE, false, changeValue.tofloat(), validTime);
		apDark = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_DARK, false, changeValue.tofloat(), validTime);
		apLight = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_LIGHT, false, changeValue.tofloat(), validTime);
	}
	else if (element == ENUM_ELEMENT_DARK)
	{
		apFire = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_FIRE, false, changeValue.tofloat(), validTime);
		apWater = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_WATER, false, changeValue.tofloat(), validTime);
		apLight = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_LIGHT, false, changeValue.tofloat(), validTime);
	}
	else if (element == ENUM_ELEMENT_LIGHT)
	{
		apFire = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_FIRE, false, changeValue.tofloat(), validTime);
		apWater = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_WATER, false, changeValue.tofloat(), validTime);
		apDark = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_DARK, false, changeValue.tofloat(), validTime);
	}
	else if (element == -1)
	{
		apFire = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_FIRE, false, changeValue.tofloat(), validTime);
		apWater = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_WATER, false, changeValue.tofloat(), validTime);
		apDark = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_DARK, false, changeValue.tofloat(), validTime);
		apLight = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_ELEMENT_ATTACK_LIGHT, false, changeValue.tofloat(), validTime);
	}
	
	if (apFire != null)
		apFire.sq_Append(obj, obj, APID_SKILL_ELEMENTAL_CHAIN_FIRE);
	if (apWater != null)
		apWater.sq_Append(obj, obj, APID_SKILL_ELEMENTAL_CHAIN_WATER);
	if (apDark != null)
		apDark.sq_Append(obj, obj, APID_SKILL_ELEMENTAL_CHAIN_DARK);
	if (apLight != null)
		apLight.sq_Append(obj, obj, APID_SKILL_ELEMENTAL_CHAIN_LIGHT);
}


function onChangeSkillEffect_ATMage(obj, skillIndex, reciveData)
{
	if(!obj)
		return;
		
	if(skillIndex == SKILL_ICEROAD)
	{
		local skill = sq_GetSkill(obj, SKILL_ICEROAD);
		skill.resetCurrentCoolTime();
		skill.setSealActiveFunction(true);	
		local skill_level = sq_GetSkillLevel(obj, SKILL_ICEROAD);
		obj.startSkillCoolTime(SKILL_ICEROAD, skill_level, -1);
		
		local appendage = obj.GetSquirrelAppendage("Character/ATMage/IceRoad/ap_ATMage_IceRoad.nut");
		appendage.setValid(false);
	}
	else if(skillIndex == SKILL_DIEHARD)
	{
		if(reciveData.getSize() > 0)
		{
			local hp = reciveData.readDword(); // 동기화할 hp
			
			if(hp > 0)
			{
				print(" onchange:" + hp);
				obj.setHp(hp, null, true);
			}
		}
	}
	else if (skillIndex == SKILL_ELEMENTAL_CHANGE)
	{
		if (reciveData.getSize() > 0)
		{
			local element = reciveData.readByte();
			obj.setThrowElement(element);
			
			// 보호막형성 처리
			local appendage = CNSquirrelAppendage.sq_GetAppendage(obj,"Character/ATMage/MagicShield/ap_MagicShield.nut");
			if(appendage)
				setMagicShieldType(appendage, obj, obj.getThrowElement());	
		}
	}
	else if(skillIndex == SKILL_TUNDRASOUL)
	{
		if (reciveData.getSize() > 0)
		{
			local mode = reciveData.readDword();
			
			local auraAppendage = 0;
			local appendage = CNSquirrelAppendage.sq_GetAppendage(obj, "Character/ATMage/TundraSoul/ap_ATMage_TundraSoul.nut");
			
			if(appendage)
			{
				auraAppendage = appendage.sq_getSquirrelAuraMaster("AuraTundraSoul");
			
				if(mode == 1)			
				{ // 있는것을 꺼야합니다. (아우라)
					appendage.sq_DeleteAppendages();
				}
				else if(mode == 0)
				{ // 없는것을 켜야합니다. (아우라)
					local range = obj.sq_GetIntData(SKILL_TUNDRASOUL , 0);// 0. 빙결 상태이상에 걸리는 효과범위
					appendage.sq_AddSquirrelAuraMaster("AuraTundraSoul",obj, obj, range, 18, 5, 0);
				}
			}
		//CNSquirrelAppendage.sq_RemoveAppendage(obj, "Character/ATMage/TundraSoul/ap_ATMage_TundraSoul.nut");
		}
	}
}

function changeTrhowState_ATMage(obj, throwState)
{
	if (!obj) return false;
	
	printc("changeTrhowState_ATMage");
	if (throwState == 3 &&
		obj.getThrowIndex() == SKILL_ELEMENTAL_CHANGE)
	{
		// 남법사 : 속성 발동
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(throwState);
		obj.sq_IntVectPush(-1);
		obj.sq_IntVectPush(obj.getThrowElement());
		obj.sq_AddSetStatePacket(STATE_THROW, STATE_PRIORITY_USER, true);
		return true;
	}

	return false;
}

function isCounterState_ATMage(obj, isCounter)
{
	if(obj.getVar("firepillar").size_vector() > 0)
	{
		if(obj.getVar("firepillar").get_vector(VECTOR_FLAG_2))
		{
			isCounter = false;
		}
	}
	
	return isCounter;
}


function AppendAppendageToSimple(obj, skillIndex, appendageFileName, validTime, isBuff)
{
	local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, skillIndex, false, appendageFileName, false);
	
	appendage.sq_SetValidTime(validTime); // 어펜디지 타임 세팅
	
	// 여기서 append 작업
	CNSquirrelAppendage.sq_Append(appendage, obj, obj, isBuff); // 버프온

}

function setActiveStatus_ATMage(obj, activeStatus, power)
{
	if (!obj) return 0;
	
	local state = sq_GetState(obj);
	
	if (state == STATE_ELEMENTAL_BUSTER)
	{
		// 각성일땐 따로 상태이상이 걸리지 않음 (엘레멘탈 버스터)
		//printc("state : STATE_ELEMENTAL_BUSTER");
		return 0;
	}
	
	return 1;
}


function reset_ATMage(obj)
{
	if(!obj)
		return;		
	
}