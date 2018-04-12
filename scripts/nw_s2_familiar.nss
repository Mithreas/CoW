//::///////////////////////////////////////////////
//:: Summon Familiar
//:: NW_S2_Familiar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons an Arcane casters familiar
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////

#include "inc_zombie"

void main()
{
    // Check for zombification.
    if (fbZGetIsZombie(OBJECT_SELF))
    {
      if (GetIsPC(OBJECT_SELF))
      {
        FloatingTextStringOnCreature("Apparently your familiar, wise to danger, doesn't want its brains to be eaten thank you very much.", OBJECT_SELF, FALSE);
      }
      return;
    }

    //Yep thats it
    SummonFamiliar();
	
	// Give the ability a use back. 
    // Septire - Or don't?
	// IncrementRemainingFeatUses(OBJECT_SELF, FEAT_SUMMON_FAMILIAR);
}
