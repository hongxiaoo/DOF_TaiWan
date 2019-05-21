
sub_state_0 <- 0
sub_state_1 <- 1

function setCustomData_po_CreatorWoodFence(obj,recive)
{

	if (!obj) return;

	local time = recive.readDword();
	
	local chr = obj.getTopCharacter();
	
	if (chr)
	{
		 local map = sq_GetMap(chr);
		 
		 if (map)
		 {
			map.recalcAStarAttributesByMovableObject(obj, false);
		 }
	}
	
	
	obj.getVar().clear_vector();
	
	obj.getVar().push_vector(time); // 시간 	
	obj.getVar().push_vector(0); // 플래그
	
	obj.getVar().clear_timer_vector();
	obj.getVar().push_timer_vector();
	obj.getVar().push_timer_vector();
			
	local t = obj.getVar().get_timer_vector(0);
	t.setParameter(20, -1);
	t.resetInstant(0);
	
	obj.getVar().clear_ct_vector();
	obj.getVar().push_ct_vector();
	local timer = obj.getVar().get_ct_vector(0);
	timer.Reset();
	timer.Start(10000,0);
	
	obj.getVar("state").clear_vector();
	obj.getVar("state").push_vector(0);
	
	
	if(obj.isMyControlObject())
	{
		local pIntVec = sq_GetGlobalIntVector();
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, 0);
			
		obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_0, pIntVec, STATE_PRIORITY_AUTO, false, "");
	}

	
}

function setState_po_CreatorWoodFence(obj,state,datas)
{
	if(!obj) return;
	
	local passiveState = state;
	
	obj.getVar("state").set_vector(0, passiveState);

	if(passiveState == PASSIVEOBJ_SUB_STATE_0)
	{
		//local ani = obj.getCustomAnimation(0);
		//obj.setCurrentAnimation(ani);
	
		local chr = obj.getTopCharacter();
		
		local map = sq_GetMap(chr);

		if (map)
		{
			map.recalcAStarAttributesByMovableObject(obj, false);
		}
	}
	else if(passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		local ani = obj.getCustomAnimation(0);
		obj.setCurrentAnimation(ani);
	}
}

function procAppend_po_CreatorWoodFence(obj)
{
	if(!obj) return;

	local chr = obj.getTopCharacter();
	
	local passiveState = obj.getVar("state").get_vector(0);
	
	if (chr)
	{
		local initFlag = obj.getVar().get_vector(1);
		
		if (!initFlag)
			 obj.getVar().set_vector(1, 1);
	}
	
	
	local ani = sq_GetCurrentAnimation(obj);
	
	if (passiveState == PASSIVEOBJ_SUB_STATE_0)
	{	
		local t = obj.getVar().get_ct_vector(0);
		if (t)
		{
			local currentT = t.Get();
			
			local maxTime = obj.getVar().get_vector(0);
			
			if (currentT >= maxTime)
			{
				if (obj.isMyControlObject())
				{
					local pIntVec = sq_GetGlobalIntVector();
				
					sq_IntVectorClear(pIntVec);
					sq_IntVectorPush(pIntVec, 0);

					obj.addSetStatePacket(PASSIVEOBJ_SUB_STATE_1, pIntVec, STATE_PRIORITY_AUTO, false, "");
					//sq_SendDestroyPacketPassiveObject(obj);
				}
			}
		}
	}
	else if (passiveState == PASSIVEOBJ_SUB_STATE_1)
	{
		if (sq_IsEnd(ani))
		{
			sq_SendDestroyPacketPassiveObject(obj);
		}
	}


}

function onChangeSkillEffect_po_CreatorWoodFence(obj,skillIndex,reciveData)
{

	if(!obj) return;

}

function onDestroyObject_po_CreatorWoodFence(obj,object)
{

	if(!obj) return;

}

function onKeyFrameFlag_po_CreatorWoodFence(obj,flagIndex)
{

	if(!obj) return;

}


function onEndCurrentAni_po_CreatorWoodFence(obj)
{

	if(!obj) return;

}

function destroy_po_CreatorWoodFence(obj)
{
	local chr = obj.getTopCharacter();
	
	if (chr)
	{
		 local map = sq_GetMap(chr);
		 
		 if (map)
		 {
			map.recalcAStarAttributesByMovableObject(obj, true);
		 }
	}
}