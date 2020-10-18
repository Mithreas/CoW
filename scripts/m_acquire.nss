#include "inc_common"
#include "inc_container"
#include "inc_istate"
#include "inc_shop"
#include "inc_text"
#include "inc_theft"
#include "inc_time"
#include "inc_xp"
#include "inc_itemupdates"
#include "inc_divination"
#include "inc_log"
#include "inc_factions"
#include "inc_disguise"
#include "inc_chatutils"
#include "inc_stacking"

const int GS_TIMEOUT = 300; //5 minutes
const string ACQUIRE = "ACQUIRE"; // For tracing

const string GS_TEMPLATE_CORPSE_FEMALE = "gs_item016";
const string GS_TEMPLATE_CORPSE_MALE   = "gs_item017";

// Blade Orb goes off - moved to its own function to avoid repeating code
void miBladeOrb(object oAcquiredBy, object oAcquired = OBJECT_INVALID)
{
  // Edit by Mithreas - reversed the order of the following
  // two lines, as the de-stealth appeared to fire
  // intermittently.
  AssignCommand(oAcquiredBy, ClearAllActions(TRUE));
  SetActionMode(oAcquiredBy, ACTION_MODE_STEALTH, FALSE);

  ApplyEffectToObject(DURATION_TYPE_INSTANT,
                      EffectVisualEffect(VFX_IMP_DISEASE_S),
                      oAcquiredBy);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                      EffectAbilityDecrease(ABILITY_CONSTITUTION, d6(1)),
                      oAcquiredBy);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                      EffectAbilityDecrease(ABILITY_DEXTERITY, d6(1)),
                      oAcquiredBy);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                      EffectAbilityDecrease(ABILITY_STRENGTH, d6(1)),
                      oAcquiredBy);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                      EffectLinkEffects(EffectLinkEffects(EffectCutsceneParalyze(),
                                                          EffectVisualEffect(VFX_DUR_PARALYZED)),
                                        EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE)),
                      oAcquiredBy,
                      RoundsToSeconds(10));

  if (GetIsObjectValid(oAcquired))
  {
    DestroyObject(oAcquired);
  }
}

void main()
{
    object oAcquiredBy   = GetModuleItemAcquiredBy();
    object oAcquiredFrom = GetModuleItemAcquiredFrom();
    object oAcquired     = GetModuleItemAcquired();
    string sTag          = ConvertedStackTag(oAcquired);
    string sResRef       = GetResRef(oAcquired);

    DeleteLocalInt(oAcquired, "GS_STORE");
    UpdateItem(oAcquired);

    gsISInitializeItemState(oAcquired);
    if (gsISGetIsIllegalItem(oAcquired)) return;

    // Set the item's ILR if it's not already set.
	SetItemILR(oAcquired);

    if (!GetIdentified(oAcquired) && GetLocalInt(oAcquired, "ID_ATTEMPTED"))
    {
      int nStack = GetItemStackSize(oAcquired);
      int nItemValue = gsCMGetItemValue(oAcquired);
      if (nStack)
        nItemValue /= nStack;

      int nMyLore = GetSkillRank(SKILL_LORE, oAcquiredBy);
      if (nMyLore > 55)
        nMyLore = 55;   // Highest row in 2da table
      int nChkLore = GetLocalInt(oAcquiredBy, "MI_IDENTIFY_LORE");
      int nMaxValue = GetLocalInt(oAcquiredBy, "MI_MAX_IDENTIFY_VALUE");

      if (nMyLore != nChkLore)
      {
        string sMaxValue = Get2DAString("skillvsitemcost", "DeviceCostMax", nMyLore);
        if (sMaxValue == "")   nMaxValue = 120000000;
        else  nMaxValue = StringToInt(sMaxValue);

        SetLocalInt(oAcquiredBy, "MI_IDENTIFY_LORE", nMyLore);
        SetLocalInt(oAcquiredBy, "MI_MAX_IDENTIFY_VALUE", nMaxValue);
      }

      if (nItemValue <= nMaxValue) SetIdentified(oAcquired, TRUE);
      SetLocalInt(oAcquired, "ID_ATTEMPTED", TRUE);
    }

    //shop
    int bShop = FALSE; // used later
    if (GetStringLeft(GetTag(oAcquired), 6) == "GS_SH_")      //we want to use the real tag here
    {
        bShop = TRUE;
        oAcquiredFrom = GetLocalObject(oAcquired, "GS_SH_CONTAINER");
        string sFID   = md_SHLoadFacID(oAcquiredFrom);

        if (GetIsDM(oAcquiredBy) ||
            gsSHGetIsVacant(oAcquiredFrom) ||
            gsSHGetIsOwner(oAcquiredFrom, oAcquiredBy) ||
            (fbFAGetFactionNameDatabaseID(sFID) != "" && md_SHLoadFacABL(ABL_B_TKI, oAcquiredFrom) && md_GetHasPowerShop(MD_PR_RIS, oAcquiredBy, sFID)))
        {
            SetLocalInt(oAcquiredFrom, "MD_SH_INV_DIS", 1);
            gsSHExportItem(oAcquired, oAcquiredBy);
        }
        else
        {
            SetStolenFlag(oAcquired, FALSE);
            object oCopy = gsCMCopyItem(oAcquired, oAcquiredFrom, TRUE);

            if (GetIsObjectValid(oCopy))
            {
                SetStolenFlag(oCopy, TRUE);
                DestroyObject(oAcquired);

                string sCDKey = GetPCPublicCDKey(oAcquiredBy, TRUE);
                if ((sCDKey != "") &&
                    (GetLocalString(oAcquired, sCDKey) != "") &&
                    (GetLocalString(oAcquired, sCDKey) != gsPCGetPlayerID(oAcquiredBy)) )
                {
                  SendMessageToPC(oAcquiredBy, "A previous character on your account has once owned this item.");
                }
                else
                {
                  SetLocalObject(oAcquiredBy, "GS_SH_ITEM", oCopy);
                  SetLocalString(oAcquiredBy, "zzdlgCurrentDialog", "zz_co_shtrade");
                  AssignCommand(oAcquiredFrom, ActionStartConversation(oAcquiredBy, "zzdlg_conv", TRUE, FALSE));
                }
            }
        }
    }

    //stolen items
    if (GetStolenFlag(oAcquired))
    {
        object oStolenFrom = gsTHGetStolenFrom(oAcquired);

        if (! GetIsObjectValid(oStolenFrom))
        {
            if (GetObjectType(oAcquiredFrom) == OBJECT_TYPE_CREATURE)
            {
			  int nSteal = gsTHCanStealItem(oAcquired);
			
              if (! nSteal ||
			      (nSteal == 2 && GetIsPC(oAcquiredFrom))) // Keys cannot be stolen from PCs.
              {
                object oCopy = gsCMCopyItem(oAcquired, oAcquiredFrom, TRUE);

                if (GetIsObjectValid(oCopy))
                {
                  gsTHResetStolenItem(oCopy);
                  SendMessageToPC(oAcquired, "Item is too big to steal - returning it.");
                  DestroyObject(oAcquired);
                }
              }
              else
              {
                if (sTag == "GS_BLADEORB")
                {
                  miBladeOrb(oAcquiredBy, oAcquired);
                }
                else if (GetIsPC(oAcquiredFrom))
                {
                  SendMessageToAllDMs(
                    gsCMReplaceString(
                        GS_T_16777436,
                        GetName(oAcquiredBy),
                        GetName(oAcquired),
                        GetName(oAcquiredFrom)));

                    int nTimestamp = gsTIGetActualTimestamp();
                    int nTimeout   = GetLocalInt(oAcquiredBy, "GS_TH_TIMEOUT");

                    if (nTimeout < nTimestamp)
                    {
                        miDVGivePoints(oAcquiredBy, ELEMENT_AIR, 4.0);
                        nTimeout     = nTimestamp + gsTIGetGameTimestamp(GS_TIMEOUT);

                        gsTHSetStolenFrom(oAcquired, oAcquiredFrom);
                        SetLocalInt(oAcquiredBy, "GS_TH_TIMEOUT", nTimeout);
                    }
                    else
                    {
                        nTimeout     = gsTIGetRealTimestamp(nTimeout - nTimestamp);

                        FloatingTextStringOnCreature(
                            gsCMReplaceString(
                                GS_T_16777448,
                                IntToString(nTimeout / 60),
                                IntToString(nTimeout % 60)),
                            oAcquiredBy,
                            FALSE);

                        object oCopy = gsCMCopyItem(oAcquired, oAcquiredFrom, TRUE);

                        if (GetIsObjectValid(oCopy))
                        {
                            gsTHResetStolenItem(oCopy);
                            DestroyObject(oAcquired);
                        }
                    }
                }
                else if (GetIsReactionTypeHostile(oAcquiredBy, oAcquiredFrom))
                {
                  miDVGivePoints(oAcquiredBy, ELEMENT_AIR, 4.0);

                  // Edit by Mith - give XP if successful PP from a hostile NPC.
                  float fRating = GetChallengeRating(oAcquiredFrom);
                  float fVariance = GetLocalFloat(GetModule(), GS_XP_VARIANCE_VAR);
                  if (GetHitDice(oAcquiredFrom) <=
                    GetLocalInt(GetModule(), GS_XP_MAX_PC_LEVEL_FOR_MULTIPLIER_VAR))
                      fVariance *= GetLocalFloat(GetModule(), GS_XP_VARIANCE_MULTIPLIER_VAR);
                  fRating = ((fRating/(2 * GetHitDice(oAcquiredBy))) - 0.5)/fVariance + 1.0;

                  if (fRating < 0.0)      fRating = 0.0;
                  else if (fRating > 2.0) fRating = 2.0;
                  float fExperience = 0.25 * IntToFloat(GetLocalInt(GetModule(), GS_XP_BASE_XP_VAR)) * fRating;

                  int nExperience = FloatToInt(fExperience);
                  if (nExperience <= 0)                    nExperience  = 1;
                  //else if (gsBOGetIsBossCreature(oAcquiredFrom)) nExperience *= 4;

                  gsXPGiveExperience(oAcquiredBy, nExperience, TRUE, FALSE);

                  // Don't treat items taken from hostiles as stolen (since
                  // mugging an NPC doesn't do it!)
                  gsTHResetStolenItem(oAcquired);
                }

                // Stole a treasure item. Spawn some loot.
                if (sTag == "FB_TREASURE")
                {
                  object oInventory = GetObjectByTag("GS_INVENTORY_" +
                   IntToString(GetRacialType(oAcquiredFrom)));
                  if (GetIsObjectValid(oInventory))
                  {
                    int nRating  = FloatToInt(pow(GetChallengeRating(oAcquiredFrom), 2.0));
                    int nCount   = GetLocalInt(oInventory, "FB_CO_TREASURE_COUNT");
                    object oItem = GetLocalObject(oInventory, "FB_CO_TREASURE_" +
                     IntToString(Random(nCount)));

                    // Spawn gold if item too valuable (except in 1 in 10 cases),
                    // in 1 in 3 cases, or if item invalid for whatever reason.
                    if (d3() == 1 || !GetIsObjectValid(oItem) ||
                     (gsCMGetItemValue(oItem) > nRating * 10 && d10() != 1))
                    {
                      nCount = Random(nRating) / 3;
                      GiveGoldToCreature(oAcquiredBy, nCount);
                      SetLocalInt(oAcquiredFrom, "FB_PP_GOLD", GetLocalInt(
                       oAcquiredFrom, "FB_PP_GOLD") + nCount);
                    }
                    // Got something
                    else
                    {
                      // Special case: Blade orb!
                      if (GetTag(oItem) == "GS_BLADEORB")
                      {
                        miBladeOrb(oAcquiredBy);
                      }
                      else
                      {
                        gsCMCopyItem(oItem, oAcquiredBy);
                      }
                      SetLocalInt(oAcquiredFrom, "FB_PP_COUNT", GetLocalInt(
                       oAcquiredFrom, "FB_PP_COUNT") + 1);
                    }

                    // In every case, destroy the treasure
                    DestroyObject(oAcquired);
                  }
                }

                AssignCommand(oAcquiredBy, SpeakString("GS_AI_THEFT", TALKVOLUME_SILENT_TALK));
              }
            }
        }
        else if (oAcquiredBy == oStolenFrom)
        {
            gsTHResetStolenItem(oAcquired);
        }
    }

    if (sTag == "GS_FX_gs_placeable181") //voidstone
    {
      DestroyObject(oAcquired);
      SendMessageToPC(oAcquiredBy, "The Voidstone spontaneously dissolves in a hiss of vacuum.");
      // Old code.
      /*
      if (GetTag(GetArea(oAcquiredBy)) != "GS_AREA_ENTER")
      {
        if (! FortitudeSave(oAcquiredBy, 25))
        {
          SendMessageToPC(oAcquiredBy, GS_T_16777418);
          DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT,
                              EffectLinkEffects(EffectVisualEffect(VFX_IMP_DEATH),
                                                EffectDeath()),
                              oAcquiredBy));
        } 
      }
      return;
      */
    }

    // Muling.
    if (!bShop &&
        sResRef != "gs_item038" && // Quarter keys
        !GetIsDM(oAcquiredBy))
    {
      string sCDKey = GetPCPublicCDKey(oAcquiredBy, TRUE);
      if ((sCDKey != "") &&
          (GetLocalString(oAcquired, sCDKey) != "") &&
          (GetLocalString(oAcquired, sCDKey) != gsPCGetPlayerID(oAcquiredBy)) )
      {
        //----------------------------------------------------------------------
        // This object was given away by another character owned by the same
        // CD key (i.e. player).  This is likely a muling case.
        //
        // We stop enforcing muling after a RL month.
        //----------------------------------------------------------------------
        int nTime = GetLocalInt(oAcquired, sCDKey + "_TIME"); // Time item was transferred

        //----------------------------------------------------------------------
        // When we reset the clocks and raise the epoch, this needs changing.
        // If in the future, strip timestamp.
        //----------------------------------------------------------------------
        if (nTime > gsTIGetActualTimestamp())
        {
          nTime = 0;
          DeleteLocalInt(oAcquired, sCDKey + "_TIME");
        }

        if (nTime > (gsTIGetActualTimestamp() - (60 * 60 * 24 * 28))) // Acquired in the last 28 days.
        {
          string sPlayer     = GetPCPlayerName(oAcquiredBy);
          string sIP         = GetPCIPAddress(oAcquiredBy);
          string sName       = GetName(oAcquiredBy);
          // Migration!
          if (GetLocalString(oAcquired, sCDKey) != sName)
          {
            SendMessageToPC(oAcquiredBy, "<c>Muling attempt detected!");
            string sLog = "Muling attempt detected: " + sName + " (" + sPlayer +
            ", " + sCDKey + ") from IP " + sIP + ". Item was " + GetName(oAcquired);
            Warning(ACQUIRE, sLog);
            SendMessageToAllDMs(sLog);

            // Drop item rather than destroying it. Don't do this if it came from a shop
            if (!bShop)
              CopyObject(oAcquired, GetLocation(oAcquiredBy));
            DestroyObject(oAcquired);
          }
          else
          {
            SetLocalString(oAcquired, sCDKey, gsPCGetPlayerID(oAcquiredBy));
          }
        }
        else
        {
          DeleteLocalInt(oAcquired, sCDKey);
        }
      }
    }

    // wolfsbane
    if (sTag == "MI_WOLFSBANE")
    {
      if (!GetLocalInt(oAcquired, "GS_TIMEOUT"))
      {
        SetLocalInt(oAcquired, "GS_TIMEOUT", gsTIGetActualTimestamp());
      }
    }

    if (sTag == "mi_notebook")
    {
      // If this is a notebook without a custom tag, create its
      // tag now - __ plus up to 8 digits.
      sTag += "__" + IntToString(Random(100000000));
      CopyObject(oAcquired, GetLocation(oAcquiredBy), oAcquiredBy, sTag);
      DestroyObject(oAcquired);
    }

	
    // item removed from container & general cleanup of SLOT_VAR variables.
    if(!bShop)
    {
      if (GetEventScript(oAcquiredFrom, EVENT_SCRIPT_PLACEABLE_ON_OPEN) == "gs_co_open" || (GetEventScript(oAcquiredFrom, EVENT_SCRIPT_PLACEABLE_ON_CLOSED) == "gs_co_close"))
      {
        string sFrom = GetLocalString(oAcquiredFrom, "MD_OPN_ID");
        if(sFrom == "") sFrom = GetTag(oAcquiredFrom);

        spCORemove(sFrom, oAcquiredFrom, oAcquired);
      }
      else
        DeleteLocalInt(oAcquired, SLOT_VAR);
    }


    // corpse picked up
    if (sResRef == GS_TEMPLATE_CORPSE_MALE ||
        sResRef == GS_TEMPLATE_CORPSE_FEMALE)
    {
        object oTarget = gsPCGetPlayerByID(GetLocalString(oAcquired, "GS_TARGET"));
        // If corpse PC still exists, tell then corpse has been picked up
        if (GetIsObjectValid(oTarget))
            FloatingTextStringOnCreature(GS_T_16777482, oTarget, FALSE);

        // Don't destroy the corpse if not, though.
    }

    // check for the acquiring of a slave clamp, if so, add the (Slave) tag behind the name
    if (sTag == "gvd_slave_clamp") {
        // add the (Slave) addition to the dynamic name of the PC
        svSetAffix(oAcquiredBy, SLAVE_SUFFIX, TRUE);          
    }
	
	if (GetLocalInt(gsPCGetCreatureHide(oAcquiredBy), "IS_GHOST") && GetBaseItemType(oAcquired) == 256)
	{
		SendMessageToPC(oAcquiredBy, "You cannot gain gold while you are a ghost.");
		int nStackSize = GetModuleItemAcquiredStackSize();
		AssignCommand(GetLocalObject(oAcquiredBy, "GS_CORPSE"), TakeGoldFromCreature(nStackSize, oAcquiredBy, TRUE));
	}

// ............................................ DM Shop & Gold reporting..........................................................................		
	// filter_gold - player picks up gold
	string sMessage1 = "";
	string sHighlight1 = "";
	if (GetTag(oAcquired) == "" && GetBaseItemType(oAcquired) == 256 && GetIsPC(oAcquiredBy))
    {
	    string sAcquiredName = GetName(oAcquiredFrom);
        if (sAcquiredName == "")
        {
            sAcquiredName = "the ground.";
        }
        else if (GetIsPC(oAcquiredFrom))
        {
            sAcquiredName = GetName(oAcquiredFrom) + " (" + GetPCPlayerName(oAcquiredFrom) + ") (" + GetPCPublicCDKey(oAcquiredFrom) + ")";
        }
		else
		{
			sAcquiredName = GetName(oAcquiredFrom);
		}
		int nStackSize = GetModuleItemAcquiredStackSize();
        string sGoldMessage1 = GetName(oAcquiredBy) + " (" + GetPCPlayerName(oAcquiredBy) + ") (" + GetPCPublicCDKey(oAcquiredBy, TRUE) + ")";
        string sGoldMessage2 = sAcquiredName;
		
        sMessage1 = "<c'>" + sGoldMessage1 + " in area "  + GetName(GetArea(oAcquiredBy)) + " has acquired " + IntToString(nStackSize) + " gold from " + sGoldMessage2;
		sHighlight1 = "<c >" + sGoldMessage1 + " in area"  + GetName(GetArea(oAcquiredBy)) + " has acquired " + IntToString(nStackSize) + " gold from " + sGoldMessage2;
    }
	
	// filter_shop
	// Player buys an item from a store
	string sMessage2 = "";
	string sHighlight2 = "";
    if (GetIsPC(oAcquiredBy) && GetObjectType(oAcquiredFrom) == OBJECT_TYPE_STORE)
    {
        sMessage2 = "<c?>" + GetName(oAcquiredBy) + " in area " + GetName(GetArea(oAcquiredBy)) + " has acquired " + GetName(oAcquired) + " from a store with name: " + GetName(oAcquiredFrom);
		sHighlight2 = "<c >" + GetName(oAcquiredBy) + " in area" + GetName(GetArea(oAcquiredBy)) + " has acquired " + GetName(oAcquired) + " from a store with name: " + GetName(oAcquiredFrom);
    }
	
	object oModule = GetModule();
	object oDM     = GetFirstObjectElement(FB_CH_DM_LIST, oModule);
	int nFilteringGold = 0;
	int nFilteringShop = 0;
	int bHighlight = 0;
	
	if (sMessage1 != "" || sMessage2 != "")
	{
		while (GetIsObjectValid(oDM))
		{
			nFilteringGold = GetLocalInt(oDM, "MI_FILTERING_GOLD");
			nFilteringShop = GetLocalInt(oDM, "MI_FILTERING_SHOP");
			bHighlight = GetLocalInt(oAcquiredBy, "MI_HIGHLIGHT_" + GetPCPlayerName(oDM));
			
			if ((sMessage1 != "")&&(nFilteringGold != 0))
			{
				if (bHighlight || (GetArea(oAcquiredBy) == GetArea(oDM) && nFilteringGold == 1) || nFilteringGold == 2)
				{
					if (bHighlight) SendMessageToPC(oDM, sHighlight1);
					else            SendMessageToPC(oDM, sMessage1);
				}
			}
			
			if ((sMessage2 != "")&&(nFilteringShop != 0))
			{
				if (bHighlight || (GetArea(oAcquiredBy) == GetArea(oDM) && nFilteringShop == 1) || nFilteringShop == 2)
				{
					if (bHighlight) SendMessageToPC(oDM, sHighlight2);
					else            SendMessageToPC(oDM, sMessage2);
				}		
			}		
		oDM = GetNextObjectElement();
		}
	}
// ............................................ End of DM Shop & Gold reporting..........................................................................
    if(GetStringLeft(sTag, 6) != "GS_SH_")
     ConvertItemToNoStack(oAcquired);


}
