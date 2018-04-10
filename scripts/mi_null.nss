void main()
{
  // Null script to override the standard handler
  // For a placeable, the OnOpen event defaults to playing the placeable's
  // animation.
  ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
}
