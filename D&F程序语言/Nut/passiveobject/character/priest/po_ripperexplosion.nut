
function setCustomData_po_RipperExplosion(obj,reciveData)
{
}


function onKeyFrameFlag_po_RipperExplosion(obj,flagIndex)
{	
	if(flagIndex == 1) {
		if(obj.sq_isMyControlObject()) // 진동,번쩍 이펙트는 나에게만 보인다.
			obj.sq_setShake(obj,5,250);	
	}
	else if(flagIndex == 2) {
		//local t = obj.sq_var.get_timer_vector(0);
		//t.setParameter(20, -1);		
		//t.resetInstant(0);
		//obj.sq_var.push_vector(0); // 파티클 5번만 생성
	}
	return true;
}

function onEndCurrentAni_po_RipperExplosion(obj)
{
	sq_SendDestroyPacketPassiveObject(obj);
}

function procAppend_po_RipperExplosion(obj)
{
	//local t = obj.sq_var.get_timer_vector(0);
	//
	//local pAni = sq_GetCurrentAnimation(obj);
	//local currentT = sq_GetCurrentTime(pAni);
	//
	//local count = obj.sq_var.get_vector(0);	
		
	//if (t.isOnEvent(currentT) == true && count < 8) {
	////if(0) {
		//local x = obj.getXPos()+(count*5);
		//local x1 = obj.getXPos()-(count*5);
		////print( + " : " + obj.getZPos() + " : " + z1);
		//local particleCreater = obj.sq_var.GetparticleCreaterMap("ripperSmoke","Monster/Common/Particle/ExplosionDarkPos1.ptl", obj);			
		//particleCreater.Restart(0);		
		//particleCreater.SetPos(x , obj.getYPos() -30, obj.getZPos()-30);
		//sq_AddParticleObject(obj, particleCreater);
		//
		//particleCreater = obj.sq_var.GetparticleCreaterMap("ripperSmoke","Monster/Common/Particle/ExplosionDarkPos2.ptl", obj);
		//particleCreater.Restart(0);		
		//particleCreater.SetPos(x1, obj.getYPos()-30, obj.getZPos()-30);		
		//sq_AddParticleObject(obj, particleCreater);
		//
		//obj.sq_var.set_vector(0,count+1);
	//}
}