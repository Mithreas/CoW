#include "gs_inc_text"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    if (! GetIsPC(oSpeaker)) return FALSE;
    object oTarget  = GetLocalObject(OBJECT_SELF, "GS_TARGET");

    if (GetIsObjectValid(oTarget))
    {
        SetCustomToken(100, GetName(oTarget));
        return TRUE;
    }

    FloatingTextStringOnCreature(GS_T_16777456, oSpeaker, FALSE);
    DestroyObject(OBJECT_SELF);
    return FALSE;
}
