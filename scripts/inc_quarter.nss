/* QUARTER library by Gigaschatten */
/* Expanded and rewritten by Mithreas; see zdlg_quarter for design */

#include "inc_database"
#include "inc_finance"
#include "inc_message"
#include "inc_pc"
#include "inc_subrace"
#include "inc_time"
#include "inc_factions"

/*
  DB table

  CREATE TABLE gs_quarter (
    row_key       VARCHAR(32),           [PK GS_CLASS + GS_INSTANCE]
    owner         INT(11) DEFAULT NULL,  [FK:gs_pc_data.id DEFAULT NULL]
    name          TEXT,                  [player-chosen name of quarter]
    public        TINYINT(1),
    lock_dc       TINYINT(3) DEFAULT 40,
    lock_strength TINYINT(3) DEFAULT 22,
    trap_dc       TINYINT(3) DEFAULT 20,
    trap_strength TINYINT(3) DEFAULT 0,
    for_sale      TINYINT(1),
    sale_price    INT(7),
    resource      INT(7),
    last_used     INT(8),
    last_tax      INT(8),
    uid           VARCHAR(32),
    messages      TEXT,
    timeout       INT(8),
    PRIMARY KEY (row_key),
    deity         VARCHAR(32)
    );

*/

const string GS_QU_TEMPLATE_KEY = "gs_item038";
const string QUARTER            = "QUARTER"; // for logging

const string VAR_NOBLE_ESTATE = "noble_estate";
//void main() {}

// Load this quarter's information from the database.  Does nothing if already
// loaded. Returns the cache object.
object gsQULoad(object oQuarter);
// Returns the current tax rate for oQuarter.
int gsQUGetTaxAmount(object oQuarter);
// Pay tax, if tax is due.  Does nothing if tax is not due.
// If tax is due and the owner cannot afford it, quarter will go up for sale.
void gsQUPayTax(object oQuarter);
//return TRUE if oPC is owner of oQuarter
int gsQUGetIsOwner(object oQuarter, object oPC);
//return owner id of oQuarter
string gsQUGetOwnerID(object oQuarter);
//make oPC own oQuarter
void gsQUSetOwner(object oQuarter, object oPC, int nTimeout = 0);
//return owner name of oQuarter
string gsQUGetOwnerName(object oQuarter);
//update timestamp of oQuarter
void gsQUTouch(object oQuarter);
//updates timestamp of oQuarter and informs oPC
void gsQUTouchWithNotification(object oQuarter, object oPC);
//return TRUE if oQuarter is vacant
int gsQUGetIsVacant(object oQuarter);
//return TRUE if oQuarter is available
int gsQUGetIsAvailable(object oQuarter);
//abandon oQuarter
void gsQUAbandon(object oQuarter);
//return key tag of oQuarter
string gsQUGetKeyTag(object oQuarter);
//create access key for oQuarter on oTarget
void gsQUCreateKey(object oQuarter, object oTarget);
//is this quarter open to the general public
int gsQUGetIsPublic(object oQuarter);
//make this quarter open to the general public or not
void gsQUSetIsPublic(object oQuarter, int bPublic);
//is this quarter for sale?
int gsQUGetIsForSale(object oQuarter);
//make this quarter for sale or not
void gsQUSetIsForSale(object oQuarter, int bForSale);
//get the strength of the lock (DC for forcing)
int gsQUGetLockStrength(object oQuarter);
//set the strength of the lock (DC for forcing)
void gsQUSetLockStrength(object oQuarter, int nStrength);
//get the DC of the lock
int gsQUGetLockDC(object oQuarter);
//set the DC of the lock
void gsQUSetLockDC(object oQuarter, int nDC);
//get the strength of the trap (# of d6 damage)
int gsQUGetTrapStrength(object oQuarter);
//set the strength of the trap (# of d6 damage)
void gsQUSetTrapStrength(object oQuarter, int nStrength);
//get the DC of the trap (search and disable)
int gsQUGetTrapDC(object oQuarter);
//set the DC of the trap (search and disable)
void gsQUSetTrapDC(object oQuarter, int nDC);
//resets a quarter for a new owner
void gsQUReset(object oQuarter);
//set the name of oQuarter to sName
void gsQUSetName(object oQuarter, string sName);
//post sMessageID in oQuarter
void gsQUPostMessage(object oQuarter, string sMessageID);
//retrieve all messages in oQuarter and deliver to oRecipient
void gsQURetrieveMessages(object oQuarter, object oRecipient);
//open the quarter door for oOpener, delivering the mail.
void gsQUOpen(object oQuarter, object oOpener);
//Resets the faction associated with oQuarter to default values (deletes), works for shops
void QUResetFaction(object oQuarter);
//Returns full or part of the nation's name that the quarter is within.
string QUGetNationNameMatch(object oQuarter=OBJECT_SELF);

//----------------------------------------------------------------
//::  ActionReplay Added
//----------------------------------------------------------------
//::  Sets deity for Temple Quarters
void arQUSetDeity(object oQuarter, string sDeity);
//::  Gets deity for Temple Quarters
string arQUGetDeity(object oQuarter);
//::  Updates Temple Servant Name
void arQUUpdateTempleServant(object oQuarter, object oCache);




//----------------------------------------------------------------
// Internal methods
//----------------------------------------------------------------
object _gsQULoad(string sID, int nInstance)
{
  if (sID == "" && nInstance == 0) return OBJECT_INVALID;  // this isn't a quarter.
  object oCache = miDAGetCacheObject(sID + IntToString(nInstance));

  if (!GetLocalInt(oCache, "GS_LOADED"))
  {
    Trace(QUARTER, "Loading quarter " + sID + IntToString (nInstance));

    SQLExecStatement("SELECT q.owner, q.lock_dc, q.lock_strength, q.trap_dc, q.trap_strength, " +
     "q.for_sale, q.sale_price, q.resource, q.last_used, q.last_tax, q.name, q.uid, p.name, " +
     "q.public, q.messages, q.timeout, q.deity FROM gs_quarter AS q LEFT JOIN gs_pc_data AS p " +
     "ON p.id = q.owner WHERE q.row_key=? LIMIT 1",
     sID + IntToString(nInstance));
    if (!SQLFetch())
    {
      // Set up default values.
      SetLocalInt(oCache, "LOCK_DC", 40);
      SetLocalInt(oCache, "LOCK_STRENGTH", 22);
      SetLocalInt(oCache, "TRAP_DC", 20);
      SetLocalInt(oCache, "TRAP_STRENGTH", 0);

      SQLExecStatement("INSERT INTO gs_quarter (row_key) VALUES (?)",
       sID + IntToString(nInstance));

      SetLocalInt(oCache, "GS_LOADED", TRUE);
      return oCache;
    }

    SetLocalString(oCache, "OWNER", SQLGetData(1));
    SetLocalInt(oCache, "LOCK_DC", StringToInt(SQLGetData(2)));
    SetLocalInt(oCache, "LOCK_STRENGTH", StringToInt(SQLGetData(3)));
    SetLocalInt(oCache, "TRAP_DC", StringToInt(SQLGetData(4)));
    SetLocalInt(oCache, "TRAP_STRENGTH", StringToInt(SQLGetData(5)));
    SetLocalInt(oCache, "FOR_SALE", StringToInt(SQLGetData(6)));
    SetLocalInt(oCache, "SALE_PRICE", StringToInt(SQLGetData(7)));
    SetLocalInt(oCache, "RESOURCE", StringToInt(SQLGetData(8)));
    SetLocalInt(oCache, "LAST_USED", StringToInt(SQLGetData(9)));
    SetLocalInt(oCache, "LAST_TAX", StringToInt(SQLGetData(10)));
    SetName(oCache, SQLGetData(11));
    SetLocalString(oCache, "UID", SQLGetData(12));
    SetLocalString(oCache, "OWNER_NAME", SQLGetData(13));
    SetLocalInt(oCache, "PUBLIC", StringToInt(SQLGetData(14)));
    SetLocalString(oCache, "MESSAGES", SQLGetData(15));
    SetLocalInt(oCache, "GS_TIMEOUT", StringToInt(SQLGetData(16)));
    SetLocalString(oCache, "AR_DEITY", SQLGetData(17));

    SetLocalInt(oCache, "GS_LOADED", TRUE);
  }

  // If we want to allow timeouts to be updated in the module, do that here.
  if (GetLocalInt(oCache, "GS_TIMEOUT"))
    SetLocalInt(OBJECT_SELF, "GS_TIMEOUT", GetLocalInt(oCache, "GS_TIMEOUT"));

  return oCache;
}
//----------------------------------------------------------------
string _gsQUGetOwnerID(string sID, int nInstance)
{
  object oCache = _gsQULoad(sID, nInstance);
  return GetLocalString(oCache, "OWNER");
}
//----------------------------------------------------------------
// End internal methods.
//----------------------------------------------------------------
object gsQULoad(object oQuarter)
{
  string sID    = GetLocalString(oQuarter, "GS_CLASS");
  int nInstance = GetLocalInt(oQuarter, "GS_INSTANCE");

  if (sID == "" && nInstance == 0) return OBJECT_INVALID;  // this isn't a quarter.
  object oCache = miDAGetCacheObject(sID + IntToString(nInstance));

  if (!GetLocalInt(oCache, "GS_LOADED"))
  {
    oCache = _gsQULoad(sID, nInstance);
    SetLocalString(oCache,
                   VAR_NATION,
                   GetLocalString(GetArea(oQuarter), VAR_NATION));

    // dunshine, add guildhouse tracking in the database here by storing the GS_MASTER_CLASS and GS_MASTER_INSTANCE variables into field guildhouse_key
    string sMasterClass = GetLocalString(oQuarter, "GS_MASTER_CLASS");
    int iMasterClass = GetLocalInt(oQuarter, "GS_MASTER_INSTANCE");
    if (sMasterClass != "") {

      // Update database
      sMasterClass = sMasterClass + IntToString(iMasterClass);
      SQLExecStatement("UPDATE gs_quarter SET guildhouse_key=? WHERE row_key=?", sMasterClass, sID + IntToString(nInstance));

    }

    if (GetName(oCache) == "" || GetName(oCache) == "Database Cache Item")
    {
      SetName(oCache, GetName(oQuarter));
    }
  }

  SetName(oQuarter, GetName(oCache));

  //::  Update Temple Servants Name
  arQUUpdateTempleServant(oQuarter, oCache);

  return oCache;
}
//----------------------------------------------------------------
int gsQUGetTaxAmount(object oQuarter)
{
  string sID = GetLocalString(oQuarter, "GS_CLASS") +
               IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));

  //----------------------------------------------------------------------------
  // Tax total is:
  //   1/10 * (tax rate) * (quarter/shop base value) +
  //   50 * DC increase for lock DC/strength * (tax rate) +
  //   100 * DC increase for trap DC * (tax rate) +
  //   500 * DC increase for trap strength * (tax rate).
  //
  // So for a tax rate of 10% (default) the costs are 1% of base value, plus 5g
  // per DC point for lock DC/strength, 10g for trap DC and 50g for trap str.
  //----------------------------------------------------------------------------
  string sNation = miCZGetBestNationMatch(GetLocalString(GetArea(oQuarter), VAR_NATION));
  int nBaseTax = FloatToInt(IntToFloat(GetLocalInt(oQuarter, "GS_COST")) *
                            miCZGetTaxRate(sNation) * 0.1);
  int nTax = nBaseTax + FloatToInt(miCZGetTaxRate(sNation) * IntToFloat(
               50 * (gsQUGetLockDC(oQuarter) - 40) +
               50 * (gsQUGetLockStrength(oQuarter) - 30) +
               100 * (gsQUGetTrapDC(oQuarter) - 20) +
               500 * gsQUGetTrapStrength(oQuarter)));

  if (nTax < nBaseTax) nTax = nBaseTax;

  Trace(QUARTER, "Tax rating for quarter " + sID + " is currently "
   + IntToString(nTax));

  return nTax;
}
//----------------------------------------------------------------
void gsQUPayTax(object oQuarter)
{
  string sID = GetLocalString(oQuarter, "GS_CLASS") +
               IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));
  if (sID == "0") return;  // not a valid quarter/shop.

  object oCache = gsQULoad(oQuarter);

  /*
   - check how much rent due, if >0
   - subtract from resource count
   - subtract from owner's bank account
   - due rent = 1/100 of value per game month
  */
  int nLastPaid      = GetLocalInt(oCache , "LAST_TAX");
  int nLastMonthPaid = gsTIGetYear(nLastPaid) * 12 + gsTIGetMonth(nLastPaid);
  int nCurrentMonth  = GetCalendarYear() * 12 + GetCalendarMonth();

  Trace(QUARTER, "Last month paid: " + IntToString(nLastMonthPaid) +
                             ", this month is: " + IntToString (nCurrentMonth));
  if (nLastMonthPaid < nCurrentMonth)
  {
    int nTax = gsQUGetTaxAmount(oQuarter) - GetLocalInt(oCache, "RESOURCE");
    Trace(QUARTER, "Tax bill is: " + IntToString(nTax));

    if (gsFIGetAccountBalance(gsQUGetOwnerID(oQuarter)) + 1000 >= nTax)
    {
      // transfer tax to local government or to owner of guildhouse.  If the
      // module is misconfigured, just trash the tax.
      string sNation = miCZGetBestNationMatch(GetLocalString(oCache, VAR_NATION));

      if (sNation != "")
      {
        Trace(QUARTER, "Paying tax to: " + sNation);
        miCZPayTax(gsQUGetOwnerID(oQuarter), sNation, nTax);
      }
      else
      {
        string sMasterID = _gsQUGetOwnerID(GetLocalString(oQuarter, "GS_MASTER_CLASS"),
                                           GetLocalInt(oQuarter, "GS_MASTER_INSTANCE"));

        Trace(QUARTER, "Paying tax to: " + sMasterID);
        gsFITransferFromTo(gsQUGetOwnerID(oQuarter),
                           (sMasterID == "" ? "DUMMY" : sMasterID),
                           nTax);

        if (sMasterID == "")
        {
          Warning(QUARTER, "quarter " + sID + " is not paying tax to anyone!");
        }
      }

      miDASetKeyedValue("gs_quarter", sID, "last_tax", IntToString(gsTIGetActualTimestamp()));
      SetLocalInt(oCache, "LAST_TAX", gsTIGetActualTimestamp());
    }
    else
    {
      // The owner has defaulted on their payments.
      Log(QUARTER, gsQUGetOwnerID(oQuarter) + " wasn't able to pay their tax.");
      gsQUAbandon(oQuarter);
    }
  }
}
//----------------------------------------------------------------
int gsQUGetIsOwner(object oQuarter, object oPC)
{
  object oCache = gsQULoad(oQuarter);
  int bIsOwner = FALSE;

  string sPlayerID = gsPCGetPlayerID(oPC);

  if (sPlayerID != "" &&
      GetLocalString(oCache, "OWNER") == sPlayerID)
  {
    bIsOwner = TRUE;
  }

  Trace(QUARTER, GetName(oPC) + " is " + (bIsOwner ? "": "not ") +"the owner of this quarter.");
  return bIsOwner;
}
//----------------------------------------------------------------
string gsQUGetOwnerID(object oQuarter)
{
  object oCache = gsQULoad(oQuarter);
  return GetLocalString(oCache, "OWNER");
}
//----------------------------------------------------------------
void gsQUSetOwner(object oQuarter, object oPC, int nTimeout = 0)
{
  object oCache = gsQULoad(oQuarter);
  string sPlayerID = gsPCGetPlayerID(oPC);
  string sID = GetLocalString(oQuarter, "GS_CLASS") +
               IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));

  if (sPlayerID != "")
  {
    string sUniqueID = gsCMCreateRandomID(32);
    int nTimeout = GetLocalInt(oCache, "GS_TIMEOUT");

    if (!nTimeout)
    {
      nTimeout = GetLocalInt(oQuarter, "GS_TIMEOUT");

      // Default to a sensible value if we can't find one configured.
      if (!nTimeout) nTimeout = 172800;

      // Convert real time to game time.
      nTimeout = gsTIGetGameTimestamp(nTimeout);
    }

    // Update database
    int nNow    = gsTIGetActualTimestamp();
    string sNow = IntToString(nNow);
    SQLExecStatement("UPDATE gs_quarter SET owner=?, uid=?, last_used=?, last_tax=?, timeout=? WHERE row_key=?",
     sPlayerID, sUniqueID, sNow, sNow, IntToString(nTimeout), sID);

    // Update local vars
    SetLocalString(oCache, "OWNER", sPlayerID);
    SetLocalString(oCache, "UID", sUniqueID);
    SetLocalInt(oCache, "LAST_USED", nNow);
    SetLocalInt(oCache, "LAST_TAX", nNow);
    SetLocalString(oCache, "OWNER_NAME", GetName(oPC));
    SetLocalInt(oCache, "GS_TIMEOUT", nTimeout);
  }
}
//----------------------------------------------------------------
string gsQUGetOwnerName(object oQuarter)
{
  object oCache = gsQULoad(oQuarter);
  return GetLocalString(oCache, "OWNER_NAME");
}
//----------------------------------------------------------------
void gsQUTouch(object oQuarter)
{
  object oCache = gsQULoad(oQuarter);
  string sID = GetLocalString(oQuarter, "GS_CLASS") +
               IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));

  miDASetKeyedValue("gs_quarter", sID, "last_used", IntToString(gsTIGetActualTimestamp()));
  SetLocalInt(oCache, "LAST_USED", gsTIGetActualTimestamp());
  Log(QUARTER, gsQUGetOwnerName(oQuarter) + " touched their quarter/shop (" + sID + ") in " + GetName(GetArea(oQuarter)));
}
//----------------------------------------------------------------
void gsQUTouchWithNotification(object oQuarter, object oPC)
{
    gsQUTouch(oQuarter);
    FloatingTextStringOnCreature("You have refreshed your quarter.", oPC, FALSE);
}
//----------------------------------------------------------------
int gsQUGetIsVacant(object oQuarter)
{
  object oCache = gsQULoad(oQuarter);
  int bIsVacant = (GetLocalString(oCache, "OWNER") == "");
  Trace(QUARTER, "Quarter is " + (bIsVacant ? "": "not ") +"vacant.");

  return bIsVacant;
}
//----------------------------------------------------------------
int gsQUGetIsAvailable(object oQuarter)
{
  object oCache = gsQULoad(oQuarter);
  int bIsAvailable = TRUE;

  if (!gsQUGetIsForSale(oQuarter))
  {
    string sID    = GetLocalString(oQuarter, "GS_CLASS");
    int nInstance = GetLocalInt(oQuarter, "GS_INSTANCE");

    if (! gsQUGetIsVacant(oQuarter))
    {
      int nTimeout = GetLocalInt(oCache, "GS_TIMEOUT");
      int nLast    = GetLocalInt(oCache, "LAST_USED");
      int nNow     = gsTIGetActualTimestamp();

      Trace(QUARTER, "Checking whether time has expired.  Last touched: " +
        IntToString(nLast) + ", timeout: " + IntToString(nTimeout) + ", now: " +
        IntToString(nNow));

      if (nLast + nTimeout >= nNow) bIsAvailable = FALSE;
    }
  }

  Trace(QUARTER, "Quarter is " + (bIsAvailable ? "": "not ") +"available.");

  return bIsAvailable;
}
//----------------------------------------------------------------
void gsQUAbandon(object oQuarter)
{
  QUResetFaction(oQuarter); //reset the faction first, we have some data to grab
  object oCache = gsQULoad(oQuarter);
  string sID = GetLocalString(oQuarter, "GS_CLASS") +
               IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));
  SetLocalString(oCache, "OWNER", "");
  miDASetKeyedValue("gs_quarter", sID, "owner", "NULL");
  //::  Added by ActionReplay:  If this was a rentable Ship
  //::  it is important we reset the Ship Expiration Timer.
  //::  Rather than importing ar_sys_ship for helper functions I'll just hardcode it here:
  if ( GetLocalInt(oQuarter, "AR_SHP_RENTABLE") ) {
    SetLocalInt(oQuarter, "AR_SHP_RENT_TIMER", 0);
    SetLocalInt(oQuarter, "AR_SHP_RENT_HOUR", 0);
  }
}
//----------------------------------------------------------------
string gsQUGetKeyTag(object oQuarter)
{
  object oCache = gsQULoad(oQuarter);
  return GetLocalString(oCache, "UID");
}
//----------------------------------------------------------------
void gsQUCreateKey(object oQuarter, object oTarget)
{
  object oCache = gsQULoad(oQuarter);
  string sUniqueID = GetLocalString(oCache, "UID");

  if (sUniqueID != "")
  {
    object oObject = CreateItemOnObject(GS_QU_TEMPLATE_KEY,
                                        oTarget,
                                        1,
                                        sUniqueID);

    if (GetIsObjectValid(oObject))
    {
      SetName(oObject,
              gsCMReplaceString(GS_T_16777477, gsQUGetOwnerName(oQuarter)));

      gsIPSetOwner(oObject, oTarget);
      SetLocalString(oObject, "MD_KEY_CREATOR", gsPCGetPlayerID(oTarget)); //in crease the owner ever changes.
    }
  }
}
//----------------------------------------------------------------
int gsQUGetIsPublic(object oQuarter)
{
  object oCache = gsQULoad(oQuarter);
  int bIsPublic = GetLocalInt(oCache, "PUBLIC");
  Trace(QUARTER, "Quarter is " + (bIsPublic ? "": "not ") +"open to the public.");

  return bIsPublic;
}
//----------------------------------------------------------------
void gsQUSetIsPublic(object oQuarter, int bPublic)
{
  object oCache = gsQULoad(oQuarter);
  string sID = GetLocalString(oQuarter, "GS_CLASS") +
               IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));
  SetLocalInt(oCache, "PUBLIC", bPublic);
  miDASetKeyedValue("gs_quarter", sID, "public", IntToString(bPublic));
}
//----------------------------------------------------------------
int gsQUGetIsForSale(object oQuarter)
{
  object oCache = gsQULoad(oQuarter);
  int bIsForSale = GetLocalInt(oCache, "FOR_SALE");
  Trace(QUARTER, "Quarter is " + (bIsForSale ? "": "not ") +"for sale.");

  return bIsForSale;
}
//----------------------------------------------------------------
void gsQUSetIsForSale(object oQuarter, int bForSale)
{
  object oCache = gsQULoad(oQuarter);
  string sID = GetLocalString(oQuarter, "GS_CLASS") +
               IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));
  SetLocalInt(oCache, "FOR_SALE", bForSale);
  miDASetKeyedValue("gs_quarter", sID, "for_sale", IntToString(bForSale));
}
//----------------------------------------------------------------
int gsQUGetLockStrength(object oQuarter)
{
  object oCache = gsQULoad(oQuarter);
  return GetLocalInt(oCache, "LOCK_STRENGTH");
}
//----------------------------------------------------------------
void gsQUSetLockStrength(object oQuarter, int nStrength)
{
  object oCache = gsQULoad(oQuarter);
  string sID = GetLocalString(oQuarter, "GS_CLASS") +
               IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));
  if (nStrength < 0) nStrength = 0;

  SetLocalInt(oCache, "LOCK_STRENGTH", nStrength);
  miDASetKeyedValue("gs_quarter", sID, "lock_strength", IntToString(nStrength));
}
//----------------------------------------------------------------
int gsQUGetLockDC(object oQuarter)
{
  object oCache = gsQULoad(oQuarter);
  return GetLocalInt(oCache, "LOCK_DC");
}
//----------------------------------------------------------------
void gsQUSetLockDC(object oQuarter, int nDC)
{
  object oCache = gsQULoad(oQuarter);
  string sID = GetLocalString(oQuarter, "GS_CLASS") +
               IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));
  if (nDC < 0) nDC = 0;

  SetLocalInt(oCache, "LOCK_DC", nDC);
  miDASetKeyedValue("gs_quarter", sID, "lock_dc", IntToString(nDC));
}
//----------------------------------------------------------------
int gsQUGetTrapStrength(object oQuarter)
{
  object oCache = gsQULoad(oQuarter);
  return GetLocalInt(oCache, "TRAP_STRENGTH");
}
//----------------------------------------------------------------
void gsQUSetTrapStrength(object oQuarter, int nStrength)
{
  object oCache = gsQULoad(oQuarter);
  string sID = GetLocalString(oQuarter, "GS_CLASS") +
               IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));
  if (nStrength < 0) nStrength = 0;

  SetLocalInt(oCache, "TRAP_STRENGTH", nStrength);
  miDASetKeyedValue("gs_quarter", sID, "trap_strength", IntToString(nStrength));
}
//----------------------------------------------------------------
int gsQUGetTrapDC(object oQuarter)
{
  object oCache = gsQULoad(oQuarter);
  return GetLocalInt(oCache, "TRAP_DC");
}
//----------------------------------------------------------------
void gsQUSetTrapDC(object oQuarter, int nDC)
{
  object oCache = gsQULoad(oQuarter);
  string sID = GetLocalString(oQuarter, "GS_CLASS") +
               IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));
  if (nDC < 0) nDC = 0;

  SetLocalInt(oCache, "TRAP_DC", nDC);
  miDASetKeyedValue("gs_quarter", sID, "trap_dc", IntToString(nDC));
}
//----------------------------------------------------------------
void gsQUReset(object oQuarter)
{
  gsQUSetIsPublic(oQuarter, FALSE);
  gsQUSetIsForSale(oQuarter, FALSE);
  QUResetFaction(oQuarter);
}
//----------------------------------------------------------------
void gsQUSetName(object oQuarter, string sName)
{
  object oCache = gsQULoad(oQuarter);
  SetName(oQuarter, sName);
  SetName(oCache, sName);
  string sID = GetLocalString(oQuarter, "GS_CLASS") +
               IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));
  miDASetKeyedValue("gs_quarter", sID, "name", sName);
}
//----------------------------------------------------------------
void gsQUPostMessage(object oQuarter, string sMessageID)
{
  object oCache = gsQULoad(oQuarter);
  string sID = GetLocalString(oQuarter, "GS_CLASS") +
               IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));
  string sMessages = GetLocalString(oCache, "MESSAGES");

  sMessages += sMessageID + ";;";
  SetLocalString(oCache, "MESSAGES", sMessages);
  miDASetKeyedValue("gs_quarter", sID, "messages", sMessages);
}
//----------------------------------------------------------------
const string GS_TEMPLATE_LETTER = "gs_item370";
void gsQURetrieveMessages(object oQuarter, object oRecipient)
{
  object oCache = gsQULoad(oQuarter);
  string sID = GetLocalString(oQuarter, "GS_CLASS") +
               IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));
  string sMessages = GetLocalString(oCache, "MESSAGES");

  int index = FindSubString(sMessages, ";;");
  string sMessage;
  object oMessage;
  int nMessageCount = 0;

  while (index > -1)
  {
    nMessageCount++;
    sMessage = GetStringLeft(sMessages, index);
    sMessages = GetStringRight(sMessages, GetStringLength(sMessages) - index - 2);

    oMessage    = CreateItemOnObject(GS_TEMPLATE_LETTER,
                                     oRecipient,
                                     1,
                                     "GS_ME_" + sMessage);
    if (GetIsObjectValid(oMessage))
    {
        string sDoubleQuote = GetLocalString(GetModule(), "GS_DOUBLE_QUOTE");
        SetName(oMessage, sDoubleQuote + gsMEGetTitle(sMessage) + sDoubleQuote);
        FloatingTextStringOnCreature("You find a letter.", oRecipient);
    }

    index = FindSubString(sMessages, ";;");
  }

  if (nMessageCount)
  {
    DeleteLocalString(oCache, "MESSAGES");
    miDASetKeyedValue("gs_quarter", sID, "messages", "");
  }
}
//----------------------------------------------------------------
void gsQUOpen(object oQuarter, object oOpener)
{
  if (GetObjectType(oQuarter) != OBJECT_TYPE_DOOR) return;

  ActionDoCommand(SetLocked(oQuarter, FALSE));
  ActionOpenDoor(oQuarter);
  ActionDoCommand(SetLocked(oQuarter, TRUE));
  gsQURetrieveMessages(oQuarter, oOpener);
}





//----------------------------------------------------------------
//::  ActionReplay Added
//----------------------------------------------------------------
void arQUSetDeity(object oQuarter, string sDeity)
{
  object oCache = gsQULoad(oQuarter);
  string sID = GetLocalString(oQuarter, "GS_CLASS") +
               IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));
  if (sDeity == "" || sDeity == " ") sDeity = "Avatar";

  SetLocalString(oCache, "AR_DEITY", sDeity);
  miDASetKeyedValue("gs_quarter", sID, "deity", sDeity);

  arQUUpdateTempleServant(oQuarter, oCache);
}

string arQUGetDeity(object oQuarter)
{
  object oCache = gsQULoad(oQuarter);
  return GetLocalString(oCache, "AR_DEITY");
}

void arQUUpdateTempleServant(object oQuarter, object oCache) {
    string sDeity = GetLocalString(oCache, "AR_DEITY");
    string sTag   = GetLocalString(oQuarter, "GS_CLASS") + "_AVATAR";

    if (sTag == "" || sDeity == "") return;

    object oServant = GetObjectByTag(sTag);

    if ( GetIsObjectValid(oServant) ) {
        SetName(oServant, "Servant of " + sDeity);
    }
}

void QUResetFaction(object oQuarter)
{
  if(GetLocalInt(oQuarter, VAR_NOBLE_ESTATE))
  {
     SQLExecStatement("UPDATE md_fa_members AS m INNER JOIN md_fa_factions AS f ON m.faction_id=f.id SET m.is_Noble=NULL WHERE m.faction_id IN ( SELECT tempM.tempID FROM (SELECT faction_id AS  tempID FROM md_fa_members WHERE is_OwnerRank=1 AND pc_id=? AND faction_id=? ) AS tempM)" +
     " AND (f.type IS NULL OR f.type !=?)", gsQUGetOwnerID(oQuarter), md_SHLoadFacID(oQuarter), IntToString(FAC_NATION));
  }
  //Removes faction
  string sID = GetLocalString(oQuarter, "GS_CLASS") +
               IntToString(GetLocalInt(oQuarter, "GS_INSTANCE"));
  SQLExecStatement("UPDATE gs_quarter SET faction_id=NULL, faction_tax=NULL, faction_ability=NULL WHERE row_key=?", sID);
  DeleteLocalString(GetModule(), VAR_FID+sID); //faction ids changed to module, see md_shloadfacid for details
  DeleteLocalInt(GetArea(oQuarter), VAR_FAB+sID);
  DeleteLocalString(GetArea(oQuarter), VAR_FTAX+sID);


}

string QUGetNationNameMatch(object oQuarter=OBJECT_SELF)
{
    string sName = GetLocalString(oQuarter, VAR_NATION);
    if(sName == "") GetLocalString(GetArea(oQuarter), VAR_NATION);
    if(sName == "")
    {
        string sID    = GetLocalString(oQuarter, "GS_CLASS");
        int nInstance = GetLocalInt(oQuarter, "GS_INSTANCE");

        object oCache = miDAGetCacheObject(sID + IntToString(nInstance));
        sName = GetLocalString(oCache, VAR_NATION);
    }

    return sName;
}
