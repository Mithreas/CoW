#include "fb_inc_chatutils"
#include "gs_inc_pc"
#include "inc_examine"

const string HELP = "DM command: Displays the Roleplay Ratings of every player currently online. Players with a Mark of Destiny have (Destiny) added to their name, players with a mark of despair have (Despair) added to their name.";

void main()
{
  object oSpeaker = OBJECT_SELF;

  // Command not valid
  if (!GetIsDM(oSpeaker)) return;

  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-rp_ratings", HELP);
  }
  else
  {
    string sMessage = " PC name (player name): Current RP rating\n";
    int nRating;
    int nIsDM;
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC))
    {
      if (!GetIsDM(oPC))
      {
        nIsDM = FALSE;
        nRating = gsPCGetRolePlay(oPC);
        switch (nRating)
        {
          case 0:
            sMessage += "  <cþ  >";
            break;
          case 10:
            sMessage += "  <cþ þ>";
            break;
          case 20:
            sMessage += "  <c +?>";
            break;
          case 30:
            sMessage += "  <c þþ>";
            break;
          case 40:
            sMessage += "  <c þ >";
            break;
          default:
            sMessage += "  <cþþþ>";
            break;
        }

        sMessage += GetName(oPC) + " (" + GetPCPlayerName(oPC) + "): " +
                                                IntToString(nRating);

        if (GetIsObjectValid(GetItemPossessedBy(oPC, "mi_mark_despair")))
        {
          sMessage += " <cþ  >(Despair)</c>";
        }

        if (GetIsObjectValid(GetItemPossessedBy(oPC, "mi_mark_destiny")))
        {
          sMessage += " <c þ >(Destiny)</c>";
        }
      }
      else
      {
        nIsDM = TRUE;
      }

      oPC = GetNextPC();
      if (GetIsObjectValid(oPC) && !nIsDM) sMessage += "\n";
    }

    SendMessageToPC(oSpeaker, sMessage);
  }

  chatVerifyCommand(oSpeaker);
}
