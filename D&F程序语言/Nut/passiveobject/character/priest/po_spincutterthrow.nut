
//S_SPINCUTTER_THROW <- 0
//S_SPINCUTTER_RECALL <- 1
//S_SPINCUTTER_ARRIVAL <- 2


//function setCustomData_po_SpincutterThrow(obj, data, size)
function setCustomData_po_SpincutterThrow(obj,reciveData)
{
	//sq_BinaryStartRead(data);		
	//local rate = sq_BinaryGetDWord();
	
	local rate = reciveData.readDword();
		
	
	local pAttack = sq_GetCurrentAttackInfo(obj);
	sq_SetCurrentAttackBonusRate(pAttack, rate);
//	sq_SetCurrentAttacknBackForce(pAttack, 800);
//	sq_SetCurrentAttacknUpForce(pAttack, 300);
//	sq_SetCurrentAttackDirection(pAttack, ATTACK_DIRECTION_UP);
//	sq_SetCurrentAttackeDamageAct(pAttack, DAMAGEACT_DAMAGE);
}

function setState_po_SpincutterThrow(obj, state, datas)
{
}

function procAppend_po_SpincutterThrow(obj)
{
	local pChr = obj.getTopCharacter();
	
	if(!pChr)
	{
		sq_SendDestroyPacketPassiveObject(obj);
		return;
	}
	
	local state = pChr.getState();	
	local substate = pChr.getSkillSubState();
	local pAni = pChr.getCurrentAnimation();
    local frmIndex = pAni.GetCurrentFrameIndex();
    local bEnd = sq_IsEnd(pAni);
    local isMyControl = obj.isMyControlObject();
    
	
	if(state != STATE_SPINCUTTER)
	{
		sq_SendDestroyPacketPassiveObject(obj);
		return;
	}
	
    if(substate != S_SPINCUTTER_THROW) {
		sq_SendDestroyPacketPassiveObject(obj);
		return;
    }
}


function onDestroyObject_po_SpincutterThrow(obj, object)
{
}

