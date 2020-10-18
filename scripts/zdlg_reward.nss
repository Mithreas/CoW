/*
  Name: zdlg_reward
  Author: Mithreas
  Date: May 22 2018
  Description: Bounty conversation script. Uses Z-Dialog.
  
  NPC variables:
    dlg_prompt (string) - the greeting the NPC will use, should explain what they want. 
	item_tag (string)   - the tag of the item they want
	item_count (int)    - the number of items they want.  Defaults to 1 if not present.  
	
	item1 (string)      - resref of a possible reward item
	item2...n           - as many optional items as you'd like to add.
	
	prop1type (int)     - index into itempropdef.2da of the first type of bonus property
	                      we could add to the item. 
	prop1subtype (int)  - property subtupe, index into the 2da defined as SubTypeResRef in
	                      the relevant row of itempropdef.2da
	prop1cost (int)     - index into the relevant cost table to determine property size (1, d4 etc)
	
	prop2type, prop3type etc can all be defined as for prop1 with the same 3 variables.
	Only positive/beneficial properties are supported.
	
	See this link for more info on what the subtype and cost should be for different property types.
	Many properties do not need a subtype or cost, or just need one of them. 
	https://nwnlexicon.com/index.php?title=Category:Item_Creation_Functions

*/
#include "zdlg_include_i"

const string MAIN_MENU   = "rw_main_options";
const string PAGE_2 = "page_2";
const string END = "end";

const string ITEMS = "reward_items";
const string PROPS = "reward_item_properties";

void _AddItemProperty(object oItem, int ipType, int ipSubType, int ipCost)
{
  itemproperty iprop;
  
  switch (ipType)
  {
    case ITEM_PROPERTY_ABILITY_BONUS:
	  ItemPropertyAbilityBonus(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_AC_BONUS:
	  iprop = ItemPropertyACBonus(ipCost);
	  break;
	case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:
	  iprop = ItemPropertyACBonusVsAlign(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:
	  iprop = ItemPropertyACBonusVsDmgType(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:
	  iprop = ItemPropertyACBonusVsRace(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:
	  iprop = ItemPropertyACBonusVsSAlign(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_ATTACK_BONUS:
	  iprop = ItemPropertyAttackBonus(ipCost);
	  break;
	case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
	  iprop = ItemPropertyAttackBonusVsAlign(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
	  iprop = ItemPropertyAttackBonusVsRace(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
	  iprop = ItemPropertyAttackBonusVsSAlign(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:
	  iprop = ItemPropertyWeightReduction(ipCost);
	  break;
	case ITEM_PROPERTY_BONUS_FEAT:
	  iprop = ItemPropertyBonusFeat(ipCost);
	  break;
	case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
	  iprop = ItemPropertyBonusLevelSpell(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_CAST_SPELL:
	  iprop = ItemPropertyCastSpell(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_DAMAGE_BONUS:
	  iprop = ItemPropertyDamageBonus(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
	  iprop = ItemPropertyDamageBonusVsAlign(ipSubType, ipCost, IP_CONST_DAMAGEBONUS_1d4);
	  break;
	case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
	  iprop = ItemPropertyDamageBonusVsRace(ipSubType, ipCost, IP_CONST_DAMAGEBONUS_1d4);
	  break;
	case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
	  iprop = ItemPropertyDamageBonusVsSAlign(ipSubType, ipCost, IP_CONST_DAMAGEBONUS_1d4);
	  break;
	case ITEM_PROPERTY_DAMAGE_REDUCTION:
	  iprop = ItemPropertyDamageReduction(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_DAMAGE_RESISTANCE:
	  iprop = ItemPropertyDamageResistance(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_DARKVISION:
	  iprop = ItemPropertyDarkvision();
	  break;
	case ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT:
	  iprop = ItemPropertyContainerReducedWeight(ipCost);
	  break;
	case ITEM_PROPERTY_ENHANCEMENT_BONUS:
	  iprop = ItemPropertyEnhancementBonus(ipCost);
	  break;
	case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
	  iprop = ItemPropertyEnhancementBonusVsAlign(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
	  iprop = ItemPropertyEnhancementBonusVsRace(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
	  iprop = ItemPropertyEnhancementBonusVsSAlign(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:
	  iprop = ItemPropertyExtraMeleeDamageType(ipSubType);
	  break;
	case ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE:
	  iprop = ItemPropertyExtraRangeDamageType(ipSubType);
	  break;
	case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:
	  iprop = ItemPropertyFreeAction();
	  break;
	case ITEM_PROPERTY_HASTE:
	  iprop = ItemPropertyHaste();
	  break;
	case ITEM_PROPERTY_HOLY_AVENGER:
	  iprop = ItemPropertyHolyAvenger();
	  break;
	case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
	  iprop = ItemPropertyDamageImmunity(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:
	  iprop = ItemPropertyImmunityMisc(ipSubType);
	  break;
	case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL:
	  iprop = ItemPropertySpellImmunitySpecific(ipSubType);
	  break;
	case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL:
	  iprop = ItemPropertySpellImmunitySchool(ipSubType);
	  break;
	case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:
	  iprop = ItemPropertyImmunityToSpellLevel(ipCost);
	  break;
	case ITEM_PROPERTY_IMPROVED_EVASION:
	  iprop = ItemPropertyImprovedEvasion();
	  break;
	case ITEM_PROPERTY_KEEN:
	  iprop = ItemPropertyKeen();
	  break;
	case ITEM_PROPERTY_LIGHT:
	  iprop = ItemPropertyLight(ipCost, ipSubType);
	  break;
	case ITEM_PROPERTY_MASSIVE_CRITICALS:
	  iprop = ItemPropertyMassiveCritical(ipCost);
	  break;
	case ITEM_PROPERTY_MIGHTY:
	  iprop = ItemPropertyMaxRangeStrengthMod(ipCost);
	  break;
	case ITEM_PROPERTY_ON_HIT_PROPERTIES:
	  iprop = ItemPropertyOnHitProps(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_ONHITCASTSPELL:
	  iprop = ItemPropertyOnHitCastSpell (ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_REGENERATION:
	  iprop = ItemPropertyRegeneration(ipCost);
	  break;
	case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
	  iprop = ItemPropertyVampiricRegeneration(ipCost);
	  break;
	case ITEM_PROPERTY_SAVING_THROW_BONUS:
	  iprop = ItemPropertyBonusSavingThrow(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
	  iprop = ItemPropertyBonusSavingThrowVsX(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_SKILL_BONUS:
	  iprop = ItemPropertySkillBonus(ipSubType, ipCost);
	  break;
	case ITEM_PROPERTY_SPELL_RESISTANCE:
	  iprop = ItemPropertyBonusSpellResistance(ipCost);
	  break;
	case ITEM_PROPERTY_TRUE_SEEING:
	  iprop = ItemPropertyTrueSeeing();
	  break;
	case ITEM_PROPERTY_UNLIMITED_AMMUNITION:
	  iprop = ItemPropertyUnlimitedAmmo(ipCost);
	  break;
  }
}

void Init()
{
  // variables
  string sTag    = GetLocalString(OBJECT_SELF, "item_tag");
  int    nNeeded = GetLocalInt(OBJECT_SELF, "item_count");
  int    nCount  = 0; 
 
  int bHasItems = FALSE;

  // Check whether we have what we need.  
  if (nNeeded == 0) nNeeded = 1;
  object oItem = GetFirstItemInInventory(OBJECT_SELF);
  
  while (GetIsObjectValid(oItem))
  {
    if (GetTag(oItem) == sTag)
	{
	  nCount += GetItemStackSize(oItem);
	}
	
	if (nCount >= nNeeded) 
	{
	  bHasItems = TRUE;
	  break;
	}  
  }
  
  // Clear responses so we check anew every time someone speaks to the NPC.
  DeleteList(MAIN_MENU);
  
  // Build response list. 
  AddStringElement("Not today, sorry.", MAIN_MENU);
  if (bHasItems) 
  {
    AddStringElement("Yes, I have what you need. Here you are!", MAIN_MENU);
  }  

  // End of conversation
  if (GetElementCount(END) == 0)
  {
    AddStringElement("Thanks, goodbye.", END);
  }
  
  // Build up lists of reward items and properties.
  if (GetElementCount(ITEMS) == 0)
  {
    nCount         = 1;
    string sResRef = GetLocalString(OBJECT_SELF, "item" + IntToString(nCount));
  
    while (sResRef != "")
	{
	  AddStringElement(sResRef, ITEMS);
	  sResRef = GetLocalString(OBJECT_SELF, "item" + IntToString(++nCount));
	}
  }

  if (GetElementCount(PROPS) == 0)
  {
    nCount = 1;
    string sProp = GetLocalString(OBJECT_SELF, "prop" + IntToString(nCount) + "type");
    
    while (sProp != "")
	{
	  AddStringElement(sProp, PROPS);
	  sProp = GetLocalString(OBJECT_SELF, "prop" + IntToString(++nCount) + "type");
	}
  }  
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {
    SetDlgPrompt(GetLocalString(OBJECT_SELF, "dlg_prompt"));
    SetDlgResponseList(MAIN_MENU, OBJECT_SELF);
  }
  else if (sPage == PAGE_2)
  {
    // variables
    string sTag    = GetLocalString(OBJECT_SELF, "item_tag");
    int    nNeeded = GetLocalInt(OBJECT_SELF, "item_count");
	
    object oItem = GetFirstItemInInventory(oPC);

    while (GetIsObjectValid(oItem))
    {
      if (GetTag(oItem) == sTag)
      {
        if (GetItemStackSize(oItem) > nNeeded)
		{
		  SetItemStackSize (oItem, GetItemStackSize(oItem) - nNeeded);
		  nNeeded = 0;
		}
		else
		{
          DestroyObject (oItem);
		  nNeeded -= GetItemStackSize(oItem);
		}
		
		if (nNeeded = 0) break;
      }

      oItem = GetNextItemInInventory(oPC);
    }

	// Do reward.
	// We have two lists defined - ITEMS and PROPS - set up in the Init method.
	// Select a random item and a random property, then apply it.
    string sResRef = GetStringElement(Random(GetElementCount(ITEMS)) + 1, ITEMS, OBJECT_SELF);
	oItem = CreateItemOnObject(sResRef, oPC);
	
	int nProp = Random(GetElementCount(PROPS)) + 1;
	
	_AddItemProperty(oItem, 
	                 GetIntElement(nProp, PROPS, OBJECT_SELF), 
					 GetLocalInt(OBJECT_SELF, "prop"+IntToString(nProp)+"subtype"),
					 GetLocalInt(OBJECT_SELF, "prop"+IntToString(nProp)+"cost"));
	
    SetDlgPrompt("Thanks, here's a little something for your trouble.");
    SetDlgResponseList(END, OBJECT_SELF);
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarrassing. Please report it.");
    EndDlg();
  }
}

void HandleSelection()
{
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();

  if (sPage == "")
  {
    switch (selection)
    {
      case 0:
        // Don't have something to sell, or don't want to.
        {
          EndDlg();
          break;
        }
      case 1:
        // Have something to sell
        {
          SetDlgPageString(PAGE_2);
          break;
        }
    }
  }
  else if (GetDlgResponseList() == END)
  {
    EndDlg();
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
