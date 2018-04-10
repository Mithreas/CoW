// Standard OnConversation script (x2_def_onconv) with added functions.
// Called by the receptionist in 'The Trawlers - Main'
// Calls for script to keep receptionist seated
// proceeds to have receptionist speak receptional SpeakStrings
// // see ls_trawlers_main for details

//::///////////////////////////////////////////////
//:: Name x2_def_onconv
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default On Conversation script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////

void main()
{
    ExecuteScript("nw_c2_default4", OBJECT_SELF);
    ExecuteScript("ls_trawlers_001", OBJECT_SELF);
    AssignCommand(OBJECT_SELF, SpeakString("Please be seated in either dining rooms..."));
    DelayCommand(3.0, AssignCommand(OBJECT_SELF, SpeakString("... Meals can be purchased at the banquette tables.")));
}
