void main()
{
    object oCaptain     = GetObjectByTag("aas_captain");
    int iTimer          = GetLocalInt(oCaptain, "liTimer");
    string sTokenText   = FloatToString(IntToFloat(iTimer) * 4, 2, 0) + " minutes.";

    SetCustomToken(301, sTokenText);
}
