AP_LIGHTNING_WALL_VAR_ELECT_OBJ <- 0;
AP_LIGHTNING_WALL_VAR_START_Z <- 1;

function sq_AddFunctionName(appendage)
{
	appendage.sq_AddFunctionName("proc", "proc_appendage_LightningWall")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_LightningWall")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_LightningWall")
}

function sq_AddEffect(appendage)
{
}



function proc_appendage_LightningWall(appendage)
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
	
	local var = appendage.getVar();
	local startZ = var.getInt(AP_LIGHTNING_WALL_VAR_START_Z);
	local z = sq_GetShuttleValue(0, 8, sq_GetObjectTime(parentObj), 40);
	parentObj.setCurrentPos(parentObj.getXPos(), parentObj.getYPos(), startZ + z);				
	
	local elect = var.getObject(AP_LIGHTNING_WALL_VAR_ELECT_OBJ);
	if(elect)
		elect.setCurrentPos(parentObj.getXPos(), parentObj.getYPos()+1, parentObj.getZPos() + parentObj.getObjectHeight()/2);
	
	local ani = parentObj.getCurrentAnimation();
	local rgb = z < 4 ? 255 : 0;
	if(ani)
		ani.setEffectLayer(true, GRAPHICEFFECT_MONOCHROME, true, sq_RGB(rgb,rgb,rgb), sq_ALPHA(255), true, true);
}



function onStart_appendage_LightningWall(appendage)
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
	
	local var = appendage.getVar();		
	local elect = sq_AddDrawOnlyAniFromParent(parentObj,"PassiveObject/Character/Mage/Animation/ATLightningWall/12_el-shock_dodge.ani", 0, 0, 0);	
	elect.setCurrentPos(parentObj.getXPos(), parentObj.getYPos()+1, parentObj.getZPos() + parentObj.getObjectHeight()/2);
	
	
	local sizeRate = sq_GetUniformVelocity(5,15,parentObj.getObjectHeight() - 100, 150);
	sizeRate = sizeRate.tofloat()/10.0;
	local ani = elect.getCurrentAnimation();
	if(ani)
		ani.resize(sizeRate);
		
	var.setObject(AP_LIGHTNING_WALL_VAR_ELECT_OBJ, elect);
	var.setInt(AP_LIGHTNING_WALL_VAR_START_Z, parentObj.getZPos());
	parentObj.sq_PlaySound("LIGHTWALL_ELEC");
}



function onEnd_appendage_LightningWall(appendage)
{
	if(!appendage) {
		return;
	}
		printc("onEnd_appendage_LightningWall");
	
	local var = appendage.getVar();
	local elect = var.getObject(AP_LIGHTNING_WALL_VAR_ELECT_OBJ);
	if(elect) {
		elect.setValid(false);
		printc("onEnd_appendage_LightningWall");
	}
}
