// Sell all contents of a scroll case.
#include "inc_holders"
#include "inc_shop"
#include "nwnx_object"
#include "x3_inc_string"
#include "inc_zdlg"


void _DelayRemoval(object oContainer)
{
    if(GetWeight(oContainer) <= 5)
        DeleteLocalInt(oContainer, "gvd_container_weight");
}


void main()
{
    object oPC = GetPCSpeaker();
    object oContainer = GetItemPossessedBy(oPC, "i_scroll_case");
    if(!GetIsObjectValid(oContainer)) oContainer = GetLocalObject(oPC, "BULKSELLSCROLLCASE");


    if(!GetIsObjectValid(oContainer)) return;

    struct NWNX_Object_LocalVariable lvKey;
    string sValue;
    int iQty;
    int iDelimeter;
    string sResRef;
    string sTag;
    string sObjectName;

    string sList = "md_apitemsid";
    object oTempChest = GetObjectByTag("gvd_tempchest");
    // object oTreasure =  GetObjectByTag("mo_jeweltreas");
    object oStore = GetNearestObjectByTag("GS_STORE_" + GetTag(OBJECT_SELF));
    if(!GetIsObjectValid(oStore))
        oStore = GetNearestObject(OBJECT_TYPE_STORE);
    struct openStore Appraise = md_DoAppraise(oStore, OBJECT_SELF, oPC);
    float fMarkDown = 1.0 - IntToFloat(Appraise.nModifierBonusBuy)/-100.0;
    float fMaxBuyPrice = IntToFloat(Appraise.nMaxBuyPrice);
    int iVar = 0;
    object oPrice;
    float fPrice;
    float fCPrice;
    lvKey = NWNX_Object_GetLocalVariable(oContainer, iVar);
    int iVars = NWNX_Object_GetLocalVariableCount(oContainer);


    while (iVar < iVars) {

        // skip any variable that doesn't have the || seperator in it's name and skip any variable starting with underscores (just to be sure)
        if ((FindSubString(lvKey.key, "||") > 0) && (GetStringLeft(lvKey.key,1) != "_")) {

            // qty are stored in first 4 characters of the variable value, desription contains the rest of the chars
            sValue = GetLocalString(oContainer, lvKey.key);
            iQty = StringToInt(GetStringLeft(sValue, 4));
            iDelimeter = FindSubString(lvKey.key, "||");
            sResRef = GetStringLeft(lvKey.key, iDelimeter);
            sTag = GetStringRight(lvKey.key, GetStringLength(lvKey.key) - iDelimeter - 2);
            sObjectName = "";

            iDelimeter = FindSubString(sTag, "||");
            if (iDelimeter >= 0) {
                // version 2.0, split up in tag + name
                sObjectName = GetStringRight(sTag, GetStringLength(sTag) - iDelimeter - 2);
                sTag = GetStringLeft(sTag, iDelimeter);
            }

            oPrice = CreateItemOnObject(sResRef, oTempChest);
            AssignCommand(oPrice, SetIsDestroyable(TRUE));
            DestroyObject(oPrice); //will fire immediately after script ends, so safe here.
            if(GetIsObjectValid(oPrice))
            {
                AddStringElement(lvKey.key, sList, oContainer);
                fPrice = fMarkDown * IntToFloat(GetGoldPieceValue(oPrice));
                if(fPrice > fMaxBuyPrice)
                    fPrice = fMaxBuyPrice;
                fCPrice += fPrice * IntToFloat(iQty);
            }
        }

        // next variable
        iVar = iVar + 1;
        lvKey = NWNX_Object_GetLocalVariable(oContainer, iVar);

    }

    if(fCPrice > 0.0)
    {
        int x;
        for(x=0;x<= GetElementCount(sList, oContainer);x++)
        {
            DeleteLocalString(oContainer, GetStringElement(x, sList, oContainer));
        }
        DeleteList(sList, oContainer);
        itemproperty ip = GetFirstItemProperty(oContainer);
        while(GetIsItemPropertyValid(ip))
        {
            if(GetItemPropertyType(ip) == ITEM_PROPERTY_WEIGHT_INCREASE)
                RemoveItemProperty(oContainer, ip);

            ip = GetNextItemProperty(oContainer);
        }
        GiveGoldToCreature(oPC, FloatToInt(fCPrice));
        DelayCommand(0.5, _DelayRemoval(oContainer));

    }


}
