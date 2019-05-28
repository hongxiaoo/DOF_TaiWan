
//function setCustomData_po_DisasterExp(obj, data, size)
function setCustomData_po_DisasterExp(obj,reciveData)
{
	local rate = reciveData.readDword();	
	local pAttack = sq_GetCurrentAttackInfo(obj);
	sq_SetCurrentAttackBonusRate(pAttack, rate);
	
}

function setState_po_DisasterExp(obj, state, datas)
{
}

function procAppend_po_DisasterExp(obj)
{
	local pChr = obj.getTopCharacter();
	
	if(!pChr)
	{
		sq_SendDestroyPacketPassiveObject(obj);
		return;
	}
	
	local state = pChr.getState();	
	local substate = pChr.getSkillSubState();
	//local pAni = pChr.getCurrentAnimation();
	local pAni = sq_GetCurrentAnimation(obj);
    local frmIndex = pAni.GetCurrentFrameIndex();
    local bEnd = sq_IsEnd(pAni);
    local isMyControl = obj.isMyControlObject();
    
	
	if(bEnd)
	{
		sq_SendDestroyPacketPassiveObject(obj);
		return;
	}
}


function onDestroyObject_po_DisasterExp(obj, object)
{
}

