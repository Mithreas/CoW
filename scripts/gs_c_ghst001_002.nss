#include "inc_common"
#include "inc_flag"
#include "inc_time"
#include "inc_xp"

void main()
{
    gsXPDistributeExperience(GetPCSpeaker(), 25);
    gsCMDestroyObject();

    if (! gsFLGetFlag(GS_FL_MORTAL))
        gsCMCreateRecreatorAtLocation(GetLocalLocation(OBJECT_SELF, "GS_LOCATION"),
                                      gsTIGetActualTimestamp() + 43200);
}
