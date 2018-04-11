//::///////////////////////////////////////////////
//:: Arelith Poison System
//:: ar_sys_poison
//:://////////////////////////////////////////////
//:: Created By: ActionReplay
//:: Created On: 2017-28-02
//:: Updated On: 2017-30-03
//:://////////////////////////////////////////////
/*
    Allows to add temporary poison properties
    to melee piercing/slashing weapons or ammunitions
    such as Arrows, Bolts, Darts, Shuriken, Throwing Axe.

    PCs without the USE POISON feat have a chance of poisoning
    themselves when trying to apply poison to an item.

    Poison Roll: 10 + d10 + DEX modifier  vs.  Poison's Apply DC


    To create a Poison Item you have to setup it by tag
    much like the Essence items in the game.

    TAG:
        AR_PO_{applyDC}_{dc}_{duration}_{hitType}_{hitSubType}

        !! All Values are always typed in as 3 digits, e.g 001 is 1, 012 is 12, 000 is 0 !!

        See:  ItemPropertyOnHitProps    for more information:
              http://www.nwnlexicon.com/index.php?title=ItemPropertyOnHitProps

        ApplyDC     - Is the DC the user must make to apply the poison successfully.
        DC          - Is a constant value of "IP_CONST_ONHIT_SAVEDC_*" constants
                      TABLE:
                        IP_CONST_ONHIT_SAVEDC_14    =   0
                        IP_CONST_ONHIT_SAVEDC_16    =   1
                        IP_CONST_ONHIT_SAVEDC_18    =   2
                        IP_CONST_ONHIT_SAVEDC_20    =   3
                        IP_CONST_ONHIT_SAVEDC_22    =   4
                        IP_CONST_ONHIT_SAVEDC_24    =   5
                        IP_CONST_ONHIT_SAVEDC_26    =   6
        Duration    - The duration in Turns for the Item Property to last.
                      E.g 005 == 5 Turns
        HitType     - A constant value of "IP_CONST_ONHIT_*" constants.
                      Meaning what kind of On Hit property is this, e.g blind, ability draing etc.
                      TABLE:
                        IP_CONST_ONHIT_SLEEP        =   0
                        IP_CONST_ONHIT_STUN         =   1
                        IP_CONST_ONHIT_HOLD         =   2
                        IP_CONST_ONHIT_CONFUSION    =   3
                        IP_CONST_ONHIT_SLOW         =   9
                        IP_CONST_ONHIT_SILENCE      =   14
                        IP_CONST_ONHIT_BLINDNESS    =   16
                        IP_CONST_ONHIT_ABILITYDRAIN =   18
                        IP_CONST_ONHIT_ITEMPOISON   =   19
                        IP_CONST_ONHIT_DISEASE      =   20
                        More here:  http://www.nwnlexicon.com/index.php?title=Ip_const_onhit
        HitSubtype  - A constant value depending on what sort of HitType used
                      above and is unique to that HitType:
                      e.g
                        IP_CONST_ONHIT_ABILITYDRAIN     uses    IP_CONST_ABILITY_*
                        IP_CONST_ONHIT_SLEEP
                        IP_CONST_ONHIT_STUN
                        IP_CONST_ONHIT_HOLD
                        IP_CONST_ONHIT_CONFUSION
                        IP_CONST_ONHIT_SLOW
                        IP_CONST_ONHIT_SILENCE  etc     uses    IP_CONST_ONHIT_DURATION_

                    TABLE IP_CONST_ONHIT_DURATION_*:
                        IP_CONST_ONHIT_DURATION_5_PERCENT_5_ROUNDS      =   0
                        IP_CONST_ONHIT_DURATION_10_PERCENT_4_ROUNDS     =   1
                        IP_CONST_ONHIT_DURATION_25_PERCENT_3_ROUNDS     =   2
                        IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS     =   3
                        IP_CONST_ONHIT_DURATION_75_PERCENT_1_ROUND      =   4


    Example:

        Following will create a Poison with
        Applied DC of 14
        Save DC of 18 (2 == IP_CONST_ONHIT_SAVEDC_18)
        A duration of 3 Turns
        OnHit property: Blindness (16 == IP_CONST_ONHIT_BLINDNESS)
        Special SubType Prop of 2 Rounds, 50% chance (3 == IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS)

        AR_PO_014_002_003_016_003



    ----------------------------------------------------------------------------
    Custom Script Fire (Unique Abillity)
    Same as above but TAG is formatted as:
        AR_PO_{applyDC}_{dc}_{duration}_{scriptName}

        DC          - Is the DC to be used in the custom Posion Script against
                      a target.

        ScriptName  - Has to start with "po", so name your script as
                      "po_MyPoison" or "poMyPoison"

    This will apply a On Hit: Cast Spell Unique Abillity on the weapon.

    Example: AR_PO_014_020_010_poTest
    Creates a poison with a apply DC of 14, custom DC of 20 (To be used in the custom script)
    lasting for 10 Turns and will run the custom script "poTest" when successfully
    hitting a target.

    NOTE:  On Hit: Cast Spell Unique Abillity is run through the script 'x2_s3_onhitcast'

    Special Case:  If the Script is "PO_POISONS" then nSaveDC is used
    as a identifier for which of the default NWN poisons to use.
    From this list here:      http://www.nwnlexicon.com/index.php?title=Poison
    For instance if nSaveDC is 33 then we use Aranea venom
    Say "AR_PO_013_033_010_po_poisons" would be Aranea venom
*/

#include "x2_inc_itemprop"
#include "X2_inc_switches"
#include "nw_i0_spells"
#include "gs_inc_common"
#include "inc_log"

const string MSG_PO_INVALID         = "Invalid Target.  Must be coated on a Piercing/Slashing Weapon, or ammunition (Arrows, Bolts, Darts, Shuriken, Throwing Axe).";
const string MSG_PO_INVALID_COATED  = "Weapon is already coated with poison.";
const string MSG_PO_INVALID_ERROR   = "The poison evaporated. Huh...";
const string MSG_PO_SUCCESS         = "Poison applied successfully.";
const string MSG_PO_FAIL            = "You poisoned yourself!";
const string MSG_PO_NEGATIVE        = "<cþ  >";

const string AR_PO_DC   = "AR_PO_DC";               //::  Variable name for stored OnHit (Cast Spell) DC, used in custom Poison Scripts
const string LOG_POISON = "LOG_POISON";             //::  For tracing

const string POISON_2DA = "poison";


//void main() {}


//::  Checks to see if oPC can use oItem as poison on oTarget with sTag
void arApplyPoison(object oPC, object oItem, object oTarget, string sTag);

//::  Returns true if oWeapon is already coated with poison
int arPOGetIsWeaponPoisoned(object oWeapon);

//::  To be used in Custom Posion Scripts, returns the Poison DC to be used
//::  against a successfully hit target with the custom poison, or whatever the
//::  creator can think of doing with the DC, e.g a biteback poison against the
//::  wielder maybe?
//::  This variable is stored on the weapon!
int arPOGetPoisonDC(object oWeapon);

//::  Returns a bonus DC to apply on the Poison base DC based on oOrigin's
//::  Assassin Levels and Blackguard Levels.
int arPOGetClassDC(object oOrigin);

//::  Applies an effet from a poison read from poison.2da
//::  Used for NWN standard poisons in the custom poison system.
//::  oOrigin   - Object using the poison
//::  oTarget   - Target the poison is applied to
//::  nPoisonId - The constant poison ID value to fetch.
//::  nStage    - The stage of the poison to fetch, 1 (Initial effect) or 2 (Secondary effect)
int arPOApplyPoisonEffectFrom2DA(object oOrigin, object oTarget, int nPoisonId, int nStage = 1);

//::  Called from custom Poison scripts to notify target they have been poisoned.
//::  bVisuals  - If TRUE will display standard NWN VFX when poisoned.
//::  sFeedback - The message to show oTarget if they are a PC
void arPONotifyTarget(object oTarget, int bVisuals = TRUE, string sFeedback = "You have been poisoned!");

//::  Returns TRUE if oTarget is Poisoned
int arPOGetIsPoisoned(object oTarget);

//::  Returns TRUE if an item has ITEM_PROPERTY_ONHITCASTSPELL and the specified nSubType
int _arPOIPGetItemHasItemOnHitCastSpellPropertySubType(object oTarget, int nSubType);

//::  Stacks Poison effects used for Ability Drain effects. Used in Poisons with
//::  Ability drain behaviour.
void _arPOStackPoisonPenalty(object oTarget, effect ePoison);

void arApplyPoison(object oPC, object oItem, object oTarget, string sTag)
{
    //::  Improper formatting on Poison TAG
    if ( GetStringLeft(sTag, 6) != "AR_PO_" ) {
        //Log(LOG_POISON, "Improper use of Poison Tag.  The tag used was " + sTag + " for item " + GetName(oItem) + ".");
        //FloatingTextStringOnCreature(MSG_PO_INVALID_ERROR, oPC, FALSE);
        return;
    }

    //::  Invalid Target
    if (oTarget == OBJECT_INVALID || GetObjectType(oTarget) != OBJECT_TYPE_ITEM) {
       FloatingTextStringOnCreature(MSG_PO_INVALID, oPC, FALSE);
       return;
    }

    //::  Invalid Weapon
    int nType = GetBaseItemType(oTarget);
    if (!IPGetIsMeleeWeapon(oTarget) &&
      !IPGetIsProjectile(oTarget)   &&
       nType != BASE_ITEM_SHURIKEN &&
       nType != BASE_ITEM_DART &&
       nType != BASE_ITEM_THROWINGAXE)
    {
       FloatingTextStringOnCreature(MSG_PO_INVALID, oPC, FALSE);
       return;
    }

    //::  Not a Piercing/Slashing Weapon
    if ( IPGetIsBludgeoningWeapon(oTarget) ) {
       FloatingTextStringOnCreature(MSG_PO_INVALID, oPC, FALSE);
       return;
    }

    //::  Weapon already poisoned?
    if ( arPOGetIsWeaponPoisoned(oTarget) ) {
        FloatingTextStringOnCreature(MSG_PO_INVALID_COATED, oPC, FALSE);
        return;
    }

    //::  AR_PO_{applyDC}_{dc}_{duration}_{hitType}_{hitSubType}
    //::  Unique OnHit:
    //::  AR_PO_{applyDC}_{dc}_{duration}_{scriptName}
    int nApplyDC            = StringToInt(GetSubString(sTag, 6, 3));
    int nSaveDC             = StringToInt(GetSubString(sTag, 10, 3));
    float fDuration         = TurnsToSeconds(StringToInt(GetSubString(sTag, 14, 3)));
    int nHitType            = StringToInt(GetSubString(sTag, 18, 3));
    int nHitSubtype         = StringToInt(GetSubString(sTag, 22, 3));
    string sScript          = "";

    //:: Is a unique OnHit script?
    if ( GetSubString(sTag, 18, 2) == "PO" ) {
        sScript     = GetSubString(sTag, 18, GetStringLength(sTag) - 18);
        nHitType    = IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER;
        nHitSubtype = 0;
    }

    //::  Check for Handle Poison Fear
    int bHasFeat = GetHasFeat(960, oPC);
    if (!bHasFeat) {
        // * Force attacks of opportunity
        AssignCommand(oPC, ClearAllActions(TRUE));

        //::  TODO:  Check if Poison is restricted to assassins and blackguards only for autofail?
        //...

        int nDex     = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
        int nCheck   = d10(1) + 10 + nDex;

        //::  Fail?  Uh oh...
        if (nCheck < nApplyDC) {
            FloatingTextStringOnCreature(MSG_PO_FAIL, oPC, FALSE);

            //::  Its impossible to make use of the onhit prop to simulate the
            //::  poison backlash on the PC.  So lets just make something generic
            //::  based on Applied DC.
            int nDmg    = d6() + (3 * nApplyDC/2);
            effect eDmg = EffectDamage(nDmg, DAMAGE_TYPE_ACID);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectLinkEffects(EffectVisualEffect(VFX_IMP_POISON_L), eDmg), oPC);
            gsCMReduceItem(oItem);
            return;
        }

        //::  Success!
        FloatingTextStringOnCreature(MSG_PO_SUCCESS, oPC, FALSE);
    }
    //::  Auto success feedback
    else {
        FloatingTextStringOnCreature(MSG_PO_SUCCESS, oPC, FALSE);
    }
    gsCMReduceItem(oItem);

    //::  All good so far so lets apply the actual poison
    itemproperty ip = sScript != "" ? ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 10) : ItemPropertyOnHitProps(nHitType, nSaveDC, nHitSubtype);
    IPSafeAddItemProperty(oTarget, ip, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);

    //::  Attach Script to run for Unique OnHit & Store DC as well
    DeleteLocalString(oTarget, "RUN_ON_HIT_1");
    DeleteLocalString(oTarget, AR_PO_DC);
    if ( sScript != "" ) {
        SetLocalString(oTarget, "RUN_ON_HIT_1", GetStringLowerCase(sScript));
        SetLocalInt(oTarget, AR_PO_DC, nSaveDC);
    }

    //::  Technically this is not 100% safe but since there is no way to retrieve the sub
    //::  properties of an item (i.e. itempoison), there is nothing we can do about it
    if ( arPOGetIsWeaponPoisoned(oTarget) ) {
        IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_ACID), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, FALSE);
        effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
    }
}

int arPOGetIsWeaponPoisoned(object oWeapon) {
    //::  0  == Sleep
    //::  1  == Stun
    //::  2  == Hold
    //::  3  == Confusion
    //::  9  == Slow
    //::  14 == Silence
    //::  16 == Blind
    //::  18 == Ability Drain
    //::  19 == Item Poison
    //::  20 == Disease
    if ( IPGetItemHasItemOnHitPropertySubType(oWeapon, 0) ||
         IPGetItemHasItemOnHitPropertySubType(oWeapon, 1) ||
         IPGetItemHasItemOnHitPropertySubType(oWeapon, 2) ||
         IPGetItemHasItemOnHitPropertySubType(oWeapon, 3) ||
         IPGetItemHasItemOnHitPropertySubType(oWeapon, 9) ||
         IPGetItemHasItemOnHitPropertySubType(oWeapon, 14) ||
         IPGetItemHasItemOnHitPropertySubType(oWeapon, 16) ||
         IPGetItemHasItemOnHitPropertySubType(oWeapon, 18) ||
         IPGetItemHasItemOnHitPropertySubType(oWeapon, 19) ||
         IPGetItemHasItemOnHitPropertySubType(oWeapon, 20) ||
         _arPOIPGetItemHasItemOnHitCastSpellPropertySubType(oWeapon, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER) )

    {
        return TRUE;
    }

    return FALSE;
}

int arPOGetPoisonDC(object oWeapon) {
    return GetLocalInt(oWeapon, AR_PO_DC);
}

int arPOGetClassDC(object oOrigin) {
    int nDC = 0;

    // nDC += GetLevelByClass(CLASS_TYPE_ASSASSIN, oOrigin);
    nDC += GetLevelByClass(CLASS_TYPE_BLACKGUARD, oOrigin) / 4;

    int nAZN = GetLevelByClass(CLASS_TYPE_ASSASSIN, oOrigin);
    if (nAZN >= 18) nDC +=5;
    else if (nAZN >= 14) nDC +=4;
    else if (nAZN >= 10) nDC +=3;
    else if (nAZN >= 6) nDC +=2;
    else if (nAZN >= 3) nDC +=1;

    return nDC;
}

int arPOApplyPoisonEffectFrom2DA(object oOrigin, object oTarget, int nPoisonId, int nStage = 1) {
    if ( nStage != 1 && nStage != 2 ) nStage = 1;

    int nLevel          = GetHitDice(oOrigin);
    int nDC             = StringToInt( Get2DAString(POISON_2DA, "Save_DC", nPoisonId)) + arPOGetClassDC(oOrigin);
    int nNumDice        = StringToInt( Get2DAString(POISON_2DA, "Dam_" + IntToString(nStage), nPoisonId) );
    int nDice           = StringToInt( Get2DAString(POISON_2DA, "Dice_" + IntToString(nStage), nPoisonId) );
    string sAttribute   = Get2DAString(POISON_2DA, "Default_" + IntToString(nStage), nPoisonId);

    //::  Do the poison save or cancel out if target is already dead at the
    //::  secondary effect or is not poisoned as secondary poison only applies
    //::  if you are poisoned in the first place.
    int bCancelPoison = nStage == 2 && ( GetIsDead(oTarget) || !arPOGetIsPoisoned(oTarget) );
    if ( bCancelPoison || MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON) ) {
        return FALSE;
    }

    //::  This poison is using a scripted attachment for this type of damage
    if ( sAttribute == "****" || sAttribute == "" ) {
        string sScript = Get2DAString(POISON_2DA, "Script_" + IntToString(nStage), nPoisonId);

        //::  Need to mark Target with a poison effect, this case just a VFX to be used for secondary.
        if ( nStage == 1 ) {
            arPONotifyTarget(oTarget);
            ApplyTaggedEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), oTarget, 65.0, EFFECT_TAG_POISON);
        }

        //::  Fire Script! (Some poisons do nothing initially or secondary, so this can be blank)
        if ( sScript != "****" || sScript != "" ) {
            ExecuteScript(GetStringLowerCase(sScript), oTarget);
        }

        return TRUE;
    }

    //::  Get Damage Dice
    int nDamage = 1;
    if ( nDice == 2 )           nDamage = d2(nNumDice);
    else if ( nDice == 3 )      nDamage = d3(nNumDice);
    else if ( nDice == 4 )      nDamage = d4(nNumDice);
    else if ( nDice == 6 )      nDamage = d6(nNumDice);
    else if ( nDice == 8 )      nDamage = d8(nNumDice);

    //::  Get Damage Ability Type
    int nAbilityType = ABILITY_CHARISMA;
    if ( sAttribute == "CON" )          nAbilityType = ABILITY_CONSTITUTION;
    else if ( sAttribute == "DEX" )     nAbilityType = ABILITY_DEXTERITY;
    else if ( sAttribute == "INT" )     nAbilityType = ABILITY_INTELLIGENCE;
    else if ( sAttribute == "STR" )     nAbilityType = ABILITY_STRENGTH;
    else if ( sAttribute == "WIS" )     nAbilityType = ABILITY_WISDOM;

    effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDmg = EffectAbilityDecrease(nAbilityType, nDamage);

    //:: Add as stackable penalty effect
    arPONotifyTarget(oTarget, TRUE, nStage == 1 ? "You have been poisoned!" : "");
    RemoveAndReapplyNEP(oTarget);
    AssignCommand(oTarget, _arPOStackPoisonPenalty(oTarget, EffectLinkEffects(eVis, eDmg)));

    return TRUE;
}

void _arPOStackPoisonPenalty(object oTarget, effect ePoison) {
    //DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget));
    DelayCommand(0.1, ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget, 0.0, EFFECT_TAG_POISON));
}

void arPONotifyTarget(object oTarget, int bVisuals = TRUE, string sFeedback = "You have been poisoned!") {
    if ( bVisuals ) {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POISON_L), oTarget);
    }

    if ( GetIsPC(oTarget) && sFeedback != "" ) {
        //SendMessageToPC(oTarget, MSG_PO_NEGATIVE + sFeedback);
        FloatingTextStringOnCreature(MSG_PO_NEGATIVE + sFeedback, oTarget, FALSE);
    }
}

int arPOGetIsPoisoned(object oTarget) {
    return GetHasTaggedEffect(oTarget, EFFECT_TAG_POISON) || GetHasEffect(EFFECT_TYPE_POISON, oTarget);
}

int _arPOIPGetItemHasItemOnHitCastSpellPropertySubType(object oTarget, int nSubType)
{
    if (GetItemHasItemProperty(oTarget,ITEM_PROPERTY_ONHITCASTSPELL)) {
        itemproperty ipTest = GetFirstItemProperty(oTarget);
        while (GetIsItemPropertyValid(ipTest)) {
            if (GetItemPropertySubType(ipTest) == nSubType) {
                return TRUE;
            }

            ipTest = GetNextItemProperty(oTarget);
        }
    }

    return FALSE;
}

