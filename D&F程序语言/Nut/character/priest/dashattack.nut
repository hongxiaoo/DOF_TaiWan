

// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_DashAttack(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	if(isAvengerAwakenning(obj) == false) {
		return;
	}
	
	obj.sq_stopMove();
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos(); 	
	
	local v = 450;
	local dstX = sq_GetDistancePos(posX, obj.getDirection(), v);
	
	obj.getVar().clear_vector();
	obj.getVar().push_vector(posX); // 시작점 0
	obj.getVar().push_vector(dstX); // 도착점 1
	obj.getVar().push_vector(posX); // 대쉬끝점 2
	obj.getVar().push_vector(0); // 대쉬이동 플래그 3 - 이동불가지역을 만났을 때 더이상 이동을 못하도록 하기 위함입니다..

	obj.sq_setShake(obj, 1, 1600);
	
	local sq_var = obj.getVar();
	local particle = sq_var.GetparticleCreaterMap("FastMove", "Character/Priest/Effect/Particle/Fastmove.ptl", obj);
	// 먼지파티클 타이머 세팅
	sq_var.clear_timer_vector();
	sq_var.push_timer_vector(); // 0번인덱스 먼지파티클 타이머
	sq_var.push_timer_vector(); // 1번인덱스 다단히트 타이머			
	
	local t = sq_var.get_timer_vector(0);
	t.setParameter(60, -1);
	t.resetInstant(0);
	
	
	//다단히트 수정
	
		local dashFrm = 13;
		
		local pAni = obj.sq_getCurrentAni();
		local dashT = pAni.getDelaySum(0, dashFrm); // 
		
		local hitCnt = obj.sq_getIntData(SKILL_AVENGER_AWAKENING, 2); // 대시공격 다단히트 최대 회수
		
		local term = 1;
		if(hitCnt > 0) {
			term = dashT / hitCnt;
		}
				
		local multiT = sq_var.get_timer_vector(1);
		multiT.setParameter(term, hitCnt);
		multiT.resetInstant(0);		
	
	//
    
}


// prepareDraw 함수 입니다..
function prepareDraw_DashAttack(obj)
{
	if(!obj) return;
}


// loop 부분입니다 ismycontrol로 감싸지 않은 연결된 모든 object들이 이곳을 거치게됩니다.
function onProc_DashAttack(obj)
{
	if(!obj) return;
	if(isAvengerAwakenning(obj) == false) {
		return;
	}
	
	local substate = obj.getSkillSubState();
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();
	
	local pAni = obj.sq_getCurrentAni();
    local frmIndex = obj.sq_ani_GetCurrentFrameIndex(pAni);
	local currentT = sq_GetCurrentTime(pAni);
	
	local dashFrm = 13;
	
	local dashT = pAni.getDelaySum(0, dashFrm); // 
	
	if(frmIndex <= dashFrm) {
		local srcX = obj.getVar().get_vector(0); // 시작점	
		local dstX = obj.getVar().get_vector(1); // 도착점
		
		
		//local currentX = sq_GetUniformVelocity(srcX, dstX, currentT, dashT);
		local currentX = sq_GetAccel(srcX, dstX, currentT, dashT, true);
		
		if(obj.isMovablePos(currentX, posY) && !obj.getVar().get_vector(3)) {
			obj.setCurrentPos(currentX, posY, posZ);
		}
		else {
			obj.getVar().set_vector(3, 1); // 대쉬이동 플래그 3 - 이동불가지역을 만났을 때 더이상 이동을 못하도록 하기 위함입니다..		
		}	
		
		obj.getVar().set_vector(2, posX); // 도착점
	}
	else {		
	
		//local delayT = 240;
		//local len = 50;
		//local srcX = obj.getVar().get_vector(2); // 시작점	
		//
		////local v = sq_GetAccel(0, len, currentT - dashT, delayT, true);
		//local v = sq_GetUniformVelocity(0, len, currentT - dashT, delayT);
		//
		//local currentX = sq_GetDistancePos(srcX, obj.getDirection(), v);
			 //
		//if(obj.isMovablePos(currentX, posY)) {
			//obj.setCurrentPos(currentX, posY, posZ);
		//}
	}
	
	// 먼지 파티클 생성
	local sq_var = obj.getVar();
	local t = sq_var.get_timer_vector(0);
	
	//print( "t:" + t);
	if(t)
	{
		if(t.isOnEvent(currentT) == true) {
			local particleCreater = sq_var.GetparticleCreaterMap("FastMove", "Character/Priest/Effect/Particle/Fastmove.ptl", obj);				
				
			particleCreater.Restart(0);
			//particleCreater.SetPos(posX, posY, posZ-1);				
			local dstX = sq_GetDistancePos(posX, obj.getDirection(), -20);				
			particleCreater.SetPos(dstX, posY, posZ+28);	
			
			sq_AddParticleObject(obj, particleCreater);
		}
	}
	else
	{
		sq_var.push_timer_vector();
		sq_var.push_timer_vector();
		local ti = sq_var.get_timer_vector(0)
		ti.setParameter(60, -1);
		ti.resetInstant(0);
	}
	
	// 다단히트 설정
	local multiT = sq_var.get_timer_vector(1);
	
	if (multiT.isOnEvent(currentT) == true)
		obj.resetHitObjectList();
	
	
}

// loop 부분입니다 ismycontrol 호스트가 본인이 object가 이곳을 들어갑니다. setstate 세팅이나 패시브오브젝트 생성 , 등등 처리합니다.
function onProcCon_DashAttack(obj)
{
	if(!obj) return;
	if(isAvengerAwakenning(obj) == false) {
		return;
	}
	
	local pAni = obj.sq_getCurrentAni();
	local bEnd = obj.sq_ani_IsEnd(pAni);
    local frmIndex = obj.sq_ani_GetCurrentFrameIndex(pAni);
	
	

	
    local substate = obj.getSkillSubState();
        
	if(bEnd) {
	}
}

function onAfterSetState_DashAttack(obj, state, datas, isResetTimer)
{
	if(!obj) return;
	
	if(isAvengerAwakenning(obj) == false) {
		return;
	}
	
	obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_AW_DASHATTACK);
	
    local power = obj.sq_getBonusRateWithPassive(SKILL_AVENGER_AWAKENING, state, SL_DASH_MAGIC_ATK,1.0);
    obj.sq_setCurrentAttackBonusRate(power);
}