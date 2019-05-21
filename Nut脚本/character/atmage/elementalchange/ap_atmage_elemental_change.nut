
function sq_AddFunctionName(appendage)
{	
	appendage.sq_AddFunctionName("proc", "proc_appendage_atmage_elemental_change")
	appendage.sq_AddFunctionName("prepareDraw", "prepareDraw_appendage_elemental_change")
	appendage.sq_AddFunctionName("onStart", "onStart_appendage_atmage_elemental_change")
	appendage.sq_AddFunctionName("onEnd", "onEnd_appendage_atmage_elemental_change")
	appendage.sq_AddFunctionName("isEnd", "isEnd_appendage_atmage_elemental_change")
	appendage.sq_AddFunctionName("onVaildTimeEnd", "onVaildTimeEnd_appendage_atmage_elemental_change")
}

function sq_AddEffect(appendage)
{
}


function onVaildTimeEnd_appendage_atmage_elemental_change(appendage)
{
	if(!appendage)
		return;		
	
	local parentObj = appendage.getParent();
	local sourceObj = appendage.getSource();
				
	if(!sourceObj || !parentObj) {
		appendage.setValid(false);
		return;
	}	
	
	local mage = sq_ObjectToSQRCharacter(parentObj);
	if(mage)
		mage.setThrowElement(ENUM_ELEMENT_NONE);		
		
	
	// 보호막형성 처리
	local appendage = CNSquirrelAppendage.sq_GetAppendage(mage,"Character/ATMage/MagicShield/ap_MagicShield.nut");
	if(appendage)
		setMagicShieldType(appendage, mage, mage.getThrowElement());
		
	
}
