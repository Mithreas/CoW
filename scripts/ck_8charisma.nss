//::///////////////////////////////////////////////
//:: FileName ck_8charisma
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 5/4/2004 8:53:09 PM
//:://////////////////////////////////////////////
int StartingConditional()
{
	if(!(GetAbilityScore(GetPCSpeaker(), ABILITY_CHARISMA) < 9))
		return FALSE;

	return TRUE;
}