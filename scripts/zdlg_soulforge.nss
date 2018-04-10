/*
  Name: zdlg_soulforge
  Author: Mithreas
  Date: Aug 2 2006
  Description: Soulforging item creation script. Uses Z-Dialog.

  _Structure_
  Item to enhance is stored on the PC as an object variable called
  SOULFORGE_ITEM.

  Initial tree asks what sort of enhancement the PC wants to add. Each option
  is only presented if the PC possesses the relevant focus item. Without a
  focus item, the PC can enchant an item to +3.

  The second page asks for the magnitude of the enchantment. There are some
  standard values for each type - e.g. enhancement is 1/2/3/4/5/6, additional
  damage is 1/2/d4/3/d6/4/d8/5/d10/2d6. Values presented depend on PC's craft
  skill and focuses possessed.

  The third page computes the cost of the new item, and thus the amount of XP
  that the PC will need to expend for the enchantment (new cost - old cost). It
  then tells the PC what the cost will be and asks them if they want to proceed.
  (Optional extra - tell the PC what level they will be once the cost is paid).

  For working purposes, we use a system chest to put copies in (this lets us
  compute costs more easily). If you add properties to this item, remember to
  remove them if the PC cancels. The item should be destroyed before calling
  EndDlg(). The working item is stored in the local object variable
  WORKING_ITEM on the PC for reference purposes.

  Note that the system as implemented allows someone to reduce the magnitude of
  properties - e.g. turn a +2 sword into a +1 sword. If the new item is
  cheaper than the old item, the change is free but no XP is regained. This
  allows someone to "rescue" an item they have made > level 20.

  @@@ ToDo:
   Add a firewall for level 20 based on cost.
   Add craft skill requirements (weapon/armour)
   Add material components?
*/
#include "zdlg_include_i"
#include "sforge_include"

// Quick way to increase the cost of all items - bump this variable.
const float MULTIPLIER   = 1.0;

// Replies are generated programatically for each page. So we reuse this list.
const string REPLY       = "reply";
// We use this list and var to keep track of which property the PC has selected.
const string PROPERTIES  = "properties";
const string PROPERTY    = "property";
// We use this list to keep track of which magnitude the PC has selected.
const string MAGNITUDES  = "magnitudes";
const string MAGNITUDE   = "magnitude";

// Page names.
const string CHOOSE_PROP = "";  // We don't control this, built into the system.
const string HOW_MUCH    = "HOW_MUCH"; // For magnitude selection
const string CONFIRM     = "CONFIRM"; // For confirming cost
const string DONE        = "DONE"; // For confirming success.

// Variables on the PC
const string WORKING_ITEM      = "WORKING_ITEM";
const string IS_SFORGE_WPN     = "IS_SFORGE_WPN"; // Weapons get different props
const string COST              = "SFORGE_COST"; // Cost of the item
const string HAS_ENHANCE_FOCUS = "HAS_ENHANCE"; // PC has the enhancement focus
const string HAS_FIRE_FOCUS    = "HAS_FIRE"; // PC has elemental focus
const string HAS_COLD_FOCUS    = "HAS_COLD"; // PC has elemental focus
const string HAS_SLASH_FOCUS   = "HAS_SLASH"; // PC has slashing focus
const string HAS_PIERCE_FOCUS  = "HAS_PIERCE"; // PC has piercing focus
const string HAS_BLUDGE_FOCUS  = "HAS_BLUDGE"; // PC has bludgeoning focus

// Allowed properties
const string ENHANCE = "ENHANCEMENT";
const string FIRE    = "FIRE";
const string COLD    = "COLD";
const string SLASH   = "SLASHING";
const string PIERCE  = "PIERCING";
const string BLUDGE  = "BLUDGEONING";

// Tag of the container we store works in progress in.
const string CHEST = "soulforge_system_chest";

// Utility methods

// Lists the weapon and armor enhancement options available to a PC.
// sReply - name of the reply list to add to. Human readable, e.g. "+1", "+2"
// sMagnitudes - name of the list of properties to set up. Machine readable,
//   i.e. IP_CONST_*
// nCraftSkill - crafter's skill level.
// bHasFocus - TRUE if we should present options up to +6, false if only +3.
void AddEnhancementMagnitudeOptions(string sReply,
                                    string sMagnitudes,
                                    int nCraftSkill,
                                    int bHasFocus = TRUE);

// Lists the damage options available to a PC.
// sReply - name of the reply list to add to. Human readable, e.g. "1d6".
// sMagnitudes - name of the list of properties to set up. Machine readable,
//   i.e. IP_CONST_*
// nCraftSkill - crafter's skill level.
void AddDamageMagnitudeOptions(string sReply,
                               string sMagnitudes,
                               int nCraftSkill);

// Lists the damage resistance options available to a PC.
// sReply - name of the reply list to add to. Human readable, e.g. "5/-".
// sMagnitudes - name of the list of properties to set up. Machine readable,
//   i.e. IP_CONST_*
void AddDamageResistanceMagnitudeOptions(string sReply,
                                         string sMagnitudes,
                                         int nCraftSkill);

// Get the craft skill modifier for this PC.
int GetCraftSkillModifier(object oPC, int nCraftSkill);

// Removes the item we're working on and ends the dialog.
void EndAndCleanUp();

void AddEnhancementMagnitudeOptions(string sReply,
                                    string sMagnitudes,
                                    int nCraftSkill,
                                    int bHasFocus = TRUE)
{
   if (nCraftSkill > 3)
   {
     AddStringElement("First Order", sReply);
     AddIntElement(1, sMagnitudes);
   }

   if (nCraftSkill > 7)
   {
     AddStringElement("Second Order", sReply);
     AddIntElement(2, sMagnitudes);
   }

   if (nCraftSkill > 11)
   {
     AddStringElement("Third Order", sReply);
     AddIntElement(3, sMagnitudes);
   }

   if (bHasFocus && (nCraftSkill > 15))
   {
     AddStringElement("Fourth Order", sReply);
     AddIntElement(4, sMagnitudes);
   }

   if (bHasFocus && (nCraftSkill > 19))
   {
     AddStringElement("Fifth Order", sReply);
     AddIntElement(5, sMagnitudes);
   }

   if (bHasFocus && (nCraftSkill > 23))
   {
     AddStringElement("Sixth Order", sReply);
     AddIntElement(6, sMagnitudes);
   }
}

void AddDamageMagnitudeOptions(string sReply,
                               string sMagnitudes,
                               int nCraftSkill)
{
  if (nCraftSkill > 3)
  {
    AddStringElement("1d4 damage", sReply);
    AddIntElement(IP_CONST_DAMAGEBONUS_1d4, sMagnitudes);
  }
  if (nCraftSkill > 7)
  {
    AddStringElement("1d6 damage", sReply);
    AddIntElement(IP_CONST_DAMAGEBONUS_1d6, sMagnitudes);
  }
  if (nCraftSkill > 11)
  {
    AddStringElement("1d8 damage", sReply);
    AddIntElement(IP_CONST_DAMAGEBONUS_1d8, sMagnitudes);
  }
  if (nCraftSkill > 15)
  {
    AddStringElement("2d4 damage", sReply);
    AddIntElement(IP_CONST_DAMAGEBONUS_2d4, sMagnitudes);
  }
  if (nCraftSkill > 19)
  {
    AddStringElement("2d6 damage", sReply);
    AddIntElement(IP_CONST_DAMAGEBONUS_2d6, sMagnitudes);
  }
  if (nCraftSkill > 23)
  {
    AddStringElement("2d8 damage", sReply);
    AddIntElement(IP_CONST_DAMAGEBONUS_2d8, sMagnitudes);
  }
}

void AddDamageResistanceMagnitudeOptions(string sReply,
                                         string sMagnitudes,
                                         int nCraftSkill)
{
  if (nCraftSkill > 3)
  {
    AddStringElement("5/-", sReply);
    AddIntElement(IP_CONST_DAMAGERESIST_5, sMagnitudes);
  }
  if (nCraftSkill > 7)
  {
    AddStringElement("10/-", sReply);
    AddIntElement(IP_CONST_DAMAGERESIST_10, sMagnitudes);
  }
  if (nCraftSkill > 11)
  {
    AddStringElement("15/-", sReply);
    AddIntElement(IP_CONST_DAMAGERESIST_15, sMagnitudes);
  }
  if (nCraftSkill > 15)
  {
    AddStringElement("20/-", sReply);
    AddIntElement(IP_CONST_DAMAGERESIST_20, sMagnitudes);
  }
  if (nCraftSkill > 19)
  {
    AddStringElement("25/-", sReply);
    AddIntElement(IP_CONST_DAMAGERESIST_25, sMagnitudes);
  }
  if (nCraftSkill > 23)
  {
    AddStringElement("30/-", sReply);
    AddIntElement(IP_CONST_DAMAGERESIST_30, sMagnitudes);
  }
}

int GetCraftSkillModifier(object oPC, int nCraftSkill)
{
  int nSkillRanks = GetSkillRank(nCraftSkill, oPC);
  int nIntMod = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
  int nHasSkillFocus = 0;
  if (nCraftSkill == SKILL_CRAFT_ARMOR)
  {
    nHasSkillFocus = GetHasFeat(FEAT_SKILL_FOCUS_CRAFT_ARMOR, oPC);
  }
  else if (nCraftSkill == SKILL_CRAFT_WEAPON)
  {
    nHasSkillFocus = GetHasFeat(FEAT_SKILL_FOCUS_CRAFT_WEAPON, oPC);
  }
  else if (nCraftSkill == SKILL_CRAFT_TRAP)
  {
    nHasSkillFocus = GetHasFeat(FEAT_SKILL_FOCUS_CRAFT_TRAP, oPC);
  }

  return (nSkillRanks + nIntMod + 3*nHasSkillFocus);
}

void EndAndCleanUp()
{
  object oPC = GetPcDlgSpeaker();
  object oWorkingCopy = GetLocalObject(oPC, WORKING_ITEM);
  DestroyObject(oWorkingCopy);
  EndDlg();
}

void Init()
{
  object oPC = GetPcDlgSpeaker();

  // This method is called at the start of the conversation. We:
  // * make a copy of the item to be forged and put it in the system chest
  // * Decide whether the item is a weapon or not.
  // * work out what focuses the PC has in their inventory.
  object oItem  = GetLocalObject(oPC, SOULFORGE_ITEM);
  Trace(SOULFORGING, "Item to work on: " + GetName(oItem));
  object oChest = GetObjectByTag(CHEST);
  SetLocalObject(oPC, WORKING_ITEM, CopyItem(oItem, oChest));

  if (IPGetIsRangedWeapon(oItem) || IPGetIsMeleeWeapon(oItem))
  {
    SetLocalInt(oPC, IS_SFORGE_WPN, 1);
  }
  else
  {
    // In case we've previously forged a weapon, clear the var.
    SetLocalInt(oPC, IS_SFORGE_WPN, 0);
  }

  // Basic enhancement up to +3 is free. To go to +6 requires an item with
  // tag sforge_enhance
  if (GetItemPossessedBy(oPC, "sforge_enhance") != OBJECT_INVALID)
  {
    Trace(SOULFORGING, "Got enhancement focus.");
    SetLocalInt(oPC, HAS_ENHANCE_FOCUS, 1);
  }
  else
  {
    SetLocalInt(oPC, HAS_ENHANCE_FOCUS, 0);
  }

  // For fire enchantment (fire damage on weapons or fire protection on non
  // weapons) the PC needs an item with tag sforge_fire
  if (GetItemPossessedBy(oPC, "sforge_fire") != OBJECT_INVALID)
  {
    Trace(SOULFORGING, "Got fire focus.");
    SetLocalInt(oPC, HAS_FIRE_FOCUS, 1);
  }
  else
  {
    SetLocalInt(oPC, HAS_FIRE_FOCUS, 0);
  }

  // For cold enchantment (cold damage on weapons or cold protection on non
  // weapons) the PC needs an item with tag sforge_cold
  if (GetItemPossessedBy(oPC, "sforge_cold") != OBJECT_INVALID)
  {
    Trace(SOULFORGING, "Got cold focus.");
    SetLocalInt(oPC, HAS_COLD_FOCUS, 1);
  }
  else
  {
    SetLocalInt(oPC, HAS_COLD_FOCUS, 0);
  }

  // For slashing enchantment (slashing damage on weapons or slashing DR on non
  // weapons) the PC needs an item with tag sforge_slash
  if (GetItemPossessedBy(oPC, "sforge_slash") != OBJECT_INVALID)
  {
    Trace(SOULFORGING, "Got slashing focus.");
    SetLocalInt(oPC, HAS_SLASH_FOCUS, 1);
  }
  else
  {
    SetLocalInt(oPC, HAS_SLASH_FOCUS, 0);
  }

  // For piercing enchantment (piercing damage on weapons or piercing DR on non
  // weapons) the PC needs an item with tag sforge_pierce
  if (GetItemPossessedBy(oPC, "sforge_pierce") != OBJECT_INVALID)
  {
    Trace(SOULFORGING, "Got piercing focus.");
    SetLocalInt(oPC, HAS_PIERCE_FOCUS, 1);
  }
  else
  {
    SetLocalInt(oPC, HAS_PIERCE_FOCUS, 0);
  }

  // For bludgeoning enchantment (bludgeoning damage on weapons or bludgeoning
  // DR on non weapons) the PC needs an item with tag sforge_bludge
  if (GetItemPossessedBy(oPC, "sforge_bludge") != OBJECT_INVALID)
  {
    Trace(SOULFORGING, "Got bludgeoning focus.");
    SetLocalInt(oPC, HAS_BLUDGE_FOCUS, 1);
  }
  else
  {
    SetLocalInt(oPC, HAS_BLUDGE_FOCUS, 0);
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  int isWeapon = GetLocalInt(oPC, IS_SFORGE_WPN);

  if (sPage == CHOOSE_PROP)
  {
    SetDlgPrompt("Choose the property you wish to change.");
    DeleteList(REPLY);
    DeleteList(PROPERTIES);

    // Include an exit option.
    AddStringElement("Cancel", REPLY);
    AddStringElement("Dummy", PROPERTIES);

    if (TRUE) // Always allow enhancement (at least up to +3)
    {
      AddStringElement("Modify enhancement bonus.", REPLY);
      AddStringElement(ENHANCE, PROPERTIES);
    }

    if (GetLocalInt(oPC, HAS_FIRE_FOCUS))
    {
      AddStringElement("Modify fire affinity.", REPLY);
      AddStringElement(FIRE, PROPERTIES);
    }

    if (GetLocalInt(oPC, HAS_COLD_FOCUS))
    {
      AddStringElement("Modify cold affinity.", REPLY);
      AddStringElement(COLD, PROPERTIES);
    }

    if (GetLocalInt(oPC, HAS_SLASH_FOCUS))
    {
      AddStringElement("Modify slashing profile.", REPLY);
      AddStringElement(SLASH, PROPERTIES);
    }

    if (GetLocalInt(oPC, HAS_PIERCE_FOCUS))
    {
      AddStringElement("Modify piercing profile.", REPLY);
      AddStringElement(PIERCE, PROPERTIES);
    }

    if (GetLocalInt(oPC, HAS_BLUDGE_FOCUS))
    {
      AddStringElement("Modify bludgeoning affinity.", REPLY);
      AddStringElement(BLUDGE, PROPERTIES);
    }

    SetDlgResponseList(REPLY, OBJECT_SELF);
  }
  else if (sPage == HOW_MUCH)
  {
    SetDlgPrompt("How much of an enhancement do you wish to apply?");
    DeleteList(REPLY);
    DeleteList(MAGNITUDES);

    int nCraftArmor = GetCraftSkillModifier(oPC, SKILL_CRAFT_ARMOR);
    int nCraftWeapon = GetCraftSkillModifier(oPC, SKILL_CRAFT_WEAPON);

    // Include a go back option
    AddStringElement("Go back", REPLY);
    AddIntElement(0, MAGNITUDES);

    string sProperty = GetLocalString(oPC, PROPERTY); // The selected property.

    if (GetLocalInt(oPC, IS_SFORGE_WPN))
    {
      // Item is a weapon. So use weapon properties.
      if (sProperty == ENHANCE)
      {
        if (GetLocalInt(oPC, HAS_ENHANCE_FOCUS))
        {
          // This method will fill out the lists for us.
          AddEnhancementMagnitudeOptions(REPLY, MAGNITUDES, nCraftWeapon, TRUE);
        }
        else
        {
          AddEnhancementMagnitudeOptions(REPLY, MAGNITUDES, nCraftWeapon, FALSE);
        }
      }
      else if (sProperty == FIRE)
      {
        // This method will fill out the lists for us.
        AddDamageMagnitudeOptions(REPLY, MAGNITUDES, nCraftWeapon);
      }
      else if (sProperty == COLD)
      {
        AddDamageMagnitudeOptions(REPLY, MAGNITUDES, nCraftWeapon);
      }
      else if (sProperty == SLASH)
      {
        AddDamageMagnitudeOptions(REPLY, MAGNITUDES, nCraftWeapon);
      }
      else if (sProperty == PIERCE)
      {
        AddDamageMagnitudeOptions(REPLY, MAGNITUDES, nCraftWeapon);
      }
      else if (sProperty == BLUDGE)
      {
        AddDamageMagnitudeOptions(REPLY, MAGNITUDES, nCraftWeapon);
      }
    }
    else
    {
      // Item is not a weapon. So use non-weapon properties.
      if (sProperty == ENHANCE)
      {
        if (GetLocalInt(oPC, HAS_ENHANCE_FOCUS))
        {
          // This method will fill out the lists for us.
          AddEnhancementMagnitudeOptions(REPLY, MAGNITUDES, nCraftArmor, TRUE);
        }
        else
        {
          AddEnhancementMagnitudeOptions(REPLY, MAGNITUDES, nCraftArmor, FALSE);
        }
      }
      else if (sProperty == FIRE)
      {
        AddDamageResistanceMagnitudeOptions(REPLY, MAGNITUDES, nCraftArmor);
      }
      else if (sProperty == COLD)
      {
        AddDamageResistanceMagnitudeOptions(REPLY, MAGNITUDES, nCraftArmor);
      }
      else if (sProperty == SLASH)
      {
        AddDamageResistanceMagnitudeOptions(REPLY, MAGNITUDES, nCraftArmor);
      }
      else if (sProperty == PIERCE)
      {
        AddDamageResistanceMagnitudeOptions(REPLY, MAGNITUDES, nCraftArmor);
      }
      else if (sProperty == BLUDGE)
      {
        AddDamageResistanceMagnitudeOptions(REPLY, MAGNITUDES, nCraftArmor);
      }
    }

    SetDlgResponseList(REPLY, OBJECT_SELF);
  }
  else if (sPage == CONFIRM)
  {
    // Apply the enhancement to the working item. We have to:
    // * Retrieve the property name and magnitude
    // * Convert the property name into an item property object (based on
    //   whether it's an armour or weapon)
    // * Remove any existing property of that type on the item
    // * Apply the new property (permanently).
    string sProperty = GetLocalString(oPC, PROPERTY);
    int nMagnitude = GetLocalInt(oPC, MAGNITUDE);
    itemproperty iprp;

    if (GetLocalInt(oPC, IS_SFORGE_WPN))
    {
      if (sProperty == ENHANCE)
      {
        iprp = ItemPropertyEnhancementBonus(nMagnitude);
      }
      else if (sProperty == FIRE)
      {
        iprp = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, nMagnitude);
      }
      else if (sProperty == COLD)
      {
        iprp = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, nMagnitude);
      }
      else if (sProperty == SLASH)
      {
        iprp = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING, nMagnitude);
      }
      else if (sProperty == PIERCE)
      {
        iprp = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING, nMagnitude);
      }
      else if (sProperty == BLUDGE)
      {
        iprp = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, nMagnitude);
      }
      else
      {
        SendMessageToPC(oPC, "Invalid item property. This is a bug, please " +
         "report it, including the text of this message.");
      }
    }
    else
    {
      if (sProperty == ENHANCE)
      {
        iprp = ItemPropertyACBonus(nMagnitude);
      }
      else if (sProperty == FIRE)
      {
        iprp = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,
                                            nMagnitude);
      }
      else if (sProperty == COLD)
      {
        iprp = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,
                                            nMagnitude);
      }
      else if (sProperty == SLASH)
      {
        iprp = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SLASHING,
                                            nMagnitude);
      }
      else if (sProperty == PIERCE)
      {
        iprp = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PIERCING,
                                            nMagnitude);
      }
      else if (sProperty == BLUDGE)
      {
        iprp = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_BLUDGEONING,
                                            nMagnitude);
      }
      else
      {
        SendMessageToPC(oPC, "Invalid item property. This is a bug, please " +
         "report it, including the text of this message.");
      }
    }

    object oWorkingItem = GetLocalObject(oPC, WORKING_ITEM);
    itemproperty iprop = GetFirstItemProperty(oWorkingItem);

    while (GetIsItemPropertyValid(iprop))
    {
      if ((GetItemPropertyType(iprp)    == GetItemPropertyType(iprop)) &&
          (GetItemPropertySubType(iprp) == GetItemPropertySubType(iprop)))
      {
        // The two properties are the same type. Remove the old one.
        Trace(SOULFORGING, "Removing duplicate property from item.");
        RemoveItemProperty(oWorkingItem, iprop);
      }

      iprop = GetNextItemProperty(oWorkingItem);
    }

    AddItemProperty(DURATION_TYPE_PERMANENT, iprp, oWorkingItem);

    // Rename the item if it's not already been renamed.
    if (FindSubString(GetName(oWorkingItem), "Soulforged") == -1)
    {
      SetName(oWorkingItem, "Soulforged " + GetName(oWorkingItem));
    }

    // Get the item costs.
    int nOldCost = GetItemCost(GetLocalObject(oPC, SOULFORGE_ITEM));
    int nNewCost = GetItemCost(oWorkingItem);

    int nXPCost  = nNewCost - nOldCost;
    // MULTIPLIER is a config parameter at the top of the file.
    nXPCost = FloatToInt(MULTIPLIER * IntToFloat(nXPCost));

    if (nXPCost < 0) nXPCost = 0; // If the player has made the item worse they
                                  // don't get XP back.
    int nXP = GetXP(oPC);

    // Delete the contents of the reply list, ready to add new ones.
    DeleteList(REPLY);

    if (nXPCost > nXP)
    {
      SetDlgPrompt("You cannot forge this item; it is beyond you.");
      AddStringElement("Done", REPLY);
    }
    else
    {
      SetLocalInt(oPC, COST, nXPCost);
      SetDlgPrompt("This item will cost you " + IntToString(nXPCost) +
        " experience points. Are you sure you wish to proceed?");
      AddStringElement("Cancel", REPLY);
      AddStringElement("Craft it", REPLY);
    }

    SetDlgResponseList(REPLY, OBJECT_SELF);
  }
  else if (sPage == DONE)
  {
    // Give the item to the PC and remove the old item, docking the XP cost.
    object oOldItem = GetLocalObject(oPC, SOULFORGE_ITEM);
    DestroyObject(oOldItem);

    object oItem  = GetLocalObject(oPC, WORKING_ITEM);
    object oNewItem = CopyItem(oItem, oPC);
    SetLocalObject(oPC, SOULFORGE_ITEM, oNewItem);

    int nNewXP = GetXP(oPC) - GetLocalInt(oPC, COST);
    SetXP(oPC, nNewXP);

    SetDlgPrompt("Item crafted successfully!");
    DeleteList(REPLY);
    AddStringElement("Modify another property", REPLY);
    AddStringElement("Done", REPLY);
    SetDlgResponseList(REPLY, OBJECT_SELF);
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarassing. Please report it.");
    EndDlg();
  }

}

void HandleSelection()
{
  int nSelection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();

  if (sPage == CHOOSE_PROP)
  {
    // Starting page. The PC has just chosen which property to enhance their
    // item with - so parse the response into a property, and store it for
    // later use.
    if (nSelection == 0)
    {
      // PC elected to cancel
      EndAndCleanUp();
    }
    else
    {
      string sProperty = GetStringElement(nSelection, PROPERTIES);
      SetLocalString(oPC, PROPERTY, sProperty);

      SetDlgPageString(HOW_MUCH);
    }
  }
  else if (sPage == HOW_MUCH)
  {
    // PC has chosen how much of an enhancement to apply. So save off the
    // machine-readable version to apply later.
    if (nSelection == 0)
    {
      // PC elected to go back
      SetDlgPageString(CHOOSE_PROP);
    }
    else
    {
      int nMagnitude = GetIntElement(nSelection, MAGNITUDES);
      SetLocalInt(oPC, MAGNITUDE, nMagnitude);
      SetDlgPageString(CONFIRM);
    }
  }
  else if (sPage == CONFIRM)
  {
    switch (nSelection)
    {
      // 0 (first option) = return to first page
      // 1 (second option) = craft.
      case 0:
      {
        SetDlgPageString(CHOOSE_PROP);
        break;
      }
      case 1:
      {
        SetDlgPageString(DONE);
        break;
      }
    }
  }
  else if (sPage == DONE)
  {
    switch (nSelection)
    {
      // 0 (first option) = return to first page
      // 1 (second option) = end dialog.
      case 0:
      {
        SetDlgPageString(CHOOSE_PROP);
        break;
      }
      case 1:
      {
        EndAndCleanUp();
        break;
      }
    }
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarassing. Please report it.");
    EndDlg();
  }
}

void main()
{
  int nEvent = GetDlgEventType();
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
