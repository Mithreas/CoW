// Script triggers before using a polymorph ability.
// Shapechanger race - remove scaling correction.
#include "inc_pc"
void main()
{
  object oPC = OBJECT_SELF;
  object oHide = gsPCGetCreatureHide(oPC);
  
  // Reset scale if needed.
  float fScale = GetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE);
  float fTrueScale = GetLocalFloat(oHide, "AR_SCALE");
  
  if (fTrueScale != 0.0f && fTrueScale != fScale)
  {
	SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fTrueScale);
  }
}
