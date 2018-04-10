const int GS_SLOT = 10;

void main()
{
    int nNth = GetLocalInt(OBJECT_SELF, "GS_EN_OFFSET") + GS_SLOT;
    nNth     = GetLocalInt(OBJECT_SELF, "GS_EN_SLOT_" + IntToString(nNth));

    SetLocalInt(OBJECT_SELF, "GS_EN_SLOT", nNth);
}
