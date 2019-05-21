EARTHQUAKE_ROCK_MAX <- 3;
// 스킬 세부발동 조건을 만들어주는 함수입니다.. 발동 조건 state는 이미 소스에서 구현되어 있습니다. 이곳에서 useskill과 setstate를 지정해주면 됩니다.
function checkExecutableSkill_EarthQuake(obj)  
{
	if(!obj) return false;
	local b_useskill = obj.sq_IsUseSkill(SKILL_EARTH_QUAKE);
	if(b_useskill) {
		obj.sq_addSetStatePacket(STATE_EARTHQUAKE , STATE_PRIORITY_USER, false);
		return true;
	}	
	
	return false;
}

// 스킬아이콘 활성화 조건을 따지는 함수입니다. true를 리턴하면 스킬 아이콘이 활성화가 됩니다. (발동조건 state는  소스에서 처리됩니다.)
function checkCommandEnable_EarthQuake(obj)
{
	if(!obj) return false;

	local state = obj.sq_GetSTATE();
	
	if(state == STATE_ATTACK) {
		return obj.sq_IsCommandEnable(SKILL_EARTH_QUAKE); // 결투장에서는 특정스킬만 캔슬이 가능합니다. 작업자:정진수 [2012.04.20] obj.sq_IsCommandEnable(SKILL_EARTH_QUAKE);
	}
	
	return true;
}

//------------------------------------------------------------------------------

// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_EarthQuake(obj, state, datas, isResetTimer)
{	
	if(!obj) return;
	obj.sq_stopMove();
	obj.sq_setCurrentAnimation(CUSTOM_ANI_EARTH_QUAKE);
	obj.sq_setXScroll(50,200,200,0);	
}

function onEndCurrentAni_EarthQuake(obj)
{
	obj.sq_addSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
	
	local x = sq_GetDistancePos(obj.getXPos(),obj.getDirection(),40);
	if(obj.isMovablePos(x,obj.getYPos()))		
		obj.setCurrentPos(x, obj.getYPos(), obj.getZPos());
}

function onKeyFrameFlag_EarthQuake(obj,flagIndex)
{
	local isMycontrolObject = obj.sq_isMyControlObject();

	if(isMycontrolObject && flagIndex == 1) // 진동,번쩍 이펙트는 나에게만 보인다.
	{
		local gap = obj.sq_getIntData(SKILL_EARTH_QUAKE,0); // 패시브 생성 간격			
		local state = obj.sq_GetSTATE();
		local dmg = obj.sq_getBonusRateWithPassive(SKILL_EARTH_QUAKE, state, 0,1.0);
		
				
		obj.sq_binaryData_startWrite();
		obj.sq_binaryData_writeWord(EARTHQUAKE_ROCK_MAX); // 패시브 재귀 생성 갯수
		obj.sq_binaryData_writeWord(gap); // 패시브 생성 간격
		obj.sq_binaryData_writeDword(dmg); // 패시브 생성 간격		
		obj.sq_p00_sendCreatePassiveObjectPacket(24103, 0, 120, 1, 0);
	}
	return true;
}
