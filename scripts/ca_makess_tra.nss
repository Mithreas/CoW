//:://////////////////////////////////////////////
//:: Spellsword Setup via Westin Conv.
//:: Created By: Kirito
//:: Created On: July 14, 2017
//:://////////////////////////////////////////////
#include "mi_inc_spllswrd"

void main()
{
    object oSpeaker = GetPCSpeaker();
    miSSSetIsSpellsword(oSpeaker);
    miSSSetPathItem(oSpeaker);
    miSSSetBlockedSchool(oSpeaker, SPELL_SCHOOL_TRANSMUTATION, 1);
    miSSSetBlockedSchool(oSpeaker, SPELL_SCHOOL_CONJURATION, 2);
    miSSApplyBonuses(oSpeaker, TRUE, FALSE);
	miSSMWPFeat(oSpeaker);
}
