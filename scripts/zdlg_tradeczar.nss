/*
  Name: zdlg_tradeczar
  Author: Mithreas
  Date: 6 October 2008
  Description: Trade czar script. Uses Z-Dialog.

  See inc_citizen for background and design.

  zdlg_tradeczar
  - if settlement leader, lets you set purchase prices
  - if settlement leader, lets you set sale prices
  - lets anyone donate items or sell items
    - inventory.

*/
#include "inc_class"
#include "inc_factions"
#include "inc_poison"
#include "inc_disguise"
#include "inc_listener"
#include "inc_message"
#include "inc_quarter"
#include "inc_zdlg"
#include "zzdlg_color_inc"

const string TC_LOG        = "TRADE_CZAR";
const string BUY_MENU      = "buy_menu";
const string CONFIRM_MENU  = "confirm_menu";
const string DONE_MENU     = "done_menu";
const string MAIN_MENU     = "main_menu";
const string NON_MENU      = "non_menu";
const string PRICE_MENU    = "price_menu";
const string RESOURCE_MENU = "resource_menu";
const string TRADE_MENU    = "trade_menu";
const string RESREF_MENU   = "rr_menu";
const string CATEGORY_MENU = "menu_category";

const string PAGE_BUY      = "buy_page";
const string PAGE_BUY_RESOURCE = "buy_page_2";
const string PAGE_DONATE   = "donate_page";
const string PAGE_SELL     = "sell_page";
const string PAGE_SETBUY   = "setbuy_page";
const string PAGE_SETSELL  = "setsell_page";
const string PAGE_RESOURCE = "resource_page";
const string PAGE_PRICE    = "price_page";
const string PAGE_EXP      = "expanded";
const string PAGE_CONFIRM  = "confirm";
const string PAGE_RACE     = "race";
const string PAGE_CLASS    = "class";
const string PAGE_ESET     = "esetbuy";
const string PAGE_SET      = "pageset";
const string PAGE_SSEL     = "setsel";
const string PAGE_COPY     = "copy";
const string PAGE_INDITM   = "inditm";
const string PAGE_ITM      = "pg_itm";
const string PAGE_PURCHASE = "pg_purchase";
const string PAGE_PURITM   = "pg_puritm";
const string PAGE_DISPLAY  = "pg_display";
const string PAGE_STOCK    = "pg_stock";
const string PAGE_STOITM   = "pg_stoitm";
const string PAGE_MVITM    = "pg_mvitm";
const string PAGE_CAT_PUR  = "pg_cat_pur";
const string PAGE_CAT_PRI  = "pg_cat_pri";



const string VAR_DLG_RESOURCE = "MI_DLG_RESOURCE";
const string VAR_DLG_PRICE    = "MI_DLG_PRICE";
const string VAR_DLG_NEXTPAGE = "MI_DLG_NEXTPAGE";
const string VAR_RACE_BIT     = "VAR_RACE_BIT";
const string VAR_CLASS_BIT    = "VAR_CLASS_BIT";
const string VAR_BIT          = "VAR_BIT";
const string VAR_ITEM         = "VAR_ITM";
const string VAR_PRICE        = "VAR_PRICE";
const string VAR_CAT_SELECTION = "VAR_CAT_SEL";

const string sStartService =  "<c þ >[Start Service]</c>";
const string sEndService = "<c þ >[End Service]</c>";
const string sSet = "<c þ >[Set Buy/Sell Prices]</c>";
const string sPurchase = "<c þ >[Purchase]</c>";
const string sRace = "<c þ >[Set Race]</c>";
const string sClass =  "<c þ >[Set Class]</c>";
const string sDisplay =  "<c þ >[Display Prices]</c>";
const string sConfirm =  "<c þ >[Confirm Selections]</c>";
const string STO_DEP  =  "<c þ >[Move to stockpiles]</c>";
const string COPY_BASE = "<c þ >[Adjust according to base prices ...]</c>";
const string COPY_CITIZEN = "<c þ >[Adjust according to citizen prices ...]</c>";
const string COPY_CLASS = "<c þ >[Adjust according to class prices ...]</c>";
const string COPY_CCLASS = "<c þ >[Adjust according to citizen & class prices ...]</c>";
const string COPY_RACE =  "<c þ >[Adjust according to race prices ...]</c>";
const string COPY_CRACE =  "<c þ >[Adjust according to race & citizen prices ...]</c>";
const string COPY_CLRACE =  "<c þ >[Adjust according to race & class prices ...]</c>";
const string COPY_CCLRACE =  "<c þ >[Adjust according to race & class & citizen prices ...]</c>";
const string COPY_TRADE = "<c þ >[Adjust according to trade prices ...]</c>";
const string COPY_RTRADE = "<c þ >[Adjust according to trade & race prices ...]</c>";



const string BACK_PROMPT = "[BACK]";

const float fTax = 0.2;
const int ItemCount = 49;

int _Back(string sList, int nSelection)
{
    string sListOverride = sList;
    if(sList == PAGE_STOCK)
        sListOverride = RESOURCE_MENU;
    else if(sList == PAGE_DISPLAY || sList == PAGE_CAT_PUR || sList == PAGE_CAT_PRI)
        sListOverride = CATEGORY_MENU;
    if(GetElementCount(sListOverride) - 1 == nSelection)
    {

        if(sList == PAGE_DISPLAY || sList == PAGE_CAT_PUR || sList == PAGE_SET || sList == PAGE_RACE || sList == PAGE_CLASS || sList == PAGE_STOCK)
            SetDlgPageString(PAGE_EXP);
        else if(sList == PAGE_PURCHASE)
            SetDlgPageString(PAGE_CAT_PUR);
        else if(sList == PAGE_PURITM)
            SetDlgPageString(PAGE_PURCHASE);
        else if(sList == PAGE_ITM)
            SetDlgPageString(PAGE_INDITM);
        else if(sList == PAGE_INDITM)
            SetDlgPageString(PAGE_CAT_PRI);
        else if(sList == PAGE_CAT_PRI)
            SetDlgPageString(PAGE_SSEL);
        else if(sList == PAGE_COPY)
        {
            if(GetLocalString(OBJECT_SELF, VAR_ITEM) != "")
                SetDlgPageString(PAGE_ITM);
            else
                SetDlgPageString(PAGE_SSEL);
        }
        else if(sList == PAGE_SSEL)
            SetDlgPageString(PAGE_ESET);
        else if(sList == PAGE_ESET)
            SetDlgPageString(PAGE_SET);
        else if(sList == PAGE_STOITM)
            SetDlgPageString(PAGE_STOCK);
        else if(sList == PAGE_MVITM)
            SetDlgPageString(PAGE_STOITM);

        return TRUE;
    }

    return FALSE;
}

int _GetMaxQty(string sResRef)
{
    if (sResRef == "gs_item451")  // coal
        return 200;
    if(sResRef == "rations" || sResRef == "rations001") //heal kits
        return 1000;
    if(sResRef == "ir_healingdraugh" || sResRef == "ar_it_miscband")
        return 600;
    if((sResRef == "gs_item458") ||  // clay
        (sResRef == "gs_item722") ||  // salt
        (sResRef == "gs_item302") ||  // sand
            //sResRef == "gs_item462") ||  // adamantine
            // (sResRef == "gs_item1000") || // arjale
        (sResRef == "gs_item457") ||  // copper
        (sResRef == "gs_item461") ||  // gold
        (sResRef == "gs_item452") ||  // iron
        (sResRef == "gs_item459") ||  // lead
            // (sResRef == "gs_item921") ||  // mithril
         (sResRef == "gs_item460") ||  // silver
         (sResRef == "gs_item496") ||  // tin
         (sResRef == "gs_item497") ||  // zinc

       (sResRef == "gs_item453") ||  // alexandrite
       (sResRef == "gs_item454") ||  // amethyst
       (sResRef == "gs_item455") ||  // adventurine
          //   (sResRef == "gs_item456") ||  // diamond
        //     (sResRef == "gs_item479") ||  // emerald
       (sResRef == "gs_item471") ||  // fire agate
       (sResRef == "gs_item472") ||  // fire opal
       (sResRef == "gs_item470") ||  // fluorspar
       (sResRef == "gs_item473") ||  // garnet
       (sResRef == "gs_item474") ||  // greenstone
       (sResRef == "gs_item475") ||  // malachite
       (sResRef == "gs_item476") ||  // phenalope
            // (sResRef == "gs_item477") ||  // ruby
       (sResRef == "gs_item478") ||  // sapphire
       (sResRef == "gs_item480") ||     // topaz
       sResRef == "ar_it_lunker001" || //scarfinned flatfish
       sResRef == "nw_it_msmlmisc20" || //fish
       sResRef == "gs_item905" || //cotton
       sResRef == "gs_item336" || //spider silk
       sResRef == "gs_item854" ||  // large hide
       sResRef == "gs_item896" ||  // medium hide
       sResRef == "gs_item895" ||  // small hide
       sResRef == "gs_item897" ||  // big meat
       sResRef == "gs_item898" ||  // medium meat
       sResRef == "gs_item899" ||     // small meat
       sResRef == "gs_item385" ||  // granite
       sResRef == "gs_item381" ||  // marble
       sResRef == "gs_item901" ||  // softwood
       sResRef == "gs_item900" ||  // hardwood
       sResRef == "gs_item304" || //nuts
       sResRef == "gs_item253" || //berries
       sResRef == "gs_item856" ||  //fruit
       sResRef == "ir_yarrowleaves") //yarrow
       return 100;
    //Items within comments are in system, but use default qty
    /*         ResRef == "sweetberry002" ||  //sweetberry
             sResref == "gs_item335" || //animal sinew
             sResRef == "ar_it_herb005" ||  //lady's tear
             sResRef == "ar_it_herb002" || //mintspear
             sResRef == "gs_item824" || //magic blood  */

    return 50;
}



string _ParseSQLCol(int nBuy, string sIni)
{
    return sIni + (nBuy == TRUE ? "buy":"sell");
}
string _ParseBuySell(int nBuy, string sIni, float fAmt, int nSub, int nAdjust = 1, string sAdjust = "")
{
    string sString = _ParseSQLCol(nBuy, sIni);
    if(nAdjust || nSub != -1)
    {
        if(sAdjust == "")
            sString += "="+sString;
        else
            sString += "="+sAdjust;
    }
    else
        sString += "=";
    if(nSub == -3)
        sString += "/";
    else if(nSub != -1)
        sString += "*";
    else if(nAdjust)
        sString += "+";

   sString += FloatToString(fAmt);
   return sString;
}
string _Update(int nVar, float fAmt, int nSub, int nAdjust = 1, string sAdjust = "")
{
        string sUpdate;
        switch(GetDlgPageInt())
        {
        case 0: sUpdate = _ParseBuySell(nVar, "", fAmt, nSub, nAdjust, sAdjust); break;
        case 1: sUpdate = _ParseBuySell(nVar, "c", fAmt, nSub, nAdjust, sAdjust); break;
        case 2: sUpdate = _ParseBuySell(nVar, "cl", fAmt, nSub, nAdjust, sAdjust); break;
        case 3: sUpdate = _ParseBuySell(nVar, "ccl", fAmt, nSub, nAdjust, sAdjust); break;
        case 4: sUpdate = _ParseBuySell(nVar, "r", fAmt, nSub, nAdjust, sAdjust); break;
        case 5: sUpdate = _ParseBuySell(nVar, "rc", fAmt, nSub, nAdjust, sAdjust); break;
        case 6: sUpdate = _ParseBuySell(nVar, "rcl", fAmt, nSub, nAdjust, sAdjust); break;
        case 7: sUpdate = _ParseBuySell(nVar, "crcl", fAmt, nSub, nAdjust, sAdjust); break;
        case 8: sUpdate = _ParseBuySell(nVar, "t", fAmt, nSub, nAdjust, sAdjust); break;
        case 9: sUpdate = _ParseBuySell(nVar, "rt", fAmt, nSub, nAdjust, sAdjust); break;
        default: sUpdate = _ParseBuySell(nVar, "", fAmt, nSub, nAdjust, sAdjust) + "," + _ParseBuySell(nVar, "c", fAmt, nSub, nAdjust, sAdjust) + "," +
           _ParseBuySell(nVar, "cl", fAmt, nSub, nAdjust, sAdjust) + "," + _ParseBuySell(nVar, "ccl", fAmt, nSub, nAdjust, sAdjust) + "," + _ParseBuySell(nVar, "r", fAmt, nSub, nAdjust, sAdjust) + "," +
           _ParseBuySell(nVar, "rc", fAmt, nSub, nAdjust, sAdjust) + "," + _ParseBuySell(nVar, "rcl", fAmt, nSub, nAdjust, sAdjust) + "," + _ParseBuySell(nVar, "crcl", fAmt, nSub, nAdjust, sAdjust) + "," +
           _ParseBuySell(nVar, "t", fAmt, nSub, nAdjust, sAdjust) + "," + _ParseBuySell(nVar, "rt", fAmt, nSub, nAdjust, sAdjust);
       }
       return sUpdate;

}
int _CheckClass(int nClass, object oPC)
{
        if(nClass)
        {
            int x;
            int nBit;
            int nPClass;

            for(x=1;x<=3;x++)
            {
                nPClass = GetClassByPosition(x, oPC);
                if(nPClass == CLASS_TYPE_INVALID)
                    break;
                if(GetLevelByClass(nPClass, oPC) > 6)   //don't need to do harpers as they can never be above lvl 5
                {
                    nBit |= mdConvertClassToBit(nPClass, oPC);

                }
            }

            return nClass &= nBit;

     }

     return FALSE;
}
int _CheckRace(int nRace, object oPC)
{
    if(nRace)
        return md_IsSubRace(nRace, oPC);

    return FALSE;
}

int _PriceCompare(int nPCBuy, int nOldPrice, int nNewPrice)
{

    if(!nPCBuy && nNewPrice > nOldPrice)
        return nNewPrice;
    else if(nPCBuy && nNewPrice < nOldPrice && nNewPrice > -1)
        return nNewPrice;

    return nOldPrice;
}
int _BestSellPrice(string sBase, string sRace, string sCitizen, string sTrade, string sCitRace, string sRaceTrade, string sClass, string sRaceClass, string sClassCitizen, string sRaceClassCit, int nNationMatch, int nRace, int nClass, int nTrade, int nPCBuy=FALSE)
{
    int nSellPrice;
    int nNewPrice=-1;
    int nTrade;
    if(nRace)
    {
        nSellPrice = StringToInt(sRace);

        if(nClass)
        {
            nNewPrice = StringToInt(sRaceClass);
            nSellPrice = _PriceCompare(nPCBuy, nSellPrice, nNewPrice);


            if(nNationMatch)
            {
                nNewPrice = StringToInt(sRaceClassCit);
                nSellPrice = _PriceCompare(nPCBuy, nSellPrice, nNewPrice);
            }
        }
        if(nNationMatch)
        {
            nNewPrice =  StringToInt(sCitRace);
        }
        else if(nTrade)
        {
            nNewPrice =  StringToInt(sRaceTrade);
        }
    }
    else
    {
        nSellPrice = StringToInt(sBase);

        if(nClass)
        {

            nNewPrice = StringToInt(sClass);
            nSellPrice = _PriceCompare(nPCBuy, nSellPrice, nNewPrice);

            if(nNationMatch)
            {

                nNewPrice = StringToInt(sClassCitizen);
                nSellPrice = _PriceCompare(nPCBuy, nSellPrice, nNewPrice);
            }
        }

        if(nNationMatch)
        {
            nNewPrice =  StringToInt(sCitizen);
        }
        else if(nTrade)
        {
            nNewPrice =  StringToInt(sTrade);
        }
    }

    nSellPrice = _PriceCompare(nPCBuy, nSellPrice, nNewPrice);

   return nSellPrice;
}
//What we know: Items can only be bought in multiples of 10.
//Every item that can be currently bought has a stack size of 99, other than misc mediums
//every other item is misc smalls at current, but lets futurte proof
void _CreateItem(string sResref, int nQTY, object oPC)
{
    object oItem = CreateItemOnObject(sResref, oPC, nQTY);
   /* int nMaxStackSize = 99;
    int nItemType =  GetBaseItemType(oItem);
    if(nItemType == BASE_ITEM_MISCMEDIUM)
        nMaxStackSize = 5;
    else if(nItemType == BASE_ITEM_MISCTHIN)
        nMaxStackSize = 20;
    else if(nItemType == BASE_ITEM_POTIONS || nItemType == BASE_ITEM_HEALERSKIT)
        nMaxStackSize = 10;
    else if(nItemType != BASE_ITEM_MISCSMALL)
    {

    } */
    int nCurrentStackSize = GetItemStackSize(oItem);
    SetItemStackSize(oItem, 99);
    int nMaxStackSize = GetItemStackSize(oItem);
    SetItemStackSize(oItem, nCurrentStackSize);

    nQTY -= nMaxStackSize;
    while(nQTY > 0)
    {
        CreateItemOnObject(sResref, oPC, nQTY);
        nQTY -= nMaxStackSize;
    }

}
object _ItemByResref(string sResref, object oChest)
{
    object oItem = GetItemPossessedBy(oChest, sResref);
    if(GetIsObjectValid(oItem)) return oItem;

    oItem = GetFirstItemInInventory(oChest);
    while(GetIsObjectValid(oItem))
    {
       if(sResref == GetResRef(oItem))
            return oItem;

        oItem = GetNextItemInInventory(oChest);
    }

    return OBJECT_INVALID;
}
void _ComputePrice(string sResource, string sResRef, string sNationID)
{
    string sResref2 = GetLocalString(OBJECT_SELF, VAR_ITEM);
    if(sResref2 != "" && sResRef != sResref2) return; //specific item doesn't match
    object oChest = GetObjectByTag(VAR_RESOURCE_INV+sResource);
    float fPrice = miCZGetSettlementBuyPrice(sNationID, sResource);
    object oItem = _ItemByResref(sResRef, oChest);
    if(!GetIsObjectValid(oItem)) return;
    string sUpdate=_Update(TRUE, IntToFloat(GetGoldPieceValue(oItem))*fPrice, -1, 0);
    SQLExecStatement("UPDATE mdcz_wh SET " + sUpdate + " WHERE nation=? AND resref=?", sNationID, sResRef);

}
void _ItemMenuSQL(string sNationID, int nBuy=TRUE, int nQty=FALSE)
{
    string sCondition;
    string sTable = "md_cr_input";
    switch(GetLocalInt(OBJECT_SELF, VAR_CAT_SELECTION))
    {
    case 0: sCondition = "(lower(c.name) LIKE '%animal%' OR lower(c.name) LIKE '%fish%' OR  w.resref='gs_item336' OR w.resref='gs_item824') "; break;
    case 1: sCondition = "(lower(c.name) LIKE '%wood%' OR w.resref='gs_item304' OR w.resref='gs_item253' OR w.resref='gs_item856' OR w.resref='gs_item905' OR w.resref='ir_yarrowleaves') "; break;
    case 2: sCondition = "lower(c.name) LIKE '%rock chunk%' "; break;
    case 3: sCondition = "lower(c.name) LIKE '%raw gem%' "; break;
    case 4: sTable = "md_cr_output"; sCondition = "lower(c.name) NOT LIKE '%animal%'"; break;
    default: sCondition = "lower(c.name) NOT LIKE '%animal%' AND lower(c.name) NOT LIKE '%fish%' AND  w.resref<>'gs_item336' AND w.resref<>'gs_item824' " +
                          "AND lower(c.name) NOT LIKE '%wood%' AND w.resref<>'gs_item304' AND w.resref<>'gs_item253' AND w.resref<>'gs_item856' " +
                          "AND lower(c.name) NOT LIKE '%rock chunk%' AND c.name NOT LIKE '%raw gem%' AND w.resref<>'gs_item905' AND w.resref<>'ir_yarrowleaves' ";
    }
    sCondition = "AND " + sCondition;

    if(nBuy)
        SQLExecStatement("SELECT buy,rbuy,cbuy,tbuy,rcbuy,rtbuy,clbuy,rclbuy,cclbuy,crclbuy,w.resref,c.name,w.QTY FROM mdcz_wh AS w INNER JOIN "+sTable+" AS c ON w.resref=c.Resref WHERE nation=?" + (nQty ? " AND w.QTY>0 ":" ") + sCondition + "GROUP BY w.resref ORDER BY c.name", sNationID);
    else
        SQLExecStatement("SELECT sell,rsell,csell,tsell,rcsell,rtsell,clsell,rclsell,cclsell,crclsell,w.resref,c.name,w.QTY FROM mdcz_wh AS w INNER JOIN "+sTable+" AS c ON w.resref=c.Resref WHERE nation=?" + (nQty ? " AND w.QTY>0 ":" ") + sCondition +"GROUP BY w.resref ORDER BY c.name", sNationID);

}
void Init()
{
  Trace(CITIZENSHIP, "Initialising trade czar conversation.");
  // This method is called once, at the start of the conversation.
  object oPC = GetPcDlgSpeaker();

  if (GetElementCount(MAIN_MENU) == 0)
  {

    AddStringElement("<c þ >[Donate Resources]</c>", MAIN_MENU);
    AddStringElement("<c þ >[Sell Resources]</c>", MAIN_MENU);
    AddStringElement("<c þ >[Expanded Warehouse]</c>", MAIN_MENU);
    AddStringElement("<c þ >[Purchase from City]</c>", MAIN_MENU);
    AddStringElement("<c þ >[Set Purchase Prices]</c>", MAIN_MENU);
    AddStringElement("<c þ >[Set Sale Prices]</c>", MAIN_MENU);
  }

  if (GetElementCount(TRADE_MENU) == 0)
  {

    AddStringElement("<c þ >[Donate Resources]</c>", TRADE_MENU);
    AddStringElement("<c þ >[Sell Resources]</c>", TRADE_MENU);
    AddStringElement("<c þ >[Expanded Warehouse]</c>", TRADE_MENU);
    AddStringElement("<c þ >[Purchase from City]</c>", TRADE_MENU);
  }

  if (GetElementCount(NON_MENU) == 0)
  {

    AddStringElement("<c þ >[Donate Resources]</c>", NON_MENU);
    AddStringElement("<c þ >[Sell Resources]</c>", NON_MENU);
    AddStringElement("<c þ >[Expanded Warehouse]</c>", NON_MENU);
  }

  if (GetElementCount(RESOURCE_MENU) == 0)
  {
    AddStringElement("<c þ >[Food]</c>", RESOURCE_MENU);
    AddStringElement("<c þ >[Wood]</c>", RESOURCE_MENU);
    AddStringElement("<c þ >[Cloth]</c>", RESOURCE_MENU);
    AddStringElement("<c þ >[Metal]</c>", RESOURCE_MENU);
    AddStringElement("<c þ >[Stone]</c>", RESOURCE_MENU);
    AddStringElement("<cþ  >[Back]</c>", RESOURCE_MENU);
  }

  if (GetElementCount(PRICE_MENU) == 0)
  {
    AddStringElement("<cþþþ>-50%</c>", PRICE_MENU);
    AddStringElement("<cþþþ>-10%</c>", PRICE_MENU);
    AddStringElement("<cþþþ>-5%</c>", PRICE_MENU);
    AddStringElement("<cþþþ>-1%</c>", PRICE_MENU);
    AddStringElement("<cþ  >+1%</c>", PRICE_MENU);
    AddStringElement("<cþ  >+5%</c>", PRICE_MENU);
    AddStringElement("<cþ  >+10%</c>", PRICE_MENU);
    AddStringElement("<cþ  >+50%</c>", PRICE_MENU);
    AddStringElement("<c þ >[Confirm]</c>", PRICE_MENU);
    AddStringElement("<cþ  >[Back]</c>", PRICE_MENU);
  }

  if (GetElementCount(DONE_MENU) == 0)
  {
    AddStringElement("<c þ >[Done]</c>", DONE_MENU);
  }

  if (GetElementCount(CONFIRM_MENU) == 0)
  {
    AddStringElement("<c þ >[Continue]</c>", CONFIRM_MENU);
    AddStringElement("<cþ  >[Cancel]</c>", CONFIRM_MENU);
  }

  if (GetElementCount(BUY_MENU) == 0)
  {
    AddStringElement("<c þ >[Speak amount then press here]</c>", BUY_MENU);
    AddStringElement("<cþ  >[Cancel]</c>", BUY_MENU);
  }

  if (GetElementCount(PAGE_CONFIRM) == 0)
  {
    AddStringElement("<c þ >[Yes]</c>", PAGE_CONFIRM);
    AddStringElement("<cþ  >[No]</c>", PAGE_CONFIRM);
  }

  if (GetElementCount(CATEGORY_MENU) == 0)
  {
    AddStringElement("Animal/Beast Products", CATEGORY_MENU);
    AddStringElement("Produce", CATEGORY_MENU);
    AddStringElement("Ore", CATEGORY_MENU);
    AddStringElement("Raw Gems", CATEGORY_MENU);
    AddStringElement("Healing supplies", CATEGORY_MENU);
    AddStringElement("Other", CATEGORY_MENU);
    AddStringElement(BACK_PROMPT, CATEGORY_MENU);
  }


  SetShowEndSelection(TRUE);

}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  object oCzar = OBJECT_SELF;

  string sMyNation = GetLocalString(oCzar, VAR_NATION); // name
  string sNationID = miCZGetBestNationMatch(sMyNation);   // id
  string sFactionID = md_GetDatabaseID(miCZGetName(sNationID));
  object oNation = miCZLoadNation(sNationID);

  if (sPage == "")
  {
    SetDlgPrompt("Have you got some resources for me?  I need stone, wood, food, " +
     "metal and cloth or hides - put them in my resource chest and talk to me.\n\n" +
     "Or, are you here to buy some of the my stock?\n\n" +
     "Current stockpiles and prices:\n" + miCZGetSettlementTradeStatus(sNationID));

    if (md_GetHasPowerSettlement(MD_PR2_RSB, oPC, sFactionID, "2"))
    {
      DeleteLocalString(OBJECT_SELF, VAR_DLG_NEXTPAGE);
      DeleteLocalString(OBJECT_SELF, VAR_DLG_RESOURCE);
      DeleteLocalFloat(OBJECT_SELF, VAR_DLG_PRICE);
      SetDlgResponseList(MAIN_MENU);
    }
    else if (gsQUGetIsOwner(OBJECT_SELF, oPC))
    {
      DeleteLocalString(OBJECT_SELF, VAR_DLG_NEXTPAGE);
      DeleteLocalString(OBJECT_SELF, VAR_DLG_RESOURCE);
      DeleteLocalFloat(OBJECT_SELF, VAR_DLG_PRICE);
      SetDlgResponseList(MAIN_MENU);
    }
    else if (sMyNation == GetLocalString(oNation, VAR_NAME) && miCZGetCanTrade(oPC, sNationID))
    {
      SetDlgResponseList(TRADE_MENU);
    }
    else
    {
      SetDlgResponseList(NON_MENU);
    }
  }
  else if (sPage == PAGE_DONATE || sPage == PAGE_SELL)
  {
    object oChest = GetObjectByTag("MI_CZ_CHEST_" + GetStringUpperCase(sMyNation));
    if (GetIsObjectValid(oChest))
    {
      object oItem = GetFirstItemInInventory(oChest);

      if (!GetIsObjectValid(oItem))
      {
        SetDlgPrompt("Please put the resources you wish to " + (sPage == PAGE_DONATE ?
         "donate":"sell") + " in my chest over there. I'll take any cloth, stone, " +
         "wood, metal or food that we can use.");
        SetDlgResponseList(DONE_MENU);
      }
      else
      {
        SetDlgPrompt("Are you sure you want to " + (sPage == PAGE_DONATE ? "donate":"sell") +
         " everything in the chest?");
        SetDlgResponseList(CONFIRM_MENU);
      }
    }
    else
    {
      SendMessageToPC(oPC, "Module badly configured, please report!");
    }
  }
  else if (sPage == PAGE_BUY)
  {
    SetDlgPrompt("What do you want to buy?");
    SetDlgResponseList(RESOURCE_MENU);
  }
  else if (sPage == PAGE_BUY_RESOURCE)
  {
    string sResource = GetLocalString(OBJECT_SELF, VAR_DLG_RESOURCE);
    float fPrice = miCZGetSettlementSellPrice(sNationID, GetStringUpperCase(sResource));
    int nNumCitizens = miCZGetCitizenCount(sNationID);
    struct Service YearCost = mdCZYearlyResourceCost(sNationID);
    SetDlgPrompt("What value do you want to buy?  I'll sell anything from my stockpiles over " +
     IntToString(YearCost.nFood) + "gp's worth which I need for this winter.\n\n" +
     "The rate for " + sResource + " is " + gsCMGetAsString(fPrice * 100.0) + "% of value.\n\n" +
     "You can buy up to 1000 units at a time.");

    SetDlgResponseList(BUY_MENU);
  }
  else if (sPage == PAGE_PRICE)
  {
    string sNextPage = GetLocalString(OBJECT_SELF, VAR_DLG_NEXTPAGE);
    string sResource = GetLocalString(OBJECT_SELF, VAR_DLG_RESOURCE);

    float fPrice = GetLocalFloat(OBJECT_SELF, VAR_DLG_PRICE);

    if (sNextPage == PAGE_SETBUY)
    {
      if (fPrice == 0.0)
      {
        fPrice = GetLocalFloat(oNation, VAR_BUYPRICE + GetStringUpperCase(sResource));
        SetLocalFloat(OBJECT_SELF, VAR_DLG_PRICE, fPrice);
      }

      fPrice = (fPrice) * 100.0; // convert to %
      SetDlgPrompt("Buy price for " + sResource + " is currently " +
        gsCMGetAsString(fPrice) + "%");
    }
    else
    {
      if (fPrice == 0.0)
      {
        fPrice = GetLocalFloat(oNation, VAR_SELLPRICE + GetStringUpperCase(sResource));
        SetLocalFloat(OBJECT_SELF, VAR_DLG_PRICE, fPrice);
      }

      fPrice = (fPrice) * 100.0; // convert to %
      SetDlgPrompt("Sale price for " + sResource + " is currently " +
       gsCMGetAsString(fPrice) + "%");
    }

    SetDlgResponseList(PRICE_MENU);
  }
  else if (sPage == PAGE_RESOURCE)
  {
    SetDlgPrompt("Which resource do you wish to manage?");
    DeleteLocalFloat(OBJECT_SELF, VAR_DLG_PRICE);
    SetDlgResponseList(RESOURCE_MENU);
  }
  else if (sPage == PAGE_SETBUY)
  {
    string sNextPage = GetLocalString(OBJECT_SELF, VAR_DLG_NEXTPAGE);
    string sResource = GetLocalString(OBJECT_SELF, VAR_DLG_RESOURCE);
    float fPrice     = GetLocalFloat(OBJECT_SELF, VAR_DLG_PRICE);
    fPrice = (fPrice) * 100.0; // convert to %

    SetDlgPrompt("You have chosen to set " + sMyNation + "'s sale price for " +
     sResource + " to " + GetStringLeft(gsCMTrimString(FloatToString(fPrice), " "),5) + "%.  Are you sure?");
    SetDlgResponseList(CONFIRM_MENU);
  }
  else if (sPage == PAGE_SETSELL)
  {
    string sNextPage = GetLocalString(OBJECT_SELF, VAR_DLG_NEXTPAGE);
    string sResource = GetLocalString(OBJECT_SELF, VAR_DLG_RESOURCE);
    float fPrice     = GetLocalFloat(OBJECT_SELF, VAR_DLG_PRICE);
    fPrice = (fPrice) * 100.0; // convert to %

    SetDlgPrompt("You have chosen to set " + sMyNation + "'s buy price for " +
     sResource + " to " + GetStringLeft(gsCMTrimString(FloatToString(fPrice), " "),5) + "%.  Are you sure?");
    SetDlgResponseList(CONFIRM_MENU);
  }
  else if (sPage == PAGE_EXP)
  {


    int nService = StringToInt(miDAGetKeyedValue("micz_nations", sNationID, "services"));
    if(!(nService & MD_SV_EXPWH))
    {
        SetDlgPrompt(miCZGetName(sNationID) + " does not currently have an expanded warehouse.");
        DeleteList(PAGE_EXP);
        int nWrit = md_GetHasWrit(oPC, sFactionID, MD_PR2_RSB, "2");
        if(nWrit > 0 && nWrit !=2)
            AddStringElement(sStartService, PAGE_EXP);
    }
    else
    {
         SetDlgPrompt("Which do you wish to perform?");
         if(GetElementCount(PAGE_EXP) == 0)
         {
             int nWrit = md_GetHasWrit(oPC, sFactionID, MD_PR2_RSB, "2");

             if(nWrit != 2)
             {
                if(nWrit)
                    AddStringElement(sEndService, PAGE_EXP);
                AddStringElement(sSet, PAGE_EXP);
                AddStringElement(sRace, PAGE_EXP);
                AddStringElement(sClass, PAGE_EXP);
                AddStringElement(STO_DEP, PAGE_EXP);
             }
             else if(md_GetHasPowerSettlement(MD_PR2_RSB, oPC, sFactionID, "2"))
             {
                AddStringElement(sSet, PAGE_EXP);
                AddStringElement(STO_DEP, PAGE_EXP);
             }

             AddStringElement(sPurchase, PAGE_EXP);
             AddStringElement(sDisplay, PAGE_EXP);
         }

    }


    SetDlgResponseList(PAGE_EXP);
  }
  else if(sPage == PAGE_CONFIRM)
  {
    if(GetDlgPageInt())
    {
        struct Service Exp = GetService(MD_SV_EXPWH);
        SetDlgPrompt("Would you like to start service " + Exp.sName + "? It has an initial and yearly cost of " + IntToString(Exp.nFood) + " food " + IntToString(Exp.nMetal) + " metal " +  IntToString(Exp.nWood) + " wood " + IntToString(Exp.nCloth) + " cloth and " + IntToString(Exp.nStone) + " stone.");
    }
    else
    {
        SetDlgPrompt("End expanded warehouses?");
    }

    SetDlgResponseList(PAGE_CONFIRM);
  }
  else if(sPage == PAGE_RACE)
  {
    SetDlgPrompt("Which races deserve special treatment? If you brought a writ you'll have to confirm with me your decision.");

    if(GetElementCount(sPage) == 0)
    {
        md_SetUpRaceList(sPage, GetLocalInt(oCzar, VAR_BIT));
        if(md_GetHasWrit(oPC, sFactionID, 0) == 3)
            AddStringElement(sConfirm, sPage);

        AddStringElement(BACK_PROMPT, sPage);
    }
    SetDlgResponseList(sPage);
  }
  else if(sPage == PAGE_CLASS)
  {
    SetDlgPrompt("Which classes deserve special treatment? If you brought a writ you'll have to confirm with me your decision.");

     if(GetElementCount(sPage) == 0)
     {
        md_SetUpClassList(sPage, GetLocalInt(oCzar, VAR_BIT));
        if(md_GetHasWrit(oPC, sFactionID, 0) == 3)
             AddStringElement(sConfirm, sPage);

        AddStringElement(BACK_PROMPT, sPage);
     }
     SetDlgResponseList(sPage);
  }
  else if(sPage == PAGE_SET)
  {
     SetDlgPrompt("Purchase or sell prices?");
     if(GetElementCount(sPage) == 0)
     {
        AddStringElement("<c þ >[Set purchase prices]</c>", sPage);
        AddStringElement("<c þ >[Set sell prices]</c>", sPage);
        SQLExecStatement("SELECT Count(QTY) FROM mdcz_wh WHERE nation=?", sNationID);
        if(SQLFetch() && StringToInt(SQLGetData(1)) < ItemCount)
            AddStringElement("[Add additional items]", sPage);
        AddStringElement(BACK_PROMPT, sPage);
     }
     SetDlgResponseList(sPage);
  }
  else if(sPage == PAGE_ESET)
  {
    SetDlgPrompt("Who are we adjusting " + (GetLocalInt(oCzar, VAR_BIT) == TRUE ? "purchase":"sell") + " prices for?");

    if(GetElementCount(sPage) == 0)
    {
        AddStringElement("<c þ >[Set base prices]</c>", sPage);
        AddStringElement("<c þ >[Set prices for citizens of non specified races]</c>", sPage);
        AddStringElement("<c þ >[Set prices for classes of non specified races]</c>", sPage);
        AddStringElement("<c þ >[Set prices for citizens & classes of non specified races]</c>", sPage);
        AddStringElement("<c þ >[Set base prices for races]</c>", sPage);
        AddStringElement("<c þ >[Set prices for races & citizen]</c>", sPage);
        AddStringElement("<c þ >[Set prices for races & class]</c>", sPage);
        AddStringElement("<c þ >[Set prices for races & class & citizen]</c>", sPage);
        AddStringElement("<c þ >[Set prices for trade partners of non specified races]</c>", sPage);
        AddStringElement("<c þ >[Set prices for trade partners of specified races]</c>", sPage);
        AddStringElement("<c þ >[Adjust all prices]</c>", sPage);
        AddStringElement(BACK_PROMPT, sPage);
    }
    SetDlgResponseList(sPage);

  }
  else if(sPage == PAGE_SSEL)
  {
    string sPrompt = "Adjust which ";

    int nSel = GetDlgPageInt();
    if(nSel == 0)
        sPrompt += " base ";
    else if(nSel == 1)
        sPrompt += " citizen ";
    else if(nSel == 2)
        sPrompt += " class ";
    else if(nSel == 3)
        sPrompt += " citizen and class ";
    else if(nSel == 4)
        sPrompt += " race ";
    else if(nSel == 5)
        sPrompt += " race and citizen ";
    else if(nSel == 6)
        sPrompt += " race and class ";
    else if(nSel == 7)
        sPrompt += " race, class, and citizen ";
    else if(nSel == 8)
        sPrompt += " trade ";
    else if(nSel == 9)
        sPrompt += " trade and race ";
    else
        sPrompt = "Adjust all ";
    if(GetLocalInt(oCzar, VAR_BIT))
        sPrompt += "purchase ";
    else
        sPrompt += "sell ";
    sPrompt += "prices.";

    SetDlgPrompt(sPrompt + txtRed +"  ((Type number before selecting ... Negative numbers lower price. Typing in a % sign will raise/lower prices by that percentage. Setting sell price to a negative number will make that item unable to be sold.))</c> WARNING: Setting a settlement purchase price below it's sell price can/will cause the settlemet to lose gold!");
    DeleteList(sPage);
    DeleteLocalString(oCzar, VAR_ITEM);
    AddStringElement("<c þ >[Raise/Lower prices by ...]</c>", sPage);
    AddStringElement("<c þ >[Set prices to ...]</c>", sPage);
    if(!GetLocalInt(oCzar, VAR_BIT))
    {
        AddStringElement("<c þ >[Multiply by current tax rate]</c>", sPage);
        AddStringElement("<c þ >[Divide by current tax rate]</c>", sPage);
    }
    else
        AddStringElement("<c þ >[Match stockpile purchase prices]</c>", sPage);
    AddStringElement("<c þ >[Adjust to prices according to other lists]</c>", sPage);
    AddStringElement("<c þ >[Show individual items]</c>", sPage);
    AddStringElement(BACK_PROMPT, sPage);
    SetDlgResponseList(sPage);

  }
  else if(sPage == PAGE_COPY)
  {
    string sPrompt = "Adjust which ";

    int nSel = GetDlgPageInt();
    if(nSel == 0)
        sPrompt += " base ";
    else if(nSel == 1)
        sPrompt += " citizen ";
    else if(nSel == 2)
        sPrompt += " class ";
    else if(nSel == 3)
        sPrompt += " citizen and class ";
    else if(nSel == 4)
        sPrompt += " race ";
    else if(nSel == 5)
        sPrompt += " race and citizen ";
    else if(nSel == 6)
        sPrompt += " race and class ";
    else if(nSel == 7)
        sPrompt += " race, class, and citizen ";
    else if(nSel == 8)
        sPrompt += " trade ";
    else if(nSel == 9)
        sPrompt += " trade and race ";
    else
        sPrompt = "Adjust all ";
    if(GetLocalInt(oCzar, VAR_BIT))
        sPrompt += "purchase ";
    else
        sPrompt += "sell ";
    sPrompt += "prices.";

    SetDlgPrompt(sPrompt + txtRed + "  ((Type number before selecting ... Negative numbers lower price. Typing in a % sign will raise/lower prices by that percentage. Setting sell price to a negative number will make that item unable to be sold.))</c>");
    DeleteList(sPage);
    if(nSel != 0)
        AddStringElement(COPY_BASE, sPage);
    if(nSel != 1)
        AddStringElement(COPY_CITIZEN, sPage);
    if(nSel != 2)
        AddStringElement(COPY_CLASS, sPage);
    if(nSel != 3)
        AddStringElement(COPY_CCLASS, sPage);
    if(nSel != 4)
        AddStringElement(COPY_RACE, sPage);
    if(nSel != 5)
        AddStringElement(COPY_CRACE, sPage);
    if(nSel != 6)
        AddStringElement(COPY_CLRACE, sPage);
    if(nSel != 7)
        AddStringElement(COPY_CCLRACE, sPage);
    if(nSel != 8)
        AddStringElement(COPY_TRADE, sPage);
    if(nSel != 9)
        AddStringElement(COPY_RTRADE, sPage);

    AddStringElement(BACK_PROMPT, sPage);
    SetDlgResponseList(sPage);
  }
  else if(sPage == PAGE_INDITM)
  {
    string sPrompt = "Which item do you want to change ";

    int nSel = GetDlgPageInt();
    if(nSel == 0)
        sPrompt += " base ";
    else if(nSel == 1)
        sPrompt += " citizen ";
    else if(nSel == 2)
        sPrompt += " class ";
    else if(nSel == 3)
        sPrompt += " citizen and class ";
    else if(nSel == 4)
        sPrompt += " race ";
    else if(nSel == 5)
        sPrompt += " race and citizen ";
    else if(nSel == 6)
        sPrompt += " race and class ";
    else if(nSel == 7)
        sPrompt += " race, class, and citizen ";
    else if(nSel == 8)
        sPrompt += " trade ";
    else if(nSel == 9)
        sPrompt += " trade and race ";
    else
        sPrompt = "Adjust all ";
    if(GetLocalInt(oCzar, VAR_BIT))
    {
        sPrompt += "purchase ";
        //SQLExecStatement("SELECT w.resref,c.name,buy,rbuy,cbuy,tbuy,rcbuy,rtbuy,clbuy,rclbuy,cclbuy,crclbuy FROM mdcz_wh AS w INNER JOIN md_cr_input AS c ON w.resref=c.Resref WHERE nation=? GROUP BY w.resref", sNationID);
        _ItemMenuSQL(sNationID, TRUE);
    }
    else
    {
        sPrompt += "sell ";
        //SQLExecStatement("SELECT w.resref,c.name,sell,rsell,csell,tsell,rcsell,rtsell,clsell,rclsell,cclsell,crclsell FROM mdcz_wh AS w INNER JOIN md_cr_input AS c ON w.resref=c.Resref WHERE nation=? GROUP BY w.resref", sNationID);
        _ItemMenuSQL(sNationID, FALSE);
    }
    sPrompt += "prices for.\n\n";
    sPrompt += txtAqua + "Base</c>\n" + txtBlue + "Citizen</c>\n" + txtBrown + "Class</c>\n" +
        txtFuchsia + "Citizen and Class</c>\n" + txtGreen + "Race</c>\n" + txtGrey + "Race and Citizen</c>\n"+
        txtLime + "Race and Class</c>\n" + txtMaroon + "Race. Citizen, and Class</c>\n" +
        txtNavy + "Trade Partner</c>\n" + txtOlive + "Trade Partner and Race</c>\n";
    SetDlgPrompt(sPrompt);
    DeleteList(sPage);
    DeleteList(RESREF_MENU);

    while(SQLFetch())
    {
        AddStringElement(SQLGetData(11), RESREF_MENU);

        AddStringElement(SQLGetData(12)  + txtAqua + SQLGetData(1) +"</c>/" + txtBlue + SQLGetData(3)+"</c>/"   + txtBrown + SQLGetData(7)+"</c>/"  +
        txtFuchsia + SQLGetData(9)+"</c>/"   + txtGreen + SQLGetData(2)+"</c>/"   + txtGrey + SQLGetData(5)+"</c>/"  +
        txtLime + SQLGetData(8)+"</c>/"   + txtMaroon + SQLGetData(10)+"</c>/"   +
        txtNavy + SQLGetData(4)+"</c>/"   + txtOlive + SQLGetData(6)+"</c>" , sPage);

    }
    AddStringElement(BACK_PROMPT, sPage);
    SetDlgResponseList(sPage);
  }
  else if(sPage == PAGE_ITM)
  {
    string sPrompt = "Which ";

    int nSel = GetDlgPageInt();
    if(nSel == 0)
        sPrompt += " base ";
    else if(nSel == 1)
        sPrompt += " citizen ";
    else if(nSel == 2)
        sPrompt += " class ";
    else if(nSel == 3)
        sPrompt += " citizen and class ";
    else if(nSel == 4)
        sPrompt += " race ";
    else if(nSel == 5)
        sPrompt += " race and citizen ";
    else if(nSel == 6)
        sPrompt += " race and class ";
    else if(nSel == 7)
        sPrompt += " race, class, and citizen ";
    else if(nSel == 8)
        sPrompt += " trade ";
    else if(nSel == 9)
        sPrompt += " trade and race ";
    else
        sPrompt = "Adjust all ";
    if(GetLocalInt(oCzar, VAR_BIT))
    {
        sPrompt += "purchase ";
        SQLExecStatement("SELECT c.name,buy,rbuy,cbuy,tbuy,rcbuy,rtbuy,clbuy,rclbuy,cclbuy,crclbuy FROM mdcz_wh AS w INNER JOIN md_cr_input AS c ON w.resref=c.Resref WHERE nation=? AND w.resref=?", sNationID, GetLocalString(oCzar, VAR_ITEM));
    }
    else
    {
        sPrompt += "sell ";
        SQLExecStatement("SELECT c.name,sell,rsell,csell,tsell,rcsell,rtsell,clsell,rclsell,cclsell,crclsell FROM mdcz_wh AS w INNER JOIN md_cr_input AS c ON w.resref=c.Resref WHERE nation=? AND w.resref=?", sNationID, GetLocalString(oCzar, VAR_ITEM));
    }
    SQLFetch();
    sPrompt += "prices for " + SQLGetData(1) + "?\n\n";
    sPrompt += txtAqua + "Base: " + SQLGetData(2) + "</c>\n" + txtBlue + "Citizen: " + SQLGetData(4) + "</c>\n" + txtBrown + "Class: " + SQLGetData(8) + "</c>\n" +
        txtFuchsia + "Citizen and Class: " + SQLGetData(10)+ "</c>\n" + txtGreen + "Race: " + SQLGetData(3)+ "</c>\n" + txtGrey + "Race and Citizen: " + SQLGetData(6)+ "</c>\n"+
        txtLime + "Race and Class: " +SQLGetData(9) + "</c>\n" + txtMaroon + "Race. Citizen, and Class: " + SQLGetData(11)+ "</c>\n" +
        txtNavy + "Trade Partner: " + SQLGetData(5)+ "</c>\n" + txtOlive + "Trade Partner and Race: " + SQLGetData(7)+ "</c>\n";
    SetDlgPrompt(sPrompt);
    DeleteList(sPage);

    AddStringElement("<c þ >[Raise/Lower prices by ...]</c>", sPage);
    AddStringElement("<c þ >[Set prices to ...]</c>", sPage);
    if(!GetLocalInt(oCzar, VAR_BIT))
    {
        AddStringElement("<c þ >[Multiply by current tax rate]</c>", sPage);
        AddStringElement("<c þ >[Divide by current tax rate]</c>", sPage);
    }
    else
        AddStringElement("<c þ >[Match stockpile purchase prices]</c>", sPage);
    AddStringElement("<c þ >[Adjsut to prices according to other lists]</c>", sPage);
    AddStringElement(BACK_PROMPT, sPage);

    SetDlgResponseList(sPage);
  }
  else if(sPage == PAGE_PURCHASE)
  {
    SetDlgPrompt("Which item do you wish to purchase?");
    DeleteList(RESREF_MENU);
    DeleteList(sPage);
    SQLExecStatement("SELECT race,class FROM micz_nations WHERE id=?", sNationID);
    SQLFetch();
    int nRace = StringToInt(SQLGetData(1));
    nRace = _CheckRace(nRace, oPC);
    int nClass = StringToInt(SQLGetData(2));

    nClass = _CheckClass(nClass, oPC);
    int nPrice;
    float fPrice;
    float fFinalTax = (1+fTax+miCZGetTaxRate(sNationID));
    int nNationMatch = GetLocalString(oPC, VAR_NATION) == sNationID;
    int nTrade = miCZGetCanTrade(oPC, sNationID);
    string sResref;
    int nPower = md_GetHasPowerSettlement(MD_PR2_RSB, oPC, sFactionID, "2");
    //SQLExecStatement("SELECT sell,rsell,csell,tsell,rcsell,rtsell,clsell,rclsell,cclsell,crclsell,w.QTY,w.resref,c.name FROM mdcz_wh AS w INNER JOIN md_cr_input AS c ON w.resref=c.Resref WHERE nation=? AND w.QTY>0 GROUP BY w.resref ORDER BY c.name", sNationID);
    _ItemMenuSQL(sNationID, FALSE, TRUE);
    while(SQLFetch())
    {

        nPrice =  _BestSellPrice(SQLGetData(1), SQLGetData(2), SQLGetData(3), SQLGetData(4), SQLGetData(5), SQLGetData(6), SQLGetData(7), SQLGetData(8), SQLGetData(9), SQLGetData(10), nNationMatch, nRace, nClass, nTrade, TRUE);

        if(nPrice >= 0 || nPower) //no sell price so no sale
        {
            sResref = SQLGetData(11);
            AddStringElement(sResref, RESREF_MENU);

            fPrice = IntToFloat(nPrice) * fFinalTax;
            nPrice = FloatToInt(fPrice); //get rid of decimals
            AddStringElement(SQLGetData(12) + " " + SQLGetData(13)+"/"+IntToString(_GetMaxQty(sResref))+ " " + IntToString(nPrice), sPage);
        }
    }
    AddStringElement(BACK_PROMPT, sPage);
    SetDlgResponseList(sPage);
  }
  else if(sPage == PAGE_PURITM)
  {
    string sPrompt = "How much of ";
    string sResRef = GetLocalString(oCzar, VAR_ITEM);
    SQLExecStatement("SELECT race,class FROM micz_nations WHERE id=?", sNationID);
    SQLFetch();
    int nRace = StringToInt(SQLGetData(1));
    nRace = _CheckRace(nRace, oPC);
    int nClass = StringToInt(SQLGetData(2));
    nClass = _CheckClass(nClass, oPC);
    SQLExecStatement("SELECT sell,rsell,csell,tsell,rcsell,rtsell,clsell,rclsell,cclsell,crclsell,w.QTY,c.name,o.name FROM mdcz_wh AS w LEFT JOIN md_cr_input AS c ON w.resref=c.Resref LEFT JOIN md_cr_output AS o ON w.resref=o.Resref WHERE nation=? AND w.resref=?", sNationID, sResRef);
    string sItemName;
    while(SQLFetch())
    {
        sItemName = SQLGetData(12);
        if(sItemName == "")
            sItemName = SQLGetData(13);

        if(sItemName != "")
            break;
    }
    sPrompt += sItemName + " do you want to buy?";

    int nPrice;
    float fPrice;
    float fFinalTax = (1+fTax+miCZGetTaxRate(sNationID));
    int nNationMatch = GetLocalString(oPC, VAR_NATION) == sNationID;
    int nTrade = miCZGetCanTrade(oPC, sNationID);
    nPrice =  _BestSellPrice(SQLGetData(1), SQLGetData(2), SQLGetData(3), SQLGetData(4), SQLGetData(5), SQLGetData(6), SQLGetData(7), SQLGetData(8), SQLGetData(9), SQLGetData(10), nNationMatch, nRace, nClass, nTrade, TRUE);
    SetLocalInt(oCzar, VAR_PRICE, nPrice);
    fPrice = IntToFloat(nPrice) * fFinalTax;
    nPrice = FloatToInt(fPrice); //get rid of decimals

    int x = 1;
    int nQty = StringToInt(SQLGetData(11));
    DeleteList(sPage);
    while(x <= 10 && x <= nQty)
    {
        AddStringElement(IntToString(x) + ": " + IntToString(nPrice * x), sPage);
        x++;
    }
    AddStringElement(BACK_PROMPT, sPage);
    SetDlgPrompt(sPrompt);
    SetDlgResponseList(sPage);
  }
  else if(sPage == PAGE_DISPLAY)
  {
    string sPrompt = "Settlement will purchase the following items at: \n";
    SQLExecStatement("SELECT race,class FROM micz_nations WHERE id=?", sNationID);
    SQLFetch();
    int nRace = StringToInt(SQLGetData(1));
    nRace = _CheckRace(nRace, oPC);
    int nClass = StringToInt(SQLGetData(2));
    nClass = _CheckClass(nClass, oPC);
    int nPrice;
    int nNationMatch = GetLocalString(oPC, VAR_NATION) == sNationID;
    int nTrade = miCZGetCanTrade(oPC, sNationID);
    //SQLExecStatement("SELECT buy,rbuy,cbuy,tbuy,rcbuy,rtbuy,clbuy,rclbuy,cclbuy,crclbuy,w.resref,c.name,w.QTY FROM mdcz_wh AS w INNER JOIN md_cr_input AS c ON w.resref=c.Resref WHERE nation=? GROUP BY w.resref ORDER BY c.name", sNationID);
   _ItemMenuSQL(sNationID, TRUE);
    while(SQLFetch())
    {
        nPrice =  _BestSellPrice(SQLGetData(1), SQLGetData(2), SQLGetData(3), SQLGetData(4), SQLGetData(5), SQLGetData(6), SQLGetData(7), SQLGetData(8), SQLGetData(9), SQLGetData(10), nNationMatch, nRace, nClass, nTrade);
        sPrompt += "\n"+SQLGetData(12) + " " + SQLGetData(13)+"/"+IntToString(_GetMaxQty(SQLGetData(11))) + " " + IntToString(nPrice);
    }
    SetDlgPrompt(sPrompt);
    SetDlgResponseList(CATEGORY_MENU);
  }
  else if(sPage == PAGE_STOCK)
  {
    SetDlgPrompt("Which resource?");
    SetDlgResponseList(RESOURCE_MENU);
  }
  else if(sPage == PAGE_STOITM)
  {
    SetDlgPrompt("Which item do you wish to move to the stockpiles");

    int nSelection = GetDlgPageInt();
    string sPrepare;
    if(nSelection == 0)
        sPrepare = SQLPrepareStatement(" w.resref=? OR w.resref=? OR w.resref=? OR w.resref=? OR w.resref=? OR w.resref=? OR w.resref=?", "gs_item897", "gs_item898", "gs_item899", "gs_item304", "gs_item253", "gs_item856", "sweetberry002");
    else if(nSelection == 1)
        sPrepare =  SQLPrepareStatement(" w.resref=? OR w.resref=?", "gs_item901", "gs_item900");
    else if(nSelection == 2)
        sPrepare = SQLPrepareStatement(" w.resref=? OR w.resref=? OR w.resref=?", "gs_item854", "gs_item896", "gs_item895");
    else if(nSelection == 4)
        sPrepare =  SQLPrepareStatement(" w.resref=? OR w.resref=?", "gs_item385", "gs_item381");

    DeleteList(PAGE_STOITM);
    DeleteList(RESREF_MENU);
    if(nSelection !=3)
    {
        SQLExecStatement("SELECT c.name,w.resref FROM mdcz_wh AS w INNER JOIN md_cr_input AS c ON w.resref=c.resref WHERE ("+sPrepare+") AND w.QTY > 0 AND nation=?  GROUP BY w.resref ORDER BY c.name", sNationID);

        while(SQLFetch())
        {
            AddStringElement(SQLGetData(1), PAGE_STOITM);
            AddStringElement(SQLGetData(2), RESREF_MENU);
        }
    }

    AddStringElement(BACK_PROMPT, PAGE_STOITM);
    SetDlgResponseList(PAGE_STOITM);
  }
  else if(sPage == PAGE_MVITM)
  {
    SQLExecStatement("SELECT c.name,w.QTY FROM mdcz_wh AS w INNER JOIN md_cr_input AS c ON w.resref=c.resref WHERE nation=? AND w.resref=? LIMIT 1", sNationID, GetLocalString(oCzar, VAR_ITEM));
    SQLFetch();
    int nQty = StringToInt(SQLGetData(2));
    SetDlgPrompt("How many of " + SQLGetData(1) + " do you wish to move to the stockpiles? Current quantity: " + SQLGetData(2));
    int x = 1;
    DeleteList(PAGE_MVITM);
    while(x <= 10 && x <= nQty)
    {
        AddStringElement("Move " + IntToString(x), PAGE_MVITM);
        x++;
    }
    AddStringElement(BACK_PROMPT, PAGE_MVITM);
    SetDlgResponseList(PAGE_MVITM);
  }
  else if(sPage == PAGE_CAT_PUR || sPage == PAGE_CAT_PRI)
  {
    SetDlgPrompt("Select an item category.");
    SetDlgResponseList(CATEGORY_MENU);
  }
  else
  {
    SendMessageToPC(oPC, "You've found a bug.  Please report it on the forums!");
  }
}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection   = GetDlgSelection();
  object oPC      = GetPcDlgSpeaker();
  string sPage    = GetDlgPageString();
  object oCzar    = OBJECT_SELF;

  string sMyNation = GetLocalString(oCzar, VAR_NATION); // name
  string sNationID = miCZGetBestNationMatch(sMyNation);   // id

  object oNation = miCZLoadNation(sNationID);

  if (sPage == "")
  {
    switch (selection)
    {
      case 0:
        SetDlgPageString(PAGE_DONATE);
        break;
      case 1:
        SetDlgPageString(PAGE_SELL);
        break;
      case 2:
        SetDlgPageString(PAGE_EXP);
        break;
      case 3:
        SetDlgPageString(PAGE_BUY);
        break;
      case 4:
        SetLocalString(OBJECT_SELF, VAR_DLG_NEXTPAGE, PAGE_SETBUY);
        SetDlgPageString(PAGE_RESOURCE);
        break;
      case 5:
        SetLocalString(OBJECT_SELF, VAR_DLG_NEXTPAGE, PAGE_SETSELL);
        SetDlgPageString(PAGE_RESOURCE);
        break;
    }
  }
  else if (sPage == PAGE_DONATE || sPage == PAGE_SELL)
  {
    object oChest = GetObjectByTag("MI_CZ_CHEST_" + GetStringUpperCase(sMyNation));
    object oReferenceChest1 = GetObjectByTag(VAR_RESOURCE_INV + RESOURCE_FOOD);
    object oReferenceChest2 = GetObjectByTag(VAR_RESOURCE_INV + RESOURCE_WOOD);
    object oReferenceChest3 = GetObjectByTag(VAR_RESOURCE_INV + RESOURCE_CLOTH);
    object oReferenceChest4 = GetObjectByTag(VAR_RESOURCE_INV + RESOURCE_METAL);
    object oReferenceChest5 = GetObjectByTag(VAR_RESOURCE_INV + RESOURCE_STONE);


    int nFoodV;
    int nFoodP;
    int nStoneV;
    int nStoneP;
    int nWoodV;
    int nWoodP;
    int nClothV;
    int nClothP;
    int nMetalV;
    int nMetalP;


    if (GetIsObjectValid(oChest) &&
        GetIsObjectValid(oReferenceChest1) &&
        GetIsObjectValid(oReferenceChest2) &&
        GetIsObjectValid(oReferenceChest3) &&
        GetIsObjectValid(oReferenceChest4) &&
        GetIsObjectValid(oReferenceChest5))
    {
      Trace(CITIZENSHIP, "Selling or donating items");
      object oItem = GetFirstItemInInventory(oChest);
      object oReferenceItem;

      int nQty;
      int nService = StringToInt(miDAGetKeyedValue("micz_nations", sNationID, "services")) & MD_SV_EXPWH;
      string sResRef;

      string LIST_ITEM = "LIST_MD_ITEM";

      while (GetIsObjectValid(oItem) && selection == 0)
      {
        sResRef = GetResRef(oItem);
        SQLExecStatement("SELECT QTY FROM mdcz_wh WHERE resref=? AND nation=? LIMIT 1", sResRef, sNationID);
        if(nService && SQLFetch() && StringToInt(SQLGetData(1)) < _GetMaxQty(sResRef))
        {
            if(sResRef != "ar_it_miscband" || GetItemCharges(oItem) >= 10)  //if the item isn't a bandage roll, or the bandageroll has max charges proceed
            {
                nQty = GetLocalInt(oCzar, sResRef);
                if(nQty)
                {
                    SetLocalInt(oCzar, sResRef, nQty + GetItemStackSize(oItem));
                }
                else
                {
                    AddStringElement(sResRef, LIST_ITEM, oCzar);
                    SetLocalInt(oCzar, sResRef, GetItemStackSize(oItem));
                }
            }
        }
        else
        {

            //----------------------------------------------------------------------
            // Work out if this item exists in any of our reference chests.
            //----------------------------------------------------------------------
            string sResource;

            if (GetTag(oItem) == "mi_resource_bund")
            {
                sResource = GetLocalString(oItem, "RESOURCE");
                oReferenceItem = oItem;
            }
            else
            {

                oReferenceItem = GetItemPossessedBy(oReferenceChest1, GetTag(oItem));
                sResource = RESOURCE_FOOD;

                if (!GetIsObjectValid(oReferenceItem))
                {
                    sResource = RESOURCE_WOOD;
                    oReferenceItem = GetItemPossessedBy(oReferenceChest2, GetTag(oItem));
                }

                if (!GetIsObjectValid(oReferenceItem))
                {
                    sResource = RESOURCE_CLOTH;
                    oReferenceItem = GetItemPossessedBy(oReferenceChest3, GetTag(oItem));
                }

                if (!GetIsObjectValid(oReferenceItem))
                {
                    sResource = RESOURCE_METAL;
                    oReferenceItem = GetItemPossessedBy(oReferenceChest4, GetTag(oItem));
                }

                if (!GetIsObjectValid(oReferenceItem))
                {
                    sResource = RESOURCE_STONE;
                    oReferenceItem = GetItemPossessedBy(oReferenceChest5, GetTag(oItem));
                }
            }

            Trace(CITIZENSHIP, "Got reference item: " + GetName(oReferenceItem));

            if (GetIsObjectValid(oReferenceItem))
            {
                //--------------------------------------------------------------------
                // get value
                // check whether city can pay for it (if need be)
                // pay character if needed
                // delete item
                // credit city with value of item
                //--------------------------------------------------------------------
                 float fPrice = GetLocalFloat(oNation, VAR_BUYPRICE + sResource);

                //--------------------------------------------------------------------
                // Remove any properties from the item.  People were using the
                // enchanting basin to pump up the value of things.  Doh.
                //
                // Doesn't work coz item properties aren't removed till script ends.
                // So replaced by using the value of the reference item instead.
                //--------------------------------------------------------------------
                //itemproperty iprp = GetFirstItemProperty(oItem);
                //while (GetIsItemPropertyValid(iprp))
                //{
                //  if (GetItemPropertyType(iprp) != ITEM_PROPERTY_WEIGHT_INCREASE) RemoveItemProperty(oItem, iprp);
                //  iprp = GetNextItemProperty(oItem);
                //}

                int nValue;
                int nPrice;

                if (oReferenceItem == oItem)
                {
                    nValue = GetLocalInt(oItem, "VALUE");
                    nPrice = FloatToInt(IntToFloat(nValue) * fPrice);
                }
                else
                {
                    nValue = GetGoldPieceValue(oReferenceItem) * GetItemStackSize(oItem);
                    nPrice = FloatToInt(IntToFloat(nValue) * fPrice);
                }

                // Keep 10k gold in reserve at all times.
                if (sPage == PAGE_SELL && gsFIGetAccountBalance("N" + sNationID) < (nPrice + 10000))
                {
                    // Can't afford item.
                    SendMessageToPC(oPC, "This settlement can't afford to buy all that.");
                    break;
                }
                else
                {
                    if (sPage == PAGE_SELL)
                    {
                        gsFITransferFromTo("N" + sNationID, "DUMMY", nPrice);
                        GiveGoldToCreature(oPC, nPrice);
                    }

                    if(sResource == RESOURCE_FOOD)
                    {
                        nFoodV += nValue;
                        nFoodP += nPrice;
                    }
                    else if(sResource == RESOURCE_STONE)
                    {
                        nStoneV += nValue;
                        nStoneP += nPrice;
                    }
                    else if(sResource == RESOURCE_WOOD)
                    {
                        nWoodV += nValue;
                        nWoodP += nPrice;
                    }
                    else if(sResource == RESOURCE_CLOTH)
                    {
                        nClothV += nValue;
                        nClothP += nPrice;
                    }
                    else if(sResource == RESOURCE_METAL)
                    {
                        nMetalV += nValue;
                        nMetalP += nPrice;
                    }
                    // Check for poisoned food.
                    if (GetLocalInt(oItem, VAR_POISON_TYPE))
                    {
                        miCZAddtoStockpile(sNationID, sResource, -nValue);
                    }
                    else
                    {
                        miCZAddtoStockpile(sNationID, sResource, nValue);
                    }

                     DestroyObject(oItem);

                 }
            }
        }
        oItem = GetNextItemInInventory(oChest);
      }

      string sElement = GetFirstStringElement(LIST_ITEM, oCzar);

      int nSellPrice;
      int nSold;
      int nRace;
      int nClass;

      int nMaxQty;
      int nCurQty;
      int nBoughtQty;

      SQLExecStatement("SELECT race,class FROM micz_nations WHERE id=?", sNationID);
      if(SQLFetch())
      {
        nRace = StringToInt(SQLGetData(1));
        nRace = _CheckRace(nRace, oPC);


        nClass = StringToInt(SQLGetData(2));
        nClass = _CheckClass(nClass, oPC);

      }


      int nNationMatch = GetLocalString(oPC, VAR_NATION) == sNationID;
      int nTrade = miCZGetCanTrade(oPC, sNationID);
      string sRec2;
      string sName;
      while(sElement != "")
      {

        SQLExecStatement("SELECT buy,rbuy,cbuy,tbuy,rcbuy,rtbuy,w.QTY,clbuy,rclbuy,cclbuy,crclbuy,c.name FROM mdcz_wh AS w LEFT JOIN md_cr_input AS c ON w.resref=c.resref WHERE w.resref=? AND nation=? LIMIT 1", sElement, sNationID);

        if(SQLFetch())
        {
            nCurQty = StringToInt(SQLGetData(7));
            nMaxQty = _GetMaxQty(sElement);
            nQty = GetLocalInt(oCzar, sElement);
            sName = SQLGetData(12);
            DeleteLocalInt(oCzar, sElement);
            if(nMaxQty > nCurQty)
            {

                if(nMaxQty < nQty + nCurQty)
                    nQty = nMaxQty - nCurQty;
                Log(TC_LOG, GetName(oPC) +  " , " + GetPCPublicCDKey(oPC) + " , " +  GetPCIPAddress(oPC) + " , " + IntToString(nQty) + " , " + sElement);
                if(sPage == PAGE_SELL)
                {
                    nSellPrice = _BestSellPrice(SQLGetData(1), SQLGetData(2), SQLGetData(3), SQLGetData(4), SQLGetData(5), SQLGetData(6), SQLGetData(8), SQLGetData(9), SQLGetData(10), SQLGetData(11), nNationMatch, nRace, nClass, nTrade);
                    if(nSellPrice < 0) //sanity check
                        nSellPrice = 0;


                    if(gsFIGetAccountBalance("N" + sNationID) < (nSold + 10000 + nQty * nSellPrice))
                    {
                        SendMessageToPC(oPC, "This settlement can't afford to buy all that.");
                        break;
                    }
                    nSold += nQty * nSellPrice;
                }

                sRec2 += sName+": " + IntToString(nQty)+"\n";
                SQLExecStatement("UPDATE mdcz_wh SET QTY=QTY+? WHERE resref=? AND nation=?", IntToString(nQty), sElement, sNationID);

                oItem = GetFirstItemInInventory(oChest);
                while(GetIsObjectValid(oItem))
                {
                    if(sElement == GetResRef(oItem))
                    {
                        nQty = gsCMReduceItem(oItem, nQty);
                    }

                    oItem = GetNextItemInInventory(oChest);
                }
            }
        }

        sElement = GetNextStringElement();
      }

      while(sElement != "") //get the rest of the variables
      {
        DeleteLocalInt(oCzar, sElement);
        sElement = GetNextStringElement();
      }

      DeleteList(LIST_ITEM);


      if(nSold)
      {
        gsFITransferFromTo("N" + sNationID, "DUMMY", nSold);
        GiveGoldToCreature(oPC, nSold);
      }
      string sRec;
      if(nFoodV > 0)
      {
        sRec += "\n " + IntToString(nFoodV) + " units of food" +
            (sPage == PAGE_DONATE ? ".":" for " + IntToString(nFoodP)+".");
      }
      if(nStoneV > 0)
      {
        sRec += "\n " + IntToString(nStoneV) + " units of stone" +
            (sPage == PAGE_DONATE ? ".":" for " + IntToString(nStoneP)+".");
      }
      if(nWoodV > 0)
      {
        sRec += "\n " + IntToString(nWoodV) + " units of wood" +
            (sPage == PAGE_DONATE ? ".":" for " + IntToString(nWoodP)+".");
      }
      if(nClothV > 0)
      {
        sRec += "\n " + IntToString(nClothV) + " units of cloth" +
            (sPage == PAGE_DONATE ? ".":" for " + IntToString(nClothP)+".");
      }
      if(nMetalV > 0)
      {
        sRec += "\n " + IntToString(nMetalV) + " units of metal" +
            (sPage == PAGE_DONATE ? ".":" for " + IntToString(nMetalP)+".");
      }

      if(sRec != "" || sRec2 != "")
      {
        string sMessageID = gsCMCreateRandomID();
        object oObject    = CreateItemOnObject("gs_me_md_",
                                               GetPcDlgSpeaker(),
                                               1,
                                               "GS_ME_MD_" + sMessageID);

        sRec = fbNAGetGlobalDynamicName(oPC) + " has " + (sPage == PAGE_DONATE ?
         "donated":"sold") + " the following:\n" + sRec;
        if (GetIsObjectValid(oObject))
        {
          string sDoubleQuote = GetLocalString(GetModule(), "GS_DOUBLE_QUOTE");

          SetName(oObject, sDoubleQuote + "Resource Receipt ("+miCZGetName(sNationID)+")" + sDoubleQuote);
          gsMEForgeMessage(sMessageID, "Resource Receipt ("+miCZGetName(sNationID)+")", sRec, sRec2, "", "", GetName(oCzar) + " of " + miCZGetName(sNationID), "The Real Deal");
          SetDescription(oObject, sRec+"\n"+sRec2);
        }
      }
    }
    else
    {
      SendMessageToPC(oPC, "Module badly configured, please report!");
    }

    EndDlg();
  }
  else if (sPage == PAGE_PRICE)
  {
    float fPrice = GetLocalFloat(OBJECT_SELF, VAR_DLG_PRICE);

    switch (selection)
    {
      case 0:
        fPrice -= 0.5;
        break;
      case 1:
        fPrice -= 0.1;
        break;
      case 2:
        fPrice -= 0.05;
        break;
      case 3:
        fPrice -= 0.01;
        break;
      case 4:
        fPrice += 0.01;
        break;
      case 5:
        fPrice += 0.05;
        break;
      case 6:
        fPrice += 0.1;
        break;
      case 7:
        fPrice += 0.5;
        break;
      case 8:
        SetDlgPageString(GetLocalString(OBJECT_SELF, VAR_DLG_NEXTPAGE));
        break;
      case 9:
        SetDlgPageString(PAGE_RESOURCE);
        break;
    }

    if (fPrice < 0.0) fPrice = 0.0;
    else if (fPrice > 9.99) fPrice = 9.99;
    SetLocalFloat(OBJECT_SELF, VAR_DLG_PRICE, fPrice);
  }
  else if (sPage == PAGE_RESOURCE || sPage == PAGE_BUY)
  {
    string sNextPage = (sPage == PAGE_RESOURCE) ? PAGE_PRICE : PAGE_BUY_RESOURCE;
    SetDlgPageString(sNextPage);

    switch (selection)
    {
      case 0:
        SetLocalString(OBJECT_SELF, VAR_DLG_RESOURCE, "Food");
        break;
      case 1:
        SetLocalString(OBJECT_SELF, VAR_DLG_RESOURCE, "Wood");
        break;
      case 2:
        SetLocalString(OBJECT_SELF, VAR_DLG_RESOURCE, "Cloth");
        break;
      case 3:
        SetLocalString(OBJECT_SELF, VAR_DLG_RESOURCE, "Metal");
        break;
      case 4:
        SetLocalString(OBJECT_SELF, VAR_DLG_RESOURCE, "Stone");
        break;
      case 5:
        SetDlgPageString("");
        break;
    }
  }
  else if (sPage == PAGE_BUY_RESOURCE)
  {
    if (selection == 1)
    {
      SetDlgPageString(PAGE_BUY);
    }
    else
    {
      string sResource = GetLocalString(OBJECT_SELF, VAR_DLG_RESOURCE);
      float fPrice = miCZGetSettlementSellPrice(sNationID, GetStringUpperCase(sResource));
      int nAmount = StringToInt(gsLIGetLastMessage(oPC));

      if (nAmount == 0)
      {
        SendMessageToPC(oPC, "That wasn't a valid number.");
        return;
      }

      if (nAmount > 1000)
      {
        // DMs don't have a maximum
        if ( !(GetIsDM(oPC) || GetIsDMPossessed(oPC)) ) {
          SendMessageToPC(oPC, "You can only buy 1000 units at a time.");
          nAmount = 1000;
        }
      }

      int nPrice = FloatToInt(IntToFloat(nAmount) * fPrice);
      // Check PC has enough gold.

      if (GetGold(oPC) < nPrice)
      {
        SendMessageToPC(oPC, "You don't have enough gold!");
        // break... will leave PC on the enter amount page.
        return;
      }

      // Check settlement can give up this much stuff.
      struct Service YearlyCost = mdCZYearlyResourceCost(sNationID);
      int nYCost;
      sResource = GetStringUpperCase(sResource);
      if(sResource ==  RESOURCE_CLOTH)
        nYCost == YearlyCost.nCloth;
      else if(sResource == RESOURCE_FOOD)
        nYCost == YearlyCost.nFood;
      else if(sResource == RESOURCE_METAL)
        nYCost == YearlyCost.nMetal;
      else if(sResource == RESOURCE_STONE)
        nYCost == YearlyCost.nStone;
      else if(sResource == RESOURCE_WOOD)
        nYCost == YearlyCost.nWood;
      int nStockpile = miCZGetSettlementStockpile(sNationID, sResource);
      if (nStockpile - nAmount < (nYCost))
      {
        SendMessageToPC(oPC, "I can't sell you that much, or it would eat into my reserves.");
        return;
      }

      object oBundle = CreateItemOnObject("mi_resource_bund", oPC);
      SetLocalString(oBundle, "RESOURCE", GetStringUpperCase(sResource));
      SetLocalInt(oBundle, "VALUE", nAmount);
      SetName(oBundle, "Resource Bundle (" + sResource + ")");
      int nWeight = nAmount;

      while (nWeight > 0)
      {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS), oBundle);
        nWeight -= 100;
      }

      if (nPrice > 0) gsFIPayIn(oPC, nPrice, "N" + sNationID);

      miCZAddtoStockpile(sNationID, GetStringUpperCase(sResource), -1 * nAmount);
    }
  }
  else if (sPage == PAGE_SETBUY || sPage == PAGE_SETSELL)
  {
    switch (selection)
    {
      case 0: // confirmed
      {
        if(md_GetHasWrit(oPC, md_GetDatabaseID(miCZGetName(sNationID)), MD_PR2_RSB, "2") == 3)
        {
          object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
          if (GetIsObjectValid(oWrit)) gsCMReduceItem(oWrit);
        }
        float fPrice = GetLocalFloat(OBJECT_SELF, VAR_DLG_PRICE);
        string sResource = GetLocalString(OBJECT_SELF, VAR_DLG_RESOURCE);

        if (sPage == PAGE_SETBUY)
        {
          SetLocalFloat(oNation, VAR_BUYPRICE + GetStringUpperCase(sResource), fPrice);
          miDASetKeyedValue("micz_nations", sNationID, GetStringLowerCase(sResource)
            + "buyprice", FloatToString(fPrice));
        }
        else
        {
          SetLocalFloat(oNation, VAR_SELLPRICE + GetStringUpperCase(sResource), fPrice);
          miDASetKeyedValue("micz_nations", sNationID, GetStringLowerCase(sResource)
            + "sellprice", FloatToString(fPrice));
        }

        SendMessageToPC(oPC, "Price change saved.");
        SetDlgPageString("");

        break;
      }
      case 1: // cancel
        SetDlgPageString("");
        break;
    }
  }
  else if(sPage == PAGE_EXP)
  {
      string sSelName = GetStringElement(selection, PAGE_EXP);

      if(sSelName == sRace)
      {
        int nRace = GetLocalInt(oCzar, VAR_RACE_BIT);
        if(nRace != 0)
            SetLocalInt(oCzar, VAR_BIT, nRace);
        else
        {
            nRace = StringToInt(miDAGetKeyedValue("micz_nations", sNationID, "race"));
            SetLocalInt(oCzar, VAR_BIT, nRace);
            SetLocalInt(oCzar, VAR_RACE_BIT, nRace);
        }
        SetDlgPageString(PAGE_RACE);
      }
      else if(sSelName == sClass)
      {
        int nClass = GetLocalInt(oCzar, VAR_CLASS_BIT);
        if(nClass != 0)
            SetLocalInt(oCzar, VAR_BIT, nClass);
        else
        {
            nClass = StringToInt(miDAGetKeyedValue("micz_nations", sNationID, "class"));
            SetLocalInt(oCzar, VAR_BIT, nClass);
            SetLocalInt(oCzar, VAR_CLASS_BIT, nClass);
        }
        SetDlgPageString(PAGE_CLASS);
      }
      else if(sSelName == sSet)
        SetDlgPageString(PAGE_SET);
      else if(sSelName == sPurchase)
        SetDlgPageString(PAGE_CAT_PUR);
      else if(sSelName == sDisplay)
        SetDlgPageString(PAGE_DISPLAY);
      else if(sSelName == sStartService)
      {
        SetDlgPageInt(1);

        SetDlgPageString(PAGE_CONFIRM);


      }
      else if(sSelName == sEndService)
      {
        SetDlgPageInt(0);
        SetDlgPageString(PAGE_CONFIRM);
        //int nService = StringToInt(miDAGetKeyedValue("micz_nations", sNationID, "services")) & ~MD_SV_EXPWH;

      }
      else if(sSelName == STO_DEP)
        SetDlgPageString(PAGE_STOCK);


  }
  else if(sPage == PAGE_CONFIRM)
  {
    if(selection == 0)
    {
        if(GetDlgPageInt())
        {

            string sPrepare = SQLPrepareStatement("(?,?)", "gs_item451", sNationID); //coal
            sPrepare += SQLPrepareStatement(",(?,?)", "gs_item458", sNationID);  // clay
            sPrepare += SQLPrepareStatement(",('gs_item722', ?)", sNationID);  // salt
            sPrepare += SQLPrepareStatement(",('gs_item302', ?)", sNationID);  // sand
            // (sResRef == "gs_item462") ||  // adamantine
             //(sResRef == "gs_item1000") || // arjale
             sPrepare += SQLPrepareStatement(",('gs_item457', ?)", sNationID);  // copper
       // sPrepare += SQLPrepareStatement("('gs_item461', ?)", sNationID);  // gold
            sPrepare += SQLPrepareStatement(",('gs_item452', ?)", sNationID);  // iron
            sPrepare += SQLPrepareStatement(",('gs_item459', ?)", sNationID);  // lead
             //sPrepare += SQLPrepareStatement("("gs_item921") ||  // mithril
            sPrepare += SQLPrepareStatement(",('gs_item460', ?)", sNationID);  // silver
            sPrepare += SQLPrepareStatement(",('gs_item496', ?)", sNationID);  // tin
            sPrepare += SQLPrepareStatement(",('gs_item497', ?)", sNationID);  // zinc
            sPrepare += SQLPrepareStatement(",('gs_item453', ?)", sNationID);  // alexandrite
            sPrepare += SQLPrepareStatement(",('gs_item454', ?)", sNationID);  // amethyst
            sPrepare += SQLPrepareStatement(",('gs_item455', ?)", sNationID);  // adventurine
             //(sResRef == "gs_item456") ||  // diamond
            // (sResRef == "gs_item479") ||  // emerald
            sPrepare += SQLPrepareStatement(",('gs_item471', ?)", sNationID);  // fire agate
            sPrepare += SQLPrepareStatement(",('gs_item472', ?)", sNationID);  // fire opal
            sPrepare += SQLPrepareStatement(",('gs_item470', ?)", sNationID);  // fluorspar
            sPrepare += SQLPrepareStatement(",('gs_item473', ?)", sNationID);  // garnet
            sPrepare += SQLPrepareStatement(",('gs_item474', ?)", sNationID);  // greenstone
            sPrepare += SQLPrepareStatement(",('gs_item475', ?)", sNationID);  // malachite
            sPrepare += SQLPrepareStatement(",('gs_item476', ?)", sNationID);  // phenalope
           //  (sResRef == "gs_item477") ||  // ruby
            sPrepare += SQLPrepareStatement(",('gs_item478', ?)", sNationID);  // sapphire
            sPrepare += SQLPrepareStatement(",('gs_item480', ?)", sNationID);     // topaz
            sPrepare += SQLPrepareStatement(",('ar_it_lunker001', ?)", sNationID); //scarfinned flatfish
            sPrepare += SQLPrepareStatement(",('sweetberry002', ?)", sNationID);  //sweetberry
            sPrepare += SQLPrepareStatement(",('nw_it_msmlmisc20', ?)", sNationID); //fish

            sPrepare += SQLPrepareStatement(",('ar_it_herb005', ?)", sNationID);  //lady's tear
            sPrepare += SQLPrepareStatement(",('ar_it_herb002', ?)", sNationID); //mintspear
            sPrepare += SQLPrepareStatement(",('gs_item824', ?)", sNationID); //magic blood
            sPrepare += SQLPrepareStatement(",('gs_item905', ?)", sNationID); //cotton
            sPrepare += SQLPrepareStatement(",('gs_item336', ?)", sNationID); //spider silk
            sPrepare += SQLPrepareStatement(",('gs_item854', ?)", sNationID);  // large hide
            sPrepare += SQLPrepareStatement(",('gs_item896', ?)", sNationID);  // medium hide
            sPrepare += SQLPrepareStatement(",('gs_item895', ?)", sNationID);  // small hide
            sPrepare += SQLPrepareStatement(",('gs_item897', ?)", sNationID); // big meat
            sPrepare += SQLPrepareStatement(",('gs_item898', ?)", sNationID);  // medium meat
            sPrepare += SQLPrepareStatement(",('gs_item899', ?)", sNationID);     // small meat
            sPrepare += SQLPrepareStatement(",('gs_item385', ?)", sNationID);  // granite
            sPrepare += SQLPrepareStatement(",('gs_item381', ?)", sNationID);  // marble
            sPrepare += SQLPrepareStatement(",('gs_item901', ?)", sNationID);  // softwood
            sPrepare += SQLPrepareStatement(",('gs_item900', ?)", sNationID);  // hardwood
            sPrepare += SQLPrepareStatement(",('gs_item304', ?)", sNationID);//nuts
            sPrepare += SQLPrepareStatement(",('gs_item253', ?)", sNationID);//berries
            sPrepare += SQLPrepareStatement(",('gs_item856', ?)", sNationID);  //fruit
            sPrepare += SQLPrepareStatement(",('gs_item335', ?)", sNationID); //animal sinew
            sPrepare += SQLPrepareStatement(",('ir_yarrowleaves', ?)", sNationID); //yarrow
            sPrepare += SQLPrepareStatement(",('ir_healingdraugh', ?)", sNationID); //healing draught
            sPrepare += SQLPrepareStatement(",('rations', ?)", sNationID); //weak meal
            sPrepare += SQLPrepareStatement(",('rations001', ?)", sNationID); //average meal
            sPrepare += SQLPrepareStatement(",('ar_it_miscband', ?)", sNationID); //bandage roll
          SQLExecStatement("INSERT INTO mdcz_wh (resref, nation) " +
            "VALUES " + sPrepare);

             if(EnableService(MD_SV_EXPWH, sNationID, oPC))
                DeleteList(PAGE_EXP);
             else
                EndDlg();

        }
        else
            SQLExecStatement("UPDATE micz_nations SET services = services & ~? WHERE id=?", IntToString(MD_SV_EXPWH), sNationID);
    }

    SetDlgPageString(PAGE_EXP);
  }
  else if(sPage == PAGE_SET)
  {
    if(_Back(sPage, selection))
        return;
    else if(selection == 0)
        SetLocalInt(oCzar, VAR_BIT, TRUE);
    else if(selection == 1)
        DeleteLocalInt(oCzar, VAR_BIT);
    else
    {
        string sPrepare;
        sPrepare += SQLPrepareStatement("('ir_yarrowleaves', ?)", sNationID); //yarrow
        sPrepare += SQLPrepareStatement(",('ir_healingdraugh', ?)", sNationID); //healing draught
        sPrepare += SQLPrepareStatement(",('rations', ?)", sNationID); //weak meal
        sPrepare += SQLPrepareStatement(",('rations001', ?)", sNationID); //average meal
        sPrepare += SQLPrepareStatement(",('ar_it_miscband', ?)", sNationID); //bandage roll
        SQLExecStatement("INSERT INTO mdcz_wh (resref, nation) " +
            "VALUES " + sPrepare);
        DeleteList(PAGE_SET);
        return;
    }


    SetDlgPageString(PAGE_ESET);
  }
  else if(sPage == PAGE_STOCK)
  {
      if(_Back(sPage, selection))
        return;
      SetDlgPageInt(selection);
      SetDlgPageString(PAGE_STOITM);
  }
  else if(sPage == PAGE_STOITM)
  {
    if(_Back(sPage, selection))
        return;
    SetLocalString(oCzar, VAR_ITEM, GetStringElement(selection, RESREF_MENU));
    SetDlgPageString(PAGE_MVITM);
  }
  else if(sPage == PAGE_MVITM)
  {
    if(_Back(sPage, selection))
        return;
    int nSel = GetDlgPageInt();
    string sResource;
    if(nSel == 0)
        sResource = RESOURCE_FOOD;
    else if(nSel == 1)
        sResource = RESOURCE_WOOD;
    else if(nSel == 2)
        sResource = RESOURCE_CLOTH;
    else if(nSel == 3)
        sResource = RESOURCE_METAL;
    else if(nSel == 4)
        sResource = RESOURCE_STONE;

    object oChest = GetObjectByTag(VAR_RESOURCE_INV+sResource);
    string sItem = GetLocalString(oCzar, VAR_ITEM);

    object oItem = _ItemByResref(sItem, oChest);

    if(!GetIsObjectValid(oItem)) return;
    selection++;

    int nValue = GetGoldPieceValue(oItem) * selection;
    miCZAddtoStockpile(sNationID, sResource, nValue);
    SQLExecStatement("UPDATE mdcz_wh SET QTY=QTY-? WHERE resref=? AND nation=?", IntToString(selection), sItem, sNationID);

  }
  else if(sPage == PAGE_ESET)
  {
    if(_Back(sPage, selection))
        return;
    SetDlgPageInt(selection);
    SetDlgPageString(PAGE_SSEL);
  }
  else if(sPage == PAGE_SSEL || sPage == PAGE_ITM)
  {
    if(_Back(sPage, selection))
        return;
    float fAmt;
    int nSub;
    string sUpdate;
    int nVar = GetLocalInt(oCzar, VAR_BIT);
    int nAdjust;
    switch(selection)
    {
    case 0: nAdjust = 1;
    case 1:
    {
        string sMsg = chatGetLastMessage(oPC);
        nSub = FindSubString(sMsg, "\-");
        if(nSub == 1)
            sMsg = GetStringRight(sMsg, GetStringLength(sMsg)-1);


        nSub = FindSubString(sMsg, "%");
        if(nSub != -1)
        {
            if(nSub == 0)
                sMsg = GetStringRight(sMsg, GetStringLength(sMsg)-1);
            else
                sMsg = GetStringLeft(sMsg, GetStringLength(sMsg)-1);
        }
        fAmt = StringToFloat(sMsg);

        if(nSub != -1)
        {
            if(selection == 0)
                fAmt += 100;

            fAmt /= 100;
            if(fAmt < 0.0)
                fAmt *= -1.0;

        }
        break;
     }
     case 2:
        if(!nVar)
        {
            fAmt = (fTax + miCZGetTaxRate(sNationID) + 1.0);
            nSub = 0;
            nAdjust = 1;
            break;
        }
        else
        {
            if(md_GetHasWrit(oPC, md_GetDatabaseID(miCZGetName(sNationID)), MD_PR2_RSB, "2") == 3)
            {
                object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
                if (GetIsObjectValid(oWrit)) gsCMReduceItem(oWrit);
            }

            _ComputePrice(RESOURCE_FOOD, "gs_item897", sNationID);
            _ComputePrice(RESOURCE_FOOD, "gs_item898", sNationID);
            _ComputePrice(RESOURCE_FOOD, "gs_item304", sNationID);
            _ComputePrice(RESOURCE_FOOD, "gs_item899", sNationID);
            _ComputePrice(RESOURCE_FOOD, "gs_item253", sNationID);
            _ComputePrice(RESOURCE_FOOD, "gs_item856", sNationID);
            _ComputePrice(RESOURCE_FOOD, "sweetberry002", sNationID);
            _ComputePrice(RESOURCE_STONE, "gs_item385", sNationID);
            _ComputePrice(RESOURCE_STONE, "gs_item381", sNationID);
            _ComputePrice(RESOURCE_WOOD, "gs_item901", sNationID);
            _ComputePrice(RESOURCE_WOOD, "gs_item900", sNationID);
            _ComputePrice(RESOURCE_CLOTH, "gs_item854", sNationID);
            _ComputePrice(RESOURCE_CLOTH, "gs_item896", sNationID);
            _ComputePrice(RESOURCE_CLOTH, "gs_item895", sNationID);

            return;
        }
     case 3:
        if(!nVar)
        {
            fAmt = (fTax + miCZGetTaxRate(sNationID) + 1.0);
            nSub = -3;
            nAdjust = 1;
            break;
        }
        else
        {
            SetDlgPageString(PAGE_COPY);
            return;
        }
     case 4:
        if(!nVar)
            SetDlgPageString(PAGE_COPY);
        else
            SetDlgPageString(PAGE_CAT_PRI);
        return;
     case 5:
        SetDlgPageString(PAGE_CAT_PRI);
        return;
     }

     if(selection <=3)
     {

       if(md_GetHasWrit(oPC, md_GetDatabaseID(miCZGetName(sNationID)), MD_PR2_RSB, "2") == 3)
       {
            object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
            if (GetIsObjectValid(oWrit)) gsCMReduceItem(oWrit);

       }
       sUpdate = _Update(nVar, fAmt, nSub, nAdjust);

       string sResref = GetLocalString(oCzar, VAR_ITEM);
       if(sResref == "")
            SQLExecStatement("UPDATE mdcz_wh SET " + sUpdate + " WHERE nation=?", sNationID);
       else
            SQLExecStatement("UPDATE mdcz_wh SET " + sUpdate + " WHERE nation=? AND resref=?", sNationID, sResref);
     }

  }
  else if(sPage == PAGE_INDITM)
  {
    if(_Back(sPage, selection))
        return;
    SetLocalString(oCzar, VAR_ITEM, GetStringElement(selection, RESREF_MENU));
    SetDlgPageString(PAGE_ITM);

  }
  else if(sPage == PAGE_PURCHASE)
  {
    if(_Back(sPage, selection))
        return;
    SetLocalString(oCzar, VAR_ITEM, GetStringElement(selection, RESREF_MENU));
    SetDlgPageString(PAGE_PURITM);

  }
  else if(sPage == PAGE_PURITM)
  {
    if(_Back(sPage, selection))
        return;
    selection++;
    int nPrice = GetLocalInt(oCzar, VAR_PRICE);

    if(!(md_GetHasPowerSettlement(MD_PR2_RSB, oPC, md_GetDatabaseID(miCZGetName(sNationID)), "2") || nPrice <= 0))
    {
        int nGold = GetGold(oPC);
        nPrice *= selection;
        int nTax = FloatToInt(IntToFloat(nPrice) * (fTax + miCZGetTaxRate(sNationID)));
        if(nGold >= (nPrice + nTax))
        {
            gsFIPayIn(oPC, nPrice, "N"+sNationID);
            TakeGoldFromCreature(nTax, oPC, TRUE);
        }
        else
        {
            SendMessageToPC(oPC, "You do not have enough gold.");
            return; //doesn't have gold to pay
        }
    }
    string sItem = GetLocalString(oCzar, VAR_ITEM);
    Log(TC_LOG, GetName(oPC) +  " , " + GetPCPublicCDKey(oPC) + " , " +  GetPCIPAddress(oPC) + " , " + IntToString(selection) + " , " + sItem);
    SQLExecStatement("UPDATE mdcz_wh SET QTY=QTY-? WHERE resref=? AND nation=?", IntToString(selection), sItem, sNationID);
    _CreateItem(sItem, selection, oPC);
  }
  else if(sPage == PAGE_COPY)
  {
    if(_Back(sPage, selection))
        return;
    string sSel = GetStringElement(selection, PAGE_COPY);
    string sAdjust;
    int nVar = GetLocalInt(oCzar, VAR_BIT);
    if(sSel == COPY_BASE)
        sAdjust = _ParseSQLCol(nVar, "");
    else if(sSel == COPY_CITIZEN)
        sAdjust = _ParseSQLCol(nVar, "c");
    else if(sSel == COPY_CLASS)
        sAdjust = _ParseSQLCol(nVar, "cl");
    else if(sSel == COPY_CCLASS)
        sAdjust = _ParseSQLCol(nVar, "ccl");
    else if(sSel == COPY_RACE)
        sAdjust = _ParseSQLCol(nVar, "r");
    else if(sSel == COPY_CRACE)
        sAdjust = _ParseSQLCol(nVar, "rc");
    else if(sSel == COPY_CLRACE)
        sAdjust = _ParseSQLCol(nVar, "rcl");
    else if(sSel == COPY_CCLRACE)
        sAdjust = _ParseSQLCol(nVar, "crcl");
    else if(sSel == COPY_TRADE)
        sAdjust = _ParseSQLCol(nVar, "t");
    else if(sSel == COPY_RTRADE)
        sAdjust = _ParseSQLCol(nVar, "rt");


    string sMsg = chatGetLastMessage(oPC);
    int nSub = FindSubString(sMsg, "\-");
    if(nSub == 1)
        sMsg = GetStringRight(sMsg, GetStringLength(sMsg)-1);


    nSub = FindSubString(sMsg, "%");
    if(nSub != -1)
    {
        if(nSub == 0)
            sMsg = GetStringRight(sMsg, GetStringLength(sMsg)-1);
        else
            sMsg = GetStringLeft(sMsg, GetStringLength(sMsg)-1);
    }
    float fAmt = StringToFloat(sMsg);

    if(nSub != -1)
    {
        fAmt += 100;
        fAmt /= 100;
        if(fAmt < 0.0)
            fAmt *= -1.0;
    }

    string sUpdate = _Update(nVar, fAmt, nSub,1, sAdjust);
    if(md_GetHasWrit(oPC, md_GetDatabaseID(miCZGetName(sNationID)), MD_PR2_RSB, "2") == 3)
    {
            object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
            if (GetIsObjectValid(oWrit)) gsCMReduceItem(oWrit);

    }
    string sResref = GetLocalString(oCzar, VAR_ITEM);
    if(sResref == "")
        SQLExecStatement("UPDATE mdcz_wh SET " + sUpdate + " WHERE nation=?", sNationID);
    else
        SQLExecStatement("UPDATE mdcz_wh SET " + sUpdate + " WHERE nation=? AND resref=?", sNationID, sResref);
  }
  else if(sPage == PAGE_RACE)
  {

        if(_Back(sPage, selection))
            return;
        int nBit;
        int nWrit = md_GetHasWrit(oPC, md_GetDatabaseID(miCZGetName(sNationID)), 0);
        if(!nWrit)
        {
            SendMessageToPC(oPC, "You don't possess a signed writ. You may only view.");
            return;
        }
        else if(selection == 33) //confirm
        {
            object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
            if (GetIsObjectValid(oWrit)) gsCMReduceItem(oWrit);
            nBit = GetLocalInt(oCzar, VAR_BIT);
            miDASetKeyedValue("micz_nations", sNationID, "race", IntToString(nBit));
            SetLocalInt(oCzar, VAR_RACE_BIT, nBit);
            return;
        }
        else
            nBit = md_GetRaceSelection(selection);


        string sVar;
        if(nWrit == 3)
            sVar == VAR_BIT;
        else
            sVar = VAR_RACE_BIT;
        int nNewBit = GetLocalInt(oCzar, sVar);

        if((nNewBit & nBit) == nBit)
            nNewBit &= ~nBit;
        else
            nNewBit |= nBit;

        SetLocalInt(oCzar, sVar, nNewBit);
        DeleteList(PAGE_RACE);
        if(sVar == VAR_RACE_BIT)
        {
            miDASetKeyedValue("micz_nations", sNationID, "race", IntToString(nNewBit));
            SetLocalInt(oCzar, VAR_BIT, nNewBit);
        }
  }
  else if(sPage == PAGE_CLASS)
  {
        if(_Back(sPage, selection))
            return;
        int nBit;
        int nWrit = md_GetHasWrit(oPC, md_GetDatabaseID(miCZGetName(sNationID)), 0);

        if(!nWrit)
        {
            SendMessageToPC(oPC, "You don't possess a signed writ. You may only view.");
            return;
        }
        else if(selection == 28) //confirm
        {
            object oWrit = GetItemPossessedBy(oPC, "micz_writ_sgn");
            if (GetIsObjectValid(oWrit)) gsCMReduceItem(oWrit);
            nBit = GetLocalInt(oCzar, VAR_BIT);
            miDASetKeyedValue("micz_nations", sNationID, "class", IntToString(nBit));
            SetLocalInt(oCzar, VAR_CLASS_BIT, nBit);
            return;
        }
        else
            nBit = md_GetClassSelection(selection);


        string sVar;
        if(nWrit == 3)
            sVar == VAR_BIT;
        else
            sVar = VAR_CLASS_BIT;
        int nNewBit = GetLocalInt(oCzar, sVar);

        if((nNewBit & nBit) == nBit)
            nNewBit &= ~nBit;
        else
            nNewBit |= nBit;

        SetLocalInt(oCzar, sVar, nNewBit);
        DeleteList(PAGE_CLASS);
        if(sVar == VAR_CLASS_BIT)
        {
            miDASetKeyedValue("micz_nations", sNationID, "class", IntToString(nNewBit));
            SetLocalInt(oCzar, VAR_BIT, nNewBit);
        }

  }
  else if(sPage ==  PAGE_CAT_PRI)
  {
    if(_Back(sPage, selection))
            return;
    SetLocalInt(oCzar, VAR_CAT_SELECTION, selection);
    SetDlgPageString(PAGE_INDITM);
  }
  else if(sPage == PAGE_CAT_PUR)
  {
    if(_Back(sPage, selection))
            return;
    SetLocalInt(oCzar, VAR_CAT_SELECTION, selection);
    SetDlgPageString(PAGE_PURCHASE);
  }
  else if(sPage == PAGE_DISPLAY)
  {
    if(_Back(sPage, selection))
        return;
    SetLocalInt(oCzar, VAR_CAT_SELECTION, selection);
  }
  else
  {
    SendMessageToPC(oPC, "You've found a bug.  Please report it on the forums!");
  }
}

void CleanUp()
{
    DeleteList(PAGE_EXP);
    DeleteLocalInt(OBJECT_SELF, VAR_BIT);
    DeleteLocalInt(OBJECT_SELF, VAR_CAT_SELECTION);
}
void main()
{
  // Never (ever ever) change this method. Got that? Good.
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Running zdlg_tradeczar script");
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
      CleanUp();
      break;
  }
}
