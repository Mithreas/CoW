void main()
{
    int nID = GetLocalInt(OBJECT_SELF, "GS_OFFSET_3") + 5;

    SetLocalInt(OBJECT_SELF, "GS_OFFSET_3", nID);
}
