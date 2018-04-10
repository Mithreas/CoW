const int GS_SLOT = 3;

void main()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_PL_OFFSET") + GS_SLOT;
    nNth     = GetLocalInt(OBJECT_SELF, "GS_PL_SLOT_" + IntToString(nNth));

    SetLocalInt(OBJECT_SELF, "GS_PL_SLOT", nNth);
}
