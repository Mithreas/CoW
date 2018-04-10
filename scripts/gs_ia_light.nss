void main()
{
    AssignCommand(GetLastUsedBy(), ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 1.0));
    SetPlaceableIllumination(OBJECT_SELF, ! GetPlaceableIllumination());
    DelayCommand(0.5, RecomputeStaticLighting(GetArea(OBJECT_SELF)));
}
