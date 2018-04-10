// Includes functions for scrying and sending your image.
#include "gs_inc_time"
#include "gs_inc_common"
#include "inc_generic"
#include "mi_inc_disguise"
#include "mi_inc_spells"
#include "__server_config"
#include "x0_i0_position"

const string IS_SCRYING = "MI_IS_SCRYING";

// Returns true if a PC is in an area protected against scrying.
int IsProtected(object oPC);
// Stop scrying. Call via DelayCommand. nHP is the PC's hitpoints when they
// start.
void stopscry(object oPC, int nHP);
// Returns TRUE if the PC can use scrying.
int GetCanScry(object oPC);
// Returns TRUE if the area the PC is in is protected from scrying.
int IsProtected(object oPC);
// Fades the PC out and in again.
void blackout(object oPC);
// Remove scrying-related invis effects.
void miSCRemoveInvis(object oPC, int bAlsoRemoveAudibleEffects = FALSE);
// Jumps oPC to oTarg, putting them in cutscene mode.  You will need to
// call miSCRemoveInvis, jump the PC to
void miSCDoScrying(object oPC, object oTarg, int bMagical = TRUE);
// Returns TRUE if oPC is currently scrying.
int miSCIsScrying(object oPC);
// Overrides whether oPC can scry or not.  See mi_scry_enter (used near crystal
// balls).
void SetScryOverride(object oPC, int bCanScry);

int miSCIsScrying(object oPC)
{
  return GetLocalInt(oPC, IS_SCRYING);
}

int miSCGetCasterLevel(object oPC)
{
  return ( GetLevelByClass(CLASS_TYPE_CLERIC, oPC) +
           GetLevelByClass(CLASS_TYPE_DRUID, oPC) +
           GetLevelByClass(CLASS_TYPE_SORCERER, oPC) +
           GetLevelByClass(CLASS_TYPE_WIZARD, oPC));
}

int IsProtected(object oPC)
{
  return GetIsObjectValid(GetNearestObjectByTag("scry_protector", oPC)) ||
         GetIsObjectValid(GetNearestObjectByTag("abjurer_ward", oPC)) ||
         (GetTag(GetItemInSlot(INVENTORY_SLOT_NECK, oPC)) == "gvd_amu_noscry");
}

void blackout(object oPC)
{
  FadeToBlack(oPC,FADE_SPEED_SLOW);
  DelayCommand(2.0,FadeFromBlack(oPC,FADE_SPEED_SLOW));
}

void miSCRemoveInvis(object oPC, int bAlsoRemoveAudibleEffects = FALSE)
{
  effect eRemove=GetFirstEffect(oPC);
  while (GetIsEffectValid(eRemove))
  {
    int eType=GetEffectType(eRemove);
    int eDur=GetEffectDurationType(eRemove);

    if((eType == EFFECT_TYPE_VISUALEFFECT && bAlsoRemoveAudibleEffects) ||
       (eType == EFFECT_TYPE_VISUALEFFECT && eDur == DURATION_TYPE_PERMANENT) ||
       eType == EFFECT_TYPE_CUTSCENEGHOST ||
       eType == EFFECT_TYPE_INVISIBILITY ||
	   eType == EFFECT_TYPE_SANCTUARY ||
       eType == EFFECT_TYPE_ETHEREAL)
    {
         RemoveEffect(oPC, eRemove);
    }

    eRemove=GetNextEffect(oPC);
  }
}

void stopscry(object oPC, int nHP)
{
  DeleteLocalInt(oPC, IS_SCRYING);
  AssignCommand(oPC, ClearAllActions(TRUE));
  gsCMStopFollowers(oPC);
  object oCopy = GetLocalObject(oPC, "pccopy");
  location pcLocation = GetLocation(oCopy);

  // debug code
  //WriteTimestampedLogEntry("Found copy: " + GetName(oCopy));

  SetImmortal(oCopy, FALSE);
  DestroyObject(oCopy, 0.0);

  DelayCommand(2.0, miSCRemoveInvis(oPC));

  object oServant = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oPC);
  if (GetIsObjectValid(oServant)) DelayCommand(8.0, miSCRemoveInvis(oServant));

  oServant = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
  if (GetIsObjectValid(oServant)) DelayCommand(8.0, miSCRemoveInvis(oServant));

  SetPlotFlag(oPC,FALSE);
  DelayCommand(1.2, AssignCommand(oPC, ActionJumpToLocation(pcLocation)));
  ApplyEffectToObject(DURATION_TYPE_INSTANT,
                      EffectDamage(nHP - GetCurrentHitPoints(oCopy),
                      DAMAGE_TYPE_POSITIVE,
                      DAMAGE_POWER_NORMAL),
                      oPC);

  blackout(oPC);
  DelayCommand(3.0, SetCutsceneMode(oPC,FALSE));
}

int GetCanScry(object oPC)
{
  if (ALLOW_SCRYING)
  {
    if (GetIsObjectValid(GetItemPossessedBy(oPC, "mi_scry_item"))) return TRUE;

    if (GetLocalInt(oPC, "OVERRIDE_CANSCRY")) return TRUE;

    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION, oPC)) return TRUE;
  }
  return FALSE;
}

void SetScryOverride(object oPC, int bCanScry)
{
  SetLocalInt(oPC, "OVERRIDE_CANSCRY", bCanScry);
}

void conceal (object oPC)
{
	//------------------------------------------------------------------------------------
    // OK, this isn't simple.
	// - Regular invisibility can be pierced by True Sight etc and by standing nearby
	// - Cutscene invisibility doesn't prevent the playerlist from showing the PC as near
	// - You apparently can't stack two types of invisibility.
	// We're sticking with Cutscene Invis for now.
	//------------------------------------------------------------------------------------
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY),
                        oPC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        EffectCutsceneGhost(),
                        oPC);
}


int GetCanSendImage(object oPC)
{
  //if (GetIsObjectValid(GetItemPossessedBy(oPC, "mi_send_item"))) return TRUE;

  if (ALLOW_SENDING)
  {
     if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, oPC))
     {
       return TRUE;
     }
  }

  return FALSE;
}

void Scrying(object oPC,object oTarg)
{
  if(GetHasSpellEffect(SPELL_SANCTUARY,oTarg) || GetHasSpellEffect(SPELL_INVISIBILITY,oTarg)
         ||GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE,oTarg) 
         ||GetHasSpellEffect(SPELL_IMPROVED_INVISIBILITY,oTarg) || IsProtected(oTarg))
         {
         blackout(oPC);
         SendMessageToPC(oPC,"You see nothing.");
         SendMessageToPC(oPC,"Scrying has failed: the target is warded against such divination.");
         return;
         }

  if (GetAreaFromLocation(GetLocation(oTarg)) == OBJECT_INVALID)
  {
    SendMessageToPC(oPC, "You concentrate, but are unable to locate the target.");
    return;
  }

  // Scry once per rest.
  if(miSPGetCanCastSpell(oPC, CUSTOM_SPELL_SCRY))
  {
    //@@@ Improve this.
    if(GetCanScry(oTarg))
          SendMessageToPC(oTarg,"You sense you are being watched from afar.");
    miSCDoScrying(oPC, oTarg);
    miSPHasCastSpell(oPC, CUSTOM_SPELL_SCRY);
  }
  else
  {
    SendMessageToPC(oPC,"<cþ  >You need to rest before you can use this ability again.");
  }
}

void miSCDoScrying(object oPC, object oTarg, int bMagical = TRUE)
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

  if (bMagical)
  {
    location pcLocation=GetLocation(oPC);
    float scrydur = IntToFloat(SCRYING_DURATION) + 2.0;
    DelayCommand(scrydur, stopscry(oPC, nHP));
    oCopy = CopyObject(oPC,pcLocation,OBJECT_INVALID,GetName(oPC)+"copy");
    SetLocalObject(oPC, "pccopy", oCopy);

    AssignCommand(oCopy,
                  ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1,
                  0.2,
                  3600.00));
    ChangeToStandardFaction(oCopy, STANDARD_FACTION_COMMONER);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        EffectVisualEffect(VFX_DUR_PROT_PREMONITION),
                        oCopy,
                        3600.0);
    SetImmortal(oCopy,TRUE);
  }

  SetCutsceneMode(oPC,TRUE);
  blackout(oPC);

  // Sort out camera. When the cutscene mode ends this will automatically be
  // undone.
  SetCameraMode(oPC, CAMERA_MODE_CHASE_CAMERA);

  RemoveAllAssociates(oPC);

  DelayCommand(1.0,AssignCommand(oPC,ActionJumpToLocation(GetBehindLocation(oTarg))));
  DelayCommand(2.0,AssignCommand(oPC,ActionForceFollowObject(oTarg,IntToFloat(Random(5)) + 0.5)));
  SetPlotFlag(oPC,TRUE);
}

// Used to make send images appear ghostly.
void ghost(object oTarget)
{
  ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                      EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE_NO_SOUND),
                      oTarget);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                      EffectVisualEffect(VFX_DUR_PROT_PREMONITION),
                      oTarget);
}

void Send_Image(object oPC,object oTarg, string sText)
{
  if (GetAreaFromLocation(GetLocation(oTarg)) == OBJECT_INVALID)
  {
    SendMessageToPC(oPC, "The spell failed.");
    return;
  }

  // Send image once per rest.
  if(miSPGetCanCastSpell(oPC, CUSTOM_SPELL_SEND_IMAGE))
  {
    // Create a copy of the PC and remove their buffs.
    miSPHasCastSpell(oPC, CUSTOM_SPELL_SEND_IMAGE);
    location tempLocation = GetLocation(GetObjectByTag("MI_WP_TEMP_LOCATION"));
    object oCopy = CopyObject(oPC,tempLocation,OBJECT_INVALID,GetName(oPC)+"copy");
    string sName;
    string sPortrait;
    if(GetIsPCDisguised(oPC))
	{
		SetLocalInt(oCopy, "disguised", 1);
		sName = fbNAGetGlobalDynamicName(oPC); // Get the Disguised name
		sName = sName + GetLocalString(oPC, "FB_NA_POST_1"); //Add the dynamic (Disguise) tag
		SetName(oCopy, sName); //Set Name of the Image, fbNASetDynamicNameForAll will not work here
		if (GetGender(oPC) == GENDER_MALE) //Hide portrait
		{ // Male
			sPortrait = "po_hu_m_99_";	
		}
		else
		{ // Female
			sPortrait = "po_hu_f_99_";	
		}
		NWNX_Object_SetPortrait(oCopy, sPortrait);
	}
    miSCRemoveInvis (oCopy); // remove existing buff things
    ghost (oCopy);
    ChangeToStandardFaction(oCopy, STANDARD_FACTION_COMMONER);
    SetImmortal(oCopy, TRUE);
    SetPlotFlag(oCopy, TRUE);
    SetActionMode(oCopy, ACTION_MODE_STEALTH, FALSE);

    AssignCommand(GetModule(), DelayCommand(1.0, AssignCommand(oCopy, ActionJumpToObject(oTarg,FALSE))));
    AssignCommand(GetModule(), DelayCommand(1.1, AssignCommand(oCopy, SetFacingPoint(GetPosition(oTarg)))));
    AssignCommand(GetModule(), DelayCommand(1.5, AssignCommand(oCopy, ActionSpeakString(
     "*A ghostly visage appears before you, shrouded in magics. It speaks.*"))));

    AssignCommand(GetModule(), DelayCommand(3.5, AssignCommand(oCopy, ActionSpeakString(sText))));
    AssignCommand(GetModule(), DelayCommand(9.5, AssignCommand(oCopy, ActionSpeakString(
                    "*As mysteriously as it appeared, the vision vanishes.*"))));
    AssignCommand(GetModule(), DelayCommand(10.0, DestroyObject(oCopy)));
    AssignCommand(GetModule(), DelayCommand(10.5, SendMessageToPC(oTarg, "The message was: " + sText)));

    SendMessageToPC(oPC, "<c þ >Your image has been sent to " + GetName(oTarg));
  }
  else
  {
    SendMessageToPC(oPC,"<cþ  >You need to rest before you can use this ability again.");
  }
}
