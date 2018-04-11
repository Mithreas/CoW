#include "gs_inc_combat"

// Batra: Makes NPC attack the PC who tries to speak to it.

void main()
{
    object oPC = GetPCSpeaker();
    object oSelf = OBJECT_SELF;

    ChangeToStandardFaction(oSelf, STANDARD_FACTION_HOSTILE);
    AdjustReputation(oPC, oSelf, -100);
    AssignCommand(oSelf, ActionAttack(oPC));
    SetLocalObject(oSelf, "GS_CB_ATTACK_TARGET", oPC);
    gsCBDetermineCombatRound(oPC);
}
