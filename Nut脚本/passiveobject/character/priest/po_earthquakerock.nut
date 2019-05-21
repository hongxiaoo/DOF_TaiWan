
function setCustomData_po_EarthQuakeRock(obj,reciveData)
{		
	local currentIndex = reciveData.readWord();
	local gab		   = reciveData.readWord();
	local dmg = reciveData.readDword();
	
	if(EARTHQUAKE_ROCK_MAX < currentIndex)
		currentIndex = EARTHQUAKE_ROCK_MAX;		
	
	obj.sq_var.setInt(0,currentIndex); //currentIndex
	obj.sq_var.setInt(1,gab); // gap	
	obj.sq_var.setInt(2,dmg);
	
	local pAttack = sq_GetCurrentAttackInfo(obj);
	sq_setAttackInfoType(obj,ATTACKTYPE_MAGICAL);
	sq_SetCurrentAttackBonusRate(pAttack, dmg);
}


function onKeyFrameFlag_po_EarthQuakeRock(obj,flagIndex)
{	
	if(obj.sq_isMyControlObject()) { // 진동,번쩍 이펙트는 나에게만 보인다.
		if(flagIndex == 1) {
			obj.sq_setShake(obj,3,150);				
		}				
		if(flagIndex == 2) {
			local currentIndex  = obj.sq_var.getInt(0);
			local gap			= obj.sq_var.getInt(1);
			local dmg			= obj.sq_var.getInt(2);
			
			if(currentIndex > 1)
			{					
				local newIndex = currentIndex-1;
				sq_BinaryStartWrite();
				sq_BinaryWriteWord(newIndex); // 패시브 재귀 생성 갯수
				sq_BinaryWriteWord(gap);
				sq_BinaryWriteDword(dmg);				
				sq_SendCreatePassiveObjectPacketFromPassive(obj,24103,0,gap,0,0,obj.getDirection());
			}
		}
	}
	return true;
}

function onEndCurrentAni_po_EarthQuakeRock(obj)
{
	sq_SendDestroyPacketPassiveObject(obj);
}

