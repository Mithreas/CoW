//::///////////////////////////////////////////////
//:: CONTAINER library
//:: inc_container
//:://////////////////////////////////////////////
/*
    Library to hold functions relating to
    persitant container management for the
    PW world of Arelith.
*/
//:://////////////////////////////////////////////
//:: Created By: Space Pirate
//:: Created On: March 26, 2009
//:://////////////////////////////////////////////

#include "inc_database"
#include "inc_xfer"
#include "inc_stacking"

// Database table needs to have the following schema:
/*
   gs_container_data
   container_id     VARCHAR(16)
   item_number      INT(11)
   item             blob
*/

// The following var name starts with an underscore.  We've hacked nwnx_fixes
// to only prevent stacking of items where they have a var that starts with an
// underscore.
const string SLOT_VAR = "_SP_CO_ITEM_SLOT";

struct gsCOResults
{
    int nSaved;
    int nOverflowed;
    int nGold;
};

const int GS_LIMIT_DEFAULT = 20;

const string CO = "CONTAINER";  // for Tracing

//load nLimit objects from database sID to oContainer.  Shops have a slightly
//different logic.
void gsCOLoad(string sID, object oContainer, int nLimit = GS_LIMIT_DEFAULT, int bShop = FALSE);
//save nLimit objects within oContainer to database sID. Returns the actual
//number of items saved.  Shops have slightly different logic.
struct gsCOResults gsCOSave(string sID, object oContainer, int nLimit = GS_LIMIT_DEFAULT, int bShop = FALSE);
//remove the oItem from oContainer with sID
void spCORemove(string sID, object oContainer, object oItem);
// Saves the contents of oContainer's inventory in the form of local variables.
// Should be used for loot containers.
void fbCOSaveInventory(object oContainer);


//----------------------------------------------------------------
void gsCOLoad(string sID, object oContainer, int nLimit = GS_LIMIT_DEFAULT, int bShop = FALSE)
{
    if (GetIsObjectValid(oContainer) && GetHasInventory(oContainer))
    {
        // convert to uppercase
        sID = GetStringUpperCase(sID);

        int nSlot = -1;
        int nPos  = 1;
        string sSlot, sSQL;
        string sUseID     = SQLEncodeSpecialChars(sID);
        string sItemCache = "#";
        object oItem;

        // Special case: Loot containers for different modules, SERVER_ISLAND (surface) is the default and has no prefix, others do
        if (GetStringLeft(sID, 12) == "GS_INVENTORY")
        {
          if (miXFGetCurrentServer() == SERVER_UNDERDARK)
          {
            sUseID = "UD_" + sUseID;
          }
          else if (miXFGetCurrentServer() == SERVER_CORDOR) // currently the same as UD, but leave it here in case we ever seperate the two servers again
          {
            sUseID = "CR_" + sUseID;
          }
          else if (miXFGetCurrentServer() == SERVER_DISTSHORES)
          {
            sUseID = "DS_" + sUseID;
          }
        }

        SQLExecDirect("SELECT item_number FROM gs_container_data WHERE UPPER(container_id)='" + sUseID + "' ORDER BY item_number ASC");

        if (!SQLFetch())
        {
          return;
        }

        nSlot = StringToInt(SQLGetData(1));

        for (; nPos <= nLimit; nPos++)
        {
            if (nSlot == nPos)
            {
                sItemCache += "*";
                SQLFetch();
                nSlot = StringToInt(SQLGetData(1));
            }
            else
            {
                sItemCache += ".";
            }
        }

        nSlot = 0;
        string sItem;
        object oTempItem;

        while (nSlot < nLimit)
        {
            nSlot = FindSubString(sItemCache, "*", nSlot + 1);

            if (nSlot == -1) break;

            sSlot = IntToString(nSlot);

            sSQL = "SELECT item FROM gs_container_data WHERE UPPER(container_id)='" + sUseID + "' AND item_number='" + sSlot + "'";
            SQLExecStatement(sSQL);

            if (SQLFetch()) {
              oItem = NWNX_SQL_ReadFullObjectInActiveRow(0, oContainer);
              if(GetIsObjectValid(oItem))
              {
                if(bShop)
                {
                    string sOldTag = GetLocalString(oItem, NO_STACK_TAG);
                    string sCurrentTag = GetTag(oItem);
                    if(GetStringLeft(sOldTag, 6) == "GS_SH_")
                    {
                        RemoveItemNoStack(oItem);
                        DeleteLocalString(oItem, NO_STACK_TAG);
                    }
                    else if(GetStringLeft(GetTag(oItem), 6) != "GS_SH_")
                    {
                        SetLocalString(oItem, "SHOP_BUG_TAG", GetTag(oItem));
                        SetTag(oItem, "GS_SH_" + GetTag(oItem));
                    }

                }
              }
              SetLocalInt(oItem, SLOT_VAR, nSlot);

              if (GetIsObjectValid(oItem))
              {
                if (GetResRef(oItem) == "nw_it_gold001") // Legacy
                {
                    DestroyObject(oItem);
                }
                else
                {
                  SetStolenFlag(oItem, bShop);
                }
              }
            }
        }

        if (GetStringLeft(GetTag(oContainer), 12) == "GS_INVENTORY")
        {
            fbCOSaveInventory(oContainer);
        }

        SetLocalString(oContainer, "SP_CO_ITEMSTRING", sItemCache);
    }
}
//----------------------------------------------------------------
struct gsCOResults gsCOSave(string sID, object oContainer, int nLimit = GS_LIMIT_DEFAULT, int bShop = FALSE)
{
    struct gsCOResults stResults;

    if (GetIsObjectValid(oContainer) && GetHasInventory(oContainer))
    {

        // convert to uppercase
        sID = GetStringUpperCase(sID);

        int nSlot, nNth;
        object oItem = GetFirstItemInInventory(oContainer);
        string sItemCache = GetLocalString(oContainer, "SP_CO_ITEMSTRING");
        string sNth, sSQL, sSlot = "";
        string sUseID = SQLEncodeSpecialChars(sID);

        // Special case: Loot containers for different modules, SERVER_ISLAND (surface) is the default and has no prefix, others do
        if (GetStringLeft(sID, 12) == "GS_INVENTORY")
        {
          if (miXFGetCurrentServer() == SERVER_UNDERDARK)
          {
            sUseID = "UD_" + sUseID;
          }
          else if (miXFGetCurrentServer() == SERVER_CORDOR) // currently the same as UD, but leave it here in case we ever seperate the two servers again
          {
            sUseID = "CR_" + sUseID;
          }
          else if (miXFGetCurrentServer() == SERVER_DISTSHORES)
          {
            sUseID = "DS_" + sUseID;
          }
        }

        if (sItemCache == "")
        {
          sItemCache = "#";
          int nI     = 0;
          for (; nI < nLimit; nI++)
          {
            sItemCache += ".";
          }
        }

        while (GetIsObjectValid(oItem) && nNth < nLimit)
        {
            if (GetResRef(oItem) == "nw_it_gold001")
            {
                stResults.nGold += GetItemStackSize(oItem);
                DestroyObject(oItem);
                nNth--;
            }
            // No slot so this is a new item!
            else if (GetLocalInt(oItem, SLOT_VAR) == 0)
            {
                nSlot = FindSubString(sItemCache, ".");

                if (nSlot != -1)
                {
                    sSlot = IntToString(nSlot);

                    sItemCache = GetStringLeft(sItemCache, nSlot) + "*" +
                                 GetStringRight(sItemCache, GetStringLength(sItemCache) - nSlot - 1);

                    //Set which slot this is in before writing it to the DB!
                    SetLocalInt(oItem, SLOT_VAR, nSlot);
                    SetStolenFlag(oItem, !bShop);

                    sSQL = "INSERT INTO gs_container_data (container_id,item_number,item, is_base64) VALUES" + "('" + sUseID + "','" + sSlot + "', ?, '1')";
                    NWNX_SQL_PrepareQuery(sSQL);
                    NWNX_SQL_PreparedObjectFull(0, oItem);
                    NWNX_SQL_ExecutePreparedQuery();

                    SetStolenFlag(oItem, bShop);
                    SetLocalString(oContainer, "SP_CO_ITEMSTRING", sItemCache);
                }
            }

            oItem = GetNextItemInInventory(oContainer);
            nNth++;
        }

        stResults.nSaved = nNth;
        while (GetIsObjectValid(oItem)) {
            stResults.nOverflowed++;
            oItem = GetNextItemInInventory(oContainer);
        }


        if (GetStringLeft(GetTag(oContainer), 12) == "GS_INVENTORY")
        {
            fbCOSaveInventory(oContainer);
        }
    }
    return stResults;
}
//----------------------------------------------------------------
void spCORemove(string sID, object oContainer, object oItem)
{
    // convert to uppercase
    sID = GetStringUpperCase(sID);
    int nSlot         = GetLocalInt(oItem, SLOT_VAR);
    string sSlot      = IntToString(nSlot);
    string sItemCache = GetLocalString(oContainer, "SP_CO_ITEMSTRING");
    string sUseID     = SQLEncodeSpecialChars(sID);

    // Special case: Loot containers for different modules, SERVER_ISLAND (surface) is the default and has no prefix, others do
    if (GetStringLeft(sID, 12) == "GS_INVENTORY")
    {
      if (miXFGetCurrentServer() == SERVER_UNDERDARK)
      {
        sUseID = "UD_" + sUseID;
      }
      else if (miXFGetCurrentServer() == SERVER_CORDOR) // currently the same as UD, but leave it here in case we ever seperate the two servers again
      {
        sUseID = "CR_" + sUseID;
      }
      else if (miXFGetCurrentServer() == SERVER_DISTSHORES)
      {
        sUseID = "DS_" + sUseID;
      }
    }

    // No slot
    string sCheck;
    if (nSlot == 0)
    {
	  //------------------------------------------------------------------------------
      // If it's gold, it's all good. Otherwise, it suggests that the removed item
	  // stacked, meaning we lost access to its slot variable, or was never saved in
	  // the first place.  Check for stacking first and clean up the database entry.
	  //------------------------------------------------------------------------------
      if (GetResRef(oItem) != "nw_it_gold001")
      {
        Error(CO, "Item had no slot assigned, container ID was " + sID + ".");

        // Loop through all the items still in the container, to find which slot was 
		// removed.
        if (sID != "" && GetIsObjectValid(oContainer))
        {
          object oChest = GetFirstItemInInventory(oContainer);

          while(GetIsObjectValid(oChest))
          {
              sCheck += "," + IntToString(GetLocalInt(oChest, SLOT_VAR));
              oChest = GetNextItemInInventory(oContainer);
          }
          sCheck += ",";
          int nLimit = GetLocalInt(oContainer, "GS_LIMIT");

          if (! nLimit) nLimit = GS_LIMIT_DEFAULT;
          int x;

          for(x = 1; x <= nLimit; x++)
          {
            if(FindSubString(sCheck, ","+IntToString(x)+",") == -1) //not found so it must had been the item removed
            {
                 SQLExecStatement("SELECT * FROM gs_container_data WHERE UPPER(container_id)=? AND item_number=?", sUseID, IntToString(x));
                 if(SQLFetch()) //item found for that number
                 {
                    sItemCache = GetStringLeft(sItemCache, x) + "." +
                     GetStringRight(sItemCache, GetStringLength(sItemCache) - x- 1);

                    SQLExecDirect("DELETE FROM gs_container_data WHERE UPPER(container_id)='" + sUseID + "' " + "AND item_number='" + IntToString(x) + "'");
                    SetLocalString(oContainer, "SP_CO_ITEMSTRING", sItemCache);
                    return; //only one item can be removed at a time.
                 }

            }
          }
        }
      }
	  
	  // If we have not already returned, then the item was never saved.  In this 
	  // case there is nothing to do, so we can return safely. 
      return;
    }

    if (sID != "" && GetIsObjectValid(oContainer))
    {
        if(GetLocalInt(oItem, "_nostack") == 0 && GetLocalInt(oItem, "_NOSTACK") == 0 && GetLocalInt(oItem, "_RANDOM") == 0)
        {
            RemoveItemNoStack(oItem);
            DeleteLocalString(oItem, NO_STACK_TAG);
        }
        sItemCache = GetStringLeft(sItemCache, nSlot) + "." +
                     GetStringRight(sItemCache, GetStringLength(sItemCache) - nSlot - 1);

        SQLExecDirect("DELETE FROM gs_container_data WHERE UPPER(container_id)='" + sUseID + "' " + "AND item_number='" + sSlot + "'");
        SetLocalString(oContainer, "SP_CO_ITEMSTRING", sItemCache);
    }

    DeleteLocalInt(oItem, SLOT_VAR);
}
//----------------------------------------------------------------
void fbCOSaveInventory(object oContainer)
{
  object oItem = GetFirstItemInInventory(oContainer);
  int nCount   = 0;
  while (GetIsObjectValid(oItem))
  {
    SetLocalObject(oContainer, "FB_CO_TREASURE_" + IntToString(nCount), oItem);
    nCount++;
    oItem = GetNextItemInInventory(oContainer);
  }

  SetLocalInt(oContainer, "FB_CO_TREASURE_COUNT", nCount);
}
