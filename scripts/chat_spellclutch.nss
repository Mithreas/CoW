#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "fb_inc_chatutils"
#include "inc_examine"
#include "gs_inc_subrace"

const string HELP = "Spell clutch allows Depp Imaskari to refresh 2nd circle and below spells 1/day";
void _RestoreSpells(object oPC, int nLevel)
{
    int x;
    int nSavedSpell;
    struct NWNX_Creature_MemorisedSpell sSpell;
    for(x=0; x <= NWNX_Creature_GetMaxSpellSlots(oPC, CLASS_TYPE_WIZARD, nLevel); x++)
    {
        nSavedSpell = GetLocalInt(oPC, "md_sc_savespell"+IntToString(nLevel)+IntToString(x));
        sSpell = NWNX_Creature_GetMemorisedSpell(oPC, CLASS_TYPE_WIZARD, nLevel, x);
        if(sSpell.id == nSavedSpell-1 && !sSpell.ready) //spell match! Restore but only if it's not already readied
        {
            sSpell.ready = 1;
            NWNX_Creature_SetMemorisedSpell(oPC, CLASS_TYPE_WIZARD, nLevel, x, sSpell);
        }
    }

}
void main()
{
    object oSpeaker = OBJECT_SELF;
    chatVerifyCommand(oSpeaker);
    if (chatGetParams(oSpeaker) == "?")
    {
      DisplayTextInExamineWindow("-spellclutch", HELP);
    }
    if(gsSUGetSubRaceByName(GetSubRace(oSpeaker)) != GS_SU_DEEP_IMASKARI) return;
    if(GetLocalInt(oSpeaker, "md_spellclutch"))
    {
        SendMessageToPC(oSpeaker, "You used up your spell clutch for the day.");
        return;
    }
    SetLocalInt(oSpeaker, "md_spellclutch", 1);
    int nBard = GetLevelByClass(CLASS_TYPE_BARD, oSpeaker);
    if(nBard > 1)
    {
        NWNX_Creature_SetRemainingSpellSlots(oSpeaker,
                                 CLASS_TYPE_BARD,
                                 0,
                                 NWNX_Creature_GetMaxSpellSlots(oSpeaker, CLASS_TYPE_BARD, 0));

        NWNX_Creature_SetRemainingSpellSlots(oSpeaker,
                                 CLASS_TYPE_BARD,
                                 1,
                                 NWNX_Creature_GetMaxSpellSlots(oSpeaker, CLASS_TYPE_BARD, 1));
        if(nBard > 3)
            NWNX_Creature_SetRemainingSpellSlots(oSpeaker,
                                 CLASS_TYPE_BARD,
                                 2,
                                 NWNX_Creature_GetMaxSpellSlots(oSpeaker, CLASS_TYPE_BARD, 2));
    }

    int nSorcerer = GetLevelByClass(CLASS_TYPE_SORCERER, oSpeaker);

    if(nSorcerer)
    {
        NWNX_Creature_SetRemainingSpellSlots(oSpeaker,
                                 CLASS_TYPE_SORCERER,
                                 0,
                                 NWNX_Creature_GetMaxSpellSlots(oSpeaker, CLASS_TYPE_SORCERER, 0));
        NWNX_Creature_SetRemainingSpellSlots(oSpeaker,
                                 CLASS_TYPE_SORCERER,
                                 1,
                                 NWNX_Creature_GetMaxSpellSlots(oSpeaker, CLASS_TYPE_SORCERER, 1));

        if(nSorcerer > 3)
            NWNX_Creature_SetRemainingSpellSlots(oSpeaker,
                                 CLASS_TYPE_SORCERER,
                                 2,
                                 NWNX_Creature_GetMaxSpellSlots(oSpeaker, CLASS_TYPE_SORCERER, 2));

    }

    int nWizard = GetLevelByClass(CLASS_TYPE_WIZARD, oSpeaker);

    if(nWizard)
    {
        _RestoreSpells(oSpeaker, 0);
        _RestoreSpells(oSpeaker, 1);
        if(nWizard > 2)
            _RestoreSpells(oSpeaker, 2);
    }
}
