void main()
{
    int nID = GetLocalInt(OBJECT_SELF, "GS_OFFSET_4") + 5;

    SetLocalInt(OBJECT_SELF, "GS_OFFSET_4", nID);
}
