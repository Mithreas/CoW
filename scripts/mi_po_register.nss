#include "mi_inc_pop"
void main()
{
  if (GetLocalInt(OBJECT_SELF, "GS_ACTIVE")) return;
  SetLocalInt(OBJECT_SELF, "GS_ACTIVE", TRUE);

  string sTag = GetTag(OBJECT_SELF);
  int nRate   = GetLocalInt(OBJECT_SELF, VAR_RATE);
  SetLocalString(GetArea(OBJECT_SELF), VAR_POP, sTag);

  int bMaster = GetLocalInt(OBJECT_SELF, VAR_PO_MASTER);

  if (!bMaster) return;

  SetLocalObject(GetModule(), sTag, GetArea(OBJECT_SELF));
  gsENLoadArea(GetArea(OBJECT_SELF));

  SQLExecStatement("SELECT rate FROM mipo_populations WHERE tag=?", sTag);

  if (SQLFetch()) // Population already exists.
  {
    // Let the module be the master so builders can control it.
    int nCurrentRate = StringToInt(SQLGetData(1));
    if (nRate != nCurrentRate)
    {
      SQLExecStatement("UPDATE mipo_populations SET rate=? WHERE tag=?",
                          IntToString(nRate), sTag);
    }

    miPOActivateAreas(sTag);
  }
  else   // New population
  {
    SQLExecStatement("INSERT INTO mipo_populations (tag,rate,pop) VALUES (?,?,0)",
                        sTag, IntToString(nRate));
  }

  DestroyObject(OBJECT_SELF);
}
