#include "gs_inc_common"
#include "gs_inc_placeable"

const int DUR_DAY           = 864000;   //::  24 RL Hours
const string ORE_EXPIRE     = "ORE_EXPIRE";
const string ORE_TEMPLATE   = "ORE_TEMPLATE";

const string LOG_MINE  = "MINE";   //  For Tracing

//void main(){}


//::  Returns the Mining Yield Chance by an Ore's sResRef.
int GetMiningChanceByOre(string sResRef);

//::  Returns the Ore's proper name by an Ore's sResRef.
string GetNameByOre(string sResRef);

//::  Randomizes a High-End Ore:
//::  Mithril       -   gs_item921
//::  Arjale        -   gs_item1000
//::  Adamantine    -   gs_item462
string GetRandomHighOre(int bIsGrandiose);

//::  Randomizes a Medium-End Ore:
//::  Silver        -   gs_item460
//::  Iron          -   gs_item452
//::  Gold          -   gs_item461
//::  Zinc          -   gs_item497
string GetRandomMediumOre();

//::  Randomizes a Low-End Ore:
//::  Coal          -   gs_item451
//::  Tin           -   gs_item496
//::  Lead          -   gs_item459
//::  Copper        -   gs_item457
string GetRandomLowOre();

//::  Generates a new Ore Resource & Expiration Timestamp for oResource and
//::  stores the new ResRef and Timestamp persistently for the placeable.
//::  Will return the ResRef for the newly generated resource.
string GenerateNewResource(object oResource);

//::  Returns the Ore Resource ResRef to spawn for the Ore Vein oResource when
//::  being mined.  This function takes Expiration into account and will call
//::  GenerateNewResource() to generate a new Ore Resource if needed.
//::  If there are no Persistent Variables stored for oResource (First time mined)
//::  it will generate and setup itself with GenerateNewResource().
string GetResourceTemplate(object oResource, int bLog = FALSE);



int GetMiningChanceByOre(string sResRef) {
    //::  Coal
    if (sResRef == "gs_item451")            return 90;
    //::  Zinc
    else if (sResRef == "gs_item497")       return 60;
    //::  Tin
    else if (sResRef ==  "gs_item496")      return 60;
    //::  Lead
    else if (sResRef ==  "gs_item459")      return 80;
    //::  Copper
    else if (sResRef ==  "gs_item457")      return 50;
    //::  Silver
    else if (sResRef ==  "gs_item460")      return 30;
    //::  Iron
    else if (sResRef ==  "gs_item452")      return 70;
    //::  Gold
    else if (sResRef ==  "gs_item461")      return 20;
    //::  Mithril
    else if (sResRef ==  "gs_item921")      return 15;
    //::  Arjale
    else if (sResRef ==  "gs_item1000")     return 30;
    //::  Adamantine
    else if (sResRef ==  "gs_item462")      return 10;

    return 50;
}

string GetNameByOre(string sResRef) {
    if      (sResRef == "gs_item451")       return "Coal";
    else if (sResRef == "gs_item497")       return "Zinc";
    else if (sResRef ==  "gs_item496")      return "Tin";
    else if (sResRef ==  "gs_item459")      return "Lead";
    else if (sResRef ==  "gs_item457")      return "Copper";
    else if (sResRef ==  "gs_item460")      return "Silver";
    else if (sResRef ==  "gs_item452")      return "Iron";
    else if (sResRef ==  "gs_item461")      return "Gold";
    else if (sResRef ==  "gs_item921")      return "Mithril";
    else if (sResRef ==  "gs_item1000")     return "Arjale";
    else if (sResRef ==  "gs_item462")      return "Adamantine";

    return "";
}

string GetRandomHighOre(int bIsGrandiose) {
    int n100 = d100();

    if ( bIsGrandiose ) n100 += 25;

    //::  Mithrill 45%
    if (n100 <= 45){
        return "gs_item921";    //::  Mithril
    }
    //::  Arjale 30%
    else if (n100 <= 75){
        return "gs_item1000";   //::  Arjale
    }
    //::  Adamantine 25% (Only for Grandiose)
    else {
        if ( !bIsGrandiose )    return "gs_item921";    //::  Mithril

        return "gs_item462";    //::  Adamantine
    }

    return "gs_item921";
}

string GetRandomMediumOre() {
    int n100 = d100();

    //::  Iron 40%
    if (n100 <= 40) {
        return "gs_item452";    //::  Iron
    }
    //::  Zinc 30%
    else if (n100 <= 70) {
        return "gs_item497";    //::  Zinc
    }
    //::  Silver or Gold 30%
    else {
        if ( d2() == 1 )    return "gs_item460";    //::  Silver
        else                return "gs_item461";    //::  Gold
    }

    return "gs_item452";
}

string GetRandomLowOre() {
    int n100 = d100();

    //::  Coal 30%
    if ( n100 <= 30 ) {
        return "gs_item451";    //::  Coal
    }
    //::  Iron 15%
    else if ( n100 <= 45 ) {
        return "gs_item452";    //::  Iron
    }
    //::  Tin or Lead 30%
    else if ( n100 <= 75 ) {
        if ( d2() == 1 )    return "gs_item496";    //::  Tin
        else                return "gs_item459";    //::  Lead
    }
    //::  Copper 25%
    else {
        return "gs_item457";    //::  Copper
    }

    return "gs_item451";
}

string GenerateNewResource(object oResource) {
    string sResRef = "";
    int nType = GetLocalInt(oResource, "TYPE");
    int nRoll = d100();
    string sOreType = "INVALID";   //::  For logging
    int nRandDuration = DUR_DAY * d3();

    //::  Low / Common          (8% Medium, 92% Low)
    if ( nType <= 0 ) {
        if ( nRoll <= 8 )       sResRef = GetRandomMediumOre();
        else                    sResRef = GetRandomLowOre();
        sOreType = "Common";
    }
    //::  Medium / Noble        (75% Medium, 25% Low)
    else if ( nType == 1 ) {
        if (nRoll <= 75)        sResRef = GetRandomMediumOre();
        else                    sResRef = GetRandomLowOre();
        sOreType = "Noble";
    }
    //::  High / Rich           (30% High, 70% Medium)
    else if ( nType == 2 ) {
       if ( nRoll <= 30 )       sResRef = GetRandomHighOre(FALSE);
       else                     sResRef = GetRandomMediumOre();
       sOreType = "Rich";
    }
    //::  Grandiose             (100% High)
    else {
        sResRef = GetRandomHighOre(TRUE);
        sOreType = "Grandiose";

        //::  Lower Duration for Adamantine
        if (sResRef == "gs_item462") {
            nRandDuration = DUR_DAY;
        }
    }

    //::  Store the Template & Timestamp expiration (Expires 2-4 Days)
    int nTimestamp = GetLocalInt(GetModule(), "GS_TIMESTAMP") + DUR_DAY + nRandDuration;
    gvd_SetPlaceableString(oResource, ORE_TEMPLATE, sResRef);
    gvd_SetPlaceableInt(oResource, ORE_EXPIRE, nTimestamp);

    sOreType = sOreType + " (" + GetNameByOre(sResRef) + ")";
    Log(LOG_MINE, "Generating " + sOreType + " ore in " + GetName(GetArea(oResource)) + ".");

    return sResRef;
}

string GetResourceTemplate(object oResource, int bLog = FALSE) {
    string sResRef  = GetLocalString(oResource, ORE_TEMPLATE);
    int nExpiration = GetLocalInt(oResource, ORE_EXPIRE);
    int nTimestamp  = GetLocalInt(GetModule(), "GS_TIMESTAMP");
    //::  Just assume anything above 5 days is a Epoch issue (Max duration is 4 days)
    int nEpochIssue = (nExpiration - nTimestamp) > (DUR_DAY*5);

    if ( bLog ) {
        int nRemain = nExpiration - nTimestamp;
        Log(LOG_MINE, "Load Ore Vein: " + GetNameByOre(sResRef) + " in " + GetName(GetArea(oResource)) + " | Expire: " + IntToString(nExpiration) + " | Module: " + IntToString(nTimestamp) + " | Remain: " + IntToString(nRemain) + ".");
    }

    //::  No Template currently on this resource.
    //::  Probably an initial spawn (First time damaged) and no value
    //::  has been set and can't be fetched from the DB.
    //::  Or the resource has expired so we generate a new one.
    if ( sResRef == "" || nTimestamp > nExpiration || nEpochIssue ) {
        sResRef = GenerateNewResource(oResource);
    }

    return sResRef;
}
