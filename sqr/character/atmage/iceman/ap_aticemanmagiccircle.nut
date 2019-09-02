
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_grab_icemagic")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_grab_icemagic")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_grab_icemagic")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_grab_icemagic")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_grab_icemagic")
	appendage.sq_AddFunctionName("onDestroyObject", "onDestroyObject_appendage_grab_icemagic")
}


function sq_AddEffect(appendage)
{
}

function proc_appendage_grab_icemagic(appendage)
{
	if(!appendage)
	{
		return;
	}
	
	if(!appendage.isValid())
		return;
		
	local obj = appendage.getParent();	
	
	if (obj.getState() != STATE_HOLD && obj.getState() != STATE_DIE)
	{
		//  던져지는 대상이 HOLD가 아니면
		if (obj.isMyControlObject())
		{
			//  HOLD로 전환
			local pIntVec = sq_GetGlobalIntVector();
			sq_IntVectorClear(pIntVec);
			sq_IntVectorPush(pIntVec, Z_ACCEL_TYPE_CONST);
			
			obj.addSetStatePacket(STATE_HOLD, pIntVec, STATE_PRIORITY_FORCE, false, "");
			
			obj.flushSetStatePacket();
		}
	}
	
	
}

function onDestroyObject_appendage_grab_icemagic(appendage, destroyObj)
{
	if(!appendage)
		return true;
	
	if (destroyObj == appendage.sq_GetSourceChrTarget())
	{
		appendage.setValid(false);
	}
		
	return true;
}

function onStart_appendage_grab_icemagic(appendage)
{
	if(!appendage)
	{
		return;
	}

	local obj = appendage.getParent();	

	if(!obj)
	{
		return;
	}
	
	appendage.getVar().clear_vector();
	
	appendage.getVar().push_vector(0); // 0
	appendage.getVar().push_vector(0); // 1
	appendage.getVar().push_vector(0); // 2
	appendage.getVar().push_vector(0); // 3
	appendage.getVar().push_vector(0); // 4
	appendage.getVar().push_vector(0); // 5

	sq_SetCustomDamageType(obj, true, 1); // DAMAGETYPE_SUPERARMOR = 1
	sq_SetGrabable(obj, false);

	if (sq_IsValidActiveStatus(obj, ACTIVESTATUS_STUN))
	{
		//  STUN 걸려있으면 해제시킴. STATE_STAND로 돌아가지 않게 disable시킴
		obj.setEnableChangeState(false);
		sq_IsSetActiveStatus(obj, ACTIVESTATUS_STUN, 0.0);
		obj.setEnableChangeState(true);
	}
	print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");

}


function prepareDraw_appendage_grab_icemagic(appendage)
{
	if(!appendage) {
		return;
	}
	
	//if (attacker_->getState() != CNFighter::STATE_SUPLEX)
	//	return;
	
	if(!appendage.isValid())
		return;
	
	local attacker = appendage.sq_GetSourceChrTarget();
	
	if(!attacker)
	{
		appendage.setValid(false);
		return;
	}

	if (attacker.getState() != STATE_ICEMAN)
	{
		appendage.setValid(false);
		return;
	}
	
	if(attacker.getState() == STATE_ICEMAN && attacker.getSkillSubState() == SUB_STATE_ICEMAN_4)
	{
		local frmIndex = sq_GetCurrentFrameIndex(attacker);
		
		if(frmIndex >= 6)
		{
			appendage.setValid(false);
			return;
		}
	}
	
	//print(" attacker.getSkillSubState():" + attacker.getSkillSubState());

	local obj = appendage.getParent();	


	if(attacker.getState() == STATE_ICEMAN && attacker.getSkillSubState() == SUB_STATE_ICEMAN_3) // 난타동작
	{
		//appendage.getVar().get_vector(0)
		local isHit = false;
		local frmIndex = sq_GetCurrentFrameIndex(attacker);
		
		if(frmIndex >= 1 && !appendage.getVar().get_vector(0))
		{
			isHit = true;
			appendage.getVar().set_vector(0, 1);
		}

		if(frmIndex >= 4 && !appendage.getVar().get_vector(1))
		{
			isHit = true;
			appendage.getVar().set_vector(1, 1);
		}

		if(frmIndex >= 8 && !appendage.getVar().get_vector(2))
		{
			isHit = true;
			appendage.getVar().set_vector(2, 1);
		}

		if(frmIndex >= 11 && !appendage.getVar().get_vector(3))
		{
			isHit = true;
			appendage.getVar().set_vector(3, 1);
		}

		if(frmIndex >= 16 && !appendage.getVar().get_vector(4))
		{
			isHit = true;
			appendage.getVar().set_vector(4, 1);
		}

		
		if(isHit)
		{
			if(attacker.isMyControlObject())
			{
				print(" hit");
				local h = (sq_GetObjectHeight(obj) / 2);
				//sq_SendHitObjectPacket(attacker,obj,0,0,0);
			}
		}
	}

	// 이 어펜디지 걸린놈을 받아온다
	// 걸린놈이 현재 HOLD 상태가 아니라면
	if (obj.getState() != STATE_HOLD)
		// 캔슬
		return;

	
}




function onEnd_appendage_grab_icemagic(appendage)
{
	if(!appendage)
	{
		return;
	}
	
	local obj = appendage.getParent();
	
	//sq_SetCustomRotate(obj, 0.0);
	sq_SetCustomDamageType(obj, false, 0); // DAMAGETYPE_NORMAL = 0
	sq_SetGrabable(obj, true);
	
	//CNSquirrelAppendage.sq_AppendAppendage(damager, pChr, SKILL_ICEMAN, 
	//false, "Character/ATMage/IceMan/ap_ATIceManMagicCircle.nut", true);
	
	//CNSquirrelAppendage.sq_RemoveAppendage(obj, "Character/ATMage/IceMan/ap_ATIceManMagicCircle.nut");

	
	if(obj.isMyControlObject())
	{
		//sq_AddSetStatePacketActiveObject(obj, STATE_STAND, null, STATE_PRIORITY_USER);
		//obj.sq_AddSetStatePacket(STATE_STAND, STATE_PRIORITY_USER, false);
		
		//local pIntVec = sq_GetGlobalIntVector();
		//sq_IntVectorClear(pIntVec);
		//sq_IntVectorPush(pIntVec, obj.getDirection());
		//sq_IntVectorPush(pIntVec, 0);
		//sq_IntVectorPush(pIntVec, DOWN_PARAM_TYPE_FORCE);
		//sq_IntVectorPush(pIntVec, 0);
		//sq_IntVectorPush(pIntVec, 10);
		//obj.addSetStatePacket(STATE_DOWN, pIntVec, STATE_PRIORITY_FORCE, false, "");
		obj.addSetStatePacket(STATE_STAND, null, STATE_PRIORITY_FORCE, false, "");
		obj.flushSetStatePacket();
		print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
	}
}


// 어벤져 각성 변신의 끝부분
function isEnd_appendage_grab_icemagic(appendage)
{
	if(!appendage) return false;
	
	local T = appendage.getTimer().Get();
	
	return false;
}