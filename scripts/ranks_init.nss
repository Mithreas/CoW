/* ranks_init */
#include "mi_repcomm"

void ClearTable()
{
  string sSQL = "DELETE FROM "+DB_RANKS+" WHERE expire=0";
  SQLExecDirect(sSQL);
}

void Add(string sFaction, int nRank, int nScore, string sName)
{
  string sSQL = "INSERT INTO "+DB_RANKS+" (faction, rank, score, name, expire) VALUES"+
  "('"+sFaction+"','"+IntToString(nRank)+"','"+IntToString(nScore)+"','"+sName+"',0)";
  SQLExecDirect(sSQL);
}


void main()
{
  ClearTable(); // So we add all values fresh each time. Saves spotting changes to
                // UPDATE instead of INSERT.

  string sFac="House Renerrin";

  Add(sFac, 1, 0,   "Thrall");
  Add(sFac, 2, 10,  "Associate");
  Add(sFac, 3, 20,  "Agent");
  Add(sFac, 4, 30,  "Blade");
  Add(sFac, 5, 40,  "Equerry");
  Add(sFac, 6, 55,  "Baron");
  Add(sFac, 7, 70,  "Viscount");
  Add(sFac, 8, 85,  "Count");
  Add(sFac, 9, 100, "Lord");

  sFac="House Drannis";

  Add(sFac, 1, 0,   "Hand");
  Add(sFac, 2, 5,   "Squire of the Shield");
  Add(sFac, 3, 10,  "Shield");
  Add(sFac, 4, 20,  "Squire of the Blade");
  Add(sFac, 5, 30,  "Blade");
  Add(sFac, 6, 45,  "Knight Defender");
  Add(sFac, 7, 60,  "Knight of the Shield and Blade");
  Add(sFac, 8, 80,  "Knight Commander");
  Add(sFac, 9, 100, "Knight General");

  sFac="House Erenia";

  Add(sFac, 1, 0,   "Acolyte of the First Circle");
  Add(sFac, 2, 10,  "Theologian of the First Circle");
  Add(sFac, 3, 20,  "Sacristan of the First Circle");
  Add(sFac, 4, 30,  "Sword of the Second Circle");
  Add(sFac, 5, 40,  "Initiate of the Second Circle");
  Add(sFac, 6, 50,  "Priest of the Third Circle");
  Add(sFac, 7, 60,  "Preacher of the Third Circle");
  Add(sFac, 8, 70,  "High Priest of the Fourth Circle");
  Add(sFac, 9, 80,  "Primate of the Fourth Circle");
  Add(sFac, 10, 90,  "Sacred Voice of the Fourth Circle");
  Add(sFac, 11, 100, "Cardinal of the Fifth Circle");
}
