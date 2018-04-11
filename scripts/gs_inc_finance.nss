/* FINANCE Library by Gigaschatten */

#include "gs_inc_common"
#include "gs_inc_pc"
#include "inc_database"
#include "inc_log"

const string BANK = "BANK"; // for logging

const int GS_FI_CAP     = 10000000; // maximum gold that can be stored
const int GS_FI_INVALID = -10000001; // number to denote an invalid account

const int GS_FI_TYPE_PC     = 0;
const int GS_FI_TYPE_NATION = 1;
const int GS_FI_TYPE_FACT   = 2;

//void main() {}

struct gsFIAccount
{
  string sOwnerID;
  string sTable;
  int nType;
  int nBalance;
  int nLastAdjust;
  int bValid;
};

//return the gsFIAccount representation of sAccountID's account
struct gsFIAccount gsFIGetAccount(string sAccountID);
//save stAccount to the database
void gsFISaveAccount(struct gsFIAccount stAccount);
//adjust the gold in stAccount by nAmount (up or down), within +/- GS_FI_CAP or
//to no less than -1000 with bAllowNegatives. Does not actually save the account
//so this method may be used to test changes. Any changes made will be stored in
//stAccount.nLastAdjust.
struct gsFIAccount gsFIAdjustBalance(struct gsFIAccount stAccount, int nAmount, int bAllowNegatives = FALSE);
//wrapper method: return balance in account sAccountID
int gsFIGetAccountBalance(string sAccountID);
//return account balance of oPC
int gsFIGetBalance(object oPC);
//return amount drawn by oPC.  sOverrideID to draw from an account other than
//the PC's own.
//nAmount =  0 //draw full positive amount
//nAmount = -1 //draw full credit limit
int gsFIDraw(object oPC, int nAmount = 0, string sOverrideID = "", int bAllowNegatives=FALSE);
//return amount paid in by oPC.  sOverrideID to put into an account other than
//the PC's own.
//nAmount = 0 //pay in everything
int gsFIPayIn(object oPC, int nAmount = 0, string sOverrideID = "");
//transfer nAmount from caller to sAccountID
void gsFITransfer(string sAccountID, int nAmount);
//transfer nAmount from sFromAccountID's account to sDestAccountID's.  If
//bAllowNegatives is true, then sFromAccountID can go into debt >1000 as a
//result of the transaction.
void gsFITransferFromTo(string sFromAccountID, string sDestAccountID, int nAmount, int bAllowNegatives=FALSE);

struct gsFIAccount gsFIGetAccount(string sAccountID)
{
  struct gsFIAccount stAccount;
  stAccount.nType  = GS_FI_TYPE_PC;
  stAccount.sTable = "gs_pc_data";
  string sAlt      = GetStringLeft(sAccountID, 1);

  if (sAccountID == "")
  {
    stAccount.bValid = FALSE;
    return stAccount;
  }

  // Dummy account
  if (sAccountID == "DUMMY")
  {
    stAccount.sTable = "";
    stAccount.bValid = TRUE;
    return stAccount;
  }
  // Nations
  else if (sAlt == "N")
  {
    sAccountID       = GetStringRight(sAccountID, GetStringLength(sAccountID) - 1);
    stAccount.sTable = "micz_nations";
    stAccount.nType  = GS_FI_TYPE_NATION;
  }
  else if (sAlt == "F")
  {
    sAccountID       = GetStringRight(sAccountID, GetStringLength(sAccountID) - 1);
    stAccount.sTable = "md_fa_factions";
    stAccount.nType  = GS_FI_TYPE_FACT;
  }

  string sBalance = miDAGetKeyedValue(stAccount.sTable, sAccountID, "bank");

  stAccount.sOwnerID = sAccountID;
  stAccount.bValid   = (sBalance != "");
  stAccount.nBalance = StringToInt(sBalance);
  return stAccount;
}
//----------------------------------------------------------------
void gsFISaveAccount(struct gsFIAccount stAccount)
{
  if (stAccount.sTable != "")
  {
    miDASetKeyedValue(stAccount.sTable, stAccount.sOwnerID, "bank", IntToString(stAccount.nBalance));
  }
}
//----------------------------------------------------------------
struct gsFIAccount gsFIAdjustBalance(struct gsFIAccount stAccount, int nAmount, int bAllowNegatives = FALSE)
{
  Trace(BANK, "Adjust Balance called: amount = " + IntToString(nAmount) + ", balance = " + IntToString(stAccount.nBalance));

  // DUMMY has no limitations. Fear the almighty power of DUMMY!
  if (stAccount.sTable == "")
  {
    stAccount.nBalance   += nAmount;
    stAccount.nLastAdjust = nAmount;
    return stAccount;
  }

  // Don't go under -1000 if !bAllowNegatives.
  if (stAccount.nBalance + nAmount < -1000 && !bAllowNegatives)
    nAmount = -stAccount.nBalance - 1000;

  // Don't go under -GS_FI_CAP.
  if (stAccount.nBalance + nAmount < -GS_FI_CAP)
    nAmount = -stAccount.nBalance - GS_FI_CAP;

  // Don't go over GS_FI_CAP.
  if (stAccount.nBalance + nAmount > GS_FI_CAP)
    nAmount = GS_FI_CAP - stAccount.nBalance;

  stAccount.nBalance   += nAmount;
  stAccount.nLastAdjust = nAmount;

  Trace(BANK, "Final adjustment: " + IntToString(nAmount));

  return stAccount;
}
//----------------------------------------------------------------
int gsFIGetAccountBalance(string sAccountID)
{
  struct gsFIAccount stAccount = gsFIGetAccount(sAccountID);

  if (!stAccount.bValid)
  {
    return GS_FI_INVALID;
  }

  return stAccount.nBalance;
}
//----------------------------------------------------------------
int gsFIGetBalance(object oPC)
{
  int nAmount = GetLocalInt(oPC, "GS_FINANCE");
  Trace (BANK, "Amount in local var: " + IntToString(nAmount));

  if (!nAmount)
  {
    return gsFIGetAccountBalance(gsPCGetPlayerID(oPC));
  }
  else
  {
    return nAmount;
  }
}
//----------------------------------------------------------------
int gsFIDraw(object oPC, int nAmount = 0, string sOverrideID = "", int bAllowNegatives=FALSE)
{
  string sID = (sOverrideID == "" ? gsPCGetPlayerID(oPC) : sOverrideID);
  Trace(BANK, "Draw called: ID = " + sID + ", amount = " + IntToString(nAmount));

  if (nAmount < -1) nAmount = -1;  // Firewall against large negative values.

  if (sID != "")
  {
    struct gsFIAccount stAccount = gsFIGetAccount(sID);
    if (!stAccount.bValid) return FALSE;

    switch (nAmount)
    {
      case -1: //draw full credit limit
        nAmount = stAccount.nBalance + 1000;
        break;

      case  0: //draw full positive amount
        nAmount = stAccount.nBalance;
        if (nAmount < 0) nAmount = 0;
        break;

      default:
        break;
    }

    stAccount = gsFIAdjustBalance(stAccount, -nAmount);
    nAmount   = -stAccount.nLastAdjust;

    gsCMCreateGold(nAmount, oPC);
    gsFISaveAccount(stAccount);
    if (sOverrideID == "") SetLocalInt(oPC, "GS_FINANCE", stAccount.nBalance);
    return nAmount;
  }

  return FALSE;
}
//----------------------------------------------------------------
int gsFIPayIn(object oPC, int nAmount = 0, string sOverrideID = "")
{
  string sID = (sOverrideID == "" ? gsPCGetPlayerID(oPC) : sOverrideID);
  Trace(BANK, "Pay in called: ID = " + sID + ", amount = " + IntToString(nAmount));

  if (sID != "")
  {
    int nGold = GetGold(oPC);
    if (nAmount > nGold || !nAmount) nAmount = nGold;

    if (nAmount > 0)
    {
      struct gsFIAccount stAccount = gsFIGetAccount(sID);
      if (!stAccount.bValid) return FALSE;

      stAccount = gsFIAdjustBalance(stAccount, nAmount);
      nAmount   = stAccount.nLastAdjust;

      if (nAmount > 0)
      {
        AssignCommand(oPC, TakeGoldFromCreature(nAmount, oPC, TRUE));
        gsFISaveAccount(stAccount);
        if (sOverrideID == "") SetLocalInt(oPC, "GS_FINANCE", stAccount.nBalance);
        return nAmount;
      }
    }
  }

  return FALSE;
}
//----------------------------------------------------------------
void gsFITransfer(string sAccountID, int nAmount)
{
  object oFrom = OBJECT_SELF;
  struct gsFIAccount stAccount = gsFIGetAccount(sAccountID);
  if (!stAccount.bValid) return;
  if (GetGold(oFrom) < nAmount && GetIsPC(oFrom)) return;

  stAccount = gsFIAdjustBalance(stAccount, nAmount);
  nAmount   = stAccount.nLastAdjust;

  if (nAmount > 0)
  {
    TakeGoldFromCreature(nAmount, OBJECT_SELF, TRUE);
    gsFISaveAccount(stAccount);

    object oPC = gsPCGetPlayerByID(sAccountID);
    if (GetIsObjectValid (oPC))
      SetLocalInt(oPC, "GS_FINANCE", stAccount.nBalance);
  }
}
//----------------------------------------------------------------
void gsFITransferFromTo(string sFromAccountID, string sDestAccountID, int nAmount, int bAllowNegatives=FALSE)
{
  Trace(BANK, "Transferring " + IntToString(nAmount) + " from " + sFromAccountID +
   " to " + sDestAccountID);

  struct gsFIAccount stFrom = gsFIGetAccount(sFromAccountID);
  struct gsFIAccount stDest = gsFIGetAccount(sDestAccountID);

  if (!stFrom.bValid || !stDest.bValid) return; // Invalid account.

  // Attempt to make the transfer.
  stFrom = gsFIAdjustBalance(stFrom, -nAmount, bAllowNegatives);
  stDest = gsFIAdjustBalance(stDest, nAmount, bAllowNegatives);

  // Use the smaller amount, in case they are different. Remember that
  // stFrom.nLastAdjust is negative. The difference is therefore the two
  // nLastAdjust variables added together.
  if (-stFrom.nLastAdjust >= stDest.nLastAdjust)
  {
    nAmount = stDest.nLastAdjust;
    stFrom.nBalance -= stFrom.nLastAdjust + stDest.nLastAdjust;
  }
  else
  {
    nAmount = -stFrom.nLastAdjust;
    stDest.nBalance -= stFrom.nLastAdjust + stDest.nLastAdjust;
  }

  if (nAmount > 0)
  {
    gsFISaveAccount(stFrom);
    gsFISaveAccount(stDest);

    object oPC = gsPCGetPlayerByID(sFromAccountID);
    if (GetIsObjectValid(oPC))
      SetLocalInt(oPC, "GS_FINANCE", stFrom.nBalance);

    oPC = gsPCGetPlayerByID(sDestAccountID);
    if (GetIsObjectValid(oPC))
      SetLocalInt(oPC, "GS_FINANCE", stDest.nBalance);
  }
}

