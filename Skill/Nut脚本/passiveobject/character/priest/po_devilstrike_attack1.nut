


function setCustomData_po_DevilStrike1(obj,reciveData)
{
	local rate = reciveData.readDword(); // °ø°Ý·Â(%)		
	
	local pAttack = sq_GetCurrentAttackInfo(obj);
	sq_SetCurrentAttackBonusRate(pAttack, rate);
}

function setState_po_DevilStrike1(obj, state, datas)
{
}

function procAppend_po_DevilStrike1(obj)
{
	local pChr = obj.getTopCharacter();
	
	if(!pChr)
	{
		sq_SendDestroyPacketPassiveObject(obj);
		return;
	}
	
	local state = pChr.getState();	
	local substate = pChr.getSkillSubState();
	local pAni = obj.getCurrentAnimation();
    local frmIndex = pAni.GetCurrentFrameIndex();
    local bEnd = sq_IsEnd(pAni);
    local isMyControl = obj.isMyControlObject();
    
	
    if(bEnd) {
		if(isMyControl) {
			sq_SendDestroyPacketPassiveObject(obj);
		}
		return;
    }
}


function onDestroyObject_po_DevilStrike1(obj, object)
{
}

