#include "gs_inc_subrace"
#include "mi_inc_backgr"
#include "ar_utils"


int StartingConditional()
{
    int bUDRestrict = GetLocalInt(OBJECT_SELF, "AR_UD_RESTRICT");
    object oPC      = GetPCSpeaker();

    if ( bUDRestrict && !ar_IsUDCharacter(oPC, TRUE) )
        return TRUE;

    return FALSE;
}
