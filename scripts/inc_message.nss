/* MESSAGE Library by Gigaschatten */

// Reworked to use an external database by Mithreas
// And reworked again to use a more efficient external database by Fireboar
//
// Database table:
/*
Removed:
//- create table gsme_messages (player VARCHAR(32), tag VARCHAR(32), name VARCHAR(32), val VARCHAR(512)); -//
Added:
CREATE TABLE gsme_messages (id VARCHAR(16), timestamp INT(12), title VARCHAR(64), text1 VARCHAR(512), text2 VARCHAR(512), text3 VARCHAR(512), text4 VARCHAR(512), author VARCHAR(256), real_author VARCHAR(256), anonymous TINYINT(1));
CREATE INDEX msgid ON gsme_messages(id);

NOTE: These two queries will be executed automatically when fb_migrate is run.
The existing data will be moved across.
*/

#include "inc_common"
#include "inc_pc"
#include "inc_text"
#include "inc_time"
#include "inc_database"

const string GS_MESSAGE = "gsme_messages";

//void main() {}

//set sMessageID to sText by oAuthor described by sTitle
void gsMESetMessage(string sMessageID, string sTitle, string sText1, string sText2 = "", string sText3 = "", string sText4 = "", object oAuthor = OBJECT_SELF, int bAnonymous = FALSE);
// set sMessageID to sText by sAuthor described by sTitle
void gsMEForgeMessage(string sMessageID, string sTitle, string sText1, string sText2, string sText3, string sText4, string sAuthor, string sRealAuthor, int bAnonymous = FALSE);
//return timestamp from sMessageID
int gsMEGetTimestamp(string sMessageID);
//return title from sMessageID
string gsMEGetTitle(string sMessageID);
//return text1 from sMessageID
string gsMEGetText1(string sMessageID);
//return text2 from sMessageID
string gsMEGetText2(string sMessageID);
//return text3 from sMessageID
string gsMEGetText3(string sMessageID);
//return text4 from sMessageID
string gsMEGetText4(string sMessageID);
//return author from sMessageID
string gsMEGetAuthor(string sMessageID);
//return whether or not this message is anonymous
int gsMEGetAnonymous(string sMessageID);
//return author from sMessageID
string gsMEGetRealAuthor(string sMessageID);
//return formatted sMessageID
string gsMEGetMessage(string sMessageID, object oReader);
// Loads the message info into our cache of the database (saving lots of
// database reads).  Returns the cache object with all vars set locally.
object gsMELoadMessage(string sMessageID);
object gsMELoadMessage(string sMessageID)
{
    object oCache = miDAGetCacheObject("GSME_MESSAGES");

    if (!GetLocalInt(oCache, sMessageID + "LOADED"))
    {
        SQLExecDirect("SELECT timestamp, title, text1, text2, text3, text4, author, real_author, anonymous FROM gsme_messages WHERE id='"+SQLEncodeSpecialChars(sMessageID)+"' LIMIT 1");
        if (!SQLFetch()) return oCache;
        SetLocalInt(oCache, sMessageID+"TIMESTAMP", StringToInt(SQLGetData(1)));
        SetLocalString(oCache, sMessageID+"TITLE", SQLGetData(2));
        SetLocalString(oCache, sMessageID+"TEXT1", SQLGetData(3));
        SetLocalString(oCache, sMessageID+"TEXT2", SQLGetData(4));
        SetLocalString(oCache, sMessageID+"TEXT3", SQLGetData(5));
        SetLocalString(oCache, sMessageID+"TEXT4", SQLGetData(6));
        SetLocalString(oCache, sMessageID+"AUTHOR", SQLGetData(7));
        SetLocalString(oCache, sMessageID+"REAL_AUTHOR", SQLGetData(8));
        SetLocalInt(oCache, sMessageID+"ANONYMOUS", StringToInt(SQLGetData(9)));
        SetLocalInt(oCache, sMessageID+"LOADED", TRUE);
    }

    return oCache;
}

void gsMESetMessage(string sMessageID, string sTitle, string sText1, string sText2 = "", string sText3 = "", string sText4 = "", object oAuthor = OBJECT_SELF, int bAnonymous = FALSE)
{
    gsMEForgeMessage(sMessageID, sTitle, sText1, sText2, sText3, sText4, GetName(oAuthor), GetName(oAuthor), bAnonymous);
}

void gsMEForgeMessage(string sMessageID, string sTitle, string sText1, string sText2, string sText3, string sText4, string sAuthor, string sRealAuthor, int bAnonymous = FALSE)
{
    sMessageID = SQLEncodeSpecialChars(GetStringLeft(sMessageID, 16));
    string sTimestamp = IntToString(gsTIGetActualTimestamp());
    sTitle = SQLEncodeSpecialChars(sTitle);
    sText1 = SQLEncodeSpecialChars(sText1);
    sText2 = SQLEncodeSpecialChars(sText2);
    sText3 = SQLEncodeSpecialChars(sText3);
    sText4 = SQLEncodeSpecialChars(sText4);
    sAuthor = SQLEncodeSpecialChars(sAuthor);
    sRealAuthor = SQLEncodeSpecialChars(sRealAuthor);
    string sAnon = IntToString(bAnonymous);

    SQLExecDirect("INSERT INTO gsme_messages (id, timestamp, title, text1, text2, text3, text4, author, real_author, anonymous) "+
        "VALUES ('"+sMessageID+"', '"+sTimestamp+"', '"+sTitle+"', '"+sText1+"', '"+sText2+"', '"+sText3+"', '"+sText4+"', '"+sAuthor+"', '" + sRealAuthor + "', '"+sAnon+"')");
}
//----------------------------------------------------------------
int gsMEGetTimestamp(string sMessageID)
{
    object oCache = gsMELoadMessage(sMessageID);

    return GetLocalInt(oCache, sMessageID+"TIMESTAMP");
}
//----------------------------------------------------------------
string gsMEGetTitle(string sMessageID)
{
    object oCache = gsMELoadMessage(sMessageID);

    return GetLocalString(oCache, sMessageID+"TITLE");
}
//----------------------------------------------------------------
string gsMEGetText1(string sMessageID)
{
    object oCache = gsMELoadMessage(sMessageID);

    return GetLocalString(oCache, sMessageID+"TEXT1");
}
//----------------------------------------------------------------
string gsMEGetText2(string sMessageID)
{
    object oCache = gsMELoadMessage(sMessageID);

    return GetLocalString(oCache, sMessageID+"TEXT2");
}
//----------------------------------------------------------------
string gsMEGetText3(string sMessageID)
{
    object oCache = gsMELoadMessage(sMessageID);

    return GetLocalString(oCache, sMessageID+"TEXT3");
}
//----------------------------------------------------------------
string gsMEGetText4(string sMessageID)
{
    object oCache = gsMELoadMessage(sMessageID);

    return GetLocalString(oCache, sMessageID+"TEXT4");
}
//----------------------------------------------------------------
string gsMEGetAuthor(string sMessageID)
{
    object oCache = gsMELoadMessage(sMessageID);

    return GetLocalString(oCache, sMessageID+"AUTHOR");
}
//----------------------------------------------------------------
string gsMEGetRealAuthor(string sMessageID)
{
    object oCache = gsMELoadMessage(sMessageID);

    return GetLocalString(oCache, sMessageID+"REAL_AUTHOR");
}
//----------------------------------------------------------------
int gsMEGetAnonymous(string sMessageID)
{
    object oCache = gsMELoadMessage(sMessageID);

    return GetLocalInt(oCache, sMessageID+"ANONYMOUS");
}
//----------------------------------------------------------------
string gsMEGetMessage(string sMessageID, object oReader)
{

    string sString = gsMEGetTitle(sMessageID);

    if (sString != "")
    {
        int nTimestamp = gsMEGetTimestamp(sMessageID);

        return "<cþë¦>" + sString + "\n" +
               "<câÛÂ>" + gsMEGetText1(sMessageID) + "\n" +
                 gsMEGetText2(sMessageID) + "\n" +
                  gsMEGetText3(sMessageID) + "\n" +
                   gsMEGetText4(sMessageID) + "\n\n" +
               "<c(”þ>        " +
               gsCMReplaceString(GS_T_16777426,
                                 IntToString(gsTIGetHour(nTimestamp)),
                                 IntToString(gsTIGetDay(nTimestamp)),
                                 IntToString(gsTIGetMonth(nTimestamp)),
                                 IntToString(gsTIGetYear(nTimestamp))) + "\n" +
               "<c(”þ>        " +
               (gsMEGetAnonymous(sMessageID) ? "Anonymous" : gsMEGetAuthor(sMessageID)) +
               (GetIsDM(oReader) ? "\nReal Author: " + gsMEGetRealAuthor(sMessageID) : "");
    }

    return "";
}

