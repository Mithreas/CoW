/*
 inc_relations

 Relationships library.  Tracks who talks to whom, who kills whom and the like.

 Can be queried to tell you who someone's friends are.

 AKA mi_inc_bigbrother

create table mi_relationships (
  pc_a  int(11) not null,
  pc_b  int(11) not null,
  value int(11) default 0,
  primary key (pc_a,pc_b),
  constraint mi_relationships_FK_1 foreign key (pc_a) references gs_pc_data (id),
  constraint mi_relationships_FK_1 foreign key (pc_b) references gs_pc_data (id)
) default charset=latin1;
*/
#include "inc_pc"
#include "inc_database"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
//void main()

// Initialises event handlers on a PC (these aren't set by default on
// character creation, so set them on login if needed).
void miRESetPCEventHandlers(object oPC);
// Adjust the relationship between sPCa and sPCb by nAmount.  Relationships are
// symmetrical (at least numerically).  sPCa and sPCb should be PC IDs.
//
// NB - it is left to the calling code to call miRECreateRelationship() between
// two PCs to minimise the number of queries done.
void miREAdjustRelationship(string sPCa, string sPCb, int nAmount);
// Checks whether sPCa and sPCb have an established relationship, and creates
// one if not.  sPCa and sPCb should be PC IDs.
void miRECreateRelationship(string sPCa, string sPCb);
// Returns the ID of the closest friend to sPC.  If sPC has no friends, returns
// "".
string miREGetBestFriend(string sPC);
// Returns the worst enemy of sPC.  If sPC has no enemies, returns "".
string miREGetWorstEnemy(string sPC);
// Handle PC A attacking PC B.
void miRERecordCombatHit(object oPCA, object oPCB);
// Process speech event between two PCs.  
void miREDoSpeech(object oPCA, object oPCB);

void miRESetPCEventHandlers(object oPC)
{
  if (!GetIsPC(oPC)) return;

  if (GetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT) == "ar_pc_heartbeat") return;

  SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, "ar_pc_heartbeat");
  SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_NOTICE, "ar_pc_perception");
  SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT, "ar_pc_spell");
  SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED, "ar_pc_attacked");
  SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_DAMAGED, "ar_pc_damaged");
  SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_DISTURBED, "ar_pc_disturbed");
  SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND, "ar_pc_endcombat");
  SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_DIALOGUE, "ar_pc_conv");
  SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_SPAWN_IN, "ar_pc_spawn");
  SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_RESTED, "ar_pc_rested");
  SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_DEATH, "ar_pc_death");
  SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT, "ar_pc_userdef");
  SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR, "ar_pc_blocked");
}

void miRECreateRelationship(string sPCa, string sPCb)
{
  if (sPCa == "" || sPCb == "") return;
  
  // A&B should always be in ascending order.
  if (StringToInt(sPCa) > StringToInt(sPCb))
  {
    string sID = sPCa;
    sPCa = sPCb;
    sPCb = sID;
  }

  SQLExecStatement("SELECT value FROM mi_relationships WHERE pc_a=? and pc_b=?", sPCa, sPCb);

  if (!SQLFetch())
  {
    SQLExecStatement("INSERT INTO mi_relationships (pc_a, pc_b, value) VALUES (?,?,0)", sPCa, sPCb);
  }
}

void miREAdjustRelationship(string sPCa, string sPCb, int nAmount)
{
  if (sPCa == "" || sPCb == "") return;
  
  // A&B should always be in ascending order.
  if (StringToInt(sPCa) > StringToInt(sPCb))
  {
    string sID = sPCa;
    sPCa = sPCb;
    sPCb = sID;
  }

  if (nAmount >= 0)
  {
    SQLExecStatement("UPDATE mi_relationships SET value=value+"+IntToString(nAmount)+
                       " WHERE pc_a=? AND pc_b=?", sPCa, sPCb);
   }
   else if (nAmount < 0) // No + sign, let - sign stand.
   {
    SQLExecStatement("UPDATE mi_relationships SET value=value"+IntToString(nAmount)+
                       " WHERE pc_a=? AND pc_b=?", sPCa, sPCb);
   }
}

string miREGetBestFriend(string sPC)
{
  SQLExecStatement("SELECT pc_a,pc_b,value FROM mi_relationships WHERE pc_a=? OR pc_b=? AND value > 0 ORDER BY value DESC LIMIT 1", sPC, sPC);

  if (SQLFetch())
  {
    int nValue = StringToInt(SQLGetData(3));
    if (nValue > 0)
    {
      if (SQLGetData(1) != sPC) return SQLGetData(1);
      else return SQLGetData(2);
    }
  }

  return "";
}

string miREGetWorstEnemy(string sPC)
{
  SQLExecStatement("SELECT pc_a,pc_b,value FROM mi_relationships WHERE pc_a=? OR pc_b=? AND value < 0 ORDER BY value LIMIT 1", sPC, sPC);

  if (SQLFetch())
  {
    int nValue = StringToInt(SQLGetData(3));
    if (nValue < 0)
    {
      if (SQLGetData(1) != sPC) return SQLGetData(1);
      else return SQLGetData(2);
    }
  }

  return "";
}


void miRERecordCombatHit(object oPCA, object oPCB)
{
  string sID = gsPCGetPlayerID(oPCA);
  string sMyID = gsPCGetPlayerID(oPCB);
  
  if (sID == "" || sMyID == "") return;

  int nRel = GetLocalInt(oPCB, "REL_CB_" + sID);

  if (!nRel)
  {
    miRECreateRelationship(sID, sMyID);
  }

  miREAdjustRelationship(sID, sMyID, -10);

  // Store that we have an established relationship to minimise DB access.
  SetLocalInt(oPCB, "REL_CB_" + sID, TRUE);
  SetLocalInt(oPCA, "REL_CB_" + sMyID, TRUE);
}

void miREDoSpeech(object oPCA, object oPCB)
{
    // DM check
    if (GetIsDM(oPCA) || GetIsDMPossessed(oPCA) || 
	    GetIsDM(oPCB) || GetIsDMPossessed(oPCB))
      return;			
	
    string sID = gsPCGetPlayerID(oPCB);
    string sMyID = gsPCGetPlayerID(oPCA);

    if (sID == "" || sMyID == "") return;
  
    int nRel = GetLocalInt(oPCA, "REL_CV_" + sID);

    if (!nRel)
    {
      miRECreateRelationship(sID, sMyID);
    }

    nRel++;

    if (nRel == 11)
    {
      nRel -= 10;
      miREAdjustRelationship(sID, sMyID, 1);
    }

    // NB - relationships are symmetrical, and improve no matter who speaks.
    SetLocalInt(oPCA, "REL_CV_" + sID, nRel);
    SetLocalInt(oPCB, "REL_CV_" + sMyID, nRel);
}