#include "__server_config"
#include "inc_chatutils"
#include "gs_inc_encounter"
#include "gs_inc_subrace"
#include "inc_class"
#include "inc_pop"
#include "inc_examine"

const string HELP = "Forest Gnomes, Wild Dwarves, Wild & Wood Elves, Rangers and Harper Scouts Scouts can use the -track command to check the area for creatures. These classes can learn something of what is likely to spawn in the current area.";

void main()
{
  // Command not valid
  if (!ALLOW_TRACKING) return;

  object oSpeaker = OBJECT_SELF;
  chatVerifyCommand(oSpeaker);

  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-track", HELP);
  }
  else
  {
    int nSubRace     = gsSUGetSubRaceByName(GetSubRace(oSpeaker));
    int nHarper = !GetLocalInt(gsPCGetCreatureHide(oSpeaker), VAR_HARPER) ?
                     GetLevelByClass(CLASS_TYPE_HARPER, oSpeaker) : 0;

    int nLevel = GetLevelByClass(CLASS_TYPE_RANGER, oSpeaker) +
                 nHarper +
                 GetLocalInt(gsPCGetCreatureHide(oSpeaker), "FL_BONUS_RGR_LEVELS") +
                 (GetLocalInt(gsPCGetCreatureHide(oSpeaker), "GVD_MAJORAWARD_TRACK") * 30);

    if (GetIsDM(oSpeaker)) nLevel = 40;

    if (nSubRace == GS_SU_GNOME_FOREST || nSubRace == GS_SU_DWARF_WILD || nSubRace == GS_SU_ELF_WILD || nSubRace == GS_SU_ELF_WOOD) nLevel = GetHitDice(oSpeaker);

    if (!nLevel) SendMessageToPC(oSpeaker, "<cþ  >Only Forest Gnomes, Wild Dwarves, Wild & Wood Elves, Rangers and Harper Scouts can track.");
    else
    {
      nLevel = nLevel / 3;
      int nSlot;
      int nCount = 0;
      string sName;
      for (nSlot = 1; nSlot <= GS_EN_LIMIT_SLOT; nSlot ++) // Note starts at 1.
      {
        sName = gsENGetCreatureName(nSlot, GetArea(oSpeaker));

        if (sName == "")
        {
          // Skip this entry.  A creature was removed from the spawns.
        }
        else
        {
          SendMessageToPC(oSpeaker, "<c þ >You find the tracks of a " + sName);
          nCount++;

          if (nCount >= nLevel) break;
        }
      }

      if (!nCount)
      {
          // No creatures in this area.
          SendMessageToPC(oSpeaker, "<cþ£ >You can find no tracks here.");
          return;
      }

      // Population tie-in.
      string sPop = GetLocalString(GetArea(oSpeaker), VAR_POP);
      int nPopulation = 0;
      int nRate = 0;

      if (sPop != "")
      {
        nPopulation = miPOGetPopulation(sPop);
        nRate = miPOGetPopulationRate(sPop);

        if (GetIsDM(oSpeaker))
        {
          // Tell DMs where the population is based.
          object oSourceArea = GetLocalObject(GetModule(), sPop);
          SendMessageToPC(oSpeaker, "This population spreads from " + GetName(oSourceArea) + ".");
        }
      }

      // Present information whether or not the population is spreading or not.
      if (nPopulation > (nRate * 2) && nLevel >= 3) // 9+ ranger/harper levels needed
      {
        SendMessageToPC(oSpeaker, "<cþ  >The population here is out of control!</c>");
      }
      else if (nPopulation > nRate)
      {
        SendMessageToPC(oSpeaker, "<cþ££>The population here is spreading.</c>");
      }
      else
      {
        SendMessageToPC(oSpeaker, "<c þ >The population here is in balance.</c>");
      }
    }
  }
}
