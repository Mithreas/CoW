#include "gs_inc_common"

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    int bStaticLevel        = GetLocalInt(GetModule(), "STATIC_LEVEL");
    int nType = GetLocalInt(OBJECT_SELF, "GS_TYPE");
    string sTemplate = gsCMGetTemplateByType(nType);

    object oTreasure = CreateObject(OBJECT_TYPE_PLACEABLE, sTemplate, GetLocation(OBJECT_SELF));

    int nDC = 0;
    if(!bStaticLevel)
    {

        if(nType == 1 || nType == 5 || nType == 9) //low
            nDC = 25;
        else if(nType == 2 || nType == 6 || nType == 10) //medium
            nDC = 50;
        else if(nType == 3 || nType == 7 || nType == 11)
            nDC = 75;

       if(d100() > nDC && nDC > 0)
       {
          SetTrapActive(oTreasure, FALSE);
          SetTrapDetectable(oTreasure, FALSE);

       }
    }

    if(nDC > 0)
        SetLocalInt(oTreasure, "md_lockcontrolled", 1);

    if ((bStaticLevel && d6() > 3) || (nDC != 0 && d100() > nDC))
    {
      SetLocked(oTreasure, FALSE);
    }

    if (bStaticLevel)
    {
       SetLockLockDC(oTreasure, bStaticLevel + 10 + d20());
       SetTrapDetectDC(oTreasure, bStaticLevel + 10 + d20());
       SetTrapDisarmDC(oTreasure, bStaticLevel + 10 + d20());
    }

    DestroyObject(OBJECT_SELF);
}
