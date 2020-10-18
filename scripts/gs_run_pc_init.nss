#include "inc_class"
#include "inc_common"
#include "inc_pc"
#include "inc_strack"
#include "inc_citizen"

const string INIT = "INIT"; // for tracing

void gsCreateBaseInventory()
{
    object oInventory = GetObjectByTag("GS_INVENTORY_PLAYER");

    if (GetIsObjectValid(oInventory))
    {
        object oItem  = GetFirstItemInInventory(oInventory);
        object oCopy  = OBJECT_INVALID;
        object oDress = OBJECT_INVALID;

        while (GetIsObjectValid(oItem))
        {
            oCopy = gsCMCopyItem(oItem, OBJECT_SELF);

            if (GetIsObjectValid(oCopy))
            {
                SetIdentified(oCopy, TRUE);
                SetStolenFlag(oCopy, FALSE);

                if (! GetIsObjectValid(oDress) &&
                    GetBaseItemType(oCopy) == BASE_ITEM_ARMOR)
                {
                    oDress = oCopy;
                }
            }

            oItem = GetNextItemInInventory(oInventory);
        }

        if (GetIsObjectValid(oDress))
            ActionEquipItem(oDress, INVENTORY_SLOT_CHEST);
    }
}

void _gvd_CopyItemToPC(object oItem) {

  object oCopy = gsCMCopyItem(oItem, OBJECT_SELF);

  if (oCopy != OBJECT_INVALID) {
    SetIdentified(oCopy, TRUE);
    SetStolenFlag(oCopy, FALSE);
  }

}

void gvdCreateBaseInventoryForClass() {

  // get Arelith class name
  string sClassName = gvd_GetArelithClassNameByPosition(1, OBJECT_SELF);
    
  // clean name for use as tag
  sClassName = GetStringUpperCase(sClassName);
  sClassName = StringReplace(sClassName, "(K)", "");
  sClassName = StringReplace(sClassName, " ", "");
  sClassName = StringReplace(sClassName, "-", "");

  // see if there is a chest for this specific class
  object oInventory = GetObjectByTag("GVD_STARTINV_" + sClassName);
  object oItem;

  if (oInventory == OBJECT_INVALID) {
    // no chest found for this (sub)class, try the main class instead
    sClassName = mdGetClassName(GetClassByPosition(1, OBJECT_SELF));
    sClassName = GetStringUpperCase(sClassName);
    sClassName = StringReplace(sClassName, " ", "");   
    sClassName = StringReplace(sClassName, "-", "");
    oInventory = GetObjectByTag("GVD_STARTINV_" + sClassName);
  }

  if (oInventory != OBJECT_INVALID) {

    oItem  = GetFirstItemInInventory(oInventory);
    object oCopy  = OBJECT_INVALID;
    object oDress = OBJECT_INVALID;

    while (oItem != OBJECT_INVALID) {

      oCopy = gsCMCopyItem(oItem, OBJECT_SELF);

      if (GetIsObjectValid(oCopy)) {
        SetIdentified(oCopy, TRUE);
        SetStolenFlag(oCopy, FALSE);

        if (! GetIsObjectValid(oDress) && GetBaseItemType(oCopy) == BASE_ITEM_ARMOR) {
          oDress = oCopy;
        }
      }

      oItem = GetNextItemInInventory(oInventory);

    }

    if (GetIsObjectValid(oDress)) {
      ActionEquipItem(oDress, INVENTORY_SLOT_CHEST);
    }

  }  

  // now check for weapon focus feat
  oInventory = GetObjectByTag("GVD_STARTINV_WEAPONS");

  if (oInventory != OBJECT_INVALID) {

    // loop through all chest items
    oItem  = GetFirstItemInInventory(oInventory);        
    
    while (oItem != OBJECT_INVALID) {

      if (GetHasFeat(FEAT_WEAPON_FOCUS_CLUB) && (GetBaseItemType(oItem) == BASE_ITEM_CLUB)) {  
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER) && (GetBaseItemType(oItem) == BASE_ITEM_DAGGER)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_DART) && (GetBaseItemType(oItem) == BASE_ITEM_DART)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW) && ((GetBaseItemType(oItem) == BASE_ITEM_HEAVYCROSSBOW) || (GetBaseItemType(oItem) == BASE_ITEM_BOLT))) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW) && ((GetBaseItemType(oItem) == BASE_ITEM_LIGHTCROSSBOW) || (GetBaseItemType(oItem) == BASE_ITEM_BOLT))) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE) && (GetBaseItemType(oItem) == BASE_ITEM_LIGHTMACE)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR) && (GetBaseItemType(oItem) == BASE_ITEM_MORNINGSTAR)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_STAFF) && (GetBaseItemType(oItem) == BASE_ITEM_QUARTERSTAFF)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR) && (GetBaseItemType(oItem) == BASE_ITEM_SHORTSPEAR)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE) && (GetBaseItemType(oItem) == BASE_ITEM_SICKLE)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_SLING) && ((GetBaseItemType(oItem) == BASE_ITEM_SLING) || (GetBaseItemType(oItem) == BASE_ITEM_BULLET))) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_UNARMED_STRIKE) && (GetBaseItemType(oItem) == BASE_ITEM_GLOVES)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW) && ((GetBaseItemType(oItem) == BASE_ITEM_LONGBOW) || (GetBaseItemType(oItem) == BASE_ITEM_ARROW))) {   
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW) && ((GetBaseItemType(oItem) == BASE_ITEM_SHORTBOW) || (GetBaseItemType(oItem) == BASE_ITEM_ARROW))) {     
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD) && (GetBaseItemType(oItem) == BASE_ITEM_SHORTSWORD)) {   
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER) && (GetBaseItemType(oItem) == BASE_ITEM_RAPIER)) {     
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR) && (GetBaseItemType(oItem) == BASE_ITEM_SCIMITAR)) {   
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD) && (GetBaseItemType(oItem) == BASE_ITEM_LONGSWORD)) {    
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD) && (GetBaseItemType(oItem) == BASE_ITEM_GREATSWORD)) {   
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE) && (GetBaseItemType(oItem) == BASE_ITEM_HANDAXE)) {    
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE) && (GetBaseItemType(oItem) == BASE_ITEM_THROWINGAXE)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE) && (GetBaseItemType(oItem) == BASE_ITEM_BATTLEAXE)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE) && (GetBaseItemType(oItem) == BASE_ITEM_GREATAXE)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD) && (GetBaseItemType(oItem) == BASE_ITEM_HALBERD)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER) && (GetBaseItemType(oItem) == BASE_ITEM_LIGHTHAMMER)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL) && (GetBaseItemType(oItem) == BASE_ITEM_LIGHTFLAIL)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER) && (GetBaseItemType(oItem) == BASE_ITEM_WARHAMMER)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL) && (GetBaseItemType(oItem) == BASE_ITEM_HEAVYFLAIL)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_KAMA) && (GetBaseItemType(oItem) == BASE_ITEM_KAMA)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI) && (GetBaseItemType(oItem) == BASE_ITEM_KUKRI)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN) && (GetBaseItemType(oItem) == BASE_ITEM_SHURIKEN)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE) && (GetBaseItemType(oItem) == BASE_ITEM_SCYTHE)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_KATANA) && (GetBaseItemType(oItem) == BASE_ITEM_KATANA)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD) && (GetBaseItemType(oItem) == BASE_ITEM_BASTARDSWORD)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE) && (GetBaseItemType(oItem) == BASE_ITEM_DIREMACE)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE) && (GetBaseItemType(oItem) == BASE_ITEM_DOUBLEAXE)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD) && (GetBaseItemType(oItem) == BASE_ITEM_TWOBLADEDSWORD)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE) && (GetBaseItemType(oItem) == BASE_ITEM_DWARVENWARAXE)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_WHIP) && (GetBaseItemType(oItem) == BASE_ITEM_WHIP)) {
        _gvd_CopyItemToPC(oItem);       
      } else if (GetHasFeat(FEAT_WEAPON_FOCUS_TRIDENT) && (GetBaseItemType(oItem) == BASE_ITEM_TRIDENT)) {
        _gvd_CopyItemToPC(oItem);       
      }

      // next item
      oItem = GetNextItemInInventory(oInventory);
  
    }

  }
    
}

//----------------------------------------------------------------
void gsInitialize()
{
    SetCommandable(TRUE);
    Log(INIT, "Checking if new character");

    object oHide = gsPCGetCreatureHide();
    if (! GetIsObjectValid(oHide))
    {
        if (GetHitDice(OBJECT_SELF) == 1)
        {
            Log(INIT, "New character");

            // Clear the subrace field.
            SetSubRace(OBJECT_SELF, "");

            // Check if character is valid.
            Log(INIT, "Calling character checker");
            ExecuteScript( "mi_checker_1", OBJECT_SELF);

            //remove gold
            TakeGoldFromCreature(GetGold(), OBJECT_SELF, TRUE);

            //remove inventory
            Log(INIT, "Destroying inventory");
            gsCMDestroyInventory();

            //remove tail
            Log(INIT, "Removing tail and wings");
            SetCreatureTailType(CREATURE_TAIL_TYPE_NONE);

            //remove wings
            SetCreatureWingType(CREATURE_WING_TYPE_NONE);
        }

        //clean inventory
        else
        {
            // Should never really be hit - if they don't have a GS hide they
            // should be level 1.  Exceptions are probably hackers.
            Log(INIT, "Cleaning inventory");
            string sItemStripScript = GetLocalString(GetModule(), "GS_ITEM_STRIP_SCRIPT");

            if (sItemStripScript != "") ExecuteScript(sItemStripScript, OBJECT_SELF);
        }

        //create base inventory
        Log(INIT, "Creating base inventory");
        DelayCommand(0.5, gsCreateBaseInventory());
        DelayCommand(0.6, gvdCreateBaseInventoryForClass());

        //subrace selection
        // Changed by Mithreas to use Z-Dialog.
        Log(INIT, "Calling subrace selection");
		GiveGoldToCreature(OBJECT_SELF, 250);
        SetLocalString(OBJECT_SELF, "dialog", "zdlg_pc_init");
        DelayCommand(2.0, ActionStartConversation(OBJECT_SELF, "zdlg_converse", TRUE, FALSE));
    }
    else
    {
        //clean inventory
        if (GetHitDice(OBJECT_SELF) == 1)
        {
            // ensure relevelled PCs don't lose their gear here
            if (GetLocalInt(oHide, "RELEVEL_OVERRIDE_ITEM_CLEAN_SCRIPT") != 1) {

              // Hacker protection.  Just in case they get smart enough to create
              // a creature that has the right creature armour item.
              Log(INIT, "Cleaning inventory");
              string sItemStripScript = GetLocalString(GetModule(), "GS_ITEM_STRIP_SCRIPT");

              if (sItemStripScript != "") ExecuteScript(sItemStripScript, OBJECT_SELF);

            }

        }
    }

    //listener - REMOVED BY Mithreas - using nwnx_chat instead.
    //gsLICreateListener(OBJECT_SELF);

    SendMessageToPC(OBJECT_SELF, GS_T_16777216);

    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    // Added by Mithreas - report if election in progress.
    if (miCZIsElectionInProgress(OBJECT_SELF))
    {
      FloatingTextStringOnCreature("Leadership challenge in progress!", OBJECT_SELF);
    }
}
//----------------------------------------------------------------
void main()
{
    object oPC = OBJECT_SELF;
    Log(INIT, "Checking if PC is initialised");
    if (GetLocalInt(oPC, "GS_ENABLED") == TRUE) return;
    SetCommandable(TRUE);

    Log(INIT, "Not initialised.  Restore spell uses.");
    //spelltracker
    gsSPTActionApply();

    Log(INIT, "Initialising PC");
    ActionDoCommand(gsInitialize());
    SetCommandable(FALSE);
}
