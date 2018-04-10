//::///////////////////////////////////////////////
//:: FileName ck_islvl10
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 9/27/2005 2:13:18 PM
//:://////////////////////////////////////////////
int StartingConditional()
{

	// Restrict based on the player's class
	int iPassed = 0;
	if(GetHitDice(GetPCSpeaker()) >= 10)
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	return TRUE;
}
