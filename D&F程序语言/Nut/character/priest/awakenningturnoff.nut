
// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_AwakenningTurnOff(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	local substate = obj.sq_getVectorData(datas, 0); // 첫번째 substate입니다..	
	obj.setSkillSubState(substate); //set substate
	obj.sq_stopMove();	
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();
	local sq_var = obj.getVar();	
	
	
	if(obj.getVar("takingAwakenSkillBack").size_vector() > 0) {	
		obj.getVar("takingAwakenSkillBack").set_vector(0, 0);
	}
	
	sq_var.clear_vector();
	sq_var.push_vector(0);
	
	local appendage = obj.GetSquirrelAppendage("Appendage/Character/ap_avenger_awakening.nut");
	
	if(appendage) {
		if(appendage.isValid()) {
			appendage.setValid(false);
		}
		
		// 리얼 밸리드 플래그로 쓸 멤버입니다.. 왜 이런식이 됐냐면.. 
		// 어벤저가 state_stand상태에서만 변신해제가 되어야 합니다 
		// 그래서 valid가 false가 된다고 해서 곧장 변신해제 됐다고 간주해서는 안됩니다 여러방법을 생각해낸 결과 이 방법이 가장 깔끔할거 같아서 입니다.. 
		// 머 쓰이는 곳도 없으니까
		appendage.sq_var.set_vector(I_AVENGER_AWAKENING_VALID, 0);
		obj.setObjectHeight(-1);
	}
	
	
	if(substate == 0) {
		//obj.sq_setCurrentAnimation(CUSTOM_ANI_AWAKENING_TURN_OFF);
		local turn_off_ani = obj.getVar().GetAnimationMap("AWAKENING_TURN_OFF", "Character/Priest/Animation/AwakeningTurnoff.ani"); // 스킨아바타 때문에 외부에서 애니메이션을 가지고 와야 합니다..
		obj.setCurrentAnimation(turn_off_ani);
	}
	else if(substate == 1) {
		obj.sq_setCurrentAnimation(CUSTOM_ANI_AWAKENING_TURN_OFF_2);
		

		
		//if(sq_var.get_vector(0) == 0) {			
		//	sq_var.set_vector(0, 1);
			
			//테아나 유리깨지는 효과
			local particleCreater = sq_var.GetparticleCreaterMap("BellatrixGlass", "Character/Priest/Effect/Particle/AwakeningTurnOff.ptl", obj);
				
			particleCreater.Restart(0);
			//local dstX = sq_GetDistancePos(posX, obj.getDirection(), -20);				
			particleCreater.SetPos(posX, posY + 2, posZ+70);
			
			sq_AddParticleObject(obj, particleCreater);
		//}
	}

	
}


// prepareDraw 함수 입니다..
function prepareDraw_AwakenningTurnOff(obj)
{
	if(!obj) return;
}


// loop 부분입니다 ismycontrol로 감싸지 않은 연결된 모든 object들이 이곳을 거치게됩니다.
function onProc_AwakenningTurnOff(obj)
{
	if(!obj) return;
	local substate = obj.getSkillSubState();
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();
	
	local pAni = obj.sq_getCurrentAni();
    local frmIndex = obj.sq_ani_GetCurrentFrameIndex(pAni);

	local currentT = sq_GetCurrentTime(pAni);
	local sq_var = obj.getVar();
	
}

// loop 부분입니다 ismycontrol 호스트가 본인이 object가 이곳을 들어갑니다. setstate 세팅이나 패시브오브젝트 생성 , 등등 처리합니다.
function onProcCon_AwakenningTurnOff(obj)
{
	if(!obj) return;
	local substate = obj.getSkillSubState();
	
	local pAni = obj.sq_getCurrentAni();
	local bEnd = obj.sq_ani_IsEnd(pAni);
    local frmIndex = obj.sq_ani_GetCurrentFrameIndex(pAni);
	
    local substate = obj.getSkillSubState();
        
	if(bEnd) {
		if(substate == 0) {
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(1);
			obj.sq_addSetStatePacket(STATE_AWAKENING_TURN_OFF, STATE_PRIORITY_USER, true);
		}
		else if(substate == 1) {
			obj.setObjectHeight(-1);
			obj.sq_addSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
		}
	}
}



// irdcharacter에서  setstate() -> IRDActiveObject::setState -> aftersetstate() 이런순서에서 마지막 setstate입니다. skill특성에 따라서 호출할 필요가 
// 있다면 이 함수를 이용합니다.

function onAfterSetState_AwakenningTurnOff(obj, state, datas, isResetTimer)
{
	if(!obj) return;
	
}

// onbeforeattack 콜백함수 입니다
function onBeforeAttack_AwakenningTurnOff(obj, damager, boundingBox)
{
	
}

// onAttack 콜백함수 입니다
function onAttack_AwakenningTurnOff(obj, damager, boundingBox)
{
	
}

// onAfterAttack 콜백함수 입니다
function onAfterAttack_AwakenningTurnOff(obj, damager, boundingBox)
{
	
}

// onBeforeDamage 콜백함수 입니다
function onBeforeDamage_AwakenningTurnOff(obj, attacker, boundingBox)
{
	
}

// onDamage 콜백함수 입니다
function onDamage_AwakenningTurnOff(obj, attacker, boundingBox)
{
	
}

// onAfterDamage 콜백함수 입니다
function onAfterDamage_AwakenningTurnOff(obj, attacker, boundingBox)
{
	
}


