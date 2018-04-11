#include "ar_sys_poison"

/*
    This callback script is used for the NWN Standard poisons. Bar the 16 NWN
    vanilla Poison ones.

    This script will make use of the poison.2da file to properly replicate the
    poison from NWN vanilla but to be used in the custom poison system instead.
*/

void secondaryEffect(object oSpellOrigin, object oSpellTarget, int nPoisonId);

void main()
{
    //::  The item casting triggering this spellscript
    object oItem = GetSpellCastItem();
    //::  On a weapon: The one being hit. On an armor: The one hitting the armor
    object oSpellTarget = GetSpellTargetObject();
    //::  On a weapon: The one wielding the weapon. On an armor: The one wearing an armor
    object oSpellOrigin = OBJECT_SELF;
    //::  For this script we use the DC as an identifier for which poison to use in
    //::  this list here:       http://nwn.wikia.com/wiki/Poison
    //::  Constant value here:  http://www.nwnlexicon.com/index.php?title=Poison
    int nPoisonId = arPOGetPoisonDC(oItem);

    if( !arPOGetIsPoisoned(oSpellTarget) && !GetIsImmune(oSpellTarget, IMMUNITY_TYPE_POISON) ) {
        //::  Only Do Secondary if Initial is successful
        if ( arPOApplyPoisonEffectFrom2DA(oSpellOrigin, oSpellTarget, nPoisonId, 1) )
            DelayCommand(60.0, secondaryEffect(oSpellOrigin, oSpellTarget, nPoisonId));
    }
}

void secondaryEffect(object oSpellOrigin, object oSpellTarget, int nPoisonId) {
    arPOApplyPoisonEffectFrom2DA(oSpellOrigin, oSpellTarget, nPoisonId, 2);
}
