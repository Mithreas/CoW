/*
  Standard include utility for scripts involving disguised PCs.
  Author: Mithreas
*/
#include "inc_names"
#include "inc_worship"
#include "inc_pc"
#include "inc_effect"
#include "__server_config"
#include "zzdlg_color_inc"

const string DISGUISED = "disguised";

// The disguised character makes a Perform or Bluff check, opposed by the
// Spot check of the spotter.  Returns TRUE if the spotter wins.
// sDescription is given to any PCs involved as a server message.
// nMultiplier is intended to be used to "weight" the decision in favour of the
// spotter - ideally, the calling code should set it to the number of times
// this NPC has tried to recognise this PC. Negative multipliers are ignored.
int SeeThroughDisguise(object oDisguised, object oSpotter, int nMultiplier = 0, string sDescription = "");

// Disguises a PC, changing their appearance by subrace. If sName is given, also
// changes the name to appear.
void DisguisePC(object oPC, string sName = "");

// Undisguises a PC, returning their appearance to normal.
void UnDisguisePC(object oPC);

// Returns true if the PC has concealed their appearance.
int GetIsPCDisguised(object oPC);

// saves portrait resref in database (used for portal)
void UpdatePortraitInDB(object oPC, string sResRef);

/*
  Change the appearance of the specified creature.
*/
void p_ChangeAppearance(object oPC, int nAppearance)
{
  SetCreatureAppearanceType(oPC, nAppearance);
}

string GetDisguisedPortraitResRef(object pc);
void HidePortrait(object pc);
void RestorePortrait(object pc);

/*
  The disguised character makes a Perform or Bluff check, opposed by the
  Spot check of the spotter.  sDescription is given to any PCs involved
  as a server message.

  nMultiplier is intended to be used to "weight" the decision in favour of the
  spotter - ideally, the calling code should set it to the number of times
  this NPC has tried to recognise this PC. Negative multipliers are ignored.
*/
int SeeThroughDisguise(object oDisguised,
                       object oSpotter,
                       int    nMultiplier = 0,
					   string sDescription = "")
{
  int nPerform = GetSkillRank(SKILL_PERFORM, oDisguised);
  int nBluff   = GetSkillRank(SKILL_BLUFF,   oDisguised);
  int nSpot    = GetSkillRank(SKILL_SPOT,    oSpotter);
  int nResult  = 0;
  
  if (GetIsPC(oDisguised))
  {
    SendMessageToPC(oDisguised, sDescription);
  }

  if (GetIsPC(oSpotter))
  {
    SendMessageToPC(oDisguised, sDescription);
  }
  
  // Special rules for polymorph.
  if (GetHasEffect(EFFECT_TYPE_POLYMORPH, oDisguised)) {
    if (GetHasEffect(EFFECT_TYPE_TRUESEEING , oSpotter))
        nSpot += 10;
    else
        nSpot -= 10;
  }

  if (nPerform > nBluff)
  {
    nResult = ( (d20() + nPerform) < (d20(nMultiplier) + nSpot) );
  }
  else
  {
    nResult = ( (d20() + nBluff) < (d20(nMultiplier) + nSpot) );
  }

  if (nResult && GetIsPC(oSpotter))
  {
    // Divine intervention!
    string sDeity = GetDeity(oDisguised);
    if (gsWOGetDeityAspect(oDisguised) & ASPECT_TRICKERY_DECEIT &&
            gsWOGrantBoon(oDisguised) )
    {
      SendMessageToPC(oDisguised, sDeity + " intercedes to conceal your identity.");
      nResult = 0;
    }
  }

  if (nResult)
  {
    if (GetIsPC(oDisguised))
    {
      SendMessageToPC(oDisguised, txtRed + "Your disguise was broken!");
    }

    if (GetIsPC(oSpotter))
    {
      SendMessageToPC(oSpotter, txtGreen + "You broke a disguise!");
    }
  }
  else
  {
    if (GetIsPC(oDisguised))
    {
      SendMessageToPC(oDisguised, txtGreen + "Your disguise held up under scrutiny!");

      // Piety reward
      if (gsWOGetDeityAspect(oDisguised) & ASPECT_TRICKERY_DECEIT)
      gsWOAdjustPiety(oDisguised, 0.1f);
    }

    if (GetIsPC(oSpotter))
    {
      SendMessageToPC(oSpotter, txtRed + "You failed to break a disguise!");
    }
  }

  return nResult;
}

/* Utility function to remove the disguise from a PC */
void UnDisguisePC(object oPC)
{

    FloatingTextStringOnCreature("You are no longer trying to disguise yourself.",
                                                                     oPC, TRUE);
    // Note that the PC is not disguised.
    SetLocalInt(oPC, DISGUISED, 0);

    // Remove name modifier.
    fbNADelaySetName(oPC, "");
    fbNARemoveNameModifier(oPC, FB_NA_MODIFIER_DISGUISE);

    miXFUpdatePlayerName(oPC, GetName(oPC));
    RestorePortrait(oPC);

    // dunshine: in case a disguise kit was used, revert the PC back to it's regular looks
    object oHide = gsPCGetCreatureHide(oPC);
    if (GetLocalInt(oHide, "GVD_DISGUISE_KIT_ACTIVE") == 1) {

      SetPhenoType(GetLocalInt(oHide, "GVD_DISGUISE_KIT_PHENO"), oPC);
      SetCreatureBodyPart(CREATURE_PART_HEAD, GetLocalInt(oHide, "GVD_DISGUISE_KIT_HEAD"), oPC);
      SetColor(oPC, COLOR_CHANNEL_HAIR, GetLocalInt(oHide, "GVD_DISGUISE_KIT_HAIR"));

      // remove disguise kit bonus
      RemoveTaggedEffects(oPC, EFFECT_TAG_DISGUISE);
    }

}

/* Utility function to disguise a PC */
void DisguisePC(object oPC, string sName = "")
{
    FloatingTextStringOnCreature("You are now trying to disguise yourself.",
                                                                     oPC, TRUE);
    int nPCType = GetRacialType(oPC);

    // Note that the PC is disguised.
    SetLocalInt(oPC, DISGUISED, 1);

    // Change name.
    if (sName != "")
    {
      fbNADelaySetName(oPC, sName);
    }

    miXFUpdatePlayerName(oPC, sName);
    HidePortrait(oPC);

    // dunshine: check for disguise kit useage, apply a bluff bonus if so
    object oHide = gsPCGetCreatureHide(oPC);
    if (GetLocalInt(oHide, "GVD_DISGUISE_KIT_ACTIVE") == 1) {
      ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(SKILL_BLUFF, 10)), oPC, 0.0, EFFECT_TAG_DISGUISE);
    }

    fbNAAddNameModifier(oPC, FB_NA_MODIFIER_DISGUISE, "", " (Disguised)");
}

int GetIsPCDisguised(object oPC)
{
  return GetLocalInt(oPC, DISGUISED);
}

string GetDisguisedPortraitResRef(object pc)
{
    return (GetGender(pc) == GENDER_MALE) ? ("po_hu_m_99_") : ("po_hu_f_99_");
}

void HidePortrait(object pc)
{
    if(!GetIsPC(pc)) return;

    object hide = gsPCGetCreatureHide(pc);

    if (GetLocalString(hide, "PORTRAIT") == "")
    {
        // We don't have a saved portrait, let's just save what we have right now before the switch.
        SetLocalString(hide, "PORTRAIT", GetPortraitResRef(pc));
    }

    SetPortraitResRef(pc, GetDisguisedPortraitResRef(pc));
    UpdatePortraitInDB(pc, GetDisguisedPortraitResRef(pc));
}

void RestorePortrait(object pc)
{
    object hide = gsPCGetCreatureHide(pc);

    { // Legacy code
        string oldResRef = GetLocalString(hide, "DISGUISED_PORTRAIT");

        if (oldResRef != "")
        {
            DeleteLocalString(hide, "DISGUISED_PORTRAIT");
            SetLocalString(hide, "PORTRAIT", oldResRef);
        }
    } // End legacy code

    string storedResRef = GetLocalString(hide, "PORTRAIT");

    if (storedResRef != "")
    {
        SetPortraitResRef(pc, storedResRef);
        UpdatePortraitInDB(pc, storedResRef);
    }
}

// Returns TRUE if module is configured accordingly.
int GetCanPCDisguiseSelf(object oPC);
int GetCanPCDisguiseSelf(object oPC)
{
  return ALLOW_DISGUISE;
}


void UpdatePortraitInDB(object oPC, string sResRef) {

  miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oPC), "portrait_resref", sResRef);

}
