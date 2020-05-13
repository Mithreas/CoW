/*
 * Sense the spirits of the area, revealing them if they are hidden.
 */
#include "inc_chatutils"
#include "inc_examine"
#include "nwnx_visibility"

const string HELP = "Use this to try and reveal any nearby spirits.  You will have to have a relevant class to see them.";

void main()
{
  object oPC = OBJECT_SELF;
  chatVerifyCommand(oPC);

  if (chatGetParams(oPC) == "?")
  {
    DisplayTextInExamineWindow("-sense", HELP);
  }
  else if (GetLevelByClass(CLASS_TYPE_BARD, oPC) ||
		    GetLevelByClass(CLASS_TYPE_DRUID, oPC) ||
			GetLevelByClass(CLASS_TYPE_RANGER, oPC) ||
			GetLevelByClass(CLASS_TYPE_SORCERER, oPC) ||
			GetLevelByClass(CLASS_TYPE_WIZARD, oPC))
  {
    int nNth = 1;
    object oSpirit = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, nNth);
	ApplyEffectToObject(DURATION_TYPE_INSTANT,  EffectVisualEffect(VFX_IMP_PDK_GENERIC_PULSE), oPC);
   
    while (GetIsObjectValid(oSpirit) && GetDistanceBetween(oPC, oSpirit) < 10.0f)
	{
	   if (GetLocalInt(oSpirit, "ATTUNEMENT")) NWNX_Visibility_SetVisibilityOverride(oPC, oSpirit, NWNX_VISIBILITY_VISIBLE);
	   
	   nNth++;
	   oSpirit = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oPC, nNth);
	}
  }
  else
  {
    SendMessageToPC(oPC, "You cannot sense anything.");
  }
}