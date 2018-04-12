#include "inc_names"
#include "gs_inc_boss"
#include "gs_inc_common"
#include "gs_inc_craft"
#include "gs_inc_encounter"
#include "gs_inc_flag"
#include "gs_inc_forum"
#include "gs_inc_iprop"
#include "gs_inc_istate"
#include "gs_inc_placeable"
#include "gs_inc_state"
#include "gs_inc_subrace"
#include "gs_inc_text"
#include "gs_inc_time"
#include "gs_inc_quarter"
#include "gs_inc_xp"
#include "inc_assassin"
#include "inc_class"
#include "inc_divination"
#include "inc_poison"
#include "inc_warlock"
#include "zzdlg_tools_inc"
#include "inc_holders"
#include "gs_inc_combat"
#include "inc_adv_xp"
#include "inc_subdual"
#include "ar_sys_poison"
#include "ki_wrapr_bldsgr"
#include "ki_wrapr_thfglv"
#include "inc_stacking"

// Runs custom behaviors associated with the item, either via tag or variable.
void ExecuteCustomItemBehaviors();

void main()
{
    int i;
    object oItem       = GetItemActivated();
    object oActivator  = GetItemActivator();
    string sTag        = GetStringUpperCase(ConvertedStackTag(oItem));
    object oTarget     = GetItemActivatedTarget();
    location lLocation = GetItemActivatedTargetLocation();

    //Must be up top
    if(!gsIPDoUMDCheck(oActivator, oItem)) return;

    StoreLastItemUsed();
    // Temp fix for item use breaking scripts that check this function
    // (e.g. totems). TO DO: clean this up later.
    _SetIsCreatureLastSpellCastItemValid(oActivator, TRUE);
    ExecuteCustomItemBehaviors();

    // wolfsbane
    if (sTag == "MI_WOLFSBANE")
    {
      int nTime = gsTIGetActualTimestamp();
      int nPickedTime = GetLocalInt(oItem, "GS_TIMEOUT");

      // dunshine, fixed for epoch clock reset, where timeout will be bigger then actual timestamp
      if ((gsTIGetHour(nTime - nPickedTime) >= 1) || (nPickedTime > nTime))
      {
        SendMessageToPC(oActivator, "This herb has gone bad.");
      }
      else
      {
        SetLocalInt(oActivator, "MI_AWIA", FALSE);
        miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oActivator), "awia", "0");
        return;
      }
    }

    // wolf infection wand
    if (sTag == "WOLFERIZER")
    {
      if (GetHasFeat(FEAT_DIVINE_HEALTH, oTarget))
      {
        SendMessageToPC(oActivator, "This PC has Divine Health and is immune to lycanthropy.");
      }
      else if (!GetLocalInt(oTarget, "MI_AWIA"))
      {
        SendMessageToPC(oActivator, "Target has been infected with lycanthropy.");
        SetLocalInt(oTarget, "MI_AWIA", TRUE);
        miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oTarget), "awia", "1");
      }
      else
      {
        SendMessageToPC(oActivator, "Target no longer has lycanthropy.");
        SetLocalInt(oTarget, "MI_AWIA", FALSE);
        miDASetKeyedValue("gs_pc_data", gsPCGetPlayerID(oTarget), "awia", "0");
      }
      return;
    }

    //portal lens
    if (sTag == "GS_PO_LENS")
    {
        if (gsFLGetAreaFlag("OVERRIDE_TELEPORT", oActivator))
        {
            FloatingTextStringOnCreature(GS_T_16777430, oActivator, FALSE);
        }
        else if (! GetIsInCombat(oActivator))
        {
            AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_po_use_lens", TRUE, FALSE));
        }
        return;
    }

    // potion of attunement
    if (sTag == "MI_POTION_ATTUNE")
    {
        ExecuteScript("wt_attn_activate", oActivator);
        return;
    }

    //firewood
    if (sTag == "GS_FIREWOOD")
    {
        // Addition by Mithreas. Don't convert items if we're standing near a
        // door, as it allows people to "jump" through doors.
        object oDoor = GetNearestObjectToLocation(OBJECT_TYPE_DOOR, lLocation);
        if (GetDistanceBetweenLocations(lLocation, GetLocation(oDoor)) > 0.0 &&
            GetDistanceBetweenLocations(lLocation, GetLocation(oDoor)) < 2.5)
        {
          // Object is too close to a door.
          SendMessageToPC(oActivator, "<c  >You cannot place this item so close to a door.");
          return;
        }

        CreateObject(OBJECT_TYPE_PLACEABLE, "gs_placeable177", lLocation);
        return;
    }

    //craft
    if (sTag == "GS_CR_RECIPE")
    {
        AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
        AssignCommand(oActivator, ActionDoCommand(_dlgStart(oActivator, oItem, "zz_co_crafting", TRUE, TRUE)));
        return;
    }

    //worship
    if (sTag == "GS_WO_SELECT")
    {
        AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
        AssignCommand(oActivator, ActionDoCommand(_dlgStart(oActivator, oItem, "zz_co_worship", TRUE, TRUE)));
        return;
    }

    //write message
    if (sTag == "GS_ME_WRITE")
    {
        SetLocalObject(oActivator, "GS_TARGET", oItem);
        AssignCommand(oTarget, SpeakString(GS_T_16777234));
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_me_write", TRUE, FALSE));
        return;
    }

    //notebook
    if (GetStringLeft(sTag, 11) == "MI_NOTEBOOK")
    {
      AssignCommand(oActivator,
         ActionDoCommand(_dlgStart(oActivator, oItem, "zz_co_forum", TRUE, TRUE, TRUE)));
    }

    //food
    if (GetStringLeft(sTag, 10) == "GS_ST_FOOD")
    {
        // Check for poison.
        int nPoison = GetLocalInt(oItem, VAR_POISON_TYPE);
        if (nPoison)
        {
          ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPoison(nPoison), oActivator);
          // Strip 'Pxxx' from the end of the tag (poison marker to prevent stacking).
          sTag = GetStringLeft(sTag, FindSubString(sTag, "P"));
        }

        float fValue = StringToFloat(GetStringRight(sTag, GetStringLength(sTag) - 11));
        //AssignCommand(oTarget, SpeakString(GS_T_16777235));
        AssignCommand(oActivator, gsSTAdjustState(GS_ST_FOOD, fValue));
        return;
    }

    //water
    if (GetStringLeft(sTag, 11) == "GS_ST_WATER")
    {
        // Check for poison.
        int nPoison = GetLocalInt(oItem, VAR_POISON_TYPE);
        if (nPoison)
        {
          ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPoison(nPoison), oActivator);
          // Strip 'Pxxx' from the end of the tag (poison marker to prevent stacking).
          sTag = GetStringLeft(sTag, FindSubString(sTag, "P"));
        }

        float fValue = StringToFloat(GetStringRight(sTag, GetStringLength(sTag) - 12));
        //AssignCommand(oTarget, SpeakString(GS_T_16777236));
        AssignCommand(oActivator, gsSTAdjustState(GS_ST_WATER, fValue));
        return;
    }

    //message
    if (GetStringLeft(sTag, 6) == "GS_ME_")
    {
        if (GetIsObjectValid(oTarget))
        {
            int nReceipt = GetStringLeft(sTag, 9) == "GS_ME_MD_";
            if(!nReceipt) //receipts cannot go on boards/notebooks/housedoors
            {
            // dunshine: to fix message boards with different tags (like bookshelves, check variable as well)
                if ( (GetStringLeft(GetTag(oTarget), 8) == "GS_FORUM") ||
                    (GetLocalInt(oTarget, "MI_MESSAGE_BOARD") == 1) ||
                    (FindSubString(GetTag(oTarget), "gs_item059") > 0) || // craftable boards
                    (GetStringLeft(GetTag(oTarget), 11) == "mi_notebook"))
                {
                    if (gsFOPostMessage(GetStringRight(sTag, 16), oActivator, oTarget))
                    {
                        gsCMReduceItem(oItem);
                    }
                    return;
                }
                else if (gsQUGetOwnerID(oTarget) != "")
                {
                    gsQUPostMessage(oTarget, GetStringRight(sTag, 16));
                    gsCMReduceItem(oItem);
                }
            }

            switch (GetObjectType(oTarget))
            {
            case OBJECT_TYPE_CREATURE:

                //read message public
                if (oTarget == oActivator)
                {
                    SetLocalObject(oActivator, "GS_TARGET", oItem);
                    AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
                    AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_me_read", FALSE, FALSE));
                }
                break;

            case OBJECT_TYPE_ITEM:

                //copy message
                if (GetTag(oTarget) == "GS_ME_WRITE")
                {
                    object oNew;
                    if(nReceipt)
                    {
                        oNew = CreateItemOnObject(GS_TEMPLATE_LETTER, oActivator, 1, "GS_ME_"+GetStringRight(sTag, 16));
                        SetName(oNew, GetName(oItem));
                    }
                    else
                        oNew = gsCMCopyItem(oItem, oActivator, FALSE, TRUE);
                    if(GetIsObjectValid(oNew))
                        gsCMReduceItem(oTarget);
                }
                break;
            }
            return;
        }

        //read message private
        SetLocalObject(oActivator, "GS_TARGET", oItem);
        AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_me_read", TRUE, FALSE));
        return;
    }

    //::  Added by ActionReplay, check custom Poisons
    arApplyPoison(oActivator, oItem, oTarget, sTag);

    //item property
    if (GetStringLeft(sTag, 6) == "GS_IP_")
    {
        if (GetIsObjectValid(oTarget) &&
            GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
        {
            //GS_IP_{type}_{subtype}_{cost}_{param}_{duration}
            int nType = StringToInt(GetSubString(sTag, 6, 3));

            if (gsIPGetIsValid(oTarget, nType))
            {
                int nSubType            = StringToInt(GetSubString(sTag, 10, 3));
                int nCost               = StringToInt(GetSubString(sTag, 14, 3));
                int nParam              = StringToInt(GetSubString(sTag, 18, 3));
                float fDuration         = HoursToSeconds(StringToInt(GetSubString(sTag, 22, 3)));
                itemproperty ipProperty = gsIPGetItemProperty(nType, nSubType, nCost, nParam);

                // On the FL server, success is not automatic.
                if (gsCRGetEssenceApplySuccess(oTarget))
                {
                  switch (nType)
                  {
                  case ITEM_PROPERTY_DAMAGE_BONUS:
                  case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
                  case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
                  case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
                    gsIPAddDamageBonus(oTarget, ipProperty, fDuration);
                    break;

                  default:
                    gsIPAddItemProperty(oTarget, ipProperty, fDuration, fDuration == 0.0);
                    break;
                  }


                  ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                      EffectVisualEffect(VFX_IMP_HOLY_AID),
                                      oActivator);
                }
                else
                {
                  SendMessageToPC(oActivator, "The item fails to hold the enchantment.");
                }
            }
            else
            {
                SendMessageToPC(oActivator, GS_T_16777237);
            }
        }

        return;
    }

    //Ammunition generator
    if (GetStringLeft(sTag,6) == "CA_GEN")
    {
      // What we're going to create and what to call it
      string sCreateTag = "ca_e_";
      string sName = "";
      // Work out what type of generator it is
      if (GetStringLeft(sTag,9) == "CA_GEN_AR")
      {
        sCreateTag = sCreateTag + "arrow";
        sName = sName + "Arrows";
      }
      if (GetStringLeft(sTag,9) == "CA_GEN_BO")
      {
        sCreateTag = sCreateTag + "bolt";
        sName = sName + "Bolts";
      }
      if (GetStringLeft(sTag,9) == "CA_GEN_BU")
      {
        sCreateTag = sCreateTag + "bullet";
        sName = sName + "Bullets";
      }
      object oAmmo = CreateItemOnObject(sCreateTag, oActivator, 99);
      itemproperty iGenProperty = GetFirstItemProperty(oItem);
      while (GetIsItemPropertyValid(iGenProperty))
      {
      // Damage bonuses and materials are the only thing transferred
        if (GetItemPropertyType(iGenProperty) == ITEM_PROPERTY_DAMAGE_BONUS ||
            GetItemPropertyType(iGenProperty) == ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP)
        {
          // Add this to the item
          AddItemProperty(DURATION_TYPE_PERMANENT, iGenProperty, oAmmo);
          // Add this to the item name if elemental
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_ACID)
          {
            sName = sName + ", Acid";
          }
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_COLD)
          {
            sName = sName +  ", Cold";
          }
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_DIVINE)
          {
            sName = sName +  ", Divine";
          }
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_ELECTRICAL)
          {
            sName = sName +  ", Electrical";
          }
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_FIRE)
          {
            sName = sName +  ", Fire";
          }
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_MAGICAL)
          {
            sName = sName +  ", Magical";
          }
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_NEGATIVE)
          {
            sName = sName +  ", Negative";
          }
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_POSITIVE)
          {
            sName = sName +  ", Positive";
          }
          if (GetItemPropertySubType(iGenProperty) == IP_CONST_DAMAGETYPE_SONIC)
          {
            sName = sName +  ", Sonic";
          }
        }
        else if (GetItemPropertyType(iGenProperty) == ITEM_PROPERTY_MATERIAL)
        {
          // Add this to the item
          AddItemProperty(DURATION_TYPE_PERMANENT, iGenProperty, oAmmo);
        }
        iGenProperty = GetNextItemProperty(oItem);
      }
      // Set the start of the name based on the item that created it
      string sGenQuality = GetStringRight(sTag, 3);
      if (sGenQuality == "BRO")
      {
        sName="Bronze " + sName;
      }
      if (sGenQuality == "IRO")
      {
        sName="Iron " + sName;
      }
      if (sGenQuality == "STE")
      {
        sName= "Steel " + sName;
      }
      if (sGenQuality == "DAM")
      {
        sName= "Damask " + sName;
      }
      if (sGenQuality == "SIL")
      {
        sName= "Silver " + sName;
      }
      SetName(oAmmo, sName);
      SetLocalString(oAmmo, "AMMOTYPE", sName);

      // Take a charge off the ammo generator.
      gsISDecreaseItemState(oItem);
    }

    //Spawn NPC (e.g. snake-in-a-jar)
    if (GetStringLeft(sTag, 7) == "MI_NPC_")
    {
      location lTarget;
      if (GetIsObjectValid (GetItemActivatedTarget())) lTarget = GetLocation(GetItemActivatedTarget());
      else lTarget = GetItemActivatedTargetLocation();

      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), lTarget, 1.0);
      object oCreature = CreateObject(OBJECT_TYPE_CREATURE, GetStringRight(sTag, GetStringLength(sTag) - 7), lTarget, TRUE);
      ChangeFaction(oCreature, GetObjectByTag("example_hostile_all"));
    }

    if (sTag == "REPXBOW_RELOAD")
    {
      if (GetResRef(oTarget) == "ar_repeatxbow")
      {
        SetItemCharges(oTarget, GetItemCharges(oTarget) + 10);
      }
    }

    if (sTag == "GONNE")
    {
      // Somebody fired a gonne.  Well, well...
      object oAmmo = GetItemPossessedBy(oActivator, "GonneExplosiveSlug");

      if (!GetIsObjectValid(oAmmo))
      {
        FloatingTextStringOnCreature("*** Out Of Ammo ***", oActivator, FALSE);
        return;
      }

      // Execute Gonne script on caller.
      SetLocalObject(oActivator, "GONNE_TARGET", oTarget);
      ExecuteScript("mi_gonne", oActivator);

      if (GetItemStackSize(oAmmo) == 1) DestroyObject(oAmmo);
      else SetItemStackSize(oAmmo, GetItemStackSize(oAmmo) - 1);
    }

    // Deck of Stars
    if (sTag == "DECK_OF_STARS")
    {
        if (GetIsDM(oActivator))
        {
          if (GetIsPC(oTarget)) batDVListElementsForDM(oActivator, oTarget);
          else miDVListAspectsForDM(oActivator);
        }

        else if (oTarget == oActivator)
        {
          SetLocalString(oActivator, "dialog", "zdlg_deckstars");
          AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));
        }
        else
        {
          miDVLayField(oActivator);
        }
    }

    // Shovel. No, wait, spade!
    if (sTag == "C_SHOVEL")
    {
      AssignCommand(oActivator, ActionSpeakString("*digs*"));

      int iTreasure = GetLocalInt(oActivator,"treasure_area");
      object oMap;

      // check if in treasure area
      if (iTreasure == 0 || GetLocalInt(GetArea(oActivator), "TREASURE_FOUND"))
      {
        FloatingTextStringOnCreature("You dig and you dig, but you don't find anything.", oActivator);
      }
      else
      {
        // "normal" treasure
        SendMessageToPC(oActivator, "You've found a hidden treasure!!");
        CreateObject(OBJECT_TYPE_PLACEABLE, "mi_hidden_treasu", GetLocation(oActivator));
        GiveXPToCreature(oActivator, 50);
        SetLocalInt(GetArea(oActivator), "TREASURE_FOUND", 1);
      }
    }

    // Golem controller
    if (sTag == "MI_GOLEM_C_STONE")
    {
      // Use on a golem with no master to start controlling it.
      // Use on a patch of ground when your golem isn't summoned to summon it.
      string CONTROLLER_VAR   = "MI_GOLEM_CONTROLLER";
      string GOLEM_VAR        = "MI_GOLEM";
      string GOLEM_RESREF_VAR = "MI_GOLEM_RESREF";

      // Only allow characters of level 15 or higher to use golems.
      int nLevel = GetHitDice(oActivator);
      if (nLevel < 15)
      {
        SendMessageToPC(oActivator, "You must be level 15 to use golems.");
        return;
      }

      if (GetIsObjectValid(oTarget))
      {
        if ((GetStringLeft(GetTag(oTarget), 8) == "mi_golem") &&
            (GetLocalObject(oTarget, CONTROLLER_VAR) == oItem ||
             !GetLocalInt(oTarget, "MI_GOLEM_IS_OWNED")))
        {
          // Take control!
          SetLocalObject(oTarget, CONTROLLER_VAR, oItem);
          SetLocalObject(oItem, GOLEM_VAR, oTarget);
          SetLocalString(oItem, GOLEM_RESREF_VAR, GetResRef(oTarget));

          DeleteLocalInt(oTarget, "MI_PERSIST");
          SetLocalInt(oTarget, "MI_GOLEM_IS_OWNED", TRUE);

          effect eRay = EffectBeam(VFX_BEAM_COLD, oActivator, BODY_NODE_HAND);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 5.0f);

          AssignCommand(oTarget, SetIsDestroyable(TRUE,FALSE,FALSE));
          AssignCommand(oActivator, AddHenchman(oActivator, oTarget));
          SetName(oItem, "Golem Control Stone (bound)");
          SetLocalInt(oItem, "_RANDOM", Random(100000));
          ConvertItemToNoStack(oItem);
        }
        else
        {
          // Invalid target, no effect.
          SendMessageToPC(oActivator, "You cannot bind this target.");
        }
      }
      else
      {
        object oGolem = GetLocalObject(oItem, GOLEM_VAR);

        if (!GetIsObjectValid(oGolem) || GetStringLeft(GetTag(oGolem), 8) != "mi_golem")
        {
          string sResRef = GetLocalString(oItem, GOLEM_RESREF_VAR);
          oGolem = CreateObject(OBJECT_TYPE_CREATURE, sResRef, GetLocation(oActivator));
          SetLocalObject(oGolem, CONTROLLER_VAR, oItem);
          SetLocalObject(oItem, GOLEM_VAR, oGolem);
          SetLocalInt(oGolem, "MI_GOLEM_IS_OWNED", TRUE);

          DeleteLocalInt(oGolem, "MI_PERSIST");

          AssignCommand(oGolem, SetIsDestroyable(TRUE,FALSE,FALSE));
          AssignCommand(oActivator, AddHenchman(oActivator, oGolem));
        }
      }
    }

    // Soul gem.
    if (sTag == "MI_SOULGEM")
    {
      gsXPGiveExperience(oActivator, 5);
      SendMessageToPC(oActivator, "Mmm... just melts in your mouth.");
    }

    // Warlock staff - select element
    if (GetStringLowerCase(sTag) == TAG_WARLOCK_STAFF)
    {
      SetLocalString(oActivator, "dialog", "zdlg_warlock_sta");
      AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));
    }

    // Spell component pouch.
    if (sTag == "MI_SPELL_POUCH")
    {
       if (GetIsObjectValid(oTarget) && GetTag(oTarget) == "MI_SPELL_COMP" && GetItemStackSize(oItem) == 1)
       {
         int nNumCharges = GetItemCharges(oItem);
         int nNewCharges = GetItemCharges(oTarget);
         int nStackSize = GetItemStackSize(oTarget);

         // Caps at 50 charges.
         while (nNumCharges < 50 && nStackSize >= 1)
         {
           SetItemCharges(oItem, nNumCharges + nNewCharges);
           gsCMReduceItem(oTarget);
           nStackSize --;
           nNumCharges += nNewCharges;
         }
       }
    }

    // Pied Pipes of Hamelyn
    if (sTag == "MI_PIED_PIPES")
    {
      if (!GetHasFeat(FEAT_BARD_SONGS, oActivator))
      {
        SpeakStringByStrRef(40063);
      }
      else
      {
        // Harper override (master harpers can sing forever).
        if (!(GetLocalInt(gsPCGetCreatureHide(oActivator), VAR_HARPER) == MI_CL_HARPER_MASTER &&
              GetLevelByClass(CLASS_TYPE_HARPER, oActivator) > 4))
          DecrementRemainingFeatUses(oActivator, FEAT_BARD_SONGS);
        PlaySound("as_cv_flute2");
        int nLevel = GetLevelByClass(CLASS_TYPE_BARD, oActivator);
        int nCount = 0;
        object oRat;
        for (nCount; nCount < nLevel; nCount++)
        {
          oRat = CreateObject(OBJECT_TYPE_CREATURE, "nw_rat002", lLocation);
          AssignCommand(oRat, ActionSpeakString("Squeak!"));
        }
      }
    }

    // Innate ability for archers.
    if (sTag == "GS_SU_ABILITY")
    {
      // Archer subclass.
      if (GetLocalInt(gsPCGetCreatureHide(oActivator), "ARCHER"))
      {
        int nLevel = GetLevelByClass(CLASS_TYPE_RANGER, oActivator);
        object oArrows;
        if (nLevel < 5)
          oArrows = CreateItemOnObject("ca_gen_arrow_iro", oActivator);
        else if (nLevel < 10)
          oArrows = CreateItemOnObject("ca_gen_arrow_ste", oActivator);
        else
          oArrows = CreateItemOnObject("ca_gen_arrow_dam", oActivator);
        SetIdentified(oArrows, TRUE);
        SetPlotFlag(oArrows, TRUE);
      }
      // Rakshasa
      else if (gsSUGetSubRaceByName(GetSubRace(oActivator)) == GS_SU_SPECIAL_RAKSHASA)
      {
        SetLocalString(oActivator, "dialog", "zdlg_rakshasa");
        AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));
      }
    }

    if (sTag == "MICZ_WRIT")
    {
      string sID = gsPCGetPlayerID(oActivator);
      string sNation = GetLocalString(oItem, VAR_NATION);

      if (GetLocalString(oActivator, VAR_NATION) == sNation &&
          !GetLocalInt(oItem, sID) &&
          miCZGetIsLeader(oActivator, GetLocalString(oActivator, VAR_NATION)))
      {
        SetLocalInt(oItem, sID, TRUE);
        int nNumSigs = GetLocalInt(oItem, "micz_num_signatures")+1;
        SetLocalInt(oItem, "micz_num_signatures", nNumSigs);
        int nTStamp = GetLocalInt(oItem, "_Writ_Timestamp");
        if(nNumSigs == 1)
        {
            //Lets put on the timestamp!
            //We'll do this for a month ahead aproximately
            int nMonth = GetCalendarMonth();
            int nYear = GetCalendarYear();
            SetName(oItem, GetName(oItem) + " (" + IntToString(nMonth) + "/" + IntToString(nYear) + ")");
            if(nMonth == 12)
            {
                nMonth = 1;
                nYear += 1;
            }
            int nTime = gsTIGetTimestamp(nYear, nMonth, GetCalendarDay(), GetTimeHour(), GetTimeMinute(), GetTimeSecond());
            SetLocalInt(oItem, "_Writ_Timestamp", nTime);
        }
        else if(gsTIGetActualTimestamp() > nTStamp || nTStamp == 0)
        {
            //It expired
            DestroyObject(oItem);
            SendMessageToPC(oActivator, "Writ Expired!");
        }
        else if(nNumSigs > (GetLocalInt(miCZLoadNation(sNation), VAR_NUM_LEADERS)/2))
        {
          //Never used this before.. unique tags to prvent stacking issues!
          SetTag(oItem, "micz_writ_sgn");
        }

        SetName(oItem, GetName(oItem) + "(signed by " + GetName(oActivator) + ")");
      }
      else
      {
        SendMessageToPC(oActivator, "You are not authorized to sign that writ.");
      }
    }

    //pirate stew
    if (sTag == "WT_PIRATESTEW")
    {
        float fValue = 50.0;
        //AssignCommand(oTarget, SpeakString(GS_T_16777235));
        AssignCommand(oActivator, gsSTAdjustState(GS_ST_FOOD, fValue));
        int nStewPoison = d4(1);
        if(nStewPoison == 1)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectPoison(7), oActivator, 0.0f);
        }
        return;
    }

    //water breathing potion
    if (sTag == "WT_WATERBREATHING")
    {
        SetLocalInt(oActivator, "WATER_BREATH", TRUE);
        AssignCommand(oTarget, SpeakString(GS_T_16777236));
        return;
    }

    //grog
    if (sTag == "WT_GROG")
    {
        float fValue = -30.0;
        //AssignCommand(oTarget, SpeakString(GS_T_16777236));
        AssignCommand(oActivator, gsSTAdjustState(GS_ST_SOBRIETY, fValue));
    }

    // poison.
    if (GetStringLeft(sTag, 9) == "MI_POISON")
    {
      miPODoPoison(oActivator, oTarget, oItem);
    }

    // Climbing rope
    if (sTag == "MI_CL_ROPE")
    {
      if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
          oTarget != oActivator)
      {
        SetLocalObject(oTarget, "MI_CL_HELPER", oActivator);
        SendMessageToPC(oTarget,fbNAGetGlobalDynamicName(oActivator) + " will help you climb.");
        SendMessageToPC(oActivator,"You will help " + fbNAGetGlobalDynamicName(oTarget) + " climb.");
      }
      else
      {
        SendMessageToPC(oActivator, "You must use the rope on another creature.");
      }
    }

    // slave clamp, this is used to make PC's able to remove/destroy their Prisoner Slave Clamp at any time they see fit.
    if (sTag == "GVD_SLAVE_CLAMP") {
      // check if it's the prisoner type
      if (GetName(oItem) == "Slave Clamp (Prisoner)") {
        // it's a prisoner slaveclamp, remove it
        SendMessageToPC(oActivator,"With some effort you finally are able to remove the Slave Clamp.");
        DestroyObject(oItem);
      } else {
        // it's a permanent slaveclamp, it won't come off
        SendMessageToPC(oActivator,"You try to remove the Slave Clamp by any means available to you, but it just won't come off.");
      }
    }

    // Oozemasters Jars (summoning)

    // we don't want this to be abused in the Cage Fights
    object oLever = GetObjectByTag("gvd_cf_lever");
    object oCageFighter = GetLocalObject(oLever,"oCF_PCFighter");
    if (oActivator == oCageFighter) {
      // not allowed
      SendMessageToPC(oActivator,"No magic allowed in this area.");

    } else {
      // someone else, it works
      if (GetStringLeft(sTag, 12) == "GVD_ACID_SUM") {
        int iOoze = StringToInt(GetStringRight(sTag,2));
        string sResRef = "";

        switch (iOoze) {
          case 1: {
            // Ochre Jelly Jar
            sResRef = "gvd_ochre_jelly";
            break;
          } case 2: {
            // Ooze Jar (Arcane)
            sResRef = "gvd_arcane_ooze";
            break;
          } case 3: {
            // Ooze Jar (Venom)
            sResRef = "gvd_venom_ooze";
            break;
          } case 4: {
            // Ooze Jar (Gray)
            sResRef = "gvd_ooze_gray";
            break;
          } case 5: {
            // Cube Jar (Blue)
            sResRef = "gvd_blue_cube";
            break;
          } case 6: {
            // Cube Jar (Gooey)
            sResRef = "gvd_getal_cube";
            break;
          } case 7: {
            // Cube Jar (Gelatin)
            sResRef = "gvd_gooey_cube";
            break;
          }
        }

        if (sResRef != "") {
          object oOoze = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLocation);
          AssignCommand(oOoze, SetIsDestroyable(TRUE,FALSE,FALSE));
          AssignCommand(oActivator, AddHenchman(oActivator, oOoze));
        }
      }
    }

    // visually visible gear items
    if (sTag == "GVD_QUIVER") {
      if (GetCreatureWingType(oActivator) == CREATURE_WING_TYPE_NONE) {
        // equip
        SetCreatureWingType(81, oActivator);
      } else {
        if (GetCreatureWingType(oActivator) == 81) {
          // unequip
          SetCreatureWingType(CREATURE_WING_TYPE_NONE, oActivator);
        }
      }
    }
    if (sTag == "GVD_BACKPACK") {
      if (GetCreatureWingType(oActivator) == CREATURE_WING_TYPE_NONE) {
        // equip
        SetCreatureWingType(79, oActivator);
      } else {
        if (GetCreatureWingType(oActivator) == 79) {
          // unequip
          SetCreatureWingType(CREATURE_WING_TYPE_NONE, oActivator);
        }
      }
    }
    if (sTag == "GVD_BACKPACK2") {
      if (GetCreatureWingType(oActivator) == CREATURE_WING_TYPE_NONE) {
        // equip
        SetCreatureWingType(80, oActivator);
      } else {
        if (GetCreatureWingType(oActivator) == 80) {
          // unequip
          SetCreatureWingType(CREATURE_WING_TYPE_NONE, oActivator);
        }
      }
    }
    if (sTag == "GVD_SCABBARD") {
      if (GetCreatureWingType(oActivator) == CREATURE_WING_TYPE_NONE) {
        // equip
        SetCreatureWingType(83, oActivator);
      } else {
        if (GetCreatureWingType(oActivator) == 83) {
          // unequip
          SetCreatureWingType(CREATURE_WING_TYPE_NONE, oActivator);
        }
      }
    }
    if (sTag == "GVD_SCABBARD2") {
      if (GetCreatureWingType(oActivator) == CREATURE_WING_TYPE_NONE) {
        // equip
        SetCreatureWingType(89, oActivator);
      } else {
        if (GetCreatureWingType(oActivator) == 89) {
          // unequip
          SetCreatureWingType(CREATURE_WING_TYPE_NONE, oActivator);
        }
      }
    }
    if (sTag == "GVD_SCABBARD3") {
      if (GetCreatureWingType(oActivator) == CREATURE_WING_TYPE_NONE) {
        // equip
        SetCreatureWingType(85, oActivator);
      } else {
        if (GetCreatureWingType(oActivator) == 85) {
          // unequip
          SetCreatureWingType(CREATURE_WING_TYPE_NONE, oActivator);
        }
      }
    }
    if (sTag == "GVD_SCABBARD4") {
      if (GetCreatureWingType(oActivator) == CREATURE_WING_TYPE_NONE) {
        // equip
        SetCreatureWingType(87, oActivator);
      } else {
        if (GetCreatureWingType(oActivator) == 87) {
          // unequip
          SetCreatureWingType(CREATURE_WING_TYPE_NONE, oActivator);
        }
      }
    }

    // added by Dunshine: minogon plant stuff
    if (sTag == "GVD_MINOGONCARD1") {
      // activate the minogon device it was used on
      if (GetStringLeft(GetTag(oTarget),17) == "gvd_minogon_panel") {
        // succes

        // retrieve the access code from the disc (if any)
        int iCode = GetLocalInt(oItem, "code");
        if (iCode == 0) {
          // variable might be gone due to relog/reset, try the description
          string sDesc = GetDescription(oItem);
          if (sDesc != "A disc") {
            iCode = StringToInt(GetStringRight(sDesc,4)) + 10000;
          } else {
            // the player didn't discover the code on the disc yet, so we'll put an hopefully impossible to guess number on the panel
            // (can't be longer then 4 digits because of the checking function in zdlg_gvd_min_pan, so try a negative number instead, since that's unlikely to be entered)
            iCode = -974;
          }
        }

        SetLocalInt(oTarget,"code", iCode);
        DestroyObject(oItem);
        SetLocalInt(oTarget,"active",1);
        SetName(oTarget,"Active Panel");
        FloatingTextStringOnCreature("The disc slides into an opening below the panel, it activates and is ready for use now.", oActivator);
      } else {
        FloatingTextStringOnCreature("You try to use the disc here, but it doesn't do anything.", oActivator);
      }
    }
    if (sTag == "GVD_MIN_TOOL1") {
      // magnifying glass, check the target
      if (GetStringLeft(GetTag(oTarget),15) == "gvd_minogoncard") {
        // used, on one of the discs, succes

        // check if the disc already has a code
        int iCode = GetLocalInt(oTarget, "code");
        if (iCode == 0) {
          // generate a random access code for the disc (0000 to 9999), store with an 10000 added to it for convenience
          iCode = 10000 + ((d100(1)-1)*100)+(d100(1)-1);
          SetLocalInt(oTarget, "code", iCode);
          SetDescription(oTarget,"A disc with access code " + GetStringRight(IntToString(iCode),4));
        }
        FloatingTextStringOnCreature("Using the magnifying glass on the disc reveals a number imprinted on it in tiny letters: " + GetStringRight(IntToString(iCode),4), oActivator);

      } else {
        // check if used on a treasure chest with a GVD_MAGNIFY_BONUS variable on it
        int iMagnifyBonus = GetLocalInt(oTarget ,"GVD_MAGNIFY_BONUS");
        if (iMagnifyBonus > 0) {
          // lower the lock DC with the bonus amount, and inform the PC of succes
          SetLockUnlockDC(oTarget, GetLockUnlockDC(oTarget) - iMagnifyBonus);
          FloatingTextStringOnCreature("Using the magnifying glass on the lock reveals a small mechanism you didn't notice before, you have disabled a part of the complex locking mechanism.", oActivator);

        } else {
          // check if it was used on Panel number 6, give the PC a hint about the second access code there
          if (GetTag(oTarget) == "gvd_minogon_panel6") {
            // the second code for this panel is the current year + month + day numbers combined, so tell the PC that the year numbers are heavily used, the month numbers regular, and the other numbers are not noticeable
            int nTime = gsTIGetActualTimestamp();
            string sYear = IntToString(gsTIGetYear(nTime));
            string sYearDigits = "";
            int iMonth = gsTIGetMonth(nTime);
            string sMonthDigits = "";
            int iNr;
            string sNr;

            // get numbers used from year first
            for (iNr = 0; iNr < 10; iNr = iNr + 1) {
              sNr = IntToString(iNr);
              if (FindSubString(sYear,sNr) >= 0) {
                sYearDigits = sYearDigits + sNr + ", ";
              }
            }

            // now get numbers used from month
            if (iMonth > 9) {
              // check if digit 1 is already in the year digits
              if (FindSubString(sYearDigits, "1") < 0) {
                // nope, add it to the month digits then
                sMonthDigits = sMonthDigits + "1" + ", ";
              }
            }
            // now check the rest of the month number
            if (iMonth != 11) {
              sNr = GetStringRight(IntToString(iMonth),1);
              if (FindSubString(sYearDigits, sNr) < 0) {
                // always present the numbers going up, to prevent giving away too much in case month = 10
                if (sNr == "0") {
                  sMonthDigits = "0, "+ sMonthDigits ;
                } else {
                  sMonthDigits = sMonthDigits + sNr + ", ";
                }
              }
            }

            if (sMonthDigits != "") {
              FloatingTextStringOnCreature("Using the magnifying glass you notice the following digits are heavily used: " + sYearDigits + "and the following digits are regularly used: " + sMonthDigits + "the other digits are used too, but not that regular.", oActivator);
            } else {
              FloatingTextStringOnCreature("Using the magnifying glass you notice the following digits are heavily used: " + sYearDigits + "the other digits are used too, but not that regular.", oActivator);
            }

          } else {
            // used on something else
            FloatingTextStringOnCreature("You use the magnifying glass on the object, but it doesn't reveal anything.", oActivator);
          }
        }
      }
    }

    // Some items added by Dunshine
    if (sTag == "GVD_POT_HEAL050") {
      // a half-full potion of heal, raise HP with half the maximum HPs
      effect eHalfHeal = EffectHeal(GetMaxHitPoints(oActivator) / 2);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eHalfHeal, oActivator);
    }

    if(GetStringLeft(sTag, 11) == "MD_JEWELBOX") {

      if (oTarget == oActivator) {
        // start a zdlg with the headbag
        SetLocalString(oActivator, "dialog", "zdlg_gvd_contain");
        SetLocalObject(oActivator, "gvd_container_conv", oItem);
        AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));

      } else {
        string sTagTarget = GetStringUpperCase(GetTag(oTarget));
        if ((GetBaseItemType(oTarget) == BASE_ITEM_RING || GetBaseItemType(oTarget) == BASE_ITEM_AMULET) && GetIdentified(oTarget) && !GetIsItemPropertyValid(GetFirstItemProperty(oTarget)) && (GetDroppableFlag(oTarget) == TRUE) && (GetItemCursedFlag(oTarget) == FALSE)) {
          // store the unpropertied ring/amulet
          int iContainerSucces = gvd_Container_AddObject(oItem, oTarget);
          if (iContainerSucces == 1) {
            SendMessageToPC(oActivator, "You've put the jewelry in the box.");
          } else {
            if (iContainerSucces == 9) {
              SendMessageToPC(oActivator, "That item cannot be put in this box.");
            } else {
              SendMessageToPC(oActivator, "The box is full.");
            }
          }

        } else {
          // invalid target
          SendMessageToPC(oActivator, "That item cannot be put in this bag.");
        }
      }
    }

    // keyring container item, two uses, on a base type item key, to store a key on the ring, and self use to retrieve a key through a zdlg
    if (sTag == "GVD_KEYRING") {

      if (oTarget == oActivator) {
        // start a zdlg with the keyring
        SetLocalString(oActivator, "dialog", "zdlg_gvd_contain");
        SetLocalObject(oActivator, "gvd_container_conv", oItem);
        AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));

      } else {
        if ((GetBaseItemType(oTarget) == BASE_ITEM_KEY) && (GetDroppableFlag(oTarget) == TRUE) && (GetItemCursedFlag(oTarget) == FALSE)) {
          // store a key
          int iContainerSucces = gvd_Container_AddObject(oItem, oTarget);
          if (iContainerSucces == 1) {
            SendMessageToPC(oActivator, "The key has been added to the keyring.");
          } else {
            if (iContainerSucces == 9) {
              SendMessageToPC(oActivator, "That item cannot be added to the keyring.");
            } else {
              SendMessageToPC(oActivator, "The keyring is full.");
            }
          }

        } else {
          // invalid target
          SendMessageToPC(oActivator, "That item cannot be added to the keyring.");
        }
      }
    }

    // headbag container item, two uses, on leader/outlaw/slaver heads, to store the head inside the bag, and self use to retrieve the head through a zdlg
    if (GetStringLeft(sTag, 11) == "GVD_HEADBAG") {

      if (oTarget == oActivator) {
        // start a zdlg with the headbag
        SetLocalString(oActivator, "dialog", "zdlg_gvd_contain");
        SetLocalObject(oActivator, "gvd_container_conv", oItem);
        AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));

      } else {
        string sTagTarget = GetStringUpperCase(GetTag(oTarget));
        if (((GetStringLeft(sTagTarget, 7) == "GS_HEAD") || (GetStringLeft(sTagTarget, 15) == "GVD_SLAVER_HEAD")) && (GetDroppableFlag(oTarget) == TRUE) && (GetItemCursedFlag(oTarget) == FALSE)) {
          // store the head
          int iContainerSucces = gvd_Container_AddObject(oItem, oTarget);
          if (iContainerSucces == 1) {
            SendMessageToPC(oActivator, "You've put the head in the bag.");
          } else {
            if (iContainerSucces == 9) {
              SendMessageToPC(oActivator, "That item cannot be put in this bag.");
            } else {
              SendMessageToPC(oActivator, "The bag is full.");
            }
          }

        } else {
          // invalid target
          SendMessageToPC(oActivator, "That item cannot be put in this bag.");
        }
      }
    }

    // mining bag container item, two uses, on ores and the likes, to store the in in the bag, and self use to retrieve them again through a zdlg
    if (GetStringLeft(sTag, 11) == "GVD_MINEBAG") {

      if (oTarget == oActivator) {
        // start a zdlg with the mining bag
        SetLocalString(oActivator, "dialog", "zdlg_gvd_contain");
        SetLocalObject(oActivator, "gvd_container_conv", oItem);
        AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));

      } else {
        string sTagTarget = GetStringUpperCase(GetTag(oTarget));
        if (((sTagTarget == "GS_ITEM451") ||  // coal
             (sTagTarget == "GS_ITEM458") ||  // clay
             (sTagTarget == "GS_ITEM385") ||  // granite
             (sTagTarget == "GS_ITEM381") ||  // marble
             (sTagTarget == "GS_ITEM722") ||  // salt
             (sTagTarget == "GS_ITEM302") ||  // sand
             (sTagTarget == "GS_ITEM901") ||  // softwood
             (sTagTarget == "GS_ITEM900") ||  // hardwood
             (sTagTarget == "GS_ITEM462") ||  // adamantine
             (sTagTarget == "GS_ITEM1000") || // arjale
             (sTagTarget == "GS_ITEM457") ||  // copper
             (sTagTarget == "GS_ITEM461") ||  // gold
             (sTagTarget == "GS_ITEM452") ||  // iron
             (sTagTarget == "GS_ITEM459") ||  // lead
             (sTagTarget == "GS_ITEM921") ||  // mithril
             (sTagTarget == "GS_ITEM460") ||  // silver
             (sTagTarget == "GS_ITEM496") ||  // tin
             (sTagTarget == "GS_ITEM497") ||  // zinc
             (sTagTarget == "GS_ITEM453") ||  // alexandrite
             (sTagTarget == "GS_ITEM454") ||  // amethyst
             (sTagTarget == "GS_ITEM455") ||  // adventurine
             (sTagTarget == "GS_ITEM456") ||  // diamond
             (sTagTarget == "GS_ITEM479") ||  // emerald
             (sTagTarget == "GS_ITEM471") ||  // fire agate
             (sTagTarget == "GS_ITEM472") ||  // fire opal
             (sTagTarget == "GS_ITEM470") ||  // fluorspar
             (sTagTarget == "GS_ITEM473") ||  // garnet
             (sTagTarget == "GS_ITEM474") ||  // greenstone
             (sTagTarget == "GS_ITEM475") ||  // malachite
             (sTagTarget == "GS_ITEM476") ||  // phenalope
             (sTagTarget == "GS_ITEM477") ||  // ruby
             (sTagTarget == "GS_ITEM478") ||  // sapphire
             (sTagTarget == "GS_ITEM480")     // topaz
            ) && (GetDroppableFlag(oTarget) == TRUE) && (GetItemCursedFlag(oTarget) == FALSE)) {
          // store the item
          int iContainerSucces = gvd_Container_AddObject(oItem, oTarget);
          if (iContainerSucces == 1) {
            SendMessageToPC(oActivator, "You've put the item in the bag.");
          } else {
            if (iContainerSucces == 9) {
              SendMessageToPC(oActivator, "That item cannot be put in this bag.");
            } else {
              SendMessageToPC(oActivator, "The bag is full.");
            }
          }

        } else {
          // invalid target
          SendMessageToPC(oActivator, "That item cannot be put in this bag.");
        }
      }
    }

    // hunting bag container item, two uses, on meats/hides, to store the in in the bag, and self use to retrieve them again through a zdlg
    if (GetStringLeft(sTag, 11) == "GVD_HUNTBAG") {

      if (oTarget == oActivator) {
        // start a zdlg with the hunting bag
        SetLocalString(oActivator, "dialog", "zdlg_gvd_contain");
        SetLocalObject(oActivator, "gvd_container_conv", oItem);
        AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));

      } else {
        string sTagTarget = GetStringUpperCase(GetTag(oTarget));
        if (((sTagTarget == "GS_ITEM854") ||  // large hide
            (sTagTarget == "GS_ITEM896") ||  // medium hide
            (sTagTarget == "GS_ITEM895") ||  // small hide
            (sTagTarget == "GS_ITEM897") ||  // big meat
            (sTagTarget == "GS_ITEM898") ||  // medium meat
            (sTagTarget == "GS_ITEM899") ||  // small meat
            (sTagTarget == "GS_ITEM335") ||  // Animal Sinew
            (sTagTarget == "AR_IT_HORNOFMAGI") ||  // Horn of a Magical Creature
            (sTagTarget == "CO_DISPBEASTH001") ||  // Displacer Beast Hide
            (sTagTarget == "DRAGONHIDE") ||  // Dragon Hide
            (sTagTarget == "GS_ITEM040") ||  // Arm Bones
            (sTagTarget == "AR_IT_BEHOLDEYE") ||  // Beholder Eye
            (sTagTarget == "IR_MONSTERHEAD") ||  // Head of a Giant
            (sTagTarget == "IR_GIANTBONE") ||  // Giant Bone
            (sTagTarget == "GS_ITEM039") ||  // Thighbone
            (sTagTarget == "X2_IT_CMAT_BONE") ||  // Large Bone
            (sTagTarget == "ANKHEGSHELL") ||  // Ankheg Shell
            (sTagTarget == "GS_ITEM824") ||  // Blood of a Magic Creature
            (sTagTarget == "IR_VENDOMSACK1") ||  // Venom Sac (Aranea)
            (sTagTarget == "IR_VENDOMSACK2") ||  // Venom Sac (Bebilith)
            (sTagTarget == "IR_VENDOMSACK3") ||  // Venom Sac (Asp)
            (sTagTarget == "IR_VENDOMSACK4") ||  // Venom Sac (Black Slaad)
            (sTagTarget == "IR_CRAWLERBRAIN") ||  // Brain Stem (Carrion Crawler)
            (sTagTarget == "IR_STINGERTAIL") ||  // Stinger Barb
            (sTagTarget == "NW_IT_MSMLMISC17") ||  // Dragon Blood
            (sTagTarget == "NW_IT_MSMLMISC06") ||  // Bodak's Tooth
            (sTagTarget == "NW_IT_MSMLMISC07") ||  // Ettercap's Silk Gland
            (sTagTarget == "NW_IT_MSMLMISC19") ||  // Fairy Dust
            (sTagTarget == "NW_IT_MSMLMISC08") ||  // Fire Beetle's Belly
            (sTagTarget == "NW_IT_MSMLMISC14") ||  // Gargoyle Skull
            (sTagTarget == "NW_IT_MSMLMISC09") ||  // Rakshasa's Eye
            (sTagTarget == "NW_IT_CREITEM201") ||  // Seagull Feather
            (sTagTarget == "NW_IT_MSMLMISC13") ||  // Skeleton's Knuckle
            (sTagTarget == "NW_IT_MSMLMISC10") ||  // Slaad's Tongue
            (sTagTarget == "AR_IT_SUBMISC005") ||  // Giant's Tooth
            (sTagTarget == "AR_IT_SUBMISC001") ||  // Illithid's Tentacle
            (sTagTarget == "AR_IT_SPECIAL003") ||  // Ogre's Tooth
            (sTagTarget == "AR_IT_SPECIAL004") ||  // Orc's Tooth
            (sTagTarget == "AR_IT_SPECIAL002")     // Pelt of a Yeti
            ) && (GetDroppableFlag(oTarget) == TRUE) && (GetItemCursedFlag(oTarget) == FALSE)) {
          // store the item
          int iContainerSucces = gvd_Container_AddObject(oItem, oTarget);
          if (iContainerSucces == 1) {
            SendMessageToPC(oActivator, "You've put the item in the bag.");
          } else {
            if (iContainerSucces == 9) {
              SendMessageToPC(oActivator, "That item cannot be put in this bag.");
            } else {
              SendMessageToPC(oActivator, "The bag is full.");
            }
          }

        } else {
          // invalid target
          SendMessageToPC(oActivator, "That item cannot be put in this bag.");
        }
      }
    }

    // Gem/gem dust bag container item, two uses, on cut gems/gem dust, to store them in in the bag, and self use to retrieve them again through a zdlg
    if (GetStringLeft(sTag, 11) == "GVD_GEMBAG_") {

      if (oTarget == oActivator) {
        // start a zdlg with the gem bag
        SetLocalString(oActivator, "dialog", "zdlg_gvd_contain");
        SetLocalObject(oActivator, "gvd_container_conv", oItem);
        AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));

      } else {
        string sTagTarget = GetStringUpperCase(GetTag(oTarget));
        if (((sTagTarget == "NW_IT_GEM013") ||   // Alexandrite
              (sTagTarget == "NW_IT_GEM003") ||    // Amethyst
              (sTagTarget == "NW_IT_GEM014") ||    // Aventurine
              (sTagTarget == "AR_ITEM_BELJUR") ||  // Beljuril
              (sTagTarget == "CRYSTAL") ||         // Crystal
              (sTagTarget == "NW_IT_GEM005") ||    // Diamond
              (sTagTarget == "NW_IT_GEM012") ||    // Emerald
              (sTagTarget == "NW_IT_GEM002") ||    // Fire Agate
              (sTagTarget == "NW_IT_GEM009") ||    // Fire Opal
              (sTagTarget == "NW_IT_GEM015") ||    // Fluorspar
              (sTagTarget == "NW_IT_GEM011") ||    // Garnet
              (sTagTarget == "NW_IT_GEM001") ||    // Greenstone
              (sTagTarget == "NW_IT_GEM007") ||    // Malachite
              (sTagTarget == "PEARL") ||           // Pearl
              (sTagTarget == "NW_IT_GEM004") ||    // Phenalope
              (sTagTarget == "AR_ITEM_ROGSTO") ||  // Rogue Stone
              (sTagTarget == "NW_IT_GEM006") ||    // Ruby
              (sTagTarget == "NW_IT_GEM008") ||    // Sapphire
              (sTagTarget == "AR_ITEM_STSAPH") ||  // Star Sapphire
              (sTagTarget == "NW_IT_GEM010") ||    // Topaz
              (sTagTarget == "GS_ITEM481") ||      // Gem Dust (Alexandrite)
              (sTagTarget == "GS_ITEM482") ||      // Gem Dust (Amethyst)
              (sTagTarget == "GS_ITEM483") ||      // Gem Dust (Aventurine)
              (sTagTarget == "GS_ITEM484") ||      // Gem Dust (Diamond)
              (sTagTarget == "GS_ITEM494") ||      // Gem Dust (Emerald)
              (sTagTarget == "GS_ITEM486") ||      // Gem Dust (Fire Agate)
              (sTagTarget == "GS_ITEM487") ||      // Gem Dust (Fire Opal)
              (sTagTarget == "GS_ITEM485") ||      // Gem Dust (Fluorspar)
              (sTagTarget == "GS_ITEM488") ||      // Gem Dust (Garnet)
              (sTagTarget == "GS_ITEM489") ||      // Gem Dust (Greenstone)
              (sTagTarget == "GS_ITEM490") ||      // Gem Dust (Malachite)
              (sTagTarget == "GS_ITEM491") ||      // Gem Dust (Phenalope)
              (sTagTarget == "GS_ITEM492") ||      // Gem Dust (Ruby)
              (sTagTarget == "GS_ITEM493") ||      // Gem Dust (Sapphire)
              (sTagTarget == "GS_ITEM495")         // Gem Dust (Topaz)
            ) && (GetDroppableFlag(oTarget) == TRUE) && (GetItemCursedFlag(oTarget) == FALSE)) {
          // store the item
          int iContainerSucces = gvd_Container_AddObject(oItem, oTarget);
          if (iContainerSucces == 1) {
            SendMessageToPC(oActivator, "You've put the item in the bag.");
          } else {
            if (iContainerSucces == 9) {
              SendMessageToPC(oActivator, "That item cannot be put in this bag.");
            } else {
              SendMessageToPC(oActivator, "The bag is full.");
            }
          }

        } else {
          // invalid target
          SendMessageToPC(oActivator, "That item cannot be put in this bag.");
        }
      }
    }

    // Trap kit container item, two uses, on trap kits, to store them in in the bag, and self use to retrieve them again through a zdlg
    if (GetStringLeft(sTag, 11) == "GVD_TRAPBOX") {

      if (oTarget == oActivator) {
        // start a zdlg with the gem bag
        SetLocalString(oActivator, "dialog", "zdlg_gvd_contain");
        SetLocalObject(oActivator, "gvd_container_conv", oItem);
        AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));

      } else {
        string sTagTarget = GetStringUpperCase(GetTag(oTarget));
                if (((sTagTarget == "NW_IT_TRAP034") ||  // Average Acid Splash Trap Kit
                    (sTagTarget == "NW_IT_TRAP014") ||  // Average Blob of Acid Trap Kit
                    (sTagTarget == "NW_IT_TRAP022") ||  // Average Electrical Trap Kit
                    (sTagTarget == "NW_IT_TRAP018") ||  // Average Fire Trap Kit
                    (sTagTarget == "NW_IT_TRAP030") ||  // Average Frost Trap Kit
                    (sTagTarget == "NW_IT_TRAP026") ||  // Average Gas Trap Kit
                    (sTagTarget == "NW_IT_TRAP006") ||  // Average Holy Trap Kit
                    (sTagTarget == "NW_IT_TRAP042") ||  // Average Negative Trap
                    (sTagTarget == "NW_IT_TRAP038") ||  // Average Sonic Trap Kit
                    (sTagTarget == "NW_IT_TRAP002") ||  // Average Spike Trap Kit
                    (sTagTarget == "NW_IT_TRAP010") ||  // Average Tangle Trap Kit
                    (sTagTarget == "NW_IT_TRAP036") ||  // Deadly Acid Splash Trap Kit
                    (sTagTarget == "NW_IT_TRAP016") ||  // Deadly Blob of Acid Trap Kit
                    (sTagTarget == "NW_IT_TRAP024") ||  // Deadly Electrical Trap Kit
                    (sTagTarget == "NW_IT_TRAP020") ||  // Deadly Fire Trap Kit
                    (sTagTarget == "NW_IT_TRAP032") ||  // Deadly Frost Trap Kit
                    (sTagTarget == "NW_IT_TRAP028") ||  // Deadly Gas Trap Kit
                    (sTagTarget == "NW_IT_TRAP008") ||  // Deadly Holy Trap Kit
                    (sTagTarget == "NW_IT_TRAP044") ||  // Deadly Negative Trap Kit
                    (sTagTarget == "NW_IT_TRAP040") ||  // Deadly Sonic Trap Kit
                    (sTagTarget == "NW_IT_TRAP004") ||  // Deadly Spike Trap Kit
                    (sTagTarget == "NW_IT_TRAP012") ||  // Deadly Tangle Trap Kit
                    (sTagTarget == "X2_IT_TRAP001") ||  // Epic Electrical Trap Kit
                    (sTagTarget == "X2_IT_TRAP002") ||  // Epic Fire Trap Kit
                    (sTagTarget == "X2_IT_TRAP003") ||  // Epic Frost Trap Kit
                    (sTagTarget == "X2_IT_TRAP004") ||  // Epic Sonic Trap Kit
                    (sTagTarget == "NW_IT_TRAP033") ||  // Minor Acid Splash Trap
                    (sTagTarget == "NW_IT_TRAP013") ||  // Minor Blob of Acid Trap Kit
                    (sTagTarget == "NW_IT_TRAP021") ||  // Minor Electrical Trap Kit
                    (sTagTarget == "NW_IT_TRAP017") ||  // Minor Fire Trap Kit
                    (sTagTarget == "NW_IT_TRAP029") ||  // Minor Frost Trap Kit
                    (sTagTarget == "NW_IT_TRAP025") ||  // Minor Gas Trap Kit
                    (sTagTarget == "NW_IT_TRAP005") ||  // Minor Holy Trap Kit
                    (sTagTarget == "NW_IT_TRAP041") ||  // Minor Negative Trap Kit
                    (sTagTarget == "NW_IT_TRAP037") ||  // Minor Sonic Trap Kit
                    (sTagTarget == "NW_IT_TRAP001") ||  // Minor Spike Trap Kit
                    (sTagTarget == "NW_IT_TRAP009") ||  // Minor Tangle Trap Kit
                    (sTagTarget == "NW_IT_TRAP035") ||  // Strong Acid Splash Trap
                    (sTagTarget == "NW_IT_TRAP015") ||  // Strong Blob of Acid Trap Kit
                    (sTagTarget == "NW_IT_TRAP023") ||  // Strong Electrical Trap Kit
                    (sTagTarget == "NW_IT_TRAP019") ||  // Strong Fire Trap Kit
                    (sTagTarget == "NW_IT_TRAP031") ||  // Strong Frost Trap Kit
                    (sTagTarget == "NW_IT_TRAP027") ||  // Strong Gas Trap Kit
                    (sTagTarget == "NW_IT_TRAP007") ||  // Strong Holy Trap Kit
                    (sTagTarget == "NW_IT_TRAP043") ||  // Strong Negative Trap Kit
                    (sTagTarget == "NW_IT_TRAP039") ||  // Strong Sonic Trap Kit
                    (sTagTarget == "NW_IT_TRAP003") ||  // Strong Spike Trap Kit
                    (sTagTarget == "NW_IT_TRAP011")     // Strong Tangle Trap Kit
            ) && (GetDroppableFlag(oTarget) == TRUE) && (GetItemCursedFlag(oTarget) == FALSE)) {
          // store the item
          int iContainerSucces = gvd_Container_AddObject(oItem, oTarget);
          if (iContainerSucces == 1) {
            SendMessageToPC(oActivator, "You've put the item in the toolbox.");
          } else {
            if (iContainerSucces == 9) {
              SendMessageToPC(oActivator, "That item cannot be put in this container.");
            } else {
              SendMessageToPC(oActivator, "The container is full.");
            }
          }

        } else {
          // invalid target
          SendMessageToPC(oActivator, "That item cannot be put in this bag.");
        }
      }
    }
    //druid sickle
    if(sTag == "ir_blessedsickle")
    {

        if(GetLevelByClass(CLASS_TYPE_DRUID, oActivator) && GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE && GetHasInventory(oTarget) &&
            GetLocalString(oTarget, "GS_TEMPLATE") != "" && GetLocalInt(oTarget, "GS_CHANCE") > 0)
        {
            DeleteLocalInt(oTarget, "GS_TIMEOUT");
        }
        else
            SendMessageToPC(oActivator, "Either you're not a druid or you used the sickle on the wrong placeable.");
        return;

    }
    // added by Dunshine: check if a drink generated by the Bar System is used
    if (GetStringLeft(sTag,11) == "GVD_BARSYS_") {

      // do the drinking animation
      AssignCommand(oActivator, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
      AssignCommand(oActivator, gsSTAdjustState(GS_ST_WATER, 25.0));

      // if alcoholic, adjust sobriety and rest as well
      if ((GetStringLeft(sTag,14) == "GVD_BARSYS_CUP") || (GetStringLeft(sTag,14) == "GVD_BARSYS_DRA")) {
        float fConstitution = IntToFloat(GetAbilityScore(oActivator, ABILITY_CONSTITUTION));
        float fSobriety     = 0.0;
        float fRest         = 0.0;
        fSobriety = -250.0 / fConstitution;
        fRest     = -25.0 / fConstitution;
        AssignCommand(oActivator, gsSTAdjustState(GS_ST_SOBRIETY, fSobriety));
        AssignCommand(oActivator, gsSTAdjustState(GS_ST_REST, fRest));
      }

      // if coffee, add 5% rest
      if (GetStringLeft(sTag,14) == "GVD_BARSYS_COF") {
        AssignCommand(oActivator, gsSTAdjustState(GS_ST_REST, 5.0));
      }

    }

    if (GetStringLeft(sTag, 11) == "GVD_SHOEPOL") {
      // shoe polish changes appearance on boots
      int iItemType = GetBaseItemType(oTarget);

      // targeting boots?
      if (iItemType == BASE_ITEM_BOOTS) {

        FloatingTextStringOnCreature("You apply the boot-polish to the boots.", oActivator);

        int iColor2 = StringToInt(GetStringRight(sTag,1));
        int iColor1 = StringToInt(GetStringLeft(GetStringRight(sTag,3),1));

        object oReplacement = CopyItemAndModify(oTarget, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_BOTTOM, iColor1, TRUE);
        object oReplacement2 = CopyItemAndModify(oReplacement, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_BOTTOM, iColor2, TRUE);
        DestroyObject(oReplacement);
        DestroyObject(oTarget);

      } else {
        // no valid target
        FloatingTextStringOnCreature("This is no valid target for the boot-polish.", oActivator);
      }
    }

    if (GetStringLeft(sTag, 12) == "GVD_SHOELACE") {
      // shoe lace changes appearance on boots
      int iItemType = GetBaseItemType(oTarget);

      // targeting boots?
      if (iItemType == BASE_ITEM_BOOTS) {

        FloatingTextStringOnCreature("You apply the boot-laces to the boots.", oActivator);

        int iColor = StringToInt(GetStringRight(sTag,1));

        object oReplacement = CopyItemAndModify(oTarget, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_MIDDLE, iColor, TRUE);
        DestroyObject(oTarget);

      } else {
        // no valid target
        FloatingTextStringOnCreature("This is no valid target for the boot-laces.", oActivator);
      }
    }

    if (GetStringLeft(sTag, 11) == "GVD_SHOELIN") {
      // shoe lining changes appearance on boots
      int iItemType = GetBaseItemType(oTarget);

      // targeting boots?
      if (iItemType == BASE_ITEM_BOOTS) {

        FloatingTextStringOnCreature("You apply the boot-lining to the boots.", oActivator);

        int iColor = StringToInt(GetStringRight(sTag,1));

        object oReplacement = CopyItemAndModify(oTarget, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP, iColor, TRUE);
        DestroyObject(oTarget);

      } else {
        // no valid target
        FloatingTextStringOnCreature("This is no valid target for the boot-lining.", oActivator);
      }
    }

    if (sTag == "GVD_HORSESHOE") {
      // horseshoe, brings luck
      effect eLuck = EffectSavingThrowIncrease(SAVING_THROW_ALL, d4(1), SAVING_THROW_TYPE_ALL);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLuck, oTarget, d6(1) * 600.0f);
      FloatingTextStringOnCreature("You kiss the horseshoe for some luck...", oActivator);
    }


    if (sTag == "IR_CURVEDBLADE")
    {
      // Assassin tool.  Corpses have the ID of the player they belong to
      // saved as GS_TARGET.
      string sVictimID = GetLocalString(oTarget, "GS_TARGET");
      int nBounty = miAZFulfilContract(sVictimID);

      if (nBounty)
      {
        WriteTimestampedLogEntry (GetName(oActivator) + " just claimed the bounty on " + GetName (oTarget));
        SetLocalObject(oTarget, "sep_azn_claimedby", oActivator);
      }
      gsCMCreateGold(nBounty * 3 / 4, oActivator);
    }

    // disguise kit (5% award item)
    if (sTag == "GVD_DISKIT") {
      // disguise kit
      AssignCommand(oActivator, ActionStartConversation(oActivator, "gvd_diskit", TRUE, FALSE));
    }

    //::Kirito Bladesinger's Blade
    if (sTag == "KI_BLDSGR")
    {
        BondBladeSingerBlade(oItem, oActivator);
    }
    //::Kirito Thieves Gloves
    if (sTag == "KI_THFGLV")
    {
        BondThievesGloves(oItem, oActivator);
    }

// ---  DM actions only below this line -- //
    if (! (GetIsDM(oActivator) ||
           GetIsDMPossessed(oActivator)))
        return;

    if (sTag == "GVD_GENDER_WAND") {
      // change gender on PC
      if (GetGender(oTarget) == GENDER_FEMALE) {

        // change the gender
        SetGender(oTarget, GENDER_MALE);

        // feedback
        SendMessageToPC(oTarget, "Your gender has been changed! The server needs a moment to get used to this");
        SendMessageToPC(oActivator, "Changed gender of " + GetName(oTarget) + " to male");

        // boot/rejoin character automatically
        SetLocalInt(oTarget, "GVD_GENDER_CHANGE_PORTAL", 1);
        miXFDoPortal(oTarget, GetLocalString(GetModule(), VAR_SERVER_NAME));

      } else if (GetGender(oTarget) == GENDER_MALE) {

        // change the gender
        SetGender(oTarget, GENDER_FEMALE);

        // feedback
        SendMessageToPC(oTarget, "Your gender has been changed! The server needs a moment to get used to this");
        SendMessageToPC(oActivator, "Changed gender of " + GetName(oTarget) + " to female");

        // boot/rejoin character automatically
        SetLocalInt(oTarget, "GVD_GENDER_CHANGE_PORTAL", 1);
        miXFDoPortal(oTarget, GetLocalString(GetModule(), VAR_SERVER_NAME));

      } else {
        SendMessageToPC(oActivator, "You can only change the Gender of male and female characters");
      }
    }

    //soulcatcher
    if (GetResRef(oItem) == "gs_item018" &&
        GetStringLeft(sTag, 6) == "GS_BA_")
    {
        if (GetIsObjectValid(oTarget) &&
            oTarget != oActivator)
        {
            if (GetIsPC(oTarget))
            {
                object oObject = CopyObject(oItem,
                                            GetLocation(oActivator),
                                            oActivator,
                                            "GS_BA_" + GetPCPublicCDKey(oTarget, TRUE));
                if (GetIsObjectValid(oObject))
                {
                    SetName(oObject, GetName(oTarget) + " (" + GetPCPlayerName(oTarget) + ")");
                    SetLocalString(oObject, "GS_BA_PNAME", GetName(oTarget));
                    SetLocalString(oObject, "GS_BA_CDKEY", GetPCPublicCDKey(oTarget));
                    SetLocalString(oObject, "GS_BA_IP", GetPCIPAddress(oTarget));
                    DestroyObject(oItem);
                }
            }
        }
        else
        {
            if (sTag == "GS_BA_VOID")
            {
                SendMessageToPC(oActivator, GS_T_16777424);
            }
            else
            {
                SendMessageToPC(
                    oActivator,
                    gsCMReplaceString(
                        GS_T_16777423,
                        GetSubString(sTag, 6, GetStringLength(sTag) - 6)));
            }
        }
        return;
    }

    // get/set area variables (bug in nwnx, so don't use this for now)
    //if (sTag == "GVD_DM_AREA_VAR") {
    //    SetLocalString(oActivator, "dialog", "zdlg_gvd_areavar");
    //    AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));
    //    return;
    //}

    // set area exploration xp tool
    if (sTag == "GVD_DM_AREA_XP") {
        SetLocalString(oActivator, "dialog", "zdlg_gvd_areaxp");
        AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));
        return;
    }

    if (oActivator == oTarget) return;

    //bonus/punishment
    if (sTag == "GS_XP_APPLY")
    {
        if (GetIsObjectValid(oTarget) && GetIsPC(oTarget))
        {
            SetLocalObject(oActivator, "GS_TARGET", oTarget);
            SetLocalString(oActivator, "dialog", "zdlg_dmwand");
            AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));
        }
        return;
    }

    //value
    if (sTag == "GS_DM_VALUE")
    {
        if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
            SendMessageToPC(
                oActivator,
                gsCMReplaceString(
                    GS_T_16777476,
                    GetName(oTarget),
                    IntToString(gsCMGetItemValue(oTarget))));
        return;
    }

    //::  DM Faerzress
    if (sTag == "GS_DM_FAERZRESS")
    {
        SetLocalString(oActivator, "dialog", "zdlg_dm_faer");
        AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));
        return;
    }

    //::  DM Read Object Variables
    if (sTag == "GS_DM_READVARS")
    {
        if ( GetIsObjectValid(oTarget) ) {
            SetLocalObject(oActivator, "AR_DM_STORED_PC", oTarget);
            SetLocalString(oActivator, "dialog", "zdlg_dm_vars");
            AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));
        }
        else {
            SendMessageToPC(oActivator, "Invalid Target - Please use on a valid target (Creature or Placeable).");
        }
        return;
    }

    //::  DM Apply Player Background
    if (sTag == "GS_DM_APPLY_BG")
    {
        if ( GetIsObjectValid(oTarget) ) {
            SetLocalObject(oActivator, "AR_DM_STORED_PC", oTarget);
            SetLocalString(oActivator, "dialog", "zdlg_dm_applybg");
            AssignCommand(oActivator, ActionStartConversation(oActivator, "zdlg_converse", TRUE, FALSE));
        }
        else {
            SendMessageToPC(oActivator, "Invalid Target - Please use on a valid Player target.");
        }
        return;
    }

    //spawn encounter
    if (sTag == "GS_EN_CREATE")
    {
        SetLocalLocation(oActivator, "GS_TARGET", lLocation);
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_en_create", TRUE, FALSE));
        return;
    }

    //edit dynamic encounter
    if (sTag == "GS_EN_EDIT")
    {
        int bNight = GetLocalInt(oItem, "NIGHT");
        SetLocalInt(oActivator, "NIGHT", bNight);
        if (GetIsObjectValid(oTarget)) gsENSetCreature(oTarget, 5, GetArea(oTarget), bNight);
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_en_edit", TRUE, FALSE));
        return;
    }

    //edit boss encounter
    if (sTag == "GS_BO_EDIT")
    {
        if (GetIsObjectValid(oTarget)) gsBOSetCreature(oTarget, GetArea(oTarget));
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_bo_edit", TRUE, FALSE));
        return;
    }

    //edit permanent placeables
    if (sTag == "GS_PL_EDIT")
    {
        if (! GetIsObjectValid(oTarget))
        {
            oTarget = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, lLocation);

            if (GetIsObjectValid(oTarget) &&
                GetDistanceBetweenLocations(lLocation, GetLocation(oTarget)) > 1.0)
            {
                oTarget = OBJECT_INVALID;
            }
        }

        if (GetIsObjectValid(oTarget)) gsPLAddPlaceable(oTarget);
        AssignCommand(oActivator, ActionStartConversation(oActivator, "gs_pl_edit", TRUE, FALSE));
        return;
    }

    //debug
    if (sTag == "GS_DM_DEBUG")
    {
        Log("ACTIVATE", "Starting debug");
        SetLocalObject(oActivator, "GS_TARGET", oTarget);
        SetLocalLocation(oActivator, "GS_LTARGET", lLocation);
        AssignCommand(oActivator, ActionDoCommand(_dlgStart(oActivator, oActivator, "zz_co_debug", TRUE, TRUE)));
        return;
    }

    // Vampiremaker (major award only, and only with admin approval)
    if (sTag == "GVD_DM_VAMPIRE")
    {
      // check if the player has indeed a major award for this
      string sID = gsPCGetCDKeyID(GetPCPublicCDKey(oTarget));
      int iMajorAwards = StringToInt(miDAGetKeyedValue("gs_player_data",sID,"award1"));

      if (iMajorAwards > 0) {

        WriteTimestampedLogEntry("MAJOR AWARD: PC " + GetName(oTarget) + " turned into a Vampire by " + GetName(oActivator));
        object oHide = gsPCGetCreatureHide(oTarget);
        SetSubRace(oTarget, gsSUGetNameBySubRace(GS_SU_SPECIAL_VAMPIRE));
        SetLocalInt(oHide, "GIFT_SUBRACE", TRUE);
        SetLocalInt(oHide, MI_TOTEM, MI_TO_VAMPIRE_BAT);
        gsSUApplyProperty(oHide, GS_SU_SPECIAL_VAMPIRE, GetHitDice(oTarget));

        miDASetKeyedValue("gs_player_data", sID, "award1", IntToString(iMajorAwards - 1));

        SendMessageToPC(oActivator, "You turned " + GetName(oTarget) + "into a Vampire succesfully.");
        SendMessageToPC(oTarget, "You turned into a Vampire!");

      } else {
        SendMessageToPC(oActivator, "This player has no major award.");
      }

    }

    // Cambionmaker (major award only, and only with admin approval)
    if (sTag == "GVD_DM_CAMBION")
    {
      // check if the player has indeed a major award for this
      string sID = gsPCGetCDKeyID(GetPCPublicCDKey(oTarget));
      int iMajorAwards = StringToInt(miDAGetKeyedValue("gs_player_data",sID,"award1"));

      if (iMajorAwards > 0) {

        WriteTimestampedLogEntry("MAJOR AWARD: PC " + GetName(oTarget) + " turned into a Cambion by " + GetName(oActivator));
        object oHide = gsPCGetCreatureHide(oTarget);
        SetSubRace(oTarget, gsSUGetNameBySubRace(GS_SU_SPECIAL_CAMBION));
        SetLocalInt(oHide, "GIFT_SUBRACE", TRUE);

        ModifyAbilityScore(oTarget, ABILITY_STRENGTH, 2);
        ModifyAbilityScore(oTarget, ABILITY_CHARISMA, 4);
        gsSUApplyProperty(oHide, GS_SU_SPECIAL_CAMBION, GetHitDice(oTarget));

        miDASetKeyedValue("gs_player_data", sID, "award1", IntToString(iMajorAwards - 1));

        SendMessageToPC(oActivator, "You turned " + GetName(oTarget) + "into a Cambion succesfully.");
        SendMessageToPC(oTarget, "You turned into a Cambion!");

      } else {
        SendMessageToPC(oActivator, "This player has no major award.");
      }

    }

    // Dragonmaker (major award only, and only with admin approval)
    if (sTag == "GVD_DM_DRAGON")
    {
      // flag the PC with an override var, so it can select dragon subrace on creation
      WriteTimestampedLogEntry("MAJOR AWARD: PC " + GetName(oTarget) + " was allowed to choose Dragon by " + GetName(oActivator));

      // since there are different colors, re-using this item, will scroll through the different ones
      int iTotem = GetLocalInt(oTarget, "MI_TOTEM");
      if (iTotem == 0) {
        iTotem = MI_TO_DRG_BLACK;
      } else {
        if (iTotem < MI_TO_DRG_WHITE) {
          iTotem = iTotem + 1;
        } else {
          iTotem = MI_TO_DRG_BLACK;
        }
      }

      SetLocalInt(oTarget, "MI_TOTEM", iTotem);
      SendMessageToPC(oActivator, "You made Dragon (" + GetTotemName(iTotem) + ") available in subrace selection for " + GetName(oTarget) + " succesfully.");

      SendMessageToPC(oTarget, "You can now choose Dragon (" + GetTotemName(iTotem) + ") as a subrace");
      SetLocalInt(oTarget, "override_allow_dragon", 1);

    }
    // Rakshasa maker (major award only, and only with admin approval)
    if (sTag == "GVD_DM_RAKSHASA")
    {
      // flag the PC with an override var, so it can select dragon subrace on creation
      WriteTimestampedLogEntry("MAJOR AWARD: PC " + GetName(oTarget) + " was allowed to choose Rakshasa by " + GetName(oActivator));
      SendMessageToPC(oActivator, "You made Rakshasa available in subrace selection for " + GetName(oTarget) + " succesfully.");
      SendMessageToPC(oTarget, "You can now choose Rakshasa as a subrace");
      SetLocalInt(oTarget, "override_allow_rakshasa", 1);
    }

    // Horse Gift tool, DMs can use this to add horse gift to a character, only for medium awards though
    if (sTag == "GVD_DM_HORSEGIFT")
    {
      // check if the player has indeed a medium award for this
      string sID = gsPCGetCDKeyID(GetPCPublicCDKey(oTarget));
      int iMediumAwards = StringToInt(miDAGetKeyedValue("gs_player_data",sID,"award2"));

      if (iMediumAwards > 0) {

        WriteTimestampedLogEntry("MEDIUM AWARD: PC " + GetName(oTarget) + " received the Horse Riding gift by " + GetName(oActivator));
        object oHide = gsPCGetCreatureHide(oTarget);
        SetLocalInt(oHide, "MAY_RIDE_HORSE", 1);

        miDASetKeyedValue("gs_player_data", sID, "award2", IntToString(iMediumAwards - 1));

        SendMessageToPC(oActivator, "You gave " + GetName(oTarget) + "the Horse Riding gift succesfully.");
        SendMessageToPC(oTarget, "You can now ride horses!");

      } else {
        SendMessageToPC(oActivator, "This player has no medium award, it's possible they have a greater/major award but to prevent unwanted spending of those, this is not automated with this tool.");
      }

    }

    // DM Area Text Widget
    // TO-DO: - Probably make this into a conversation-based widget later.
    //        - Add hooks in inc_bloodstains, maybe inc_divination?
    if (sTag == "BAT_DM_AREATEXTTOOL")
    {
      object oArea = GetArea(oActivator);

      if(GetLocalString(oArea, "GS_TEXT") == "")
      {
        SetLocalInt(oActivator, "BAT_SETTINGAREATEXT", TRUE);
        SendMessageToPC(oActivator,
        "Speak your desired flavor text in any channel. The text will be automatically enclosed in brackets. " +
        "What you say won't be visible to any players.\n" +
        "If you do not want to set this area's flavor text, type -cancel to escape. " +
        "When a character enters the area, your spoken flavor text will appear in their combat log.");
      }

      else
      {
        DeleteLocalString(oArea, "GS_TEXT");
        SendMessageToPC(oActivator, "You have removed this area's flavor text. Use the tool again to set new text.");
      }
    }
}

//::///////////////////////////////////////////////
//:: ExecuteCustomItemBehaviors
//:://////////////////////////////////////////////
/*
    Runs custom behaviors associated with the
    item, either via tag or variable.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 12, 2017
//:://////////////////////////////////////////////
void ExecuteCustomItemBehaviors()
{
    int i;
    object oActivator = GetItemActivator();
    object oItem = GetItemActivated();
    string sScript;
    string sTag = GetStringUpperCase(ConvertedStackTag(oItem));
    string sVar = GetStringLowerCase(GetLocalString(oItem, "SCRIPT"));

    //::  If the Item has a variable SCRIPT, we'll try and fire the script by the given value.
    //::  This is an alternative to the TAG based system below to work-around stacking behaviour.
    if (sVar != "") {
        ExecuteScript(sVar, OBJECT_SELF);
    }
    //custom: item tag must have prefix 'I_' and script named like item tag must be provided
    else if (GetStringLeft(sTag, 2) == "I_")
    {
        ExecuteScript(sTag, OBJECT_SELF);
    }
    // Alternate custom script approach. Allows use of multiple scripts on one item for
    // improved modularity.
    do
    {
        i++;
        sScript = GetLocalString(oItem, "RUN_ON_USE_" + IntToString(i));
        ExecuteScript(sScript, oActivator);
    } while(sScript != "");
    if(GetItemActivatedTarget() == oActivator)
    {
        i = 0;
        do
        {
            i++;
            sScript = GetLocalString(oItem, "RUN_ON_USE_SELF_" + IntToString(i));
            ExecuteScript(sScript, oActivator);
        } while(sScript != "");
    }
    else
    {
        i = 0;
        do
        {
            i++;
            sScript = GetLocalString(oItem, "RUN_ON_USE_TARGET_" + IntToString(i));
            ExecuteScript(sScript, oActivator);
        } while(sScript != "");
    }
}
