
function setCustomData_po_ATFlameCircle(obj, reciveData)
{

	if(!obj) return;
	
	local spin_count = reciveData.readWord();
	local radius = reciveData.readFloat();
	local speed = reciveData.readFloat();
	local attack_rate = reciveData.readDword();

	local pAni = obj.getCurrentAnimation();
	pAni.setImageRate(radius, 1.0);
	pAni.setSpeedRate(speed);
	
	obj.sq_var.clear_vector();
	obj.sq_var.push_vector(spin_count); // 0
	obj.sq_var.push_vector(0); // 1
	obj.sq_var.push_vector(0); // 2
	obj.sq_var.push_vector(0); // 3
	
	obj.sq_var.clear_obj_vector();
	
	
	//local pRopeNormal = obj.sq_createCNRDAnimation("Effect/Animation/Spincutter/throw/4_rope_normal_0.ani");
	local ani = sq_CreateAnimation("","PassiveObject/Character/Mage/Animation/ATFlameCircle/04_bspin_dodge.ani");
	
	ani.setImageRate(radius, 1.0);
	ani.setSpeedRate(speed);
	
	local bspin_dodge = sq_CreatePooledObject(ani,false);
	bspin_dodge.setCurrentPos(obj.getXPos(),obj.getYPos()-2,obj.getZPos()-2);
	bspin_dodge.setCurrentDirection(obj.getDirection());
	sq_AddObject(obj,bspin_dodge,2,false);	
	
	obj.sq_var.push_obj_vector(bspin_dodge);
	
	sq_SetAttackBoundingBoxSizeRate(pAni, radius, radius, radius);
	
	local pAttack = sq_GetCurrentAttackInfo(obj);
	sq_SetCurrentAttackBonusRate(pAttack, attack_rate);
}

function destroy_po_ATFlameCircle(obj)
{
	local bspin_dodge_obj = obj.sq_var.get_obj_vector(0);
	print( " destroy_po_ATFlameCircle:" + bspin_dodge_obj);
	
	if(bspin_dodge_obj) {
		bspin_dodge_obj.setValid(false);
		obj.sq_var.clear_obj_vector();
	}
	
}

function setState_po_ATFlameCircle(obj, state, datas)
{
	if(!obj) return;

}

function onAttack_po_ATFlameCircle(obj, damager, boundingBox, isStuck)
{
	if(!obj)
		return 0;

	local spin_cnt = obj.sq_var.get_vector(1);
	local total_spin_cnt = obj.sq_var.get_vector(0);
	
	if(spin_cnt >= total_spin_cnt)
	{
		sq_AddHitObject(obj, damager);
	}
	
	return 0;
}

function procAppend_po_ATFlameCircle(obj)
{
	if(!obj) return;
	
	local pChr = obj.getTopCharacter();
	
	if(!pChr)
	{
		if(obj.isMyControlObject()) {
			sq_SendDestroyPacketPassiveObject(obj);
			return;
		}		
	}
	
	if(pChr.getState() != STATE_FLAMECIRCLE)
	{
		if(obj.isMyControlObject()) {
			sq_SendDestroyPacketPassiveObject(obj);
			return;
		}
	}	
	
	local pAni = obj.getCurrentAnimation();
	local frmIndex = sq_GetAnimationFrameIndex(pAni);
	
	local bspin_dodge_obj = obj.sq_var.get_obj_vector(0);
	
	if(bspin_dodge_obj) {
		local bspin_dodge_ani = bspin_dodge_obj.getCurrentAnimation();
		local bspin_frm_index = sq_GetAnimationFrameIndex(bspin_dodge_ani);
		sq_SetAnimationCurrentTimeByFrame(pAni, bspin_frm_index, false);
	}
	
	if(frmIndex >= 0 &&  frmIndex < 3) {
		if(obj.sq_var.get_vector(2) == 1) {
			local cnt = obj.sq_var.get_vector(1);
			
			cnt = cnt + 1;
			obj.sq_var.set_vector(1, cnt); // 한바퀴 돌아간 카운트를 한번 늘린다..
			
			obj.sq_var.set_vector(2, 0);
			obj.resetHitObjectList();
		}
	}
	
	if(frmIndex >= 3 && frmIndex <= 4) {
		if(obj.sq_var.get_vector(2) == 0) {
			local cnt = obj.sq_var.get_vector(1);
			obj.sq_var.set_vector(2, 1);
		}
	}
	
	local spin_cnt = obj.sq_var.get_vector(1);
	local total_spin_cnt = obj.sq_var.get_vector(0);

	if(spin_cnt >= (total_spin_cnt - 1)) {
		if(obj.sq_var.get_vector(3) == 0) {
			obj.sq_var.set_vector(3, 1);
		}
	} 	
	
	//print( " total_spin_cnt:" +  total_spin_cnt + " spin_cnt:" + spin_cnt);
	
	if(spin_cnt >= total_spin_cnt) {
	
		//obj.resetHitObjectList();
		
		if(bspin_dodge_obj) {
			bspin_dodge_obj.setValid(false);
			obj.sq_var.clear_obj_vector();
		}
		
		if(obj.isMyControlObject()) {
			sq_SendDestroyPacketPassiveObject(obj);
		}		
	}

}

function onDestroyObject_po_ATFlameCircle(obj, object)
{

	if(!obj) return;
	
	if(object == obj)
	{
		local bspin_dodge_obj = obj.sq_var.get_obj_vector(0);
		
		if(bspin_dodge_obj)
		{
			bspin_dodge_obj.setValid(false);
			obj.sq_var.clear_obj_vector();
		}
	}
}

function onKeyFrameFlag_po_ATFlameCircle(obj, flagIndex)
{

}

function onEndCurrentAni_po_ATFlameCircle(obj)
{

	if(!obj) return;
	

	//if(obj.isMyControlObject()) {
		//sq_SendDestroyPacketPassiveObject(obj);
	//}

}
