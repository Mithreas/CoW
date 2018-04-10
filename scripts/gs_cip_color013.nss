void main()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_OFFSET");

    SetLocalInt(OBJECT_SELF, "GS_OFFSET", nNth + 5);
}
