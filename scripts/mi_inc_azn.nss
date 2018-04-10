/*
 Assassin's Guild library.

 Core functions:
 - Anyone can approach the guild to put a contract on someone else
 - The cost of the contract is paid into the guild immediately.
 - The target will be notified that there is a contract out on
 them whenever they log in (and when the contract is placed).
 - The target can buy off the contract, by paying the same amount
 as was originally bid.  If this happens, the contractor gets
 half the money back (but only half!).
 - An assassin can take out the target.  Using their special
 guild dagger on the corpse will cause them to be paid the
 contract sum (less 25% for guild fees).
 - If someone is marked assassinated, they lose any elected
 position that they hold.

 Database table:
 CREATE TABLE `mi_az_contracts` (
   `id` int(11) NOT NULL auto_increment,
   `customer` int(11) NOT NULL,
   `victim` int(11) NOT NULL,
   `contract_value` int(11) NOT NULL,
   `modified` TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`id`),
   KEY (`victim`),
   CONSTRAINT `mi_az_contracts_FK1` FOREIGN KEY (`customer`) REFERENCES `gs_pc_data` (`id`) ON DELETE CASCADE,
   CONSTRAINT `mi_az_contracts_FK2` FOREIGN KEY (`victim`) REFERENCES `gs_pc_data` (`id`) ON DELETE CASCADE
  ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

*/
#include "gs_inc_finance"
#include "mi_inc_citizen"
#include "mi_inc_xfer"

struct miAZContract
{
    string  sID;
    string  sCustomer;
    string  sVictim;
    int     nValue;
    int     nTimeStamp;
};

// Clean out contracts older than 30 days
void miAZCleanContracts();
// Return a formatted string with details of all the contracts currently
// open.
string miAZListContracts();
// Returns the contract with ID sID, or null if no such contract exists.
struct miAZContract miAZGetContractByID(string sID);
// Returns a contract object representing the active contract on nVictim,
// or null if no contract exists.  sVictim is the PC ID of the character.
struct miAZContract miAZGetContractByVictim(string sVictim);
// Create a contract.  Returns the id of the new contract, or "" if the
// create fails (e.g. there is always a contract on sVictim).
// Note: Doesn't take the money from nCustomer.  Calling script should
// do this.
string miAZCreateContract(string sCustomer, string sVictim, int nAmount);
// Fulfil the contract on nVictim.  Returns the value of the contract,
// or 0 if no contract was found.
int miAZFulfilContract(string sVictim);
// Destroy the contract on nVictim.  The customer will get 50% of the value
// of the contract back.
void miAZCancelContract(string sVictim);

// sends a NPC messenger to the target to warn about the contract (if online)
void gvdAZMessenger(string sVictim);


void miAZCleanContracts()
{
    // Clean out contracts older than 30 days
    SQLExecStatement("DELETE FROM mi_az_contracts WHERE DATEDIFF(NOW(), modified) > 30");
}

string miAZListContracts()
{

    miAZCleanContracts();
    SQLExecStatement("SELECT c.contract_value,p.name FROM mi_az_contracts AS c INNER JOIN gs_pc_data AS p ON c.victim=p.id");

    string sText = "";

    while (SQLFetch())
    {
        sText += "Mark: " + SQLGetData(2) + ", value: " + SQLGetData(1) + "\n";
    }

    return sText;
}

struct miAZContract miAZGetContractByID(string sID)
{
    miAZCleanContracts();
    SQLExecStatement("SELECT id,customer,victim,contract_value,modified FROM mi_az_contracts WHERE id=?", sID);

    struct miAZContract xContract;
    xContract.sID = "";
    xContract.nValue = 0;

    if (!SQLFetch())
    {
        return xContract;
    }

    xContract.sID       = SQLGetData(1);
    xContract.sCustomer = SQLGetData(2);
    xContract.sVictim   = SQLGetData(3);
    xContract.nValue    = StringToInt(SQLGetData(4));
    xContract.nTimeStamp    = StringToInt(SQLGetData(5));

    return xContract;
}

struct miAZContract miAZGetContractByVictim(string sVictim)
{
    miAZCleanContracts();
    SQLExecStatement("SELECT id,customer,victim,contract_value,modified FROM mi_az_contracts WHERE victim=?", sVictim);

    struct miAZContract xContract;
    xContract.sID = "";
    xContract.nValue = 0;

    if (!SQLFetch())
    {
        return xContract;
    }

    xContract.sID       = SQLGetData(1);
    xContract.sCustomer = SQLGetData(2);
    xContract.sVictim   = SQLGetData(3);
    xContract.nValue    = StringToInt(SQLGetData(4));
    xContract.nTimeStamp    = StringToInt(SQLGetData(5));

    return xContract;
}

string miAZCreateContract(string sCustomer, string sVictim, int nAmount)
{
    miAZCleanContracts();

    // Check that there is no contract on this victim already.
    // 3/1/2018 - Modifying this so that the contact amount is added to and refreshed

    int nOldAmount = 0;

    SQLExecStatement("SELECT id,contract_value FROM mi_az_contracts WHERE victim=?", sVictim);
    if (SQLFetch())
    {
        nOldAmount = StringToInt(SQLGetData(2));
        SQLExecStatement("DELETE FROM mi_az_contracts WHERE id = ?", SQLGetData(1));
        // Oops - contract already exists.
        // return "";
    }

  // If the player is online, let them know about the bounty.
    gvdAZMessenger(sVictim);
  //object oPC = gsPCGetPlayerByID(sVictim);
  //if (GetIsObjectValid(oPC))
  //{
  //    WriteTimestampedLogEntry("ASSASSIN WARNING FOR: " + GetName(oPC) + " with ID " + sVictim);
  //    FloatingTextStringOnCreature("There is a bounty on your head!", oPC, FALSE);
  //    SendMessageToPC(oPC, "Someone has put a contract out on you!  Assassins may be trying to hunt you down, be on your guard.  " +
  //        "You can buy out your contract at the Guild of Assassins.  Guild assassins do not " +
  //        "need to interactively RP with you before attacking, but still need to follow all " +
  //        "other rules of engagement (e.g. hostile before attack).");
  //}

    SQLExecStatement("INSERT INTO mi_az_contracts (customer, victim, contract_value) VALUES (?,?,?)",
                   sCustomer, sVictim, IntToString(nAmount + nOldAmount));

    SQLExecStatement("SELECT id FROM mi_az_contracts WHERE victim=?", sVictim);
    SQLFetch();
    return SQLGetData(1);
}

int miAZFulfilContract(string sVictim)
{
    //  Check whether sVictim has a contract.
    struct miAZContract xContract =  miAZGetContractByVictim(sVictim);

    if (xContract.sID != "")
    {
        if (miCZGetIsLeaderByID(sVictim))
        {
            // Settlement leader - need to remove from office.  Look up their nation.
            SQLExecStatement("SELECT nation FROM gs_pc_data WHERE id=?", sVictim);
            SQLFetch();
            string sNation = SQLGetData(1);
            miCZResign(sVictim, sNation);
    }

    object oPC = gsPCGetPlayerByID(xContract.sID);

    if (GetIsObjectValid(oPC)) // PC is logged in
    {
        SendMessageToPC (oPC, "An assassin got you!  Your bounty has been claimed; you no longer have a price on your head.");
    }

    // Remove contract.
    SQLExecStatement("DELETE FROM mi_az_contracts WHERE id = ?", xContract.sID);

    return xContract.nValue;
  }

  return 0;
}

void miAZCancelContract(string sVictim)
{
    struct miAZContract xContract = miAZGetContractByVictim(sVictim);

    gsFIAdjustBalance(gsFIGetAccount(xContract.sCustomer), xContract.nValue / 2);

    SQLExecStatement("DELETE FROM mi_az_contracts WHERE id = ?", xContract.sID);
}

void gvdAZMessenger(string sVictim) {

    // check if a PC with id = sVictim is online atm
    SQLExecStatement("SELECT a.server, b.name FROM mixf_currentplayers as a INNER JOIN gs_pc_data as b ON (a.pcid = b.id) WHERE (a.pcid = ?)", sVictim);

    if (SQLFetch()) {

        string sCurrentServer = GetLocalString(GetModule(), VAR_SERVER_NAME);
        string sTargetServer  = SQLGetData(1);
        string sVictimName = SQLGetData(2);

    if (sCurrentServer == sTargetServer) {
        miXFDeliverMessage(sVictim, "I deliver a message from the guild of Assassins. Someone has put a contract out on you.", MESSAGE_TYPE_IMAGE);
    } else {
        miXFSendMessage(sVictim, sTargetServer, "I deliver a message from the guild of Assassins. Someone has put a contract out on you.", MESSAGE_TYPE_IMAGE);
    }

    WriteTimestampedLogEntry("ASSASSIN WARNING FOR: " + sVictimName + " with ID " + sVictim);

  }

}

