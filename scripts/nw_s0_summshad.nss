//::///////////////////////////////////////////////
//:: Summon Shadow
//:: NW_S0_SummShad.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spell powerful ally from the shadow plane to
    battle for the wizard
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 26, 2001
//:://////////////////////////////////////////////

#include "inc_spells"
#include "mi_inc_spells"
#include "mi_inc_warlock"

// Applies buffs to the summoned shadow based on the summoner's illusionary aptitude.
// For each spell focus in illusion, the summon gains one undead level and +1 AC.
void DoIllusionBuffs(object oSummoner = OBJECT_SELF);

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check mi_inc_spells.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    if (miWAGetIsWarlock(OBJECT_SELF))
    {
        if (GetIsTimelocked(OBJECT_SELF, "Warlock Summon Shadows"))
        {
            TimelockErrorMessage(OBJECT_SELF, "Warlock Summon Shadows");
            return;
        }

        SetTimelock(OBJECT_SELF, 180, "Warlock Summon Shadows", 30, 6);
    }

    //Declare major variables
    int nMetaMagic = AR_GetMetaMagicFeat();
    int nCasterLevel = AR_GetCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLevel;
    int nNumSummons;
    string sBlueprint = GetGender(OBJECT_SELF) == GENDER_FEMALE ? "sum_shadowf" : "sum_shadowm";
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }

    switch(GetSpellId())
    {
        case SPELL_SHADOW_CONJURATION_SUMMON_SHADOW:
            nNumSummons = 1;
            break;
        case SPELL_GREATER_SHADOW_CONJURATION_SUMMON_SHADOW:
            nNumSummons = 2;
            break;
        case SPELL_SHADES_SUMMON_SHADOW:
            nNumSummons = 3;
            break;
    }

    SummonSwarm(OBJECT_SELF, CreateSummonGroup(nNumSummons, sBlueprint), RoundsToSeconds(nDuration), VFX_FNF_SUMMON_UNDEAD);
}


