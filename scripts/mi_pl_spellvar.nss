//
// Used to set a variable on a PC's creature hide when they cast the correct spell
// on this object.
//
#include "inc_pc"

void main()
{
  int nSpell = GetLastSpell();
  object oCaster = GetLastSpellCaster();
  object oHide = gsPCGetCreatureHide(oCaster);

  int nTargetSpell = GetLocalInt(OBJECT_SELF, "MI_PL_SPELL");

  if (nSpell == nTargetSpell)
  {
    string sVar = GetLocalString(OBJECT_SELF, "MI_PL_VARNAME");
    int nValue = GetLocalInt(OBJECT_SELF, "MI_PL_VALUE");
	
    SetLocalInt(oHide, sVar, nValue);
	
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
						  EffectVisualEffect(VFX_FNF_SUMMON_GATE),
						  GetLocation(OBJECT_SELF));
  }
  else
  {
    FloatingTextStringOnCreature("Your spell has no effect.", oCaster);
  }
}