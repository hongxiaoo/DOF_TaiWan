
SUB_STATE_DIEHARD_0	<- 0
SUB_STATE_DIEHARD_1	<- 1
SUB_STATE_DIEHARD_2	<- 2

function onSetState_DieHard(obj, state, datas, isResetTimer)
{

	if(!obj) return;

	local substate = obj.sq_GetVectorData(datas, 0);
	obj.setSkillSubState(substate);

	obj.sq_StopMove();
	
	obj.getVar().clear_vector();
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);

	if(substate == SUB_STATE_DIEHARD_0)
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_DIEHARD1); 
	}
	else if(substate == SUB_STATE_DIEHARD_1)
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_DIEHARD2); 
		CNSquirrelAppendage.sq_AppendAppendage(obj, obj, SKILL_DIEHARD, true, "Appendage/Character/ap_atmage_bodyeffect.nut", true);
		obj.sq_PlaySound("IMMORTAL");
	}
	else if(substate == SUB_STATE_DIEHARD_2)
	{
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_DIEHARD3); 
	}
	

}

function prepareDraw_DieHard(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_DIEHARD_0) {
		// SUB_STATE_DIEHARD_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_DIEHARD_1) {
		// SUB_STATE_DIEHARD_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_DIEHARD_2) {
		// SUB_STATE_DIEHARD_2 서브스테이트 작업
	}
	

}

function onProc_DieHard(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	local pAni = obj.sq_GetCurrentAni();
	local frmIndex = obj.sq_GetCurrentFrameIndex(pAni);
	local currentT = sq_GetCurrentTime(pAni);

	if(substate == SUB_STATE_DIEHARD_0)
	{
	}
	else if(substate == SUB_STATE_DIEHARD_1)
	{
	}
	else if(substate == SUB_STATE_DIEHARD_2)
	{
	}
	

}

function onProcCon_DieHard(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_DIEHARD_0) {
		// SUB_STATE_DIEHARD_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_DIEHARD_1) {
		// SUB_STATE_DIEHARD_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_DIEHARD_2) {
		// SUB_STATE_DIEHARD_2 서브스테이트 작업
	}
	

}

function onEndCurrentAni_DieHard(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();
	
	if(!obj.isMyControlObject())
		return;

	if(substate == SUB_STATE_DIEHARD_0) {
		print(" end");
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_DIEHARD_1); // substate세팅
		obj.sq_AddSetStatePacket(STATE_DIEHARD, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == SUB_STATE_DIEHARD_1) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_DIEHARD_2); // substate세팅
		obj.sq_AddSetStatePacket(STATE_DIEHARD, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == SUB_STATE_DIEHARD_2) {
		obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	}
	

}

function onKeyFrameFlag_DieHard(obj, flagIndex)
{

	if(!obj) return false;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_DIEHARD_0) {
		// SUB_STATE_DIEHARD_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_DIEHARD_1) {
		// SUB_STATE_DIEHARD_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_DIEHARD_2) {
		// SUB_STATE_DIEHARD_2 서브스테이트 작업
	}
	

	return false;

}

function onEndState_DieHard(obj, new_state)
{

	if(!obj) return;
	
	if(new_state != STATE_DIEHARD)
	{
		print(" ghost go");
		//sq_SendMessage(obj, OBJECT_MESSAGE_INVINCIBLE, 1, 0);
		sq_SetCustomDamageType(obj, false, 1);
		sq_SendMessage(obj, OBJECT_MESSAGE_GHOST, 0, 0);
		sq_SendMessage(obj, OBJECT_MESSAGE_GHOST, 1, 0);
		sq_PostDelayedMessage(obj, OBJECT_MESSAGE_GHOST, 0, 0, 1500);
	}

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_DIEHARD_0) {
		// SUB_STATE_DIEHARD_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_DIEHARD_1) {
		// SUB_STATE_DIEHARD_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_DIEHARD_2) {
		// SUB_STATE_DIEHARD_2 서브스테이트 작업
	}
	

}

function onAfterSetState_DieHard(obj, state, datas, isResetTimer)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_DIEHARD_0) {
		// SUB_STATE_DIEHARD_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_DIEHARD_1) {
		// SUB_STATE_DIEHARD_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_DIEHARD_2) {
		// SUB_STATE_DIEHARD_2 서브스테이트 작업
	}
	

}

