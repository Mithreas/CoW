#include "inc_common"
#include "inc_flag"
#include "inc_time"
#include "inc_xp"

void main()
{
    object oSpeaker = GetPCSpeaker();

    //AdjustAlignment(oSpeaker, ALIGNMENT_GOOD, 5);
    gsXPDistributeExperience(oSpeaker, 50);
    gsCMDestroyObject();

    if (! gsFLGetFlag(GS_FL_MORTAL))
        gsCMCreateRecreatorAtLocation(GetLocalLocation(OBJECT_SELF, "GS_LOCATION"),
                                      gsTIGetActualTimestamp() + (60 * 60));
}
