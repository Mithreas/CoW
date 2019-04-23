#include "__server_config"
#include "inc_chatutils"
#include "inc_flag"
#include "inc_text"
#include "inc_customspells"
#include "inc_spell"
#include "inc_worship"
#include "inc_examine"

const string HELP = "If a character has Epic Spell Focus: Transmutation they can teleport.  Use -teleport mark to save a location, and -teleport to return to it later.";

void main()
{
    // Command not valid
    if (!ALLOW_TELEPORT) return;

    object oSpeaker = OBJECT_SELF;
    object oPortal;
    object oHide = gsPCGetCreatureHide(oSpeaker);
	location lLocation = APSStringToLocation(GetLocalString(oHide, "ESF_TELEPORT_LOCATION"));

    if (chatGetParams(oSpeaker) == "?") {
        DisplayTextInExamineWindow("-teleport", HELP);
    } else if (chatGetParams(oSpeaker) == "mark") {
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oSpeaker)) {
		    lLocation = GetLocation(oSpeaker);
            miDoCastingAnimation(oSpeaker);
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_COLD), GetLocation(oSpeaker));
			gsSTDoCasterDamage(oSpeaker, 5);
			SetLocalString(oHide, "ESF_TELEPORT_LOCATION", APSLocationToString(lLocation));
        }
        else {
            SendMessageToPC(oSpeaker, "<cþ  >You must have Epic Spell Focus in Transmutation to teleport.");
        }
    } else {
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oSpeaker)) {
            if (!GetIsObjectValid(GetAreaFromLocation(lLocation)))
			{
			  FloatingTextStringOnCreature("You must mark a location before you can return to it.", oSpeaker);			  
			}
			else if (!GetLocalInt(oHide, "CUSTOM_SPELL_" + IntToString(CUSTOM_SPELL_TELEPORT))) {
                // Has a remaining spell use, can cast the spell
                miDoCastingAnimation(oSpeaker);
				
                if (gsFLGetAreaFlag("OVERRIDE_TELEPORT", oSpeaker)) {
                    FloatingTextStringOnCreature(GS_T_16777430, oSpeaker, FALSE);
                }
                else if (GetIsInCombat(oSpeaker)) {
                    FloatingTextStringOnCreature("You cannot use this ability in combat.", oSpeaker, FALSE);
                }
                else {
				  gsCMTeleportToLocation(oSpeaker, lLocation, VFX_IMP_AC_BONUS, TRUE);
				  gsSTDoCasterDamage(oSpeaker, 15);
                }
            }
            else {
                // No remaining spell uses, notify the player.
                SendMessageToPC(oSpeaker,"<cþ  >You cannot use this ability until you rest again.");
            }
        }
        else {
            SendMessageToPC(oSpeaker, "<cþ  >You must have Epic Spell Focus in Transmutation to teleport.");
        }
    }
    chatVerifyCommand(oSpeaker);
}
