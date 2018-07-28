void main()
{
    //slot 3

    int nID1    = GetLocalInt(OBJECT_SELF, "GS_OFFSET_1") + 2;
    int nID2    = GetLocalInt(OBJECT_SELF, "GS_SLOT_3_ID");
    int nStrRef = GetLocalInt(OBJECT_SELF, "GS_SLOT_3_STRREF");

    SetLocalInt(OBJECT_SELF, "GS_PROPERTY", nID1);
    SetLocalInt(OBJECT_SELF, "GS_PROPERTY_ID", nID2);
    SetLocalInt(OBJECT_SELF, "GS_PROPERTY_STRREF", nStrRef);
    DeleteLocalInt(OBJECT_SELF, "GS_OFFSET_2");
    DeleteLocalInt(OBJECT_SELF, "GS_OFFSET_3");
    DeleteLocalInt(OBJECT_SELF, "GS_OFFSET_4");
}
