
function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_avenger_awakening")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_avenger_awakening")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_avenger_awakening")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_avenger_awakening")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_avenger_awakening")
	appendage.sq_AddFunctionName("onSetHp", "onSetHp_appendage_avenger_awakening")
}


function sq_AddEffect(appendage)
{
	//appendage.sq_AddEffectFront("Character/Priest/Effect/Animation/ScytheMastery/1_aura_normal.ani")
}




function proc_appendage_avenger_awakening(appendage)
{
	if(!appendage) {
		return;
	}
	
	//appendage.sq_var.set_vector(I_DOOMS_HP, after_hp);
}

function onSetHp_appendage_avenger_awakening(appendage, hp, attacker)
{
	local obj = appendage.getParent();
	
	if(appendage.sq_var.size_vector() != (I_AVENGER_AWAKENING_VALID + 1)) {
		return -1;
	}

	if(attacker && obj && obj.isEnemy(attacker))
	{	// 적에 의한
		local org_hp = hp;
		
		if (org_hp <= 0) {
			org_hp = 1;
			appendage.sq_var.set_vector(I_DOOMS_HP, 0);
		}
		
		return org_hp;
	}

	
	//if(attacker && obj && obj.isEnemy(attacker))
	//{	// 적에 의한
		//local org_hp = obj.getHp();
		//
		//if (hp < obj.getHp())
		//{	// HP 감소라면
			//local doomshp = appendage.sq_var.get_vector(I_DOOMS_HP); // 변신한 어벤져의 hp값
			//local damage = obj.getHp() - hp;
			//
			//local after_hp = doomshp - damage;
			//
			//if(after_hp < 0)
				//after_hp = 0;
				//
			////print("\n doomsgudian hp:" + after_hp);
				//
			//appendage.sq_var.set_vector(I_DOOMS_HP, after_hp);
		//}
		//
		//return org_hp;
	//}
	
	return -1;
}




function onStart_appendage_avenger_awakening(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
	
	
	obj.setObjectHeight(-1);
	
	//obj.setHp(2, null, false);
	//appendage.sq_var.clear_vector();		
	//appendage.sq_var.push_vector(20000); // I_AVENGER_AWAKENING_TIME	
	//appendage.sq_var.push_vector(4000); // 완전 변신체 HP 

}


function prepareDraw_appendage_avenger_awakening(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();	
}




function onEnd_appendage_avenger_awakening(appendage)
{
	if(!appendage) {
		return;
	}
	
	local obj = appendage.getParent();		
	obj.setObjectHeight(-1);
	//appendage.sq_var.set_vector(I_AVENGER_AWAKENING_VALID, 0);
	
	local hpmaxup_appendage = appendage.sq_getHpMaxUp("HpMaxUp");
	
	if(hpmaxup_appendage) {
		if(hpmaxup_appendage.isValid()) {
			hpmaxup_appendage.setValid(false);
		}
	}
}


// 어벤져 각성 변신의 끝부분
function isEnd_appendage_avenger_awakening(appendage)
{
	local T = appendage.getTimer().Get();
	
	if(appendage.sq_var.size_vector() != (I_AVENGER_AWAKENING_VALID + 1)) {
		return true;
	}
	
	local maxT = appendage.sq_var.get_vector(I_AVENGER_AWAKENING_TIME);
	local doomshp = appendage.sq_var.get_vector(I_DOOMS_HP); // 변신한 어벤져의 hp값
	
	if(T >= maxT || doomshp <= 0) { // 시간이 다 됐거나 둠스가디언 hp가 다 닳았다면.. 끝이다..
	//if(T >= maxT) {
		return true;
	}
	
	return false;
}