int StartingConditional()
{
  return (GetArea(OBJECT_SELF) != GetArea(GetWaypointByTag("wp_city_from_sunrise")));
}