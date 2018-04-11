#include "inc_werewolf"

void main()
{
  object oEntering = GetEnteringObject();

  if (GetIsPC(oEntering) && !GetIsDM(oEntering))
  {
    int nEffect = VFX_DUR_GHOST_TRANSPARENT;

    // Randomize alignment!
    int nAlignment;
    switch (d4())
    {
      case 1:
        nAlignment = GetAlignmentGoodEvil(oEntering);
        break;
      case 2:
        nAlignment = ALIGNMENT_GOOD;
        break;
      case 3:
        nAlignment = ALIGNMENT_NEUTRAL;
        break;
      case 4:
        nAlignment = ALIGNMENT_EVIL;
        break;
    }

    switch (nAlignment)
    {
      case ALIGNMENT_GOOD:
        nEffect = VFX_DUR_GLOW_LIGHT_BLUE;
        break;

      case ALIGNMENT_NEUTRAL:
        nEffect = VFX_DUR_GLOW_GREY;
        break;

      case ALIGNMENT_EVIL:
        nEffect = VFX_DUR_GLOW_RED;
        break;
    }

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(nEffect),
     oEntering);

    // Addition by Fireboar
    if (GetLocalInt(oEntering, "MI_AWIA_ACTIVE"))
    {
      miAWRemoveWolfEffects(oEntering);
      DeleteLocalInt(oEntering, "MI_AWIA_ACTIVE");
    }
  }
  //ExploreAreaForPlayer(GetArea(OBJECT_SELF), oEntering, TRUE);
  ExecuteScript("gs_a_enter", OBJECT_SELF);
}
