void main()
{
  // Destroy immediately.  Otherwise PCs get to fire the convo off again.
  //ActionRandomWalk();
  //DelayCommand(10.0, DestroyObject(OBJECT_SELF));
  DestroyObject (OBJECT_SELF);
}
