/* LANGUAGE Library by Gigaschatten */

#include "inc_external"
#include "inc_zombie"
#include "inc_common"
#include "inc_subrace"
#include "inc_text"
#include "inc_emote_style"
#include "inc_backgrounds"
#include "inc_warlock"
#include "inc_log"
#include "x3_inc_string"

//void main() {}

const string GS_LA_COLOR_EMOTE       = "<cþþþ>";

// For debug
const string LANGUAGE = "LANGUAGE";

const int GS_LA_LANGUAGE_INVALID     = -1;
const int GS_LA_LANGUAGE_COMMON      =  0;
const int GS_LA_LANGUAGE_ABYSSAL     =  1;
const int GS_LA_LANGUAGE_ANIMAL      =  2;
const int GS_LA_LANGUAGE_CELESTIAL   =  3;
const int GS_LA_LANGUAGE_DRACONIC    =  4;
const int GS_LA_LANGUAGE_DWARVEN     =  5;
const int GS_LA_LANGUAGE_ELVEN       =  6;
const int GS_LA_LANGUAGE_GNOME       =  7;
const int GS_LA_LANGUAGE_GOBLIN      =  8;
const int GS_LA_LANGUAGE_HALFLING    =  9;
const int GS_LA_LANGUAGE_INFERNAL    = 10;
const int GS_LA_LANGUAGE_ORC         = 11;
const int GS_LA_LANGUAGE_SIGN        = 12;
const int GS_LA_LANGUAGE_THIEF       = 13;
const int GS_LA_LANGUAGE_UNDERCOMMON = 14;
const int GS_LA_LANGUAGE_XANALRESS   = 15;
const int GS_LA_LANGUAGE_GIANT       = 16;

const int GS_LA_LANGUAGE_FIRST = GS_LA_LANGUAGE_COMMON;
const int GS_LA_LANGUAGE_LAST = GS_LA_LANGUAGE_GIANT; // Update this if you add a new language!

//return TRUE if oPC can speak nLanguage
int gsLAGetCanSpeakLanguage(int nLanguage, object oPC = OBJECT_SELF, int nLearning = FALSE);
//returns a float between 0 and 1 of progress towards learning a language
float gsLAGetLanguageProgress(int language, object pc = OBJECT_SELF);
//returns a string representation of the language progress
string gsLAGetLanguageProgressString(int language, object pc = OBJECT_SELF);
//surrounds the provided string in a colour depending on language progression
string gsLAGetLanguageProgressionColour(int language, string str, object pc = OBJECT_SELF);
//return language by sKey
int gsLAGetLanguageByKey(string sKey);
//return name of nLanguage
string gsLAGetLanguageName(int nLanguage);
//return key of nLanguage
string gsLAGetLanguageKey(int nLanguage);
//return sString translated to nLanguage
//if modify is TRUE, modifies the words, else returns the unmodified (but coloured and formatted) string.
string gsLATranslate(string sString, int nLanguage, int nStyle = EMOTE_STYLE_STANDARD, int modify = TRUE);
//initializes languages on the characte
void gsLAInitialiseLanguages(object pc);

int _gsLAGetCanSpeakLanguage(int nLanguage, object oPC, object oHide, string sTag)
{
    Trace(LANGUAGE, "Checking whether the PC can speak " + IntToString(nLanguage) + " naturally.");


    int nRace        = GetRacialType(oPC);
    if(GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC)) nRace = -1; //we ignore base race while shapeshifted
    string sSubRace  = GetSubRace(oPC);
    int nSubRace     = gsSUGetSubRaceByName(sSubRace);
    int nAlignmentGE = GetAlignmentGoodEvil(oPC);
    int nAlignmentLC = GetAlignmentLawChaos(oPC);

    switch (nLanguage)
    {
    case GS_LA_LANGUAGE_COMMON:
        return TRUE;

    case GS_LA_LANGUAGE_ABYSSAL:
        if ((miWAGetIsWarlock(oPC) == PACT_ABYSSAL) ||
            (nSubRace == GS_SU_PLANETOUCHED_TIEFLING &&
             nAlignmentLC != ALIGNMENT_LAWFUL) ||
            (nAlignmentGE == ALIGNMENT_EVIL &&
             nAlignmentLC != ALIGNMENT_LAWFUL &&
             (gsCMGetHasClass(CLASS_TYPE_CLERIC, oPC) ||
              gsCMGetHasClass(CLASS_TYPE_BLACKGUARD, oPC))))
         {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
         }
         break;

    case GS_LA_LANGUAGE_ANIMAL:
        if (nRace == RACIAL_TYPE_ANIMAL ||
            nRace == RACIAL_TYPE_BEAST ||
            miWAGetIsWarlock(oPC) == PACT_FEY ||
            nSubRace == GS_SU_SPECIAL_FEY ||
            nSubRace == GS_SU_HALFORC_GNOLL ||
            nSubRace == GS_SU_GNOME_FOREST ||
            gsCMGetHasClass(CLASS_TYPE_DRUID, oPC) ||
            gsCMGetHasClass(CLASS_TYPE_RANGER, oPC))
         {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
         }
         break;

    case GS_LA_LANGUAGE_CELESTIAL:
        if (nSubRace == GS_SU_PLANETOUCHED_AASIMAR ||
               (nAlignmentGE == ALIGNMENT_GOOD &&
                gsCMGetHasClass(CLASS_TYPE_CLERIC, oPC)) ||
                gsCMGetHasClass(CLASS_TYPE_PALADIN, oPC))
         {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
         }
         break;

    case GS_LA_LANGUAGE_DRACONIC:
        if (nSubRace == GS_SU_SPECIAL_KOBOLD ||
            nSubRace == GS_SU_SPECIAL_DRAGON ||
            gsCMGetHasClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC) ||
            gsCMGetHasClass(CLASS_TYPE_WIZARD, oPC))
         {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
         }
         break;

    case GS_LA_LANGUAGE_DWARVEN:
        if ((FindSubString(sSubRace, "Dwarf") >= 0) ||
               nRace == RACIAL_TYPE_DWARF)
         {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
         }
         break;

    case GS_LA_LANGUAGE_ELVEN:
        if (((FindSubString(sSubRace, "Elf") >= 0) ||
               nRace == RACIAL_TYPE_ELF ||
               nRace == RACIAL_TYPE_HALFELF) &&
               nSubRace != GS_SU_ELF_DROW &&
               nSubRace != GS_SU_SPECIAL_HOBGOBLIN &&
               nSubRace != GS_SU_DEEP_IMASKARI)
         {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
         }

         if (nSubRace == GS_SU_SPECIAL_FEY &&
             GetLocalInt(GetModule(), "STATIC_LEVEL"))
         {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
         }
         break;

    case GS_LA_LANGUAGE_GNOME:
        if ((FindSubString(sSubRace, "Gnome") >= 0) ||
               nSubRace == GS_SU_GNOME_DEEP ||
               nRace == RACIAL_TYPE_GNOME)
         {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
         }
         break;

    case GS_LA_LANGUAGE_GOBLIN:
        if (nSubRace == GS_SU_SPECIAL_GOBLIN ||
            nSubRace == GS_SU_SPECIAL_HOBGOBLIN)
         {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
         }
         break;

    case GS_LA_LANGUAGE_HALFLING:
        if ((nRace == RACIAL_TYPE_HALFLING ||
                (FindSubString(sSubRace, "Halfling") >= 0)) &&
               nSubRace != GS_SU_SPECIAL_FEY &&
               nSubRace != GS_SU_SPECIAL_GOBLIN &&
               nSubRace != GS_SU_SPECIAL_KOBOLD &&
               nSubRace != GS_SU_SPECIAL_IMP)
         {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
         }
         break;

    case GS_LA_LANGUAGE_INFERNAL:
        if ((miWAGetIsWarlock(oPC) == PACT_INFERNAL) ||
            (nSubRace == GS_SU_SPECIAL_RAKSHASA) ||
            (nSubRace == GS_SU_SPECIAL_IMP) ||
            (nSubRace == GS_SU_SPECIAL_CAMBION) ||
            (nSubRace == GS_SU_PLANETOUCHED_TIEFLING &&
             nAlignmentLC == ALIGNMENT_LAWFUL) ||
            (nAlignmentGE == ALIGNMENT_EVIL &&
             nAlignmentLC == ALIGNMENT_LAWFUL &&
             (gsCMGetHasClass(CLASS_TYPE_CLERIC, oPC) ||
              gsCMGetHasClass(CLASS_TYPE_BLACKGUARD, oPC))))
         {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
         }
         break;

    case GS_LA_LANGUAGE_ORC:
        if (( (FindSubString(sSubRace, "Half-Orc") >= 0) ||
                nRace == RACIAL_TYPE_HALFORC) &&
                nSubRace != GS_SU_HALFORC_GNOLL &&
                nSubRace != GS_SU_SPECIAL_OGRE)
         {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
         }
         break;

    case GS_LA_LANGUAGE_SIGN:
        if (nSubRace == GS_SU_ELF_DROW)
         {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
         }
         break;

    case GS_LA_LANGUAGE_THIEF:
        if (gsCMGetHasClass(CLASS_TYPE_ROGUE, oPC))
         {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
         }
         break;

    case GS_LA_LANGUAGE_UNDERCOMMON:
        if (nSubRace == GS_SU_DWARF_GRAY ||
            nSubRace == GS_SU_ELF_DROW ||
            nSubRace == GS_SU_GNOME_DEEP ||
            nSubRace == GS_SU_SPECIAL_GOBLIN ||
            nSubRace == GS_SU_HALFORC_OROG ||
            nSubRace == GS_SU_SPECIAL_BAATEZU ||
            nSubRace == GS_SU_SPECIAL_RAKSHASA ||
            nSubRace == GS_SU_SPECIAL_DRAGON ||
            nSubRace == GS_SU_SPECIAL_VAMPIRE ||
            nSubRace == GS_SU_FR_OROG ||
            nSubRace == GS_SU_SPECIAL_KOBOLD ||
            nSubRace == GS_SU_SPECIAL_OGRE ||
            nSubRace == GS_SU_SPECIAL_IMP ||
            nSubRace == GS_SU_SPECIAL_HOBGOBLIN ||
            nSubRace == GS_SU_HALFORC_GNOLL ||
            miBAGetBackground(oPC) == MI_BA_OUTCAST ||
            nSubRace == GS_SU_DEEP_IMASKARI)
         {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
         }
         break;

    case GS_LA_LANGUAGE_XANALRESS:
        if (nSubRace == GS_SU_ELF_DROW) {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
         }
         break;

    case GS_LA_LANGUAGE_GIANT:
        if (nSubRace == GS_SU_SPECIAL_OGRE) {
           SetLocalInt(oHide, sTag, 1);
           return TRUE;
        }
        break;
    }

    Trace(LANGUAGE, "Apparently not.");
    return FALSE;
}
int gsLAGetCanSpeakLanguage(int nLanguage, object oPC = OBJECT_SELF, int nLearning = FALSE)
{
  if (GetIsDM(oPC))            return TRUE;
  if (GetIsDMPossessed(oPC))   return TRUE;
  if (GetIsPossessedFamiliar(oPC)) oPC = GetMaster(oPC);

  Trace(LANGUAGE, "Checking whether a PC can understand " + IntToString(nLanguage));

  if (fbZGetIsZombie(oPC))
  {
    if (nLanguage == FB_Z_LANGUAGE_ZOMBIE) return TRUE;
    return FALSE;
  }

  string sTag  = "GS_LA_LANGUAGE_" + IntToString(nLanguage);
  object oHide = gsPCGetCreatureHide(oPC);
  if (GetLocalInt(oHide, sTag)) return TRUE;

  object oItem = GetItemPossessedBy(oPC, sTag);
  if (GetIsObjectValid(oItem))
  {
    Trace(LANGUAGE, "Ear ear, we seem to have an ear.");
    SetLocalInt(oHide, sTag, 1);
    DeleteLocalInt(oHide, "PROGRESS_" + IntToString(nLanguage)); // Cleanup character hide
    return TRUE;
  }

  // Phrasebooks
  string sTag2     = "MI_LA_PHRASEBK_" + IntToString(nLanguage);
  object oBook     = GetItemPossessedBy(oPC, sTag2);
  if (GetIsObjectValid(oBook))
  {
    int nScore      = GetLocalInt(oHide, "PROGRESS_" + IntToString(nLanguage));
    int scoreOnBook = GetLocalInt(oBook, "PROGRESS_" + gsPCGetPlayerID(oPC));

    if (scoreOnBook > nScore)
    {
        // Transfer progress from books to character storage.
        SetLocalInt(oHide, "PROGRESS_" + IntToString(nLanguage), scoreOnBook);
        nScore = scoreOnBook;
    }

    int nBaseAbility   = gsCMGetBaseAbilityModifier(oPC, ABILITY_INTELLIGENCE);
    int nAbility       = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC); // Easier to learn if your INT is boosted.

    if (GetLocalInt(oHide, "GIFT_OF_TONGUES"))
    {
      nBaseAbility += 4;
      nAbility += 4;
    }

    Trace(LANGUAGE, "We have a book, and the current score is " + IntToString(nScore));

    if (d6() <= nAbility)
    {
      Trace(LANGUAGE, "Roll successful. Whoopee!");

      if (nLearning)
      {
        // Make sure the PC hasn't reached his/her cap
        int nCount  = GetLocalInt(oHide, "GS_LA_LANGUAGES");
        int nI;
        string sI;
        if (!GetLocalInt(oHide, "GS_LA_COUNTED")) // temporary measure for compatability with old scripts
        {
          Trace(LANGUAGE, "Quick filter.");
          nCount = 0;
          for (nI = 1; nI <= 14; nI++)
          {
            sI = IntToString(nI);

            // Can't speak naturally
            if (!_gsLAGetCanSpeakLanguage(nI, oPC, oHide, "GS_LA_LANGUAGE_" + sI))
            {
              if (nCount >= nBaseAbility)
              {
                // Trim languages that exceed the player's INT modifier.
                DeleteLocalInt(oHide, "GS_LA_LANGUAGE_" + sI);
                Trace(LANGUAGE, "Ooh, tough cheese, we've just dropped " + sI);
              }
              else if (GetLocalInt(oHide, "GS_LA_LANGUAGE_" + sI))
              {
                Trace(LANGUAGE, "Found a language, it's " + sI);
                nCount++;
              }
            }
          }
          SetLocalInt(oHide, "GS_LA_COUNTED", TRUE);
          SetLocalInt(oHide, "GS_LA_LANGUAGES", nCount);
        }

        int nLanguagesToLearn = nBaseAbility - nCount;
        if (nLanguagesToLearn > 0)
        {
          Trace(LANGUAGE, "Time to do some learning.");

          // Only allow +10 per IG hour
          int nTimestamp = gsTIGetActualTimestamp();
          string sTime   = "";
          for (nI = 0; nI < 10; nI++)
          {
            sI = IntToString(nI);

            // dunshine: also check for the x yearly timestamp fix here, which will result in book timestamps which are 50 year-ish ahead of actual timestamp
            if ((GetLocalInt(oBook, "GS_LA_TIMESTAMP_" + sI) < nTimestamp) || (GetLocalInt(oBook, "GS_LA_TIMESTAMP_" + sI) > (nTimestamp + 3600)))
            {
              sTime = "GS_LA_TIMESTAMP_" + sI;
              break;
            }
          }

          // There is a timestamp "slot" free
          if (sTime != "")
          {
            nScore ++;
            SetLocalInt(oHide, "PROGRESS_" + IntToString(nLanguage), nScore);
            SetLocalInt(oBook, sTime, nTimestamp + 3600);
          }

          Trace(LANGUAGE, "Timeslot used (none if blank): " + sTime);
        }
      }

      if (nScore >= 1000)
      {
        Trace(LANGUAGE, "We've just learned a new language. Double whoopee!");
        SetLocalInt(oHide, sTag, 1);
        SetLocalInt(oHide, "GS_LA_LANGUAGES", GetLocalInt(oHide, "GS_LA_LANGUAGES") + 1);
        DeleteLocalInt(oHide, "PROGRESS_" + IntToString(nLanguage)); // Remove the progress variable, we've fully learned it.
        return TRUE;
      }
     }
     if (Random(1000) + 1 <= nScore)
      {
        return 2;
      }
  }

  // Polymorph effect: should not teach new languages.
  effect eEffect = GetFirstEffect(oPC);
  while (GetIsEffectValid(eEffect))
  {
    if (GetEffectType(eEffect) == EFFECT_TYPE_POLYMORPH)
    {
      // Shifted characters were unable to speak common due to this check.
      // This is the case because _gsLAGetCanSpeakLanguage sets the learned flag for all languages -except- common.
      // Rather than change that (and risk everything else in the world breaking), I'm just gonna check there.
      // Also, when polymorphed, we're letting them understand animal. But only while shifted.
      return nLanguage == GS_LA_LANGUAGE_COMMON || nLanguage == GS_LA_LANGUAGE_ANIMAL;
    }
    eEffect = GetNextEffect(oPC);
  }

  return _gsLAGetCanSpeakLanguage(nLanguage, oPC, oHide, sTag);
}
//----------------------------------------------------------------
float gsLAGetLanguageProgress(int language, object pc = OBJECT_SELF)
{
    object hide = gsPCGetCreatureHide(pc);

    string languageTag = "GS_LA_LANGUAGE_" + IntToString(language);
    int knowsLanguage = GetLocalInt(hide, languageTag);
    int hasLanguageItem = GetIsObjectValid(GetItemPossessedBy(pc, languageTag));

    if (language == GS_LA_LANGUAGE_COMMON || knowsLanguage || hasLanguageItem)
    {
        return 1.0; // We've mastered the language
    }

    int progress = GetLocalInt(hide, "PROGRESS_" + IntToString(language));
    return IntToFloat(progress) / 1000.0;
}
//----------------------------------------------------------------
string gsLAGetLanguageProgressString(int language, object pc = OBJECT_SELF)
{
    float progress = gsLAGetLanguageProgress(language, pc);

    if (progress == 0.0)
    {
        return "Unknown";
    }
    else if (progress <= 0.33)
    {
        return "Beginner";
    }
    else if (progress <= 0.66)
    {
        return "Intermediate";
    }
    else if (progress < 1.0)
    {
        return "Advanced";
    }

    return "Fluent";
}
//----------------------------------------------------------------
string gsLAGetLanguageProgressionColour(int language, string str, object pc = OBJECT_SELF)
{
    float progress = gsLAGetLanguageProgress(language, pc);

    if (progress == 0.0)
    {
        return StringToRGBString(str, STRING_COLOR_RED);
    }
    else if (progress <= 0.33)
    {
        return StringToRGBString(str, "950");
    }
    else if (progress <= 0.66)
    {
        return StringToRGBString(str, "990");
    }
    else if (progress < 1.0)
    {
        return StringToRGBString(str, "592");
    }

    return StringToRGBString(str, STRING_COLOR_GREEN);
}
//----------------------------------------------------------------
int gsLAGetLanguageByKey(string sKey)
{
    sKey = GetStringLowerCase(sKey);

    if (sKey == GS_T_16777530) return GS_LA_LANGUAGE_COMMON;
    if (sKey == GS_T_16777357) return GS_LA_LANGUAGE_ABYSSAL;
    if (sKey == GS_T_16777358) return GS_LA_LANGUAGE_ANIMAL;
    if (sKey == GS_T_16777359) return GS_LA_LANGUAGE_CELESTIAL;
    if (sKey == GS_T_16777360) return GS_LA_LANGUAGE_DRACONIC;
    if (sKey == GS_T_16777361) return GS_LA_LANGUAGE_DWARVEN;
    if (sKey == GS_T_16777362) return GS_LA_LANGUAGE_ELVEN;
    if (sKey == GS_T_16777363) return GS_LA_LANGUAGE_GNOME;
    if (sKey == GS_T_16777364) return GS_LA_LANGUAGE_GOBLIN;
    if (sKey == GS_T_16777365) return GS_LA_LANGUAGE_HALFLING;
    if (sKey == GS_T_16777366) return GS_LA_LANGUAGE_INFERNAL;
    if (sKey == GS_T_16777367) return GS_LA_LANGUAGE_ORC;
    if (sKey == GS_T_16777368) return GS_LA_LANGUAGE_SIGN;
    if (sKey == GS_T_16777369) return GS_LA_LANGUAGE_THIEF;
    if (sKey == GS_T_16777439) return GS_LA_LANGUAGE_UNDERCOMMON;
    if (sKey == GS_T_16777590) return GS_LA_LANGUAGE_XANALRESS;
    if (sKey == GS_T_16777601) return GS_LA_LANGUAGE_GIANT;
    if (sKey == "zb")          return FB_Z_LANGUAGE_ZOMBIE;

    return GS_LA_LANGUAGE_INVALID;
}
//----------------------------------------------------------------
string gsLAGetLanguageName(int nLanguage)
{
    switch (nLanguage)
    {
    case GS_LA_LANGUAGE_COMMON:      return GS_T_16777529;
    case GS_LA_LANGUAGE_ABYSSAL:     return GS_T_16777344;
    case GS_LA_LANGUAGE_ANIMAL:      return GS_T_16777355;
    case GS_LA_LANGUAGE_CELESTIAL:   return GS_T_16777345;
    case GS_LA_LANGUAGE_DRACONIC:    return GS_T_16777346;
    case GS_LA_LANGUAGE_DWARVEN:     return GS_T_16777347;
    case GS_LA_LANGUAGE_ELVEN:       return GS_T_16777348;
    case GS_LA_LANGUAGE_GNOME:       return GS_T_16777349;
    case GS_LA_LANGUAGE_GOBLIN:      return GS_T_16777350;
    case GS_LA_LANGUAGE_HALFLING:    return GS_T_16777351;
    case GS_LA_LANGUAGE_INFERNAL:    return GS_T_16777352;
    case GS_LA_LANGUAGE_ORC:         return GS_T_16777353;
    case GS_LA_LANGUAGE_SIGN:        return GS_T_16777356;
    case GS_LA_LANGUAGE_THIEF:       return GS_T_16777354;
    case GS_LA_LANGUAGE_UNDERCOMMON: return GS_T_16777440;
    case GS_LA_LANGUAGE_XANALRESS:   return GS_T_16777591;
    case GS_LA_LANGUAGE_GIANT:       return GS_T_16777602;
    case FB_Z_LANGUAGE_ZOMBIE:       return "Zombie";
    }

    return "";
}
//----------------------------------------------------------------
string gsLAGetLanguageKey(int nLanguage)
{
    switch (nLanguage)
    {
    case GS_LA_LANGUAGE_COMMON:      return GS_T_16777530;
    case GS_LA_LANGUAGE_ABYSSAL:     return GS_T_16777357;
    case GS_LA_LANGUAGE_ANIMAL:      return GS_T_16777358;
    case GS_LA_LANGUAGE_CELESTIAL:   return GS_T_16777359;
    case GS_LA_LANGUAGE_DRACONIC:    return GS_T_16777360;
    case GS_LA_LANGUAGE_DWARVEN:     return GS_T_16777361;
    case GS_LA_LANGUAGE_ELVEN:       return GS_T_16777362;
    case GS_LA_LANGUAGE_GNOME:       return GS_T_16777363;
    case GS_LA_LANGUAGE_GOBLIN:      return GS_T_16777364;
    case GS_LA_LANGUAGE_HALFLING:    return GS_T_16777365;
    case GS_LA_LANGUAGE_INFERNAL:    return GS_T_16777366;
    case GS_LA_LANGUAGE_ORC:         return GS_T_16777367;
    case GS_LA_LANGUAGE_SIGN:        return GS_T_16777368;
    case GS_LA_LANGUAGE_THIEF:       return GS_T_16777369;
    case GS_LA_LANGUAGE_UNDERCOMMON: return GS_T_16777439;
    case GS_LA_LANGUAGE_XANALRESS:   return GS_T_16777590;
    case GS_LA_LANGUAGE_GIANT:       return GS_T_16777601;
    case FB_Z_LANGUAGE_ZOMBIE:       return "zb";
    }

    return "";
}
//----------------------------------------------------------------
string gsLAGetLanguageColor(int nLanguage)
{
  switch (nLanguage)
  {
    case GS_LA_LANGUAGE_COMMON:      return "<cþþþ>";
    case GS_LA_LANGUAGE_ABYSSAL:     return "<cT  >";
    case GS_LA_LANGUAGE_ANIMAL:      return "<c^|@>";
    case GS_LA_LANGUAGE_CELESTIAL:   return "<cþì•>";
    case GS_LA_LANGUAGE_DRACONIC:    return "<c»#K>";
    case GS_LA_LANGUAGE_DWARVEN:     return "<c‰‡y>";
    case GS_LA_LANGUAGE_ELVEN:       return "<cÊßt>";
    case GS_LA_LANGUAGE_GNOME:       return "<cÃ™V>";
    case GS_LA_LANGUAGE_GOBLIN:      return "<ct¦L>";
    case GS_LA_LANGUAGE_HALFLING:    return "<cÖ¹G>";
    case GS_LA_LANGUAGE_INFERNAL:    return "<c². >";
    case GS_LA_LANGUAGE_ORC:         return "<c]nD>";
    case GS_LA_LANGUAGE_SIGN:        return "<chYj>";
    case GS_LA_LANGUAGE_THIEF:       return "<cþþþ>";
    case GS_LA_LANGUAGE_UNDERCOMMON: return "<c€2¡>";
    case GS_LA_LANGUAGE_XANALRESS:   return "<c#{Î>";
    case GS_LA_LANGUAGE_GIANT:       return "<c «Á>";
    case FB_Z_LANGUAGE_ZOMBIE:       return "<c|||>";
  }
  
  return "";
}
//----------------------------------------------------------------
string gsLATranslate(string sString, int nLanguage, int nStyle, int modify)
{
  // Save a round trip if common.
  if (nLanguage == GS_LA_LANGUAGE_COMMON)
  {
    return sString;
  }

  string ruby = "Translator.create(:" + gsLAGetLanguageKey(nLanguage) + ")" +
    ".translate(?, " + IntToString(nStyle) + ", " + (modify ? "true" : "false") + ")";
  string sResponse = fbEXRuby(ruby, sString);
  return (sResponse == "" ? sString : sResponse);
}
//---------------------------------------------------------------
void gsLAInitialiseLanguages(object pc)
{
    object hide = gsPCGetCreatureHide(pc);

    if (GetLocalInt(hide, "GS_LA_INIT"))
    {
        return; // Already initialized.
    }

    int i = GS_LA_LANGUAGE_FIRST;
    while (i <= GS_LA_LANGUAGE_LAST)
    {
        _gsLAGetCanSpeakLanguage(i, pc, gsPCGetCreatureHide(pc), "GS_LA_LANGUAGE_" + IntToString(i)); // Gives racial and class languages.
        ++i;
    }

    SetLocalInt(hide, "GS_LA_INIT", 1);
}
