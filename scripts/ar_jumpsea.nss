//::  Launches a player into the sea, either the Jump Overboard option on Ships
//::  or the Pearl Diver at Rayne's Landing.

#include "ar_sys_ship"

void main()
{
    object oPC = GetPCSpeaker();

    if (!GetIsPC(oPC)) return;

    object oWP      = GetObjectByTag("AR_WP_UnderSea");
    object oArea    = GetArea(OBJECT_SELF);
    string sText    = "*dives into the water*";

    if (GetTag(oArea) != "AR_A_RAYNE")
    {
        sText           = "*jumps overboard*";
        int nID         = GetLocalInt(GetArea(OBJECT_SELF), AR_ID);
        string sShipTag = "AR_SHIP_" + IntToString(nID);
        SetLocalInt(oPC, "AR_JUMP_SHIP", TRUE);
        SetLocalString(oPC, "AR_JUMP_SHIP_NAME", sShipTag);
    }

    AssignCommand(oPC, SpeakString(sText));
    AssignCommand(oPC, JumpToObject(oWP));
}
