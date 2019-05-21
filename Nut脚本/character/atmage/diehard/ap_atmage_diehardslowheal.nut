


function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_atmage_diehard_heal")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_atmage_diehard_heal")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_atmage_diehard_heal")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_atmage_diehard_heal")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_atmage_diehard_heal")
	appendage.sq_AddFunctionName("onSetHp", "onSetHp_appendage_atmage_diehard_heal")
}


function sq_AddEffect(appendage)
{
	if(!appendage)
		return;
	appendage.sq_AddEffectFront("Character/Mage/Effect/Animation/ATDieHard/02_looping_dodge.ani");
}




function proc_appendage_atmage_diehard_heal(appendage)
{
	if(!appendage) {
		return;
	}
	
	//print(" proc");
	
	local parentObj = appendage.getParent();
	
	local currentT = appendage.getTimer().Get();
	local t = appendage.sq_var.get_timer_vector(0);
	//
	local state_ = appendage.sq_var.get_vector(VECTOR_I_STATE);	
	local rebirthTime_ = appendage.sq_var.get_vector(VECTOR_I_REBIRTH_TIME);
	
	if(!parentObj)
	{
		appendage.setValid(false);
		return;
	}	
	
	local changeHp_ = appendage.getVar("changehp").get_vector(0);
	local changeTime_ = appendage.getVar("changehp").get_vector(2);
	local changedHp_ = appendage.getVar("changehp").get_vector(3);
	
	//print( " changeTime_:" + currentT);
	local currentChangeHp = sq_GetUniformVelocity(0, changeHp_, currentT, changeTime_);	
	
	local sqrObj = sq_GetCNRDObjectToSQRCharacter(parentObj);
	
	if(sqrObj.getHp() <= 0)
	{
		appendage.setValid(false);
		return;
	}
	
	if (currentChangeHp != changedHp_)
	{
		//  더 변화시킬 양이 있으면 처리
		local hp = currentChangeHp - changedHp_;
		changedHp_ = currentChangeHp;
		appendage.getVar("changehp").set_vector(3, changedHp_);
		
		if(sqrObj)
		{
			//print(" sqrObj.getHp():" + sqrObj.getHp() + " hp:" + hp);
			if(sqrObj.isMyControlObject())
			{
				sqrObj.sq_SendSetHpPacket(sqrObj.getHp() + hp, true, parentObj);
			}
		}
	}
	
	if(changeTime_ <= currentT)
	{
		if(parentObj)
		{
			if(parentObj.isMyControlObject())
			{ // hp동기화
				//local parentHp = parentObj.getHp();
				//sq_BinaryStartWrite();
				//sq_BinaryWriteDword(parentHp); // 
				//sq_SendChangeSkillEffectPacket(parentObj, SKILL_DIEHARD);
			}
		}
		appendage.setValid(false);
	}
	
	if(parentObj.getHp() >= parentObj.getHpMax())
	{
		if(parentObj)
		{
			if(parentObj.isMyControlObject())
			{ // hp동기화
				//local parentHp = parentObj.getHp();
				//sq_BinaryStartWrite();
				//sq_BinaryWriteDword(parentHp); // 
				//sq_SendChangeSkillEffectPacket(parentObj, SKILL_DIEHARD);
			}
		}
		appendage.setValid(false);
	}
	
	//print(" changeTime_:" + changeTime_ + " currentT:" + currentT);
	
}


function onStart_appendage_atmage_diehard_heal(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();		


	appendage.sq_var.clear_timer_vector();
	appendage.sq_var.push_timer_vector();
	appendage.sq_var.push_timer_vector();
	
	appendage.sq_var.clear_vector();
	appendage.sq_var.push_vector(0);
	appendage.sq_var.push_vector(0);
	
	local t = appendage.sq_var.get_timer_vector(0);
	t.setParameter(400, -1);
	t.resetInstant(0);

	local sqrObj = sq_GetCNRDObjectToSQRCharacter(obj);
	
	if(sqrObj)
	{
	}
}


function prepareDraw_appendage_atmage_diehard_heal(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}




function onEnd_appendage_atmage_diehard_heal(appendage)
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

function onSetHp_appendage_atmage_diehard_heal(appendage, hp, attacker)
{
	if(!appendage)
		return hp;
		
	local obj = appendage.getParent();
	
	//local dst_hp = hp;
	local org_hp = -1;

	local state_ = appendage.sq_var.get_vector(VECTOR_I_STATE);	

	if(obj.getHp() > hp)
	{	 // 데미지라면..
		//local damage = obj.getHp() - hp; // 입은 데미지만큼 증가하여야할 회복최대수치를 깎아줍니다.
		//local maxHp = appendage.getVar("changehp").get_vector(0);
		//print(" damage:" + damage + " obj.getHp():" + obj.getHp());
		//appendage.getVar("changehp").set_vector(0, maxHp - damage);
		
		//0. 피격시 받는 데미지 증가율(%)
		local sqrObj = sq_GetCNRDObjectToSQRCharacter(obj);
		if(sqrObj)
		{
			local isConvert = true;
			
			local dieHardAppendage = CNSquirrelAppendage.sq_GetAppendage(sqrObj, "Character/ATMage/DieHard/ap_ATMage_DieHard.nut");
			
			if(dieHardAppendage)
			{
				local dieHardState = dieHardAppendage.sq_var.get_vector(VECTOR_I_STATE);
				
				if(dieHardState != STATE_SLOW_HEAL)
				{
					isConvert = false;
					if(hp < 0)
					{
						hp = 1;
						print( " heal hp:" + hp);
						
						if(sqrObj.isMyControlObject())
						{
							sq_ReleaseActiveStatus(sqrObj, ACTIVESTATUS_POISON);
							sq_ReleaseActiveStatus(sqrObj, ACTIVESTATUS_BLEEDING);
						}
						
					}
				}
			}
			
			if(isConvert)
			{
				if(sqrObj.isMyControlObject())
				{
					//local increaseDamageRate = sq_GetIntData(sqrObj, SKILL_DIEHARD, SKL_STATIC_INT_IDX_0); 
					//local damage = sqrObj.getHp() - hp; // 입은 데미지만큼 증가하여야할 회복최대수치를 깎아줍니다.
					//increaseDamageRate.tofloat() / 100.0;
					//local addDamage = damage.tofloat() * increaseDamageRate.tofloat() / 100.0;
					//hp = hp - addDamage;
					
				}
			}
		}
		return hp;
	}
	
	return -1;
}




// 어벤져 각성 변신의 끝부분
function isEnd_appendage_atmage_diehard_heal(appendage)
{
	if(!appendage)
		return false;
	local T = appendage.getTimer().Get();	
	
	return false;
}