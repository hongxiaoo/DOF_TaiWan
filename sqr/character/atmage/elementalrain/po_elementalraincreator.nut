SUBSTATE_PO_ELEMENTAL_CREATOR_STAY	<- 2; // 대기 상태 // 패시브의 서브 스테이트는  2 부터 시작한다.
SUBSTATE_PO_ELEMENTAL_CREATOR_FIRE	<- 3; // 발사 

VAR_PO_ELEMENTAL_CREATOR_TYPE	<- 0;	// 원소 타입
VAR_PO_POS_MIN					<- 1;	// 둥둥 떠있는 위치 최소값
VAR_PO_POS_MAX					<- 2;	// 둥둥 떠있는 위치 최대값

function setCustomData_po_ATElementalCreator(obj, receiveData)
{		
	if (!obj) return;	
	//elemental type 설정.  이 타입으로 나중에 마법구 생성
	local elementalType = receiveData.readWord();	
	
	local var = obj.getVar();
	var.setInt(VAR_PO_ELEMENTAL_CREATOR_TYPE, elementalType);
	
	
	local rand = sq_getRandom(0, 1);
	local upHeight = 8;
	if (rand == 0)
		upHeight = -8;

	var.setInt(VAR_PO_POS_MIN, obj.getZPos());
	var.setInt(VAR_PO_POS_MAX, obj.getZPos() + upHeight);
	
	if (elementalType != ENUM_ELEMENT_NONE)
		setCurrentAnimationFromCutomIndex(obj, elementalType);
	obj.sendStateOnlyPacket(SUBSTATE_PO_ELEMENTAL_CREATOR_STAY);	
}

function onAttack_po_ATElementalCreator(obj, damager, boundingBox, isStuck)
{
	if (!obj) return 0;
	return 0;
}


function procAppend_po_ATElementalCreator(obj)
{
	if (!obj) return;
	
	local var = obj.getVar();
	local min = var.getInt(VAR_PO_POS_MIN);
	local max = var.getInt(VAR_PO_POS_MAX);
	
	local zPos = sq_GetShuttleValue(min, max, sq_GetObjectTime(obj), 400);
	sq_SetCurrentPos(obj, obj.getXPos(), obj.getYPos(), zPos);	
}


function setState_po_ATElementalCreator(obj, state, datas)
{
	if (!obj) return;
	
	if (state == SUBSTATE_PO_ELEMENTAL_CREATOR_FIRE) 
	{
		local var = obj.getVar();
		local elementalType = var.getInt(VAR_PO_ELEMENTAL_CREATOR_TYPE);	
		playSoundForAtmageAttack(obj, elementalType, 0);
		
		if (!obj.isMyControlObject()) // 내가 관리하는 애가 아니면 사운드만 재생
			return;		
		
		local direction = sq_GetDirection(obj);
		local parentObj = obj.getTopCharacter();
		
		// 약간의 유도기능이 있음.		
		local activeObject = sq_FindShootingTarget(parentObj, 0, 0, 0, 0, 0, 4, 4, -1, 300, 100, 50, 100);
		local horizonAngle = 0.0;
		local verticalAngle = 0.0;

		if (activeObject != NULL)
		{
			local maxDistance = abs(activeObject.getXPos());
			horizonAngle = sq_GetShootingHorizonAngle(activeObject, 0, 0, 5, maxDistance);
			verticalAngle = sq_GetShootingVerticalAngle(activeObject, 0, 0, 5, maxDistance, 300);
		}

		sq_BinaryStartWrite()
		sq_BinaryWriteFloat(horizonAngle);			// 폭발의 크기
		sq_BinaryWriteFloat(verticalAngle);
		sq_BinaryWriteDword(0);
		sq_BinaryWriteDword(1);						// 엘레멘탈 레인의 패시브 오브젝트 인가?
		
		// 패시브 오브젝트 인덱스 설정
		local passiveObjectIndex = (elementalType == ENUM_ELEMENT_NONE ? 24207 : 24208 + elementalType);
		sq_SendCreatePassiveObjectPacket(obj, passiveObjectIndex, 0, 0, 0, 0, obj.getDirection());	
		sq_SendDestroyPacketPassiveObject(obj);	
	}
}
