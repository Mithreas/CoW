void main()
{
    int nID = GetLocalInt(OBJECT_SELF, "GS_OFFSET_2") + 5;

    SetLocalInt(OBJECT_SELF, "GS_OFFSET_2", nID);
}
