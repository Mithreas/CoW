#include "cow_checkclasses"
void JumpToStartingLocation(object oPC, location lLocation)
{
  if (GetIsObjectValid(GetArea(oPC)))
  {
    AssignCommand(oPC, JumpToLocation(lLocation));
  }
  else
  {
    DelayCommand(1.0, JumpToStartingLocation(oPC, lLocation));
  }
}

void CreateItemVoid(string sResRef, object oCreature)
{
  CreateItemOnObject(sResRef, oCreature);
}

void ResetInventory(object oPC)
{
  // Remove all items.
  object oItem = GetFirstItemInInventory(oPC);
  while (GetIsObjectValid(oItem))
  {
    DestroyObject(oItem);
    oItem = GetNextItemInInventory(oPC);
  }

  // Modules and areas can't take gold. Which means that we have to tell
  // the PC to take gold from themself and destroy it. Odd, huh? :-)
  AssignCommand(oPC, TakeGoldFromCreature(GetGold(oPC), oPC, TRUE));

  // Give objects to new player.
  DelayCommand(0.2, GiveGoldToCreature (oPC, 1000));
  DelayCommand(0.1, CreateItemVoid("obj_trainwidg", oPC));
  DelayCommand(0.1, CreateItemVoid("obj_praywidg", oPC));
  DelayCommand(0.1, CreateItemVoid("obj_reswidg", oPC));
  DelayCommand(0.1, CreateItemVoid("dmfi_pc_follow", oPC));
  DelayCommand(0.1, CreateItemVoid("dmfi_pc_dicebag", oPC));
  DelayCommand(0.1, CreateItemVoid("dmfi_pc_emote", oPC));
  DelayCommand(0.1, CreateItemVoid("obj_qstjournal", oPC));
  DelayCommand(0.1, CreateItemVoid("citymap", oPC));
  DelayCommand(0.1, CreateItemVoid("onhonour", oPC));
  DelayCommand(0.1, CreateItemVoid("obj_savewidg", oPC));
  //DelayCommand(0.1, CreateItemVoid("cnrTradeJournal", oPC));  This crashes the server when used.
}

void RemoveAllPCGoldAndItems(object oPC)
{
  if (!GetIsObjectValid(GetArea(oPC)))
  {
    // Not loaded yet. Wait.
    DelayCommand(0.5, RemoveAllPCGoldAndItems(oPC));
    return;
  }

  // unequip anything equipped.
  int nSlot;
  object oItem;
  for (nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; nSlot++)
  {
    oItem = GetItemInSlot(nSlot, oPC);
    if (GetIsObjectValid(oItem))
    AssignCommand(oPC, ActionUnequipItem(oItem));
  }

  // Give PC a standard robe.
  oItem = CreateItemOnObject ("nw_cloth007", oPC);
  AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST));

  DelayCommand(0.5, ResetInventory(oPC));
}


void main()
{
  object oPC = GetEnteringObject();

  // Mark that the player is logged in.
  SetPersistentString(OBJECT_INVALID, GetName(oPC), "PLAYING");

  if ((!GetPersistentInt(oPC, "INITIALIZED")) && (!GetIsDM(oPC)))
  {
     // Remove all gold and items from PC, and give them their starting gear.
     DelayCommand(0.1, RemoveAllPCGoldAndItems(oPC));

     // Take all XP from PC.
     SetXP(oPC, 0);

     // Go to the new player start.
     if (HasInvalidClasses(oPC))
     {
       DelayCommand(3.0, JumpToStartingLocation(oPC,
                               GetLocation(GetObjectByTag("invalid_classes")) ));
       return;
     }

     else if (HasInvalidRaces(oPC))
     {
       DelayCommand(3.0, JumpToStartingLocation(oPC,
                               GetLocation(GetObjectByTag("invalid_classes")) ));
       return;
     }

     else
     {
       DelayCommand(3.0, JumpToStartingLocation(oPC,
                             GetLocation(GetObjectByTag("new_player_start")) ));
     }
  }

  // If invalid, send to the invalid class area.
  else if (!GetIsDM(oPC))
  {
    if (HasInvalidClasses(oPC))
    {
      DelayCommand(3.0, JumpToStartingLocation(oPC,
                              GetLocation(GetObjectByTag("invalid_classes")) ));
      return;
    }
    else if (HasInvalidRaces(oPC))
    {
      DelayCommand(3.0, JumpToStartingLocation(oPC,
                              GetLocation(GetObjectByTag("invalid_classes")) ));
      return;
    }
  }

  if (GetIsDM(oPC))
  {
    if (GetItemPossessedBy(oPC, "dmfi_exploder") == OBJECT_INVALID)
                                       CreateItemOnObject("dmfi_exploder", oPC);
    if (GetItemPossessedBy(oPC, "obj_rankquery") == OBJECT_INVALID)
                                       CreateItemOnObject("obj_rankquery", oPC);
    if (GetItemPossessedBy(oPC, "obj_setname") == OBJECT_INVALID)
                                       CreateItemOnObject("obj_setname", oPC);
  }
}
