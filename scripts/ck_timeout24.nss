#include "inc_time"
int StartingConditional()
{
  // checks if the local GVD_TIMESTAMP variable is past for 24 hours realtime
  object oModule     = GetModule();
  int iTimestamp = GetLocalInt(oModule, "GS_TIMESTAMP");
  int iTimestampObject = GetLocalInt(OBJECT_SELF,"GVD_TIMESTAMP");

  // dunshine, fixed for epoch clock reset, where timeout will be bigger then actual timestamp, we'll just allow it in that rare case  
  if ((gsTIGetDay(iTimestamp - iTimestampObject) > 4) || (iTimestampObject > iTimestamp)) {
    return TRUE;
  } else {
    return FALSE;
  }

}
