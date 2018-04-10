#include "gs_inc_container"
#include "mi_log"

void _save(object oPC)
{
  string sTag = GetTag(OBJECT_SELF);
  int nLimit  = GetLocalInt(OBJECT_SELF, "GS_LIMIT");
  struct gsCOResults stResults;

  if (! nLimit) nLimit = GS_LIMIT_DEFAULT;

  stResults = gsCOSave(sTag, OBJECT_SELF, nLimit);
  SendMessageToPC(oPC, "<c þ >" + IntToString(stResults.nSaved) + " items saved. " +
     "This chest has a limit of " + IntToString(nLimit) + " items.");
  if (stResults.nOverflowed) {
    SendMessageToPC(oPC, "<cþ  >Warning: " + IntToString(stResults.nOverflowed) +
       " items were NOT saved.");
  }
  if (stResults.nGold)
  {
    GiveGoldToCreature(oPC, stResults.nGold);
    SendMessageToPC(oPC, "<cþN >Note: you can not store gold in these chests.");
  }

  Log(CO, GetName(oPC) + " accessed chest " + sTag +
     " and left " + IntToString(stResults.nSaved) + " stored.");
}

void main()
{
    // Edit by Mithreas: report number of items saved and log.
    // NB: Delay by 0.5s to prevent an exploit.
    // --[
    DelayCommand(0.5, _save(GetLastClosedBy()));
    // ]--
}
