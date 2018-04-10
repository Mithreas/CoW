int StartingConditional()
{
    string sString = GetLocalString(OBJECT_SELF, "GS_ME_TEXT_1");

    DeleteLocalString(OBJECT_SELF, "GS_ME_TEXT_2");
    DeleteLocalString(OBJECT_SELF, "GS_ME_TEXT_3");
    DeleteLocalString(OBJECT_SELF, "GS_ME_TEXT_4");

    if (sString != "")
    {
        SetCustomToken(100, GetLocalString(OBJECT_SELF, "GS_ME_TITLE"));
        SetCustomToken(101, sString);
        return TRUE;
    }

    return FALSE;
}
