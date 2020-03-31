// Conversational hook to assign NPC as a PC henchman
// Make sure to use other scripts to check prerequisites.

#include "inc_associates"
#include "nwnx_object"

void main()
{
    object oPC       = GetPCSpeaker();
    object oHench     = OBJECT_SELF;

    AssignCommand( oHench, ClearAllActions());
    AssignCommand( oHench, SpeakString("I am yours to command.") );
    AssignCommand( oHench, ActionForceMoveToObject(oPC) );

    // Set default henchman event handlers.
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, "nw_ch_ac1");
  	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_NOTICE, "nw_ch_ac2");
  	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT, "nw_ch_acb");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED, "nw_ch_ac5");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_DAMAGED, "nw_ch_ac6");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_DISTURBED, "nw_ch_ac8");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND, "nw_ch_ac3");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_DIALOGUE, "nw_ch_ac4");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_SPAWN_IN, "nw_ch_ac9");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_RESTED, "");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_DEATH, "nw_ch_ac7");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT, "nw_ch_acd");
	SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR, "nw_ch_ace");

    SetLocalInt(oHench, "MI_PERSISTS", TRUE);
    SetLocalInt(oHench, "AR_IS_RECRUITED", TRUE);

    AddHenchman(oPC, oHench);
}

