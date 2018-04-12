#include "inc_area"
//----------------------------------------------------------------
void gsRun()
{
    object oArea       = GetArea(OBJECT_SELF);

    if (! gsARGetIsAreaActive(oArea))
    {
        DeleteLocalInt(OBJECT_SELF, "GS_ENABLED");
        return;
    }

    if (d3() == 1)
    {
      // Zap the tower.
      object oSource = GetObjectByTag("UDPT_NODE_13");
      object oDest   = GetObjectByTag("UDPT_NODE_14");

      DelayCommand(1.0,
                   AssignCommand(oSource,
                                 ActionCastSpellAtObject(SPELL_RAY_OF_FROST,
                                                         oDest,
                                                         METAMAGIC_ANY,
                                                         TRUE,
                                                         5,
                                                         PROJECTILE_PATH_TYPE_DEFAULT,
                                                         FALSE    )));

    }
    DelayCommand(30.0, gsRun());
}
//----------------------------------------------------------------
void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    gsRun();
}
