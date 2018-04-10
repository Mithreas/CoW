#include "fb_inc_chatutils"
#include "inc_examine"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"

string HELP = "DM command: Forces your current area to stay active (as if there was a player in it), or to notify you when a character enters it with the parameter <cþôh>notify</c>. "+
                    "It is imperative that you disable <cþôh>forceactive</c> when you are done with your quest, and courteous to disable <cþôh>notify</c>. This tool is predominantly designed "+
                    "to maintain placeables in an area and prevent the area from resetting when you are gone and to alert you when players walk into a prepared area. This includes doors, locks, "+
                    "and chests, raising dead NPCs, etc. Passing the parameter 'list' will display which areas are toggled. Usage: <cþôh>-force_active</c>, <cþôh>-force_active list</c>, <cþôh>-force_active notify</c>";

void main()
{
  object oSpeaker = OBJECT_SELF;

  // Command not valid
  if (!GetIsDM(oSpeaker)) return;

  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-force_active", HELP);
  }
  else if (chatGetParams(oSpeaker) == "list")
  {
    object oArea = GetFirstArea();
    string sMessage = " <cVs·>Areas currently in Force Active Mode: ";
    while (oArea != OBJECT_INVALID)
    {
        if (GetLocalInt(oArea, "DM_FORCE_ACTIVE") == 1)
        {
            sMessage += " <cVs·>" + GetName(oArea) + " is in Force Active mode. \n";
        }
        oArea = GetNextArea();
    }
    SendMessageToPC(oSpeaker, sMessage);
  }

  else if (chatGetParams(oSpeaker) == "notify")
  {
    int bForceActiveNotify = GetLocalInt(GetArea(oSpeaker), "DM_NOTIFY");

    if (bForceActiveNotify)
    {
      DeleteLocalInt(GetArea(oSpeaker), "DM_NOTIFY");
      SendMessageToPC(oSpeaker, " <cVs·>" + GetName(GetArea(oSpeaker)) + " is no longer in Notify mode.");
      SendMessageToAllDMs(" <cVs·>" + "Notify mode disabled in area: "+ GetName(GetArea(oSpeaker)));
    }
    else
    {
      SetLocalInt(GetArea(oSpeaker), "DM_NOTIFY", 1);
      SendMessageToPC(oSpeaker, " <cVs·>" + GetName(GetArea(oSpeaker)) + " is now in Notify mode!");
      SendMessageToAllDMs(" <cVs·>" + "Notify mode enabled in area: "+ GetName(GetArea(oSpeaker)));
    }
  }

  else
  {
    int bForceActive = GetLocalInt(GetArea(oSpeaker), "DM_FORCE_ACTIVE");

    if (bForceActive)
    {
      DeleteLocalInt(GetArea(oSpeaker), "DM_FORCE_ACTIVE");
      SendMessageToPC(oSpeaker, " <cVs·>" + GetName(GetArea(oSpeaker)) + " is no longer in Force Active mode.");
      SendMessageToAllDMs(" <cVs·>" + "Force Active mode disabled in area: "+ GetName(GetArea(oSpeaker)));
    }
    else
    {
      SetLocalInt(GetArea(oSpeaker), "DM_FORCE_ACTIVE", 1);
      SendMessageToPC(oSpeaker, " <cVs·>" + GetName(GetArea(oSpeaker)) + " is now in Force Active mode!");
      SendMessageToAllDMs(" <cVs·>" + "Force Active mode enabled in area: "+ GetName(GetArea(oSpeaker)));
    }
  }

  chatVerifyCommand(oSpeaker);
}
