void main()
{
    //slot 1

    int nID1    = GetLocalInt(OBJECT_SELF, "GS_OFFSET_2");
    int nID2    = GetLocalInt(OBJECT_SELF, "GS_SLOT_1_ID");
    int nStrRef = GetLocalInt(OBJECT_SELF, "GS_SLOT_1_STRREF");

    SetLocalInt(OBJECT_SELF, "GS_SUBTYPE", nID1);
    SetLocalInt(OBJECT_SELF, "GS_SUBTYPE_ID", nID2);
    SetLocalInt(OBJECT_SELF, "GS_SUBTYPE_STRREF", nStrRef);
    DeleteLocalInt(OBJECT_SELF, "GS_OFFSET_3");
    DeleteLocalInt(OBJECT_SELF, "GS_OFFSET_4");
}
