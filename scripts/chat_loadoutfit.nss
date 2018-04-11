#include "fb_inc_chatutils"
#include "gs_inc_iprop"
#include "inc_examine"
#include "inc_timelock"
#include "nwnx_item"
#include "inc_math"

const string HELP = "Use the -loadoutfit command to recover an outfit saved with -saveoutfit. Must type the name. Can be used only once per 6s.";
string sOutChest = "MD_outhelp";
//Where the strings start, keep them in case it's ever necessary
/*const int STR_CLO_1 = 4;
const int STR_CLO_2 = 6;
const int STR_LEA_1 = 0;
const int STR_LEA_2 = 2;
const int STR_MET_1 = 8;
const int STR_MET_2 = 10;
const int STR_NECK = 36;
const int STR_TORSO = 32;
const int STR_BELT = 34;
const int STR_PELVIS = 30;
const int STR_ROBE = 54;
const int STR_RIG_SHO = 46;
const int STR_LEF_SHO = 48;
const int STR_RIG_BIC = 42;
const int STR_LEF_BIC = 44;
const int STR_RIG_FA = 38;
const int STR_LEF_FA = 40;
const int STR_RIG_HA = 50;
const int STR_LEF_HA = 52;
const int STR_RIG_TH = 28;
const int STR_LEF_TH = 26;
const int STR_RIG_SH = 22;
const int STR_LEF_SH = 24;
const int STR_RIG_FO = 18;
const int STR_LEF_FO = 20;
const int STR_WPN_TOP = 16;
const int STR_WPN_MID = 14;
const int STR_WPN_BOT = 12; //yes, shared with simple?*/
const int STR_SIMPLE = 12;




int GetWeaponProps(int nApp, int nColor = TRUE)
{
    if(nColor)
    {
        return nApp - (nApp/10*10);
    }
    else
    {
        return nApp/10;
    }
}

object _RestoreSpecific(object oItem, string sApp, int nType, int nIndex, int nOld)
{
    int nStart;
    int nApp;
    if(nOld)
    {
        nStart = nIndex * 2;
        if(nType == ITEM_APPR_TYPE_ARMOR_MODEL)
            nStart += 18;
        else if(nType == ITEM_APPR_TYPE_SIMPLE_MODEL)
            nStart = STR_SIMPLE;
        else if(nType == ITEM_APPR_TYPE_WEAPON_COLOR || nType == ITEM_APPR_TYPE_WEAPON_MODEL)
            nStart += 12;

        nApp = ConvertHexToDec(GetSubString(sApp, nStart, 2));
        if(nType == ITEM_APPR_TYPE_WEAPON_COLOR)
            nApp = GetWeaponProps(nApp, TRUE);
        else if(nType == ITEM_APPR_TYPE_WEAPON_MODEL)
            nApp =  GetWeaponProps(nApp, FALSE);

    }
    else
    {
        int nLength = 4;
        if(nType == ITEM_APPR_TYPE_SIMPLE_MODEL)
            nStart = 0;
        else if(nType == ITEM_APPR_TYPE_ARMOR_COLOR)
        {
            sApp = GetStringRight(sApp, (4 * ITEM_APPR_ARMOR_NUM_COLORS));
            nStart = nIndex * 4;
        }
        else if(nType == ITEM_APPR_TYPE_ARMOR_MODEL)
            nStart = nIndex * 4;
        else if(nType == ITEM_APPR_TYPE_WEAPON_MODEL)
            nStart = nIndex * 5;
        else if(nType == ITEM_APPR_TYPE_WEAPON_COLOR)
        {
            nStart = nIndex * 4 + 4 + nIndex;
            nLength = 1;
        }

        sApp = GetSubString(sApp, nStart, nLength);
        nApp = StringToInt(gsCMTrimString(sApp));
    }

    DestroyObject(oItem);
    return CopyItemAndModify(oItem, nType, nIndex, nApp, TRUE);

}
object _RestoreAppearance(object oItem, string sApp, int nBase, int nOld)
{
    int x;

    if(nBase == BASE_ITEM_ARMOR || nBase == BASE_ITEM_CLOAK || nBase == BASE_ITEM_HELMET)
    {
        for(x = 0; x < ITEM_APPR_ARMOR_NUM_COLORS; x++)
        {
            oItem = _RestoreSpecific(oItem, sApp, ITEM_APPR_TYPE_ARMOR_COLOR,  x, nOld);
        }

        if(nBase == BASE_ITEM_ARMOR)
        {
            for(x = 0;x < ITEM_APPR_ARMOR_NUM_MODELS; x++)
            {
                oItem = _RestoreSpecific(oItem, sApp, ITEM_APPR_TYPE_ARMOR_MODEL, x, nOld);
            }
        }
        else
            oItem = _RestoreSpecific(oItem, sApp, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nOld);
    }
    else if(nBase == BASE_ITEM_LARGESHIELD || nBase == BASE_ITEM_SMALLSHIELD || nBase == BASE_ITEM_TOWERSHIELD)
        oItem = _RestoreSpecific(oItem, sApp, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, nOld);
    else //weapons!
    {
        for(x = 0; x < 3; x++)
        {
            oItem = _RestoreSpecific(oItem, sApp, ITEM_APPR_TYPE_WEAPON_MODEL, x, nOld);
            oItem = _RestoreSpecific(oItem, sApp, ITEM_APPR_TYPE_WEAPON_COLOR, x, nOld);
        }
    }

    return oItem;
}
void _Recover(string sSave, string sSlot, object oChest, object oSpeaker, int nOld=TRUE)
{
    int nSub = FindSubString(sSave, sSlot);
    if(nSub > -1)
    {
        int nSlot;
        object oItem;

        if(sSlot == "L" || sSlot == "R")
        {
            string sBase;
            if(nOld == 1)
            {
                sBase = GetSubString(sSave, nSub+1, 3);
                nSub += 3;
            }
            else
            {
                sBase = gsCMTrimString(GetSubString(sSave, nSub+1, 4));
                nSub += 4;
            }

            if(sSlot == "L")
                nSlot = INVENTORY_SLOT_LEFTHAND;
            else if(sSlot == "R")
                nSlot = INVENTORY_SLOT_RIGHTHAND;

            oItem = GetItemInSlot(nSlot, oSpeaker);

            if(StringToInt(sBase) != GetBaseItemType(oItem))
            {
                SendMessageToPC(oSpeaker, "Base Item mismatch. Item skipped");
                return;
            }

        }
        else if(sSlot == "T")
            nSlot = INVENTORY_SLOT_CHEST;
        else if(sSlot == "P")
            nSlot = INVENTORY_SLOT_CLOAK;
        else if(sSlot == "H")
            nSlot = INVENTORY_SLOT_HEAD;

        oItem = GetItemInSlot(nSlot, oSpeaker);

        if(!GetIsObjectValid(oItem))
        {
            SendMessageToPC(oSpeaker, "Item not equipped. Item Skipped.");
            return;
        }

        int nBase  = GetBaseItemType(oItem);
        int nLength;
        if(nOld == 3)
            nLength=284;
        else if(nOld)
            nLength = 56;
        else if(nBase == BASE_ITEM_SMALLSHIELD || nBase == BASE_ITEM_LARGESHIELD || nBase == BASE_ITEM_TOWERSHIELD)
            nLength = 4;
        else if(nBase == BASE_ITEM_HELMET || nBase == BASE_ITEM_CLOAK)
            nLength = 4 * ITEM_APPR_ARMOR_NUM_COLORS + 4;
        else if(nBase == BASE_ITEM_ARMOR)
            nLength = 4 * ITEM_APPR_ARMOR_NUM_COLORS + 4 * ITEM_APPR_ARMOR_NUM_MODELS;
        else //weapons!
            nLength = (1+4) * 3;
        string sApp = GetSubString(sSave, nSub+1, nLength);
        int nPlot = GetPlotFlag(oItem);
        if(nPlot) SetPlotFlag(oItem, FALSE);
        string sDes = GetDescription(oItem);
        int nCurse = GetItemCursedFlag(oItem);
        int nDrop = GetDroppableFlag(oItem);
        object oCopy = CopyItem(oItem, oChest, TRUE);


        if(nOld == 0)
        {
            oCopy = _RestoreAppearance(oCopy, sApp, nBase, nOld);
            sApp = GetSubString(NWNX_Item_GetEntireItemAppearance (oCopy), 0, 56) + "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
        }
        else if(nOld == 1)
        {
            sApp += "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
        }
        //removes color overrides for v1 and v2, completetly sets for v3 and v1 (untested for v1)
        NWNX_Item_RestoreItemAppearance (oCopy, sApp);
        if(GetIsObjectValid(oCopy) && GetGoldPieceValue(oItem) == GetGoldPieceValue(oCopy))
        {
            DestroyObject(oCopy);
            if(sSlot == "T")
            {
                int nTableID = gsIPGetAppearanceTableID(ITEM_APPR_ARMOR_MODEL_TORSO);

                if(gsIPGetAppearanceAC(nTableID, GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO)) !=
                     gsIPGetAppearanceAC(nTableID, GetItemAppearance(oCopy, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO)))
                {
                    SendMessageToPC(oSpeaker, "Base Item mismatch. Item skipped");
                    return;
                }
            }

            object oCopy2 = CopyItem(oCopy, oSpeaker, TRUE);

            if(GetIsObjectValid(oCopy2))
            {
                DestroyObject(oItem);
                SetPlotFlag(oCopy2, nPlot);
                SetItemCursedFlag(oCopy2, nCurse);
                SetDroppableFlag(oCopy2, nDrop);
                AssignCommand(oSpeaker, ActionEquipItem(oCopy2, nSlot));
                SetDescription(oCopy2, sDes);
            }
        }
    }
}
void main()
{
  object oSpeaker = OBJECT_SELF;
  string sParam = chatGetParams(oSpeaker);
  if (sParam == "?")
  {
    DisplayTextInExamineWindow("-loadoutfit", HELP);
  }
  else if(sParam == "")
  {
    SendMessageToPC(oSpeaker, "Name must be supplied.");
  }
  else
  {
    if (GetIsTimelocked(oSpeaker, "loadoutfit")) // miesny_jez - added a timelock for this to remove an equipment copy exploit
    {
        TimelockErrorMessage(oSpeaker, "loadoutfit");
    }
    else
    {
        sParam = GetStringLowerCase(sParam);
        object oHide = gsPCGetCreatureHide(oSpeaker);
        object oChest = GetObjectByTag(sOutChest);
        string sSave = GetLocalString(oHide, "ofit_"+sParam);
        int nOld = TRUE;
        if(sSave == "")
        {
            sSave = GetLocalString(oHide, "v2ofit_"+sParam);
            nOld = FALSE;
        }
        if(sSave == "")
        {
            sSave = GetLocalString(oHide, "v3ofit_"+sParam);
            nOld = 3;
        }
        if(sSave == "" || !GetIsObjectValid(oChest))
        {
            SendMessageToPC(oSpeaker, "No outfit under that name.");
        }
        else
        {
            _Recover(sSave, "T", oChest, oSpeaker, nOld);
            _Recover(sSave, "R", oChest, oSpeaker, nOld);
            _Recover(sSave, "L", oChest, oSpeaker, nOld);
            _Recover(sSave, "P", oChest, oSpeaker, nOld);
            _Recover(sSave, "H", oChest, oSpeaker, nOld);
        }

        SetTimelock(oSpeaker, 6, "loadoutfit");
        SetIsTimelockMuted(oSpeaker, "loadoutfit", TRUE);
    }
  }

  chatVerifyCommand(oSpeaker);
}
