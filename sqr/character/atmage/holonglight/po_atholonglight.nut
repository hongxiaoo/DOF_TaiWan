HOLONG_LIGHT_VAR_IS_LEFT		<- 0;
HOLONG_LIGHT_VAR_APPENDAGE		<- 1;
HOLONG_LIGHT_VAR_HORIZON_ANGLE  <- 2;
HOLONG_LIGHT_VAR_VERTICAL_ANGLE <- 3;
HOLONG_LIGHT_VAR_LIFE_TIME		<- 4;
HOLONG_LIGHT_VAR_DEFENCE_UP		<- 5;
HOLONG_LIGHT_VAR_ATTACK_POWER	<- 6;
HOLONG_LIGHT_VAR_SHOOT_TIME		<- 7;
HOLONG_LIGHT_VAR_COOL_TIME		<- 8;


HOLONG_LIGHT_STATE_BUFF     <- 2; // 대기 상태 : 캐릭터에 버프를 걸어준다. : 패시브 스테이트는 2부터 시작한다.
HOLONG_LIGHT_STATE_ATTACK   <- 3; // 공격 : 사출되어 타겟을 공격하지만 버프는 사라진다.
HOLONG_LIGHT_STATE_DESTROY  <- 4; // 제자리서 사라진다.
HOLONG_LIGHT_STATE_EXPLOSION <- 5; // 폭발


HOLONG_LIGHT_CUSTOM_ANI_MOVE	<- 0; // 이동시 애니
HOLONG_LIGHT_CUSTOM_ANI_DESTROY <- 1; // 파괴시 애니
HOLONG_LIGHT_CUSTOM_ANI_SHOOT	<- 2; // 발사시 날아가는 애니
HOLONG_LIGHT_CUSTOM_ANI_EXPLOSION <- 3; //폭발 애니


function setCustomData_po_ATHolongLight(obj, receiveData)
{
	if(!obj) return;
	
	local isLeft		= receiveData.readBool();
	local horizonAngle  = receiveData.readFloat();
	local verticalAngle = receiveData.readFloat();
	local lifeTime		= receiveData.readDword();
	local defenceUp		= receiveData.readDword();
	local attackPower	= receiveData.readDword();
	local shootTime		= receiveData.readDword();
	local coolTime		= receiveData.readDword();
	
	local var = obj.getVar();	
	
	var.setBool(HOLONG_LIGHT_VAR_IS_LEFT,isLeft);		
	obj.sendStateOnlyPacket(HOLONG_LIGHT_STATE_BUFF);
	
	
	var.setFloat(HOLONG_LIGHT_VAR_HORIZON_ANGLE, horizonAngle);
	var.setFloat(HOLONG_LIGHT_VAR_VERTICAL_ANGLE, verticalAngle);	
	var.setInt(HOLONG_LIGHT_VAR_LIFE_TIME, lifeTime);	
	var.setInt(HOLONG_LIGHT_VAR_DEFENCE_UP, defenceUp);
	var.setInt(HOLONG_LIGHT_VAR_SHOOT_TIME, shootTime);
	var.setInt(HOLONG_LIGHT_VAR_COOL_TIME, coolTime);

	sq_SetCurrentAttackBonusRate(sq_GetCurrentAttackInfo(obj), attackPower);
}

function onTimeEvent_po_ATHolongLight(obj, timeEventIndex, timeEventCount)
{	
	if(!obj)
		return false;

	if(obj.isMyControlObject() && timeEventIndex == 0)
	{	
		if(obj.getState() == HOLONG_LIGHT_STATE_BUFF) {
			obj.sendStateOnlyPacket(HOLONG_LIGHT_STATE_DESTROY);
			
			local mage = sq_ObjectToSQRCharacter(obj.getTopCharacter());	
			if (mage)
				mage.sq_RemoveSkillLoad(SKILL_HOLONG_LIGHT);	
		}
		return true; // true면 콜백 중단
	}
	else if( timeEventIndex == 1 )
	{
		obj.sendStateOnlyPacket(HOLONG_LIGHT_STATE_EXPLOSION);
	}
	
	return false;	
} 


function onDestroyObject_po_ATHolongLight(obj, destroyObj)
{
	
	local parentObj = obj.getParent();
	parentObj = sq_ObjectToSQRCharacter(parentObj);
		
	
	if(!parentObj || isSameObject(parentObj,destroyObj)) { //부모 객체가 파괴되면 사라짐 	
		obj.sendStateOnlyPacket(HOLONG_LIGHT_STATE_DESTROY);
	}	
	

}


function onAttack_po_ATHolongLight(obj, damager, boundingBox, isStuck)
{	
	if(!obj)
		return 0;

	obj.sendStateOnlyPacket(HOLONG_LIGHT_STATE_EXPLOSION);	
	return 0;
}

function setState_po_ATHolongLight(obj, state, datas)
{
	if(!obj) return;	
	
	local var = obj.getVar();
	
	// 버프 모드
	if (state ==  HOLONG_LIGHT_STATE_BUFF) {	
	
		local lifeTime    = var.getInt(HOLONG_LIGHT_VAR_LIFE_TIME);
		local defenceUp   = var.getInt(HOLONG_LIGHT_VAR_DEFENCE_UP);
						
		var.push_ct_vector(); // 타이머 추가
		local timer = var.get_ct_vector(0);
		timer.Reset();
		timer.Start(500,0);
		obj.setTimeEvent(0,lifeTime,1,false); // 0번 인덱스의 타이머, 5초단위 이벤트 발생, 1번만, 처음엔 실행안함.
		
		local parentObj = obj.getParent();	
		printc("lifeTime " +lifeTime);
		printc("defenceUp " +defenceUp);
		
		local appendage = sq_CreateChangeStatus(CHANGE_STATUS_TYPE_EQUIPMENT_MAGICAL_DEFENSE, false, defenceUp.tofloat() , lifeTime);
		if(appendage && parentObj) {
			appendage.sq_AddChangeStatus(CHANGE_STATUS_TYPE_EQUIPMENT_PHYSICAL_DEFENSE, false, defenceUp.tofloat());
			appendage.sq_Append(parentObj,parentObj);
			
			local var2 = obj.getVar("holong");
			
			printc("var2 " +var2);
			var2.setAppendage(HOLONG_LIGHT_VAR_APPENDAGE, appendage);
		}	
	}
	else if (state ==  HOLONG_LIGHT_STATE_ATTACK) {
		local var2 = obj.getVar("holong");
		local append = var2.getAppendage(HOLONG_LIGHT_VAR_APPENDAGE);
				
		if(append)
			append.setValid(false);
		
		local horizonAngle = var.getFloat(HOLONG_LIGHT_VAR_HORIZON_ANGLE);
		local verticalAngle = var.getFloat(HOLONG_LIGHT_VAR_VERTICAL_ANGLE);
			
		local shootAni = obj.getCustomAnimation(HOLONG_LIGHT_CUSTOM_ANI_SHOOT);		
		obj.setCurrentAnimation(shootAni);		
		sq_SetfRotateAngle(shootAni, sq_ToRadian(-horizonAngle));
			
		local shootTime = var.getInt(HOLONG_LIGHT_VAR_SHOOT_TIME);
		obj.setTimeEvent(1,shootTime,1,false);		
		
		obj.sq_SetMoveParticle("Particle/ATHolongLight.ptl", horizonAngle, verticalAngle);
							
		sq_AddDrawOnlyAniFromParent(obj,"PassiveObject/Character/Mage/Animation/ATHolongLight/shot_effect_dodge.ani", 0, 0, 0);
		
		obj.sq_PlaySound("LAMPLIGHT_ATK");
	}
	else if (state ==  HOLONG_LIGHT_STATE_DESTROY) {
		local destroyAni = obj.getCustomAnimation(HOLONG_LIGHT_CUSTOM_ANI_DESTROY);		
		obj.setCurrentAnimation(destroyAni);		
	}
	else if (state == HOLONG_LIGHT_STATE_EXPLOSION) {
		
		local shootAni = obj.getCustomAnimation(HOLONG_LIGHT_CUSTOM_ANI_EXPLOSION);				
		obj.setCurrentAnimation(shootAni);		
		obj.sq_RemoveMoveParticle();
	} 
	
}


function procAppend_po_ATHolongLight(obj)
{
	if(!obj)
		return;

	local var = obj.getVar();	
	local xDistance = -26;
	local timer = var.get_ct_vector(0);				
	if(!timer)
		return;
		
	local currentTime = timer.Get();			
	local zDistance = sq_GetAccel(0, 35, currentTime, 300, true);;	
	
	
	local isLeft = var.getBool(HOLONG_LIGHT_VAR_IS_LEFT);	
	if(isLeft)		
		xDistance = -26 + sq_GetAccel(0, 52, currentTime, 300, true);	
	
		
	local parentObj = obj.getParent();		
	if(obj.sq_GetParentState() == STATE_DIE) // 죽으면 사라짐	
		obj.sendStateOnlyPacket(HOLONG_LIGHT_STATE_DESTROY);
		
		
	if(obj.getState() == HOLONG_LIGHT_STATE_BUFF) { // 이동할때 애니 변경

		local isDash = false;
		if(obj.sq_GetParentState() == STATE_DASH){
			if(!obj.isCurrentAnimationIndex(HOLONG_LIGHT_CUSTOM_ANI_MOVE))
				obj.setCurrentAnimation(obj.getCustomAnimation(HOLONG_LIGHT_CUSTOM_ANI_MOVE));					
			isDash = true;	
		}
		else {
			local defaultAni = obj.getDefaultAnimation();
			local currentAni = obj.getCurrentAnimation();
			if(!sq_IsSameAni(defaultAni,currentAni))
				obj.setCurrentAnimation(defaultAni);		
		}
		
		if(parentObj) {
			local x = sq_GetDistancePos(parentObj.getXPos(),parentObj.getDirection(),xDistance);
			local y = parentObj.getYPos() - 1;
			local z = parentObj.getZPos() + sq_GetShuttleValue(90, 113,sq_GetObjectTime(obj),500) - zDistance;
			obj.setDirection(parentObj.getDirection());
			sq_SetCurrentPos(obj, x, y, z);
		}
	}	
}


function onEndCurrentAni_po_ATHolongLight(obj)
{
	if(!obj) return;	
	
	if(obj.getState() == HOLONG_LIGHT_STATE_DESTROY) {
		if(obj.isMyControlObject())
			sq_SendDestroyPacketPassiveObject(obj);
	}
	else if(obj.getState() == HOLONG_LIGHT_STATE_EXPLOSION) {
		if(obj.isMyControlObject())
			sq_SendDestroyPacketPassiveObject(obj);
	}
	
}
