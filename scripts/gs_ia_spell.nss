void main()
{
    object oUser = GetLastUsedBy();
    int nSpell   = GetLocalInt(OBJECT_SELF, "GS_SPELL");

    ActionCastSpellAtObject(nSpell, oUser, METAMAGIC_ANY, TRUE, 20);
}
