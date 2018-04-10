void main()
{
   object oPC = GetPCSpeaker();
   object oPool = OBJECT_SELF;

   object oHolyWater = GetObjectByTag("cnrHolyWater", 1);
   effect eVisual = EffectVisualEffect(VFX_IMP_GOOD_HELP, FALSE);

   AssignCommand(oPC, ActionCastFakeSpellAtObject(SPELL_BLESS, oPool, PROJECTILE_PATH_TYPE_DEFAULT));
   DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisual, oPool, 1.5));

   DecrementRemainingSpellUses(oPC, SPELL_BLESS);

   object oVial = GetItemPossessedBy(oPC, "cnrGlassVial");
   if (oVial != OBJECT_INVALID)
   {
      DestroyObject(oVial, 0.0);
      CreateItemOnObject("cnrHolyWater", oPC, 1);
   }
}
