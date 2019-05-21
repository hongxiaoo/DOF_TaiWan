
S_PO_ATCLT_0 <- 10
S_PO_ATCLT_1 <- 11

function setCustomData_po_ATChainLightningTarget(obj, reciveData)
{

	if(!obj) return;
	
	local id = reciveData.readDword();
	
	local attack_time = reciveData.readDword();
	local attack_rate = reciveData.readDword();
	local multi_hit_num = reciveData.readDword();
	//local multi_hit_term = reciveData.readDword();
	
	local hitCnt = multi_hit_num;
	
	print( " hitCnt	:" + hitCnt);
	
	local object = sq_GetObjectByObjectId(obj, id);
	obj.sq_var.clear_obj_vector();
	obj.sq_var.push_obj_vector(object);
	
	
	local pAni = obj.getCurrentAnimation();	
	local initDelay = 0;

	local term = attack_time / hitCnt;
	
	obj.timer_.setParameter(term, -1);
	obj.timer_.resetInstant(initDelay);
	
	
	obj.getVar("state").clear_vector(); // state vector
	obj.getVar("state").push_vector(0);
	
	obj.getVar("hitCnt").clear_vector();
	obj.getVar("hitCnt").push_vector(hitCnt);
	obj.getVar("hitCnt").push_vector(1);
	
	obj.getVar("end").clear_vector();
	obj.getVar("end").push_vector(0);
	
	local pAttack = sq_GetCurrentAttackInfo(obj);
	sq_SetCurrentAttackBonusRate(pAttack, attack_rate);
	
	
	obj.getVar("state").clear_ct_vector();
	
	obj.getVar("state").push_ct_vector();
	local t = obj.getVar("state").get_ct_vector(0);
	t.Reset();
	t.Start(100000,0);
	
	if(obj.isMyControlObject())
	{
		sq_SendHitObjectPacket(obj,object,0,0,(sq_GetObjectHeight(object) / 2));
	}
	
	local currentT = 0;
	
	local isMyControl = obj.isMyControlObject();
	
	

	if(isMyControl) {
		local pIntVec = sq_GetGlobalIntVector();
		
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
		
		obj.addSetStatePacket(S_PO_ATCLT_0, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}
	

}

function setState_po_ATChainLightningTarget(obj, state, datas)
{

	if(!obj) return;

	local passiveState = state;
	
	obj.getVar("state").set_vector(0, passiveState);
	
	if(passiveState == S_PO_ATCLT_0) {

	}
	else if(passiveState == S_PO_ATCLT_1) {
		local pA = obj.getCustomAnimation(0);
		obj.setCurrentAnimation(pA);
	}

}


function procAppend_po_ATChainLightningTarget(obj)
{
	if(!obj)
		return;
		
	local pChr = obj.getTopCharacter();
	
	
	local state = obj.getVar("state").get_vector(0);

	//if(state != S_PO_ATCLT_0 ) {
		//return;
	//}
	
	if(state != S_PO_ATCLT_0 && state != S_PO_ATCLT_1)
		return;
	
	
	
	if(!pChr || obj.sq_var.get_obj_vector_size() != 1)
	{
		if(obj.isMyControlObject()) {
			if(state != S_PO_ATCLT_1)
			{
				local pIntVec = sq_GetGlobalIntVector();

				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);

				obj.addSetStatePacket(S_PO_ATCLT_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
				return;
			}
		}
	}
	
	if(!pChr)
	{
		if(obj.isMyControlObject())
			sq_SendDestroyPacketPassiveObject(obj);
			
		return;
	}
	
	local pTargetChr = obj.sq_var.get_obj_vector(0);
	
	
	if(pChr.getState() != STATE_CHAINLIGHTNING || !pTargetChr) {
		if(obj.isMyControlObject()) {
			if(state != S_PO_ATCLT_1)
			{
				local pIntVec = sq_GetGlobalIntVector();

				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);

				obj.addSetStatePacket(S_PO_ATCLT_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
				return;
			}
		}
	}	
	
	
	
	if(pTargetChr) 
	{
		local posX = pTargetChr.getXPos();
		local posY = pTargetChr.getYPos();
		local posZ = pTargetChr.getZPos() + (sq_GetObjectHeight(pTargetChr) / 2) - 25;
		
		sq_SetCurrentPos(obj, posX, posY, posZ);
	}
	
	
	local pObjAni = obj.getCurrentAnimation();
	
	/////////////////////////////////////////////////
	// 
	local substate = pChr.getSkillSubState();
	
	if(substate == SUB_STATE_ATCHAINLIGHTNING_2) {
		if(state == S_PO_ATCLT_0) {
			if(obj.isMyControlObject()) {
				local pIntVec = sq_GetGlobalIntVector();

				sq_IntVectorClear(pIntVec);
				sq_IntVectorPush(pIntVec, 0);

				obj.addSetStatePacket(S_PO_ATCLT_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
				
				//print(" obj.addSetStatePacket(S_PO_ATCL_1 ");
			}
			return;
		}
	}
	////////////////////////////////////////////
	
	if(pTargetChr)
	{
		local multiHitCnt = obj.getVar("hitCnt").get_vector(VECTOR_FLAG_0);
		local cnt = obj.getVar("hitCnt").get_vector(VECTOR_FLAG_1);
		
		
		if(cnt < multiHitCnt)
		{		
			local t = obj.getVar("state").get_ct_vector(0);
			local time = 0;
			
			if(t)
				time = t.Get();
			
			print( " multiHitCnt:" + multiHitCnt + " cnt:" + cnt);
			if (obj.timer_.isOnEvent(time) == true)
			{
				local value = obj.getVar("hitCnt").get_vector(VECTOR_FLAG_1);
				value = value + 1;		
				obj.getVar("hitCnt").set_vector(VECTOR_FLAG_1, value);
				if(obj.isMyControlObject())
				{
					sq_SendHitObjectPacket(obj,pTargetChr,0,0,(sq_GetObjectHeight(pTargetChr) / 2));
				}
			}
		}
	}
	
	if(state == S_PO_ATCLT_1)
	{
		if(obj.isMyControlObject())
		{
			local isend = obj.getVar("end").get_vector(0);
			if(obj.getVar("end").get_vector(0))
			{
				local multiHitCnt = obj.getVar("hitCnt").get_vector(VECTOR_FLAG_0);
				local cnt = obj.getVar("hitCnt").get_vector(VECTOR_FLAG_1);
				//print(" multiHitCnt:" + multiHitCnt + " cnt:" + cnt);
			
				if(multiHitCnt <= cnt || obj.sq_var.get_obj_vector_size(0) == 0)
				{
					print(" destroy lightning target");
					if(obj.isMyControlObject())
					{
						sq_SendDestroyPacketPassiveObject(obj);
					}
				}
			}
		}
	}
	
	
}


function onDestroyObject_po_ATChainLightningTarget(obj, object)
{

	if(!obj) return;
	
	obj.sq_var.remove_obj_vector(object);

}

function onKeyFrameFlag_po_ATChainLightningTarget(obj, flagIndex)
{

}

function onEndCurrentAni_po_ATChainLightningTarget(obj)
{
	if(!obj) return;
	
	local state = obj.getVar("state").get_vector(0);
	
	if(state == S_PO_ATCLT_1) {
		obj.getVar("end").set_vector(0, 1);
	}
}
