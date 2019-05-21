
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_IceCrash")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_IceCrash")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_IceCrash")
}

function sq_AddEffect(appendage)
{
}



function proc_appendage_IceCrash(appendage)
{
	if(!appendage) {
		return;		
	}

	local parentObj = appendage.getParent();
	local sourceObj = appendage.getSource();
				
	if(!sourceObj || !parentObj) {
		appendage.setValid(false);
		return;
	}
				
	local x = sq_GetDistancePos(sourceObj.getXPos(), sourceObj.getDirection(), 155);
	local t = sq_GetShuttleValue(0, 10,sq_GetObjectTime(parentObj),50)-5;
	x = x + (t >= 0 ? 3 : -3);
	local z = sourceObj.getZPos() + 50 - parentObj.getObjectHeight()/2;	
				
	if(z < 0)
		z = 0;
	sq_SetCurrentPos(parentObj, x, sourceObj.getYPos()-1,z);
}



function onStart_appendage_IceCrash(appendage)
{
	if(!appendage) {
		return;
	}
	
	local parentObj = appendage.getParent();
	local sourceObj = appendage.getSource();
				
	if(!sourceObj || !parentObj) {
		appendage.setValid(false);
		return;
	}	
}



function onEnd_appendage_IceCrash(appendage)
{
	if(!appendage) {
		return;
	}	
	
	local obj = appendage.getParent();
	local sourceObj = appendage.getSource();
	if(obj && sq_IsMyControlObject(obj) ) {
		local xPos = obj.getXPos();
		local yPos = obj.getYPos();

		// 직선상 이동 가능한 좌표를 찾는다
		if (moveDamagerLinerMovablepos(obj, sourceObj.getDirection(), 50) == false)
		{
			// 직선상 가능한 좌표를 못찾은 경우 시전자의 위치가 정상적인 경우 시전자의 위치로 이동
			if (obj.isMovablePos(sourceObj.getXPos(), sourceObj.getYPos()) == true)
			{
				sq_SetCurrentPos(obj, sourceObj.getXPos(), sourceObj.getYPos(), obj.getZPos());
			}
			// 시전자의 위치도 이상한 경우 주변의 적당한 위치 선정
			else
			{
				sq_SimpleMoveToNearMovablePos(obj,200);
			}
		}
	}		
}

function moveDamagerLinerMovablepos(damager, dir, movableRange)
{
	local xPos = damager.getXPos();
	local yPos = damager.getYPos();
	local toXPos = xPos

	if (dir == ENUM_DIRECTION_LEFT)
	{
		toXPos = xPos - movableRange;
	}
	else
	{
		toXPos = xPos + movableRange;
	}

	toXPos = damager.sq_findNearLinearMovableXPos(xPos, yPos, toXPos, yPos, 10);
	if (damager.isMovablePos(toXPos, yPos) == true)
	{
		sq_SetCurrentPos(damager, toXPos, yPos, damager.getZPos());
		return true;
	}
	else
	{
		if (dir == ENUM_DIRECTION_LEFT)
		{
			toXPos = xPos + movableRange;
		}
		else
		{
			toXPos = xPos - movableRange;
		}

		toXPos = damager.sq_findNearLinearMovableXPos(xPos, yPos, toXPos, yPos, 10);
		if (damager.isMovablePos(toXPos, yPos) == true)
		{
			sq_SetCurrentPos(damager, toXPos, yPos, damager.getZPos());
			return true;
		}
	}

	return false;
}