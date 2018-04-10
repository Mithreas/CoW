#include "fb_inc_chatutils"
#include "inc_examine"
#include "fb_inc_names"

const string HELP = "<cþôh>-guard </c><cþ£ >[Text]</c>\n Tells your character to try and intercept attacks on a character whose name starts with <cþ£ >[Text]</c>, or alternatively you can send this command as a tell to the target.  You must stay close to them for this to work!  Turn off guard mode by sending -guard to yourself as a Tell.";

void unhookRelationship(object guard, object ward)
{
    DeleteLocalObject(guard, "CURRENT_WARD");
    DeleteLocalObject(ward, "CURRENT_GUARD");
}

void informBrokenRelationship(object guard, object ward)
{
    FloatingTextStringOnCreature("You are no longer guarding " + fbNAGetGlobalDynamicName(ward) + "!", guard, FALSE);
    FloatingTextStringOnCreature(fbNAGetGlobalDynamicName(guard) + " is no longer guarding you!", ward, FALSE);
}

void hookRelationship(object guard, object ward)
{
    SetLocalObject(guard, "CURRENT_WARD", ward);
    SetLocalObject(ward, "CURRENT_GUARD", guard);
}

void informNewRelationship(object guard, object ward)
{
    FloatingTextStringOnCreature("You are now guarding " + fbNAGetGlobalDynamicName(ward) + "!", guard, FALSE);
    FloatingTextStringOnCreature(fbNAGetGlobalDynamicName(guard) + " is now guarding you!", ward, FALSE);
}

void RemoveGuardAndWard(object me)
{
    object myExistingGuard = GetLocalObject(me, "CURRENT_GUARD");
    object myExistingWard = GetLocalObject(me, "CURRENT_WARD");

    int iAmBeingGuarded = GetIsObjectValid(myExistingGuard);
    int iHaveAWard = GetIsObjectValid(myExistingWard);

    if (iAmBeingGuarded)
    {
        unhookRelationship(myExistingGuard, me);

        if (myExistingGuard != me)
        {
            informBrokenRelationship(myExistingGuard, me);
        }
    }
    else if (iHaveAWard)
    {
        unhookRelationship(me, myExistingWard);

        if (myExistingWard != me)
        {
            informBrokenRelationship(me, myExistingWard);
        }
    }
}
void main()
{
  object oSpeaker = OBJECT_SELF;
  string sParams = chatGetParams(oSpeaker);
  object oTarget = chatGetTarget(oSpeaker);

  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-guard", HELP);
  }
  else
  {
    if (sParams == "" && (!GetIsObjectValid(oTarget) || oTarget == oSpeaker))
    {
      SendMessageToPC(oSpeaker, "<cþ£ >You must specify a name. You only "+
       "need to type the first few letters, e.g. '-guard Joh' will match "+
       "a character with the name 'John Doe'. You may also send '-guard' as a " +
       "tell to guard that person.");

       RemoveGuardAndWard(oSpeaker);
    }
    else
    {
      if (GetAssociateType(oSpeaker) == ASSOCIATE_TYPE_FAMILIAR)
      {
        SendMessageToPC(oSpeaker, "Familiars are too small to guard anyone!");
        return;
      }

      if (!GetIsObjectValid(oTarget))
      {
        object oPC  = GetFirstPC();
        int nLength = GetStringLength(sParams);
        while (GetIsObjectValid(oPC))
        {
          if (GetStringLeft(fbNAGetGlobalDynamicName(oPC), nLength) == sParams)
          {
            oTarget = oPC;
          }
          oPC = GetNextPC();
        }
      }

      if (!GetIsObjectValid(oTarget))
      {
        SendMessageToPC(oSpeaker, "<cþ£ >Could not find character: " + sParams);
      }
      else
      {
        object me = oSpeaker;


        object myNewWard = oTarget;
        RemoveGuardAndWard(me);




        object myNewWardsExistingGuard = GetLocalObject(myNewWard, "CURRENT_GUARD");
        object myNewWardsExistingWard = GetLocalObject(myNewWard, "CURRENT_WARD");

        int myNewWardIsBeingGuarded = GetIsObjectValid(myNewWardsExistingGuard);
        int myNewWardHasAWard = GetIsObjectValid(myNewWardsExistingWard);

        if (myNewWardIsBeingGuarded)
        {
            unhookRelationship(myNewWardsExistingGuard, myNewWard);

            if (myNewWardsExistingGuard != myNewWard)
            {
                informBrokenRelationship(myNewWardsExistingGuard, myNewWard);
            }
        }
        else if (myNewWardHasAWard)
        {
            unhookRelationship(myNewWard, myNewWardsExistingWard);

            if (myNewWardsExistingWard != myNewWard)
            {
                informBrokenRelationship(myNewWard, myNewWardsExistingWard);
            }
        }

        hookRelationship(me, myNewWard);

        if (me != myNewWard)
        {
            informNewRelationship(me, myNewWard);
        }
      }
    }
  }

  chatVerifyCommand(oSpeaker);
}
