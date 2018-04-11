#include "fb_inc_chatutils"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_item"
#include "nwnx_admin"
#include "gs_inc_iprop"
#include "inc_examine"

const string HELP = "Use the -saveoutfit command to save an outfit. Type an outfit name after -saveoutfit. Will save currently equipped weapon, armor, shield, cloak, and helmet. -d parameter can be used to delete an outfit -r can be used to replace an outfit";

string _AppToString(object oItem, int nType, int nIndex, int nPad=4)
{
    return gsCMPadString(IntToString(GetItemAppearance(oItem, nType, nIndex)), nPad);
}
string _ItemApp(int nSlot, object oSpeaker)
{
    object oItem = GetItemInSlot(nSlot, oSpeaker);
    if(GetIsObjectValid(oItem))
    {
        string sRet;
        int x;
        if(nSlot == INVENTORY_SLOT_LEFTHAND || nSlot == INVENTORY_SLOT_RIGHTHAND)
        {
            int nBase = GetBaseItemType(oItem);
            if(nSlot == INVENTORY_SLOT_LEFTHAND)
                sRet = "L";
            else
                sRet = "R";

            sRet += gsCMPadString(IntToString(nBase), 4);

          /*  if(nBase == BASE_ITEM_SMALLSHIELD || nBase == BASE_ITEM_LARGESHIELD || nBase == BASE_ITEM_TOWERSHIELD)
                sRet += _AppToString(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
            else
            {
                for(x = 0; x < 3; x++)
                {
                    sRet += _AppToString(oItem, ITEM_APPR_TYPE_WEAPON_MODEL, x);
                    sRet += _AppToString(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, x, 1);
                }
            }  */
        }
        else
        {
            if(nSlot == INVENTORY_SLOT_CHEST)
            {
                sRet = "T";
              /*  for(x = 0; x < ITEM_APPR_ARMOR_NUM_MODELS; x++)
                {
                    sRet += _AppToString(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, x);
                }  */
            }
            else if(nSlot == INVENTORY_SLOT_CLOAK)
            {
                sRet = "P";
                //sRet += _AppToString(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
            }
            else if(nSlot == INVENTORY_SLOT_HEAD)
            {
                sRet = "H";
                //sRet += _AppToString(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
            }
           /* if(sRet != "")
            {
                for(x = 0; x < ITEM_APPR_ARMOR_NUM_COLORS; x++)
                {
                    sRet += _AppToString(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, x);
                }
            } */
        }

        if(sRet != "")
            return sRet + NWNX_Item_GetEntireItemAppearance (oItem);
    }

    return "";
}
void main()
{
  object oSpeaker = OBJECT_SELF;
  string sParam = chatGetParams(oSpeaker);
  object oHide = gsPCGetCreatureHide(oSpeaker);

  if (sParam == "?")
  {
    DisplayTextInExamineWindow("-saveoutfit", HELP);
  }
  else if (sParam == "reset")
  {
    SendMessageToPC(oSpeaker, "Reseting outfit list.");
    SetLocalString(oHide, "outfitList", "");
  }
  else if(sParam == "")
  {
    SendMessageToPC(oSpeaker, "Name must be supplied.");
  }
  else
  {
    sParam = GetStringLowerCase(sParam);
    string sLeft = GetStringLeft(sParam, 2);
    string sRight = GetStringRight(sParam, GetStringLength(sParam)-3);
    string sList = GetLocalString(oHide, "outfitList");

    if(sLeft == "-d")
    {

        string sOutfit = GetLocalString(oHide, "ofit_"+sRight);
        if(sOutfit == "")
            sOutfit = GetLocalString(oHide, "v2ofit_"+sRight);
        if(sOutfit == "")
            sOutfit = GetLocalString(oHide, "v3ofit_"+sRight);
        if(sOutfit != "")
        {
            string newLine = "\n";
            string sOldName = sRight;
            if (sOutfit != "" ) {
                DeleteLocalString(oHide, "ofit_"+sOldName);
                DeleteLocalString(oHide, "v2ofit_"+sOldName);
                DeleteLocalString(oHide, "v3ofit_"+sOldName);
                SendMessageToPC(oSpeaker, "Stored settings on '" + sOldName + "' removed.");
            }

            int nSub = FindSubString(sList, sRight);
            int nLength = GetStringLength(sRight);
            int nListLength = GetStringLength(sList);
            while(nSub >= 0)
            {
                if(nSub == 0 && (FindSubString(sList, newLine, nSub+1) == nLength || nListLength==nLength))
                {
                    sRight = GetStringRight(sList, nListLength-1-nLength);
                    break;
                }
                else if(nSub > 0 && (FindSubString(sList, newLine, nSub+1) == nLength + nSub || nLength + nSub == nListLength))
                {

                   sLeft = GetStringLeft(sList, nSub-1);
                   sRight = GetStringRight(sList, nListLength-nLength-nSub);
                   sRight = sLeft + sRight;
                   break;
                }
                nSub = FindSubString(sList, sRight, nSub+1);
            }

            if(sOldName != sRight) //hopefully error proofs it some
            {
                SendMessageToPC(oSpeaker, "Outfit deleted!");
                SetLocalString(oHide, "outfitList", sRight);
            }
        }

    }
    else if(sLeft == "-r")
    {
        if(sRight == "")
            SendMessageToPC(oSpeaker, "Name must be supplied.");
        else
        {
            DeleteLocalString(oHide, "ofit_"+sRight);
            DeleteLocalString(oHide, "v2ofit_"+sRight);
            SetLocalString(oHide, "v3ofit_"+sRight,
                _ItemApp(INVENTORY_SLOT_CHEST, oSpeaker) + _ItemApp(INVENTORY_SLOT_LEFTHAND, oSpeaker) +
                _ItemApp(INVENTORY_SLOT_RIGHTHAND, oSpeaker) + _ItemApp(INVENTORY_SLOT_HEAD, oSpeaker) +
                _ItemApp(INVENTORY_SLOT_CLOAK, oSpeaker));


            SendMessageToPC(oSpeaker, "Outfit replaced!");
        }

    }
    else if(GetLocalString(oHide, "ofit_"+sParam) != "" || GetLocalString(oHide, "v2ofit_"+sParam) != "" || GetLocalString(oHide, "v3ofit_"+sParam) != "")
    {
        SendMessageToPC(oSpeaker, "An outfit is already saved under that name. You can replace outfits by typing -saveoutfit -r OutfitName and delete outfits by typing -saveoutfit -d OutfitName.");
    }
    else
    {
        SetLocalString(oHide, "v3ofit_"+sParam,
            _ItemApp(INVENTORY_SLOT_CHEST, oSpeaker) + _ItemApp(INVENTORY_SLOT_LEFTHAND, oSpeaker) +
            _ItemApp(INVENTORY_SLOT_RIGHTHAND, oSpeaker) + _ItemApp(INVENTORY_SLOT_HEAD, oSpeaker) +
            _ItemApp(INVENTORY_SLOT_CLOAK, oSpeaker));

        string sList = GetLocalString(oHide, "outfitList");
        if(sList != "")
            sList += "\n";
        SetLocalString(oHide, "outfitList", sList + sParam);

        SendMessageToPC(oSpeaker, "Outfit saved!");
    }
  }

  chatVerifyCommand(oSpeaker);
}
