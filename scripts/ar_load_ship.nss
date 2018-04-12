#include "inc_quarter"
#include "ar_sys_ship"


void main()
{
    if ( GetLocalInt(OBJECT_SELF, "AR_DO_ONCE") )   return;
    SetLocalInt(OBJECT_SELF, "AR_DO_ONCE", TRUE);

    object oShip = GetArea(OBJECT_SELF);

    int bIsRentable         = GetLocalInt(OBJECT_SELF, "IsRentable");
    int nRentTimeout        = GetLocalInt(OBJECT_SELF, "RentTimeout");
    int nShipID             = GetLocalInt(OBJECT_SELF, "ShipId");

    string sName            = GetLocalString(OBJECT_SELF, "ShipName");
    string sDestination     = GetLocalString(OBJECT_SELF, "StartPort");
    string sLocation        = GetLocalString(OBJECT_SELF, "StartLocation");
    string sLocationWP      = sLocation + "_" + IntToString(nShipID);

    int bCanFish    = GetLocalInt(OBJECT_SELF, "CanFish");
    int bCanPirate  = GetLocalInt(OBJECT_SELF, "CanPirate");
    int bCanRayne   = GetLocalInt(OBJECT_SELF, "CanRayne");
    int bCanSearch  = GetLocalInt(OBJECT_SELF, "CanSearch");
    int nHide       = GetLocalInt(OBJECT_SELF, "Hide");

    //::  This is a rentable/timeout ship, setup a few stuff
    if (bIsRentable) {
        SetLocalInt(oShip, AR_RENTABLE, TRUE);
        SetLocalInt(oShip, AR_RENT_TIMEOUT, nRentTimeout);
        SetLocalInt(oShip, AR_RENT_TIMER, 0);
        //::  Rentable ships always lose ownership after resets
        gsQUAbandon(oShip);
    }

    //::  Store Homeport
    SetLocalString(oShip, AR_DESTINATION, sDestination);
    SetLocalString(oShip, AR_STORED_PORT, sDestination);

    //::  Store Location
    SetLocalString(oShip, AR_TRUE_DEST, sLocationWP);
    SetLocalString(oShip, AR_STORED_DEST, sLocation);

    //:: Store Abilities
    SetLocalInt(oShip, AR_CAN_FISH, bCanFish);
    SetLocalInt(oShip, AR_CAN_PIRATE, bCanPirate);
    SetLocalInt(oShip, AR_CAN_RAYNE, bCanRayne);
    SetLocalInt(oShip, AR_CAN_SEARCH, bCanSearch);
    SetLocalInt(oShip, AR_HIDE, nHide);

    //::  Ship Name & Status & ID
    SetLocalString(oShip, AR_NAME, sName);
    SetLocalString(oShip, AR_STATUS, "anchored off " + sDestination);
    SetLocalInt(oShip, AR_ID, nShipID);

    SetLocalString(oShip, "GS_CLASS", "AR_SHIPS");
    SetLocalInt(oShip, "GS_INSTANCE", nShipID);

    DestroyObject(OBJECT_SELF);
}
