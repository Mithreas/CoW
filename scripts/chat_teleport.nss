#include "__server_config"
#include "fb_inc_chatutils"
#include "gs_inc_flag"
#include "gs_inc_text"
#include "inc_customspells"
#include "gs_inc_spell"
#include "gs_inc_worship"
#include "inc_examine"

const string HELP = "If a character has Greater Spell Focus: Transmutation and is level 21+, they can teleport to any destination portal on the island once per day. Using -teleport activates this spell, which functions exactly like a Planar Portal or a Portal Lens.  If the character has Epic Spell Focus: Transmutation, they gain the additional option of creating a temporary source portal usable by anyone, at their location.  Using '-teleport create' creates such a portal, which lasts five minutes.";

void main()
{
    // Command not valid
    if (!ALLOW_TELEPORT) return;

    object oSpeaker = OBJECT_SELF;
    location lLocation = GetLocation(oSpeaker);
    object oPortal;
    object oHide = gsPCGetCreatureHide(oSpeaker);

    if (chatGetParams(oSpeaker) == "?") {
        DisplayTextInExamineWindow("-teleport", HELP);
    } else if (chatGetParams(oSpeaker) == "create") {
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oSpeaker)) {
            if (miSPGetCanCastSpell(oSpeaker, CUSTOM_SPELL_PORTAL)) {
                // Has a remaining spell use, can cast the spell
                miDoCastingAnimation(oSpeaker);
                if (gsFLGetAreaFlag("OVERRIDE_TELEPORT", oSpeaker)) {
                    FloatingTextStringOnCreature(GS_T_16777430, oSpeaker, FALSE);
                }
                else if (GetIsInCombat(oSpeaker)) {
                    FloatingTextStringOnCreature("You cannot use this ability in combat.", oSpeaker, FALSE);
                }
                else {
                    // We're making the portal at our location.
                    oPortal = CreateObject(OBJECT_TYPE_PLACEABLE, "trans_portal", lLocation);
                    DelayCommand(0.1, RecomputeStaticLighting(GetArea(oPortal)));

                    // Portal fades in 5 minutes.
                    DelayCommand(TurnsToSeconds(5), DestroyObject(oPortal));

                    // Feedback
                    SendMessageToPC(oSpeaker,"<cþ  >You have tapped into the ley network and created a juncture.  It will fade in a few minutes.");
                    SetLocalInt(oHide, "CUSTOM_SPELL_" + IntToString(CUSTOM_SPELL_PORTAL), 1);
                }
            }
            else {
                // No remaining spell uses, notify the player.
                SendMessageToPC(oSpeaker,"<cþ  >You cannot use this ability until you rest again.");
            }
        }
        else {
            SendMessageToPC(oSpeaker, "<cþ  >You must have Epic Spell Focus in Transmutation to create a temporary portal.");
        }
    } else {
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oSpeaker)) {
            if (GetHitDice(oSpeaker) < 21) {
                     SendMessageToPC(oSpeaker, "You must be at least level 21 to use use the -teleport command.");
            } else if (!GetLocalInt(oHide, "CUSTOM_SPELL_" + IntToString(CUSTOM_SPELL_TELEPORT))) {
                // Has a remaining spell use, can cast the spell
                miDoCastingAnimation(oSpeaker);
                if (gsFLGetAreaFlag("OVERRIDE_TELEPORT", oSpeaker)) {
                    FloatingTextStringOnCreature(GS_T_16777430, oSpeaker, FALSE);
                }
                else if (GetIsInCombat(oSpeaker)) {
                    FloatingTextStringOnCreature("You cannot use this ability in combat.", oSpeaker, FALSE);
                }
                else {
                    AssignCommand(oSpeaker, ActionStartConversation(oSpeaker, "gs_po_use_lens", TRUE, FALSE));
                    SetLocalInt(oSpeaker, "MI_TELEPORTING", 1);
                }
            }
            else {
                // No remaining spell uses, notify the player.
                SendMessageToPC(oSpeaker,"<cþ  >You cannot use this ability until you rest again.");
            }
        }
        else {
            SendMessageToPC(oSpeaker, "<cþ  >You must have Greater Spell Focus in Transmutation to teleport.");
        }
    }
    chatVerifyCommand(oSpeaker);
}
