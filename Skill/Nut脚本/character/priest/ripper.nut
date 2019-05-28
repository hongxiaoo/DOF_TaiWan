// 스킬 세부발동 조건을 만들어주는 함수입니다.. 발동 조건 state는 이미 소스에서 구현되어 있습니다. 이곳에서 useskill과 setstate를 지정해주면 됩니다.
function checkExecutableSkill_Ripper(obj)  
{
	if(!obj) return false;
	local b_useskill = obj.sq_IsUseSkill(SKILL_RIPPER);
	if(b_useskill) {
		obj.sq_addSetStatePacket(STATE_RIPPER, STATE_PRIORITY_USER, false);
		return true;
	}	
	
	return false;
}

// 스킬아이콘 활성화 조건을 따지는 함수입니다. true를 리턴하면 스킬 아이콘이 활성화가 됩니다. (발동조건 state는  소스에서 처리됩니다.)
function checkCommandEnable_Ripper(obj)
{
	if(!obj) return false;
	
	local state = obj.sq_GetSTATE();
	
	if(state == STATE_ATTACK) {
		// 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20]
		return obj.sq_IsCommandEnable(SKILL_RIPPER);
	}

	return true;
}

//------------------------------------------------------------------------------


//isCheckHitCollision와 checkHit는 피격 체크를 상대방이 아닌 내가 해야 할경우에 쓰인다. pvp에선 상대방이 피격체크를 하면 응답시간이 느려 스킬이 캔슬되는 경우가 있기 때문.
function onIsCheckHitCollision_Ripper(obj,damager)
{	
	return obj.isMyControlObject();
}

function isForceHitCheck_Ripper(obj)
{
	return obj.isMyControlObject();
}

function onAttack_Ripper(obj,damager,boundingBox)
{
	local sq_var = obj.getVar();
	sq_var.setBool(0,true); // 공격 성공	
	
	local isLast = sq_var.getBool(1); // 막타
	if (!isLast) {
		sq_var.push_obj_vector(damager);
		sq_AtrractionForce(obj, damager, false, 270, -1, 2000.0, 1500.0, false); // 밀어내기	
		sq_EffectLayerAppendage(damager,sq_RGB(255,255,255),155,0,80,0);	
	}
}


function onEndState_Ripper(obj, newState)
{
	if(!obj) return;
	local sq_var = obj.getVar();
	sq_var.clear_obj_vector();
	
	local ani = sq_GetCurrentAnimation(obj);	
	if(ani){
		local sizeRate = sq_var.getFloat(2);
		ani.setAttackBoundingBoxSizeRate(1.0/sizeRate,true);
	}
}


// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_Ripper(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	local sq_var = obj.getVar();
	obj.sq_stopMove();
	obj.sq_setCurrentAnimation(CUSTOM_ANI_RIPPER);
	obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_RIPPER);	
	obj.sq_setAttackPowerWithPassive(SKILL_RIPPER, state, -1,0,1.0);	
	sq_var.setBool(0,false);	
	sq_var.setBool(1,false);
	sq_var.setFloat(2,1.0);
	
	obj.sq_setXScroll(180,500,1500,100);
	obj.sq_PlaySound("PR_RIPPER_READY");	
}

function onEndCurrentAni_Ripper(obj)
{
	obj.sq_addSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	obj.sq_setfindNearMovablePos(obj.getXPos(),obj.getYPos(),50,1,5);
}

function onKeyFrameFlag_Ripper(obj,flagIndex)
{
	local isMycontrolObject = obj.sq_isMyControlObject();
	local sq_var = obj.getVar();
	
	if(isMycontrolObject && flagIndex == 1) // 진동,번쩍 이펙트는 나에게만 보인다.
		obj.sq_setShake(obj,4,60);
	else if(isMycontrolObject && flagIndex == 2)
		obj.sq_setShake(obj,2,30);
	else if(flagIndex == 3) 
	{		
		if(isMycontrolObject)
			obj.sq_setShake(obj,3,60);			
	}
	else if(isMycontrolObject && flagIndex == 4)
		obj.sq_setShake(obj,2,30);
	else if(flagIndex == 6)
	{
		obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_RIPPER);
		local state = obj.sq_GetSTATE();
		obj.sq_setAttackPowerWithPassive(SKILL_RIPPER, state, -1,0,1.0);
	}
	else if(flagIndex == 5 && sq_var.getBool(0))
	{		
		local state = obj.sq_GetSTATE();

		obj.sq_setCurrentAttackInfo(CUSTOM_ATTACKINFO_RIPPER_EXPLOSION);
		
		// 리퍼 특성 스킬이면
		local exSkillLevel = sq_GetSkillLevel(obj,SKILL_RIPPER_EX);		
		if(!sq_isPVPMode() && exSkillLevel > 0) {			
			local sizeRate = sq_GetLevelData(obj, SKILL_RIPPER, 2, exSkillLevel);			
			sizeRate = sizeRate * 0.01;	
			
			local ani = sq_GetCurrentAnimation(obj);			
			if(ani){
				ani.setAttackBoundingBoxSizeRate(sizeRate,true);
				sq_var.setFloat(2,sizeRate);
			}
		}	
		
			
		obj.sq_setAttackPowerWithPassive(SKILL_RIPPER, state, -1,1,1.0);
		sq_AddDrawOnlyAniFromParent(obj,"Character/Priest/Effect/Animation/Ripper/etc/33p_1_burst1-handup_normal.ani",0,1,0);
		sq_AddDrawOnlyAniFromParent(obj,"Character/Priest/Effect/Animation/Ripper/etc/33p_burst1-handup_normal.ani",0,1,0);
		if(isMycontrolObject)
		{			
			local flash = sq_flashScreen(obj,80, 80, 0, 255, sq_RGBA(255,255,255,128),GRAPHICEFFECT_NONE,ENUM_DRAWLAYER_BOTTOM);
			sq_addFlashScreen(flash,0,0,400,255,sq_RGBA(0,0,0,180),GRAPHICEFFECT_NONE,ENUM_DRAWLAYER_BOTTOM);
			
			local objListSize = sq_var.get_obj_vector_size();	
			for(local i =0;i<objListSize;++i)
			{				
				local obj = sq_var.get_obj_vector(i);
				if(obj == null)
					continue;
				
				sq_EffectLayerAppendage(obj,sq_RGB(0,0,0),255,0,160,160);
			}
		}
	}
	else if(flagIndex == 7 && sq_var.getBool(0))
	{				
		sq_var.setBool(1,true);
		if(isMycontrolObject)
			sq_SendCreatePassiveObjectPacket(obj,24102, 0, 267, 1, 83,obj.getDirection());
		obj.sq_PlaySound("R_PR_RIPPER");
	}

	return true;
}
