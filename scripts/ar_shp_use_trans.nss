void main()
{
    object oUsed = OBJECT_SELF;
    object oPC   = GetLastUsedBy();
    object oWP;

    if ( !GetIsPC(oPC) ) return;

    string sTag = GetTag(oUsed);

    //::  Peny Rose Transitions
    if      (sTag == "AR_SHP_OBJ_PENNY")    oWP = GetObjectByTag("AR_SHP_ROPE_PENNY");
    else if (sTag == "AR_SHP_ROPE_PENNY")   oWP = GetObjectByTag("AR_SHP_OBJ_PENNY");
    //::  Sea Leopard Transitions
    else if (sTag == "AR_SHP_OBJ_LEO")      oWP = GetObjectByTag("AR_SHP_LADDER_LEO");
    else if (sTag == "AR_SHP_LADDER_LEO")   oWP = GetObjectByTag("AR_SHP_OBJ_LEO");
    else if (sTag == "AR_SHP_OBJ2_LEO")     oWP = GetObjectByTag("AR_SHP_LADDER2_LEO");
    else if (sTag == "AR_SHP_LADDER2_LEO")  oWP = GetObjectByTag("AR_SHP_OBJ2_LEO");
    //::  The Troubadour Transitions
    else if (sTag == "AR_SHP_OBJ_TROUB")    oWP = GetObjectByTag("AR_SHP_DOOR_TROUB");
    //::  The Timberfleet Transitions
    else if (sTag == "AR_SHP_OBJ_TIMB")     oWP = GetObjectByTag("AR_SHP_WP_TIMB");
    else if (sTag == "AR_SHP_OBJ2_TIMB")    oWP = GetObjectByTag("AR_SHP_WP2_TIMB");
    else if (sTag == "AR_SHP_OBJ3_TIMB")    oWP = GetObjectByTag("AR_SHP_LADDER_TIMB");
    else if (sTag == "AR_SHP_LADDER_TIMB")  oWP = GetObjectByTag("AR_SHP_OBJ3_TIMB");
    //::  The Warship Transitions
    else if (sTag == "AR_SHP_OBJ_WAR")      oWP = GetObjectByTag("AR_SHP_LADDER_WAR");
    else if (sTag == "AR_SHP_LADDER_WAR")   oWP = GetObjectByTag("AR_SHP_OBJ_WAR");
    //::  Liberator Transitions
    else if (sTag == "AR_SHP_OBJ_LIB")      oWP = GetObjectByTag("AR_SHP_LADDER_LIB");
    else if (sTag == "AR_SHP_LADDER_LIB")   oWP = GetObjectByTag("AR_SHP_OBJ_LIB");


    //::  Amnish (NPC) Transitions
    else if (sTag == "AR_SHP_ROPE_AMN")     oWP = GetObjectByTag("AR_SHP_OBJ_AMN");
    else if (sTag == "AR_SHP_OBJ_AMN")      oWP = GetObjectByTag("AR_SHP_ROPE_AMN");
    else if (sTag == "AR_SHP_LADDER_AMN")   oWP = GetObjectByTag("AR_SHP_OBJ2_AMN");
    else if (sTag == "AR_SHP_OBJ2_AMN")     oWP = GetObjectByTag("AR_SHP_LADDER_AMN");

    //::  Cordorian (NPC) Transitions
    else if (sTag == "AR_SHP_OBJ_CORD")     oWP = GetObjectByTag("AR_SHP_LADDER_CORD");
    else if (sTag == "AR_SHP_LADDER_CORD")  oWP = GetObjectByTag("AR_SHP_OBJ_CORD");
    else if (sTag == "AR_SHP_OBJ2_CORD")    oWP = GetObjectByTag("AR_SHP_LADDER2_CORD");
    else if (sTag == "AR_SHP_LADDER2_CORD") oWP = GetObjectByTag("AR_SHP_OBJ2_CORD");

    //::  Ghost Ship (Other) Transitions
    else if (sTag == "AR_SHP_OBJ_GS1")      oWP = GetObjectByTag("AR_SHP_LADDER_GS1");
    else if (sTag == "AR_SHP_OBJ_GS2")      oWP = GetObjectByTag("AR_SHP_LADDER_GS2");
    else if (sTag == "AR_SHP_LADDER_GS1")   oWP = GetObjectByTag("AR_SHP_OBJ_GS1");
    else if (sTag == "AR_SHP_LADDER_GS2")   oWP = GetObjectByTag("AR_SHP_OBJ_GS2");


    AssignCommand(oPC, JumpToObject(oWP));
}
