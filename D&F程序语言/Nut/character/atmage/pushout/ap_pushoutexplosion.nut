VAR_PUSH_OUT_EXPLOSION_OLD_STATE <- 0

function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_PushOutExplosion")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_PushOutExplosion")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_PushOutExplosion")
}

function onStart_appendage_PushOutExplosion(appendage)
{
	if(!appendage) {
		return;
	}
	
	local parentObj = appendage.getParent();
				
	if(!parentObj) {
		appendage.setValid(false);
		return;
	}
	
	local var = appendage.getVar();
	var.setInt(VAR_PUSH_OUT_EXPLOSION_OLD_STATE,parentObj.getState());
	
}

function proc_appendage_PushOutExplosion(appendage)
{
	if(!appendage && !appendage.isValid()) {
		return;		
	}

	local parentObj = appendage.getParent();
	local sourceObj = appendage.getSource();
	
	sourceObj = sq_GetCNRDObjectToSQRCharacter(sourceObj);
	if(!sourceObj || !parentObj) {
		appendage.setValid(false);
		return;
	}
	
	local var = appendage.getVar();
	local oldState = var.getInt(VAR_PUSH_OUT_EXPLOSION_OLD_STATE);	
	var.setInt(VAR_PUSH_OUT_EXPLOSION_OLD_STATE,parentObj.getState());
	
	if(oldState == STATE_STAND && parentObj.getState() != STATE_DOWN){
		appendage.setValid(false);
		return;
	}
			
	if(parentObj.getState() == STATE_DOWN && parentObj.getDownState() >=1 || ( oldState == STATE_DOWN && parentObj.getState() != STATE_DOWN) )
	{
		if(sourceObj.isMyControlObject())
		{		
			local level		  = sq_GetSkillLevel(sourceObj, SKILL_PUSH_OUT);
			
			// 충격파 주변데미지
			local attackPower = sourceObj.sq_GetPowerWithPassive(SKILL_PUSH_OUT, STATE_PUSH_OUT, 2, -1, 1.0);
			local sizeRate = sq_GetIntData(sourceObj, SKILL_PUSH_OUT, 0);
			print(sizeRate);
			
			
			// 소스 : CNEarthBreak와 동일한 것을 사용함
			sq_BinaryStartWrite();			
			// 0:(BOOL) 퍼뎀 유무 0:독뎀
			sq_BinaryWriteBool(0);
			
			// 1:(float) 공격력
			sq_BinaryWriteFloat(attackPower.tofloat());
			
			// 2:(WORD) 사이즈
			sq_BinaryWriteWord(sizeRate);
			
			// 3:(WORD) 띄우는 힘
			sq_BinaryWriteWord(200);
			
			// 4:(bool) 확장 스킬 유무
			local isExSkill = false;
			isExSkill = sq_GetSkillLevel(sourceObj, SKILL_PUSH_OUT_EX) > 0;
			sq_BinaryWriteBool(isExSkill);
			
			// 5:(DWORD) parent id : 확장 스킬일 때는 자신도 충격파를 맞는다.
			if(!isExSkill)
				sq_BinaryWriteDword(sq_GetObjectId(parentObj));			
			
			
			local x = sourceObj.getXPos() > parentObj.getXPos() ?  sourceObj.getXPos() - parentObj.getXPos() : parentObj.getXPos() - sourceObj.getXPos(); // 캐릭터와 몬스터와의 거리차 
			local y = parentObj.getYPos() - sourceObj.getYPos();
							
			if(sourceObj.getDirection() == parentObj.getDirection())
				x = -x;
				
			sq_SendCreatePassiveObjectPacket(sourceObj, 21035, 0, x, y, 0, ENUM_DIRECTION_NEUTRAL);
		}
		appendage.setValid(false);
	}		
}
