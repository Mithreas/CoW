/* WORSHIP Library by Gigaschatten, heavily modified by Mithreas, Fireboar and others */

#include "inc_state"
#include "inc_xp"

const int ASPECT_WAR_DESTRUCTION     = 1;
const int ASPECT_HEARTH_HOME         = 2;
const int ASPECT_KNOWLEDGE_INVENTION = 4;
const int ASPECT_TRICKERY_DECEIT     = 8;
const int ASPECT_NATURE              = 16;
const int ASPECT_MAGIC               = 32;

const int FB_WO_CATEGORY_MAJOR        = 1;
const int FB_WO_CATEGORY_INTERMEDIATE = 2;
const int FB_WO_CATEGORY_LESSER       = 3;
const int FB_WO_CATEGORY_DEMIGOD      = 4;

const int GS_WO_NONE = -1;

// The script compiler has a limitation on constants.
// Soooo . . . we're just not going to add any constants.
// Make sure to add one here and comment it out, then fill in the required stuff below.
// If you want to improve this in the future and have way more time than I do, consider
// porting this logic to a 2da file or to the mysql database.

// TODO: add Halfling (Nature, Hearth and Home) and Elf (Nature/Magic and War/Magic) religions

//const int GS_WO_DIVINES                =     1;
//const int GS_WO_DARK_ONE               =     2;

string gsWOGetPortfolio(int nDeity)
{
  string sPortfolio = "";

  switch (nDeity)
  {
    case 1   : sPortfolio = "The Seven Divines\nThe Emperor, Morrian, Solkin, Nocturne, Trannis, Serrian and Verria\n\nThe official religion of the City of Winds, the Seven Divines are responsible for saving Humanity from extinction.  The Emperor still rules the City today."; break;
    case 2   : sPortfolio = "The Dark One\n\nThe cancer below the City, the source of forbidden blood magics.  Those who desire the power to overthrow the rulers of the City sometimes seek it in the darkest of places."; break;
    default  : sPortfolio = "No portfolio! Please report this bug."; break;
  }

  return sPortfolio;
}

// Sets up the deity list if not already done so
void gsWOSetup();
//return TRUE if nDeity is available for oPlayer
int gsWOGetIsDeityAvailable(int nDeity, object oPlayer = OBJECT_SELF);
//return deity constant resembling sDeity
int gsWOGetDeityByName(string sDeity);
//return name of nDeity
string gsWOGetNameByDeity(int nDeity);
//return aspect of nDeity
int gsWOGetAspect(int nDeity);
//return aspect of oPC's deity
int gsWOGetDeityAspect(object oPC);
//return race restriction of nDeity
int gsWOGetRacialType(int nDeity);
//return whether oPC is of an allowed race for nDeity
int gsWOGetIsRacialTypeAllowed(int nDeity, object oPC);
//return alignment restriction of nDeity
string gsWOGetAlignments(int nDeity);
//return the Piety score of oPC
float gsWOGetPiety(object oPC);
//adjust oPC's Piety by fAmount.  Return FALSE if it is now below 0.
int gsWOAdjustPiety(object oPC, float fAmount, int bReducePietyBelowZero = TRUE);
//adjust piety for oPC if they have the right aspected deity.
void gsWOGiveSpellPiety(object oPC, int bHealSpell);
//return TRUE if deity grants favor to oTarget
int gsWOGrantFavor(object oTarget = OBJECT_SELF);
//return TRUE if deity grants an unrequested boon to oTarget
int gsWOGrantBoon(object oTarget = OBJECT_SELF);
//return TRUE if deity resurrects oTarget
int gsWOGrantResurrection(object oTarget = OBJECT_SELF);
//oPC consecrates oAltar to their deity
void gsWOConsecrate(object oPC, object oAltar);
//oPC desecrates oAltar
void gsWODesecrate(object oPC, object oAltar);
//return the deity to which this altar is consecrated, if any.
int gsWOGetConsecratedDeity(object oAltar);
//return whether or not this altar is desecrated
int gsWOGetIsDesecrated(object oAltar);
// Handles the tedious technicalities of adding a deity's portfolio to the list
void gsWOAddDeity(int nDeity, string sAlignments, int nAspect, int nRacialType);
//lookup the item cache for the worship subsystem
void __gsWOInitCacheItem();
// Changes the currently active category of deities
void gsWOChangeCategory(int nCategory);
// Grabs the nNth deity in nCategory
int fbWOGetNthDeity(int nCategory, int nDeity);
// Grabs the portfolio of the nNth deity in nCategory
string fbWOGetNthPortfolio(int nCategory, int nDeity);
// Convenience method to return the friendly name of the aspect
string fbWOGetAspectName(int nDeity);
// Convenience method to return the name of the race
string fbWOGetRacialTypeName(int nDeity);

object oWOCacheItem = OBJECT_INVALID;
void __gsWOInitCacheItem()
{
    if (GetIsObjectValid(oWOCacheItem))
        return;

    oWOCacheItem = gsCMGetCacheItem("WORSHIP");
}
//-----------------------------------------------------------------
int gsWOGetIsDeityAvailable(int nDeity, object oPlayer = OBJECT_SELF)
{
    if (GetIsDM(oPlayer)) return TRUE;
    if (nDeity == GS_WO_NONE) return TRUE;


    object oItem = gsPCGetCreatureHide(oPlayer);
    // Non religious classes can worship anyone.
    if (!gsCMGetHasClass(CLASS_TYPE_CLERIC, oPlayer) &&
        !gsCMGetHasClass(CLASS_TYPE_PALADIN, oPlayer) &&
        !gsCMGetHasClass(CLASS_TYPE_BLACKGUARD, oPlayer) &&
        !gsCMGetHasClass(CLASS_TYPE_DRUID, oPlayer) &&
        !gsCMGetHasClass(CLASS_TYPE_RANGER, oPlayer) &&
        !gsCMGetHasClass(CLASS_TYPE_DIVINECHAMPION, oPlayer) &&
        !GetLocalInt(gsPCGetCreatureHide(oPlayer), VAR_FAV_SOUL) &&
        !GetLocalInt(oItem, "GIFT_OF_HOLY")) return TRUE;

    // Racial restrictions.
    if (!GetLocalInt(oItem, "GIFT_OF_UFAVOR") && !gsWOGetIsRacialTypeAllowed(nDeity, oPlayer)) return FALSE;

    // Druids can worship only nature god(desse)s.  Rangers can also, without alignment restrictions
    if ((gsCMGetHasClass(CLASS_TYPE_DRUID, oPlayer) ||
         gsCMGetHasClass(CLASS_TYPE_RANGER, oPlayer)) &&
         gsWOGetAspect(nDeity) & ASPECT_NATURE)
    {
      //enforce alignment restrictions if the druid has one of these classes.
      if(!gsCMGetHasClass(CLASS_TYPE_CLERIC, oPlayer) &&
         !gsCMGetHasClass(CLASS_TYPE_PALADIN, oPlayer) &&
         !gsCMGetHasClass(CLASS_TYPE_BLACKGUARD, oPlayer) &&
         !gsCMGetHasClass(CLASS_TYPE_DIVINECHAMPION, oPlayer))
           return TRUE;
    }
    //Rangers don't need to follow a nature deity.
    else if(gsCMGetHasClass(CLASS_TYPE_DRUID, oPlayer))
      return FALSE;


    // Clerics, rangers, paladins, champion of torms and blackguards must obey alignment restrictions.
    //As well as those with the gift of holy & favored souls.
    string sAlignment = "";

    switch (GetAlignmentLawChaos(oPlayer))
    {
    case ALIGNMENT_LAWFUL:  sAlignment = "L"; break;
    case ALIGNMENT_NEUTRAL: sAlignment = "N"; break;
    case ALIGNMENT_CHAOTIC: sAlignment = "C"; break;
    }

    switch (GetAlignmentGoodEvil(oPlayer))
    {
    case ALIGNMENT_GOOD:    sAlignment += "G"; break;
    case ALIGNMENT_NEUTRAL: sAlignment += "N"; break;
    case ALIGNMENT_EVIL:    sAlignment += "E"; break;
    }

    string sDeityAlignment = gsWOGetAlignments(nDeity);

    if (FindSubString(sDeityAlignment, sAlignment) > -1) return TRUE;

    if ((nDeity == gsWOGetDeityByName("Sune") || nDeity == gsWOGetDeityByName("Corellon Larethian")) &&
         gsCMGetHasClass(CLASS_TYPE_PALADIN, oPlayer)) return TRUE;

    return FALSE;
}
//----------------------------------------------------------------
int gsWOGetDeityByName(string sDeity)
{
    if (sDeity == "")                  return GS_WO_NONE;
    if (sDeity == "The Divines")             return 1;
    if (sDeity == "The Dark One")            return 2;

    return FALSE;
}
//----------------------------------------------------------------
string gsWOGetNameByDeity(int nDeity)
{
    switch (nDeity)
    {
        case 1:    return "The Divines";
        case 2:    return "The Dark One";
    }

    return "";
}
//----------------------------------------------------------------
float gsWOGetPiety(object oPC)
{
    object oHide = gsPCGetCreatureHide(oPC);
    return GetLocalFloat(oHide, "GS_ST_PIETY");
}
//----------------------------------------------------------------
int gsWOAdjustPiety(object oPC, float fAmount, int bReducePietyBelowZero = TRUE)
{
    object oHide = gsPCGetCreatureHide(oPC);
    float fPiety = gsWOGetPiety(oPC);

    if(fAmount < 0.0 && fPiety + fAmount < 0.0 && !bReducePietyBelowZero) return FALSE;

    if (fPiety + fAmount > 100.0) fPiety = 100.0;
    else if (fPiety + fAmount < -100.0) fPiety = -100.0;
    else fPiety += fAmount;

    SetLocalFloat(oHide, "GS_ST_PIETY",  fPiety);

    string sMessage = "";
    if (fAmount > 0.0) sMessage += "<cªÕþ>+";
    else               sMessage += "<cþ((>";

    SendMessageToPC(oPC, "Piety: " + sMessage + FloatToString(fAmount, 0, 1) + " (" +
    FloatToString(fPiety, 0, 1) + "%)");

    return (fPiety >= 0.0f);
}
//----------------------------------------------------------------
void gsWOGiveSpellPiety(object oPC, int bHealSpell)
{
    int nAspect = gsWOGetDeityAspect(oPC);

    if (nAspect & ASPECT_MAGIC && !bHealSpell) gsWOAdjustPiety(oPC, 0.1);
    if (nAspect & ASPECT_HEARTH_HOME && bHealSpell) gsWOAdjustPiety(oPC, 0.5);
}
//----------------------------------------------------------------
int gsWOGrantFavor(object oTarget = OBJECT_SELF)
{
    int GS_WO_TIMEOUT_FAVOR        = 10800; // 3 hours
    float GS_WO_COST_LESSER_FAVOR    =     5.0f;
    float GS_WO_COST_GREATER_FAVOR   =    10.0f;
    int GS_WO_PENALTY_PER_LEVEL    =    15;

    //deity
    string sDeity  = GetDeity(oTarget);

    if (sDeity == "")
    {
        FloatingTextStringOnCreature(GS_T_16777282, oTarget, FALSE);
        return FALSE;
    }

    //timeout
    int nTimestamp = gsTIGetActualTimestamp();

    if (GetLocalInt(oTarget, "GS_WO_TIMEOUT_FAVOR") > nTimestamp)
    {
        FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777283, sDeity), oTarget, FALSE);
        return FALSE;
    }

    SetLocalInt(oTarget, "GS_WO_TIMEOUT_FAVOR", nTimestamp + GS_WO_TIMEOUT_FAVOR);

    //piety
    float fPiety  = gsWOGetPiety(oTarget);

    // Removing random chance of triggering.
    // if (IntToFloat(Random(100)) >= fPiety)
    // {
    //    FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777284, sDeity), oTarget, FALSE);
    //    return FALSE;
    // }

    int nFlag      = FALSE;

    //greater favor
    if (fPiety >= GS_WO_COST_GREATER_FAVOR)
    {
        //remove negative effects
        effect eEffect = GetFirstEffect(oTarget);
        int nHitDice   = GetHitDice(oTarget);
        int nHeal = nHitDice * 10; // Max healing is hit dice x 10;
        int nCount = 0;

        while (GetIsEffectValid(eEffect) && nCount < 3)
        {
            switch (GetEffectType(eEffect))
            {
            case EFFECT_TYPE_ABILITY_DECREASE:
            case EFFECT_TYPE_AC_DECREASE:
            case EFFECT_TYPE_ARCANE_SPELL_FAILURE:
            case EFFECT_TYPE_ATTACK_DECREASE:
            case EFFECT_TYPE_BLINDNESS:
            case EFFECT_TYPE_CHARMED:
            case EFFECT_TYPE_CONFUSED:
            case EFFECT_TYPE_CURSE:
            case EFFECT_TYPE_DAMAGE_DECREASE:
            case EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE:
            case EFFECT_TYPE_DAZED:
            case EFFECT_TYPE_DEAF:
            case EFFECT_TYPE_DISEASE:
            case EFFECT_TYPE_DOMINATED:
            case EFFECT_TYPE_ENTANGLE:
            case EFFECT_TYPE_FRIGHTENED:
            case EFFECT_TYPE_NEGATIVELEVEL:
            case EFFECT_TYPE_PARALYZE:
            case EFFECT_TYPE_PETRIFY:
            case EFFECT_TYPE_POISON:
            case EFFECT_TYPE_SAVING_THROW_DECREASE:
            case EFFECT_TYPE_SKILL_DECREASE:
            case EFFECT_TYPE_SLEEP:
            case EFFECT_TYPE_SLOW:
            case EFFECT_TYPE_SPELL_FAILURE:
            case EFFECT_TYPE_SPELL_RESISTANCE_DECREASE:
            case EFFECT_TYPE_STUNNED:
                if (GetEffectSubType(eEffect) != SUBTYPE_EXTRAORDINARY)
                {
                    RemoveEffect(oTarget, eEffect);
                    nFlag = TRUE;
                    nCount++;
                    nHeal -= 100;
                }
            }

            eEffect = GetNextEffect(oTarget);
        }

        // int nCurrentHitPoints = GetCurrentHitPoints(oTarget);
        // int nMaxHitPoints     = GetMaxHitPoints(oTarget);

        //heal
        // if (nFlag || nCurrentHitPoints < nMaxHitPoints / 3)
        // {
        //    ApplyEffectToObject(DURATION_TYPE_INSTANT,
        //                        EffectHeal(nMaxHitPoints - nCurrentHitPoints),
        //                        oTarget);
        //    nFlag = TRUE;
        //}

        if (nHeal > 0)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oTarget);
            nFlag = TRUE;
        }

        //divine wrath - restricted to religious classes only.
        int nWRATHDISABLED = TRUE;  // Disabling this feature
        if (!nFlag && !nWRATHDISABLED &&
            (gsCMGetHasClass(CLASS_TYPE_CLERIC, oTarget) ||
             gsCMGetHasClass(CLASS_TYPE_PALADIN, oTarget) ||
             gsCMGetHasClass(CLASS_TYPE_BLACKGUARD, oTarget)||
             gsCMGetHasClass(CLASS_TYPE_DRUID, oTarget)||
             gsCMGetHasClass(CLASS_TYPE_RANGER, oTarget)))
        {
            location lLocation = GetLocation(oTarget);
            object oEnemy      = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, TRUE);
            effect eVisual1    = EffectVisualEffect(VFX_FNF_STRIKE_HOLY);
            effect eVisual2    = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
            int nDamage        = 0;
            float fPietyEnemy  = gsWOGetPiety(oEnemy);;
            int nResistance    = 0;
            int nNth           = 0;

            while (GetIsObjectValid(oEnemy))
            {
                if (GetIsReactionTypeHostile(oEnemy, oTarget) &&
                    ! gsBOGetIsBossCreature(oEnemy))
                {
                    string sDeityEnemy = GetDeity(oEnemy);

                    if (sDeityEnemy != sDeity)
                    {
                        if (GetIsPC(oEnemy))
                        {
                            nDamage        = d6(FloatToInt(fPiety) * nHitDice / 100);
                            nResistance    = fPietyEnemy < 1.0 ?
                                             0 : d6(FloatToInt(fPietyEnemy) * GetHitDice(oEnemy) / 100);
                        }
                        else
                        {
                            nDamage        = d6(FloatToInt(fPiety));
                            nResistance    = FloatToInt(gsWOGetPiety(oEnemy)) < 20 ?
                                             d6(20) : d6(FloatToInt(gsWOGetPiety(oEnemy)));
                        }

                        //visual effect
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual1, oEnemy);

                        if (nResistance < nDamage)
                        {
                            FloatingTextStringOnCreature(GS_T_16777481, oEnemy, FALSE);

                            //apply damage
                            DelayCommand(
                                1.0,
                                ApplyEffectToObject(
                                    DURATION_TYPE_INSTANT,
                                    EffectLinkEffects(
                                        eVisual2,
                                        EffectDamage(
                                            nDamage - nResistance,
                                            DAMAGE_TYPE_DIVINE,
                                            DAMAGE_POWER_ENERGY)),
                                    oEnemy));
                        }
                        else
                        {
                            FloatingTextStringOnCreature(GS_T_16777480, oEnemy, FALSE);
                        }

                        nFlag = TRUE;
                        nNth++;
                    }
                }

                if (nNth >= 3) break; //affects a maximum of 3 creatures

                oEnemy = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, TRUE);
            }
        }

        if (nFlag)
        {
            gsWOAdjustPiety(oTarget, -GS_WO_COST_GREATER_FAVOR);
            FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777285, sDeity), oTarget, FALSE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                EffectVisualEffect(VFX_FNF_LOS_HOLY_20),
                                oTarget);

            //apply penalty
            if (GetIsInCombat(oTarget))
            {
                gsXPApplyDeathPenalty(oTarget, nHitDice * GS_WO_PENALTY_PER_LEVEL, TRUE);
            }

            return TRUE;
        }
    }

    //lesser favor
    if (fPiety >= GS_WO_COST_LESSER_FAVOR)
    {
        //state
        if (gsSTGetState(GS_ST_FOOD, oTarget)  <= 0.0) gsSTAdjustState(GS_ST_FOOD,  25.0);
        if (gsSTGetState(GS_ST_WATER, oTarget) <= 0.0) gsSTAdjustState(GS_ST_WATER, 25.0);
        if (gsSTGetState(GS_ST_REST, oTarget)  <= 0.0) gsSTAdjustState(GS_ST_REST,  25.0);

        //ability
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_CHARISMA, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_CONSTITUTION, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_DEXTERITY, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_INTELLIGENCE, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_STRENGTH, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_WISDOM, Random(3)),
                            oTarget,
                            600.0);

        gsWOAdjustPiety(oTarget, -GS_WO_COST_LESSER_FAVOR);
        FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777286, sDeity), oTarget, FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectVisualEffect(VFX_FNF_LOS_HOLY_10),
                            oTarget);
        return TRUE;
    }

    FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777287, sDeity), oTarget, FALSE);
    return FALSE;
}
//----------------------------------------------------------------
int gsWOGrantBoon(object oTarget = OBJECT_SELF)
{
    int GS_WO_TIMEOUT_BOON = 43200; //12 hours
    float GS_WO_COST_BOON  =    25.0f;

    float fPiety = gsWOGetPiety(oTarget);

    string sDeity  = GetDeity(oTarget);
    if (sDeity == "")                                            return FALSE;
    int nTimestamp = gsTIGetActualTimestamp();
    if (GetLocalInt(oTarget, "GS_WO_TIMEOUT_BOON") > nTimestamp) return FALSE;
    SetLocalInt(oTarget, "GS_WO_TIMEOUT_BOON", nTimestamp + GS_WO_TIMEOUT_BOON);
    if (IntToFloat(Random(100)) >= fPiety)                       return FALSE;
    if (Random(100) < 5)                                         return FALSE;
    if (fPiety < GS_WO_COST_BOON)                                return FALSE;

    gsWOAdjustPiety(oTarget, -GS_WO_COST_BOON);
    return TRUE;
}
//----------------------------------------------------------------
int gsWOGrantResurrection(object oTarget = OBJECT_SELF)
{

    string sDeity  = GetDeity(oTarget);
    int nAspect = gsWOGetDeityAspect(oTarget);
    if (!(nAspect & ASPECT_HEARTH_HOME) &&
        !(nAspect & ASPECT_NATURE) &&
        !(nAspect & ASPECT_WAR_DESTRUCTION)) return FALSE;

    if (!GetIsDead(oTarget))                                    return FALSE;
    if (!gsWOGrantBoon(oTarget)) return FALSE;

    ApplyResurrection(oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectHeal(GetMaxHitPoints(oTarget) + 10),
                        oTarget);
    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
            ExtraordinaryEffect(
                EffectLinkEffects(
                    EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
                    EffectLinkEffects(
                        EffectVisualEffect(VFX_DUR_SANCTUARY),
                        EffectEthereal()))),
        oTarget,
        12.0);

    FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777288, sDeity), oTarget, FALSE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectVisualEffect(VFX_FNF_LOS_HOLY_30),
                        oTarget);

    return TRUE;
}
//----------------------------------------------------------------
void gsWOConsecrate(object oPC, object oAltar)
{
   float fPiety = gsWOGetPiety(oPC);

   int nPCDeity = gsWOGetDeityByName(GetDeity(oPC));
   int nAltarDeity = StringToInt(GetLocalString(oAltar, "GS_WO_DEITY"));

   if (nAltarDeity && (nPCDeity != nAltarDeity))
   {
     FloatingTextStringOnCreature("You can only reconsecrate an altar belonging to your deity.", oPC, FALSE);
     return;
   }

   if (fPiety < 20.0f)
   {
     FloatingTextStringOnCreature("You do not have enough piety to consecrate this altar.", oPC, FALSE);
     return;
   }

   gsFXSetLocalString(oAltar, "GS_WO_DEITY", IntToString(nPCDeity));
   gsFXSetLocalString(oAltar, "GS_WO_DESECRATED", "0");
   gsWOAdjustPiety(oPC, -20.0f);
}
//----------------------------------------------------------------
void gsWODesecrate(object oPC, object oAltar)
{
   float fPiety = gsWOGetPiety(oPC);

   if (fPiety < 5.0f)
   {
     FloatingTextStringOnCreature("You do not have enough piety to desecrate this altar.", oPC, FALSE);
     return;
   }

   // Random chance of deity smite.
   if (d20() == 1)
   {
     FloatingTextStringOnCreature("You have incurred the wrath of " +
        gsWOGetNameByDeity(gsWOGetConsecratedDeity(oAltar)) + "!", oPC, FALSE);
     ApplyEffectToObject(DURATION_TYPE_INSTANT,
                         EffectVisualEffect(VFX_FNF_GREATER_RUIN),
                         oPC);
     DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                           EffectDamage(d6(35), DAMAGE_TYPE_DIVINE),
                                           oPC));
   }

   // Hostile nearby NPCs.
   int nNth = 1;
   object oNPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                                    PLAYER_CHAR_NOT_PC,
                                    oPC, nNth);
   while (GetIsObjectValid(oNPC) && GetDistanceBetween(oNPC, oPC) <= 20.0)
   {
     if (LineOfSightObject(oNPC, oPC))
     {
       AdjustReputation(oPC, oNPC, -100);

       // Use the DMFI trick of blinding an NPC so that they see the PC again
       // and trigger hostility.
       effect eInvis =EffectBlindness();
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oNPC, 6.1);
     }

     nNth++;
     oNPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                                    PLAYER_CHAR_NOT_PC,
                                    oPC, nNth);
   }


   gsFXSetLocalString(oAltar, "GS_WO_DESECRATED", "1");
   gsWOAdjustPiety(oPC, -5.0f);
}
//----------------------------------------------------------------
int gsWOGetConsecratedDeity(object oAltar)
{
  int nDeity = StringToInt(GetLocalString(oAltar, "GS_WO_DEITY"));
  if (!nDeity) {
    // check for an INT variable as well (used on permanent altars in the toolset)
    nDeity = GetLocalInt(oAltar, "GS_WO_DEITY");
  }
  if (!nDeity) nDeity = GS_WO_NONE;

  return nDeity;
}
//----------------------------------------------------------------
int gsWOGetIsDesecrated(object oAltar)
{
  return StringToInt(GetLocalString(oAltar, "GS_WO_DESECRATED"));
}
//----------------------------------------------------------------
int nGlobalCategory = 0;
int nGlobalNth = 0;
//----------------------------------------------------------------
void gsWOAddDeity(int nDeity, string sAlignments, int nAspect, int nRacialType)
{
    __gsWOInitCacheItem();
    string sCat   = IntToString(nGlobalCategory);
    string sNth   = IntToString(++nGlobalNth);
    string sDeity = IntToString(nDeity);
    SetLocalInt(oWOCacheItem, "FB_WO_DEITY_"+sCat+"_"+sNth, nDeity);
    SetLocalString(oWOCacheItem, "FB_WO_PORTFOLIO_"+sCat+"_"+sNth, gsWOGetPortfolio(nDeity));
    SetLocalString(oWOCacheItem, "FB_WO_ALIGNMENTS_"+sDeity, sAlignments);
    SetLocalInt(oWOCacheItem, "FB_WO_ASPECT_"+sDeity, nAspect);
    SetLocalInt(oWOCacheItem, "FB_WO_RACE_"+sDeity, nRacialType);
}
//----------------------------------------------------------------
int gsWOGetRacialType(int nDeity)
{
  __gsWOInitCacheItem();
  return (GetLocalInt(oWOCacheItem, "FB_WO_RACE_" + IntToString(nDeity)));
}
//----------------------------------------------------------------
int gsWOGetIsRacialTypeAllowed(int nDeity, object oPlayer)
{
    int nRacialType = gsWOGetRacialType(nDeity);
    int nSubRace = gsSUGetSubRaceByName(GetSubRace(oPlayer));
    //don't allow people to change deity if they're under polymorph.
    //given polymorph has the ability to change race.
    if (gsC2GetHasEffect(EFFECT_TYPE_POLYMORPH, oPlayer, TRUE) && nRacialType != RACIAL_TYPE_ALL)
    {
        SendMessageToPC(oPlayer, "You cannot change deity to racial deities while polymorphed.");
        return FALSE;
    }
    switch (nRacialType)
    {
      case RACIAL_TYPE_ALL: break;
      case RACIAL_TYPE_DWARF:
      case RACIAL_TYPE_GNOME:
        if (GetRacialType(oPlayer) != nRacialType) return FALSE;
        break;
      case RACIAL_TYPE_HALFLING:
        if (GetRacialType(oPlayer) != nRacialType ||
            nSubRace == GS_SU_SPECIAL_GOBLIN ||
            nSubRace == GS_SU_SPECIAL_KOBOLD ||
            nSubRace == GS_SU_SPECIAL_FEY ||
            nSubRace == GS_SU_SPECIAL_IMP) return FALSE;
         break;
      case RACIAL_TYPE_ELF:
        if (GetRacialType(oPlayer) != nRacialType &&
            GetRacialType(oPlayer) != RACIAL_TYPE_HALFELF ||
            nSubRace == GS_SU_SPECIAL_HOBGOBLIN ||
            nSubRace == GS_SU_DEEP_IMASKARI) return FALSE;
         break;
      case RACIAL_TYPE_HUMAN:
        if ((GetRacialType(oPlayer) != nRacialType &&
             GetRacialType(oPlayer) != RACIAL_TYPE_HALFELF &&
             GetRacialType(oPlayer) != RACIAL_TYPE_HALFORC) ||
            nSubRace == GS_SU_HALFORC_OROG ||
            nSubRace == GS_SU_FR_OROG ||
            nSubRace == GS_SU_HALFORC_GNOLL ||
            nSubRace == GS_SU_SPECIAL_OGRE ||
            nSubRace == GS_SU_SPECIAL_HOBGOBLIN) return FALSE;
         break;
      case RACIAL_TYPE_FEY:
         if (nSubRace != GS_SU_SPECIAL_FEY) return FALSE;
         break;
      case RACIAL_TYPE_HUMANOID_GOBLINOID:
         if (nSubRace != GS_SU_SPECIAL_GOBLIN &&
             nSubRace != GS_SU_SPECIAL_HOBGOBLIN) return FALSE;
         break;
      case RACIAL_TYPE_HUMANOID_REPTILIAN:
         if (nSubRace != GS_SU_SPECIAL_KOBOLD &&
             nSubRace != GS_SU_SPECIAL_DRAGON) return FALSE;
         break;
      case RACIAL_TYPE_HUMANOID_ORC:
         if (GetRacialType(oPlayer) != RACIAL_TYPE_HALFORC ||
             nSubRace == GS_SU_HALFORC_GNOLL ||
             nSubRace == GS_SU_SPECIAL_OGRE) return FALSE;
         break;
      case RACIAL_TYPE_HUMANOID_MONSTROUS:
         if (nSubRace != GS_SU_HALFORC_GNOLL &&
             nSubRace != GS_SU_SPECIAL_OGRE) return FALSE;
         break;
    }


    return TRUE;
}
//----------------------------------------------------------------
string gsWOGetAlignments(int nDeity)
{
  __gsWOInitCacheItem();
  return (GetLocalString(oWOCacheItem, "FB_WO_ALIGNMENTS_" + IntToString(nDeity)));
}
//----------------------------------------------------------------
int gsWOGetAspect(int nDeity)
{
  __gsWOInitCacheItem();
  return (GetLocalInt(oWOCacheItem, "FB_WO_ASPECT_" + IntToString(nDeity)));
}
//----------------------------------------------------------------
int gsWOGetDeityAspect(object oPC)
{
  // Harper override.
  if (GetLocalInt(gsPCGetCreatureHide(oPC), VAR_HARPER) == MI_CL_HARPER_PRIEST &&
      GetLevelByClass(CLASS_TYPE_HARPER, oPC) > 4)
  {
    return ASPECT_WAR_DESTRUCTION &
           ASPECT_HEARTH_HOME &
           ASPECT_KNOWLEDGE_INVENTION &
           ASPECT_TRICKERY_DECEIT &
           ASPECT_NATURE &
           ASPECT_MAGIC;
  }
  else
  {
    return gsWOGetAspect(gsWOGetDeityByName(GetDeity(oPC)));
  }
}
//----------------------------------------------------------------
void gsWOSetup()
{
    __gsWOInitCacheItem();
    if (GetLocalInt(oWOCacheItem, "FB_WO_SETUP")) return;

    gsWOChangeCategory(FB_WO_CATEGORY_MAJOR);
    gsWOAddDeity(1, "LG,LN,NG,NN,LE,NE", ASPECT_WAR_DESTRUCTION + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_HUMAN); //Divines
    gsWOAddDeity(2, "CG,CN,CE", ASPECT_TRICKERY_DECEIT + ASPECT_MAGIC, RACIAL_TYPE_HUMAN); //Dark One

    //gsWOChangeCategory(FB_WO_CATEGORY_INTERMEDIATE);

    //gsWOChangeCategory(FB_WO_CATEGORY_LESSER);

    //gsWOChangeCategory(FB_WO_CATEGORY_DEMIGOD);

    SetLocalInt(oWOCacheItem, "FB_WO_SETUP", TRUE);
}
//----------------------------------------------------------------
void gsWOChangeCategory(int nCategory)
{
    nGlobalCategory = nCategory;
    nGlobalNth = 0;
}

//----------------------------------------------------------------
int fbWOGetNthDeity(int nCategory, int nNth)
{
    __gsWOInitCacheItem();
    return GetLocalInt(oWOCacheItem, "FB_WO_DEITY_"+IntToString(nCategory)+"_"+IntToString(nNth));
}
//----------------------------------------------------------------
string fbWOGetNthPortfolio(int nCategory, int nNth)
{
    __gsWOInitCacheItem();
    return GetLocalString(oWOCacheItem, "FB_WO_PORTFOLIO_"+IntToString(nCategory)+"_"+IntToString(nNth));
}
//----------------------------------------------------------------
string fbWOGetAspectName(int nDeity)
{
    int nAspect = gsWOGetAspect(nDeity);
    string sAspect = "";

    if (nAspect & ASPECT_WAR_DESTRUCTION) sAspect += "War and Destruction, ";
    if (nAspect & ASPECT_HEARTH_HOME) sAspect += "Hearth and Home, ";
    if (nAspect & ASPECT_KNOWLEDGE_INVENTION) sAspect += "Knowledge and Invention, ";
    if (nAspect & ASPECT_TRICKERY_DECEIT) sAspect += "Trickery and Deceit, ";
    if (nAspect & ASPECT_NATURE) sAspect += "Nature, ";
    if (nAspect & ASPECT_MAGIC) sAspect += "Magic, ";

    sAspect = GetSubString(sAspect, 0, GetStringLength(sAspect) - 2);

    return sAspect;
}
//----------------------------------------------------------------
string fbWOGetRacialTypeName(int nDeity)
{
  int nRacialType = gsWOGetRacialType(nDeity);
  string sRace = "";

  switch (nRacialType)
  {
    case RACIAL_TYPE_ALL:                 sRace = "Any"; break;
    case RACIAL_TYPE_DWARF:               sRace = "Dwarf"; break;
    case RACIAL_TYPE_ELF:                 sRace = "Elf"; break;
    case RACIAL_TYPE_FEY:                 sRace = "Fey"; break;
    case RACIAL_TYPE_HALFLING:            sRace = "Halfling"; break;
    case RACIAL_TYPE_HUMAN:               sRace = "Human"; break;
    case RACIAL_TYPE_HUMANOID_GOBLINOID:  sRace = "Goblin"; break;
    case RACIAL_TYPE_HUMANOID_REPTILIAN:  sRace = "Reptilian"; break;
    case RACIAL_TYPE_HUMANOID_ORC:        sRace = "Orc"; break;
    case RACIAL_TYPE_HUMANOID_MONSTROUS:  sRace = "Monstrous"; break;
    case RACIAL_TYPE_GNOME:               sRace = "Gnome"; break;
  }

  return sRace;
}