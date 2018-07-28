void main()
{
    //slot 3

    int nID1    = GetLocalInt(OBJECT_SELF, "GS_OFFSET_4") + 2;
    int nID2    = GetLocalInt(OBJECT_SELF, "GS_SLOT_3_ID");
    int nStrRef = GetLocalInt(OBJECT_SELF, "GS_SLOT_3_STRREF");

    SetLocalInt(OBJECT_SELF, "GS_PARAM", nID1);
    SetLocalInt(OBJECT_SELF, "GS_PARAM_ID", nID2);
    SetLocalInt(OBJECT_SELF, "GS_PARAM_STRREF", nStrRef);
}
