// Do a will save, or take Stamina damage.
#include "inc_state"
#include "nw_i0_spells"
void main()
{
  object oPC = GetEnteringObject();
  
  if (!GetIsPC(oPC)) return;
  
  int nDC = GetLocalInt(OBJECT_SELF, "DC");
  string sText = GetLocalString(OBJECT_SELF, "TEXT");
    
  if (!nDC) nDC = 20;
  if (sText == "") sText = "The hideous visions scare you!";
  
  if (!MySavingThrow(SAVING_THROW_WILL, oPC, nDC, SAVING_THROW_TYPE_FEAR))
  {
    FloatingTextStringOnCreature(sText, oPC);
	AssignCommand(oPC, gsSTAdjustState(GS_ST_STAMINA, -1.0f));
  }    
}