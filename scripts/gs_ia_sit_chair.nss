void main()
{
    if (! GetIsObjectValid(GetSittingCreature(OBJECT_SELF)))
    {
        object oSelf = OBJECT_SELF;
		object oUser = GetLastUsedBy();

        AssignCommand(oUser, ActionSit(oSelf));
		
		// Transformed creatures sit at the height of their transform. Normalise them to the height of the chair.
		// We want to take the negative/opposite of their differential from "standard" and divide by 2.  So a 
		// creature at 1.6 scale (0.6 above standard) should be Z-transformed by -0.3.
		float fScale = GetObjectVisualTransform(oUser, OBJECT_VISUAL_TRANSFORM_SCALE) - 1.0f;
		SetObjectVisualTransform(oUser, OBJECT_VISUAL_TRANSFORM_TRANSLATE_Z, (-fScale)/2.0f);
		 
		DelayCommand(3.0f, SetLocalLocation(oUser, "MI_SIT_LOCATION", GetLocation(oUser)));
    }
}
