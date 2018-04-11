/*

  Z-Dialog conversation script for container objects (such as keychains)

*/

#include "nwnx_creature"
#include "nwnx_object"
#include "zdlg_include_i"
#include "inc_holders"
#include "zzdlg_color_inc"
#include "inc_stacking"
const string OBJECTOPTIONS = "OBJECTOPTIONS";
const string OBJECTIDS = "OBJECTIDS";

const string PAGE_DONE    = "DONE";
const string PAGE_FAILED  = "FAILED";

void Init()
{

  // make sure the list of objects is always accurate
  DeleteList(OBJECTOPTIONS);
  DeleteList(OBJECTIDS);

  if (GetElementCount(OBJECTOPTIONS) == 0)
  {
    // retrieve the object name and qty from the local variables on the container object (see gvd_inc_keychain for details)
    object oPC   = GetPcDlgSpeaker();
    object oContainer = GetLocalObject(oPC, "gvd_container_conv");

    int iVars = NWNX_Object_GetLocalVariableCount(oContainer);
    int iVar = 0;
    string sValue;
    int iQty;
    string sName;
    struct NWNX_Object_LocalVariable lvKey;

    lvKey = NWNX_Object_GetLocalVariable(oContainer, iVar);

    AddStringElement(txtLime + "[Place all suitable inventory items into container]</c>", OBJECTOPTIONS);
    while (iVar < iVars) {

      // skip any variable that doesn't have the || seperator in it's name and skip any variable starting with underscores (just to be sure)
      if ((FindSubString(lvKey.key, "||") > 0) && (GetStringLeft(lvKey.key,1) != "_")) {

        // qty are stored in first 4 characters of the variable value, desription contains the rest of the chars
        sValue = GetLocalString(oContainer, lvKey.key);
        iQty = StringToInt(GetStringLeft(sValue, 4));

        // objectname is stored as last part of the variable name in version 2.0 of the containers
        string sVarName = lvKey.key;
        int iDelimeter = FindSubString(sVarName, "||");
        sVarName = GetStringRight(sVarName, GetStringLength(sVarName) - iDelimeter - 2);
        iDelimeter = FindSubString(sVarName, "||");
        if (iDelimeter < 0) {
          // version 1.0 style variable name, object name is stored as part of the value instead of the variable name
          sName = GetStringRight(sValue, GetStringLength(sValue)-4);
        } else {
          // version 2.0 style variable name, object name is stored as the last part of the variable name
          sName = GetStringRight(sVarName, GetStringLength(sVarName) - iDelimeter - 2);
        }

        // add name to list for PC
        AddStringElement(sName + " (" + IntToString(iQty) + ")", OBJECTOPTIONS);

        // add variable name holding resref and tag and name to list for item creation
        AddStringElement(lvKey.key, OBJECTIDS);

      }

      // next variable
      iVar = iVar + 1;
      lvKey = NWNX_Object_GetLocalVariable(oContainer, iVar);

    }


    // always add, a done option
    AddStringElement(txtLime + "[Done]</c>", OBJECTOPTIONS);

  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  object oContainer = GetLocalObject(oPC, "gvd_container_conv");

  if (sPage == "")
  {
    SetDlgPrompt("What item do you wish to retrieve from the " + GetName(oContainer) + "?");
    SetDlgResponseList(OBJECTOPTIONS);
  }
  else if (sPage == PAGE_DONE)
  {
    SetDlgPrompt("You retrieve the item.\nWhat item do you wish to retrieve from the " + GetName(oContainer) + "?");
    Init();
    SetDlgPageString("");
    SetDlgResponseList(OBJECTOPTIONS);
  }
  else if (sPage == PAGE_FAILED)
  {
    SetDlgPrompt("You can't find the item you are looking for.");
  }
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();

  if (sPage == "") {
    // handle the PCs selection
    int nCount = GetElementCount(OBJECTIDS);
    object oContainer = GetLocalObject(oPC, "gvd_container_conv");
    if(selection == 0) //loop through inventory, add items)
    {
        object oItem;
        string sTag = GetStringUpperCase(ConvertedStackTag(oContainer));
        string sLeft = GetStringLeft(sTag, 11);
        if(sLeft == "MD_JEWELBOX")
        {
            oItem = GetFirstItemInInventory(oPC);
            while(GetIsObjectValid(oItem))
            {
                if ((GetBaseItemType(oItem) == BASE_ITEM_RING || GetBaseItemType(oItem) == BASE_ITEM_AMULET) && GetIdentified(oItem) && !GetIsItemPropertyValid(GetFirstItemProperty(oItem)) && (GetDroppableFlag(oItem) == TRUE) && (GetItemCursedFlag(oItem) == FALSE))
                {
                    gvd_Container_AddObject(oContainer, oItem);
                }

                oItem = GetNextItemInInventory(oPC);
            }

        }
        else if(sTag == "GVD_KEYRING")
        {
            oItem = GetFirstItemInInventory(oPC);
            while(GetIsObjectValid(oItem))
            {
                if ((GetBaseItemType(oItem) == BASE_ITEM_KEY) && (GetDroppableFlag(oItem) == TRUE) && (GetItemCursedFlag(oItem) == FALSE))
                {
                    gvd_Container_AddObject(oContainer, oItem);
                }

                oItem = GetNextItemInInventory(oPC);
            }

        }
        else if(sLeft == "GVD_HEADBAG")
        {
            oItem = GetFirstItemInInventory(oPC);
            string sTagTarget;
            while(GetIsObjectValid(oItem))
            {
                sTagTarget = GetStringUpperCase(GetTag(oItem));
                if (((GetStringLeft(sTagTarget, 7) == "GS_HEAD") || (GetStringLeft(sTagTarget, 15) == "GVD_SLAVER_HEAD")) && (GetDroppableFlag(oItem) == TRUE) && (GetItemCursedFlag(oItem) == FALSE))
                {
                    gvd_Container_AddObject(oContainer, oItem);
                }

                oItem = GetNextItemInInventory(oPC);
            }

        }
        else if(sLeft == "GVD_MINEBAG")
        {
            oItem = GetFirstItemInInventory(oPC);
            string sTagTarget;
            while(GetIsObjectValid(oItem))
            {
                sTagTarget = GetStringUpperCase(GetTag(oItem));
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
                    ) && (GetDroppableFlag(oItem) == TRUE) && (GetItemCursedFlag(oItem) == FALSE))
                {
                    gvd_Container_AddObject(oContainer, oItem);
                }

                oItem = GetNextItemInInventory(oPC);
            }

        }
        else if(sLeft == "GVD_HUNTBAG")
        {
            oItem = GetFirstItemInInventory(oPC);
            string sTagTarget;
            while(GetIsObjectValid(oItem))
            {
                sTagTarget = GetStringUpperCase(GetTag(oItem));
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
                    ) && (GetDroppableFlag(oItem) == TRUE) && (GetItemCursedFlag(oItem) == FALSE))
                {
                    gvd_Container_AddObject(oContainer, oItem);
                }

                oItem = GetNextItemInInventory(oPC);
            }

        }
        else if(sLeft == "GVD_GEMBAG_")
        {
            oItem = GetFirstItemInInventory(oPC);
            string sTagTarget;
            while(GetIsObjectValid(oItem))
            {
                sTagTarget = GetStringUpperCase(GetTag(oItem));
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
                    ) && (GetDroppableFlag(oItem) == TRUE) && (GetItemCursedFlag(oItem) == FALSE))
                {
                    gvd_Container_AddObject(oContainer, oItem);
                }

                oItem = GetNextItemInInventory(oPC);
            }
        }
        else if(sLeft == "GVD_TRAPBOX")
        {
            oItem = GetFirstItemInInventory(oPC);
            string sTagTarget;
            while(GetIsObjectValid(oItem))
            {
                sTagTarget = GetStringUpperCase(GetTag(oItem));
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
                    ) && (GetDroppableFlag(oItem) == TRUE) && (GetItemCursedFlag(oItem) == FALSE) && GetIdentified(oItem))
                {
                    gvd_Container_AddObject(oContainer, oItem);
                }

                oItem = GetNextItemInInventory(oPC);
            }
        }

        else if(sLeft == "I_SCROLL_CA")
        {
            oItem = GetFirstItemInInventory(oPC);
            string sTagTarget;
            while(GetIsObjectValid(oItem))
            {
                if (GetBaseItemType(oItem) == BASE_ITEM_SPELLSCROLL && GetDroppableFlag(oItem) == TRUE && GetItemCursedFlag(oItem) == FALSE)
                    gvd_Container_AddObject(oContainer, oItem);

                oItem = GetNextItemInInventory(oPC);
            }
        }
        EndDlg();

    }
    else if(selection == nCount+1) {
      // The Done response list has only one option, to end the conversation.
      EndDlg();
    }
    // OBJECTIDS has 1 element less then OBJECTOPTIONS for the done option
    else {

      string sObjectID = GetStringElement(selection-1, OBJECTIDS);
      int iDelimeter = FindSubString(sObjectID, "||");

      if (iDelimeter < 0) {
        // not a container object variable, return failure
        SetDlgPageString(PAGE_FAILED);

      } else {

        string sResRef = GetStringLeft(sObjectID, iDelimeter);
        string sTag = GetStringRight(sObjectID, GetStringLength(sObjectID) - iDelimeter - 2);
        string sObjectName = "";

        iDelimeter = FindSubString(sTag, "||");
        if (iDelimeter >= 0) {
          // version 2.0, split up in tag + name
          sObjectName = GetStringRight(sTag, GetStringLength(sTag) - iDelimeter - 2);
          sTag = GetStringLeft(sTag, iDelimeter);
        }


        gvd_Container_GetObject(oContainer, sResRef, sTag, sObjectName, oPC);

        SetDlgPageString(PAGE_DONE);

      }

    }

  } else {
    // The Done response list has only one option, to end the conversation.
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

