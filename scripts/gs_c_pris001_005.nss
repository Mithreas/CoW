#include "gs_inc_common"
#include "gs_inc_flag"
#include "gs_inc_time"
#include "gs_inc_xp"

void main()
{
    gsXPDistributeExperience(GetPCSpeaker(), 25);
    gsCMDestroyObject();

    if (! gsFLGetFlag(GS_FL_MORTAL)) 
        gsCMCreateRecreatorAtLocation(GetLocalLocation(OBJECT_SELF, "GS_LOCATION"),
                                      gsTIGetActualTimestamp() + 43200);
}
