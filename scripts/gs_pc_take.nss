#include "inc_pc"
#include "inc_death"
#include "inc_text"

void main()
{
  object oUsedBy = GetLastUsedBy();
  if (! GetIsPC(oUsedBy))              return;
  
  if (GetLocalObject(oUsedBy, "GS_CORPSE") == OBJECT_SELF)
  {
	MakeLiving(oUsedBy);
	return;
  }
  
  if (GetIsPossessedFamiliar(oUsedBy)) return;
  string sTarget = GetLocalString(OBJECT_SELF, "GS_TARGET");
  object oTarget = gsPCGetPlayerByID(sTarget);
  int nSize      = GetLocalInt(OBJECT_SELF, "GS_SIZE");
  int nGender    = GetLocalInt(OBJECT_SELF, "GS_GENDER");

  GiveGoldToCreature(oUsedBy, GetLocalInt(OBJECT_SELF, "GS_GOLD"));

  object oCorpse = CreateItemOnObject(nGender == GENDER_FEMALE ?
                                        GS_TEMPLATE_CORPSE_FEMALE :
                                        GS_TEMPLATE_CORPSE_MALE,
                                        oUsedBy);

  AssignCommand(oUsedBy, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 1.0));

  switch (nSize)
  {
  case CREATURE_SIZE_HUGE:
      AddItemProperty(DURATION_TYPE_PERMANENT,
                      ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS),
                      oCorpse);
      AddItemProperty(DURATION_TYPE_PERMANENT,
                      ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS),
                      oCorpse);
      break;

  case CREATURE_SIZE_LARGE:
      AddItemProperty(DURATION_TYPE_PERMANENT,
                      ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS),
                      oCorpse);
      AddItemProperty(DURATION_TYPE_PERMANENT,
                      ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_50_LBS),
                      oCorpse);
      break;

  case CREATURE_SIZE_MEDIUM:
      AddItemProperty(DURATION_TYPE_PERMANENT,
                      ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS),
                      oCorpse);
      break;

  case CREATURE_SIZE_SMALL:
      AddItemProperty(DURATION_TYPE_PERMANENT,
                      ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_50_LBS),
                      oCorpse);
      break;

  case CREATURE_SIZE_TINY:
      break;
  }

  // Corpse's owner is now notified in gs_m_acquire.
  SetName(oCorpse, GetName(OBJECT_SELF));
  SetLocalObject(oCorpse, "sep_azn_claimedby", GetLocalObject(OBJECT_SELF, "sep_azn_claimedby")); 
  SetLocalString(oCorpse, "GS_TARGET", sTarget);
  SetLocalInt(oCorpse, "GS_SIZE", nSize);

  if (GetIsObjectValid(oTarget))
  {
    SetLocalObject(oTarget, "GS_CORPSE", oCorpse);
  }

  DestroyObject(OBJECT_SELF);
}
