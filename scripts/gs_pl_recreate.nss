#include "gs_inc_common"
#include "gs_inc_time"

const int GS_TIMEOUT = 7200; //2 hours

void main()
{
    gsCMCreateRecreator(gsTIGetActualTimestamp() + GS_TIMEOUT);
}
