/* TORTURE Library by Gigaschatten */

//void main() {}

#include "inc_ai"
#include "inc_flag"
#include "inc_time"

const int GS_TO_TIMEOUT = 12;

//set torture state for oCreature
void gsTODoTorture(object oCreature);
//return TRUE if oCreature is in torture state
int gsTOGetIsTortured(object oCreature = OBJECT_SELF);

void gsTODoTorture(object oCreature)
{
    int nTimeout = gsTIGetActualTimestamp() +
                   gsTIGetGameTimestamp(GS_TO_TIMEOUT);

    if (! GetLocalInt(oCreature, "GS_TO_ENABLED"))
    {
        SetLocalInt(
            oCreature,
            "GS_TO_IMMORTAL",
            GetImmortal(oCreature));
        SetLocalInt(
            oCreature,
            "GS_TO_DISABLE_COMBAT",
            gsFLGetFlag(GS_FL_DISABLE_COMBAT, oCreature));
        SetLocalInt(
            oCreature,
            "GS_TO_ACTION_MATRIX",
            gsAIGetActionMatrix(oCreature));

        AssignCommand(oCreature, ClearAllActions(TRUE));
        SetImmortal(oCreature, TRUE);
        gsFLSetFlag(GS_FL_DISABLE_COMBAT, oCreature);
        gsAIClearActionMatrix(oCreature);

        SetLocalInt(oCreature, "GS_TO_ENABLED", TRUE);
    }

    SetLocalInt(oCreature, "GS_TO_TIMEOUT", nTimeout);
}
//----------------------------------------------------------------
int gsTOGetIsTortured(object oCreature = OBJECT_SELF)
{
    if (gsTIGetActualTimestamp() > GetLocalInt(oCreature, "GS_TO_TIMEOUT"))
    {
        if (GetLocalInt(oCreature, "GS_TO_ENABLED"))
        {
            AssignCommand(oCreature, ClearAllActions(TRUE));
            SetImmortal(
                oCreature,
                GetLocalInt(oCreature, "GS_TO_IMMORTAL"));
            gsFLSetFlag(
                GS_FL_DISABLE_COMBAT,
                oCreature,
                GetLocalInt(oCreature, "GS_TO_DISABLE_COMBAT"));
            gsAISetActionMatrix(
                GetLocalInt(oCreature, "GS_TO_ACTION_MATRIX"),
                TRUE,
                oCreature);

            DeleteLocalInt(oCreature, "GS_TO_ENABLED");
            DeleteLocalInt(oCreature, "GS_TO_TIMEOUT");
            DeleteLocalInt(oCreature, "GS_TO_IMMORTAL");
            DeleteLocalInt(oCreature, "GS_TO_DISABLE_COMBAT");
            DeleteLocalInt(oCreature, "GS_TO_ACTION_MATRIX");
        }

        return FALSE;
    }

    return TRUE;
}
