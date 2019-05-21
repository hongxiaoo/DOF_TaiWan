

// ********** ATFireRoad1 ********** 
function setCustomData_po_ATFireRoad1(obj, receiveData)
{
	local pauseTime = receiveData.readWord();
	local damage1 = receiveData.readDword();
	local damage2 = receiveData.readDword();
	local maxHit = receiveData.readByte();
	local number = receiveData.readByte();		// 생성된 번째수
	local sizeRate = receiveData.readWord();	// 확대율
	
	sq_SetPause(obj, PAUSETYPE_OBJECT, pauseTime);
	local attackInfo = sq_GetCurrentAttackInfo(obj);
	
	sq_SetCurrentAttackBonusRate(attackInfo, damage1);
	obj.sq_var.setInt(0, damage2);

	obj.sq_SetMaxHitCounterPerObject(maxHit);
	obj.sq_PlaySound("FIREROAD_01");	
	
	// 파이어로드 범위를 확대하는 코드
	// 아이템과 연동되는 기능
	if (sizeRate != 100)
	{
		local animation = sq_GetCurrentAnimation(obj);
		if (!animation) return;
		local size = sizeRate.tofloat() / 100.0;
		animation.setImageRateFromOriginal(size, size);
		animation.setAutoLayerWorkAnimationAddSizeRate(size);
		sq_SetAttackBoundingBoxSizeRate(animation, size, size, size);
	}
}


function procAppend_po_ATFireRoad1(obj)
{
	local animation = sq_GetCurrentAnimation(obj);
	local frameIndex = sq_GetAnimationFrameIndex(animation);

	// 부모 오브젝트를 구해서, skillSubState가 0이 아니라면, 2번째 공격 프레임으로 변경함.
	// 혹은 부모의 state가 STATE_FIRE_ROAD가 아니라면 2번째 공격프레임으로 변경함
	if (frameIndex == 15)
	{
		local state = obj.sq_GetParentState();
		local skillSubState = obj.sq_GetParentSkillSubState();

		if (skillSubState == 1 || state == -1 || state != STATE_FIRE_ROAD)
		{
			local attackInfo = sq_GetCustomAttackInfo(obj, 0);
			sq_SetCurrentAttackInfo(obj, attackInfo);

			// 저장해놓은 데미지를 셋팅함
			local damage = obj.sq_var.getInt(0);	
			attackInfo = sq_GetCurrentAttackInfo(obj);
			sq_SetCurrentAttackBonusRate(attackInfo, damage);
			sq_SetAnimationCurrentTimeByFrame(animation, 16, true);
			obj.sq_PlaySound("FIREROAD_02");
		}
	}
}

function onKeyFrameFlag_po_ATFireRoad1(obj)
{
}


// 에니메이션이 끝났다면 삭제한다
function onEndCurrentAni_po_ATFireRoad1(obj)
{
	if(!obj)
		return;
	if(obj.isMyControlObject())
	{
		sq_SendDestroyPacketPassiveObject(obj);
	}
}












// ********** ATFireRoad2 ********** 
function setCustomData_po_ATFireRoad2(obj, receiveData)
{
	local pauseTime = receiveData.readWord();
	local damage1 = receiveData.readDword();
	local damage2 = receiveData.readDword();
	local maxHit = receiveData.readByte();
	local number = receiveData.readByte();		// 생성된 번째수
	local sizeRate = receiveData.readWord();	// 확대율
		
	sq_SetPause(obj, PAUSETYPE_OBJECT, pauseTime);
	local attackInfo = sq_GetCurrentAttackInfo(obj);
	
	sq_SetCurrentAttackBonusRate(attackInfo, damage1);
	obj.sq_var.setInt(0, damage2);

	obj.sq_SetMaxHitCounterPerObject(maxHit);
	obj.sq_PlaySound("FIREROAD_01");
	
	
	// 파이어로드 범위를 확대하는 코드
	// 아이템과 연동되는 기능
	if (sizeRate != 100)
	{
		local animation = sq_GetCurrentAnimation(obj);
		if (!animation) return;
		local size = sizeRate.tofloat() / 100.0;
		animation.setImageRateFromOriginal(size, size);
		animation.setAutoLayerWorkAnimationAddSizeRate(size);
		sq_SetAttackBoundingBoxSizeRate(animation, size, size, size);
	}
}


function procAppend_po_ATFireRoad2(obj)
{	
	local animation = sq_GetCurrentAnimation(obj);
	local frameIndex = sq_GetAnimationFrameIndex(animation);
	

	// 부모 오브젝트를 구해서, skillSubState가 0이 아니라면, 2번째 공격 프레임으로 변경함.
	// 혹은 부모의 state가 STATE_FIRE_ROAD가 아니라면 2번째 공격프레임으로 변경함
	if (frameIndex == 15)	{
		local state = obj.sq_GetParentState();
		local skillSubState = obj.sq_GetParentSkillSubState();

		if (skillSubState == 1 || state == -1 || state != STATE_FIRE_ROAD)
		{
			local attackInfo = sq_GetCustomAttackInfo(obj, 0);
			sq_SetCurrentAttackInfo(obj, attackInfo);

			// 저장해놓은 데미지를 셋팅함
			local damage = obj.sq_var.getInt(0);	
			attackInfo = sq_GetCurrentAttackInfo(obj);
			sq_SetCurrentAttackBonusRate(attackInfo, damage);
			sq_SetAnimationCurrentTimeByFrame(animation, 16, true);
			obj.sq_PlaySound("FIREROAD_02");
		}
	}
}

function onKeyFrameFlag_po_ATFireRoad2(obj)
{
}


// 에니메이션이 끝났다면 삭제한다
function onEndCurrentAni_po_ATFireRoad2(obj)
{
	sq_SendDestroyPacketPassiveObject(obj);
}