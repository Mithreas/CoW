int StartingConditional()
{
    string sString = GetLocalString(OBJECT_SELF, "GS_ME_TEXT_4");

    if (sString != "")
    {
        SetCustomToken(100, GetLocalString(OBJECT_SELF, "GS_ME_TITLE"));
        SetCustomToken(101, GetLocalString(OBJECT_SELF, "GS_ME_TEXT_1"));
        SetCustomToken(102, GetLocalString(OBJECT_SELF, "GS_ME_TEXT_2"));
        SetCustomToken(103, GetLocalString(OBJECT_SELF, "GS_ME_TEXT_3"));
        SetCustomToken(104, sString);
        return TRUE;
    }

    return FALSE;
}
