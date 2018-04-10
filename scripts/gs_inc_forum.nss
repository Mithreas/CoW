/* FORUM Library by Gigaschatten */

// Rewritten by Mithreas to use an external database.
/*
Removed:
//- create table gsfo_messages (player VARCHAR(32), tag VARCHAR(32), name VARCHAR(32), val VARCHAR(512)); -//
Added:
CREATE TABLE gsfo_messages (id INT(11) AUTO_INCREMENT, tag VARCHAR(64), message VARCHAR(16), owner VARCHAR(32) PRIMARY KEY(id));
CREATE INDEX forumid ON gsfo_messages(tag);
*/
#include "gs_inc_pc"
#include "mi_inc_database"

//void main() {};

const string FORUMS = "FORUMS"; // For logging

const int GS_FO_LIMIT = 35;
const string FORUM_TABLE = "gsfo_messages";

//load content of oForum from database
void gsFOLoadContent(object oForum = OBJECT_SELF);
//return message id at nPosition from oForum
string gsFOGetMessage(int nPosition = 0, object oForum = OBJECT_SELF);
//return position of first message at or after nPosition in oForum, return -1 if at end
int gsFOGetFirstMessage(int nPosition = 0, object oForum = OBJECT_SELF);
//internally used
int _gsFOGetFirstMessage(int nPosition, object oForum, int nStep = 1);
//return position of message following nPosition in oForum, return -1 if at end
int gsFOGetNextMessage(int nPosition = 0, object oForum = OBJECT_SELF);
//return position of message preceding nPosition in oForum, return -1 if at start
int gsFOGetPreviousMessage(int nPosition = 0, object oForum = OBJECT_SELF);
//return owner id of sMessageID from oForum
string gsFOGetOwner(string sMessageID, object oForum = OBJECT_SELF);
//return true on successfully posting sMessageID to oForum by oOwner
int gsFOPostMessage(string sMessageID, object oOwner, object oForum = OBJECT_SELF);
//remove sMessageID from oForum
void gsFORemoveMessage(string sMessageID, object oForum = OBJECT_SELF);

void gsFOLoadContent(object oForum = OBJECT_SELF)
{
    if (GetLocalInt(oForum, "GS_FO_OFFSET")) return; // Already loaded.

    string sTag       = GetTag(oForum);
    string sMessageID = "";
    int nNth          = 0;
    int nNumMessages  = 0;
    int nMin          = 0;
    int bFlag         = FALSE;

    // Start by deciding where to query from and to
    SQLExecStatement("SELECT COUNT(1) FROM gsfo_messages WHERE tag=?", sTag);
    SQLFetch();
    nNumMessages = StringToInt(SQLGetData(1));
    Trace(FORUMS, "Found " + IntToString(nNumMessages) + " messages for forum " + sTag);
    // No entries at all
    if (!nNumMessages) return;
    // Over the limit - introduce a lower boundary and make sure no more than
    // the limit number of results are returned.
    if (nNumMessages > GS_FO_LIMIT)
    {
        nMin = nNumMessages - GS_FO_LIMIT;
        nNumMessages = GS_FO_LIMIT;
        // @@@ TODO - add a DELETE FROM where tag= and id<min statement.
    }

    SQLExecStatement("SELECT message, owner FROM gsfo_messages WHERE tag=? ORDER BY " +
      "id LIMIT " + IntToString(nMin) + ", " + IntToString(nNumMessages), sTag);
    while (SQLFetch())
    {
        sMessageID = SQLGetData(1);
        if (sMessageID == "")
        {
            // There are clearly some inconsistencies in the database, so clean
            // them all up in one big swoop. Only do this once.
            if (!bFlag)
            {
                SQLExecStatement("DELETE FROM gsfo_messages WHERE message=''");
                bFlag = TRUE;
            }
            continue;
        }
        nNth++;
        SetLocalString(oForum, "GS_FO_MESSAGE_" + IntToString(nNth), sMessageID);
        SetLocalString(oForum, "GS_FO_" + sMessageID + "_OWNER", SQLGetData(2));
    }
    SetLocalInt(oForum, "GS_FO_OFFSET", nNth);
}
//----------------------------------------------------------------
string gsFOGetMessage(int nPosition = 0, object oForum = OBJECT_SELF)
{
    if (nPosition < 0)            return "";
    if (nPosition >= GS_FO_LIMIT) return "";

    nPosition = GetLocalInt(oForum, "GS_FO_OFFSET") - nPosition;
    if (nPosition < 1)            nPosition += GS_FO_LIMIT;

    return GetLocalString(oForum, "GS_FO_MESSAGE_" + IntToString(nPosition));
}
//----------------------------------------------------------------
int gsFOGetFirstMessage(int nPosition = 0, object oForum = OBJECT_SELF)
{
    return _gsFOGetFirstMessage(nPosition, oForum);
}
//----------------------------------------------------------------
int _gsFOGetFirstMessage(int nPosition, object oForum, int nStep = 1)
{
    string sMessageID = "";

    for (; nPosition >= 0 && nPosition < GS_FO_LIMIT; nPosition += nStep)
    {
        sMessageID = gsFOGetMessage(nPosition, oForum);
        if (sMessageID != "") return nPosition;
    }

    return -1;
}
//----------------------------------------------------------------
int gsFOGetNextMessage(int nPosition = 0, object oForum = OBJECT_SELF)
{
    return _gsFOGetFirstMessage(nPosition + 1, oForum);
}
//----------------------------------------------------------------
int gsFOGetPreviousMessage(int nPosition = 0, object oForum = OBJECT_SELF)
{
    return _gsFOGetFirstMessage(nPosition - 1, oForum, -1);
}
//----------------------------------------------------------------
string gsFOGetOwner(string sMessageID, object oForum = OBJECT_SELF)
{
    return GetLocalString(oForum, "GS_FO_" + sMessageID + "_OWNER");
}
//----------------------------------------------------------------
int gsFOPostMessage(string sMessageID, object oOwner, object oForum = OBJECT_SELF)
{
    // edit by Mith - make sure we've loaded the forum contents before
    // we add anything to it!
    gsFOLoadContent(oForum);
    string sNth      = "";
    int nNth         = 1;

    for (; nNth <= GS_FO_LIMIT; nNth++)
    {
        sNth = IntToString(nNth);
        if (GetLocalString(oForum, "GS_FO_MESSAGE_" + sNth) == sMessageID) return FALSE;
    }

    string sTag      = GetTag(oForum);
    string sPlayerID = gsPCGetPlayerID(oOwner);

    nNth             = GetLocalInt(oForum, "GS_FO_OFFSET") + 1;
    if (nNth > GS_FO_LIMIT) nNth -= GS_FO_LIMIT;
    sNth             = IntToString(nNth);

    SetLocalInt(oForum, "GS_FO_OFFSET", nNth);
    SetLocalString(oForum, "GS_FO_MESSAGE_" + sNth, sMessageID);
    SetLocalString(oForum, "GS_FO_" + sMessageID + "_OWNER", sPlayerID);

    Trace(FORUMS, "Adding message: "+sTag+","+sMessageID+","+sPlayerID);
    // Added by Fireboar
    SQLExecStatement("INSERT INTO gsfo_messages (tag, message, owner) VALUES (?, ?, ?)",
      sTag, sMessageID, sPlayerID);

    return TRUE;
}
//----------------------------------------------------------------
void gsFORemoveMessage(string sMessageID, object oForum = OBJECT_SELF)
{
    string sTag = GetTag(oForum);
    string sNth = "";
    int nNth    = 1;

    for (; nNth <= GS_FO_LIMIT; nNth++)
    {
        sNth = IntToString(nNth);

        if (GetLocalString(oForum, "GS_FO_MESSAGE_" + sNth) == sMessageID)
        {
            DeleteLocalString(oForum, "GS_FO_MESSAGE_" + sNth);
            SQLExecStatement("DELETE FROM gsfo_messages WHERE message=? AND TAG=? LIMIT 1", sMessageID, sTag);
            return;
        }
    }
}

