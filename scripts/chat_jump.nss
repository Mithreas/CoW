#include "inc_chatutils"
#include "inc_xfer"
#include "inc_examine"

const string HELP = "DM Command: Travel instantly to the tell target. This command must be sent as a tell to a player or DM. Adding ' to me' on the end makes the target PC jump to you instead of you to them. Adding the name or number of a server (1 = Surface, 2 = Underdark, 3 = Cordor) makes you jump to that server (in which case it need not be a tell).";

string WorkOutServer(string sServer)
{
  sServer = GetStringLowerCase(sServer);
  if (sServer == "surface" || sServer == "5123")        					   sServer = "1";
  else if (sServer == "underdark" || sServer == "cordor" || sServer == "5122") sServer = "2";
  else if (sServer == "distshores" || sServer == "distantshores" || sServer == "5121") sServer = "8";

  if (sServer == "1" || sServer == "2" || sServer == "3" || sServer == "8") return sServer;
  return "";
}

void main()
{
  object oSpeaker = OBJECT_SELF;

  if (GetPCPlayerName(oSpeaker) == "Mithreas" && !GetIsDM(oSpeaker))
  {
    AssignCommand(oSpeaker, JumpToObject(GetObjectByTag("GS_TARGET_START")));
    chatVerifyCommand(oSpeaker);	
  }

  // Command not valid
  if (!GetIsDM(oSpeaker)) return;

  string sParams = chatGetParams(oSpeaker);

  if (sParams == "?")
  {
    DisplayTextInExamineWindow("-jump", HELP);
  }
  else
  {
    object oTarget = chatGetTarget(oSpeaker);
    string sServer = WorkOutServer(sParams);
	if (sServer != "")
    {
	  // Portal to server
      miXFDoPortal(oSpeaker, sServer);
    }
    else if (sParams == "tome" || sParams == "to me")
    {
      if (GetIsDM(oTarget))
      {
        SendMessageToPC(oSpeaker, "Don't be bossy! They'll jump to you if they want to.");
      }
      else
      {
		// Jump target to DM
        AssignCommand(oTarget, JumpToObject(oSpeaker));
      }
    }
	else if (sParams != "")
	{
		string sName = "";
		int bToMe = 0;
		if (GetStringRight(sParams, 4) == "tome")
		{
			sName = GetSubString(sParams, 0, GetStringLength(sParams) - 5);
			bToMe = 1;
		}
		else if (GetStringRight(sParams, 5) == "to me")
		{
			sName = GetSubString(sParams, 0, GetStringLength(sParams) - 6);
			bToMe = 1;
		}
		else
		{
			sName = sParams;
		}
		SQLExecStatement("SELECT pcid,server,visiblename FROM mixf_currentplayers AS a INNER JOIN gs_pc_data AS b " +
						 "ON a.pcid = b.id WHERE b.name LIKE ?", sName + "%");		
		string sPlayer = "";
		string sServer = "";
		string sVisibleName = "";
		if (SQLFetch())
		{
			// Found
			sPlayer = SQLGetData(1);
			sServer = SQLGetData(2);
			sVisibleName = SQLGetData(3);
		}
		else
		{
			SQLExecStatement("SELECT pcid,server,visiblename FROM mixf_currentplayers WHERE visiblename LIKE ?", sName + "%");
			if (SQLFetch())
			{
				// Found
				sPlayer = SQLGetData(1);
				sServer = SQLGetData(2);
				sVisibleName = SQLGetData(3);
			}
		}			
		if (sPlayer == "")
		{
			SendMessageToPC(oSpeaker, "No player found by the given arguments.");
		}
		else
		{
			oTarget = gsPCGetPlayerByID(sPlayer);
			if (miXFGetCurrentServer() != sServer)
			{
				SendMessageToPC(oSpeaker, "Target is not on your server");
			}
			else
			{
				if (bToMe)
				{
					AssignCommand(oTarget, JumpToObject(oSpeaker));				
				}
				else
				{
					AssignCommand(oSpeaker, JumpToObject(oTarget));						
				}				
			}					
		}
	}
    else
    {
		// Jump DM to target
      AssignCommand(oSpeaker, JumpToObject(oTarget));
    }
  }

  chatVerifyCommand(oSpeaker);
}
