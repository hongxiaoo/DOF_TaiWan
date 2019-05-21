

// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_AvengerJump(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	if(isAvengerAwakenning(obj) == false) {
		return;
	}
	
	
	obj.sq_stopMove();
	
	obj.setAttackXVelocity(0);
	obj.setAttackXAccel(0);
	obj.setAttackXVelocityFast(0);
	obj.setAttackXAccelFast(0);
}


// prepareDraw 함수 입니다..
function prepareDraw_AvengerJump(obj)
{
	if(!obj) return;
}


// loop 부분입니다 ismycontrol로 감싸지 않은 연결된 모든 object들이 이곳을 거치게됩니다.
function onProc_AvengerJump(obj)
{
	if(!obj) return;
	if(isAvengerAwakenning(obj) == false) {
		return;
	}		
}

// loop 부분입니다 ismycontrol 호스트가 본인이 object가 이곳을 들어갑니다. setstate 세팅이나 패시브오브젝트 생성 , 등등 처리합니다.
function onProcCon_AvengerJump(obj)
{
	if(!obj) return;
	if(isAvengerAwakenning(obj) == false) {
		return;
	}
	
	
	if(obj.getAttackIndex() != 3) {
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(3); // substate세팅
		obj.sq_addSetStatePacket(STATE_ATTACK, STATE_PRIORITY_USER, true);
	}
	
	local pAni = obj.sq_getCurrentAni();
	local bEnd = obj.sq_ani_IsEnd(pAni);
    local frmIndex = obj.sq_ani_GetCurrentFrameIndex(pAni);
	
    local substate = obj.getSkillSubState();
        
	if(bEnd) {
		
	}
}

// state종료와 동시에 한번 호출되는 함수입니다. oldstate가 종료되는 state입니다. 무언가 발사된것이 있거나 종료처리될것이 있다면 이곳에서 처리합니다.
function onEndState_AvengerJump(obj, new_state)
{
	if(!obj) return;
	if(isAvengerAwakenning(obj) == false) {
		return;
	}
	
	//obj.sq_IntVectClear();
	//obj.sq_IntVectPush(2); // substate세팅
	//obj.sq_addSetStatePacket(STATE_ATTACK, STATE_PRIORITY_USER, true);
//
}

function onAfterSetState_AvengerJump(obj, state, datas, isResetTimer)
{
	if(!obj) return;
	obj.sq_stopMove();
	
	obj.setAttackXVelocity(0);
	obj.setAttackXAccel(0);
	obj.setAttackXVelocityFast(0);
	obj.setAttackXAccelFast(0);
}

