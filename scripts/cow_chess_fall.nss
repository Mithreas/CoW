void main()
{
   object oPC = GetEnteringObject();
   int nLevel = GetLevelByPosition(1, oPC) +GetLevelByPosition(2, oPC) +
                         GetLevelByPosition(3, oPC);
   int nDamage = d6(nLevel);

   AssignCommand(oPC, JumpToLocation(GetLocation(GetObjectByTag("WP_chess_fall"))));
   AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 2.0));
   effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);
}
