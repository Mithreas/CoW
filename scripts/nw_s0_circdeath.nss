#include "inc_spells"
#include "mi_inc_spells"

void main()
{
    if (gsSPGetOverrideSpell()) return;

    object oTarget1    = OBJECT_INVALID;
    object oTarget2    = OBJECT_INVALID;
    location lLocation = GetSpellTargetLocation();
    effect eEffect     = EffectLinkEffects(EffectVisualEffect(VFX_IMP_DEATH), EffectDeath());
    float fDelay       = 0.0;
    float fDistance1   = 0.0;
    float fDistance2   = 0.0;
    int nSpell         = GetSpellId();
    int nCasterLevel   = AR_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic     = AR_GetMetaMagicFeat();
    int nDC            = AR_GetSpellSaveDC();
    int nValue         = gsSPGetDamage(nCasterLevel, 4, nMetaMagic);
    string sString     = "GS_SP_" + IntToString(nSpell) + "_";
    int nHD1           = 0;
    int nHD2           = 0;
    int nCount         = 0;
    int nNth1          = 0;
    int nNth2          = 0;

    //build target list
    oTarget1           = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation);

    while (GetIsObjectValid(oTarget1))
    {
        //raise event
        SignalEvent(oTarget1, EventSpellCastAt(OBJECT_SELF, nSpell));
				
        //affection check
        if (GetHitDice(oTarget1) < 9)
        {
            if (gsSPGetIsAffected(GS_SP_TYPE_HARMFUL_SELECTIVE, OBJECT_SELF, oTarget1))
            {
                //store target
                SetLocalObject(OBJECT_SELF, sString + IntToString(nCount++), oTarget1);
            }
        }
        else
        {
            gsC2AdjustSpellEffectiveness(nSpell, oTarget1, FALSE);
        }

        oTarget1 = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation);
    }

    //visual effect
    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_FNF_LOS_EVIL_20),
        lLocation);

    //process target list
    while (nCount > 0)
    {
        oTarget1    = OBJECT_INVALID;
        fDistance1  = 100.0;
        nHD1        =  10;
        nNth1       =   0;

        for (nNth2 = 0; nNth2 < nCount; nNth2++)
        {
            oTarget2 = GetLocalObject(OBJECT_SELF, sString + IntToString(nNth2));
            nHD2     = GetHitDice(oTarget2);

            if (nHD2 <= nHD1)
            {
                fDistance2 = GetDistanceBetweenLocations(lLocation, GetLocation(oTarget2));

                if (nHD2 < nHD1 || (nHD2 == nHD1 && fDistance2 < fDistance1))
                {
                    oTarget1   = oTarget2;
                    fDistance1 = fDistance2;
                    nHD1       = nHD2;
                    nNth1      = nNth2;
                }
            }
        }

        //hit dice check
        if (nHD1 > nValue) break;

        fDelay     += 0.1;
        nValue     -= nHD1;

        //resistance check
        if (! gsSPResistSpell(OBJECT_SELF, oTarget1, nSpell, fDelay))
        {
            //saving throw check
            if (! gsSPSavingThrow(OBJECT_SELF,       oTarget1,
                                  nSpell,            nDC,
                                  SAVING_THROW_FORT, SAVING_THROW_TYPE_DEATH,
                                  fDelay))
            {
                //apply
                DelayCommand(fDelay, gsSPApplyEffect(oTarget1, eEffect, nSpell));
            }
        }

        DeleteLocalObject(OBJECT_SELF, sString + IntToString(--nCount));
        if (nNth1 != nCount) SetLocalObject(OBJECT_SELF, sString + IntToString(nNth1), oTarget2);
    }

    //clean target list
    for (nNth1 = 0; nNth1 < nCount; nNth1++)
    {
        DeleteLocalObject(OBJECT_SELF, sString + IntToString(nNth1));
    }
}
