#include "inc_teleport"
#include "inc_house_check"
#include "inc_database"
#include "inc_respawn"

void main()
{
  object oPC = GetPCSpeaker();

  if (gsSUGetSubRaceByName(GetSubRace(oPC)) == GS_SU_SHAPECHANGER)
  {
    JumpAllToLocation(oPC,
                      GetLocation(GetObjectByTag("spc_start")));    
  }
  else if (isRenerrin(oPC))
  {
    JumpAllToLocation(oPC,
                      GetLocation(GetObjectByTag("renerrin_start")));
  }
  else if (isDrannis(oPC))
  {
    JumpAllToLocation(oPC,
                      GetLocation(GetObjectByTag("drannis_start")));
  }
  else if (isErenia(oPC))
  {
    JumpAllToLocation(oPC,
                      GetLocation(GetObjectByTag("erenia_start")));
  }
  else if (isWarden(oPC))
  {
    JumpAllToLocation(oPC,
                      GetLocation(GetObjectByTag("warden_start")));  
  }
  else if (isFernvale(oPC))
  {
    JumpAllToLocation(oPC,
                      GetLocation(GetObjectByTag("gen_start1")));  
  }
  else
  {
    JumpAllToLocation(oPC,
                      GetLocation(GetObjectByTag("gen_start" + IntToString(GetRacialType(oPC)))));
  }

    AssignCommand(oPC, ActionDoCommand(gsRESetRespawnLocation()));
}
