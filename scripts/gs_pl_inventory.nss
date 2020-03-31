#include "inc_common"
#include "inc_time"
#include "inc_loot"
#include "inc_log"

const int GS_TIMEOUT            =  3600; //1 RL hour
const int GS_LIMIT_GOLD         =  2000;
const int GS_LIMIT_MIN_LOW      =    75;
const int GS_LIMIT_VALUE_VLOW   =  1000;
const int GS_LIMIT_VALUE_LOW    =  5000;
const int GS_LIMIT_VALUE_MEDIUM = 15000;
const int GS_LIMIT_VALUE_HIGH   = 999999;
const int GS_LIMIT_ITEM_LOW     =     2;
const int GS_LIMIT_ITEM_MEDIUM  =     3;
const int GS_LIMIT_ITEM_HIGH    =     4;


const string MIMIC = "MIMICLOG";   //:: For tracing
void spawnMimic(int nTimestamp, int nTimeout);


void main()
{
    //timeout
    int nTimestamp = gsTIGetActualTimestamp();
    int nTimeout   = GetLocalInt(OBJECT_SELF, "GS_TIMEOUT");
    int nOpened    = ! GetIsObjectValid(GetLastKiller());
    string sTag    = GetTag(OBJECT_SELF);
    object opener = GetLastOpenedBy();

    object oPC;

    //::  Added by AR: Spawn Mimic if flagged, 5% chance
    //::  Make sure it only spawns for Medium and High Chests.
    //::  Also Destroy Chest!
    //::  Note:  This will only occur once!  If the chest is destroyed or if a mimic
    //::         is spawned it will never happen again during this server instance.
    if (nTimeout < nTimestamp || !nOpened)
    {
        int nMimic      = GetLocalInt(OBJECT_SELF, "AR_MIMIC");
        int bValidChest = sTag == "GS_TREASURE_LOW" || sTag == "GS_TREASURE_MEDIUM" || sTag == "GS_TREASURE_HIGH";
        if ( GetLocalInt(OBJECT_SELF, "AR_DISABLED") )  return; //::  Just for safety as there is a slight delay on destroying the chest
        if ( bValidChest && d20() <= nMimic ) {
            SetLocalInt(OBJECT_SELF, "AR_DISABLED", TRUE);
            spawnMimic(nTimestamp, nTimeout);
            return;
        }
    }

    if (nTimeout < nTimestamp)
    {
        oPC = GetLastOpenedBy();

        if (sTag == "GS_GOLD_HIGH")
        {
          gsCMCreateGold(Random(1000) + 1001);
        }
        else if (sTag == "GS_GOLD_MEDIUM")
        {
          gsCMCreateGold(Random(750) + 251);
        }
        else if (sTag == "GS_GOLD_LOW")
        {
          gsCMCreateGold(Random(200) + 75);
        }
        else
        {
            string sTagInventory = sTag;
            int nLimitValue      = GS_LIMIT_VALUE_HIGH;
            int nLimitItem       = GS_LIMIT_ITEM_LOW;
            int nNth             = GetStringLength(sTag);

            //determine item value range
            if (GetStringRight(sTag, 5) == "_VLOW")
            {
                nLimitValue   = GS_LIMIT_VALUE_VLOW;
                nLimitItem    = GS_LIMIT_ITEM_LOW;
                sTagInventory = GetStringLeft(sTag, nNth - 5);
            }
            else if (GetStringRight(sTag, 4) == "_LOW")
            {
                nLimitValue   = GS_LIMIT_VALUE_LOW;
                nLimitItem    = GS_LIMIT_ITEM_LOW;
                sTagInventory = GetStringLeft(sTag, nNth - 4);
            }
            else if (GetStringRight(sTag, 7) == "_MEDIUM")
            {
                nLimitValue   = GS_LIMIT_VALUE_MEDIUM;
                nLimitItem    = GS_LIMIT_ITEM_MEDIUM;
                sTagInventory = GetStringLeft(sTag, nNth - 7);
            }
            else if (GetStringRight(sTag, 5) == "_HIGH")
            {
                // Batra: 1% chance for any given _HIGH treasure chest to contain an artefact.
                if (d100() == 13) ExecuteScript("gs_pl_inv_unique", OBJECT_SELF);
                nLimitValue   = GS_LIMIT_VALUE_HIGH;
                nLimitItem    = GS_LIMIT_ITEM_HIGH;
                sTagInventory = GetStringLeft(sTag, nNth - 5);
            }

            else if (GetStringRight(sTag, 7) == "_UNIQUE")
            {
                nLimitValue   = GS_LIMIT_VALUE_HIGH;
                nLimitItem    = GS_LIMIT_ITEM_HIGH;
                sTagInventory = GetStringLeft(sTag, nNth - 7);
            }

            nNth                 = GetStringLength(sTagInventory);
            sTagInventory        = "GS_INVENTORY_" + GetStringRight(sTagInventory, nNth - 3);
            object oInventory    = GetObjectByTag(sTagInventory);



            if (GetIsObjectValid(oInventory))
            {
                object oItem = GetFirstItemInInventory(oInventory);

                if (GetIsObjectValid(oItem))
                {
                    int nGold  = 0;
                    int nValue = 0;
                    int nCount = 0;

                    //generate item list
                    do
                    {
                        nValue = gsCMGetItemValue(oItem);

                        if (nValue <= nLimitValue || Random(100) == 99)
                        {
                            nGold = (nGold + nValue) / 2;

                            SetLocalObject(
                                oInventory,
                                "GS_PL_INVENTORY_ITEM_" + IntToString(nCount++),
                                oItem);
                        }

                        oItem = GetNextItemInInventory(oInventory);
                    }
                    while (GetIsObjectValid(oItem));

                    //create item
                    if (nOpened)
                    {
                        object oCopy   = OBJECT_INVALID;
                        int nItemLimit = Random(nLimitItem + 1);

                        int nSearchBonus = GetSkillRank(14, oPC);

                        if (nSearchBonus >= Random(100)) 
                        {
                            nItemLimit += 1;
                            SendMessageToPC(oPC, "You have discovered some extra treasure here!");
                        }

                        for (nNth = 0; nNth < nItemLimit; nNth++)
                        {
                            oItem = GetLocalObject(
                                oInventory,
                                "GS_PL_INVENTORY_ITEM_" + IntToString(Random(nCount)));
                            oCopy = gsCMCopyItem(oItem, OBJECT_SELF, TRUE);

                            if (GetIsObjectValid(oCopy))
                            {
                                SetIdentified(oCopy, gsCMGetItemValue(oCopy) <= 100);
                                SetStolenFlag(oCopy, FALSE);
                            }
                        }
                    }

                    //create gold
                    nGold /= 10;
                    if (nGold > GS_LIMIT_GOLD) nGold = GS_LIMIT_GOLD;
                    gsCMCreateGold(Random(nGold));

                    if (GetStringRight(sTag, 5) == "_HIGH")
                    {
                        CreateLoot(LOOT_CONTEXT_CHEST_HIGH, OBJECT_SELF, opener);
                    }
                    else if (GetStringRight(sTag, 7) == "_MEDIUM")
                    {
                        CreateLoot(LOOT_CONTEXT_CHEST_MEDIUM, OBJECT_SELF, opener);
                    }
                    else if (GetStringRight(sTag, 4) == "_LOW")
                    {
                        CreateLoot(LOOT_CONTEXT_CHEST_LOW, OBJECT_SELF, opener);
                    }
                }
            }

            // check for chest specific treasure, and spawn those as well
            int iTreasureExtra = GetLocalInt(OBJECT_SELF, "GVD_TREASURE");
            string sTreasureExtraResRef;
            string sTreasureExtraQty;
            int iTreasureExtraQty;

            while (iTreasureExtra > 0) {
              sTreasureExtraResRef = GetLocalString(OBJECT_SELF, "GVD_TREASURE_RESREF" + IntToString(iTreasureExtra));
              
              if (sTreasureExtraResRef != "") {
                // the qty is stored as a formula on the chest, so it's a string (i.e. "d(4)+1")
                sTreasureExtraQty = GetLocalString(OBJECT_SELF, "GVD_TREASURE_QTY" + IntToString(iTreasureExtra));
                iTreasureExtraQty = gvd_Eval(sTreasureExtraQty);

                // spawn the qty of items
                if (iTreasureExtraQty > 0) {
                  CreateItemOnObject(sTreasureExtraResRef, OBJECT_SELF, iTreasureExtraQty);
                }
                                
              }              

              // next item
              iTreasureExtra = iTreasureExtra - 1;
            }

        }

        if (nOpened)
        {
            nTimestamp += GS_TIMEOUT;
            SetLocalInt(OBJECT_SELF, "GS_TIMEOUT", nTimestamp);
            if(GetLockLockable(OBJECT_SELF) && !GetLocalInt(GetModule(), "STATIC_LEVEL") && ( GetStringLeft(GetTag(OBJECT_SELF), 11) == "GS_TREASURE" ||
                GetStringLeft(GetTag(OBJECT_SELF), 8) == "GS_ARMOR" ||
                GetStringLeft(GetTag(OBJECT_SELF), 9) == "GS_WEAPON" ||
                GetStringLeft(GetTag(OBJECT_SELF), 7) == "GS_GOLD"))
            {
                int nChance;
                if(GetStringRight(GetTag(OBJECT_SELF), 4) == "_LOW")
                    nChance = 75;
                else if(GetStringRight(GetTag(OBJECT_SELF), 5) == "_HIGH")
                    nChance = 25;
                else if(GetStringRight(GetTag(OBJECT_SELF), 7) == "_MEDIUM")
                    nChance = 50;

                if(nChance > 0 && d100() > nChance)
                    SetLocalInt(OBJECT_SELF, "md_lockme", 1);
            }
            return;
        }
    }

    if (! nOpened)
    {
        string sTag = GetTag(OBJECT_SELF);

        if (! nTimeout || nTimeout < nTimestamp) nTimeout = nTimestamp + GS_TIMEOUT;

        if (sTag == "GS_TREASURE_LOW")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_TREASURE_LOW,    nTimeout);
        else if (sTag == "GS_TREASURE_MEDIUM")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_TREASURE_MEDIUM, nTimeout);
        else if (sTag == "GS_TREASURE_HIGH")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_TREASURE_HIGH,   nTimeout);
        else if (sTag == "GS_WEAPON_LOW")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_WEAPON_LOW,      nTimeout);
        else if (sTag == "GS_WEAPON_MEDIUM")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_WEAPON_MEDIUM,   nTimeout);
        else if (sTag == "GS_WEAPON_HIGH")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_WEAPON_HIGH,     nTimeout);
        else if (sTag == "GS_ARMOR_LOW")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_ARMOR_LOW,       nTimeout);
        else if (sTag == "GS_ARMOR_MEDIUM")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_ARMOR_MEDIUM,    nTimeout);
        else if (sTag == "GS_ARMOR_HIGH")
            gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_ARMOR_HIGH,      nTimeout);
        else
            gsCMCreateRecreator(nTimeout);
    }

}

void spawnMimic(int nTimestamp, int nTimeout) {
    //::  Logging for testing
    Log(MIMIC, "A Mimic was spawned in " + GetName(GetArea(OBJECT_SELF)) + ".");

    //::  Copied code from Above as if chest was destroyed
    string sTag = GetTag(OBJECT_SELF);
    if (! nTimeout || nTimeout < nTimestamp) nTimeout = nTimestamp + GS_TIMEOUT;

    if (sTag == "GS_TREASURE_MEDIUM")
        gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_TREASURE_MEDIUM, nTimeout);
    else if (sTag == "GS_TREASURE_HIGH")
        gsCMCreateRecreatorByType(GS_CM_TEMPLATE_TYPE_TREASURE_HIGH,   nTimeout);

    //::  Spawn Mimic and give it some loot based on Chest Tag!
    location lLoc = GetLocation(OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1), lLoc);
    string sResRef = sTag == "GS_TREASURE_MEDIUM" ? "ar_mimic_low" : "ar_mimic_high";
    object oMimic = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLoc);

    //::  Medium
    if (sTag == "GS_TREASURE_MEDIUM") {
        gsCMCreateGold(Random(1000) + 1001, oMimic);
        CreateItemOnObject("it_gem006", oMimic);    //::  Diamond

        if (d3() != 1) CreateItemOnObject("ar_lantern", oMimic);    //::  Djinn Lantern
    }
    //::  High
    else {
        gsCMCreateGold(Random(1200) + 2001, oMimic);
        CreateItemOnObject("it_gem013", oMimic);    //::  Emerald

        if (d3() != 1) CreateItemOnObject("ar_lantern", oMimic);    //::  Djinn Lantern
        if (d3() != 1) CreateItemOnObject("gs_item886", oMimic);    //::  Portal Lens
    }

    //::  Destroy Chest!
    DestroyObject(OBJECT_SELF, 0.2);
}
