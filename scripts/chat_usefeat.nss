#include "inc_chatutils"
#include "inc_examine"
void main()
{
    object oSpeaker = OBJECT_SELF;
    object oTarget = GetAttackTarget(oSpeaker);
    string params = chatGetParams(oSpeaker);

    if(params == "calledshot")
    {
        AssignCommand(oSpeaker, ActionUseFeat(FEAT_CALLED_SHOT, oTarget));
    }
    else if(params == "deatharrow")
    {
        AssignCommand(oSpeaker, ActionUseFeat(FEAT_PRESTIGE_ARROW_OF_DEATH, oTarget));
    }
    else if(params == "deathtouch")
    {
        AssignCommand(oSpeaker, ActionUseFeat(FEAT_DEATHLESS_MASTER_TOUCH, oTarget));
    }
    else if(params == "disarm")
    {
        AssignCommand(oSpeaker, ActionUseFeat(FEAT_DISARM, oTarget));
    }
    else if(params == "kidamage")
    {
        AssignCommand(oSpeaker, ActionUseFeat(FEAT_KI_DAMAGE, oTarget));
    }
    else if(params == "knockdown")
    {
        if(GetHasFeat(FEAT_IMPROVED_KNOCKDOWN, oSpeaker))
            AssignCommand(oSpeaker, ActionUseFeat(FEAT_IMPROVED_KNOCKDOWN, oTarget));
        else
            AssignCommand(oSpeaker, ActionUseFeat(FEAT_KNOCKDOWN, oTarget));
    }
    else if(params == "oathwrath")
    {
        AssignCommand(oSpeaker, ActionUseFeat(FEAT_PDK_WRATH, oTarget));
    }
    else if(params == "seekerarrow")
    {
        AssignCommand(oSpeaker, ActionUseFeat(FEAT_PRESTIGE_SEEKER_ARROW_1, oTarget));
    }
    else if(params == "smiteevil")
    {
        AssignCommand(oSpeaker, ActionUseFeat(FEAT_SMITE_EVIL, oTarget));
    }
    else if(params == "smitegood")
    {
        AssignCommand(oSpeaker, ActionUseFeat(FEAT_SMITE_GOOD, oTarget));
    }
    else if(params == "stunfist")
    {
        AssignCommand(oSpeaker, ActionUseFeat(FEAT_STUNNING_FIST, oTarget));
    }
    else if(params == "undeadgraft")
    {
        AssignCommand(oSpeaker, ActionUseFeat(FEAT_UNDEAD_GRAFT_1, oTarget));
    }
    else //on failure, print the help
    {
        DisplayTextInExamineWindow(
            chatCommandTitle("-usefeat") + " " + chatCommandParameter("[Type]"),

            "Queues a feat action on current target. All listed feats are alias of this command. Selectable feats:\n\n" +

            chatCommandParameter("calledshot") + "\n" +
            chatCommandParameter("deatharrow") + "\n" +
            chatCommandParameter("deathtouch") + "\n" +
            chatCommandParameter("disarm") + "\n" +
            chatCommandParameter("kidamage") + "\n" +
            chatCommandParameter("knockdown") + "\n" +
            chatCommandParameter("oathwrath") + "\n" +
            chatCommandParameter("seekerarrow") + "\n" +
            chatCommandParameter("smiteevil") + "\n" +
            chatCommandParameter("smitegood") + "\n" +
            chatCommandParameter("stunfist") + "\n" +
            chatCommandParameter("undeadgraft")

        );
    }
    chatVerifyCommand(oSpeaker);
}
