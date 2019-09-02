

// state를 세팅하고 처음으로 들어오게 됩니다. 각종 리소스를 세팅합니다. 
function onSetState_Attack(obj, state, datas, isResetTimer)
{	
	if (!obj)
		return;

	local skillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);

	// 수인체를 배웠음.
	if (skillLevel > 0)
	{
		// 일반 공격시, 앞으로 전진 처리
		obj.setAttackXVelocity(250);
		obj.setAttackXAccel(-1000);
		obj.setAttackXVelocityFast(400);
		obj.setAttackXAccelFast(-1000);
		
		// 기본기 숙련 적용	
		obj.applyBasicAttackUp(sq_GetCurrentAttackInfo(obj),obj.getState());		
		sq_SetCurrentAttackInfo(obj, sq_GetCurrentAttackInfo(obj));
	}
	else
	{
		// 수인체를 배우지 않았다면 제자리에서 마법구 시전
		obj.setAttackXVelocity(0);
		obj.setAttackXAccel(0);
		obj.setAttackXVelocityFast(0);
		obj.setAttackXAccelFast(0);
		local element = obj.getThrowElement();
		local attackIndex = obj.getAttackIndex();
		playSoundForAtmageAttack(obj, element, attackIndex);
	}
}


function onAfterSetState_Attack(obj, state, datas, isResetTimer)
{
	if (!obj) return;

	// 수인체 스킬을 배웠다면, 평타 에니메이션이 바뀜
	// 마법구도 발사되지 않음.
	local iceElementalAttackSkillLevel = obj.sq_GetSkillLevel(SKILL_ICE_ELEMENTAL_ATTACK);


	if (state == STATE_ATTACK && iceElementalAttackSkillLevel <= 0)
	{
		// 평타 이펙트를 붙인다.
		// 걸려있는 버프 스킬 인덱스 및 서브 스테이트에 따라서 보여지는 이펙트가 다름 (속성에따라서 붙는 이펙트가 다름)
		local element = obj.getThrowElement();
		local attackIndex = obj.getAttackIndex();
		
		// 속성발동 appendage에 걸려있는지 체크함.
		// 속성발동에 걸려있지 않다면 무속성 평타가 발사됨
		local appendage = obj.GetSquirrelAppendage("Character/ATMage/ElementalChange/ap_ATMage_Elemental_Change.nut");
		if (!appendage || !appendage.isValid())
			element = ENUM_ELEMENT_NONE;

		if (attackIndex == 0)
		{
			if (element == ENUM_ELEMENT_FIRE)
			{	// 화속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/fire/attack1_fire_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/fire/attack1_fire_dodge.ani"), 0, 0);
			}
			else if (element == ENUM_ELEMENT_WATER)
			{	// 수속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/water/attack1_water_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/water/attack1_water_dodge.ani"), 0, 0);
			}
			else if (element == ENUM_ELEMENT_DARK)
			{	// 암속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/dark/attack1_dark_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/dark/attack1_dark_dodge.ani"), 0, 0);
			}
			else if (element == ENUM_ELEMENT_LIGHT)
			{	// 명속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/light/attack1_light_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/light/attack1_light_dodge.ani"), 0, 0);
			}
			else if (element == ENUM_ELEMENT_NONE)
			{	// 무속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/attack1_none_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/attack1_none_dodge.ani"), 0, 0);
			}
		}
		else if (attackIndex == 1)
		{
			if (element == ENUM_ELEMENT_FIRE)
			{	// 화속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/fire/attack2_fire_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/fire/attack2_fire_dodge.ani"), 0, 0);
			}
			else if (element == ENUM_ELEMENT_WATER)
			{	// 수속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/water/attack2_water_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/water/attack2_water_dodge.ani"), 0, 0);
			}
			else if (element == ENUM_ELEMENT_DARK)
			{	// 암속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/dark/attack2_dark_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/dark/attack2_dark_dodge.ani"), 0, 0);
			}
			else if (element == ENUM_ELEMENT_LIGHT)
			{	// 명속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/light/attack2_light_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/light/attack2_light_dodge.ani"), 0, 0);
			}
			else if (element == ENUM_ELEMENT_NONE)
			{	// 무속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/attack2_none_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/attack2_none_dodge.ani"), 0, 0);
			}
		}
		else if (attackIndex == 2)
		{
			if (element == ENUM_ELEMENT_FIRE)
			{	// 화속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/fire/attack3_fire_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/fire/attack3_fire_dodge.ani"), 0, 0);
			}
			else if (element == ENUM_ELEMENT_WATER)
			{	// 수속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/water/attack3_water_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/water/attack3_water_dodge.ani"), 0, 0);
			}
			else if (element == ENUM_ELEMENT_DARK)
			{	// 암속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/dark/attack3_dark_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/dark/attack3_dark_dodge.ani"), 0, 0);
			}
			else if (element == ENUM_ELEMENT_LIGHT)
			{	// 명속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/light/attack3_light_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/light/attack3_light_dodge.ani"), 0, 0);
			}
			else if (element == ENUM_ELEMENT_NONE)
			{	// 무속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/attack3_none_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/attack3_none_dodge.ani"), 0, 0);
			}
		}
		else if (attackIndex == 3)
		{
			if (element == ENUM_ELEMENT_FIRE)
			{	// 화속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/fire/attack4_fire_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/fire/attack4_fire_dodge.ani"), 0, 0);
			}
			else if (element == ENUM_ELEMENT_WATER)
			{	// 수속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/water/attack4_water_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/water/attack4_water_dodge.ani"), 0, 0);
			}
			else if (element == ENUM_ELEMENT_DARK)
			{	// 암속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/dark/attack4_dark_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/dark/attack4_dark_dodge.ani"), 0, 0);
			}
			else if (element == ENUM_ELEMENT_LIGHT)
			{	// 명속성
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/light/attack4_light_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/light/attack4_light_dodge.ani"), 0, 0);
			}
			else if (element == ENUM_ELEMENT_NONE)
			{
				obj.sq_AddStateLayerAnimation(1, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/attack4_none_normal.ani"), 0, 0);
				obj.sq_AddStateLayerAnimation(2, obj.sq_CreateCNRDAnimation("Effect/Animation/ATAttack/attack4_none_dodge.ani"), 0, 0);
			}
		}
	}	
}

function createMiniMagicCircle(obj, xPos, zPos, shotDirection, bonusDamage) // direction 0:정면  1:대각선  2:하단)
{	
	if(!obj)
		return;
	if (obj.sq_IsMyControlObject()) {
	
		// 마법구체 생성위치
		local direction = sq_GetDirection(obj);
		local x = sq_GetDistancePos(obj.getXPos(), direction, xPos);
		local y = sq_GetDistancePos(obj.getYPos(), ENUM_DIRECTION_DOWN, 1);
		local z = sq_GetDistancePos(obj.getZPos(), ENUM_DIRECTION_UP, zPos);
		// 약간의 유도기능이 있음.
		// 공격자
		// 발사 위치(x,y,z)
		// 가로 발사각 (0이면 앞으로 발사, 30이면 오른쪽 30도로 발사)
		// 세로 발사각 (0이면 앞으로 발사, -30이면 아래쪽 30도로 발사)
		// 가로 최대 보정각 (한쪽 방향)
		// 세로 최대 보정각 (한쪽 방향)
		// 적과의 최대 거리. -1이면 제한 없음
		// x축 최대 사정거리
		// 공격 박스의 x축 크기
		// 공격 박스의 y축 크기
		// 공격 박스의 z축 크기
		
		local activeObject;
		local searchAngleH = 0;
		local searchAngleV = 0;
		local passiveObjectIndex = 0;		
		
		if(shotDirection == 0)
		{	// 정면
			//activeObject = sq_FindShootingTarget(obj, x, y, z, 0, 0, 10, 10, -1, 1000, 1000, 250, 100);	
			local distance = 1000;
			local angle = 20;
			activeObject = findAngleTarget(obj, distance, angle, 100); // 부채꼴 모양의 적 검색			
			searchAngleH = 30;
			searchAngleV = 15;
			passiveObjectIndex = 24202;
		
			// 연속발사는 생김새는 같지만, 다른 오브젝트가 발사됨 (컨버전의 영향을 받기때문)
			if (obj.getState() == STATE_MULTI_SHOT)
				passiveObjectIndex = 24266;
		}
		else if(shotDirection == 1) {// 대각선
			activeObject = sq_FindShootingTarget(obj, x, y, z, 0, 0, 4, 4, -1, 300, 100, 50, 100);
			searchAngleH = 5;
			searchAngleV = 5;			
			passiveObjectIndex = 24207;
			
			// 연속발사는 생김새는 같지만, 다른 오브젝트가 발사됨 (컨버전의 영향을 받기때문)
			if (obj.getState() == STATE_MULTI_SHOT)
				passiveObjectIndex = 24271;
		}
		else if(shotDirection == 2) { // 하단
			activeObject = sq_FindShootingTarget(obj, x, y, z, 0, 0, 4, 4, -1, 300, 100, 50, 100);			
			searchAngleH = 5;
			searchAngleV = 5;	
			passiveObjectIndex = 24228;
			
			// 연속발사는 생김새는 같지만, 다른 오브젝트가 발사됨 (컨버전의 영향을 받기때문)
			if (obj.getState() == STATE_MULTI_SHOT)
				passiveObjectIndex = 24276;
		}				
		else {
			printc("error! magic ball create shotDirection error");
			return;
		}
		
		// 속성발동 appendage에 걸려있는지 체크함.
		// 속성발동에 걸려있지 않다면 무속성 평타가 발사됨
		local horizonAngle = 0.0;
		local verticalAngle = 0.0;	
		if (activeObject != NULL) {		
			local maxDistance = abs(activeObject.getXPos() - x);
			horizonAngle = sq_GetShootingHorizonAngle(activeObject, y, 0, searchAngleH, maxDistance);
			verticalAngle = sq_GetShootingVerticalAngle(activeObject, z, 0, searchAngleV, maxDistance, 300);
		}
			
		local appendage = obj.GetSquirrelAppendage("Character/ATMage/ElementalChange/ap_ATMage_Elemental_Change.nut");
		if (appendage && appendage.isValid()) {	
			local element = obj.getThrowElement();
			passiveObjectIndex = passiveObjectIndex + 1 + element;
		}
		
		obj.sq_StartWrite();
		obj.sq_WriteFloat(horizonAngle);
		obj.sq_WriteFloat(verticalAngle);
		obj.sq_WriteDword(bonusDamage);		
		obj.sq_SendCreatePassiveObjectPacket(passiveObjectIndex, 0, xPos, 1, zPos);
	}
}

// 공격시 마법 구체를 생성한다.
function onKeyFrameFlag_Attack(obj, flagIndex)
{
	if(!obj)
		return false;
	local isMyControlObject = obj.sq_IsMyControlObject();

	// 공격할때마다 마법 구체를 생성한다.
	// 걸려있는 버프에 따라서 생성 되어져야 할 패시브 오브젝트가 다름(속성)
	// 
	local xPos = 0, zPos = 0;

	local attackIndex = obj.getAttackIndex();
	if (attackIndex == 0)
	{
		xPos = 65, zPos = 59;
	}
	else if (attackIndex == 1)
	{
		xPos = 60, zPos = 71;
	}
	else if (attackIndex == 2)
	{
		xPos = 55, zPos = 58;
	}
	else if (attackIndex == 3)
	{
		xPos = 65, zPos = 36;
	}

	if (flagIndex == 1)
	{
		// 마법구체를 생성한다.
		createMiniMagicCircle(obj, xPos, zPos, 0, 0); // direction 0:정면  1:대각선  2:하단
	}


	return true;
}

function playSoundForAtmageAttack(obj, elementalType, attackCount)
{	
	if(!obj)
		return;

	local elementalName = "MWSHOT_0";
	if (elementalType == ENUM_ELEMENT_FIRE)
		elementalName = "FIRESHOT_0";
	else if (elementalType == ENUM_ELEMENT_WATER)
		elementalName = "ICESHOT_0";
	else if (elementalType == ENUM_ELEMENT_DARK)
		elementalName = "DARKSHOT_0";
	else if (elementalType == ENUM_ELEMENT_LIGHT)
		elementalName = "LIGHTSHOT_0";
	
	obj.sq_PlaySound(elementalName + (attackCount+1));
}