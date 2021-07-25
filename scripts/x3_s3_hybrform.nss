#include "inc_shapechanger"
#include "inc_zdlg"

void main()
{  
  int nHybridForm = GetLocalInt(gsPCGetCreatureHide(OBJECT_SELF), VAR_HYBRID_FORM);
  
  if (GetLocalInt(gsPCGetCreatureHide(OBJECT_SELF), VAR_CURRENT_FORM) == 1 && nHybridForm < 8 &&
      !gsC2GetHasEffect(EFFECT_TYPE_POLYMORPH, OBJECT_SELF, TRUE))
  {
    // Open the appearance edit menu if we are already in hybrid form and using a dynamic appearance.
	StartDlg(OBJECT_SELF, OBJECT_SELF, "zdlg_customise", TRUE, FALSE);
  }  
  
  SPC_DoHybridForm(OBJECT_SELF);
}