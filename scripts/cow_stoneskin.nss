// Adds the stoneskin visual effect to a placeable the first time it is called,
// then sets a marker to ensure it doesn't execute again.
void main()
{
  if (!GetLocalInt(OBJECT_SELF, "stoneskinned"))
  {
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        EffectVisualEffect(VFX_DUR_PROT_STONESKIN),
                        OBJECT_SELF);
    SetLocalInt(OBJECT_SELF, "stoneskinned", 1);
  }
}
