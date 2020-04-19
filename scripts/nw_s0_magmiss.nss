//::///////////////////////////////////////////////
//:: Magic Missile
//:: NW_S0_MagMiss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A missile of magical energy darts forth from your
// fingertip and unerringly strikes its target. The
// missile deals 1d4+1 points of damage.
//
// For every two extra levels of experience past 1st, you
// gain an additional missile.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 10, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: May 8, 2001

#include "NW_I0_SPELLS"
#include "inc_customspells"
#include "inc_istate"

void _DoMagicMissile(object oTarget, int nCasterLvl, int nMetaMagic) {

    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    int nDamage = 0;
    int nCnt;
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    int nMissiles = (nCasterLvl + 1)/2;
    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);
    float fDelay2, fTime;
    int bStaticLevel   = GetLocalInt(GetModule(), "STATIC_LEVEL");

    if(!GetIsReactionTypeFriendly(oTarget))
    {

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_MISSILE));
        //Limit missiles to five
        if (nMissiles > 5)
        {
            nMissiles = 5;
        }
	    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF)) nMissiles += 1;
        //Make SR Check
        if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
        {
            //Apply a single damage hit for each missile instead of as a single mass
            for (nCnt = 1; nCnt <= nMissiles; nCnt++)
            {
                //Roll damage
                int nDam = d4(bStaticLevel ? 2 : 1) + 1;
                //Enter Metamagic conditions
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                      nDam = bStaticLevel ? 9 : 5;//Damage is at max
                }
                if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                      nDam = nDam + nDam/2; //Damage/Healing is +50%
                }
                fTime = fDelay;
                fDelay2 += 0.1;
                fTime += fDelay2;

                //Set damage effect
                nDam = miSPGetSRAdjustedDamage(nDam, oTarget);
                effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);

                //Apply the MIRV and damage effect
                DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fTime, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
                DelayCommand(fDelay2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
             }
         }
         else
         {
            // dunshine: check if the target wields a shield with the "Reflect Magic Missile" property
            object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
            if (oShield != OBJECT_INVALID) {
              if (GetLocalInt(oShield, "GVD_REFLECT_MISSILES") != 0) {
                // add charges
                int iCharges = gsISGetItemState(oShield);
                int iChargesMax = GetLocalInt(oShield, "sep_is_maxcharge");
                if (iChargesMax == 0) {
                  // default max of 30
                  iChargesMax = 30;
                  SetLocalInt(oShield, "sep_is_maxcharge", 30);
                }
                iCharges = iCharges + nMissiles;
                if (iCharges > iChargesMax) {
                  iCharges = iChargesMax;
                }
                gsISSetItemState(oShield, iCharges);

                // 25% chance of not only absorbing, but also reflecting
                if (d4(1) == 1) {
                  // so re-cast at the caster with same level and metamagic
                  FloatingTextStringOnCreature("Reflected!", oTarget);
                  SendMessageToPC(oTarget, "Your shield reflects the magic missiles!");
                  SendMessageToPC(OBJECT_SELF, "Your magic missiles are reflected back at you!");
                  object oCaster = OBJECT_SELF;
                  DelayCommand(0.3f, AssignCommand(oTarget, _DoMagicMissile(oCaster, nCasterLvl, nMetaMagic)));
                } else {
                  SendMessageToPC(oTarget, "Your shield absorbs the magic missiles!");
               }
              }
            }

            for (nCnt = 1; nCnt <= nMissiles; nCnt++)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
            }
         }
     }


}

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check inc_customspells.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oTarget = GetSpellTargetObject();
    int nCasterLvl = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = AR_GetMetaMagicFeat();

    // wrap in a function, so we can re-call it from itself
    AssignCommand(OBJECT_SELF, _DoMagicMissile(oTarget, nCasterLvl, nMetaMagic));

}
