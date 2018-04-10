//::///////////////////////////////////////////////
//:: BODY TAILOR: Widget
//::                    item activation
//:://////////////////////////////////////////////
/*
   this makes the targeted NPC start the body tailor
   conversation, so you can change its wings, tail,
   head, tattoos, eyes, phenotype, etc etc etc.

   body tailor must be installed (the conversation and scripts, at least)
   this script must be called from your modules onActivateItem script.
   this uses stale kvernes method.
*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//:://////////////////////////////////////////////



void main()
{
    object   oPC   = OBJECT_SELF;
    object   oTarget   = GetLocalObject(oPC,"IT_ACT_TARGET");

    AssignCommand(oPC, ActionStartConversation(oTarget, "bodytailor", TRUE, FALSE));

}
