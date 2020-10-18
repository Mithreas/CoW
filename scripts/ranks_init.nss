/* ranks_init */
#include "inc_reputation"

void ClearTable()
{
  string sSQL = "DELETE FROM "+DB_RANKS+" WHERE expire=0";
  SQLExecDirect(sSQL);
}

void Add(string sFaction, int nRank, int nScore, string sName, int nLevel)
{
  string sSQL = "INSERT INTO "+DB_RANKS+" (faction, rank, score, name, level, expire) VALUES"+
  "('"+sFaction+"','"+IntToString(nRank)+"','"+IntToString(nScore)+"','"+sName+"','" + IntToString(nLevel) + "',0)";
  SQLExecDirect(sSQL);
}


void main()
{
  ClearTable(); // So we add all values fresh each time. Saves spotting changes to
                // UPDATE instead of INSERT.

  string sFac="House Renerrin";

  Add(sFac, 1, 0,   "Thrall", 1);
  Add(sFac, 2, 10,  "Associate", 1);
  Add(sFac, 3, 20,  "Agent", 2);
  Add(sFac, 4, 30,  "Blade", 2);
  Add(sFac, 5, 40,  "Equerry", 2);
  Add(sFac, 6, 55,  "Baron", 3);
  Add(sFac, 7, 70,  "Viscount", 3);
  Add(sFac, 8, 85,  "Count", 3);
  Add(sFac, 9, 100, "Lord", 3);

  sFac="House Drannis";

  Add(sFac, 1, 0,   "Hand", 1);
  Add(sFac, 2, 5,   "Squire of the Shield", 1);
  Add(sFac, 3, 10,  "Shield", 1);
  Add(sFac, 4, 20,  "Squire of the Blade", 1);
  Add(sFac, 5, 30,  "Blade", 2);
  Add(sFac, 6, 45,  "Knight Defender", 2);
  Add(sFac, 7, 60,  "Knight of the Shield and Blade", 2);
  Add(sFac, 8, 80,  "Knight Commander", 3);
  Add(sFac, 9, 100, "Knight General", 3);

  sFac="House Erenia";

  Add(sFac, 1, 0,   "Acolyte of the First Circle", 1);
  Add(sFac, 2, 10,  "Theologian of the First Circle", 1);
  Add(sFac, 3, 20,  "Sacristan of the First Circle", 1);
  Add(sFac, 4, 30,  "Sword of the Second Circle", 1);
  Add(sFac, 5, 40,  "Initiate of the Second Circle", 1);
  Add(sFac, 6, 50,  "Priest of the Third Circle", 2);
  Add(sFac, 7, 60,  "Preacher of the Third Circle", 2);
  Add(sFac, 8, 70,  "High Priest of the Fourth Circle", 2);
  Add(sFac, 9, 80,  "Primate of the Fourth Circle", 2);
  Add(sFac, 10, 90,  "Sacred Voice of the Fourth Circle", 3);
  Add(sFac, 11, 100, "Cardinal of the Fifth Circle", 3);
  
  sFac = "Wardens";
  Add(sFac, 1, 0, "Warden", 1);
  Add(sFac, 2, 50, "Senior Warden", 2);
  Add(sFac, 3, 100, "Protector of Vyvian", 3);
  
  sFac = "Fernvale";
  Add(sFac, 1, 0, "Resident", 1);
  Add(sFac, 2, 50, "Champion", 2);
  Add(sFac, 3, 100, "Elder", 3);
}
