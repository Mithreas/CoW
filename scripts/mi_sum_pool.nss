void main()
{
  int nSpell = GetLastSpell();
  object oPC = GetLastSpellCaster();

  if (nSpell == SPELL_PLANAR_ALLY ||
      nSpell == SPELL_PLANAR_BINDING ||
      nSpell == SPELL_LESSER_PLANAR_BINDING ||
      nSpell == SPELL_GREATER_PLANAR_BINDING)
  {
    // Summon henchman
    object oDemon = CreateObject(OBJECT_TYPE_CREATURE,
                                 "ar_cr_ghour001",
                                 GetLocation(OBJECT_SELF),
                                 TRUE);

    AddHenchman(oPC, oDemon);
  }
}
