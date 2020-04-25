/* WORSHIP Library by Gigaschatten, heavily modified by Mithreas, Fireboar and others */
#include "inc_favsoul"
#include "inc_state"
#include "inc_xp"

const int ASPECT_WAR_DESTRUCTION     = 1;
const int ASPECT_HEARTH_HOME         = 2;
const int ASPECT_KNOWLEDGE_INVENTION = 4;
const int ASPECT_TRICKERY_DECEIT     = 8;
const int ASPECT_NATURE              = 16;
const int ASPECT_MAGIC               = 32;

const int FB_WO_CATEGORY_SEVEN_DIVINES = 1;
const int FB_WO_CATEGORY_BALANCE       = 2;
const int FB_WO_CATEGORY_MAGIC         = 3;
const int FB_WO_CATEGORY_BEAST_CULTS   = 4;
const int FB_WO_CATEGORY_NPC           = 5;

const int GS_WO_NONE = -1;

// The script compiler has a limitation on constants.
// Soooo . . . we're just not going to add any constants.
// Make sure to add one here and comment it out, then fill in the required stuff below.
// If you want to improve this in the future and have way more time than I do, consider
// porting this logic to a 2da file or to the mysql database.

//const int GS_WO_EMPEROR                =     1;
//const int GS_WO_MORRIAN                =     2;
//const int GS_WO_SOLKIN                 =     3;
//const int GS_WO_NOCTURNE               =     4;
//const int GS_WO_TRANNOS                =     5;
//const int GS_WO_SERRIAN                =     6;
//const int GS_WO_VERRIA                 =     7;
//const int GS_WO_DARK_ONE               =     8;
//const int GS_WO_BALANCE                =     9;
//const int GS_WO_ELAKADENCIA            =     10;
//const int GS_WO_GYGOS_THE_GREEN        =     11;
//const int GS_WO_ANTLERED_ONE           =     12;
//const int GS_WO_TRIXIVERIA             =     13;
//const int GS_WO_STAR_EYED_LADY         =     21;
//const int GS_WO_AKAVOS_FIRELORD        =     22;
//const int GS_WO_SABATHA_THE_SNEAK      =     23;
//const int GS_WO_MATHGAR_THE_MIGHTY     =     91;
//const int GS_WO_VALAROS                =     92;
//const int GS_WO_NPC_BEAST_CULT         =     99;

string gsWOGetPortfolio(int nDeity)
{
  string sPortfolio = "";

  switch (nDeity)
  {
    case 1   : sPortfolio = "The Emperor\n\nOne of the Seven Divines, responsible for saving Humanity from extinction.  The Emperor still rules the City today, though rarely shows himself in person.  Those involved in maintaining the city's law, guards and magistrates, are the most likely to worship the Emperor directly."; break;
	case 2   : sPortfolio = "Morrian, Lady Moon\n\nOne of the Seven Divines, responsible for saving Humanity from extinction.  Morrian is the mother figure of the official pantheon, the soft light of the Moon governing the times when families are together under their own roof.  Many families have a small shrine to Morrian even if their primary devotion is to another of the Seven, while she is the most popular divine patron for members of House Renerrin." ; break;
    case 3   : sPortfolio = "Solkin, Lord Sun\n\nOne of the Seven Divines, responsible for saving Humanity from extinction.  Solkin's primary sphere is that of war, and most of House Drannis grant him their primary devotion.  However, he is also the god of passion, worshipped by lovers and craftsmen alike."; break;
    case 4   : sPortfolio = "Nocturne, Lady Night\n\nOne of the Seven Divines, responsible for saving Humanity from extinction.  Nocturne is a common choice for those involved in secretive matters, such as espionage or scouting.  Praying to Nocturne that your passage may not be noted by others is a common prayer, even for those who are not normal devotees of the Lady of Night."; break;
    case 5   : sPortfolio = "Trannos, Lord Twilight\n\nOne of the Seven Divines, responsible for saving Humanity from extinction.  Trannos is the usual patron of scholars and those who seek to uncover mysteries.  For this reason, many craftsman prefer Trannos and his measured philosophy to the passion of Solkin."; break;
    case 6	 : sPortfolio = "Serrian, Lord of Stars, Lord Starlight\n\nOne of the Seven Divines, responsible for saving Humanity from extinction.  The messenger and guide of the gods, Serrian is the usual patron of sailors and others whose life sees much travelling.  Those who follow another patron will often offer a prayer to Serrian before embarking on a journey."; break;
	case 7   : sPortfolio = "Verria, Lady Void\n\nOne of the Seven Divines, responsible for saving Humanity from extinction.  Verria is often turned to by those dealing with loss or heartbreak; her devotees accept that the world is a hard place, but find solace in Her worship.  Devotees of Verria are often fatalists, praying to Verria to alter their fate."; break;
    case 8   : sPortfolio = "The Dark One\n\nThe cancer below the City, the source of forbidden blood magics.  Those who desire the power to overthrow the rulers of the City sometimes seek it in the darkest of places.  Worship of the Dark One is strictly outlawed."; break;
	case 9   : sPortfolio = "The Balance\n\nHalflings, and occasional others, revere the Balance above all.  By making pacts with the elemental spirits of land, sky, river and flame, druidic servants of the Balance can direct natural power.  However, elemental spirits do not all think alike; some may refuse pacts, or may feel that serving the Balance requires a cull..."; break;
	case 10  : sPortfolio = "Elakadencia, Queen of the Fey\n\nThe fey have many kings and queens, each ruling over their own pocket of the Feywilds.  Elakadencia is tall, wise and beautiful with feathered wings of raven black; a powerful and uncompromising champion of the Balance, she receives the unquestioning fealty of her subjects."; break;
	case 11  : sPortfolio = "Gygos the Green\n\nAlso known as the Green Knight, Gygos is often turned to by those who fight to protect nature or the balance.  He has been known to appear occasionally to turn the tide of a battle or to protect a threatened glade, but otherwise is not known for answering prayers or speaking with his followers."; break;
	case 12  : sPortfolio = "The Antlered One\n\nThe true name of the Antlered One is lost to time.  An ancient fertility god, he often attracts followers drawn to the physical aspect of his power, but accepts the worship of all who seek to see life spread and grow.  Many farmers worship him first above all."; break;
	case 13  : sPortfolio = "Queen Trixiveria\n\nThe fey have many kings and queens, each ruling over their own pocket of the Feywilds.  A playful spirit, Trixiveria's lighthearted manner does little to conceal her magical power.  Perhaps more in tune with the twisting magics of the Feywilds than any other, she is often sought out by mortals."; break;
	case 21  : sPortfolio = "Seravithia the Star-Eyed\n\nAlso known as the Star-Eyed Lady, Seravithia is often hailed as the inventor of magic, the first wizard among the Elven people.  Teaching her first followers how to tap into natural power and weave it into spells, she spent her natural life span discovering and teaching.  Death never claimed her, though her followers now hear from her but rarely."; break;
	case 22  : sPortfolio = "Akavos Firelord\n\nAscending to godhood during the Great War, Akavos was a mighty battle mage.  His ascension occurred in the middle of a battle during which he was channeling great power... those who have attempted to replicate the feat have not survived.  Naturally gifted with fire magics, he is often worshipped by other pyromancers."; break;
	case 23  : sPortfolio = "Sabatha the Sneak\n\nSabatha is hailed in Elven mythology as the one who stole the secret of fire from the gods.  An ancient deity, she is hailed as something of a trickster, and her overt worship is looked down on by traditionalists.  Scouts, jesters, those who challenge the status quo, and those who have something to hide often take Sabatha as their patron."; break;
	case 91  : sPortfolio = "Mathgar the Mighty\n\nLittle is known about Mathgar at this time.  His name is carried south on the lips of traders and trackers, worshiped by many in the frozen North."; break;
	case 92  : sPortfolio = "Valaros\n\nRumoured to be the First Shapeshifter, and hence the official or unofficial patron of shapeshifters across the world.  Highly secretive, there are very few tales of him... or her... or whatever!"; break;
	case 99  : sPortfolio = ""; break; // Secret, so no info here in case it shows up.
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
// Selects the deity-appropriate planar stream for this PC. 
int gsWOGetDeityPlanarStream(object oCreature);
// Returns the GS_WO_CATEGORY* of nDeity. 
int gsWOGetCategory(int nDeity);

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
	
	// Racial restrictions - do these first..
    if (!GetLocalInt(oItem, "GIFT_OF_UFAVOR") && !gsWOGetIsRacialTypeAllowed(nDeity, oPlayer)) return FALSE;
	 
	// Favoured Soul.  On Anemoi, Favoured Souls must worship the Seven Divines.
	if (gsCMGetHasClass(CLASS_TYPE_FAVOURED_SOUL, oPlayer))
	{
	  return gsWOGetCategory(nDeity) == FB_WO_CATEGORY_SEVEN_DIVINES;
	}
	
    // Non religious classes can worship anyone.
    if (!gsCMGetHasClass(CLASS_TYPE_CLERIC, oPlayer) &&
        !gsCMGetHasClass(CLASS_TYPE_PALADIN, oPlayer) &&
        !gsCMGetHasClass(CLASS_TYPE_BLACKGUARD, oPlayer) &&
        !gsCMGetHasClass(CLASS_TYPE_DRUID, oPlayer) &&
        !gsCMGetHasClass(CLASS_TYPE_RANGER, oPlayer) &&
        !gsCMGetHasClass(CLASS_TYPE_DIVINECHAMPION, oPlayer) &&
        !GetLocalInt(oItem, "GIFT_OF_HOLY")) return TRUE;

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
    if (sDeity == "The Emperor")             return 1;
    if (sDeity == "Morrian")                 return 2;
    if (sDeity == "Solkin")                  return 3;
    if (sDeity == "Nocturne")                return 4;
    if (sDeity == "Trannos")                 return 5;
    if (sDeity == "Serrian")                 return 6;
    if (sDeity == "Verria")                  return 7;
    if (sDeity == "The Dark One")            return 8;
	if (sDeity == "The Balance")             return 9;
	if (sDeity == "Elakadencia")             return 10;
	if (sDeity == "Gygos the Green")         return 11;
	if (sDeity == "The Antlered One")        return 12;
	if (sDeity == "Trixiveria")              return 13;
	if (sDeity == "Seravithia Star-Eyed")    return 21;
	if (sDeity == "Akavos Firelord")         return 22;
	if (sDeity == "Sabatha the Sneak")       return 23;
	if (sDeity == "Magthar the Mighty")      return 91;
	if (sDeity == "Valaros")                 return 92;
	if (sDeity == "Beast Cult")              return 99;

    return FALSE;
}
//----------------------------------------------------------------
string gsWOGetNameByDeity(int nDeity)
{
    switch (nDeity)
    {
        case 1:    return "The Emperor";
		case 2:    return "Morrian";
		case 3:    return "Solkin";
		case 4:    return "Nocturne";
		case 5:    return "Trannos";
		case 6:    return "Serrian";
		case 7:    return "Verria";
        case 8:    return "The Dark One";
		case 9:    return "The Balance";
		case 10:   return "Elakadencia";
		case 11:   return "Gygos the Green";
		case 12:   return "The Antlered One";
		case 13:   return "Trixiveria";
		case 21:   return "Seravithia Star-Eyed";
		case 22:   return "Akavos Firelord";
		case 23:   return "Sabatha the Sneak";
		case 91:   return "Magthar the Mighty";
		case 92:   return "Valaros";
		case 99:   return "Beast Cult";
    }

    return "";
}
//----------------------------------------------------------------
int gsWOGetCategory(int nDeity)
{
    switch (nDeity)
    {
        case 1:    
		case 2:    
		case 3:    
		case 4:    
		case 5:    
		case 6:    
		case 7:    
		  return FB_WO_CATEGORY_SEVEN_DIVINES;
        case 8:    
		case 21:   
		case 22:   
		case 23:
		  return FB_WO_CATEGORY_MAGIC;
		case 9:    
		case 10:   
		case 11:   
		case 12:   
		case 13:
		  return FB_WO_CATEGORY_BALANCE;
		case 91:
		case 92:
		case 99:   
		default:
		  return FB_WO_CATEGORY_BEAST_CULTS;
    }

    return 0;
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
	
	if (GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC) && fAmount > 0.0) fAmount *= 2;

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
    int GS_WO_PENALTY_PER_LEVEL    =    15;

    //deity
    string sDeity  = GetDeity(oTarget);

    if (sDeity == "")
    {
        FloatingTextStringOnCreature(GS_T_16777282, oTarget, FALSE);
        return FALSE;
    }

	if (gsWOGrantResurrection(oTarget)) return FALSE;
	if (GetIsDead(oTarget)) return FALSE;
	if (!gsWOGrantBoon(oTarget)) 
	{
	  FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777284, sDeity), oTarget, FALSE); 
	  return FALSE;
    }
	
    int nFlag      = FALSE;

    //greater favor
    if (d6() > 3)
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

        if (nHeal > 0)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oTarget);
            nFlag = TRUE;
        }

        if (nFlag)
        {
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
    else
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
    int GS_WO_TIMEOUT_BOON = 60 * 60 * 3; //3 hours
    float GS_WO_COST_BOON  =    25.0f;

    float fPiety = gsWOGetPiety(oTarget);

    string sDeity  = GetDeity(oTarget);
    if (sDeity == "")                                            return FALSE;
    int nTimestamp = gsTIGetActualTimestamp();
    if (IntToFloat(Random(100)) >= fPiety)                       return FALSE;
    if (Random(100) < 5)                                         return FALSE;
    if (fPiety < GS_WO_COST_BOON)                                return FALSE;
    if (GetLocalInt(oTarget, "GS_WO_TIMEOUT_BOON") > nTimestamp) return FALSE;
    SetLocalInt(oTarget, "GS_WO_TIMEOUT_BOON", nTimestamp + GS_WO_TIMEOUT_BOON);

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

    gsWOChangeCategory(FB_WO_CATEGORY_SEVEN_DIVINES);
    gsWOAddDeity(1, "LG,LN,NG,NN,LE,NE", ASPECT_WAR_DESTRUCTION + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_HUMAN); //Emperor
    gsWOAddDeity(2, "LG,LN,NG,NN,LE,NE", ASPECT_HEARTH_HOME + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_HUMAN); //Morrian
    gsWOAddDeity(3, "LG,LN,NG,NN,LE,NE", ASPECT_WAR_DESTRUCTION + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_HUMAN); //Solkin
    gsWOAddDeity(4, "LG,LN,NG,NN,LE,NE,CG,CN,CE", ASPECT_TRICKERY_DECEIT + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_HUMAN); //Nocturne
    gsWOAddDeity(5, "LG,LN,NG,NN,LE,NE,CG,CN,CE", ASPECT_HEARTH_HOME + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_HUMAN); //Trannos
    gsWOAddDeity(6, "LG,LN,NG,NN,LE,NE,CG,CN,CE", ASPECT_WAR_DESTRUCTION + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_HUMAN); //Serrian
    gsWOAddDeity(7, "LG,LN,NG,NN,LE,NE,CG,CN,CE", ASPECT_HEARTH_HOME + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_HUMAN); //Verria

    gsWOChangeCategory(FB_WO_CATEGORY_BALANCE);
	gsWOAddDeity(9, "NG,LN,NN,CN,NE", ASPECT_NATURE + ASPECT_HEARTH_HOME, RACIAL_TYPE_HALFLING); // The Balance
	gsWOAddDeity(10, "NG,LN,NN,CN,NE", ASPECT_NATURE + ASPECT_HEARTH_HOME, RACIAL_TYPE_FEY); // Elakadencia
	gsWOAddDeity(11, "LG,NG,LN,NN,LE,NE", ASPECT_NATURE + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); // Gygos the Green
	gsWOAddDeity(12, "NG,NN,CN,NE,CG,CE", ASPECT_NATURE + ASPECT_HEARTH_HOME, RACIAL_TYPE_ALL); // The Antlered One
	gsWOAddDeity(13, "NG,NN,CN,NE,CG", ASPECT_NATURE + ASPECT_MAGIC, RACIAL_TYPE_FEY); // Trixiveria

    gsWOChangeCategory(FB_WO_CATEGORY_MAGIC);
    gsWOAddDeity(8, "CG,CN,CE", ASPECT_TRICKERY_DECEIT + ASPECT_MAGIC, RACIAL_TYPE_HUMAN); //Dark One
    gsWOAddDeity(21, "LG,LN,LE,NG,NN,NE,CG,CN,CE", ASPECT_HEARTH_HOME + ASPECT_MAGIC, RACIAL_TYPE_ELF); //Seravithia Star-Eyed
    gsWOAddDeity(22, "LG,LN,LE,NG,NN,NE", ASPECT_WAR_DESTRUCTION + ASPECT_MAGIC, RACIAL_TYPE_ELF); //Akavos Firelord
    gsWOAddDeity(23, "CG,CN,CE,NG,NN,NE", ASPECT_TRICKERY_DECEIT + ASPECT_MAGIC, RACIAL_TYPE_ELF); //Sabatha the Sneak
	
    gsWOChangeCategory(FB_WO_CATEGORY_BEAST_CULTS);
	gsWOAddDeity(91, "LG,LN,NG,NN,LE,NE,CG,CN,CE", ASPECT_WAR_DESTRUCTION + ASPECT_NATURE, RACIAL_TYPE_HUMANOID_MONSTROUS); // Magthar
	gsWOAddDeity(92, "LG,LN,NG,NN,LE,NE,CG,CN,CE", ASPECT_WAR_DESTRUCTION + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_SHAPECHANGER); // Valaros
	
    gsWOChangeCategory(FB_WO_CATEGORY_NPC);	
	gsWOAddDeity(99, "LG,NG,CG,LN,NN,CN,LE,NE,CE", ASPECT_NATURE + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_HUMANOID_MONSTROUS); // NPC beast cults

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
//----------------------------------------------------------------
int gsWOGetDeityPlanarStream(object oCreature)
{
    switch(gsWOGetCategory(gsWOGetDeityByName(GetDeity(oCreature))))
    {
        case FB_WO_CATEGORY_SEVEN_DIVINES:
            return STREAM_PLANAR_7DIVINES;
        case FB_WO_CATEGORY_MAGIC:
            return STREAM_PLANAR_MAGIC;
        case FB_WO_CATEGORY_BALANCE:
            return STREAM_PLANAR_BALANCE;
		default:
		    return STREAM_PLANAR_BEAST;
    }
    return 0;
}