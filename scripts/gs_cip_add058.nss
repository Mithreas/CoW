void main()
{
    //slot 5

    int nID1    = GetLocalInt(OBJECT_SELF, "GS_OFFSET_4") + 4;
    int nID2    = GetLocalInt(OBJECT_SELF, "GS_SLOT_5_ID");
    int nStrRef = GetLocalInt(OBJECT_SELF, "GS_SLOT_5_STRREF");

    SetLocalInt(OBJECT_SELF, "GS_PARAM", nID1);
    SetLocalInt(OBJECT_SELF, "GS_PARAM_ID", nID2);
    SetLocalInt(OBJECT_SELF, "GS_PARAM_STRREF", nStrRef);
}
