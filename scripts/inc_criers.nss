/*
  inc_criers

  Description, as eloqently defined by jjjerm...

  (19:18:05) Jjjerm: a town crier NPC.  You pay X gold, that city town crier
  shouts the message that you want every minute irl for  so many hours.  For X
  times 20 gold, the guild of criers (one in every town) shouts the same message
  for the same amount of time.

  This function uses an external MySQL database.  The database table needs to
  have the name micr_messages and the following columns:
    tag       varchar(32)
    message   varchar(512)
    timestamp varchar(32)

  e.g.
create table micr_messages (tag VARCHAR(32), message VARCHAR(512), timestamp VARCHAR(32), modified TIMESTAMP(8));

  @@@ todo: logging.

*/

#include "inc_database"
#include "inc_log"
#include "inc_time"

const string CRIERS = "CRIERS"; // for tracing

// Variable name to use on town criers to determine which is which.
const string INSTANCE = "instance";

// The tag to use for all town criers.
const string MICR_TAG = "micr_crier";

// Set the message to be shouted.  bAllCriers should be TRUE if the message
// should be shouted by criers in all towns.  nDuration is measured in hours.
//
// Logs the player who added this message in case of abuse.
void miCRAddMessage(string sMessage, int nDuration, int bAllCriers = FALSE, object oCrier = OBJECT_SELF);

// same as above, but instead of using a oCrier object as parameter, use the instance string variable
// this function can be used from outside a Crier zdlg for instance
void miCRAddMessageForInstance(string sMessage, int nDuration, string sInstance);

// Get the current message to be shouted.
void miCRDoShoutMessage(object oCrier = OBJECT_SELF);

// Tell all town criers to shout their messages.  Call from module heartbeat.
void miCRDoShoutMessages();

// DM-called tool to clear out the database, removing any unsavoury messages.
void miCRPurgeDatabase();

void _miCRAddMessageToCrier(string sMessage, int nExpires, object oCrier)
{
  string sInstance  = GetLocalString(oCrier, INSTANCE);
  string sTimestamp = IntToString(nExpires);

  string sSQL = "INSERT INTO micr_messages (tag,message,timestamp) VALUES ('" +
     sInstance + "','" + sMessage + "','" + sTimestamp + "');";
  Trace(CRIERS, "Executing SQL: " + sSQL);
  SQLExecDirect(sSQL);
}

void miCRAddMessage(string sMessage, int nDuration, int bAllCriers = FALSE, object oCrier = OBJECT_SELF)
{
  int nTimestamp = gsTIGetActualTimestamp() + 60 * MINUTES_PER_HOUR * nDuration;

  if (bAllCriers)
  {
    int nCount = 0;
    oCrier = GetObjectByTag(MICR_TAG, nCount);

    while (GetIsObjectValid(oCrier))
    {
      Trace(CRIERS, "Adding message to crier: " + GetName(oCrier));
      _miCRAddMessageToCrier(SQLEncodeSpecialChars(sMessage), nTimestamp, oCrier);
      nCount++;
      oCrier = GetObjectByTag(MICR_TAG, nCount);
    }

    Trace(CRIERS, "Added message to all criers.");
  }
  else if (GetIsObjectValid(oCrier))
  {
    Trace(CRIERS, "Adding message to one crier (" + GetName(oCrier) + ")");
    _miCRAddMessageToCrier(SQLEncodeSpecialChars(sMessage), nTimestamp, oCrier);
  }
  else
  {
    Trace(CRIERS, "No crier to add messages to.");
  }
}

void miCRAddMessageForInstance(string sMessage, int nDuration, string sInstance) {

  int nTimestamp = gsTIGetActualTimestamp() + 60 * MINUTES_PER_HOUR * nDuration;
  string sTimestamp = IntToString(nTimestamp);
  sMessage = SQLEncodeSpecialChars(sMessage);

  Trace(CRIERS, "Adding message to criers with instance (" + sInstance + ")");

  string sSQL = "INSERT INTO micr_messages (tag,message,timestamp) VALUES ('" +
     sInstance + "','" + sMessage + "','" + sTimestamp + "');";
  Trace(CRIERS, "Executing SQL: " + sSQL);
  SQLExecDirect(sSQL);  

}


void miCRDoShoutMessage(object oCrier = OBJECT_SELF)
{
  string sTimestamp = IntToString(gsTIGetActualTimestamp());
  string sInstance = GetLocalString(oCrier, INSTANCE);
  string sSQL = "SELECT message FROM micr_messages WHERE timestamp > '" +
               sTimestamp + "' and tag='" + sInstance + "' ORDER BY RAND() LIMIT 1;";
  Trace(CRIERS, "Database query: " + sSQL);

  SQLExecDirect(sSQL);

  if (SQLFetch())
  {
    string sMessage = SQLGetData(1);
    Trace(CRIERS, "Message to shout: " + sMessage);
    AssignCommand(oCrier, ActionSpeakString(sMessage));
  }
  else
  {
    Trace(CRIERS, "No message to shout for crier " + sInstance);
  }

  // Tidy up the database by purging old messages.
  SQLExecDirect("DELETE FROM micr_messages WHERE timestamp < '" + sTimestamp + "';");
}

void miCRDoShoutMessages()
{
  int nCount = 0;
  object oCrier = GetObjectByTag(MICR_TAG, nCount);

  while (GetIsObjectValid(oCrier))
  {
    Trace(CRIERS, "Got crier: " + GetName(oCrier));
    miCRDoShoutMessage(oCrier);
    nCount++;
    oCrier = GetObjectByTag(MICR_TAG, nCount);
  }
}

void miCRPurgeDatabase()
{
  string sSQL = "DELETE FROM micr_messages;";
  Trace(CRIERS, "Executing SQL: " + sSQL);
  SQLExecDirect(sSQL);
}

//void main(){}
