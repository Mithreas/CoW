#include "fb_inc_chatutils"
#include "gs_inc_fixture"
#include "inc_examine"

const string HELP = "<cþôh>-pickup_fixture </c><cþ£ >[Text]</c>\nPicks up the nearest fixture. If <cþ£ >[Text]</c> is given, the nearest fixture with the name <cþ£ >[Text]</c> (case insensitive) will be picked up instead.";

void main()
{
  object oSpeaker = OBJECT_SELF;

  string sSearch = chatGetParams(oSpeaker);

  if (sSearch == "?")
  {
    DisplayTextInExamineWindow("-pickup_fixture", HELP);
  }
  else
  {
    sSearch = GetStringLowerCase(sSearch);
    int bDM = GetIsDM(oSpeaker);

    int nNth = 0;
    while (TRUE)
    {
      object oPlaceable = GetNearestObject(OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nNth++);
      if (!GetIsObjectValid(oPlaceable) ||
         GetDistanceBetween(oPlaceable, oSpeaker) > (bDM ? 35.0 : 4.0)) {
        SendMessageToPC(oSpeaker, "-pickup_fixture: no matching fixture found nearby. You may need to get closer.");
        break;
      }
      if (GetStringLeft(GetTag(oPlaceable), 6) != "GS_FX_")
          continue;
      if (sSearch != "" && FindSubString(GetStringLowerCase(GetName(oPlaceable)), sSearch) < 0)
          continue;

      object oFixture = gsFXPickupFixture(oSpeaker, oPlaceable);
      if (GetIsObjectValid(oFixture))
      {
        vector vDirection = GetPosition(oPlaceable);
        AssignCommand(oSpeaker, SetFacingPoint(vDirection));
        AssignCommand(oSpeaker, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.0));
        Log(FIXTURES, "Fixture " + GetName(oPlaceable) + " in area " +
          GetName(GetArea(oPlaceable)) + " was taken by " + GetName(oSpeaker));
        DestroyObject(oPlaceable);
        gsFXWarn(oSpeaker, oFixture);
      }
      break;
    }
  }

  chatVerifyCommand(oSpeaker);
}
