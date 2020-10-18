//::///////////////////////////////////////////////
//:: Chat Command: Stream
//:: chat_stream
//:://////////////////////////////////////////////
/*
    Opens the summon stream menu, which allows
    the PC to configure summoned creature types.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: December 26, 2016
//:://////////////////////////////////////////////

#include "inc_chatutils"
#include "inc_common"
#include "inc_examine"
#include "inc_string"
#include "inc_sumstream"

const string HELP_1 = "Use this command to open the summon stream menu, which allows you to choose the types of creatures you would like to summon. You may activate a stream from the console directly by entering the stream code as a command, which is displayed next to each stream in the menu (e.g. for a stream listed as 'Fire (-fir)', typing '-fir' would activate the stream).\n\n";
const string HELP_2 = "Note that creatures distant from your own alignment may turn on you. Alignments colored yellow indicate a 10% chance of attacking you, orange a 20% chance of attacking you, and red a 30% chance of attacking you.\n\n";
const string HELP_3 = "Protection from Alignment, Magic Circle Against Alignment, and Aura vs Alignment will reduce these chances by 10%, 20%, and 30% respectively, provided you have warded against the alignment of the summon you intend to conjure.";

void main()
{
    chatVerifyCommand(OBJECT_SELF);

    string sParams = chatGetParams(OBJECT_SELF);
    string sStreamType;
    string sStreamElement;

    if(sParams == "?")
    {
        DisplayTextInExamineWindow(chatCommandTitle("-stream"), HELP_1 + HELP_2 + HELP_3);
        return;
    }
    if(sParams == "")
    {
        ClearAllActions();
        ActionStartConversation(OBJECT_SELF, "sum_streamselect", TRUE, FALSE);
        return;
    }

    sStreamType = GetStringLowerCase(GetStringLeft(sParams, 1));
    sStreamElement = GetStringLowerCase(GetSubString(sParams, FindNthSubString(sParams, " ", 0, 1) + 1, 3));

    if(sStreamType == "d")
    {
        // Dragon
        if(sStreamElement == "def")
        {
            // Default
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_DRAGON, STREAM_DRAGON_DEFAULT);
            return;
        }
        else if(sStreamElement == "sil")
        {
            // Silver
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_DRAGON, STREAM_DRAGON_SILVER);
            return;
        }
        else if(sStreamElement == "pri")
        {
            // Prismatic
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_DRAGON, STREAM_DRAGON_PRISMATIC);
            return;
        }
        else if(sStreamElement == "red")
        {
            // Red
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_DRAGON, STREAM_DRAGON_RED);
            return;
        }
        else if(sStreamElement == "dra")
        {
            // Dracolich
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_DRAGON, STREAM_DRAGON_UNDEAD);
            return;
        }
        else if(sStreamElement == "gol")
        {
            // Gold Dragon
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_DRAGON, STREAM_DRAGON_GOLD);
            return;
        }
        else if(sStreamElement == "sha")
        {
            // Shadow Dragon
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_DRAGON, STREAM_DRAGON_SHADOW);
            return;
        }
    }
    else if(sStreamType == "e")
    {
        // Elemental
        if(sStreamElement == "def")
        {
            // Default
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_ELEMENTAL, STREAM_ELEMENTAL_DEFAULT);
            return;
        }
        else if(sStreamElement == "air")
        {
            // Air
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_ELEMENTAL, STREAM_ELEMENTAL_AIR);
            return;
        }
        else if(sStreamElement == "ear")
        {
            // Earth
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_ELEMENTAL, STREAM_ELEMENTAL_EARTH);
            return;
        }
        else if(sStreamElement == "fir")
        {
            // Fire
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_ELEMENTAL, STREAM_ELEMENTAL_FIRE);
            return;
        }
        else if(sStreamElement == "wat")
        {
            // Water
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_ELEMENTAL, STREAM_ELEMENTAL_WATER);
            return;
        }
    }
    else if(sStreamType == "o")
    {
        // Planar
        if(sStreamElement == "def")
        {
            // Default
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_PLANAR, STREAM_PLANAR_DEFAULT);
            return;
        }
        else if(sStreamElement == "cel")
        {
            // Celestial
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_PLANAR, STREAM_PLANAR_CELESTIAL);
            return;
        }
        else if(sStreamElement == "sla")
        {
            // Slaad
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_PLANAR, STREAM_PLANAR_SLAAD);
            return;
        }
        else if(sStreamElement == "dev")
        {
            // Devil
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_PLANAR, STREAM_PLANAR_DEVIL);
            return;
        }
        else if(sStreamElement == "yug")
        {
            // Yugoloth
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_PLANAR, STREAM_PLANAR_YUGOLOTH);
            return;
        }
        else if(sStreamElement == "dem")
        {
            // Demon
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_PLANAR, STREAM_PLANAR_DEMON);
            return;
        }
    }
    else if(sStreamType == "u")
    {
        // Undead
        if(sStreamElement == "def" || sStreamElement == "mum" || sStreamElement == "zom")
        {
            // Zombie
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_UNDEAD, STREAM_UNDEAD_ZOMBIE);
            return;
        }
        else if (sStreamElement == "vam")
        {
            // Ghoul
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_UNDEAD, STREAM_UNDEAD_GHOUL);
            return;
        }
		else if (sStreamElement == "gho")
		{
		    // Ghost
            SetActiveSummonStream(OBJECT_SELF, STREAM_TYPE_UNDEAD, STREAM_UNDEAD_GHOST);
            return;
		}
    }
    SendMessageToPC(OBJECT_SELF, "Stream type either invalid or unavailable. Type '-stream ?' for help, or '-stream' for a list of available streams.");
}
