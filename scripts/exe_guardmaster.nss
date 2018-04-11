//::///////////////////////////////////////////////
//:: Executed Script: Guard Master
//:: exe_guardmaster
//:://////////////////////////////////////////////
/*
    Instructs the caller to -guard its master.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 13, 2016
//:://////////////////////////////////////////////

#include "gs_inc_combat"

void main()
{
    SetAssociateGuardian(GetMaster(OBJECT_SELF), OBJECT_SELF);
}
