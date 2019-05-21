
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_PushOut")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_PushOut")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_PushOut")
}

function sq_AddEffect(appendage)
{
}



function proc_appendage_PushOut(appendage)
{
	if(!appendage || !appendage.isValid()) {
		return;		
	}

	local parentObj = appendage.getParent();
	local sourceObj = appendage.getSource();
				
	if(!sourceObj || !parentObj) {
		appendage.setValid(false);
		return;
	}

	if (parentObj.getState() == STATE_HOLD)
	{
		if (parentObj.getState() == STATE_HOLD && !sq_IsInCategory(parentObj,CATEGORY_ETC_FIXTURE))
		{
			//	지정된 방향대로 강제 전환
			parentObj.setCurrentDirection(sq_GetOppositeDirection(sourceObj.getDirection()));
		}
	}
	else
	{
		//	홀드시키기
		if (parentObj.isMyControlObject() && parentObj.getState() != STATE_DIE && !parentObj.isDead())
		{
			sq_IntVectorClear(sq_GetGlobalIntVector());
			sq_IntVectorPush(sq_GetGlobalIntVector(),0);
			sq_IntVectorPush(sq_GetGlobalIntVector(),0);
			sq_AddSetStatePacketActiveObject(parentObj,STATE_HOLD, sq_GetGlobalIntVector(), STATE_PRIORITY_FORCE);						
		}
	}

}

function onEnd_appendage_PushOut(appendage)
{
	if(!appendage) {
		return;
	}	
		
	local parentObj = appendage.getParent();
				
	if(!parentObj) {
		appendage.setValid(false);
		return;
	}			
		
	if (parentObj.getState() == STATE_HOLD) {
		appendage.setValid(false);
		parentObj.sendStateOnlyPacket(STATE_STAND);
	}
	// TODO : x축 우선 체크 할것. 지금은 y축으로 내려와 버려서 연속기가 안됨
	//local ao = sq_GetCNRDObjectToActiveObject(parentObj);
	//if(ao && sq_IsMyControlObject(ao) && !ao.isMovablePos(ao.getXPos(),ao.getYPos())) {
		//sq_SimpleMoveToNearMovablePos(ao,100); // 이동불가 지역에 있다면 이동가능지역으로 이동
	//}
}

