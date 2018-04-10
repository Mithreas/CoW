/* OnEnter script for the epic abjurer's ward. Paralyses creatures for one
second per caster level if they fail a Will save. Doubled if caster has the
extend spell metamagic feat. */
void main()
{
  object oCreature = GetEnteringObject();
  if (GetCutsceneMode(oCreature)) return;
  object oForbidding = GetNearestObjectByTag("abjurer_ward");
  int nDC;
  float fDuration;
  object oCaster;
  if (oForbidding == OBJECT_INVALID)
  {
    // Oops. Use some reasonable defaults.
    nDC = 18;
    fDuration = 6.0;
    oCaster = GetFirstPC();
  }
  else
  {
    fDuration = GetLocalFloat(oForbidding, "Duration");
    nDC       = GetLocalInt(oForbidding, "DC");
    oCaster   = GetLocalObject(oForbidding, "Caster");

    if (!GetIsObjectValid(oCaster)) oCaster = GetFirstPC();
  }

  if(GetIsReactionTypeHostile(oCreature, oCaster) && !WillSave(oCreature, nDC))
  {
    AssignCommand(oCreature, ClearAllActions());
    //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectParalyze(), oCreature, fDuration);
    effect eDur1 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
    effect eLink = EffectLinkEffects(EffectParalyze(), eDur1);
    eLink = EffectLinkEffects(eLink, eDur2);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCreature, fDuration);
  }

  // And zap them for entering.
  if(GetIsReactionTypeHostile(oCreature, oCaster))
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        EffectVisualEffect(VFX_DUR_DEATH_ARMOR),
                        oCreature,
                        1.0);
}
