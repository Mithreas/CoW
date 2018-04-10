void main()
{
    int nID = GetLocalInt(OBJECT_SELF, "GS_OFFSET_2") - 5;

    if (nID < 0) nID = 0;

    SetLocalInt(OBJECT_SELF, "GS_OFFSET_2", nID);
}
