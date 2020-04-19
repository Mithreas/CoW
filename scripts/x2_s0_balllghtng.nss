//::///////////////////////////////////////////////
//:: Isaacs Lesser Missile Storm
//:: x0_s0_MissStorm1
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Up to 10 missiles, each doing 1d6 damage to all
 targets in area.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2002
//:://////////////////////////////////////////////
//:: Last Updated By:

#include "X0_I0_SPELLS"
#include "inc_customspells"

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

   // End of Spell Cast Hook

   //SpawnScriptDebugger();                         503
    //DoMissileStorm(1, 15, GetSpellId(), 503, VFX_IMP_LIGHTNING_S, DAMAGE_TYPE_ELECTRICAL, FALSE, TRUE );


    int nDamage =  AR_GetCasterLevel(OBJECT_SELF);
    if (nDamage > 15)
        nDamage = 15;
	if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF)) nDamage += 2;

    DoMissileStorm(nDamage, 15, GetSpellId(), VFX_IMP_MIRV_ELECTRIC, VFX_IMP_LIGHTNING_S, DAMAGE_TYPE_ELECTRICAL, TRUE, TRUE);
}
