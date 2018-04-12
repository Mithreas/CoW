#include "inc_chat"
#include "inc_names"
#include "inc_time"
#include "inc_item"
#include "inc_disguise"
#include "nwnx_events"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "x0_i0_match"
#include "x3_inc_string"
#include "inc_language"

// Adds text flagging an item as not copyable (if relevant).
void AddItemDescriptionCopyable(object oItem);
// Adds the item level requirement to an item's description (if relevant).
void AddItemDescriptionILR(object oItem);
// Adds text flagging an item as mundane (if relevant).
void AddItemDescriptionMundane(object oItems);
// Returns the object's base description.
string GetObjectDescription(object oObject);
// Stores the object's pre-examine description for later and retrieval by the post-examine
// event.
void StoreObjectDescription(object oObject);
// Adds UMD requirement, if relevant.
void AddItemDescriptionUMD(object oItem);

void main()
{
    object examiner = OBJECT_SELF;
    object examinee = NWNX_Object_StringToObject(NWNX_Events_GetEventData("EXAMINEE_OBJECT_ID"));
    int objectType = GetObjectType(examinee);

    if (objectType == OBJECT_TYPE_ITEM)
    {
        StoreObjectDescription(examinee);
        AddItemDescriptionMundane(examinee);
        AddItemDescriptionCopyable(examinee);
        AddItemDescriptionUMD(examinee);
        SetDescription(examinee, GetDescription(examinee) + "\n\n" + StringToRGBString("Gold Value: " + IntToString(GetGoldPieceValue(examinee)), "770"));
        if (GetLocalInt(examinee, "RUNIC"))
        {
            // Runic items have a description in blue which explains the runic property.
            string additionalDesc = "This item is marked by powerful ";

            int runicType = GetLocalInt(examinee, "RUNIC_TYPE");
            int runicLang = GetLocalInt(examinee, "RUNIC_LANGUAGE") - 1;

                                                                                      //2 was also used for all races
            if (runicType == RACIAL_TYPE_ALL || runicLang == GS_LA_LANGUAGE_COMMON || runicType == 2)
            {
                additionalDesc += "arcane ";
            }
            else if (runicType == RACIAL_TYPE_ELF || runicLang == GS_LA_LANGUAGE_ELVEN || runicLang == GS_LA_LANGUAGE_XANALRESS)
            {
                additionalDesc += "elven ";
            }
            else if(runicLang > -1) //has to come before dwarf, as dwarf is 0/default
            {
                additionalDesc += GetStringLowerCase(gsLAGetLanguageName(runicLang)) + " ";
            }
            else if (runicType == RACIAL_TYPE_DWARF)
            {
                additionalDesc += "dwarven ";
            }

            additionalDesc += "runes, and may be more easily improved by a skilled enchanter";

            if (runicType != RACIAL_TYPE_ALL || runicLang > 0)
            {
                additionalDesc += " knowledgeable of that language";
            }

            additionalDesc += ".";

            SetDescription(examinee, GetDescription(examinee) + "\n\n" + StringToRGBString(additionalDesc, "339"));
        }
		if (GetLocalInt(examinee, "BondTag") || GetLocalInt(examinee, "Elfblade"))
        {
			// Bonded items have a description in blue which hints at the greater power of the item.
            string additionalDesc2 = "This item hums with magical power. The item's true strength can be realised if the right person would wield it.";
			
			SetDescription(examinee, GetDescription(examinee) + "\n\n" + StringToRGBString(additionalDesc2, "933"));
		}

        // Add runic infusion notification.
        if (GetLocalInt(examinee, "RUNIC_INFUSED"))
            SetDescription(examinee, GetDescription(examinee) + "\n\n" + txtSilver + "This object has been infused with a rune and may no longer be infused with additional runes.</c>");

        AddItemDescriptionILR(examinee);
    }
    else if (objectType == OBJECT_TYPE_CREATURE)
    {
        if (GetIsDM(examiner) || GetIsDM(examinee) || examiner == examinee)
        {
            return;
        }

        string metaInfo = "";

        int curTimestamp = gsTIGetActualTimestamp();
        int prevTimestamp = GetLocalInt(examiner, "MI_LOOK_TIMEOUT_" + ObjectToString(examinee));

        if (GetLocalInt(examinee, "INANIMATE_OBJECT") && GetHasEffect(EFFECT_TYPE_CUTSCENE_PARALYZE, examinee))
        {
            // This is a statue, or something we don't want to examine . . . do nothing.
        }
        else
        {
            metaInfo = StringToRGBString("You try to assess ", "599") +
                       StringToRGBString(fbNAGetGlobalDynamicName(examinee), "199") +
                       StringToRGBString(". ", "599");

            if (curTimestamp - 1800 >= prevTimestamp) // 180 sec cooldown between attempts.
            {
                if (GetDistanceBetween(examiner, examinee) >= YardsToMeters(15.0))
                {
                    metaInfo += StringToRGBString("This character is too far away for you to determine " +
                                                  "anything useful about them.", "599");
                }
                else if (!LineOfSightObject(examiner, examinee))
                {
                    metaInfo += StringToRGBString("This character is out of your line of sight so you " +
                                                  "can't determine anything useful about them.", "599");
                }
                else
                {
                    string looksInfo = fbDoLooksAndGetString(examiner, examinee);
                    SetLocalString(examiner, "MI_LOOK_CACHED_" + ObjectToString(examinee), looksInfo);
                    SetLocalInt(examiner, "MI_LOOK_TIMEOUT_" + ObjectToString(examinee), curTimestamp);
                    metaInfo += looksInfo;
                }
            }
            else
            {
                metaInfo += GetLocalString(examiner, "MI_LOOK_CACHED_" + ObjectToString(examinee));
            }
        }

        string oldDescription = GetDescription(examinee);
        SetLocalString(examinee, "MI_LOOK_OLD_DESC", oldDescription);
        SetDescription(examinee, oldDescription + ((oldDescription == "") ? ("") : ("\n\n")) + metaInfo);

        if (GetLocalInt(examiner, "MI_LOOK_BROKE_" + ObjectToString(examinee)))
        {
            RestorePortrait(examinee);
        }
    }
}

//::///////////////////////////////////////////////
//:: AddItemDescriptionCopyable
//:://////////////////////////////////////////////
/*
    Adds text flagging an item as not copyable
    (if relevant).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 8, 2017
//:://////////////////////////////////////////////
void AddItemDescriptionCopyable(object oItem)
{
    if(!GetIsItemCopyable(oItem))
    {
        if(GetBaseItemType(oItem) == BASE_ITEM_BOOK)
        {
            SetDescription(oItem, GetObjectDescription(oItem) + "\n\n" + StringToRGBString("This book cannot be copied via a printing press.", "599"));
        }
    }
}

//::///////////////////////////////////////////////
//:: AddItemDescriptionILR
//:://////////////////////////////////////////////
/*
    Adds the item level requirement to an
    item's description (if relevant).

    If the item doesn't yet have its ILR set,
    set it.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 6, 2016
//:://////////////////////////////////////////////
void AddItemDescriptionILR(object oItem)
{
    if(!GetIsItemEquippable(oItem)) return;
    SetItemILR(oItem);

    int nHitDice = GetHitDice(OBJECT_SELF);
    int nItemLevel = GetLocalInt(oItem, "ILR");

    if(!GetPlotFlag(oItem) && nItemLevel > nHitDice)
    {
        SetDescription(oItem, GetObjectDescription(oItem) + "\n\n" + StringToRGBString("Item Level Requirement: " + IntToString(nItemLevel), STRING_COLOR_RED));
    }
}

//::///////////////////////////////////////////////
//:: AddItemDescriptionMundane
//:://////////////////////////////////////////////
/*
    Adds text flagging an item as mundane
    (if relevant).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 6, 2016
//:://////////////////////////////////////////////
void AddItemDescriptionMundane(object oItem)
{
    if(GetIsItemMundane(oItem))
    {
        SetDescription(oItem, GetObjectDescription(oItem) + "\n\n" + StringToRGBString("This is a mundane item and can be used by characters ordinarily barred from magic and in antimagic areas.", "599"));
    }
}

//::///////////////////////////////////////////////
//:: GetObjectDescription
//:://////////////////////////////////////////////
/*
    Returns the object's base description.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 6, 2016
//:://////////////////////////////////////////////}
string GetObjectDescription(object oObject)
{
    string sDescription = GetDescription(oObject);

    if(GetObjectType(oObject) == OBJECT_TYPE_ITEM && sDescription == GetBaseItemDefaultDescription(GetBaseItemType(oObject))
        && GetDescription(oObject, TRUE, TRUE) == GetDescription(oObject, FALSE, TRUE))
    {
        sDescription = GetDescription(oObject, FALSE, FALSE);
    }

    return sDescription;
}

//::///////////////////////////////////////////////
//:: StoreObjectDescription
//:://////////////////////////////////////////////
/*
    Stores the object's pre-examine description
    for later and retrieval by the post-examine
    event.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 6, 2016
//:://////////////////////////////////////////////
void StoreObjectDescription(object oObject)
{
    if(GetLocalString(oObject, "OriginalObjectDescription") != "")
        return;

    SetLocalString(oObject, "OriginalObjectDescription", GetObjectDescription(oObject));
}
//::///////////////////////////////////////////////
//:: md_GetUMDRequired
//:://////////////////////////////////////////////
/*
    Gets UMD value from value and ip type
    Type: 1 for class
    Type: 2 for race
    Type: 3 for align
*/
//:://////////////////////////////////////////////
//:: Created By: Morderon
//:: Created On: Feburary 22, 2018
//:://////////////////////////////////////////////
int GetUMDRequired(int nValue, int nType)
{

    object oModule  = GetModule();
    string sString  = "";
    int nValueLevel = 0;
    int nNth        = 0;
    int nClass      = 0;
    int nRace       = 0;
    int nAlign      = 0;

    while (nNth < 55)
    {
        sString     = IntToString(nNth);
        if(IntArray_Size(oModule, "MD_ITMVALUMD"+sString) == 0)
        {
            nValueLevel = StringToInt(Get2DAString("skillvsitemcost", "DeviceCostMax", nNth));
            IntArray_PushBack(oModule, "MD_ITMVALUMD"+sString, nValueLevel);
            nClass = StringToInt(Get2DAString("skillvsitemcost", "SkillReq_Class", nNth));
            IntArray_PushBack(oModule, "MD_ITMVALUMD"+sString, nClass);
            nRace = StringToInt(Get2DAString("skillvsitemcost", "SkillReq_Race", nNth));
            IntArray_PushBack(oModule, "MD_ITMVALUMD"+sString, nRace);
            nAlign = StringToInt(Get2DAString("skillvsitemcost", "SkillReq_Align", nNth));
            IntArray_PushBack(oModule, "MD_ITMVALUMD"+sString, nAlign);
        }
        else
        {
            nValueLevel = IntArray_At(oModule, "MD_ITMVALUMD"+sString, 0);
        }

        if(nValue <= nValueLevel) //get the umd for this value
        {
            if(nType == 1)
            {
                if(nClass > 0)
                    return nClass;
            }
            else if(nType == 2)
            {
                if(nRace > 0)
                    return nRace;
            }
            else if(nType == 3)
            {
                if(nAlign > 0)
                    return nAlign;
            }

            return IntArray_At(oModule, "MD_ITMVALUMD"+sString, nType);
        }
        nNth++;
    }

    return 0;
}
//::///////////////////////////////////////////////
//:: AddItemDescriptionUMD
//:://////////////////////////////////////////////
/*
    Places the UMD value for the item.
*/
//:://////////////////////////////////////////////
//:: Created By: Morderon
//:: Created On: April 5, 2017
//:://////////////////////////////////////////////
void AddItemDescriptionUMD(object oItem)
{
    int nUMD = GetLocalInt(oItem, "UMD_REQUIREMENT");
    if(!gsIPMeetsRestrictions(oItem, OBJECT_SELF))
    {
        if(nUMD)
        {
            SetDescription(oItem, GetObjectDescription(oItem) + "\n\n" + StringToRGBString("This item requires a Use Magic Device skill of " + IntToString(nUMD), STRING_COLOR_RED));
        }
        else
        {
            itemproperty ip = GetFirstItemProperty(oItem);
            int nValue = GetGoldPieceValue(oItem);
            int nDoOnceAlign, nDoOnceClass, nDoOnceRace;
            while (GetIsItemPropertyValid(ip))
            {
                if ((GetItemPropertyType(ip) == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP || GetItemPropertyType(ip) == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT) && nDoOnceAlign == 0)
                {
                    SetDescription(oItem, GetDescription(oItem) + "\n\n" + StringToRGBString("This item requires a Use Magic Device skill of " + IntToString(GetUMDRequired(nValue, 3)) + " to bypass the alignment check.", STRING_COLOR_RED));
                    nDoOnceAlign = 1;
                }
                else if (GetItemPropertyType(ip) == ITEM_PROPERTY_USE_LIMITATION_CLASS && nDoOnceClass == 0)
                {
                    SetDescription(oItem, GetDescription(oItem) + "\n\n" + StringToRGBString("This item requires a Use Magic Device skill of " + IntToString(GetUMDRequired(nValue, 1)) + " to bypass the class check.", STRING_COLOR_RED));
                    nDoOnceClass = 1;

                }
                else if (GetItemPropertyType(ip) == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE && nDoOnceRace == 0)
                {
                    SetDescription(oItem, GetDescription(oItem) + "\n\n" + StringToRGBString("This item requires a Use Magic Device skill of " + IntToString(GetUMDRequired(nValue, 2)) + " to bypass the racial check.", STRING_COLOR_RED));
                    nDoOnceRace = 1;
                }

                ip = GetNextItemProperty(oItem);
            }
        }
    }

}
