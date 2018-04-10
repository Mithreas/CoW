//::///////////////////////////////////////////////
//:: Executed Script: Create Aura
//:: exe_createaura
//:://////////////////////////////////////////////
/*
    Creates an aura on the caller, with parameters
    based on variables.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 23, 2016
//:://////////////////////////////////////////////

void main()
{
    int nAoE = GetLocalInt(OBJECT_SELF, "AURA_ID");
    string sEnter = GetLocalString(OBJECT_SELF, "AURA_ON_ENTER");
    string sHeartbeat = GetLocalString(OBJECT_SELF, "AURA_ON_HEARTBEAT");
    string sExit = GetLocalString(OBJECT_SELF, "AURA_ON_EXIT");

    if(sEnter == "") sEnter = "****";
    if(sHeartbeat == "") sHeartbeat = "****";
    if(sExit == "") sExit = "ext_removeeffect";

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAreaOfEffect(nAoE, sEnter, sHeartbeat, sExit)), OBJECT_SELF);
}
