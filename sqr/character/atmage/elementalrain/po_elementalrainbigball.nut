// 마법구체 - 명속성
function setCustomData_po_ATElementalRainBigBall(obj, receiveData)
{
	if(!obj)
		return;
	// 마지막 큰 마법구의 공격력 셋팅
	local attackBonusRate = receiveData.readDword();
	local attackInfo = sq_GetCurrentAttackInfo(obj);
	local mage = obj.getTopCharacter();
	if (mage)
		attackInfo.setElement(mage.getThrowElement());
		
	sq_SetCurrentAttackBonusRate(attackInfo, attackBonusRate);	
	sq_SetCurrentAttackInfo(obj,attackInfo);
	
		
	// 크로니클 아이템에 의해서 발사각도가 변경됨
	local mage = obj.getTopCharacter();
	if (!mage) return;
	
	local angle = sq_GetIntData(mage, SKILL_ELEMENTAL_RAIN, 6);
	
	// 파티클의 이동 설정
	obj.sq_SetMoveParticle("Particle/ATElementalRainBigBall.ptl", 0.0, -angle.tofloat());
}

function onAttack_po_ATElementalRainBigBall(obj, damager, boundingBox, isStuck)
{
	if (!obj)
		return 0;
	return 0;
}


function procAppend_po_ATElementalRainBigBall(obj)
{
	if(!obj)
		return;
	if (sq_GetZPos(obj) < 16)
	{
		if (obj.isMyControlObject())
		{
			local mage = obj.getTopCharacter();
			mage = sq_ObjectToSQRCharacter(mage);
			
			if (mage)
			{
				// 마지막 폭발 데미지 얻어오기
				local skill = sq_GetSkill(mage, SKILL_ELEMENTAL_RAIN);
				local attackBonusRate = mage.sq_GetBonusRateWithPassive(SKILL_ELEMENTAL_RAIN, STATE_ELEMENTAL_RAIN, 2, 1.0);
				
				
				// 아이템에 의한 기능 추가
				// 마지막 폭발의 사이즈를 변경할 수 있는 기능임
				local sizeRate = sq_GetIntData(mage, SKILL_ELEMENTAL_RAIN, 4);
				
				// 마지막 폭발 오브젝트를 생성한다.
				sq_BinaryStartWrite();
				sq_BinaryWriteDword(attackBonusRate);
				sq_BinaryWriteWord(sizeRate);
				sq_SendCreatePassiveObjectPacket(obj, 24220, 0, 0, 1, 0, obj.getDirection());
			}
			
			// 오브젝트 소멸
			sq_SendDestroyPacketPassiveObject(obj);
		}
	}
}

