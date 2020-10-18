#include "inc_assassin"
#include "inc_associates"
#include "inc_backgrounds"
#include "inc_bonuses"
#include "inc_chatutils"
#include "inc_checker"
#include "inc_class"
#include "inc_common"
#include "inc_disguise"
#include "inc_death"
#include "inc_effect"
#include "inc_external"
#include "inc_factions"
#include "inc_language"
#include "inc_pc"
#include "inc_relations"
#include "inc_rename"
#include "inc_shop"
#include "inc_spellsword"
#include "inc_text"
#include "inc_werewolf"
#include "inc_xfer"
#include "inc_zombie"
#include "nwnx_alts"
#include "x3_inc_horse"

void _FixXPECL(object oPC, int nSubRace);
void _CreateDefaultSetting(object pc, string name, int value);

// copied from gs_m_equip, since that one can't be included
void gsUnequipItem(object oItem)
{
    if (GetHasSpellEffect(SPELL_CHARM_MONSTER) ||
        GetHasSpellEffect(SPELL_CHARM_PERSON) ||
        GetHasSpellEffect(SPELL_CHARM_PERSON_OR_ANIMAL) ||
        GetHasSpellEffect(SPELL_MASS_CHARM))
    {
      // We get item duplication if we allow this.  Since charmed folks can't
      // do much, let them equip the item.
      return;
    }
    gsCMCopyItem(oItem, OBJECT_SELF, TRUE);
    DestroyObject(oItem);
}

void _PerformChestSave(object oChest, string sID)
{
    gsCOSave(sID, oChest, 100);
}
void _ShopBugFix(object oAcquired, object oAcquiredFrom, object oAcquiredBy)
{
    string sIDDebug2   = GetLocalString(oAcquiredFrom, "GS_CLASS") + "_" +
                       IntToString(GetLocalInt(oAcquiredFrom, "GS_INSTANCE"));
    SQLExecStatement("SELECT * FROM gs_container_data WHERE container_id=? AND item_number=?", sIDDebug2,  IntToString(GetLocalInt(oAcquired, SLOT_VAR)));
    string sLogMsg = "SHOP ITEM NOT FOUND FROM A SHOP LOST AND FOUND ITEM  " + GetTag(oAcquired) + " Name: " + GetName(oAcquired) + "CD Key: " + GetPCPublicCDKey(oAcquiredBy) + " StackSize: " + IntToString(GetItemStackSize(oAcquired)) + " ON: " + GetName(oAcquiredBy) + " SHOP INFO: " + sIDDebug2 + " " + GetName(GetArea(oAcquiredFrom)) + " " + GetName(oAcquiredFrom);
    if(SQLFetch())
        sLogMsg += " ITEM FOUND IN DATABASE.";
    SendMessageToAllDMs(sLogMsg);
    WriteTimestampedLogEntry(sLogMsg);
    if(GetLocalString(oAcquired, "STOLEN_DUE_TO_STACK2") == "")
        SetLocalString(oAcquired, "STOLEN_DUE_TO_STACK2", sLogMsg);
    RemoveItemNoStack(oAcquired);
    string sBugTag = GetTag(oAcquired);


    if(GetStringLeft(sBugTag, 6) == "GS_SH_")
        SetTag(oAcquired, GetStringRight(sBugTag, GetStringLength(sBugTag) - 6));

    SetStolenFlag(oAcquired, FALSE);
    DeleteLocalInt(oAcquired, CUSTOM_PRICE);
    DeleteLocalInt(oAcquired, SLOT_VAR);
    DeleteLocalString(oAcquired, NO_STACK_TAG);
    ConvertItemToNoStack(oAcquired);
    //SendMessageToPC(oAcquiredBy, "An error was found with " + GetName(oAcquired) + " a DM may be able to return it.");


}

void _ShopBugFix2(object oAcquired, object oAcquiredBy)
{
    string sOldTag = GetLocalString(oAcquired, NO_STACK_TAG);
    if(GetStringLeft(sOldTag, 6) == "GS_SH_")
    {
        object oShopDebug = GetLocalObject(oAcquired, "GS_SH_CONTAINER");
        string sIDDebug   = GetLocalString(oShopDebug, "GS_CLASS") + "_" +
                       IntToString(GetLocalInt(oShopDebug, "GS_INSTANCE"));

        string sMsg = "STOLEN ITEM FROM STACKING ISSUE: " + "Item: " + GetName(oAcquired) + " Item Old Tag: " + sOldTag + " On: " + GetName(oAcquiredBy) + "CD Key: " + GetPCPublicCDKey(oAcquiredBy) + " Shop Info: " + sIDDebug + " " + GetName(GetArea(oShopDebug));
        WriteTimestampedLogEntry(sMsg);
        SendMessageToAllDMs(sMsg);
        DeleteLocalInt(oAcquired, CUSTOM_PRICE);
        SetStolenFlag(oAcquired, FALSE);
        DeleteLocalInt(oAcquired, SLOT_VAR);
        if(GetLocalString(oAcquired, "STOLEN_DUE_TO_STACK") == "")
            SetLocalString(oAcquired, "STOLEN_DUE_TO_STACK", sMsg);
        SetTag(oAcquired, GetStringRight(sOldTag, GetStringLength(sOldTag) - 6));

        DeleteLocalString(oAcquired, NO_STACK_TAG);
        ConvertItemToNoStack(oAcquired);
    }

}
void _OnPCShopBugFix(object oPC)
{
    object oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
        if(GetStringLeft(GetTag(oItem), 6) == "GS_SH_")
           _ShopBugFix(oItem, GetLocalObject(oItem, "GS_SH_CONTAINER"), oPC);

        _ShopBugFix2(oItem, oPC);
        oItem = GetNextItemInInventory(oPC);
    }
   // DelayCommand(3.0, _PerformChestSave(oChest, "GS_CONTAINER_DM_01"));
}
void main()
{
    object oEntering   = GetEnteringObject();

    if (GetLocalInt(OBJECT_SELF, "MI_DATABASE_SCREWED") == TRUE)
    {
      // The database is currently inaccessible.  This is a Really Bad Thing
      // (tm) so we don't let players log in, and we warn DMs.
      if (GetIsDM(oEntering))
      {
         DelayCommand(5.0, SendMessageToPC(oEntering,
          "--!WARNING!--\nThe database server is currently unavailable.  Players " +
          "will not be allowed to log in until the problem is corrected.  If you " +
          "are not a server administrator, try restarting the server.  If this " +
          "does not correct the problem, contact a server admin."));
      }
      else
      {
        BootPC(oEntering);
        return;
      }
    }

    // Added by Mithreas - check for characters no longer meeting requirements,
    // or accounts being hijacked.
    //
    // We have to call this code now, before we create the database entry for
    // a new character.
    miCLCheckIsIllegal(oEntering);
    miXFRegisterPlayer(oEntering);
    miXFUpdatePlayerName(oEntering, svGetPCNameOverride(oEntering));

    // Tails.
    if (!GetCreatureTailType(oEntering)) SetCreatureTailType(14, oEntering);

    // Update event handlers if needed.
    miRESetPCEventHandlers(oEntering);
    SetListenPattern(oEntering, "*a", 100);
    SetListening(oEntering, TRUE);

    // Edit by Mithreas - create on DMs all the tools they want/need. --[
    if (GetIsDM(oEntering))
    {
      if (GetItemPossessedBy(oEntering, "dmfi_exploder") == OBJECT_INVALID)
             CreateItemOnObject("dmfi_exploder", oEntering); // DMFI master
      if (GetItemPossessedBy(oEntering, "obj_setname") == OBJECT_INVALID)
             CreateItemOnObject("obj_setname", oEntering); // Set Name widget
      if (GetItemPossessedBy(oEntering, "obj_rankquery") == OBJECT_INVALID)
             CreateItemOnObject("obj_rankquery", oEntering);
      //if (GetItemPossessedBy(oEntering, "gs_item315") == OBJECT_INVALID)
      //       CreateItemOnObject("gs_item315", oEntering); // DM create encounter
      if (GetItemPossessedBy(oEntering, "gs_item110") == OBJECT_INVALID)
             CreateItemOnObject("gs_item110", oEntering); // DM PC actions
      if (GetItemPossessedBy(oEntering, "gs_item018") == OBJECT_INVALID)
             CreateItemOnObject("gs_item018", oEntering); // DM soulcatcher

      chatEnter(oEntering);
      DelayCommand(3.0, AssignCommand(oEntering,
                                      ActionSpeakString("-rp_ratings")));
      DelayCommand(3.0, AssignCommand(oEntering,
                                      ActionSpeakString("-forceactive list")));
      return;
    }
    // ]-- End edit.

    fbEXClear(oEntering);

    string sPlayer     = GetPCPlayerName(oEntering);
    string sCDKey      = GetPCPublicCDKey(oEntering, TRUE);
    string sIP         = GetPCIPAddress(oEntering);
    string sName       = GetName(oEntering);
    object oHide       = gsPCGetCreatureHide(oEntering);

    if (gsPCGetIsPlayerBanned(oEntering))
    {
      SendMessageToAllDMs(gsCMReplaceString(GS_T_16777425, sPlayer, sCDKey, sIP, sName));
      BootPC(oEntering, GetStringByStrRef(10455));

      // Relink the ban if necessary
      gsPCBanPlayer(oEntering);
      return;
    }

    //enter message
    SendMessageToAllDMs(gsCMReplaceString(GS_T_16777598, sPlayer, sCDKey, sName));
    WriteTimestampedLogEntry(gsCMReplaceString(GS_T_16777441, sPlayer, sCDKey, sIP, sName));

    // Check whether we're a ghost with no corpse.  If so, respawn.
	if (GetLocalInt(oHide, "IS_GHOST") && !GetIsObjectValid(GetLocalObject(oEntering, "GS_CORPSE")))
	{
	  MakeLiving(oEntering);
	}

    // Journal entries and button flash.
    SetPanelButtonFlash(oEntering, PANEL_BUTTON_JOURNAL, FALSE);

	AddJournalQuestEntry("intro",1,oEntering, FALSE);
	AddJournalQuestEntry("alignment",1,oEntering, FALSE);
	AddJournalQuestEntry("greatwar",1,oEntering, FALSE);
	AddJournalQuestEntry("magic",1,oEntering, FALSE);
	
	if (GetRacialType(oEntering) == RACIAL_TYPE_ELF)
	{
	  AddJournalQuestEntry("elvenmanners",1,oEntering, FALSE);
	}
	else
	{
	  AddJournalQuestEntry("city",1,oEntering, FALSE);
	  AddJournalQuestEntry("houses",1,oEntering, FALSE);
	  AddJournalQuestEntry("perenor",1,oEntering, FALSE);
	  AddJournalQuestEntry("honour",1,oEntering, FALSE);
	}
	
    if (GetHitDice(oEntering) == 1)
    {
      if (GetLocalInt(oEntering, "GS_ENABLED"))
      {
        // Someone has remade a character with the same name as an old one.
        // This can cause server crashes.  The following code works around the
        // problem.
        DeleteLocalInt(oEntering, "GS_ENABLED");
      }
    }

    if (GetLocalInt(oEntering, "GS_ENABLED"))
    {
        //restore health
        int nHealth = GetLocalInt(gsCMGetCacheItem("HEALTH"),
                                  "GS_HEALTH_" + ObjectToString(oEntering));

        //remove polymorph
        gsFXRemoveEffect(oEntering, OBJECT_INVALID, EFFECT_TYPE_POLYMORPH);
        gsFXRemoveEffect(oEntering, OBJECT_INVALID, EFFECT_TYPE_TEMPORARY_HITPOINTS);

        gsCMSetHitPoints(nHealth, oEntering);

        SetLocalInt(oEntering, "GS_ENABLED", -1);

        // Remove timers.
        DeleteLocalInt(oEntering, "GSTimer");
        DeleteLocalInt(oEntering, "TSTimer");
        DeleteLocalInt(oEntering, "GSTimerPoly");

		// Remove praying flag
		DeleteLocalInt(oEntering, "PRAYING");
    }

    //memorize class data
    gsPCMemorizeClassData(oEntering);

    // dunshine: store class data in db
    gvd_UpdateArelithClassesInDB(oEntering);

    if(GetHitDice(oEntering) > 1)
    {
        // Handle class bonus updates for established PCs. New PCs will instead be handled on initialization.
        DelayCommand(0.0, ApplyCharacterBonuses(oEntering, FALSE, FALSE, TRUE));
    }
    _FixXPECL(oEntering, gsSUGetSubRaceByName(GetSubRace(oEntering)));
    //activity
    SetLocalInt(oEntering, "GS_ACTIVE", TRUE);

    // Added by Mithreas - register with Talus listener and database --[
    chatEnter(oEntering);
    // ]--


    // Added by Mithreas - cache PC information
    gsPCCacheValues(oEntering);

    // Reset Warlock spell lists.
    if (miWAGetIsWarlock(oEntering))
    {
      miWASetSpells(oEntering);

      // Check for old warlocks and disable their staves.
      object oStaff = miWAGetWarlockStaff(oEntering);

      if (GetIsObjectValid(oStaff))
      {
        // Migration code.
        miWAStripStaffAbilities(oStaff);
      }
    }

    // Check for new faction messages.
    DelayCommand(1.0, md_FactionClientEnter(oEntering));
    DelayCommand(0.1, _OnPCShopBugFix(oEntering));
    // Welcome message
    string sWelcome = GetLocalString(GetModule(), "WELCOME_MESSAGE");
    if (sWelcome != "") FloatingTextStringOnCreature(sWelcome, oEntering, FALSE);

    // Assassin warning!
    if (miAZGetContractByVictim(gsPCGetPlayerID(oEntering)).nValue)
    {
      gvdAZMessenger(gsPCGetPlayerID(oEntering));
    }

    // Dunshine: check for artifacts and flag them so we can track them later on
    int iItem;
    object oItem;
    if (GetLocalInt(oHide, "gvd_artifact_legacy_checked") != 1) {
      oItem = GetFirstItemInInventory(oEntering);
      while (GetIsObjectValid(oItem)) {
        if ((GetName(oItem) == "Artefact") || (GetStringLeft(GetDescription(oItem),51) == "A curious artefact of unknown origin, discovered by")) {
          SetLocalInt(oItem, "gvd_artifact_legacy", 1);
        }

        oItem   = GetNextItemInInventory(oEntering);
      }
      // also check equipped items
      for (iItem = 0; iItem < NUM_INVENTORY_SLOTS; ++iItem) {
        oItem = GetItemInSlot(iItem, oEntering);
        if (GetIsObjectValid(oItem)) {
          if ((GetName(oItem) == "Artefact") || (GetStringLeft(GetDescription(oItem),51) == "A curious artefact of unknown origin, discovered by")) {
            SetLocalInt(oItem, "gvd_artifact_legacy", 1);
          }
        }
      }

      SetLocalInt(oHide, "gvd_artifact_legacy_checked", 1);
    }

    // Dunshine: always remove captured lasso object from PC when logging in
    DeleteLocalObject(oEntering, "gvd_lasso_capture");

    { // We always want to track the character's original portrait.

        if (GetLocalString(oHide, "PORTRAIT") == "")
        {
            SetLocalString(oHide, "PORTRAIT", GetPortraitResRef(oEntering));
        }
    }

    if (!GetIsPCDisguised(oEntering))
    {
        RestorePortrait(oEntering);
    }

    // Added by Fireboar - Run werewolf script. Need to re-apply if the PC logs
    // out, or apply if the PC logs in during hour 0.
    if (GetLocalInt(oEntering, "MI_AWIA") && GetCalendarDay() > 25 && GetTimeHour() == 0)
    {
      if (!GetLocalInt(oEntering, "MI_AWIA_ACTIVE"))
      {
        SetLocalInt(oEntering, "MI_AWIA_ACTIVE", TRUE);
      }
      miAWTransform(oEntering);
    }

    // Zombie day specific code.
    if (GetLocalInt(GetModule(), "ZOMBIE_MODE"))
    {
      if (fbZGetIsZombie(oEntering))
      {
        fbZZombieEffects(oEntering);
      }
      else
      {
        object oZombie = GetFirstPC();
        while (GetIsObjectValid(oZombie))
        {
          if (fbZGetIsZombie(oZombie))
          {
            SetPCDislike(oEntering, oZombie);
          }
          oZombie = GetNextPC();
        }
      }

      // On zombie days, everyone starts at level 10.
      if (GetXP(oEntering) < 45000)
      {
        // If not a new character, keep them in a safe area until they've finished levelling.
        if (GetXP(oEntering) > 1000)
        {
          SendMessageToPC(oEntering, "A wizard did it.");
          SetLocalInt(oEntering, "GS_ENABLED", -2);
        }
        SetXP(oEntering, 45000);
      }
    }

	//::Kirito - Reset Spellsword acid imbue effect FLAG in case of log or crash
	SetLocalInt(oEntering, "SS_ACID_DAMAGE_OFF", 1);
	//::Kirito - Reset APR
	if (miSSGetIsSpellsword(oEntering))
    {
		//Re-Applies All Spellsword Bonuses
		miSSReApplyBonuses(oEntering, TRUE);
	}
	else
	{
		RestoreBaseAttackBonus(oEntering);
	}

    // Peppermint, 1-3-2016; Remove associate controller if present (due to crash/logout while
    // controller was present).
    RemoveAssociateCommand(oEntering);
    SetAssociateCount(oEntering, 0);

    // Check to remove lingering vine mine HiPS effect (in case of crash).
    IPRemoveMatchingItemProperties(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oEntering), ITEM_PROPERTY_BONUS_FEAT, DURATION_TYPE_PERMANENT, IP_CONST_FEAT_HIDE_IN_PLAIN_SIGHT);

    // Just in case this effect lingers from -respite. There shouldn't be any means for that to happen,
    // but one can never be too careful.
    SetImmortal(oEntering, FALSE);

    // Sweep quickbars to ensure there are no invalid spells.
    VerifyQuickbarMetaMagic(oEntering);

    // verify feat requirements, log anything that looks off
    VerifyFeatRequirements(oEntering);

    if (GetLocalInt(gsPCGetCreatureHide(oEntering), "REVEALED_TO_PARTY"))
    {
        AssignCommand(oEntering, SetStealthPartyRevealed(TRUE));
    }
    else
    {
        AssignCommand(oEntering, SetStealthPartyRevealed(FALSE));
    }

	// Add horse menu if not available
	HorseAddHorseMenu(oEntering);

    gsLAInitialiseLanguages(oEntering);
    UpdateTimelocks(oEntering);
    // Fix for bug where PCs would sometimes lose spontaneous spells on server transition.
    UpdateSpontaneousSpellReadyStates(oEntering);

    //For spellclutch save starting spell levels only once per reset
    if(!GetLocalInt(oEntering, "md_sc_fireonce"))
    {
        SetLocalInt(oEntering, "md_sc_fireonce", 1);
        md_SaveSpellLevel(oEntering, 0);
        md_SaveSpellLevel(oEntering, 1);
        md_SaveSpellLevel(oEntering, 2);
    }

    // Update feats etc.
    ExecuteScript("fl_check_legal", oEntering);

    // TODO: We need a library for settings in general.
    // The below code sets up default values for three settings:

    // -colour_mode: 1 [writes out untranslated text to the console, except for common]
    _CreateDefaultSetting(oEntering, "OUTPUT_COLOUR", 1);

    // -console_mode: 1 [mirrors all PC chat text to the right hand server window]
    _CreateDefaultSetting(oEntering, "OUTPUT_TO_CONSOLE", 1);

    // -prefix_mode: 1 [colour untranslated text, do not colour translated text]
    _CreateDefaultSetting(oEntering, "OUTPUT_PREFIX", 1);

    // default -adventure mode off
    _CreateDefaultSetting(oEntering, "GVD_ADVENTURE_MODE", 0);

    // Batra: Set DM_TIP var to 1: returns useful feedback message the first time they send a /dm message.
    if(!GetLocalInt(oEntering, "DM_TIP"))
    {
      SetLocalInt(oEntering, "DM_TIP", 1);
    }
	
	if (GetLocalFloat(oEntering, "AR_SCALE") > 0.0f)
	{
	    SetObjectVisualTransform(oEntering, OBJECT_VISUAL_TRANSFORM_SCALE, GetLocalFloat(oEntering, "AR_SCALE"));
	}
	
	// Cutscene ghost all PCs, to make dealing with lots of summons less annoying.
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneGhost()), oEntering);
}

void _FixXPECL(object oPC, int nSubRace)
{

    object oHide = gsPCGetCreatureHide(oPC);
    if(!GetLocalInt(oHide, "GIFT_SUBRACE")) return;   //disable if gift_subrace is already checked
    //IGNORe aasimar as they're getting an ECL increase.. no effect old ones.
    if(nSubRace == GS_SU_PLANETOUCHED_TIEFLING || nSubRace == GS_SU_PLANETOUCHED_AASIMAR) return;

    float fCurrentECL = GetLocalFloat(oHide, "ECL");
    int nRaceECL = gsSUGetECL(nSubRace, 0);
    //get effect orogs as specific as possible
    if((nSubRace == GS_SU_FR_OROG || nSubRace == GS_SU_HALFORC_OROG) && GetLocalInt(oHide, "IsFROrog") && fCurrentECL <= 6.0)
    {
        WriteTimestampedLogEntry("!!!SUBRACE!!!---ECL---OROG:"+GetName(oPC)+" OF "+ GetPCPlayerName(oPC) + " OLD ECL: "+ FloatToString(fCurrentECL) + " HD: " +  IntToString(GetHitDice(oPC)));
        SendMessageToAllDMs("!!!SUBRACE!!!---ECL---OROG:"+GetName(oPC)+" OF "+ GetPCPlayerName(oPC) + " OLD ECL: "+ FloatToString(fCurrentECL) + " HD: " +  IntToString(GetHitDice(oPC)));
        if(GetHitDice(oPC) > 6)
            SetXP(oPC, 15001); //enough xp for level 6 + 1

        SetLocalFloat(oHide, "ECL", fCurrentECL + 10);  //add offset
        SendMessageToPC(oPC, "You have been detected as having an incorrect ECL. Your level may have been dropped to 6 and your ECL has been adjusted correctly.");
    }
    else if(nSubRace == GS_SU_GNOME_DEEP && fCurrentECL < 0.0)
    {
        WriteTimestampedLogEntry("!!!SUBRACE!!!---ECL---DEEPGNOME:"+GetName(oPC)+" OF "+ GetPCPlayerName(oPC) + " OLD ECL: "+FloatToString(fCurrentECL) + " HD: " +  IntToString(GetHitDice(oPC)));
        SendMessageToAllDMs("!!!SUBRACE!!!---ECL---DEEPGNOME:"+GetName(oPC)+" OF "+ GetPCPlayerName(oPC) + " OLD ECL: "+FloatToString(fCurrentECL) + " HD: " +  IntToString(GetHitDice(oPC)));
        if(GetHitDice(oPC) > 6)
            SetXP(oPC, 15001); //enough xp for level 6 + 1
        SetLocalFloat(oHide, "ECL", fCurrentECL + 13); // add offset + 3 for smurf ECL
       SendMessageToPC(oPC, "You have been detected as having an incorrect ECL. Your level may have been dropped to 6 and your ECL has been adjusted correctly.");
    }
    else if(nRaceECL > 0) //I don't like this one! it's basically everyone. We can exclude ECL 3 races if they make it this far
    {
      //Recalculate what their ECL should be!
      object oAbility  = GetItemPossessedBy(oPC, "GS_SU_ABILITY");

      if (! GetIsObjectValid(oAbility))
      {
        oAbility  = CreateItemOnObject(GS_SU_TEMPLATE_ABILITY,  oPC);
      }
      float fNewECL = IntToFloat(nRaceECL) + 10.0;

      int nGift;
      int x;
      string sGift;
      for(x = 0; x < GetListSize(oAbility, "Gifts"); x++)
      {

        nGift = StringToInt(GetListElement(oAbility, "Gifts", x));

        if(nGift == GIFT_OF_ENDURANCE && FindSubString(GetDescription(oAbility), ": Gift of Endurance") > -1)
            fNewECL += 0.5; //old gift of endurance ecl
        else
            fNewECL += GetGiftECL(nGift);

        sGift += GetGiftName(nGift) + " ";
      }

      if(fCurrentECL == fNewECL) return; //ECL is expected value cancel out!

      //Uh oh ECL isn't expected value. But can still be caused by an award.. sadly we don't track -ECL awards.
      //greater awards can't current be used to purchase ECL awards.. Need to fix that
      int nAwardMaj =  GetLocalInt(oHide, "HAS_MAJOR_AWARD");
      int nAwardNor =  GetLocalInt(oHide, "HAS_NORMAL_AWARD");
      int nAwardMin = GetLocalInt(oHide, "HAS_MINOR_AWARD");
      if(!nAwardMaj &&
         !nAwardNor &&
         !nAwardMin)
         {
            //They don't have an award so it must be this most recent breakage! Maybe. Hopefully
            WriteTimestampedLogEntry("!!!SUBRACE!!!---ECL---OTHER (NO AWARD):"+GetName(oPC)+" OF "+ GetPCPlayerName(oPC) + " OLD ECL: "+FloatToString(fCurrentECL) + " SR: " + GetSubRace(oPC));
            SendMessageToPC(oPC, "You have been detected as having an incorrect ECL. Your ECL has been adjusted correctly.");
            SendMessageToAllDMs("!!!SUBRACE!!!---ECL---OTHER (NO AWARD):"+GetName(oPC)+" OF "+ GetPCPlayerName(oPC) + " OLD ECL: "+FloatToString(fCurrentECL)+ " SR: " + GetSubRace(oPC));
            SetLocalFloat(oHide, "ECL", fNewECL);
            return;
         }

       //Okay we can tell what award they don't have                         //good underdarker                                                           //rdd
       int nAward = GetLocalInt(oHide, "MAY_RIDE_HORSE") || gsSUGetIsUnderdarker(nSubRace) && GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD || GetIsObjectValid(GetItemPossessedBy(oPC, "gs_item917"));
       float fDifference = fNewECL - fCurrentECL;
       if(nAward && fDifference == IntToFloat(nRaceECL))
       {//other award has been selected and difference in ECL is equal to RaceECL, assume breakage
            WriteTimestampedLogEntry("!!!SUBRACE!!!---ECL---OTHER (NO ECL AWARD):"+GetName(oPC)+" OF "+ GetPCPlayerName(oPC) + " OLD ECL: "+FloatToString(fCurrentECL)+ " SR: " + GetSubRace(oPC));
            SendMessageToAllDMs("!!!SUBRACE!!!---ECL---OTHER (NO ECL AWARD):"+GetName(oPC)+" OF "+ GetPCPlayerName(oPC) + " OLD ECL: "+FloatToString(fCurrentECL)+ " SR: " + GetSubRace(oPC));
            SendMessageToPC(oPC, "You have been detected as having an incorrect ECL. Your ECL has been adjusted correctly.");
            SetLocalFloat(oHide, "ECL", fNewECL);
            return;
       }
       if(!nAward && fDifference > 0.0 && fDifference < 4.0 && (nAwardMaj && nRaceECL != 3) || (nAwardNor && nRaceECL != 2) || (nAwardMin && nRaceECL != 1))
       {
          //okay here we know the RACE ECL is not equal to possible -ECL awards!  So it's possible they took an award to lower their ECL, and we know they don't have another award
          if((fDifference == 1.0 && nAwardMin) || (fDifference == 2.0 && nAwardNor) ||(fDifference == 3.0 && nAwardMaj))
          {
            WriteTimestampedLogEntry("!!!SUBRACE!!!---ECL---OTHER (INCONCLUSIVE POSSIBLE AWARD):"+GetName(oPC)+" OF "+ GetPCPlayerName(oPC) + " OLD ECL: "+FloatToString(fCurrentECL)+ " SR: " + GetSubRace(oPC) + " " + sGift + " Expected ECL: " + FloatToString(fNewECL));
            return; //the difference matches.. we're going to assume they took ECL award no Change to ECL necessary
          }
       }
       //if they make it this far i have no idea why ECL is different.
       WriteTimestampedLogEntry("!!!SUBRACE!!!---ECL---OTHER (INCONCLUSIVE):"+GetName(oPC)+" OF "+ GetPCPlayerName(oPC) + " OLD ECL: "+FloatToString(fCurrentECL)+ " SR: " + GetSubRace(oPC) + " " + sGift + " Expected ECL: " + FloatToString(fNewECL));
    }
    object oAbility  = GetItemPossessedBy(oPC, "GS_SU_ABILITY");

    if (! GetIsObjectValid(oAbility))
    {
       oAbility  = CreateItemOnObject(GS_SU_TEMPLATE_ABILITY,  oPC);
    }
    //Fixing gift here too!

    int nGift;
    int x;
    for(x = 0; x < GetListSize(oAbility, "Gifts"); x++)

    {
        nGift = StringToInt(GetListElement(oAbility, "Gifts", x));
        //x++;
        if(nGift == GIFT_OF_FORTUNE && FindSubString(GetDescription(oAbility), GIFT_OF_FORTUNE_NAME_M) > -1)
        {
          //SendMessageToPC(oPC, "Found gift to fix" + IntToString(GIFT_OF_FORTUNE_M));
          SetListElement(oAbility, "Gifts", x, IntToString(GIFT_OF_FORTUNE_M));
        }
    }
}

void _CreateDefaultSetting(object pc, string name, int value)
{
    object hide = gsPCGetCreatureHide(pc);

    if (!GetIsObjectValid(hide))
    {
        // We don't have a hide, which means we're probably a brand new character, so let's try again.
        DelayCommand(30.0f, _CreateDefaultSetting(pc, name, value));
        return;
    }

    string initName = name + "_INIT";

    if (GetLocalInt(hide, initName))
    {
        // Already initialised. Just return.
        return;
    }

    SetLocalInt(hide, initName, 1);

    // Now we check if we have a value set already.
    // This is to support characters who may have chosen a setting value before the default value
    // system was introduced.
    int existingValue = GetLocalInt(hide, name);

    if (!existingValue)
    {
        // If no value is set, we initialise the variable to the default value.
        SetLocalInt(hide, name, value);
    }
}

