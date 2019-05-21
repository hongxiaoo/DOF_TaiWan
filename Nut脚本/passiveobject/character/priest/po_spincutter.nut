
//S_SPINCUTTER_THROW <- 0
//S_SPINCUTTER_RECALL <- 1
//S_SPINCUTTER_ARRIVAL <- 2

S_PO_SPINCUTTER_THROW <- 10
S_PO_SPINCUTTER_RECALL <- 11

VECTOR_I_RECALL_FLAG <- 0
VECTOR_I_RECALL_STD_X <- 1
VECTOR_I_MULTI_HIT_COUNT <- 2
VECTOR_I_ATTACK_RATE <- 3 // °ø°Ý·Â


//function setCustomData_po_Spincutter(obj, data, size)
function setCustomData_po_Spincutter(obj,reciveData)
{
	//sq_BinaryStartRead(data);		
	//local multi_count = sq_BinaryGetDWord();
	//local rate = sq_BinaryGetDWord();
	local multi_count = reciveData.readDword();
	local rate = reciveData.readDword();
	
	
	
	obj.sq_var.push_vector(0);
	obj.sq_var.push_vector(0);
	obj.sq_var.push_vector(0);
	obj.sq_var.push_vector(0);
	obj.sq_var.push_vector(0);
	
	obj.sq_var.set_vector(VECTOR_I_MULTI_HIT_COUNT, multi_count);	
	obj.sq_var.set_vector(VECTOR_I_ATTACK_RATE, rate);
	
	local attackInfo = sq_GetCustomAttackInfo(obj, 0);
	sq_SetCurrentAttackInfo(obj, attackInfo);
	
	local pAttack = sq_GetCurrentAttackInfo(obj);
	sq_SetCurrentAttackBonusRate(pAttack, rate);
	
	
	local pAni = obj.getCurrentAnimation();	
	local initDelay = 0;
	local attackTime = pAni.getDelaySum(false);
	local hitCnt = obj.sq_var.get_vector(VECTOR_I_MULTI_HIT_COUNT);

	local term = 500 / hitCnt;
	//print("term = attackTime / hitCnt :" + attackTime);
	
	obj.timer_.setParameter(term, hitCnt);
	obj.timer_.resetInstant(initDelay);
	
	//print("\n eType:" + eType);
	
}

function setState_po_Spincutter(obj, state, datas)
{
	local passiveState = state;
	
	
	if(passiveState == S_PO_SPINCUTTER_THROW) {
	}
	else if(passiveState == S_PO_SPINCUTTER_RECALL) {
		local pA = obj.getCustomAnimation(0);
		
		
		local objectX = sq_GetVectorData(datas, 0); // xpos
		
		obj.setCurrentAnimation(pA);
		obj.sq_var.set_vector(VECTOR_I_RECALL_STD_X, objectX);
		
		//print("objectx:" + objectX + "getxpos" + obj.getXPos());
		
		local attackInfo = sq_GetDefaultAttackInfo(obj);
		sq_SetCurrentAttackInfo(obj, attackInfo);		
		local rate = obj.sq_var.get_vector(VECTOR_I_ATTACK_RATE);
		
		local current_attack_info = sq_GetCurrentAttackInfo(obj);
		//print(" spincutter attack rate:" + rate);
		sq_SetCurrentAttackBonusRate(current_attack_info, rate);
		
		
		local pAni = obj.getCurrentAnimation();	
		
		local initDelay = 0;
		local attackTime = pAni.getDelaySum(false);
		local hitCnt = obj.sq_var.get_vector(VECTOR_I_MULTI_HIT_COUNT);
		//local hitCnt = 6;
		local term = attackTime / hitCnt;
		
		obj.timer_.setParameter(term, hitCnt);
		obj.timer_.resetInstant(initDelay);
		
		//print("setCustomData_po_Spincutter x:" + obj.getXPos());
		
				
	}
}

function procAppend_po_Spincutter(obj)
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


	
    if(substate == S_SPINCUTTER_THROW) {
    }
    else if(substate == S_SPINCUTTER_RECALL) {
    	local flag = obj.sq_var.get_vector(VECTOR_I_RECALL_FLAG);
    	if(flag == 0) {
	    		obj.sq_var.set_vector(VECTOR_I_RECALL_FLAG, 1);
	    		if(isMyControl == true) {
	    			// vector
	    			local pIntVec = sq_GetGlobalIntVector();
	    			sq_IntVectorClear(pIntVec);
	    			sq_IntVectorPush(pIntVec, obj.getXPos());
	    			
					//print("sq_IntVectorPush:" + obj.getXPos());

	    			obj.addSetStatePacket(S_PO_SPINCUTTER_RECALL, pIntVec, STATE_PRIORITY_AUTO, false, "");
	    			//sq_addSetStatePacketColObj(obj, S_PO_SPINCUTTER_RECALL);
	    		} 
    	}
    	else {    	
    		if(obj.getState() == S_PO_SPINCUTTER_RECALL) {
    			local dstX = sq_GetDistancePos(pChr.getXPos(), obj.getDirection(), 80);
    			//local dstX = pChr.getXPos();
    			local currentT = sq_GetCurrentTime(pAni);
				local totalT = pAni.getDelaySum(false);
				local srcX = obj.sq_var.get_vector(VECTOR_I_RECALL_STD_X);
				local posX = sq_GetAccel(srcX, dstX, currentT, totalT, false);
				//local posX = sq_GetAccel(srcX, dstX, currentT, totalT - 100, false);
				local posY = obj.getYPos();
				local posZ = obj.getZPos();
				obj.setCurrentPos(posX, posY, posZ);
				
				//print("src x:" + srcX + "dst x:" + dstX);
    		}
    	}
    	
    	//local pObjAni = obj.getCurrentAnimation();
    	//local time = sq_GetCurrentTime(pObjAni);
    	//
		//if (obj.timer_.isOnEvent(time) == true)
			//obj.resetHitObjectList();
    	
    }
    else if(substate == S_SPINCUTTER_ARRIVAL) {
    	sq_SendDestroyPacketPassiveObject(obj);
    	return;
    }
    
	local pObjAni = obj.getCurrentAnimation();
	local time = sq_GetCurrentTime(pObjAni);
	
	if (obj.timer_.isOnEvent(time) == true) {
		//print("resetHitObjectList");
		obj.resetHitObjectList();    
	}

	
}


function onDestroyObject_po_Spincutter(obj, object)
{
}

