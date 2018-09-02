// Return TRUE if we can see the nearest PC.  Used to hail greetings etc.
int StartingConditional()
{
  object oNearest = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF, 1);
  
   return (GetIsObjectValid(oNearest) && GetObjectSeen(oNearest, OBJECT_SELF)); 
}