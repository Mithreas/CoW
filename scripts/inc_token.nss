/* TOKEN Library by Gigaschatten */

//void main() {}

//set token nNth to value sString on caller
void gsTKSetToken(int nNth, string sString);
//load token nNth to caller
void gsTKRecallToken(int nNth);

void gsTKSetToken(int nNth, string sString)
{
    string sNth = IntToString(nNth);

    SetLocalString(OBJECT_SELF, "GS_TK_" + sNth, sString);
}
//----------------------------------------------------------------
void gsTKRecallToken(int nNth)
{
    string sNth    = IntToString(nNth);
    string sString = GetLocalString(OBJECT_SELF, "GS_TK_" + sNth);

    SetCustomToken(nNth, sString);
}
