//::  ar_grapple_death
//::  Called when a grapple iron/chain is destroyed.

#include "ar_sys_ship"

void main()
{
    string sTag  = GetLocalString(OBJECT_SELF, "AR_SHP_PARENT");
    object oShip = GetArea(OBJECT_SELF);
    object oAttacker = GetObjectByTag( sTag );

    AlertPlayersOnShip(oShip, "Grappling irons removed!  The " + GetShipName(oShip) + " is breaking free!");
    AlertPlayersOnShip(oAttacker, "Grappling irons destroyed!  The " + GetShipName(oShip) + " is breaking free!");

    //::  Remove grappling iron (also removes the rowboat and ladder) after 30 seconds
    object oNavi = GetNearestObjectByTag("AR_NAVIGATOR");
    AssignCommand(oNavi, DelayCommand(30.0, ar_AddRemoveGrappleIron(oAttacker, TRUE)));
}
