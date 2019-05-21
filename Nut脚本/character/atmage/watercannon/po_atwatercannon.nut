function setCustomData_po_ATWaterCannon(obj, receiveData)
{
	if (!obj)
		return;

	// 패킷 데이터 받기
	local attackBonusRate = receiveData.readDword();
	local sizeRate = receiveData.readWord();
	
	local xVelocity = receiveData.readWord();
	local distance = receiveData.readWord();
	
	obj.getVar().clear_vector();
	obj.getVar().push_vector(0);
	
	
	obj.getVar("attack").clear_vector();
	obj.getVar("attack").push_vector(attackBonusRate);

	// 이동 및 효과 파티클의 설정
	//obj.sq_SetMoveParticle("Particle/ATWaterCannonMove.ptl", 0.0, 0.0);	
	//local particleCreater = obj.sq_var.GetparticleCreaterMap("ATWaterCannon",
			//"PassiveObject/Character/Mage/Particle/ATWaterCannonTail.ptl", obj);
	//particleCreater.Restart(0);
	//obj.sq_AddObjectParticleCreater("Particle/ATWaterCannonTail.ptl");
	//obj.sq_SetObjectParticlePos(0, 1, 0);
	
	//local distance = 400; // 나가는 거리
	
	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj);
	local z = sq_GetZPos(obj);
	
	
	obj.getVar("dis").clear_vector();
	
	obj.getVar("dis").push_vector(x);
	obj.getVar("dis").push_vector(y);
	obj.getVar("dis").push_vector(z);
	obj.getVar("dis").push_vector(distance);
	
	//local arriveTime = distance;
	local arriveTime = (distance * 800) / xVelocity;
	

	obj.getVar("arriveTime").clear_vector();
	obj.getVar("arriveTime").push_vector(arriveTime);
	obj.getVar("arriveTime").push_vector(arriveTime);

	// 패킷으로 받은 공격력 셋팅
	local attackInfo = sq_GetCurrentAttackInfo(obj);
	if (attackInfo)
		sq_SetCurrentAttackBonusRate(attackInfo, attackBonusRate);

	// 물대포의 크기를 조절함.
	local currentAni = sq_GetCurrentAnimation(obj);
	obj.getVar("rate").clear_vector();
	obj.getVar("rate").push_vector(sizeRate);
	
	sizeRate = sizeRate.tofloat() / 100.0;
	currentAni.setImageRateFromOriginal(sizeRate, sizeRate);
	currentAni.setAutoLayerWorkAnimationAddSizeRate(sizeRate);
	
	sq_SetAttackBoundingBoxSizeRate(currentAni, sizeRate, sizeRate, sizeRate);
	
}

function setState_po_ATWaterCannon(obj, state, datas)
{
	if (!obj)
		return;
}

function procAppend_po_ATWaterCannon(obj)
{
	if (!obj)
		return;		
	
	local pAni = obj.getCurrentAnimation();
	local frmIndex = sq_GetAnimationFrameIndex(pAni);
	local currentT = sq_GetCurrentTime(pAni);

	local objX = sq_GetXPos(obj);
	local objY = sq_GetYPos(obj);
	local parentObj = obj.getParent();
	
	if(!parentObj)
	{
		if(obj.isMyControlObject())
		{
			sq_SendDestroyPacketPassiveObject(obj);
			return;
		}
	}
		
		
	local fireT = obj.getVar("arriveTime").get_vector(0);
	
	local srcX = obj.getVar("dis").get_vector(0); // 시작x
	local srcY = obj.getVar("dis").get_vector(1); // 시작y
	local srcZ = obj.getVar("dis").get_vector(2); // 시작z
	    	
	local distance = obj.getVar("dis").get_vector(3); // 총 이동거리
	
	local v = sq_GetUniformVelocity(0, distance, currentT, fireT);
	
	local dstX = sq_GetDistancePos(srcX, obj.getDirection(), v);
	local dstY = srcY;
	
	sq_setCurrentAxisPos(obj, 0, dstX);
	
	local remainT = obj.getVar("arriveTime").get_vector(1);
	if(currentT >= remainT)
	{
		if(obj.isMyControlObject())
		{
			sq_SendDestroyPacketPassiveObject(obj);
		}
	}	
	
		
}

function onChangeSkillEffect_po_ATWaterCannon(obj, skillIndex, reciveData)
{
	if (!obj)
		return;
}

function onDestroyObject_po_ATWaterCannon(obj, object)
{
	if (!obj)
		return;
}

function onKeyFrameFlag_po_ATWaterCannon(obj, flagIndex)
{
}

function onEndCurrentAni_po_ATWaterCannon(obj)
{
	if (!obj)
		return;
}

function onAttack_po_ATWaterCannon(obj, damager, boundingBox, isStuck)
{
	if (!obj)
		return 0;
		
	if(!damager)
		return 0;
		
	// PassiveObject/Character/Mage/Animation/ATWaterCannon/explode_normal.ani	

	local attackRate = obj.getVar("attack").get_vector(0);
	local sizeRate = obj.getVar("rate").get_vector(0) - 30;
	local group = sq_GetGroup(damager);
	local id = sq_GetUniqueId(damager);
	
	
	//local x = sq_GetCenterXPos(boundingBox);
	//local y = damager.getYPos() + 1;
	//local z = sq_GetCenterZPos(boundingBox);
	
	local x = sq_GetXPos(obj);
	local y = sq_GetYPos(obj) + 1;
	local z = sq_GetZPos(obj);
	
	local parentObj = obj.getParent();

	if(obj.isMyControlObject())
	{
		local cnt = obj.getVar().get_vector(0);
		
		if(!cnt)
		{
			sq_BinaryStartWrite();
			sq_BinaryWriteDword(attackRate);
			sq_BinaryWriteDword(group);
			sq_BinaryWriteDword(id);
			sq_BinaryWriteDword(sizeRate);
			
			print(" exp create:" + cnt);
			
			obj.getVar().set_vector(0, cnt + 1);
			sq_SendCreatePassiveObjectPacketPos(parentObj, 24256, 0, x, y, z);
		}		
	}
	
	//local sizeRateFloat = sizeRate.tofloat() / 100.0a
	//local x = sq_GetCenterXPos(boundingBox);
	//local y = damager.getYPos();
	//local z = sq_GetCenterZPos(boundingBox);
	//local isAutoDestroy = true;
	//
	//local ani = sq_CreateAnimation("","PassiveObject/Character/Mage/Animation/ATWaterCannon/explode_normal.ani");
	//
	//if(!ani)
		//return 0;	
	//
	//local pooledObj = sq_CreatePooledObject(ani,isAutoDestroy);
//
	//local hitAni = sq_GetCurrentAnimation(pooledObj);
	//hitAni.Proc();
	//hitAni.setImageRate(sizeRateFloat, sizeRateFloat);
	////hitAni.resize(sizeRateFloat, sizeRateFloat);
	//
	//pooledObj.setCurrentPos(x,y + 1,z);
	//sq_SetCurrentDirection(pooledObj, obj.getDirection());
	//
	//sq_AddObject(obj, pooledObj, OBJECTTYPE_DRAWONLY, false);
	
	
	return 0;
}

function onAfterAttack_po_ATWaterCannon(obj, damager, boundingBox, isStuck)
{
	if (!obj)
		return 0;
		
	if(obj.isMyControlObject())
	{
		sq_SendDestroyPacketPassiveObject(obj);	
	}
	
	return 0;
}



function getCustomHitEffectFileName_po_ATWaterCannon(obj, isAttachOnDamager)
{
	return "";
}


