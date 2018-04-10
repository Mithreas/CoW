// mi_initnation
// See mi_inc_citizen for details.
#include "mi_inc_factions"
void CreateSettlementFaction(string sNation)
{
  fbFACreateFaction(sNation, OBJECT_INVALID, SETTLEMENT_PREFIX, sNation, FAC_NATION);
}
void main()
{
  string sNation  = GetLocalString(OBJECT_SELF, VAR_NATION);
  string sLeader  = GetLocalString(OBJECT_SELF, "MI_NATION_LEADER");
  int nNumLeaders = GetLocalInt(OBJECT_SELF, "MI_NATION_NUM_LEADERS");

  if (sNation != "" && sLeader != "" && nNumLeaders > 0)
  {
    Trace(CITIZENSHIP, "Initialising nation: " + sNation);
    miCZCreateNation(sNation, sLeader, nNumLeaders);
  }

  //Set up the faction. Do it through asign command to both
  //avoid TMI and have it happen sequentially.
  object oModule = GetModule();
  AssignCommand(oModule, CreateSettlementFaction(sNation));

  DestroyObject(OBJECT_SELF);
}
