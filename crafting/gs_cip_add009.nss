void main()
{
    int nID = GetLocalInt(OBJECT_SELF, "GS_OFFSET_1") - 5;

    if (nID < 0) nID = 0;

    SetLocalInt(OBJECT_SELF, "GS_OFFSET_1", nID);
}
