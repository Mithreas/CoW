/* SPELL Library by Gigaschatten */

//void main() {}

#include "gs_inc_combat2"
#include "inc_item"
#include "x2_inc_spellhook"
#include "inc_stacking"

const float GS_SP_DURATION_INSTANT        = -1.0;
const float GS_SP_DURATION_PERMANENT      = -2.0;

const int GS_SP_TYPE_BENEFICIAL           =  1;
const int GS_SP_TYPE_BENEFICIAL_SELECTIVE =  2;
const int GS_SP_TYPE_HARMFUL              =  3;
const int GS_SP_TYPE_HARMFUL_SELECTIVE    =  4;

const int OBJECT_TYPE_SPELLTARGET         = 73; //OBJECT_TYPE_CREATURE
                                                //OBJECT_TYPE_DOOR
                                                //OBJECT_TYPE_PLACEABLE;

//return current spell id
int gsSPGetSpellID();
//execute gs_spellscript and return TRUE if spell is overridden
int gsSPGetOverrideSpell();
//override current spell of caller, use in gs_spellscript
void gsSPSetOverrideSpell();
//apply eEffect of nSpell to oTarget for fDuration
void gsSPApplyEffect(object oTarget, effect eEffect, int nSpell, float fDuration = GS_SP_DURATION_INSTANT);
//return TRUE if oTarget is affected by a nType (GS_SP_TYPE_*) spell of oCaster
int gsSPGetIsAffected(int nType, object oCaster, object oTarget);
//return TRUE if oTarget resists nSpell of oCaster, show visual effect after fDelay
int gsSPResistSpell(object oCaster, object oTarget, int nSpell, float fDelay = 0.0);
//
int gsSPSavingThrow(object oCaster, object oTarget, int nSpell, int nDC, int nSavingThrow, int nSavingThrowType = SAVING_THROW_TYPE_NONE, float fDelay = 0.0);
//return damage with nCount rolls of nDice using nMetaMagic adding nBonus
int gsSPGetDamage(int nCount, int nDice, int nMetaMagic, int nBonus = 0);
//remove all effects of nSpell applied by oCaster from oTarget
void gsSPRemoveEffect(object oTarget, int nSpell, object oCaster = OBJECT_INVALID);
//return random float between fMinimum and fMaximum
float gsSPGetRandomDelay(float fMinimum = 0.5, float fMaximum = 1.5);
//return spell delay for fDistance
float gsSPGetDelay(float fDistance);
//return TRUE if oCreature is a humanoid
int gsSPGetIsHumanoid(object oCreature);
//return TRUE if oCreature is an animal
int gsSPGetIsAnimal(object oCreature);
//return TRUE if oCreature is an undead
int gsSPGetIsUndead(object oCreature);
//return TRUE if oCreature is a living being
int gsSPGetIsLiving(object oCreature);
//set if last spell of oCaster is nHarmful
void gsSPSetLastSpellHarmful(object oCaster = OBJECT_SELF, int nHarmful = TRUE);
//return TRUE if last spell of oCaster is harmful
int gsSPGetLastSpellHarmful(object oCaster = OBJECT_SELF);
//set last spell target of oCaster
void gsSPSetLastSpellTarget(object oCaster, object oTarget = OBJECT_INVALID);
//return last spell target of oCaster
object gsSPGetLastSpellTarget(object oCaster = OBJECT_SELF);
//set spell callback flag of oCaster
void gsSPSetSpellCallback(object oCaster = OBJECT_SELF);
//return spell callback flag of oCaster
int gsSPGetSpellCallback(object oCaster = OBJECT_SELF);
//reset spell callback flag of oCaster
void gsSPResetSpellCallback(object oCaster = OBJECT_SELF);
//return level of nSpell for nClass
int gsSPGetSpellLevel(int nSpell, int nClass = CLASS_TYPE_INVALID);
//return true if casters are allowed to buff this weapon.
int gSPGetCanCastWeaponBuff(object oTargetItem);

//remove up to nCount spells from oTarget that are affected by spell breach
void gsSPApplySpellBreach(object oTarget, int nCount);
//internally used
void _gsSPApplySpellBreach(object oTarget, int nSpell);
//make oCaster dispel area of effect oTarget by nChance
void gsSPDispelAreaOfEffect(object oCaster, object oTarget, int nChance = 100);
//take nCharges worth of spell components from oPC. Return FALSE if we didn't
// have enough, TRUE otherwise.
int gsSPReduceCharges(object oPC, int nNumCharges, int bReduceChargesBelowZero = FALSE);
// Return stotal number of spell components available to the PC.
int GetTotalSpellComponentCharges(object oPC);

//----------------------------------------------------------------
int gsSPReduceCharges(object oPC, int nNumCharges, int bReduceChargesBelowZero = FALSE)
{
  if(nNumCharges > GetTotalSpellComponentCharges(oPC) && !bReduceChargesBelowZero) return FALSE;

  // Cycle through inventory depleting spell pouches until we use up all our
  // charges or run out of components.
  object oItem = GetFirstItemInInventory(oPC);

  while (GetIsObjectValid(oItem) && nNumCharges > 0)
  {
    if (GetTag(oItem) == "MI_SPELL_POUCH" || GetLocalString(oItem, NO_STACK_TAG) == "MI_SPELL_POUCH" )
    {
       int nCharges = GetItemCharges(oItem);
       if (nCharges > nNumCharges)
       {
         SetItemCharges(oItem, nCharges - nNumCharges);
         SendMessageToPC(oPC, "Your pouch has " + IntToString(nCharges - nNumCharges) + " components left.");
         nNumCharges = 0; // miesny_jez - fix to display correct number of left charges in spell components
       }
       else
       {
         if (nCharges) DestroyObject (oItem);
         nNumCharges -= nCharges;
       }
    }

    oItem = GetNextItemInInventory(oPC);
  }

  // Did we find enough components?
  if (nNumCharges == 0) return TRUE;
  else return FALSE;
}
//----------------------------------------------------------------
int gsSPGetSpellID()
{
    effect eEffect = EffectBlindness();
    return GetEffectSpellId(eEffect);
}
//----------------------------------------------------------------
int gsSPGetOverrideSpell()
{
    return ! X2PreSpellCastCode(); //temporary override

    ExecuteScript("gs_spellscript", OBJECT_SELF);

    int nOverrideSpell = GetLocalInt(OBJECT_SELF, "GS_SP_OVERRIDE_SPELL");
    DeleteLocalInt(OBJECT_SELF, "GS_SP_OVERRIDE_SPELL");
    return nOverrideSpell;
}
//----------------------------------------------------------------
void gsSPSetOverrideSpell()
{
    SetLocalInt(OBJECT_SELF, "GS_SP_OVERRIDE_SPELL", TRUE);
}
//----------------------------------------------------------------
void gsSPApplyEffect(object oTarget, effect eEffect, int nSpell, float fDuration = GS_SP_DURATION_INSTANT)
{
    effect eCurrentEffect = GetFirstEffect(oTarget);
    int nHitPoints        = GetCurrentHitPoints(oTarget);
    int nCount1           = 0;
    int nEffective        = FALSE;

    //effect count before
    while (GetIsEffectValid(eCurrentEffect))
    {
        nCount1        += 1;
        eCurrentEffect  = GetNextEffect(oTarget);
    }

    //apply effect
    if (fDuration == GS_SP_DURATION_INSTANT)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oTarget);
    }
    else
    {
        if (fDuration == GS_SP_DURATION_PERMANENT)
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oTarget);
        }
        else
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration);
        }

        //check applied effect
        nEffective = GetHasSpellEffect(nSpell, oTarget);
    }

    //check spell effectiveness
    if (! nEffective)
    {
        //check hit point count
        if (nHitPoints == GetCurrentHitPoints(oTarget))
        {
            //effect count after
            int nCount2    = 0;
            eCurrentEffect = GetFirstEffect(oTarget);

            while (GetIsEffectValid(eCurrentEffect))
            {
                nCount2        += 1;
                eCurrentEffect  = GetNextEffect(oTarget);
            }

            //check effect count
            if (nCount1 == nCount2)
            {
                //the spell is considered ineffective
                gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
                return;
            }
        }
    }

    //the spell is considered effective
    gsC2AdjustSpellEffectiveness(nSpell, oTarget);
}
//----------------------------------------------------------------
int gsSPGetIsAffected(int nType, object oCaster, object oTarget)
{
    if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM)           return TRUE;
    if (GetPlotFlag(oTarget))                                 return FALSE;
    if (GetIsDM(oCaster))                                     return TRUE;
    // Edit by Mithreas - allow healing spells to heal dying PCs.
    if (GetIsDead(oTarget) && nType != GS_SP_TYPE_BENEFICIAL) return FALSE;

    // NPCs never hurt allies.
    if(!GetIsPC(oCaster) && nType == GS_SP_TYPE_HARMFUL)
        nType = GS_SP_TYPE_HARMFUL_SELECTIVE;

    switch (nType)
    {
    case GS_SP_TYPE_BENEFICIAL:
        return TRUE;

    case GS_SP_TYPE_BENEFICIAL_SELECTIVE:
        if (GetIsReactionTypeFriendly(oTarget, oCaster) ||
            (GetFactionEqual(oTarget, oCaster) &&
             ! GetIsReactionTypeHostile(oTarget, oCaster)))
        {
            return TRUE;
        }
        break;

    case GS_SP_TYPE_HARMFUL:
        if (GetIsPC(oCaster))                           return TRUE;
        if (GetIsReactionTypeHostile(oTarget, oCaster)) return TRUE;
        break;

    case GS_SP_TYPE_HARMFUL_SELECTIVE:
        if (oTarget == oCaster)                         return FALSE;
        if (GetIsReactionTypeHostile(oTarget, oCaster)) return TRUE;
        break;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsSPResistSpell(object oCaster, object oTarget, int nSpell, float fDelay = 0.0)
{
    if(GetIsObjectValid(GetSpellCastItem()) && GetIsItemMundane(GetSpellCastItem())) return FALSE;

    int nEffect = FALSE;

    switch (ResistSpell(oCaster, oTarget))
    {
    case 1: //resistance
        nEffect = VFX_IMP_MAGIC_RESISTANCE_USE;
        break;

    case 2: //imunity
        nEffect = VFX_IMP_GLOBE_USE;
        break;

    case 3: //absorption
        nEffect = VFX_IMP_SPELL_MANTLE_USE;
        break;
    }

    if (nEffect)
    {
        DelayCommand(
            fDelay,
            ApplyEffectToObject(
                DURATION_TYPE_INSTANT,
                EffectVisualEffect(nEffect),
                oTarget));

        gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
        return TRUE;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsSPSavingThrow(object oCaster, object oTarget, int nSpell, int nDC, int nSavingThrow, int nSavingThrowType = SAVING_THROW_TYPE_NONE, float fDelay = 0.0)
{
    if (GetIsDM(oCaster)) return FALSE;

    int nSuccess = FALSE;
    int nEffect  = FALSE;

    if (nDC < 1)        nDC =   1;
    else if (nDC > 255) nDC = 255;

    switch (nSavingThrow)
    {
    case SAVING_THROW_FORT:
        nSuccess = FortitudeSave(oTarget, nDC, nSavingThrowType, oCaster);
        if (nSuccess == 1) nEffect = VFX_IMP_FORTITUDE_SAVING_THROW_USE;
        break;

    case SAVING_THROW_REFLEX:
        nSuccess = ReflexSave(oTarget, nDC, nSavingThrowType, oCaster);
        if (nSuccess == 1) nEffect = VFX_IMP_REFLEX_SAVE_THROW_USE;
        break;

    case SAVING_THROW_WILL:
        nSuccess = WillSave(oTarget, nDC, nSavingThrowType, oCaster);
        if (nSuccess == 1) nEffect = VFX_IMP_WILL_SAVING_THROW_USE;
        break;
    }

    switch (nSuccess)
    {
    case 0: //failure
        //death
        if ((nSavingThrowType == SAVING_THROW_TYPE_DEATH ||
             nSpell == SPELL_FINGER_OF_DEATH ||
             nSpell == SPELL_WEIRD) &&
            nSpell != SPELL_HORRID_WILTING)
        {
            nEffect = VFX_IMP_DEATH;
        }
        break;

    case 1: //success
        break;

    case 2: //immunity
        nSuccess = 0;
        nEffect  = VFX_IMP_MAGIC_RESISTANCE_USE;

        gsC2AdjustSpellEffectiveness(nSpell, oTarget, FALSE);
        break;
    }

    if (nEffect)
    {
        DelayCommand(
            fDelay,
            ApplyEffectToObject(
                DURATION_TYPE_INSTANT,
                EffectVisualEffect(nEffect),
                oTarget));
    }

    return nSuccess != 0;
}
//----------------------------------------------------------------
int gsSPGetDamage(int nCount, int nDice, int nMetaMagic, int nBonus = 0)
{
    int nDamage = 0;
    int nNth    = 0;

    switch (nMetaMagic)
    {
    case METAMAGIC_EMPOWER:
        for (; nNth < nCount; nNth++)
        {
            nDamage += Random(nDice) + 1;
        }
        nDamage += nDamage / 2;
        break;

    case METAMAGIC_MAXIMIZE:
        nDamage  = nCount * nDice;
        break;

    default:
        for (; nNth < nCount; nNth++)
        {
            nDamage += Random(nDice) + 1;
        }
        break;
    }

    return nDamage + nBonus;
}
//----------------------------------------------------------------
void gsSPRemoveEffect(object oTarget, int nSpell, object oCaster = OBJECT_INVALID)
{
    if (GetHasSpellEffect(nSpell, oTarget))
    {
        effect eEffect = GetFirstEffect(oTarget);
        int nCaster    = ! GetIsObjectValid(oCaster);

        while (GetIsEffectValid(eEffect))
        {
            if ((nCaster || GetEffectCreator(eEffect) == oCaster) &&
                GetEffectSpellId(eEffect) == nSpell)
            {
                RemoveEffect(oTarget, eEffect);
            }

            eEffect = GetNextEffect(oTarget);
        }
    }
}
//----------------------------------------------------------------
float gsSPGetRandomDelay(float fMinimum = 0.5, float fMaximum = 1.5)
{
    return fMinimum + IntToFloat(Random(FloatToInt(fMaximum * 10.0) + 1)) / 10.0;
}
//----------------------------------------------------------------
float gsSPGetDelay(float fDistance)
{
    return 3.0 * log(fDistance) + 2.0;
}
//----------------------------------------------------------------
int gsSPGetIsHumanoid(object oCreature)
{
    switch (GetRacialType(oCreature))
    {
    case RACIAL_TYPE_DWARF:
    case RACIAL_TYPE_ELF:
    case RACIAL_TYPE_GNOME:
    case RACIAL_TYPE_HALFELF:
    case RACIAL_TYPE_HALFLING:
    case RACIAL_TYPE_HALFORC:
    case RACIAL_TYPE_HUMAN:
    case RACIAL_TYPE_HUMANOID_GOBLINOID:
    case RACIAL_TYPE_HUMANOID_MONSTROUS:
    case RACIAL_TYPE_HUMANOID_ORC:
    case RACIAL_TYPE_HUMANOID_REPTILIAN:
        return TRUE;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsSPGetIsAnimal(object oCreature)
{
    switch (GetRacialType(oCreature))
    {
    case RACIAL_TYPE_ANIMAL:
        return TRUE;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsSPGetIsUndead(object oCreature)
{
    switch (GetRacialType(oCreature))
    {
    case RACIAL_TYPE_UNDEAD:
        return TRUE;
    }

    return FALSE;
}
//----------------------------------------------------------------
int gsSPGetIsLiving(object oCreature)
{
    switch (GetRacialType(oCreature))
    {
    case RACIAL_TYPE_CONSTRUCT:
    case RACIAL_TYPE_UNDEAD:
        return FALSE;
    }

    return TRUE;
}
//----------------------------------------------------------------
void gsSPSetLastSpellHarmful(object oCaster = OBJECT_SELF, int nHarmful = TRUE)
{
    SetLocalInt(oCaster, "GS_SP_HARMFUL", nHarmful);
}
//----------------------------------------------------------------
int gsSPGetLastSpellHarmful(object oCaster = OBJECT_SELF)
{
    return GetLocalInt(oCaster, "GS_SP_HARMFUL");
}
//----------------------------------------------------------------
void gsSPSetLastSpellTarget(object oCaster, object oTarget = OBJECT_INVALID)
{
    SetLocalObject(oCaster, "GS_SP_TARGET", oTarget);
}
//----------------------------------------------------------------
object gsSPGetLastSpellTarget(object oCaster = OBJECT_SELF)
{
    return GetLocalObject(oCaster, "GS_SP_TARGET");
}
//----------------------------------------------------------------
void gsSPSetSpellCallback(object oCaster = OBJECT_SELF)
{
    SetLocalInt(oCaster, "GS_SP_CALLBACK", TRUE);
}
//----------------------------------------------------------------
int gsSPGetSpellCallback(object oCaster = OBJECT_SELF)
{
    return GetLocalInt(oCaster, "GS_SP_CALLBACK");
}
//----------------------------------------------------------------
void gsSPResetSpellCallback(object oCaster = OBJECT_SELF)
{
    DeleteLocalInt(oCaster, "GS_SP_CALLBACK");
}
//----------------------------------------------------------------
int gsSPGetSpellLevel(int nSpell, int nClass = CLASS_TYPE_INVALID)
{
    string sString = "";

    switch (nClass)
    {
    case CLASS_TYPE_BARD:     sString = "Bard";     break;
    case CLASS_TYPE_CLERIC:   sString = "Cleric";   break;
    case CLASS_TYPE_DRUID:    sString = "Druid";    break;
    case CLASS_TYPE_PALADIN:  sString = "Paladin";  break;
    case CLASS_TYPE_RANGER:   sString = "Ranger";   break;
    case CLASS_TYPE_SORCERER:
    case CLASS_TYPE_WIZARD:   sString = "Wiz_Sorc"; break;
    default:                  sString = "Innate";   break;
    }

    sString        = Get2DAString("spells", sString, nSpell);
    if (sString == "") sString = Get2DAString("spells", "Innate", nSpell);

    return StringToInt(sString);
}
//----------------------------------------------------------------
void gsSPApplySpellBreach(object oTarget, int nCount)
{
    int nSpell = gsC2GetBreachableSpell(oTarget);
    int nNth   = 0;

    while (nSpell && nNth++ < nCount)
    {
        _gsSPApplySpellBreach(oTarget, nSpell);
        nSpell = gsC2GetBreachableSpell(oTarget);
    }
}
//----------------------------------------------------------------
void _gsSPApplySpellBreach(object oTarget, int nSpell)
{
    effect eEffect = GetFirstEffect(oTarget);

    while (GetIsEffectValid(eEffect))
    {
        if (GetEffectSpellId(eEffect) == nSpell) RemoveEffect(oTarget, eEffect);
        eEffect = GetNextEffect(oTarget);
    }
}
//----------------------------------------------------------------
void gsSPDispelAreaOfEffect(object oCaster, object oTarget, int nChance = 100)
{
    if (GetIsDM(oCaster) ||
        oCaster == GetAreaOfEffectCreator(oTarget))
    {
        nChance = 100;
    }

    if (Random(100) < nChance)
    {
        FloatingTextStrRefOnCreature(100929, oCaster, FALSE);
        DestroyObject(oTarget);
    }
    else
    {
        FloatingTextStrRefOnCreature(100930, oCaster, FALSE);
    }
}
//----------------------------------------------------------------
int gSPGetCanCastWeaponBuff(object oTargetItem)
{
  itemproperty ipProperty = GetFirstItemProperty(oTargetItem);

  while (GetIsItemPropertyValid(ipProperty))
  {
    if (GetItemPropertyDurationType(ipProperty) == DURATION_TYPE_PERMANENT &&
        !(GetItemPropertyType(ipProperty) == ITEM_PROPERTY_BONUS_FEAT &&
          GetItemPropertySubType(ipProperty) == IP_CONST_FEAT_DISARM_WHIP))
    {
      return FALSE;
    }

    ipProperty = GetNextItemProperty(oTargetItem);
  }

  return TRUE;
}
//----------------------------------------------------------------
int GetTotalSpellComponentCharges(object oPC)
{
    int nCharges;
    object oItem = GetFirstItemInInventory(oPC);

    while(GetIsObjectValid(oItem))
    {
        if (GetTag(oItem) == "MI_SPELL_POUCH" || GetLocalString(oItem, NO_STACK_TAG) == "MI_SPELL_POUCH" )
        {
            nCharges += GetItemCharges(oItem);
        }
        oItem = GetNextItemInInventory(oPC);
    }

    return nCharges;
}
