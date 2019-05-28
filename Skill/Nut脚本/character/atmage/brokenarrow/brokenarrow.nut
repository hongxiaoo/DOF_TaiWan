
SUB_STATE_BROKENARROW_0	<- 0
SUB_STATE_BROKENARROW_1	<- 1
SUB_STATE_BROKENARROW_2	<- 2
SUB_STATE_BROKENARROW_3	<- 3
SUB_STATE_BROKENARROW_4	<- 4

BrokenArrow_state_0 <- 10
BrokenArrow_state_1 <- 11
BrokenArrow_state_2 <- 12

function checkExecutableSkill_BrokenArrow(obj)
{

	if(!obj) return false;
	
	//local targetObj = sq_GetObjectByObjectId(obj, BROKENARROW_UNIQUE_ID);
	local flag = obj.getVar("brokenarrow").get_vector(VECTOR_FLAG_0);
	local targetObj = sq_GetPassiveObjectByState(obj, 24250, BrokenArrow_state_1); // 24250	`Character/Mage/ATBrokenArrow.obj`			// 남법사 - 브로큰애로우 (화살)

	local expTime = obj.sq_GetIntData(SKILL_BROKENARROW, 1); // 1. 타격 성공시 대쉬기능을 사용할 수 있는 시간 (화살이 꽂혀있는 시간)
	
	// 크로니클 아이템 작업.. 타격 성공시 대쉬기능을 사용할 수 있는 시간 (화살이 꽂혀있는 시간)
	// 0라면 대쉬를 하지 않는다..
		
	if(!targetObj || flag == 0 || expTime == 0)
	{
		local b_useskill = obj.sq_IsUseSkill(SKILL_BROKENARROW);

		if(b_useskill) {
			obj.getVar("arrow").clear_vector();
			obj.getVar("arrow").push_vector(0);
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(SUB_STATE_BROKENARROW_0); // substate세팅
			obj.sq_AddSetStatePacket(STATE_BROKENARROW, STATE_PRIORITY_IGNORE_FORCE, true);
			return true;
		}	
	}
	else
	{
		print( " checkExecutableSkill_BrokenArrow targetObj:" + targetObj);
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_BROKENARROW_2); // substate세팅
		
		local group = sq_GetGroup(targetObj);
		local uniqueId = sq_GetUniqueId(targetObj);
	
		obj.sq_IntVectPush(group); // substate세팅
		obj.sq_IntVectPush(uniqueId); // substate세팅
		obj.sq_AddSetStatePacket(STATE_BROKENARROW, STATE_PRIORITY_IGNORE_FORCE, true);
		return true;
	}
	


	return false;

}


//local arr=["one","two","three"]
//
//::print("FOREACH\n");
//
//foreach(i,val in arr)
//{
	//::print("index ["+i+"]="+val+"\n");
//}
//
//::print("FOR\n");
//
//for(local i=0;i<arr.len();i+=1)
//{
	//::print("index ["+i+"]="+arr[i]+"\n");
//}
//
//::print("WHILE\n");
//
//local i=0;
//while(i<arr.len())
//{
	//::print("index ["+i+"]="+arr[i]+"\n");
	//i+=1;
//}
//::print("DO WHILE\n");
//
//local i=0;
//do
//{
	//::print("index ["+i+"]="+arr[i]+"\n");
	//i+=1;
//}while(i<arr.len());


function checkCommandEnable_BrokenArrow(obj)
{

	if(!obj) return false;

	local state = obj.sq_GetState();
	
	if(state == STATE_ATTACK)
	{
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_BROKENARROW); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_BROKENARROW);
	}
	

	return true;

}

function onChangeSkillEffect_BrokenArrow(obj, skillIndex, reciveData)
{
	if(!obj)
		return;
}

function onSetState_BrokenArrow(obj, state, datas, isResetTimer)
{

	if(!obj) return;

	local substate = obj.sq_GetVectorData(datas, 0);
	obj.setSkillSubState(substate);
	obj.sq_StopMove();

	local arrowLauchNum = obj.sq_GetIntData(SKILL_BROKENARROW, 0); // 0. 화살 갯수
	
	obj.getVar().clear_vector();	
	obj.getVar().push_vector(arrowLauchNum);
	obj.getVar().push_vector(0);
	obj.getVar().push_vector(0);
	
	obj.getVar("flag").clear_vector();
	obj.getVar("flag").push_vector(0);
	
	local posX = obj.getXPos();
	local posY = obj.getYPos();
	local posZ = obj.getZPos();

	if(substate == SUB_STATE_BROKENARROW_0) {
		if(obj.getVar("brokenarrow").size_vector() == 0)
		{
			obj.sq_PlaySound("MW_BARROW");
			obj.getVar("brokenarrow").clear_vector();
			obj.getVar("brokenarrow").push_vector(1);
		}
		else
			obj.getVar("brokenarrow").set_vector(VECTOR_FLAG_0, 1);
		
		// 대쉬플래그
		obj.getVar("dash").clear_vector();
		obj.getVar("dash").push_vector(0);
		
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_BROKENARROW1);
		local pAni = obj.sq_GetCurrentAni();
		pAni.setSpeedRate(200.0);

	}
	else if(substate == SUB_STATE_BROKENARROW_1) {
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_BROKENARROW_LOOP1);
		local pAni = obj.sq_GetCurrentAni();
		pAni.setSpeedRate(200.0);
	}
	else if(substate == SUB_STATE_BROKENARROW_2) {
		// 대쉬1
		obj.getVar("brokenarrow").set_vector(VECTOR_FLAG_0, 0); // 한번 후려친다면..다시 리셋이 됩니다.
		
		local group = obj.sq_GetVectorData(datas, 1);
		local uniqueId = obj.sq_GetVectorData(datas, 2);
		
		local targetObj = sq_GetObject(obj, group, uniqueId);

		obj.getVar().push_vector(posX); // 현재 x : i: 3
		obj.getVar().push_vector(posY); // 현재 y : i: 4
		
		if(targetObj) {
			local disX = sq_Abs(targetObj.getXPos() - posX);
			local disY = targetObj.getYPos() - posY;
			
			if(targetObj.getXPos() > posX)
			{
				obj.setDirection(ENUM_DIRECTION_RIGHT);
			}
			else
			{
				obj.setDirection(ENUM_DIRECTION_LEFT);
			}
			
			disX = disX - 60;
			
			if(disX <= 0)
				disX = 0;
			
			obj.getVar().push_vector(disX); // x축 이동거리 : i: 5
			obj.getVar().push_vector(disY); // y축 이동거리 : i: 6
		}
		else { // 디폴트 이동거리
			local defaultDistance = obj.sq_GetIntData(SKILL_BLUEDRAGONWILL, 1); // 간접 공격 (지진 확대율) (100~)
			obj.getVar().push_vector(defaultDistance); // x축 이동거리 
			obj.getVar().push_vector(0); // y축 이동거리
		}
		
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_BROKENARROW_DASH1);
	}
	else if(substate == SUB_STATE_BROKENARROW_3) {
		obj.sq_SetCurrentAttackInfo(CUSTOM_ATTACK_INFO_AT_MAGE_BROKENARROW);
		obj.sq_SetCurrentAnimation(CUSTOM_ANI_BROKENARROW_DASH2);
		
		obj.sq_PlaySound("MW_BARROW_FIN");
		
		local atk = sq_GetCurrentAttackInfo(obj);		
		local attackRate = obj.sq_GetBonusRateWithPassive(SKILL_BROKENARROW, STATE_BROKENARROW, 1, 1.0); //1.휘둘러치기 공격력(%)
		sq_SetCurrentAttackBonusRate(atk, attackRate);
		
	}
	else if(substate == SUB_STATE_BROKENARROW_4) {
		// SUB_STATE_BROKENARROW_4 서브스테이트 작업
	}
}

function prepareDraw_BrokenArrow(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_BROKENARROW_0) {
	}
	else if(substate == SUB_STATE_BROKENARROW_1) {
	}
	else if(substate == SUB_STATE_BROKENARROW_2) {
	}
	else if(substate == SUB_STATE_BROKENARROW_3) {
	}
	else if(substate == SUB_STATE_BROKENARROW_4) {
	}
	

}


function getAngleArrow(obj, pTargetChr)
{
	if(!obj) return;
	if(!pTargetChr) return;
	
	local offsetX = 58; // 활쏘는 위치
	local offsetZ = 75; // 활쏘는 위치
	

	local X = obj.getXPos() + sq_GetDistancePos(0, obj.getDirection(), offsetX);
	local Y = obj.getYPos();
	local Z = obj.getZPos() + offsetZ;
	
	local posX = pTargetChr.getXPos();
	local posY = pTargetChr.getYPos();
	local posZ = pTargetChr.getZPos() + (sq_GetObjectHeight(pTargetChr) / 2);
	
	local offset = posX - X;
	
	local distance = sq_GetDistance( X, Y - Z, posX, posY - posZ, true);
	
	local w = posX - X;		
	if(w < 0) w = -w;
	//	화면상의 각도를 구해서 이펙트를 몇도나 돌려야 되는지 구한다.
	
	local h = (posY - posZ) - (Y - Z);
	local width = sq_Abs(posX - X);
	local angle = sq_Atan2( h.tofloat(), width.tofloat());

	//if((posY - posZ) < (Y - Z))
	{
		angle = -angle;
	}

	local nRevision = distance;

	local cos = nRevision.tofloat() * sq_Cos(angle);
	local sin = nRevision.tofloat() * sq_Sin(angle);

	local nX = sq_Abs( cos.tointeger() );
	local nY = sq_Abs( sin.tointeger() );

	return angle;
	//sq_SetfRotateAngle(pAni, angle);		

}


function onProc_BrokenArrow(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	local pAni = obj.sq_GetCurrentAni();
	local frmIndex = obj.sq_GetCurrentFrameIndex(pAni);
	local sq_var = obj.getVar();
	local currentT = sq_GetCurrentTime(pAni);

	local posX = sq_GetXPos(obj);
	local posY = sq_GetYPos(obj);
	local posZ = sq_GetZPos(obj);

	if(substate == SUB_STATE_BROKENARROW_0) {
		// SUB_STATE_BROKENARROW_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_1) {
		// SUB_STATE_BROKENARROW_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_2) {
		local dash_t = pAni.getDelaySum(false); //
		//obj.getVar().push_vector(posX); // 현재 x : i: 3
		//obj.getVar().push_vector(posY); // 현재 y : i: 4
    	
		local srcX = obj.getVar().get_vector(3); // 시작x
		local srcY = obj.getVar().get_vector(4); // 시작y
    	    	
    	local dis_x_len = sq_var.get_vector(5); // 총 이동거리
		local dis_y_len = obj.getVar().get_vector(6) + 1; // y축 이동거리
		
		local v = sq_GetAccel(0, dis_x_len, currentT, dash_t, true);
		
		local my = sq_GetUniformVelocity(0, dis_y_len, currentT, dash_t);
		
		local dstX = sq_GetDistancePos(srcX, obj.getDirection(), v);
		local dstY = srcY + my;
		 
		if(sq_var.get_vector(1))
		{ // 전프레임에서 이동할 수 없는 지역을 만났다면..
			if(sq_var.get_vector(2) != posY)
			{ // 전 posY와 비교해봐서 달라졌다면..
				sq_var.set_vector(1, 0); // 이동플래그를 off해줍니다..
				sq_var.set_vector(2, posY);
			}
		}
		 
		if(obj.isMovablePos(dstX, dstY) && !sq_var.get_vector(1))
		{ // 이동플래그와 이동가능지역이 모두 가능해야 이동
			sq_setCurrentAxisPos(obj, 0, dstX);
			sq_setCurrentAxisPos(obj, 1, dstY);
		}
		else
		{ // 이동할 수 없는 지역을 만났다..
			sq_var.set_vector(1,1); // 이동 플래그 인덱스 3 이동할 수 없는 지역을 만났을 때 그순간 더이상 이동못한다..
			local offset = dstX - posX;
			
			if(offset != 0) {				
				if(offset < 0) 
					offset = -offset;
				
				local totalLen = sq_var.get_vector(5); // 총이동거리
				sq_var.set_vector(5, totalLen - offset);
			}
		}
	}
	else if(substate == SUB_STATE_BROKENARROW_3) {
		// SUB_STATE_BROKENARROW_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_4) {
		// SUB_STATE_BROKENARROW_4 서브스테이트 작업
	}
	

}

function onProcCon_BrokenArrow(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_BROKENARROW_0 || substate == SUB_STATE_BROKENARROW_1)
	{
		local pAni = obj.getCurrentAnimation();
		local frmIndex = obj.sq_GetCurrentFrameIndex(pAni);

		//local x_range = obj.sq_GetIntData(SKILL_BLUEDRAGONWILL, 3); // 기운 충전시간
		//local y_range = obj.sq_GetIntData(SKILL_BLUEDRAGONWILL, 4); // 기운 충전시간
		//local z_range = obj.sq_GetIntData(SKILL_BLUEDRAGONWILL, 5); // 기운 충전시간
	
		if(frmIndex >= 3)
		{
			if(obj.getVar("flag").get_vector(0) == 0)
			{
				local x_range = 400; // 검색범위 x
				local y_range = 200; // 검색범위 y
				local z_range = 50; // 검색범위 z
				
				x_range = obj.sq_GetIntData(SKILL_BROKENARROW, 3); // 3. x범위
				y_range = obj.sq_GetIntData(SKILL_BROKENARROW, 4); // 4. y범위
				z_range = obj.sq_GetIntData(SKILL_BROKENARROW, 5); // 5. z범위
				
				local x = sq_GetXPos(obj);
				local y = sq_GetYPos(obj);
				local z = sq_GetZPos(obj);

				local attackRate = obj.sq_GetBonusRateWithPassive(SKILL_BROKENARROW, STATE_BROKENARROW, 0, 1.0); //2.공격력(%)

				local expTime = obj.sq_GetIntData(SKILL_BROKENARROW, 1); // 1. 타격 성공시 대쉬기능을 사용할 수 있는 시간 (화살이 꽂혀있는 시간)
				local stunTime = obj.sq_GetIntData(SKILL_BROKENARROW, 2); // 2. 적 경직시간
				
				local targetObj = sq_FindTarget(obj, 80, x_range, y_range, z_range);
				
				
				//local my = sq_GetUniformVelocity(0, dis_y_len, currentT, dash_t);
				local xLen = 400;
				local yLen = 0;
				local zLen = 75;
				local angle = -1.0;
				
				if(targetObj)
				{
					 xLen = obj.getXDistance(targetObj);
					 yLen = sq_GetYPos(targetObj) - sq_GetYPos(obj);
					 zLen = sq_GetZPos(targetObj) + (sq_GetObjectHeight(targetObj) / 2);
					 
					 angle = getAngleArrow(obj, targetObj);
					 
					 print(" angle:" + angle);
				}
				
				//local fireOffsetX = 56;
				
				if(obj.isMyControlObject())
				{
					local fireOffsetX = 65;
					local fireOffsetY = 0;
					local fireOffsetZ = 73;
					
					sq_BinaryStartWrite();
					sq_BinaryWriteDword(xLen); // 
					sq_BinaryWriteDword(yLen); // 
					sq_BinaryWriteDword(zLen); // 
					sq_BinaryWriteDword(attackRate); // 		
					sq_BinaryWriteDword(expTime); // 		
					sq_BinaryWriteDword(stunTime); // 		
					sq_BinaryWriteFloat(angle); // 		
					obj.sq_SendCreatePassiveObjectPacket(24250, 0, fireOffsetX, fireOffsetY + 1, fireOffsetZ); // 화살
				}
				
				obj.getVar("flag").set_vector(0, 1);
			}
		}
		
		if(obj.getVar("dash").get_vector(0) == 0)
		{
			obj.setSkillCommandEnable(SKILL_BROKENARROW, true);
    		
			local iEnterSkill = obj.sq_IsEnterSkill(SKILL_BROKENARROW);
    		
			if(iEnterSkill != -1)
			{
				obj.getVar("dash").set_vector(0, 1);
			}
		}

		
		
		
		//local particleCreater = null;
		
		//particleCreater = obj.getVar().GetparticleCreaterMap("BrokenArrowDownAttack", "Character/Mage/Particle/BrokenArrowDownAttack.ptl", obj);
		//
		//particleCreater = obj.getVar().GetparticleCreaterMap("BrokenArrowUpAttack", "Character/Mage/Particle/BrokenArrowUpAttack.ptl", obj);
			//
		//particleCreater.Restart(0);
		//particleCreater.SetPos(x + dx, y + dy, z + dz);	
		//
		//sq_AddParticleObject(obj, particleCreater);
	}
	else if(substate == SUB_STATE_BROKENARROW_2) {
		// SUB_STATE_BROKENARROW_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_3) {
		// SUB_STATE_BROKENARROW_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_4) {
		// SUB_STATE_BROKENARROW_4 서브스테이트 작업
	}
	

}

function onEndCurrentAni_BrokenArrow(obj)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();
	
	if(!obj.isMyControlObject()) {
		return;
	}

	local arrowNum = obj.getVar().get_vector(0);
		
	if(substate == SUB_STATE_BROKENARROW_0 || substate == SUB_STATE_BROKENARROW_1)
	{

		local arrowIndex = obj.getVar("arrow").get_vector(0);
		
		arrowIndex = arrowIndex + 1;
		
		obj.getVar("arrow").set_vector(0, arrowIndex);
		
		if(arrowIndex < arrowNum)
		{
			obj.sq_IntVectClear();
			obj.sq_IntVectPush(SUB_STATE_BROKENARROW_1); // substate세팅
			obj.sq_AddSetStatePacket(STATE_BROKENARROW, STATE_PRIORITY_IGNORE_FORCE, true);
		}
		else
		{
			local expTime = obj.sq_GetIntData(SKILL_BROKENARROW, 1); // 1. 타격 성공시 대쉬기능을 사용할 수 있는 시간 (화살이 꽂혀있는 시간)
			
			// 크로니클 아이템 작업.. 타격 성공시 대쉬기능을 사용할 수 있는 시간 (화살이 꽂혀있는 시간)
			// 0라면 대쉬를 하지 않는다..
		
			if(obj.getVar("dash").get_vector(0) == 1 && expTime > 0)
			{
				local targetObj = sq_GetPassiveObjectByState(obj, 24250, BrokenArrow_state_1); // 24250	`Character/Mage/ATBrokenArrow.obj`			// 남법사 - 브로큰애로우 (화살)				
				
				
				if(!targetObj)
				{
					obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
				}
				else
				{
					local group = sq_GetGroup(targetObj);
					local uniqueId = sq_GetUniqueId(targetObj);
				
					obj.sq_IntVectClear();
					obj.sq_IntVectPush(SUB_STATE_BROKENARROW_2); // substate세팅
					obj.sq_IntVectPush(group); // substate세팅
					obj.sq_IntVectPush(uniqueId); // substate세팅
					
					obj.sq_AddSetStatePacket(STATE_BROKENARROW, STATE_PRIORITY_IGNORE_FORCE, true);
				}
				
			}
			else
			{
				obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
			}
			
			//obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
		}

	}
	else if(substate == SUB_STATE_BROKENARROW_2)
	{
		obj.sq_IntVectClear();
		obj.sq_IntVectPush(SUB_STATE_BROKENARROW_3); // substate세팅
		obj.sq_AddSetStatePacket(STATE_BROKENARROW, STATE_PRIORITY_IGNORE_FORCE, true);
	}
	else if(substate == SUB_STATE_BROKENARROW_3)
	{
		obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	}
	else if(substate == SUB_STATE_BROKENARROW_4) {
		// SUB_STATE_BROKENARROW_4 서브스테이트 작업
	}
	

}

function onKeyFrameFlag_BrokenArrow(obj, flagIndex)
{

	if(!obj) return false;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_BROKENARROW_0) {
		// SUB_STATE_BROKENARROW_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_1) {
		// SUB_STATE_BROKENARROW_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_2) {
		// SUB_STATE_BROKENARROW_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_3) {
		// SUB_STATE_BROKENARROW_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_4) {
		// SUB_STATE_BROKENARROW_4 서브스테이트 작업
	}
	

	return false;

}

function onEndState_BrokenArrow(obj, new_state)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_BROKENARROW_0) {
		// SUB_STATE_BROKENARROW_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_1) {
		// SUB_STATE_BROKENARROW_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_2) {
		// SUB_STATE_BROKENARROW_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_3) {
		// SUB_STATE_BROKENARROW_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_4) {
		// SUB_STATE_BROKENARROW_4 서브스테이트 작업
	}
	

}

function onAfterSetState_BrokenArrow(obj, state, datas, isResetTimer)
{

	if(!obj) return;

	local substate = obj.getSkillSubState();

	if(substate == SUB_STATE_BROKENARROW_0) {
		// SUB_STATE_BROKENARROW_0 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_1) {
		// SUB_STATE_BROKENARROW_1 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_2) {
		// SUB_STATE_BROKENARROW_2 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_3) {
		// SUB_STATE_BROKENARROW_3 서브스테이트 작업
	}
	else if(substate == SUB_STATE_BROKENARROW_4) {
		// SUB_STATE_BROKENARROW_4 서브스테이트 작업
	}
	

}

function onAttack_BrokenArrow(obj, damager, boundingBox, isStuck)
{
	if(!obj) return;
	
	local substate = obj.getSkillSubState();
	
	if(substate == SUB_STATE_BROKENARROW_3)
	{
		
	}

}

