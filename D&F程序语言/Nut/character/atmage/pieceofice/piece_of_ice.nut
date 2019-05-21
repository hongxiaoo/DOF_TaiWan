POI_MAX_KEYFRAME_INDEX <-8;

function checkExecutableSkill_PieceOfIce(obj)
{

	if (!obj) return false;

	local useSkill = obj.sq_IsUseSkill(SKILL_PIECE_OF_ICE);

	if (useSkill) {
		//obj.sq_IntVectClear();
		//obj.sq_IntVectPush(SUB_STATE_ICEROAD_0); // substate세팅
		obj.sq_AddSetStatePacket(STATE_PIECE_OF_ICE, STATE_PRIORITY_IGNORE_FORCE, false);
		return true;
	}

	return false;

}

function checkCommandEnable_PieceOfIce(obj)
{

	if(!obj) return false;

	local state = obj.sq_GetState();

	if(state == STATE_ATTACK) {
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_PIECE_OF_ICE);
	}

	return true;

}

function onSetState_PieceOfIce(obj, state, datas, isResetTimer)
{
	if(!obj) return;	
	
	obj.sq_StopMove();
	obj.sq_SetCurrentAnimation(CUSTOM_ANI_PIECE_OF_ICE);
	
	obj.sq_SetStaticSpeedInfo(SPEED_TYPE_ATTACK_SPEED, SPEED_TYPE_ATTACK_SPEED,
			SPEED_VALUE_DEFAULT, SPEED_VALUE_DEFAULT, 1.0, 1.0);
}

function onProc_PieceOfIce(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();	

}

function onEndCurrentAni_PieceOfIce(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();
	
	obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);	
}

function onKeyFrameFlag_PieceOfIce(obj, flagIndex)
{

	if(!obj) return false;

	local substate = obj.getSkillSubState();
	local level		  = sq_GetSkillLevel(obj, SKILL_PIECE_OF_ICE);
	
	if(flagIndex == 1) {
		if(obj.isMyControlObject())
		{
			obj.sq_StartWrite();
			obj.sq_WriteBool(false); 
			local x = sq_GetIntData(obj, SKILL_PIECE_OF_ICE, 0);
			local z = sq_GetIntData(obj, SKILL_PIECE_OF_ICE, 1);		
			obj.sq_SendCreatePassiveObjectPacket(24224, 0, x, 0, z);
		}
	}
	else if(flagIndex >= 2 ) {
		local iceCoreObj = obj.getMyPassiveObject(24224,0);
		if(iceCoreObj)
		{			
			if(iceCoreObj.isMyControlObject()) {
				iceCoreObj.sendStatePacket(PIECE_OF_ICE_CORE_STATE_DAMAGE, flagIndex);	
			}			
			
			local randMin = sq_GetIntData(obj, SKILL_PIECE_OF_ICE, 2);
			local randMax = sq_GetIntData(obj, SKILL_PIECE_OF_ICE, 3);
			local randNum = sq_getRandom(randMin, randMax);
						
			for(local i=0;i<randNum;++i) {			
			
				//최대 플래그 인덱스 = 8 8에 가까울수록 범위가 줄어 든다.
				if(obj.isMyControlObject())
				{
					local hAngleRange = sq_GetIntData(obj, SKILL_PIECE_OF_ICE, 5); //좌우 범위
					local vAngleRange = sq_GetIntData(obj, SKILL_PIECE_OF_ICE, 6); //상하 범위
					
					if(hAngleRange > 360)
						hAngleRange = 360;
						
					local horizonAngle =  sq_getRandom(0,hAngleRange) -(hAngleRange/2);
					local verticalAngle = sq_getRandom(0,vAngleRange);
					
					
					// 프레임이 지날수록 생성 좌표가 점점 안으로 들어가게끔
					local startPosY = (40 * (8-flagIndex)/POI_MAX_KEYFRAME_INDEX)  * (vAngleRange == 0 ? 1 : horizonAngle/(hAngleRange/2)); 
					local lifeTime	  = sq_GetIntData(obj, SKILL_PIECE_OF_ICE, 4);														
					local iceParticle = sq_CreateDrawOnlyObject(iceCoreObj, "PassiveObject/Character/Mage/Animation/ATPieceOfIce/08_ice_shard1_dodge.ani",ENUM_DRAWLAYER_NORMAL,true);
					sq_SetCustomRotate(iceParticle,sq_ToRadian(-horizonAngle.tofloat()));	
					
					obj.sq_StartWrite();
					obj.sq_WriteWord(sq_getRandom(0,5));
					obj.sq_WriteFloat(horizonAngle.tofloat()); // 수평 범위 
					obj.sq_WriteFloat(verticalAngle.tofloat());  // 수직 범위
					obj.sq_WriteWord(lifeTime);									
					
					obj.sq_SendCreatePassiveObjectPacket(24223, 0, 60, startPosY, 75);			
				}
			}	
		}
	}	

	return true;

}

function onDamage_PieceOfIce(obj, attacker, boundingBox)
{
	if(!obj) return;
	
	local iceCoreObj = obj.getMyPassiveObject(24224,0);
	if(iceCoreObj)
		iceCoreObj.sendStateOnlyPacket(PIECE_OF_ICE_CORE_STATE_END);

}
