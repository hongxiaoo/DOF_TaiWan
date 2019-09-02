
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_common_burster")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_common_burster")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_common_burster")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_common_burster")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_common_burster")
	appendage.sq_AddFunctionName("onStartMap", "onStartMap_appendage_common_burster")
	appendage.sq_AddFunctionName("onAttackParent", "onAttackParent_appendage_common_burster")
}


function sq_AddEffect(appendage)
{
	appendage.sq_AddEffectBack("Character/Common/Animation/BusterMode/buster_loop_back_normal.ani");
	appendage.sq_AddEffectFront("Character/Common/Animation/BusterMode/buster_loop_front_normal.ani");
}


function onStartMap_appendage_common_burster(appendage)
{
	if(!appendage)
		return;
		
	local obj = appendage.getParent();
	
	if(!obj)
	{
		appendage.setValid(false);
		return;
	}
		
	local validT = appendage.getAppendageInfo().getValidTime();

	local useTime = appendage.getTimer().Get();

	local remainT = validT - useTime;

	print(" remain validT:" + remainT);

	if (obj.isMyControlObject())
	{
		if (remainT > 0)
		{
			sq_flashScreen(obj, 0, remainT, 300, 150, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
		}
	}
}

function proc_appendage_common_burster(appendage)
{
	if(!appendage) {
		return;
	}
}

function onAttackParent_appendage_common_burster(appendage, realAttacker, damager, boundingBox, isStuck)
{
	if(!appendage) {
		return;
	}

	// 버스터모드로 쳤다면..
	if (appendage.isValid())
	{
		local centerX = sq_GetCenterXPos(boundingBox);
		local centerZ = sq_GetCenterZPos(boundingBox);

		local posY = damager.getYPos();

		local hitEffAni = sq_CreateAnimation("","Character/Common/Animation/BusterMode/buster_hit_back_normal1.ani");
		local hitBackEffObj = sq_CreatePooledObject(hitEffAni, true);
		hitBackEffObj.setCurrentPos(centerX, posY - 1, centerZ);
		sq_AddObject(realAttacker, hitBackEffObj, OBJECTTYPE_DRAWONLY, false);

		local hitFrontEffAni = sq_CreateAnimation("","Character/Common/Animation/BusterMode/buster_hit_front_dodge.ani");
		local hitFrontEffObj = sq_CreatePooledObject(hitFrontEffAni, true);
		hitFrontEffObj.setCurrentPos(centerX, posY + 1, centerZ);
		sq_AddObject(realAttacker, hitFrontEffObj, OBJECTTYPE_DRAWONLY, false);
	}
}


function onStart_appendage_common_burster(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
	
	if (!obj)
	{
		appendage.setValid(false);
		return;
	}

	local validT = appendage.getAppendageInfo().getValidTime();

	if (obj.isMyControlObject())
	{
		print(" sq_flashScreen validTime:" + validT);
		local fScreen = sq_flashScreen(appendage.getParent(),0,validT - 300,300,150, sq_RGB(0,0,0), GRAPHICEFFECT_NONE, ENUM_DRAWLAYER_BOTTOM);
	}
	
	////////////////////////
	// 스펙트럼 어펜디지 등록
	///////////////////////
	local spectrumAppendage = appendage.sq_GetOcularSpectrum("ocularSpectrum");
	
	if(!spectrumAppendage)
	{
		spectrumAppendage = appendage.sq_AddOcularSpectrum("ocularSpectrum", obj, obj, 100);
	}
	
	sq_SetParameterOcularSpectrum(spectrumAppendage, 800, 100, true, sq_RGBA(20, 80, 200, 255), sq_RGBA(20, 80, 200, 0), 2, 2, 2);
	sq_SetParameterOcularSpectrum(spectrumAppendage, 800, 100, true, sq_RGBA(20, 80, 200, 255), sq_RGBA(20, 80, 200, 0), 2, 0, 1);
	///////////////////////	

	local chr = sq_ObjectToSQRCharacter(obj);

	if (chr)
	{
		//쿨타임을 초기화 시켜야할 스킬들을 글로벌벡터에 넣습니다.

		local bursterSkill = sq_GetSkill(chr, SKILL_BURSTER);
	
		local pIntVec = sq_GetGlobalIntVector();
		sq_IntVectorClear(pIntVec);
		sq_IntVectorPush(pIntVec, SKILL_BURSTER); // 우선 버스터모드 스킬 본인부터 푸시합니다.

		local size = sq_GetCustomIntDataSize(bursterSkill, chr);

		for (local i = 0; i < size; i++)
		{
			// 금지된 스킬인덱스들을 얻어온다.
			local disableSkillIndex = sq_GetIntData(chr, SKILL_BURSTER, i);
			sq_IntVectorPush(pIntVec, disableSkillIndex);
		}

		sq_SetStartCoolTime(chr, 0, pIntVec);
		//
		print(" pooled obj");

		local posX = chr.getXPos();
		local posY = chr.getYPos();
		local posZ = chr.getZPos();

		//local buster_loop_back_normal = sq_CreateAnimation("","Character/Common/Animation/BusterMode/buster_loop_back_normal.ani");
		//local buster_loop_back_normalObj = chr.sq_CreateCNRDPooledObject(buster_loop_back_normal);
		//buster_loop_back_normalObj.setCurrentDirection(chr.getDirection());
		//buster_loop_back_normalObj.setCurrentPos(posX, posY - 1, 0);
		//chr.sq_AddObject(buster_loop_back_normalObj);

		//local backEffObj = sq_CreateDrawOnlyObject(obj, "Character/Common/Animation/BusterMode/buster_loop_back_normal.ani",
		//ENUM_DRAWLAYER_NORMAL, false);

		//sq_moveWithParent(chr, backEffObj);

		//local frontEffObj = sq_CreateDrawOnlyObject(obj, "Character/Common/Animation/BusterMode/buster_loop_front_normal.ani",
		//ENUM_DRAWLAYER_NORMAL, false);

		//frontEffObj.setCurrentPos(posX, posY - 1, 0);

		//sq_moveWithParent(chr, frontEffObj);

		//buster_loop_front_normal.ani.als
	}

	
}


function prepareDraw_appendage_common_burster(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}




function onEnd_appendage_common_burster(appendage)
{
	if(!appendage) {
		return;
	}
	
	
	local obj = appendage.getParent();
	
	local spectrumAppendage = appendage.sq_GetOcularSpectrum("ocularSpectrum");
	
	print(" onend burst:" + spectrumAppendage);
	if(spectrumAppendage)
	{
		spectrumAppendage.endCreateSpectrum();
	}
	
	//CNSquirrelAppendage.sq_RemoveAppendage(obj, "Character/Common/Burster/ap_Common_Burster.nut");
	
}


// 어벤져 각성 변신의 끝부분
function isEnd_appendage_common_burster(appendage)
{	
	return false;
}