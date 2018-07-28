void main()
{
    int nID = GetLocalInt(OBJECT_SELF, "GS_OFFSET_1") + 5;

    SetLocalInt(OBJECT_SELF, "GS_OFFSET_1", nID);
}
