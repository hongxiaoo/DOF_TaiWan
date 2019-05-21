DIR_X_I <- 0
DIR_Y_I <- 1

X_NORMALDASH_VELOCITY <- 286		/// 대쉬 횡이동에서 가로 1초동안 이동 픽셀 수
X_SLANTDASH_VELOCITY <- 238			/// 대쉬 대각선 이동에서 가로 1초동안 이동 픽셀 수
Y_NORMALDASH_VELOCITY <- 136		/// 대쉬 종이동에서 세로 1초동안 이동 픽셀 수
Y_SLANTDASH_VELOCITY <- 114			/// 대쉬 대각선 이동에서 세로 1초동안 이동 픽셀 수



// 선택된 캐릭터의 스킬매니져만 세팅합니다. 이번 프로토타입에서는 선택을 해도 AI가 멈추면 안되기 때문에 AI 활성화 상태에서 스킬 슬롯만 새로 세팅하는 구조로 갑니다.
// 그리고 버튼을 눌렀을때만 이제 커맨드체커를 세팅해줍니다.
// aiMode가 true라면.. ai모드인 커맨드체커를 세팅하며 aiMode가 false라면 ai모드를 해제하고 본인이 직접 콘트롤할 수 있는 커맨드체커를 세팅합니다.
function setCommandCheckerMyControlChracter(obj, aiMode)
{
	local aiChr = sq_GetCNRDObjectToSQRCharacter(obj);
	if(!aiChr)
		return;
	
	// aiChr의 커맨드 체커를 얻습니다.
	local cmdChecker = aiChr.getCommandChecker();	
	if(cmdChecker)
	{
		// ai 캐릭터를 다이나믹캐스팅을 합니다.	
		local onlyAiChr = sq_GetCNRDObjectToAICharacter(aiChr);
		// 기존 ai캐릭터에서 targetobject가 널이 아니라면 null로 세팅합니다.
		// 커맨드체커 교체 시 targetobject이 댕글링이 되어 팅버그가 발생하여 targetobject포인터를 널처리 합니다.
		sq_SetTargetObjectAICharacter(onlyAiChr, null, false);
		
		// 다음방으로 이용하기 위해 쓰인 플래그 입니다. 내가 ai가 콘트롤하는 오브젝트인지 체크하는 플래그 입니다 (irdsqrcharacter)
		aiChr.setAIModeByControlObject(aiMode); 
		// 커맨트 체크에서 ai모드가 on인지 off인지 체크하는 플래그를 세팅하는 함수 입니다.
		cmdChecker.setAIMode(aiMode); 
		cmdChecker.commandListReset();
		
		// 키보드 잠금 풀기부분입니다.
		sq_SetEnableKeyInputType(cmdChecker, 0, true, 1);
		//cmdChecker.setEnableKeyInputType(0, true);
		
		aiChr.initCommandChecker(cmdChecker, aiMode);
		aiChr.setCommandChecker(cmdChecker);
		
		
		local skillMgr = aiChr.getSkillManager();
		
		if(skillMgr)
		{
			skillMgr.setParent(aiChr);
			skillMgr.setCommandChecker(cmdChecker);	// 스킬매니저와 커맨드체커를 연결
			local skillTree = aiChr.getCurrentSkillTree();
			skillMgr.addAllKeyCommand(skillTree);
			aiChr.flushCommandEnable();
		}
		
	}	
}

// 자식이 있는 본체인지 체크하는 함수입니다.
function isObjectWithChild(obj)
{	
	local ismychr = sq_IsMyCharacter(obj);
	local chr = sq_GetCNRDObjectToCharacter(obj);
	
	//print(" ismychr:" + ismychr + " job:" + sq_getJob(chr));
	if(ismychr)
	{
		
		local childSize = sq_GetMyControlObjectSize(obj);
		
		if(childSize > 0)
			return true;
	}
	
	return false;
}

// 나의 마스터의 콘트롤오브젝트인지 체크하는 함수입니다.
// 즉 파라미터로 전달된 obj가 콘트롤 되는 ai chr인지 체크하는 함수 입니다.
function isMasterControlObject(obj)
{
	if(!obj)
		return false;


	// 마스터 캐릭터(본체) CNUser::myCharacter_를 얻어냅니다.
	if(sq_GetMyMasterCharacter())
	{
		// CNUser::myCharacter_ 에서 myControlObject_ 벡터에서 find_if를 이용하여 맞는지 아닌지 구해냅니다.
		local bRet = sq_GetMyMasterCharacter().isMyControlObject(obj);
		
		return bRet;
	}
	return false;
}


// 요청한 varStr의 obj_vector 에 있는 obj들의 
// 외곽선을 다 지웁니다.
function releaseOutLine(obj, varStr)
{
	local objListSize = obj.getVar(varStr).get_obj_vector_size();	
	for(local i =0;i<objListSize;++i)
	{				
		local vObj = obj.getVar(varStr).get_obj_vector(i);
		
		if(vObj == null)
			continue;
			
		vObj.setCustomOutline(false, 0, true, 2);
	}
	
	obj.getVar(varStr).clear_obj_vector();	
}


// 콘트롤하는 모든 오브젝트의 커맨드 체커를 ai모드로 전환합니다.
function setAIControlObjCommandChecker(obj)
{
	local objListSize = sq_GetMyControlObjectSize(obj);
	for(local i =0;i < objListSize;++i)
	{
		local vObj =  sq_GetMyControlObject(obj, i);
		
		if(vObj == null)
			continue;

		local grabChr = sq_GetCNRDObjectToSQRCharacter(vObj);
		
		if(grabChr)
		{
			local cmdChecker = grabChr.getCommandChecker();
			grabChr.initCommandChecker(cmdChecker, true); // 자신이 콘트롤하기 위해 커맨드체커 ai플래그 부분을 true로 바꿉니다.
			grabChr.setCommandChecker(cmdChecker);
			// 커맨트 체크에서 ai모드가 on인지 off인지 체크하는 플래그를 세팅하는 함수 입니다.
			cmdChecker.setAIMode(true);  
			// 다음방으로 이용하기 위해 쓰인 플래그 입니다. 내가 ai가 콘트롤하는 오브젝트인지 체크하는 플래그 입니다 (irdsqrcharacter)
			grabChr.setAIModeByControlObject(true);  
			
			local onlyAiChr = sq_GetCNRDObjectToAICharacter(grabChr);

			sq_SetTargetObjectAICharacter(onlyAiChr, null, false);

			local skillMgr = grabChr.getSkillManager();
			
			if(skillMgr)
			{
				skillMgr.setParent(grabChr);
				skillMgr.setCommandChecker(cmdChecker);	// 스킬매니저와 커맨드체커를 연결
				local skillTree = grabChr.getCurrentSkillTree();
				skillMgr.addAllKeyCommand(skillTree);
				grabChr.flushCommandEnable();
			}
		}
	}
}

// 선택된 obj벡터에서 obj 외곽선을 그립니다.
function setOutLine(obj, varStr, rgb)
{
	local objListSize = obj.getVar(varStr).get_obj_vector_size();	
	for(local i =0;i<objListSize;++i)
	{				
		local vObj = obj.getVar(varStr).get_obj_vector(i);
		
		if(vObj == null)
			continue;

		vObj.setCustomOutline(true, rgb, false, 1);
	}
}

// 멤버 orgStr 구룹의 오브젝트 벡터를 멤버 dstStr 구룹의 오브젝트 벡터에 똑같이 카피합니다.
function objCopy(obj, dstStr, orgStr)
{
	obj.getVar(dstStr).clear_obj_vector();
	
	local objListSize = obj.getVar(orgStr).get_obj_vector_size();	
	for(local i =0;i<objListSize;++i)
	{				
		local vObj = obj.getVar(orgStr).get_obj_vector(i);
		
		if(vObj == null)
			continue;
			
		obj.getVar(dstStr).push_obj_vector(vObj);
	}	
}


// 범위내에 맞는 오브젝트가 있는 체크해서 있으면.. 멤버 hoverd 구룹 벡터에 푸시합니다.
function pushOverClickableObject(obj, x, y, w, h)
{
	if(!obj)
		return null;
		
	local objectManager = obj.getObjectManager();
	

	if (objectManager == null)
		return null;
		
	local target = null;

	releaseOutLine(obj, "hoverd");
	
	for (local i = 0; i < objectManager.getCollisionObjectNumber(); i+=1)
	{
		local object = objectManager.getCollisionObject(i);
		
		if (object)
		{
			// 적이 아니고 본체의 자식이고 캐릭터이고 
			 //if( (obj.isEnemy(object) == false && isMasterControlObject(object) && object.isInDamagableState(obj) && object.isObjectType(OBJECTTYPE_CHARACTER)) || sq_IsMyCharacter(object))
			 if( (obj.isEnemy(object) == false && isMasterControlObject(object) && object.isInDamagableState(obj) && object.isObjectType(OBJECTTYPE_CHARACTER)))
			 {
				//sq_GetScreenXPos
				local width = sq_GetWidthObject(object);
				local height = sq_GetHeightObject(object);
				local screenX = sq_GetScreenXPos(object) - (width / 2);
				local screenY = sq_GetScreenYPos(object) - height;
				
				local isUnion = sq_IsIntersectRect(screenX, screenY, width, height, x, y, w, h);
				
				if(isUnion)
				{
					object.setCustomOutline(true, sq_RGBA(255, 255, 0, 255), false, 1);
					obj.getVar("hoverd").push_obj_vector(object);
				}
			}
		}
	}
}



// 원하는 방향으로 오브젝트를 이동시킵니다. 
// 이동시켜야 하는 오브젝트가 매 루프 실행되어야 하는 루프함수 입니다.
function procDestinationMove(obj)
{
	//obj.getVar("dstpos").clear_vector();
	local state = obj.getState();
	
	if (state != STATE_DASH && state != STATE_STAND)
		return;

	// dstpos는 이동하고자 하는 목적지 pos입니다.
	// 0(DIR_X_I) 은 x방향 1(DIR_Y_I) 은 y방향입니다.
	if (obj.getVar("dstpos").size_vector() == 0)
		return;		
		
	// movedir는 이동방향을 푸시한 vector데이타 입니다.
	// 0(DIR_X_I) 은 x방향 1(DIR_Y_I) 은 y방향입니다.
	if (obj.getVar("movedir").size_vector() == 0)
	{
		obj.getVar("movedir").push_vector(4);
		obj.getVar("movedir").push_vector(4);
	}
		
	
	local destinationXPos_ = obj.getVar("dstpos").get_vector(DIR_X_I);
	local destinationYPos_ = obj.getVar("dstpos").get_vector(DIR_Y_I);


	local xMoveDirection_ = obj.getVar("movedir").get_vector(DIR_X_I);
	local yMoveDirection_ = obj.getVar("movedir").get_vector(DIR_Y_I);
	
	if(obj.getDirection() != xMoveDirection_)
	{
		obj.setCurrentDirection(xMoveDirection_);
	}

	// 어디로 가야할지에 대한 방향을 설정해주는 부분입니다.
	
	// 우선 x좌표에 대한 방향을 설정합니다.
	//if(obj.getXPos() > destinationXPos_ && xMoveDirection_ == ENUM_DIRECTION_RIGHT)
	//{
		//// x좌표 보정부분입니다. 목표 좌표보다 오버됐을 경우 보정하는 부분입니다.	
		////  오른쪽으로 지나쳤을 때 : 좌표 보정 후 정지
		////sq_MoveToNearMovablePos(obj, destinationXPos_, obj.getYPos(), obj.getZPos(), destinationXPos_, obj.getYPos(), obj.getZPos(), 100, -1, 5);
		//obj.getVar("movedir").set_vector(DIR_X_I, ENUM_DIRECTION_NEUTRAL);
	//}
	//else if (obj.getXPos() < destinationXPos_ && xMoveDirection_ == ENUM_DIRECTION_LEFT)
	//{
		//// x좌표 보정부분입니다. 목표 좌표보다 오버됐을 경우 보정하는 부분입니다.	
		////  왼쪽으로 지나쳤을 때 : 좌표 보정 후 정지
		////sq_MoveToNearMovablePos(obj, destinationXPos_, obj.getYPos(), obj.getZPos(), destinationXPos_, obj.getYPos(), obj.getZPos(), 100, -1, 5);
		//obj.getVar("movedir").set_vector(DIR_X_I, ENUM_DIRECTION_NEUTRAL);
	//}
	//else if (obj.getXPos() < destinationXPos_)
	
	local offset = sq_Abs(obj.getXPos() - destinationXPos_);
	if(offset <= 1)
	{
		sq_MoveToNearMovablePos(obj, destinationXPos_, obj.getYPos(), obj.getZPos(), destinationXPos_, obj.getYPos(), obj.getZPos(), 100, -1, 5);
		obj.getVar("movedir").set_vector(DIR_X_I, ENUM_DIRECTION_NEUTRAL);
	}
	else
	{
		//print(" offset:" + offset);
		if (obj.getXPos() < destinationXPos_)
		{
			obj.getVar("movedir").set_vector(DIR_X_I, ENUM_DIRECTION_RIGHT);
		}
		else if (obj.getXPos() > destinationXPos_)
		{
			obj.getVar("movedir").set_vector(DIR_X_I, ENUM_DIRECTION_LEFT);
		}
		else
			obj.getVar("movedir").set_vector(DIR_X_I, ENUM_DIRECTION_NEUTRAL);
	}
	//////////////////////////////////////////////////


	// 우선 y좌표에 대한 방향을 설정합니다.
	if (obj.getYPos() > destinationYPos_ && yMoveDirection_ == ENUM_DIRECTION_DOWN)
	{
		// y좌표 보정부분입니다. 목표 좌표보다 오버됐을 경우 보정하는 부분입니다.
		//  아래쪽으로 지나쳤을 때 : 좌표 보정 후 정지
		//sq_MoveToNearMovablePos(obj, obj.getXPos(), destinationYPos_, obj.getZPos(), obj.getXPos(), destinationYPos_, obj.getZPos(), 100, -1, 5);
		obj.getVar("movedir").set_vector(DIR_Y_I, ENUM_DIRECTION_NEUTRAL);
	}
	else if (obj.getYPos() < destinationYPos_ && yMoveDirection_ == ENUM_DIRECTION_UP)
	{
		// y좌표 보정부분입니다. 목표 좌표보다 오버됐을 경우 보정하는 부분입니다.
		//  위쪽으로 지나쳤을 때 : 좌표 보정 후 정지
		//sq_MoveToNearMovablePos(obj, obj.getXPos(), destinationYPos_, obj.getZPos(), obj.getXPos(), destinationYPos_, obj.getZPos(), 100, -1, 5);
		obj.getVar("movedir").set_vector(DIR_Y_I, ENUM_DIRECTION_NEUTRAL);
	}
	else if (obj.getYPos() < destinationYPos_)
		obj.getVar("movedir").set_vector(DIR_Y_I, ENUM_DIRECTION_DOWN);
	else if (obj.getYPos() > destinationYPos_)
	{
		obj.getVar("movedir").set_vector(DIR_Y_I, ENUM_DIRECTION_UP);
		local direction = obj.getVar("movedir").get_vector(DIR_Y_I);
	}
	else
		obj.getVar("movedir").set_vector(DIR_Y_I, ENUM_DIRECTION_NEUTRAL);
	//////////////////////////////////////////////////////////////////////////////
	


	// 멈춰야하는 순간을 체크하여 멈추게 합니다.
	// 목적지에 도착했거나 오브젝트의 state가 stand나 dash상태가 아니라면 이동시키면 안됩니다.
	// 같은 장소를 계속 제자리 걷기나 뛰기를 하면 안되기 때문에 현재 좌표를 저장했다가 
	// 다음프레임에서 비교해봐서 같은 좌표라면 동작을 멈추게 합니다.
	
	local state = obj.getState(); 
	local beforeXPos = obj.getVar("dstpos").get_vector(2); // 전프레임에 이동했던 좌표 저장공간 입니다. (x)
	local beforeYPos = obj.getVar("dstpos").get_vector(3); // 전프레임에 이동했던 좌표 저장공간 입니다. (y)
	
	// 전프레임과 동일할 때 카운트를 늘려줘서 카운트가 어느정도 찼을때 이동불가라 판단하여 멈추게 합니다. 
	// 바로 처음 이동했을땐 전프레임과 어차피 좌표가 같기때문에 이 같은 방법을 썼습니다.
	local samdCnt = obj.getVar("dstpos").get_vector(4);
	if(beforeXPos == obj.getXPos() && beforeYPos == obj.getYPos())
	{
		obj.getVar("dstpos").set_vector(4, samdCnt + 1);
		samdCnt = obj.getVar("dstpos").get_vector(4);
	}
	
	if(obj.isMyControlObject())
	{
		local stage = sq_GetObjectManagerStage(obj);
		local control = stage.getMainControl();
		
		if(!control.IsRBDown())
		{
			if(destinationXPos_ == obj.getXPos() && destinationYPos_ == obj.getYPos() || (state != STATE_STAND && state != STATE_DASH))
			{
				//print(" arrived dstX:" + destinationXPos_ + " getX:" + obj.getXPos() + " samdCnt:" + samdCnt);
				obj.getVar("dstpos").clear_vector();
				sq_SetVelocity(obj, 0, 0.0);
				sq_SetVelocity(obj, 1, 0.0);
				obj.getVar("movedir").set_vector(DIR_X_I, ENUM_DIRECTION_NEUTRAL);
				obj.getVar("movedir").set_vector(DIR_Y_I, ENUM_DIRECTION_NEUTRAL);

				local actobj = sq_GetCNRDObjectToActiveObject(obj);
				if(actobj)
				{
					print(" state_stand"); 
					sq_AddSetStatePacketCollisionObject(actobj, STATE_STAND, null, STATE_PRIORITY_USER, true);
				}
				
				return;
			}
		}
	}



	//  속력 알아내기
	local isDash = obj.getVar("dash").get_vector(0);
	
	// 기본적인 워킹에서는 기본속도가 세팅됩니다.
	local xNormalVel = X_NORMALMOVE_VELOCITY;
	local yNormalVel = Y_NORMALMOVE_VELOCITY;
	local xSlantVel = X_SLANTMOVE_VELOCITY;
	local ySlantVel = Y_SLANTMOVE_VELOCITY;
	
	// 대쉬라면 속도를 달리세팅합니다.
	if(isDash)
	{
		xNormalVel = X_NORMALDASH_VELOCITY;
		yNormalVel = Y_NORMALDASH_VELOCITY;
		xSlantVel = X_SLANTDASH_VELOCITY;
		ySlantVel = Y_SLANTDASH_VELOCITY;
	}
	
	local xVelocity = xNormalVel;
	local yVelocity = yNormalVel;
	
	xMoveDirection_ = obj.getVar("movedir").get_vector(DIR_X_I);
	yMoveDirection_ = obj.getVar("movedir").get_vector(DIR_Y_I);

	if(yMoveDirection_ == ENUM_DIRECTION_NEUTRAL)
		xVelocity = xNormalVel;
	else
		xVelocity = xSlantVel;
		
	if(xMoveDirection_ == ENUM_DIRECTION_NEUTRAL)
		yVelocity = yNormalVel;
	else
		yVelocity = ySlantVel;
		
	if (xMoveDirection_ == ENUM_DIRECTION_NEUTRAL)
		xVelocity = xVelocity.tofloat() * 0.0;
	else if (xMoveDirection_ == ENUM_DIRECTION_LEFT)
		xVelocity = xVelocity.tofloat() * -1.0;
		
	if (yMoveDirection_ == ENUM_DIRECTION_NEUTRAL)
		yVelocity = yVelocity.tofloat() * 0.0;
	else if (yMoveDirection_ == ENUM_DIRECTION_UP)
		yVelocity = yVelocity.tofloat() * -1.0;

	sq_SetVelocity(obj, DIR_X_I, xVelocity.tofloat());
	sq_SetVelocity(obj, DIR_Y_I, yVelocity.tofloat());
	
	// 같은 장소를 계속 제자리 걷기나 뛰기를 하면 안되기 때문에 현재 좌표를 저장했다가 
	// 다음프레임에서 비교해봐서 같은 좌표라면 동작을 멈추게 합니다.
	obj.getVar("dstpos").set_vector(2, obj.getXPos()); // 전프레임에 이동했던 좌표 저장공간 입니다. (x)
	obj.getVar("dstpos").set_vector(3, obj.getYPos()); // 전프레임에 이동했던 좌표 저장공간 입니다. (y)
	
}

// 파라미터로 전달된 obj에 대상좌표 이동하는 정보를 세팅합니다.
function setMovGrabObj(obj, dstX, dstY, isDash)
{
	//  이동 가능한 좌표면
	//  목적지 이동 셋팅
	local actobj = sq_GetCNRDObjectToActiveObject(obj);
	
	if(actobj)
	{
		actobj.getVar("dstpos").clear_vector();
		actobj.getVar("dstpos").push_vector(dstX);
		actobj.getVar("dstpos").push_vector(dstY);
		actobj.getVar("dstpos").push_vector(0); // 전프레임에 이동했던 좌표 저장공간 입니다. (x)
		actobj.getVar("dstpos").push_vector(0); // 전프레임에 이동했던 좌표 저장공간 입니다. (y)
		actobj.getVar("dstpos").push_vector(0); // 전프레임에 이동했던 좌표와 동일할 때 카운트 변수 입니다.
		
		actobj.getVar("movedir").set_vector(DIR_X_I, ENUM_DIRECTION_NEUTRAL);
		actobj.getVar("movedir").set_vector(DIR_Y_I, ENUM_DIRECTION_NEUTRAL);
		
		actobj.getVar("dash").clear_vector();
		actobj.getVar("dash").push_vector(isDash);
		
		local grabChr = sq_GetCNRDObjectToSQRCharacter(actobj); // chr로 다이나믹캐스팅을 합니다.
		
		//if(grabChr)
			//setCommandCheckerMyControlChracter(grabChr, false);
		
		//print(" move obj:" + obj + " dash:" + isDash);
		if(isDash)
		{
			sq_AddSetStatePacketCollisionObject(actobj, STATE_DASH, null, STATE_PRIORITY_USER, true);
			//sq_AddSetStatePacketActiveObject(actobj, STATE_DASH, null, STATE_PRIORITY_USER);
		}
		else
		{
			sq_AddSetStatePacketCollisionObject(actobj, STATE_STAND, null, STATE_PRIORITY_USER, true);
			//sq_AddSetStatePacketActiveObject(actobj, STATE_STAND, null, STATE_PRIORITY_USER);
		}
	}

}



// 선택된 캐릭터의 스킬매니져만 세팅합니다. 이번 프로토타입에서는 선택을 해도 AI가 멈추면 안되기 때문에 AI 활성화 상태에서 스킬 슬롯만 새로 세팅하는 구조로 갑니다.
// 그리고 버튼을 눌렀을때만 이제 커맨드체커를 세팅해줍니다.
function setSkillManagerMyControlChracter(aiChr)
{
	if(!aiChr)
		return;
	
	local cmdChecker = aiChr.getCommandChecker();
	
	if(cmdChecker)
	{
		local onlyAiChr = sq_GetCNRDObjectToAICharacter(aiChr);
		sq_SetTargetObjectAICharacter(onlyAiChr, null, false);
		// 다음방으로 이용하기 위해 쓰인 플래그 입니다. 내가 ai가 콘트롤하는 오브젝트인지 체크하는 플래그 입니다 (irdsqrcharacter)
		// 캐릭이 선택되더라도 ai모드가 켜져있어야하기 때문에 true로 유지시켜줍니다.
		aiChr.setAIModeByControlObject(true); 
		
		local skillMgr = aiChr.getSkillManager();
		
		if(skillMgr)
		{
			skillMgr.setParent(aiChr);
			skillMgr.setCommandChecker(cmdChecker);	// 스킬매니저와 커맨드체커를 연결
			local skillTree = aiChr.getCurrentSkillTree();
			skillMgr.addAllKeyCommand(skillTree);
			aiChr.flushCommandEnable();
		}
	}
}


// 요청한 파라미터의 aiChr를 콘트롤할 수 있도록 커맨드체커와 스킬매니져를 세팅합니다.
function setMyControlChracter(aiChr)
{
	if(!aiChr)
		return;
	
	local cmdChecker = aiChr.getCommandChecker();	
	if(cmdChecker)
	{
		local onlyAiChr = sq_GetCNRDObjectToAICharacter(aiChr);
		sq_SetTargetObjectAICharacter(onlyAiChr, null, false);
		
		aiChr.setAIModeByControlObject(false); // 다음방으로 이용하기 위해 쓰인 플래그 입니다. 내가 ai가 콘트롤하는 오브젝트인지 체크하는 플래그 입니다 (irdsqrcharacter)
		cmdChecker.setAIMode(false); // 커맨트 체크에서 ai모드가 on인지 off인지 체크하는 플래그를 세팅하는 함수 입니다.
		cmdChecker.commandListReset();
		aiChr.initCommandChecker(cmdChecker, false);
		aiChr.setCommandChecker(cmdChecker);
		
		local skillMgr = aiChr.getSkillManager();
		
		if(skillMgr)
		{
			skillMgr.setParent(aiChr);
			skillMgr.setCommandChecker(cmdChecker);	// 스킬매니저와 커맨드체커를 연결
			local skillTree = aiChr.getCurrentSkillTree();
			skillMgr.addAllKeyCommand(skillTree);
			aiChr.flushCommandEnable();
		}
	}

}


// 범위내에 맞는 오브젝트가 있는 체크해서 있으면.. 오브젝트 객체를 리턴합니다.
function getOverClickableEnemyObject(obj, x, y)
{
	if(!obj)
		return null;
		
	local group = -1;
	local uniqueId = -1;
	
	local objectManager = obj.getObjectManager();
	

	if (objectManager == null)
		return null;
		
	local target = null;

	//releaseOutLine(obj, "hoverd");
	
	for (local i = 0; i < objectManager.getCollisionObjectNumber(); i+=1)
	{
		local object = objectManager.getCollisionObject(i);
		
		if (object)
		{
			// 적이 아니고 본체의 자식이고 캐릭터이고 
			 if( (obj.isEnemy(object) == true && object.isInDamagableState(obj)) )
			 {
				//local width = sq_GetWidthObject(object);
				//local height = sq_GetHeightObject(object);
				//local screenX = sq_GetScreenXPos(object) - (width / 2);
				//local screenY = sq_GetScreenYPos(object) - height;
				//
				//local isUnion = sq_IsIntersectRect(screenX, screenY, width, height, x, y, w, h);
				local isUnion = object.isOverPos(x, y);
				
				if(isUnion)
				{
					group = sq_GetGroup(object);
					uniqueId = sq_GetUniqueId(object);
					//print(" group:" + group + " uniqueId:" + uniqueId);
					//object.setCustomOutline(true, sq_RGBA(255, 255, 0, 255), false, 2);
					//return group, uniqueId;
					return object;
				}
			}
		}
	}
	
	return null;
}


// 더블섀도우에서 자신의 콘트롤오브젝트를 세팅하는 부분입니다. 즉
// #define getMyCharacter()		(getMyControlCharacter()) 를 바꿔주는 부분입니다. 
function setConrolCharacter(obj, index)
{
	local controlSize = sq_GetMyControlObjectSize(obj);
	
	if(index < 0 || controlSize <= index)
		return;
	
	releaseOutLine(obj, "grabobj");
	releaseOutLine(obj, "hoverd");
	//
	local vObj = sq_GetMyControlObject(obj, index); // 선택될 캐릭터를 얻어온다..
	//
	local grabChr = sq_GetCNRDObjectToSQRCharacter(vObj); // chr로 다이나믹캐스팅을 합니다.
	//
	if(grabChr)
	{
		// 콘트롤하는 모든 오브젝트의 커맨드 체커를 ai모드로 전환합니다.
		setAIControlObjCommandChecker(obj); // 선택된 캐릭터의 커맨드체커를 전부 ai로 바꾼다.
		//// 캐릭터 선택
		obj.getVar("grabobj").push_obj_vector(vObj); // grabobj 
		// 선택된 캐릭터의 스킬매니져만 세팅합니다. 이번 프로토타입에서는 선택을 해도 AI가 멈추면 안되기 때문에 AI 활성화 상태에서 스킬 슬롯만 새로 세팅하는 구조로 갑니다.
		// 그리고 버튼을 눌렀을때만 이제 커맨드체커를 세팅해줍니다.
		setSkillManagerMyControlChracter(grabChr);
		// 바인딩 함수 입니다. CNUser::setMyControlCharacter(character); grabChr가 콘트롤하는 캐릭터라고 알려줍니다.
		// CNUser::myControlCharacter_ = grabChr가 됩니다.
		sq_SetMyControlCharacter(grabChr);
	}
}
