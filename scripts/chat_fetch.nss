#include "inc_chatutils"
#include "inc_examine"
#include "inc_timelock"

const string HELP = "-fetch. Pulls all familiars, animal companions, dominated creatures, henchmen, and summons to your side. Please respect the honour system with this tool and don't be a cheeseball.";

void main()
{
    string params = chatGetParams(OBJECT_SELF);

    if (params == "?")
    {
        DisplayTextInExamineWindow("-fetch", HELP);
    }
    else
    {
        // Cooldown check.
        if(GetIsTimelocked(OBJECT_SELF, "Fetch Companion"))
        {
            TimelockErrorMessage(OBJECT_SELF, "Fetch Companion");
            chatVerifyCommand(OBJECT_SELF);
            return;
        }
        int i, j;
        object oAssociate;
        object oSpeaker = OBJECT_SELF;
        SendMessageToPC(oSpeaker, "Fetching for: " + GetName(oSpeaker));
        // Fetch all Associates of oSpeaker
        for(i = ASSOCIATE_TYPE_HENCHMAN; i <= ASSOCIATE_TYPE_DOMINATED; i++)
        {
            while(GetIsObjectValid(oAssociate = GetAssociate(i, oSpeaker, ++j)))
            {
                SendMessageToPC(oSpeaker, "Found: "+ GetName(oAssociate));
                AssignCommand(oAssociate, ClearAllActions());
                AssignCommand(oAssociate, JumpToLocation(GetLocation(oSpeaker)));
                if(i == ASSOCIATE_TYPE_DOMINATED) break;
            }
            j = 0;
        }
    // Set Cooldown to 2 minutes.  Refresh reminder at 1m, final reminder at 30 seconds.
    SetTimelock(OBJECT_SELF, 120, "Fetch Companion", 60, 30);
    }
    chatVerifyCommand(OBJECT_SELF);
}

