// Conversation conditional to check if PC can be a spellsword.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 17/07/2017 Kirito            Initial release.
//
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "inc_spellsword"
#include "gs_inc_pc"

int StartingConditional()
{
    object oPC = GetPCSpeaker( );

    if ( GetIsDM(oPC) ){return TRUE;}

    // Restrict based on the player's class
    int iPassed = 0;
    if((GetLevelByClass(CLASS_TYPE_WIZARD, oPC) >= 5)
        && (!NWNX_Creature_GetWizardSpecialization(oPC))
        && (!miSSGetIsSpellsword(oPC))
		&& (!(GetLocalInt(gsPCGetCreatureHide(oPC), "WILD_MAGE")==1))
		&& (!(GetLocalInt(gsPCGetCreatureHide(oPC), "SHADOW_MAGE"))==1))
    {
        iPassed = 1;
    }

    if (iPassed == 0){return FALSE;}

    return TRUE;
}
