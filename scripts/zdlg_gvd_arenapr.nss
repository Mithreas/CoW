 
/*
  zdlg_messengers

  Z-Dialog conversation script for arena priest


*/

#include "zdlg_include_i"
#include "x0_i0_position"
#include "gs_inc_pc"

const string SPELLOPTIONS = "SPELLOPTIONS";
const string DONE    = "MES_DONE";

const string PAGE_SPELLS = "PAGE_SPELLS";
const string PAGE_DONE    = "DONE";


void Init()
{
  object oPC = GetPcDlgSpeaker();

  if (GetElementCount(DONE) == 0)
  {
    AddStringElement("<c þ >[Done]</c>", DONE);
  }

  if (GetElementCount(SPELLOPTIONS) == 0)
  {

    AddStringElement("Bless", SPELLOPTIONS);
    AddStringElement("Endurance", SPELLOPTIONS);
    AddStringElement("Bulls Strength", SPELLOPTIONS);
    AddStringElement("Cat's Grace", SPELLOPTIONS);
    AddStringElement("Ultravision", SPELLOPTIONS);
    AddStringElement("Magic Vestment", SPELLOPTIONS);
    AddStringElement("Darkfire", SPELLOPTIONS);
    AddStringElement("I'm done here", SPELLOPTIONS);
  
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {
      // check classes, sorcerers, wizards, priests, druids and bards are excluded
      if ((GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0) || (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0) || (GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0) || (GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 0) || (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0)) {
          SetDlgPrompt("The blessings of Tempus are for true warriors only, find your help elsewhere!");
          EndDlg();
      } else {
          // check if the PC already got 2 buffs
          object oHide = gsPCGetCreatureHide(oPC);
          if (GetLocalInt(oHide, "GVD_ARENA_BUFFS") < 2) {
            SetDlgPrompt("Experience Tempus' blessings warrior! You will learn to appreciate them when fighting in the arena!");
            SetDlgResponseList(SPELLOPTIONS);
          } else {
            SetDlgPrompt("That's enough for now, show Tempus some fighting first!");
            EndDlg();
          }
      }
  }
  else if (sPage == PAGE_DONE)
  {
    SetDlgResponseList(DONE);
  }

}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();
  object oTarget;

  if (sPage == "") {
    // handle the PCs selection

    switch (selection) {
      case 0: {
        // bless
        ActionCastFakeSpellAtObject(SPELL_BLESS, oPC);
        ActionCastSpellAtObject(SPELL_AID, oPC, METAMAGIC_EXTEND); 
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(1), oPC, 300.0f);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_WILL, 1), oPC, 300.0f);
        break;
      }
      case 1:
        // endurance
        ActionCastFakeSpellAtObject(SPELL_ENDURANCE, oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_CONSTITUTION, d4(1)+1), oPC, 300.0f);   
        break;

      case 2:
        // bull str
        ActionCastFakeSpellAtObject(SPELL_BULLS_STRENGTH, oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_STRENGTH, d4(1)+1), oPC, 300.0f);   
        break;

      case 3:
        // cat's grace
        ActionCastFakeSpellAtObject(SPELL_CATS_GRACE, oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_DEXTERITY, d4(1)+1), oPC, 300.0f);   
        break;

      case 4:
        // ultravision
        ActionCastFakeSpellAtObject(SPELL_DARKVISION, oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectUltravision(), oPC, 300.0f);   
        break;

      case 5:
        // magic vestment
        ActionCastFakeSpellAtObject(SPELL_MAGIC_VESTMENT, oPC);
        oTarget = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        if (oTarget != OBJECT_INVALID) {
          AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyACBonus(3), oTarget, 300.0f);
        }
        break;

      case 6:
        // darkfire
        ActionCastFakeSpellAtObject(SPELL_DARKFIRE, oPC);
        oTarget = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        if (oTarget != OBJECT_INVALID) {
          AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, d6(1)+4), oTarget, 300.0f);
        }
        break;

      case 7:
        // leave
        break;
    }

    // keep track of number of buffs on the PC hide, max at a time = 2
    object oHide = gsPCGetCreatureHide(oPC);
    SetLocalInt(oHide, "GVD_ARENA_BUFFS", GetLocalInt(oHide, "GVD_ARENA_BUFFS") + 1);

    EndDlg();

  } else {

    EndDlg();

  }

}

void main()
{
  // Don't change this method unless you understand Z-dialog.
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Called conversation script with event... " + IntToString(nEvent));
  switch (nEvent)
  {
    case DLG_INIT:
      Init();
      break;
    case DLG_PAGE_INIT:
      PageInit();
      break;
    case DLG_SELECTION:
      HandleSelection();
      break;
    case DLG_ABORT:
    case DLG_END:
      break;
  }
}
