//::///////////////////////////////////////////////
//:: Dragon Knight
//:: X2_S2_DragKnght
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Summons an adult red dragon for you to
     command.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 07, 2003
//:://////////////////////////////////////////////

#include "inc_spells"
#include "inc_sumstream"
#include "x2_inc_toollib"
#include "x2_inc_spellhook"

void main()
{

    /*
      Spellcast Hook Code
      Added 2003-06-20 by Georg
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    effect eVis = EffectVisualEffect(460);
    string sResRef;
    object oCaster = OBJECT_SELF;
    int nCasterLevel = GetGreatestSpellCasterLevel(oCaster);

    SummonFromStream(oCaster, GetSpellTargetLocation(), RoundsToSeconds(nCasterLevel*2), STREAM_TYPE_DRAGON, STREAM_DRAGON_TIER_DRAGON_KNIGHT,
        481, 0.0, TRUE, TRUE);

    DelayCommand(1.0f,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis,GetSpellTargetLocation()));
}


