#include "gs_inc_fixture"
#include "gs_inc_flag"
#include "gs_inc_iprop"
#include "gs_inc_pc"
#include "gs_inc_text"
#include "gs_inc_time"
#include "gs_inc_common"
#include "inc_disguise"
#include "inc_pop"
#include "inc_chatutils"
#include "inc_seeds"

const string GS_TEMPLATE_CORPSE = "gs_placeable017";
const string GS_TEMPLATE_BODY = "gvd_pl_body";
const int GS_TIMEOUT = 10800; //3 hours

void main()
{
    object oLostBy = GetModuleItemLostBy();
    object oItem   = GetModuleItemLost();
    string sTag    = GetTag(oItem);

    //override transfer
    if (gsFLGetAreaFlag("OVERRIDE_TRANSFER", oLostBy) &&
        ! (GetIsDM(oLostBy) ||
           GetIsDM(GetItemPossessor(oItem))))
    {
        if (GetBaseItemType(oItem) == BASE_ITEM_TRAPKIT)
        {
            object oTrap = GetNearestTrapToObject(oLostBy, FALSE);
            if (GetTrapCreator(oTrap) == oLostBy) SetTrapDisabled(oTrap);
        }

        gsCMCopyItem(oItem, oLostBy, TRUE);
        DestroyObject(oItem);
        return;
    }

    //::Kirito-Spellsword path
    if (miSSGetIsSpellsword(oLostBy))
    {
        //Re-Applies All Spellsword Bonuses
        miSSReApplyBonuses(oLostBy, FALSE);

        //removes imbue properties
        int bPropertiesRemoved  = FALSE;
        itemproperty ipLoop = GetFirstItemProperty(oItem);

        while (GetIsItemPropertyValid(ipLoop))
        {
            if(GetItemPropertyDurationType(ipLoop) == DURATION_TYPE_TEMPORARY)
            {
                if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_ONHITCASTSPELL ||
                    GetItemPropertyType(ipLoop) == ITEM_PROPERTY_VISUALEFFECT ||
                    GetItemPropertyType(ipLoop) == ITEM_PROPERTY_DAMAGE_BONUS
                  )
                {
                    RemoveItemProperty(oItem, ipLoop);
                    bPropertiesRemoved = TRUE;
                }
            }
            //else if (GetItemPropertyDurationType(ipLoop) == DURATION_TYPE_PERMANENT)
            //{
            //    if(GetItemPropertyType(ipLoop) == ITEM_PROPERTY_ONHITCASTSPELL && GetBaseItemType(oItem) == BASE_ITEM_ARMOR )
            //    {
            //        RemoveItemProperty(oUnequipped, ipLoop);
            //        bPropertiesRemoved = TRUE;
            //    }
            //}
            ipLoop=GetNextItemProperty(oItem);
        }
        if (bPropertiesRemoved) SendMessageToPC(oLostBy, "The imbued power fades from the item.");
    }

    //corpse
    if (sTag == "GS_CORPSE")
    {
        // Find PC that the corpse represents
        string sTarget = GetLocalString(oItem, "GS_TARGET");
        object oTarget = gsPCGetPlayerByID(sTarget);

        // Dropping corpse on ground?  Turn to placeable corpse
        if (! GetIsObjectValid(GetItemPossessor(oItem)))
        {
            object oCorpse = CreateObject(OBJECT_TYPE_PLACEABLE,
                                          GS_TEMPLATE_CORPSE,
                                          GetLocation(oLostBy));

            if (GetIsObjectValid(oCorpse))
            {
                if (GetIsObjectValid(oTarget))
                {
                    FloatingTextStringOnCreature(GS_T_16777483, oTarget, FALSE);
                    SetLocalObject(oTarget, "GS_CORPSE", oCorpse);
                }

                SetName(oCorpse, GetName(oItem));
                SetLocalString(oCorpse, "GS_TARGET", sTarget);
				SetLocalObject(oCorpse, "sep_azn_claimedby", GetLocalObject(oItem, "sep_azn_claimedby")); 
                SetLocalInt(oCorpse, "GS_STATIC", TRUE);
                SetLocalInt(oCorpse, "GS_GOLD", GetLocalInt(oItem, "GS_GOLD"));
                DestroyObject(oItem);
            }
        }
        // Dropping corpse into inventory placeable?  Just send PC the corpse-dropped
        // message.
        else if (GetObjectType(GetItemPossessor(oItem)) != OBJECT_TYPE_CREATURE &&
                 GetIsObjectValid(oTarget))
        {
            FloatingTextStringOnCreature(GS_T_16777483, oTarget, FALSE);
        }

        return;
    }

    // body
    if (sTag == "GVD_BODY")
    {
        // Find PC that the body represents
        string sTarget = GetLocalString(oItem, "GS_TARGET");
        object oTarget = gsPCGetPlayerByID(sTarget);

        // Dropping body on ground?  Turn to placeable body
        if (! GetIsObjectValid(GetItemPossessor(oItem)))
        {
            object oBody = CreateObject(OBJECT_TYPE_PLACEABLE,
                                          GS_TEMPLATE_BODY,
                                          GetLocation(oLostBy));

            if (GetIsObjectValid(oBody))
            {
                if (GetIsObjectValid(oTarget))
                {
                    FloatingTextStringOnCreature("Your body has been dropped to the ground", oTarget, FALSE);
                    SetLocalObject(oTarget, "GVD_BODY", oBody);
                }

                SetName(oBody, GetName(oItem));
                SetLocalString(oBody, "GS_TARGET", sTarget);
                SetLocalInt(oBody, "GS_STATIC", TRUE);
                SetLocalInt(oBody, "GS_GOLD", GetLocalInt(oItem, "GS_GOLD"));
                DestroyObject(oItem);
            }
        }
        // Dropping body into inventory placeable?  Just send PC the body-dropped
        // message.
        else if (GetObjectType(GetItemPossessor(oItem)) != OBJECT_TYPE_CREATURE &&
                 GetIsObjectValid(oTarget))
        {
            FloatingTextStringOnCreature("Your body has been dropped to the ground", oTarget, FALSE);
        }

        return;
    }

    //fixture
    if (GetStringLeft(sTag, 6) == "GS_FX_"  && !GetIsObjectValid(GetItemPossessor(oItem)))
    {
        if (! GetIsObjectValid(GetItemPossessor(oItem)))
        {
            // Addition by Mithreas. Don't convert items if we're standing near a
            // door, as it allows people to "jump" through doors.
            object oDoor = GetNearestObject(OBJECT_TYPE_DOOR, oItem);
            if (GetDistanceBetween(oItem, oDoor) > 0.0 &&
                GetDistanceBetween(oItem, oDoor) < 2.5)
            {
              // Object is too close to a door.
              SendMessageToPC(oLostBy, "<cþ  >You cannot place this item so close to a door.");
              return;
            }

            // Dunshine: Check for seeds, they can only be placed out in trigger areas from now on, player feedback is done in the function
            if (gvd_GetSeedAllowed(oLostBy, oItem) == 0) {
              return;                
            }


            vector vPosition    = GetPosition(oLostBy);
            float fFacing       = GetFacing(oLostBy);
            vPosition          += AngleToVector(fFacing);
            location lLocation  = Location(GetArea(oLostBy), vPosition, fFacing);
            sTag                = GetStringRight(sTag, GetStringLength(sTag) - 6);

            // Addition by Mithreas.  Message boards need to have a unique tag
            // to work. So if there's a __ (double underscore) in the tag, cut
            // it short.
            // 123__12  index=3
            int __index = FindSubString(sTag, "__");
            string sTagg = "";
            if (__index > 0)
            {
              sTagg = GetStringRight(sTag, GetStringLength(sTag) - __index);
              sTag = GetStringLeft(sTag, __index);
            }
            // If this is a message board without a custom tag, create its
            // tag now - __ plus up to 8 digits.
            // The item's tag is (GS_FX_)mi_messageboard - first 6 chars trimmed
            // The fixture's tag is (will be) GS_FX_gs_item059__<random>
            else if (sTag == "mi_messageboard" || sTag == "wt_plbl_bkcase1")
            {
              sTagg = "__" + IntToString(Random(100000000));
            }

            Trace(FIXTURES, "Creating object with tag: GS_FX_" + GetResRef(oItem) + sTagg);
            object oFixture     = CreateObject(OBJECT_TYPE_PLACEABLE, sTag, lLocation, FALSE, "GS_FX_" + GetResRef(oItem) + sTagg);

            if (GetIsObjectValid(oFixture))
            {
                if ((GetName(oItem, TRUE) != GetName(oItem, FALSE)) || (GetResRef(oItem) == "gvd_it_remains"))
                {
                   SetName(oFixture, GetName(oItem));
                }

                if (GetDescription(oItem, TRUE) != GetDescription(oItem, FALSE))
                {
                   SetDescription(oFixture, GetDescription(oItem));
                }

                // Change owner.
                gsIPSetOwner(oFixture, oLostBy);

                if (!gsFXSaveFixture(GetTag(GetArea(oFixture)), oFixture))
                {
                  SendMessageToPC(oLostBy, "Fixture object not saved! Max 60 per area.");
                  Log(FIXTURES, "Fixture " + GetName(oFixture) + " was placed in area " +
                    GetName(GetArea(oFixture)) + " by " + GetName(oLostBy) +
                    ", but could not be saved.");
                  
                  // in case it's a fixture remains, make sure to store the variables so they don't get lost
                  if (GetLocalString(oItem, "GVD_REMAINS_DATA") != "") {
                    SetLocalString(oFixture, "GVD_REMAINS_DATA", GetLocalString(oItem, "GVD_REMAINS_DATA"));
                    SetLocalString(oFixture, "GVD_REMAINS_STATUS", GetLocalString(oItem, "GVD_REMAINS_STATUS"));
                    SetLocalString(oFixture, "GVD_REMAINS_CRAFTPOINTS", GetLocalString(oItem, "GVD_REMAINS_CRAFTPOINTS"));
                  }

                }
                else
                {
                  Log(FIXTURES, "Fixture " + GetName(oFixture) + " was placed in area " +
                    GetName(GetArea(oFixture)) + " by " + GetName(oLostBy) + ".");

                  // Migrate variables.
                  string sVarName = GetFirstStringElement("VAR_LIST", oItem);

                  while (sVarName != "")
                  {
                    gsFXSetLocalString(oFixture, sVarName, GetLocalString(oItem, sVarName));
                    AddStringElement(sVarName, "VAR_LIST", oFixture);
                    sVarName = GetNextStringElement();
                  }

                }

                // make sure the variables for fixture remains are handled correctly
                gvd_SetFixtureRemainsData(oFixture);

                // dunshine: if it's a seed, set the time-out, so it doesn't spawn resources immediately after being placed out (exploitable)
                if (gvd_GetItemIsSeed(oItem) == 1) {
                  int nTimestamp = gsTIGetActualTimestamp();
                  nTimestamp += GS_TIMEOUT;
                  SetLocalInt(oFixture, "GS_TIMEOUT", nTimestamp);
                }

                gsCMReduceItem(oItem);
            }
        }

        return;
    }

    //Unlimited ammo generator
    if (GetStringLeft(sTag,6) == "ca_gen")
    {
      string sTagDestroy = "ca_e_";
      string sDroppedType = "Enchanted ";
      if (GetStringLeft(sTag,9) == "ca_gen_ar")
      {
        sTagDestroy = sTagDestroy + "arrow";
        sDroppedType = sDroppedType + "Arrows";
      }
      if (GetStringLeft(sTag,9) == "ca_gen_bo")
      {
        sTagDestroy = sTagDestroy + "bolt";
        sDroppedType = sDroppedType + "Bolts";
      }
      if (GetStringLeft(sTag,9) == "ca_gen_bu")
      {
        sTagDestroy = sTagDestroy + "bullet";
        sDroppedType = sDroppedType + "Bullets";
      }
      // Work out the variable on ammo created by the item dropped
      itemproperty iGenProperty = GetFirstItemProperty(oItem);
      while (GetIsItemPropertyValid(iGenProperty))
      {
        if (GetItemPropertyType(iGenProperty) == ITEM_PROPERTY_DAMAGE_BONUS &&
           GetItemPropertyDurationType(iGenProperty) == DURATION_TYPE_PERMANENT)
        {
          // Add this to the item name if elemental
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_ACID)
          {
            sDroppedType = sDroppedType + ", Acid";
          }
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_COLD)
          {
            sDroppedType = sDroppedType +  ", Cold";
          }
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_DIVINE)
          {
            sDroppedType = sDroppedType +  ", Divine";
          }
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_ELECTRICAL)
          {
            sDroppedType = sDroppedType +  ", Electrical";
          }
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_FIRE)
          {
            sDroppedType = sDroppedType +  ", Fire";
          }
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_MAGICAL)
          {
            sDroppedType = sDroppedType +  ", Magical";
          }
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_NEGATIVE)
          {
            sDroppedType = sDroppedType +  ", Negative";
          }
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_POSITIVE)
          {
            sDroppedType = sDroppedType +  ", Positive";
          }
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_SONIC)
          {
            sDroppedType = sDroppedType +  ", Sonic";
          }
        }
        iGenProperty = GetNextItemProperty(oItem);
      }
      // Set the start of the name based on the item that created it
      string sGenQuality = GetStringRight(sTag, 3);
      if (sGenQuality == "bro")
      {
        sDroppedType= "Bronze " + sDroppedType;
      }
      if (sGenQuality == "iro")
      {
        sDroppedType= "Iron " + sDroppedType;
      }
      if (sGenQuality == "ste")
      {
        sDroppedType= "Steel " + sDroppedType;
      }
      if (sGenQuality == "dam")
      {
        sDroppedType= "Damask " + sDroppedType;
      }
      // Now destroy ammo appropriately
      object oItemToCheck = GetFirstItemInInventory(oLostBy);
      while(oItemToCheck!= OBJECT_INVALID)
      {
        if(GetTag(oItemToCheck) == sTagDestroy && GetLocalString(oItemToCheck, "AMMOTYPE") == sDroppedType)
        {
          DestroyObject(oItemToCheck);
        }
        oItemToCheck = GetNextItemInInventory(oLostBy);
      }
      oItemToCheck = GetItemInSlot(INVENTORY_SLOT_ARROWS, oLostBy);
      if(GetTag(oItemToCheck) == sTagDestroy &&
      GetLocalString(oItemToCheck, "AMMOTYPE") == sDroppedType
      && oItemToCheck != OBJECT_INVALID)
      {
        DestroyObject(oItemToCheck);
      }
      oItemToCheck = GetItemInSlot(INVENTORY_SLOT_BOLTS, oLostBy);
      if(GetTag(oItemToCheck) == sTagDestroy &&
      GetLocalString(oItemToCheck, "AMMOTYPE") == sDroppedType
      && oItemToCheck != OBJECT_INVALID)
      {
        DestroyObject(oItemToCheck);
      }
      oItemToCheck = GetItemInSlot(INVENTORY_SLOT_BULLETS, oLostBy);
      if(GetTag(oItemToCheck) == sTagDestroy &&
      GetLocalString(oItemToCheck, "AMMOTYPE") == sDroppedType
      && oItemToCheck != OBJECT_INVALID)
      {
        DestroyObject(oItemToCheck);
      }
    }

    // Muling script
    if (GetResRef(oItem) != "gs_item038" && // Quarter keys
        !GetIsDM(oLostBy))
    {
      // Store the PCID of the losing character, so that we can notice if any
      // other characters of the same player somehow get hold of this item
      // (i.e. muling).
      if (GetPCPublicCDKey(oLostBy, TRUE) != "")
      {
        SetLocalString(oItem, GetPCPublicCDKey(oLostBy, TRUE), gsPCGetPlayerID(oLostBy));
        SetLocalInt(oItem, GetPCPublicCDKey(oLostBy, TRUE) + "_TIME", gsTIGetActualTimestamp());
      }
    }
	
	// Resources.
	if (sTag == "mi_resource_bund")
	{
	  string sPop = GetLocalString(GetArea(oLostBy), VAR_POP);
	  
	  if (sPop != "")
	  {
	    miPOAdjustPopulation(sPop, GetLocalInt(oItem, "VALUE") / 100);
		DestroyObject(oItem);
		FloatingTextStringOnCreature("Your supplies have been delivered to the local populace", oLostBy); 
	  }	
	}

// ............................................ DM Shop reporting..........................................................................	
	// filter_shop
	string sMessage1 = "";
	string sHighlight1 = "";
    if (GetItemPossessor(oItem) == OBJECT_INVALID)
    {
		/*	This block needs to set/delete some variable ShopName when a store is open and closed, otherwise it is spam.
        if (GetLocalString(oPlayer, "ShopName") != "")
        {
            SendMessageToPC(GetFirstPC(), GetName(oPlayer) + " stacked or sold infinite-stock item to shop with tag: " + GetLocalString(oPlayer, "ShopName"));
        }
		*/
    }
    else if (GetObjectType(GetItemPossessor( oItem ))== OBJECT_TYPE_STORE && GetIsPC(oLostBy))
    {
        sMessage1 = "<cÀ?À>" + GetName(oLostBy) + " (" + GetPCPlayerName(oLostBy) + ") (" + GetPCPublicCDKey(oLostBy, TRUE) + ") sold " + GetName(oItem) + " to a store with name: " + GetName(GetItemPossessor(oItem)) + " in area: " + GetName(GetArea(oLostBy));		
		sHighlight1 = "<c þþ>" + GetName(oLostBy) + " (" + GetPCPlayerName(oLostBy) + ") (" + GetPCPublicCDKey(oLostBy, TRUE) + ") sold " + GetName(oItem) + " to a store with name: " + GetName(GetItemPossessor(oItem)) + " in area: " + GetName(GetArea(oLostBy));	
    }
	
	object oModule = GetModule();
	object oDM     = GetFirstObjectElement(FB_CH_DM_LIST, oModule);
	int nFilteringShop = 0;
	int bHighlight = 0;
	
	if (sMessage1 != "")
	{
		while (GetIsObjectValid(oDM))
		{
			nFilteringShop = GetLocalInt(oDM, "MI_FILTERING_SHOP");
			bHighlight = GetLocalInt(oLostBy, "MI_HIGHLIGHT_" + GetPCPlayerName(oDM));
						
				if (bHighlight || (GetArea(oLostBy) == GetArea(oDM) && nFilteringShop == 1) || nFilteringShop == 2)
				{
					if (bHighlight) SendMessageToPC(oDM, sHighlight1);
					else            SendMessageToPC(oDM, sMessage1);
				}			
		oDM = GetNextObjectElement();
		}
	}
// ............................................ End of DM Shop reporting..........................................................................		
}
