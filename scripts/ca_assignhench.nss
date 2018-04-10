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
	NWNX_Object_SetEventHandler(OBJECT_SELF, CREATURE_EVENT_HEARTBEAT, "nw_ch_ac1");
  	NWNX_Object_SetEventHandler(OBJECT_SELF, CREATURE_EVENT_PERCEPTION, "nw_ch_ac2");
  	NWNX_Object_SetEventHandler(OBJECT_SELF, CREATURE_EVENT_SPELLCAST, "nw_ch_acb");
	NWNX_Object_SetEventHandler(OBJECT_SELF, CREATURE_EVENT_ATTACKED, "nw_ch_ac5");
	NWNX_Object_SetEventHandler(OBJECT_SELF, CREATURE_EVENT_DAMAGED, "nw_ch_ac6");
	NWNX_Object_SetEventHandler(OBJECT_SELF, CREATURE_EVENT_DISTURBED, "nw_ch_ac8");
	NWNX_Object_SetEventHandler(OBJECT_SELF, CREATURE_EVENT_ENDCOMBAT, "nw_ch_ac3");
	NWNX_Object_SetEventHandler(OBJECT_SELF, CREATURE_EVENT_CONVERSATION, "nw_ch_ac4");
	NWNX_Object_SetEventHandler(OBJECT_SELF, CREATURE_EVENT_SPAWN, "nw_ch_ac9");
	NWNX_Object_SetEventHandler(OBJECT_SELF, CREATURE_EVENT_RESTED, "");
	NWNX_Object_SetEventHandler(OBJECT_SELF, CREATURE_EVENT_DEATH, "nw_ch_ac7");
	NWNX_Object_SetEventHandler(OBJECT_SELF, CREATURE_EVENT_USERDEF, "nw_ch_acd");
	NWNX_Object_SetEventHandler(OBJECT_SELF, CREATURE_EVENT_BLOCKED, "nw_ch_ace");

    SetLocalInt(oHench, "MI_PERSISTS", TRUE);
    SetLocalInt(oHench, "AR_IS_RECRUITED", TRUE);

    AddHenchman(oPC, oHench);
}

