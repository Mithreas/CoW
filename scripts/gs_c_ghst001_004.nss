#include "gs_inc_common"
#include "gs_inc_flag"
#include "gs_inc_time"
#include "gs_inc_xp"

void main()
{
    object oSpeaker = GetPCSpeaker();

    //AdjustAlignment(oSpeaker, ALIGNMENT_GOOD, 5);
    gsXPDistributeExperience(oSpeaker, 50);
    gsCMDestroyObject();

    if (! gsFLGetFlag(GS_FL_MORTAL))
        gsCMCreateRecreatorAtLocation(GetLocalLocation(OBJECT_SELF, "GS_LOCATION"),
                                      gsTIGetActualTimestamp() + 43200);
}
