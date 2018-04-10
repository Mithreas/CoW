//  ScarFace's Persistent Banking system  - OnUsed -
//  Anti-Theft Script
#include "bank_inc"
void main()
{
    object oChest = OBJECT_SELF,
           oPC = GetLastUsedBy(),
           oWaypoint;
    int iWarning;

    if (GetLocked(oChest))
    {
        FloatingTextStringOnCreature("Please wait a moment", oPC);
    }
    else
    {
       if(GetLocalInt(oChest, "IN_USE") && (GetName(oPC) != GetLocalString(oChest, "USER")))
       {
           iWarning = GetLocalInt(oPC, "WARNED");
           if (iWarning < WARNING)
           {
               iWarning++;
               SetLocalInt(oPC, "WARNED", iWarning);
               AssignCommand(oPC, ClearAllActions());
               AssignCommand(oPC, ActionMoveAwayFromObject(oChest, FALSE, 5.0));
               FloatingTextStringOnCreature("This is a warning, do not interfer with players using bank chests", oPC);
            }
            else
            {
                if (SEND_TO_JAIL)
                {
                    oWaypoint = GetWaypointByTag(JAIL_WAYPOINT);
                    if (GetIsObjectValid(oWaypoint))
                    {
                         AssignCommand(oPC, ClearAllActions());
                         AssignCommand(oPC, ActionJumpToLocation(GetLocation(oWaypoint)));
                         SendMessageToAllDMs(GetName(oPC)+" was sent to jail for attempting to steal from a player's bank chest");
                         DeleteLocalInt(oPC, "WARNED");
                    }
                    else
                    {
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
                        SendMessageToAllDMs(GetName(oPC)+" was killed for attempting to steal from a player's bank chest");
                        DeleteLocalInt(oPC, "WARNED");
                    }
                }
                else
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
                    SendMessageToAllDMs(GetName(oPC)+" was killed for attempting to steal from a player's bank chest");
                    DeleteLocalInt(oPC, "WARNED");
                }
            }
        }
    }
}
