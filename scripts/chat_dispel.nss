#include "inc_chatutils"
#include "inc_effect"
#include "inc_examine"

const string HELP1 = "-dispel allows you to remove all buffs on any player, including yourself, provided you were the one who cast them. In addition, it can remove the effect of the -blind or -deaf commands. To target another player, send -dispel to them as a Tell.\n\n-dispel [+] Tag\nUsed to dispel a specific buff with a visual effect. Example: '-dispel bar' will dispel Barkskin.";
const string HELP2 = " The following is a list of spell tags for available spells:\n'bar' = Barkskin\n'clai' = Clairaudience/Clairvoyance\n'clar' = Clarity\n'dea' = Death Armor\n'ele' = Elemental Shield\n'ene' = Energy Buffer\n'ent' = Entropic Shield\n'eth' = Ethereal Visage\n'fre' = Freedom of Movement\n'gho' = Ghostly Visage\n'glo' = Globe of Invulernability\n'gma' = Greater Spell Mantle\n'gst' = Greater Stoneskin";
const string HELP3 = "\n'imp' = Improved Invisibility\n'inv' = Invisibility\n'isp' = Invisibility Sphere\n'lmi' = Lesser Mind Blank\n'lma' = Lesser Spell Mantle\n'lig' = Light\n'mes' = Mestil's Acid Sheath\n'min' = Mind Blank\n'mgl' = Minor Globe of Invulnerability\n'pre' = Premonition\n'pgo' = Protection from Good\n'pev' = Protection from Evil\n'pel' = Protection from Elements\n'res' = Resist Elements";
const string HELP4 = "\n'san' = Sanctuary\n'see' = See Invisibility\n'sha' = Shadow Shield\n'shi' = Shield\n'sil' = Silence\n'sma' = Spell Mantle\n'sre' = Spell Resistance\n'sto' = Stoneskin\n'tru' = True Seeing\n'ult' = Ultravision\n'wou' = Wounding Whispers";
string HELP = HELP1 + HELP2 + HELP3 + HELP4;

void main()
{
  object oSpeaker = OBJECT_SELF;
  object oTarget  = chatGetTarget(oSpeaker);
  string sParams = chatGetParams(oSpeaker);
  int spellID;
  int ERROR = 1;
  int ERROR_NONE = 0;
  int ERROR_SPELL_NOT_FOUND = 1;
  int ERROR_INVALID_SPELL_ID = 2;

  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-dispel", HELP);
  }

  else
  {
    if (!GetIsObjectValid(oTarget))
    {
      oTarget = oSpeaker;
    }
    effect eBuff = GetFirstEffect(oTarget);

  if(GetStringLeft(sParams, 1) != "")
  {
   if (GetStringLeft(sParams, 3) == "bar") spellID = SPELL_BARKSKIN;
   else if (GetStringLeft(sParams, 4) == "clai") spellID = SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE;
   else if (GetStringLeft(sParams, 4) == "clar") spellID = SPELL_CLARITY;
   else if (GetStringLeft(sParams, 3) == "dea") spellID = SPELL_DEATH_ARMOR;
   else if (GetStringLeft(sParams, 3) == "ele") spellID = SPELL_ELEMENTAL_SHIELD;
   else if (GetStringLeft(sParams, 3) == "ene") spellID = SPELL_ENERGY_BUFFER;
   else if (GetStringLeft(sParams, 3) == "ent") spellID = SPELL_ENTROPIC_SHIELD;
   else if (GetStringLeft(sParams, 3) == "eth") spellID = SPELL_ETHEREAL_VISAGE;
   else if (GetStringLeft(sParams, 3) == "fre") spellID = SPELL_FREEDOM_OF_MOVEMENT;
   else if (GetStringLeft(sParams, 3) == "gho") spellID = SPELL_GHOSTLY_VISAGE;
   else if (GetStringLeft(sParams, 3) == "glo") spellID = SPELL_GLOBE_OF_INVULNERABILITY;
   else if (GetStringLeft(sParams, 3) == "gma") spellID = SPELL_GREATER_SPELL_MANTLE;
   else if (GetStringLeft(sParams, 3) == "gst") spellID = SPELL_GREATER_STONESKIN;
   else if (GetStringLeft(sParams, 3) == "imp") spellID = SPELL_IMPROVED_INVISIBILITY;
   else if (GetStringLeft(sParams, 3) == "inv") spellID = SPELL_INVISIBILITY;
   else if (GetStringLeft(sParams, 3) == "isp") spellID = SPELL_INVISIBILITY_SPHERE;
   else if (GetStringLeft(sParams, 3) == "lmi") spellID = SPELL_LESSER_MIND_BLANK;
   else if (GetStringLeft(sParams, 3) == "lma") spellID = SPELL_LESSER_SPELL_MANTLE;
   else if (GetStringLeft(sParams, 3) == "lig") spellID = SPELL_LIGHT;
   else if (GetStringLeft(sParams, 3) == "mes") spellID = SPELL_MESTILS_ACID_SHEATH;
   else if (GetStringLeft(sParams, 3) == "min") spellID = SPELL_MIND_BLANK;
   else if (GetStringLeft(sParams, 3) == "mgl") spellID = SPELL_MINOR_GLOBE_OF_INVULNERABILITY;
   else if (GetStringLeft(sParams, 3) == "pol") spellID = SPELL_POLYMORPH_SELF;
   else if (GetStringLeft(sParams, 3) == "pre") spellID = SPELL_PREMONITION;
   else if (GetStringLeft(sParams, 3) == "pgo") spellID = SPELL_PROTECTION_FROM_GOOD;
   else if (GetStringLeft(sParams, 3) == "pev") spellID = SPELL_PROTECTION_FROM_EVIL;
   else if (GetStringLeft(sParams, 3) == "pel") spellID = SPELL_PROTECTION_FROM_ELEMENTS;
   else if (GetStringLeft(sParams, 3) == "res") spellID = SPELL_RESIST_ELEMENTS;
   else if (GetStringLeft(sParams, 3) == "san") spellID = SPELL_SANCTUARY;
   else if (GetStringLeft(sParams, 3) == "see") spellID = SPELL_SEE_INVISIBILITY;
   else if (GetStringLeft(sParams, 3) == "sha") spellID = SPELL_SHADOW_SHIELD;
   else if (GetStringLeft(sParams, 3) == "shi") spellID = SPELL_SHIELD;
   else if (GetStringLeft(sParams, 3) == "sil") spellID = SPELL_SILENCE;
   else if (GetStringLeft(sParams, 3) == "sma") spellID = SPELL_SPELL_MANTLE;
   else if (GetStringLeft(sParams, 3) == "sre") spellID = SPELL_SPELL_RESISTANCE;
   else if (GetStringLeft(sParams, 3) == "sto") spellID = SPELL_STONESKIN;
   else if (GetStringLeft(sParams, 3) == "ten") spellID = SPELL_TENSERS_TRANSFORMATION;
   else if (GetStringLeft(sParams, 3) == "tru") spellID = SPELL_TRUE_SEEING;
   else if (GetStringLeft(sParams, 3) == "ult") spellID = SPELL_DARKVISION;
   else if (GetStringLeft(sParams, 3) == "wou") spellID = SPELL_WOUNDING_WHISPERS;
   else
   {
   SendMessageToPC(oSpeaker, "That is not a valid spell identifier.");
   ERROR = ERROR_INVALID_SPELL_ID;

   }
  }

  //else spellID = GetEffectSpellId(eBuff);

    while (GetIsEffectValid(eBuff))
    {

      if(GetEffectCreator(eBuff) == oSpeaker &&
        (GetIsTaggedEffect(eBuff, EFFECT_TAG_CONSOLE_COMMAND_DISPELLABLE) ||
        (/*!GetIsEffectHarmful(eBuff) &&*/ GetEffectSubType(eBuff) != SUBTYPE_SUPERNATURAL && GetEffectSubType(eBuff) != SUBTYPE_EXTRAORDINARY &&
         GetEffectType(eBuff) != EFFECT_TYPE_POLYMORPH /*&& GetEffectType(eBuff) != EFFECT_TYPE_VISUALEFFECT*/)) && (!spellID || GetEffectSpellId(eBuff) == spellID) && ERROR != ERROR_INVALID_SPELL_ID)
      {
        RemoveEffect(oTarget, eBuff);
        ERROR = ERROR_NONE;
      }

      eBuff = GetNextEffect(oTarget);
    }

    if (ERROR == ERROR_NONE)
      {
        string output = "You have stripped ";
        output += (oTarget == oSpeaker) ? ("yourself") : (GetName(oTarget));
        if (GetStringLeft(sParams, 1) != "") output += " of a spell.";
        else output += " of all magical effects cast by you.";
        SendMessageToPC(oSpeaker, output);
      }
    else if (ERROR == ERROR_SPELL_NOT_FOUND) SendMessageToPC(oSpeaker, "Spell not currently cast.");
  }

  chatVerifyCommand(oSpeaker);
}
