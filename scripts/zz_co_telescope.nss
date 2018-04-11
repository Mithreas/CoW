//::///////////////////////////////////////////////
//:: Name
//:: FileName  zz_co_telescope
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Use: conversation script for placeable. allows placeable to scry on locations
    to set a location place a waypoint with the same tag with 1 on the end.
    Increment for multiple locations from same placeable.
    Example:
    Telescope tag: cor_frontier
    Waypoints:
    cor_frontier1
    cor_frontier2
    cor_frontier3

    Dialog options use waypoint names
    For best results waypoints should be facing north (possibly..)

*/
//:://////////////////////////////////////////////
//:: Created By:  Morderon
//:: Created On: 6/20/2017
//:://////////////////////////////////////////////


#include "inc_customspells"
#include "zzdlg_main_inc"


const string PAGE_MAIN = "PAGE_MAIN";
const string PAGE_DUR = "PAGE_DUR";
const int SHORT = 15;
const int LONG = 30;

void _CameraAndJump(object oPC, object oTarg, int nDur)
{
  int nTransition = 30;
  if(nDur == LONG)
    nTransition = 15;
  AssignCommand(oPC,ActionJumpToObject(oTarg,FALSE));
  AssignCommand(oPC,SetCameraFacing(0.0, 25.0, 60.0));
  AssignCommand(oPC,SetCameraFacing(270.0, -1.0, -1.0, nTransition));
  DelayCommand(IntToFloat(nDur)/2.0, AssignCommand(oPC,SetCameraFacing(89.0, -1.0, -1.0, nTransition)));
}
string _NumberOfCreatures(object oTarget, int nPC = TRUE)
{
    object oArea = GetFirstObjectInShape(SHAPE_SPHERE, 30.0, GetLocation(oTarget));
    int x;
    while(GetIsObjectValid(oArea))
    {
        if(((nPC && GetIsPC(oArea)) || (!nPC && !GetIsPC(oArea))) && (GetStealthMode(oArea) == STEALTH_MODE_DISABLED && !GetHasEffect(EFFECT_TYPE_INVISIBILITY, oArea) && !GetHasEffect(EFFECT_TYPE_SANCTUARY, oArea) &&  !GetHasEffect(EFFECT_TYPE_ETHEREAL, oArea)))
        {
            x++;
        }
        oArea = GetNextObjectInShape(SHAPE_SPHERE, 30.0, GetLocation(oTarget));
    }

    return IntToString(x);
}
void LocationScry(object oPC, object oTarg, int bMagical = TRUE)
{
  SetLocalInt(oPC, IS_SCRYING, TRUE);
  AssignCommand(oPC, ClearAllActions());
  if (bMagical) miSCRemoveInvis (oPC, TRUE); // Avoid buff jingle noises when scrying.
  conceal (oPC);

  object oServant = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
  if (GetIsObjectValid(oServant)) conceal(oServant);

  oServant = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
  if (GetIsObjectValid(oServant)) conceal(oServant);

  int nHP = GetCurrentHitPoints(oPC);

  object oCopy;

  int nDuration = dlgGetSpeakeeDataInt("TELE_DURATION");

  if (bMagical)
  {
    location pcLocation=GetLocation(oPC);
    float scrydur = IntToFloat(nDuration);
    DelayCommand(scrydur, stopscry(oPC, nHP));
    oCopy = CopyObject(oPC,pcLocation,OBJECT_INVALID,GetName(oPC)+"copy");
    SetLocalObject(oPC, "pccopy", oCopy);

    AssignCommand(oCopy,
                  ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1,
                  0.2,
                  900.00));
    ChangeToStandardFaction(oCopy, STANDARD_FACTION_COMMONER);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        EffectVisualEffect(VFX_DUR_PROT_PREMONITION),
                        oCopy,
                        900.0);
    SetImmortal(oCopy,TRUE);
  }

  SetCutsceneMode(oPC,TRUE);

  blackout(oPC);

  // Sort out camera. When the cutscene mode ends this will automatically be
  // undone.
  SetCameraMode(oPC, CAMERA_MODE_CHASE_CAMERA);

  // Remove any PC summons. Otherwise they follow us when we start scrying (!)
  RemoveAllAssociates(oPC);


  DelayCommand(1.0, _CameraAndJump(oPC, oTarg, nDuration));
  SetPlotFlag(oPC,TRUE);

}

void OnInit()
{
    string sTag = GetTag(OBJECT_SELF);
    object oPC = dlgGetSpeakingPC();
    int nCount = GetElementCount(PAGE_MAIN, oPC);
    if(!nCount)
    {
        object oTarget = GetWaypointByTag(sTag + "1");
        while(GetIsObjectValid(oTarget))
        {
            nCount = dlgAddResponseTalk(PAGE_MAIN, GetName(oTarget) + "    Number of creatures (NPC): " + _NumberOfCreatures(oTarget, FALSE) + " (PC): " + _NumberOfCreatures(oTarget));
            oTarget = GetWaypointByTag(sTag + IntToString(nCount+2));
        }
    }

    nCount = GetElementCount(PAGE_DUR, oPC);
    if(!nCount)
    {
        dlgAddResponseTalk(PAGE_DUR, "Short.");
        dlgAddResponseTalk(PAGE_DUR, "Long.");
    }


    dlgChangePage(PAGE_DUR);

}
void OnPageInit(string sPage)
{
    string sPrompt;
    if(sPage == PAGE_DUR)
        sPrompt = "Select duration.";
    else
        sPrompt = "[Point device in the direction of...]";

    dlgSetPrompt(sPrompt);
    //not multiple pages so don't need anything here
    dlgSetActiveResponseList(sPage);
}
void OnSelection(string sPage)
{
    int nIndex = dlgGetSelectionIndex();
    if(sPage == PAGE_DUR)
    {
        int nDuration = SHORT;
        if(nIndex == 1)
            nDuration = LONG;
        dlgSetSpeakeeDataInt("TELE_DURATION", nDuration);
        dlgChangePage(PAGE_MAIN);
    }
    else
    {
        nIndex += 1;
        object oTarget = GetWaypointByTag(GetTag(OBJECT_SELF) + IntToString(nIndex));

        dlgEndDialog();
        LocationScry(dlgGetSpeakingPC(), oTarget, TRUE);
    }
}
void OnContinue(string sPage, int nContinuePage)
{
}
void OnReset(string sPage)
{

}


void Cleanup()
{

}

void OnAbort(string sPage)
{
  Cleanup();
}
void OnEnd(string sPage)
{
  Cleanup();
}
void main()
{
  dlgOnMessage();
}
