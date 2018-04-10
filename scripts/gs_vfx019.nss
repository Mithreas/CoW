#include "gs_inc_craft"

void main()
{
    int nEnabled = GetLocalInt(OBJECT_SELF, "GS_ENABLED");
    int nCraft = GetLocalInt(OBJECT_SELF, "CRAFT");
	
	// Stagger loading of the different trade skills.  
	if (nEnabled > nCraft) return;
	else if (nEnabled < nCraft)
	{
	  nEnabled++;
	  SetLocalInt(OBJECT_SELF, "GS_ENABLED", nEnabled);
	  return;
	}

    gsCRLoadRecipeList(nCraft);
    if (nCraft == 6) ActionDoCommand(gsCRLoadCategoryList());

    DelayCommand(3.0, ActionDoCommand(DestroyObject(OBJECT_SELF)));
}
