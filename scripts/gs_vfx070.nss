#include "gs_inc_area"
//----------------------------------------------------------------
int miGetNextTarget(int nSource, int nDirection)
{
  int nDest = nSource - 1; // default
  if (nDirection)
  {
    switch (nSource)
    {
      case 1:
        nDest = 9;
        break;
      case 2:
        nDest = 10;
        break;
      case 3:
        nDest = 10;
        break;
      case 4:
        nDest = 11;
        break;
      case 5:
        nDest = 11;
        break;
      case 6:
        nDest = 12;
        break;
      case 7:
        nDest = 12;
        break;
      case 8:
        nDest = 9;
        break;
      case 9:
        nDest = 2;
        break;
      case 10:
        nDest = 4;
        break;
      case 11:
        nDest = 6;
        break;
      case 12:
        nDest = 8;
        break;
    }
  }
  else
  {
    switch (nSource)
    {
      case 1:
        nDest = 12;
        break;
      case 2:
        nDest = 9;
        break;
      case 3:
        nDest = 9;
        break;
      case 4:
        nDest = 10;
        break;
      case 5:
        nDest = 10;
        break;
      case 6:
        nDest = 11;
        break;
      case 7:
        nDest = 11;
        break;
      case 8:
        nDest = 12;
        break;
      case 9:
        nDest = 1;
        break;
      case 10:
        nDest = 3;
        break;
      case 11:
        nDest = 5;
        break;
      case 12:
        nDest = 7;
        break;
    }
  }

  return (nDest);
}
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
      // Fire up the zappy stuff.
      int nCount = d6();
      int nSource = d12();
      int nDirection = d2() - 1;
      int nDest = miGetNextTarget(nSource, nDirection);
      float fDelay = IntToFloat(Random(30));

      for (nCount; nCount > 0; nCount--)
      {
        if (nDest == 13) nDest = 1;
        object oSource = GetObjectByTag("UDPT_NODE_" + IntToString(nSource));
        object oDest   = GetObjectByTag("UDPT_NODE_" + IntToString(nDest));

        DelayCommand(fDelay,
                   AssignCommand(oSource,
                                 ActionCastSpellAtObject(SPELL_RAY_OF_FROST,
                                                         oDest,
                                                         METAMAGIC_ANY,
                                                         TRUE,
                                                         5,
                                                         PROJECTILE_PATH_TYPE_DEFAULT,
                                                         FALSE    )));

        nSource = nDest;
        nDest = miGetNextTarget(nSource, nDirection);
        fDelay += 0.2;
      }
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
