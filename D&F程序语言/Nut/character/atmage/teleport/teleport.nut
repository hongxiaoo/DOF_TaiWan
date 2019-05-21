
SUB_STATE_TELEPORT_0	<- 0
SUB_STATE_TELEPORT_1	<- 1
SUB_STATE_TELEPORT_2	<- 2
SUB_STATE_TELEPORT_3	<- 3
SUB_STATE_TELEPORT_4	<- 4

function checkExecutableSkill_Teleport(obj)
{

	if(!obj) return false;

	local b_useskill = obj.sq_IsUseSkill(SKILL_TELEPORT);

	if(b_useskill)
	{
		obj.getVar("pos").clear_vector();
		obj.getVar("pos").push_vector(0);
		obj.getVar("pos").push_vector(0);
		obj.getVar("pos").push_vector(0);
	
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_TELEPORT_0); // substate세팅
		obj.sq_AddSetStatePacket(STATE_TELEPORT, STATE_PRIORITY_IGNORE_FORCE, true);
		return true;
	}	

	return false;

}

function checkCommandEnable_Teleport(obj)
{

	if(!obj) return false;

	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK) {
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_TELEPORT);
	}
	

	return true;

}

function onSetState_Teleport(obj, state, datas, isResetTimer)
{

	if(!obj) return;

	local substate = obj.sq_GetVectorData(datas, 0);
	obj.setSkillSubState(substate);
	obj.sq_StopMove();
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();
	
	local sq_var = obj.getVar();

	if(substate == SUB_STATE_TELEPORT_0) {
		obj.sq_PlaySound("MW_TELEPORT");
		
		obj.getVar("pos").set_vector(0, posX);
		obj.getVar("pos").set_vector(1, posY);
		obj.getVar("pos").set_vector(2, posZ);
		
		sq_var.clear_vector();
		sq_var.push_vector(ENUM_DIRECTION_NEUTRAL);
		sq_var.push_vector(ENUM_DIRECTION_NEUTRAL);
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_TELEPORT1);
		
		local appendage = CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_TELEPORT, 
		true, "Appendage/Character/ap_atmage_bodyeffect.nut", true);
		
	}
	else if(substate == SUB_STATE_TELEPORT_1) {
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_TELEPORT2);
		
	}
	else if(substate == SUB_STATE_TELEPORT_2) {
		//obj.sq_SetCurrentAnimation(CUSTOM_ANI_TELEPORT3);
	}
	else if(substate == SUB_STATE_TELEPORT_3) {
		// SUB_STATE_TELEPORT_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_4) {
		// SUB_STATE_TELEPORT_4 서브스테이트 작업
	}
	

}

function prepareDraw_Teleport(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_TELEPORT_0) {
		// SUB_STATE_TELEPORT_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_1) {
		// SUB_STATE_TELEPORT_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_2) {
		// SUB_STATE_TELEPORT_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_3) {
		// SUB_STATE_TELEPORT_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_4) {
		// SUB_STATE_TELEPORT_4 서브스테이트 작업
	}
	

}

function onProc_Teleport(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	local pAni = obj.sq_GetCurrentAni();
	local frmIndex = obj.sq_GetCurrentFrameIndex(pAni);
	local currentT = sq_GetCurrentTime(pAni);

	if(substate == SUB_STATE_TELEPORT_0) {
	}
	else if(substate == SUB_STATE_TELEPORT_1) {
		// SUB_STATE_TELEPORT_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_2) {
		// SUB_STATE_TELEPORT_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_3) {
		// SUB_STATE_TELEPORT_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_4) {
		// SUB_STATE_TELEPORT_4 서브스테이트 작업
	}
	

}

function onProcCon_Teleport(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_TELEPORT_0)
	{
		local horizonDirection = obj.sq_GetInputDirection(0);
		obj.getVar().set_vector(0, horizonDirection);
		local verticalDirection = obj.sq_GetInputDirection(1);
		obj.getVar().set_vector(1, verticalDirection);
	
	}
	else if(substate == SUB_STATE_TELEPORT_1) {
		// SUB_STATE_TELEPORT_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_2) {
		// SUB_STATE_TELEPORT_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_3) {
		// SUB_STATE_TELEPORT_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_4) {
		// SUB_STATE_TELEPORT_4 서브스테이트 작업
	}
	

}

function onEndCurrentAni_Teleport(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();
	
	//if(!obj.isMyControlObject()) {
	//	return;
	//}
	

	if(substate == SUB_STATE_TELEPORT_0) {
		local horizonDistance = obj.sq_GetIntData(SKILL_TELEPORT, 0); // 수평 워프거리
		local verticalDistance = obj.sq_GetIntData(SKILL_TELEPORT, 1); // 수직 워프거리
		
		local sq_var = obj.getVar();
		local horizonDirection = sq_var.get_vector(0);
		local verticalDirection = sq_var.get_vector(1);
		
		local posX = obj.getXPos();
		local posY = obj.getYPos();
		local posZ = obj.getZPos();
		
		local fx = posX;
		local fy = posY;
		local fz = posZ;
		
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_TELEPORT_1); // substate세팅
		
		if((horizonDirection == ENUM_DIRECTION_LEFT || horizonDirection == ENUM_DIRECTION_RIGHT))
		{
			fx = sq_GetDistancePos(posX, horizonDirection, horizonDistance);
		}
		
		if(verticalDirection == ENUM_DIRECTION_UP)
		{
			fy = posY - verticalDistance;
		}
		
		if(verticalDirection == ENUM_DIRECTION_DOWN)
		{
			fy = posY + verticalDistance;
		}
		
		if(horizonDirection == ENUM_DIRECTION_NEUTRAL && verticalDirection == ENUM_DIRECTION_NEUTRAL)
		{
			fx = sq_GetDistancePos(posX, obj.getDirection(), horizonDistance);
		}
		
		if(!sq_IsValidActiveStatus(obj, ACTIVESTATUS_HOLD))
			obj.sq_SetfindNearLinearMovablePos(fx, fy, obj.getXPos(), obj.getYPos(), 10);
		
		if(obj.isMyControlObject())
		{
			obj.sq_AddSetStatePacket(STATE_TELEPORT, STATE_PRIORITY_IGNORE_FORCE, true);
		}

	}
	else if(substate == SUB_STATE_TELEPORT_1) {
		if(obj.isMyControlObject())
		{
			obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
		}
	}
	else if(substate == SUB_STATE_TELEPORT_2) {
		if(obj.isMyControlObject())
		{
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(1); // substate세팅
			obj.sq_IntVectPush(0); // substate세팅
			obj.sq_IntVectPush(1); // substate세팅
			obj.sq_AddSetStatePacket(STATE_JUMP, STATE_PRIORITY_USER, true);
		}
		
	}
	else if(substate == SUB_STATE_TELEPORT_3) {
		// SUB_STATE_TELEPORT_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_4) {
		// SUB_STATE_TELEPORT_4 서브스테이트 작업
	}
	

}

function onKeyFrameFlag_Teleport(obj, flagIndex)
{

	if(!obj) return false;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_TELEPORT_0) {
		// SUB_STATE_TELEPORT_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_1) {
		// SUB_STATE_TELEPORT_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_2) {
		// SUB_STATE_TELEPORT_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_3) {
		// SUB_STATE_TELEPORT_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_4) {
		// SUB_STATE_TELEPORT_4 서브스테이트 작업
	}
	

	return false;

}

function onEndState_Teleport(obj, new_state)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_TELEPORT_0) {
		// SUB_STATE_TELEPORT_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_1) {
		// SUB_STATE_TELEPORT_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_2) {
		// SUB_STATE_TELEPORT_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_3) {
		// SUB_STATE_TELEPORT_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_4) {
		// SUB_STATE_TELEPORT_4 서브스테이트 작업
	}
	

}

function onAfterSetState_Teleport(obj, state, datas, isResetTimer)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_TELEPORT_0) {
		// SUB_STATE_TELEPORT_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_1) {
		// SUB_STATE_TELEPORT_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_2) {
		// SUB_STATE_TELEPORT_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_3) {
		// SUB_STATE_TELEPORT_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_TELEPORT_4) {
		// SUB_STATE_TELEPORT_4 서브스테이트 작업
	}
	

}


function getScrollBasisPos_Teleport(obj)
{
	if(!obj) return;
	
	local substate = obj.getSkillSubState();
	
	

	if(substate == SUB_STATE_TELEPORT_1 || substate == SUB_STATE_TELEPORT_0)
	{
		if(obj.isMyControlObject())		
		{
			local pX = obj.getVar("pos").get_vector(0);
			local pY = obj.getVar("pos").get_vector(1);
			
			if(substate == SUB_STATE_TELEPORT_1)
			{		
				local pAni = obj.sq_GetCurrentAni();
				local currentT = sq_GetCurrentTime(pAni);
				
				local totalT = 200;
				local posX = obj.getXPos();
				local posY = obj.getYPos();
				local posZ = obj.getZPos();
				
				local orgX = obj.getVar("pos").get_vector(0);
				local orgY = obj.getVar("pos").get_vector(1);
				local orgZ = obj.getVar("pos").get_vector(2);
				
				//pX = sq_GetAccel(orgX, posX, currentT, totalT, true);
				pX = sq_GetUniformVelocity(orgX, posX, currentT, totalT);
				//pX = posX;
				//print( " orgX:" + orgX + " pX:" + pX);
				pY = posY;
			}
			obj.sq_SetCameraScrollPosition(pX, pY, 0);
			return true;
		}
	}
	
	return false;
}
