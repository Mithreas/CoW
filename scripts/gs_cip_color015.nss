void main()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_OFFSET") - 5;

    if (nNth < 0) nNth = 0;

    SetLocalInt(OBJECT_SELF, "GS_OFFSET", nNth);
}
