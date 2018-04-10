// Conversation conditional to check if PC is a meat shield.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/12/2004 Artos            Initial release.
//

int StartingConditional()
{

	// Restrict based on the player's class
	int iPassed = 0;
	if(GetLevelByClass(CLASS_TYPE_ASSASSIN, GetPCSpeaker()) >= 4)
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_BARBARIAN, GetPCSpeaker()) >= 4))
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_BLACKGUARD, GetPCSpeaker()) >= 4))
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_FIGHTER, GetPCSpeaker()) >= 4))
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker()) >= 4))
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, GetPCSpeaker()) >= 4))
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_ROGUE, GetPCSpeaker()) >= 4))
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	return TRUE;
}
