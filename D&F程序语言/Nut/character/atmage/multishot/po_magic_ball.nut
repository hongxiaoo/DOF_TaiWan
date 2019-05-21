function setCustomData_po_ATMagicBallLightDownMultiShot(obj, receiveData)
{
	setCustomData_po_ATMagicBallLightDown(obj, receiveData);
}

function setCustomData_po_ATMagicBallDarkDownMultiShot(obj, receiveData)
{
	setCustomData_po_ATMagicBallDarkDown(obj, receiveData);
}

function setCustomData_po_ATMagicBallWaterDownMultiShot(obj, receiveData)
{
	setCustomData_po_ATMagicBallWaterDown(obj, receiveData);
}

function setCustomData_po_ATMagicBallFireDownMultiShot(obj, receiveData)
{
	setCustomData_po_ATMagicBallFireDown(obj, receiveData);
}

function setCustomData_po_ATMagicBallNoneDownMultiShot(obj, receiveData)
{
	setCustomData_po_ATMagicBallNoneDown(obj, receiveData);
}



// 마법구체 - 명속성
function setCustomData_po_ATMagicBallLightDown(obj, receiveData)
{
	if(!obj)
		return;

	local horizonAngle = receiveData.readFloat();
	local verticalAngle = receiveData.readFloat();
	if (sq_BinaryGetReadSize() < receiveData.getSize())
	{
		// 엘레멘탈 레인 이라면, 공격력을 저장해놨다가 폭발할때 사용하도록 한다.
		
		// 공격력 셋팅
		local attackBonusRate = receiveData.readDword();
		local attackInfo = sq_GetCurrentAttackInfo(obj);
		sq_SetCurrentAttackBonusRate(attackInfo, attackBonusRate);
		sq_SetCurrentAttackInfo(obj,sq_GetCurrentAttackInfo(obj));
		
	}
	
	// 파티클의 이동 각도를 조절함
	obj.sq_SetMoveParticle("Particle/ATMagicBallLightMoveDown.ptl", horizonAngle, verticalAngle);
	local particleCreater = obj.sq_var.GetparticleCreaterMap("ATMagicBallLight", "PassiveObject/Character/Mage/Particle/ATMagicBallLightTail1.ptl", obj);
	particleCreater.Restart(0);
	obj.sq_AddObjectParticleCreater("Particle/ATMagicBallLightTailDown1.ptl");
	obj.sq_AddObjectParticleCreater("Particle/ATMagicBallLightTailDown2.ptl");
}


// 마법구체 - 암속성
function setCustomData_po_ATMagicBallDarkDown(obj, receiveData)
{
	if(!obj)
		return;
		
	local horizonAngle = receiveData.readFloat();
	local verticalAngle = receiveData.readFloat();
	
	if (sq_BinaryGetReadSize() < receiveData.getSize())
	{
		// 공격력 셋팅
		local attackBonusRate = receiveData.readDword();
		local attackInfo = sq_GetCurrentAttackInfo(obj);
		sq_SetCurrentAttackBonusRate(attackInfo, attackBonusRate);
		sq_SetCurrentAttackInfo(obj,sq_GetCurrentAttackInfo(obj));
	}

	// 파티클의 이동 각도를 조절함
	obj.sq_SetMoveParticle("Particle/ATMagicBallDarkMoveDown.ptl", horizonAngle, verticalAngle);
	local particleCreater = obj.sq_var.GetparticleCreaterMap("ATMagicBallDark", "PassiveObject/Character/Mage/Particle/ATMagicBallDarkTail1.ptl", obj);
	particleCreater.Restart(0);
	obj.sq_AddObjectParticleCreater("Particle/ATMagicBallDarkTailDown1.ptl");
	obj.sq_AddObjectParticleCreater("Particle/ATMagicBallDarkTailDown2.ptl");
	//obj.sq_AddObjectParticleCreater("Particle/ATMagicBallDarkTailDown3.ptl");
}


// 마법구체 - 수속성
function setCustomData_po_ATMagicBallWaterDown(obj, receiveData)
{
	local horizonAngle = receiveData.readFloat();
	local verticalAngle = receiveData.readFloat();
	
	if (sq_BinaryGetReadSize() < receiveData.getSize())
	{
		// 공격력 셋팅
		local attackBonusRate = receiveData.readDword();
		local attackInfo = sq_GetCurrentAttackInfo(obj);
		sq_SetCurrentAttackBonusRate(attackInfo, attackBonusRate);
		sq_SetCurrentAttackInfo(obj,sq_GetCurrentAttackInfo(obj));
	}

	// 파티클의 이동 각도를 조절함
	obj.sq_SetMoveParticle("Particle/ATMagicBallWaterMoveDown.ptl", horizonAngle, verticalAngle);
	local particleCreater = obj.sq_var.GetparticleCreaterMap("ATMagicBallWaterTailDown", "PassiveObject/Character/Mage/Particle/ATMagicBallWaterTail1.ptl", obj);
	particleCreater.Restart(0);
	obj.sq_AddObjectParticleCreater("Particle/ATMagicBallWaterTailDown1.ptl");
	obj.sq_AddObjectParticleCreater("Particle/ATMagicBallWaterTailDown2.ptl");
}


// 마법구체 - 화속성
function setCustomData_po_ATMagicBallFireDown(obj, receiveData)
{
	if(!obj)
		return;

	local horizonAngle = receiveData.readFloat();
	local verticalAngle = receiveData.readFloat();

	if (sq_BinaryGetReadSize() < receiveData.getSize())
	{
		// 공격력 셋팅
		local attackBonusRate = receiveData.readDword();
		local attackInfo = sq_GetCurrentAttackInfo(obj);
		sq_SetCurrentAttackBonusRate(attackInfo, attackBonusRate);
		sq_SetCurrentAttackInfo(obj,sq_GetCurrentAttackInfo(obj));
	}
	
	// 파티클의 이동 각도를 조절함
	obj.sq_SetMoveParticle("Particle/ATMagicBallFireMoveDown.ptl", horizonAngle, verticalAngle);
	local particleCreater = obj.sq_var.GetparticleCreaterMap("ATMagicBallNoneTail", "PassiveObject/Character/Mage/Particle/ATMagicBallFireTail1.ptl", obj);
	particleCreater.Restart(0);
	obj.sq_AddObjectParticleCreater("Particle/ATMagicBallFireTailDown1.ptl");
	obj.sq_AddObjectParticleCreater("Particle/ATMagicBallFireTailDown2.ptl");
}

// 마법구체 - 무속성
function setCustomData_po_ATMagicBallNoneDown(obj, receiveData)
{
	if(!obj)
		return;
	local horizonAngle = receiveData.readFloat();
	local verticalAngle = receiveData.readFloat();

	if (sq_BinaryGetReadSize() < receiveData.getSize())
	{
		// 공격력 셋팅
		local attackBonusRate = receiveData.readDword();
		local attackInfo = sq_GetCurrentAttackInfo(obj);
		sq_SetCurrentAttackBonusRate(attackInfo, attackBonusRate);		
	}
	
	// 파티클의 이동 각도를 조절함
	obj.sq_SetMoveParticle("Particle/ATMagicBallNoneMoveDown.ptl", horizonAngle, verticalAngle);
	local particleCreater = obj.sq_var.GetparticleCreaterMap("ATMagicBallNoneTail", "PassiveObject/Character/Mage/Particle/ATMagicBallNoneTail.ptl", obj);
	particleCreater.Restart(0);
	obj.sq_AddObjectParticleCreater("Particle/ATMagicBallNoneTailDown.ptl");
	
	local mage = obj.getTopCharacter();
	if (!mage)
		return;
		
	// 기본기 숙련 적용
	mage.applyBasicAttackUp(sq_GetCurrentAttackInfo(obj),mage.getState());	
	sq_SetCurrentAttackInfo(obj,sq_GetCurrentAttackInfo(obj));
}



// 적이 연속 마법구(화속성)에 맞음.
// 폭발 생성
function onAttack_po_ATMagicBallFireDownMultiShot(obj, damager, boundingBox, isStuck)
{
	if(!obj)
		return 0;
	createFireExplosion(obj, damager, boundingBox, isStuck, 24281);
	return 0;
}


// 적이 평타 마법구(화속성)에 맞음.
// 폭발 생성
function onAttack_po_ATMagicBallFireDown(obj, damager, boundingBox, isStuck)
{
	if(!obj)
		return 0;

	createFireExplosion(obj, damager, boundingBox, isStuck, 24214);
	return 0;
}


// 적이 연속 마법구(수속성)에 맞음.
// 폭발 생성
function onAttack_po_ATMagicBallWaterDownMultiShot(obj, damager, boundingBox, isStuck)
{
	if(!obj)
		return 0;
	// 평타 수속성
	createWaterExplosion(obj, damager, boundingBox, isStuck, 24282);
	return 0;
}


// 적이 평타 마법구(수속성)에 맞음.
// 폭발 생성
function onAttack_po_ATMagicBallWaterDown(obj, damager, boundingBox, isStuck)
{
	if(!obj)
		return 0;
	// 평타 수속성
	createWaterExplosion(obj, damager, boundingBox, isStuck, 24215);
	return 0;
}


// 적이 연속 마법구(명속성)에 맞음.
// 폭발 생성
function onAttack_po_ATMagicBallLightDownMultiShot(obj, damager, boundingBox, isStuck)
{
	if(!obj)
		return 0;
	// 평타 명속성
	createLightExplosion(obj, damager, boundingBox, isStuck, 24283);
	return 0;
}



// 적이 평타 마법구(명속성)에 맞음.
// 폭발 생성
function onAttack_po_ATMagicBallLightDown(obj, damager, boundingBox, isStuck)
{
	if(!obj)
		return 0;
	// 평타 명속성
	createLightExplosion(obj, damager, boundingBox, isStuck, 24216);
	return 0;
}


