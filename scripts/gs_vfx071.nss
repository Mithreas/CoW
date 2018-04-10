// Workaround - we cannot retrieve a PC's location when they are between
// areas.  So we create an Effect (Tracks) object and then it runs a heartbeat
// script to look for a nearby tracks object.  This is that heartbeat script.
void main()
{
  object oSelf = OBJECT_SELF;
  if (GetLocalInt(oSelf, "GS_ACTIVE")) return;
  SetLocalInt(oSelf, "GS_ACTIVE", 1);

  object oTracks = GetNearestObjectByTag("mi_tracks2", oSelf);

  if (!GetIsObjectValid(oTracks) || GetDistanceBetween(oTracks, oSelf) > 5.0)
  {
    oTracks = CreateObject(OBJECT_TYPE_PLACEABLE, "mi_tracks2", GetLocation(oSelf));
  }

  string sTracks = GetLocalString(oTracks, "MI_TRACKS");
  string sNewTracks = GetLocalString(oSelf, "MI_TRACKS");

  sTracks += (sTracks == "" ? "" : ",") + sNewTracks;

  SetLocalString(oTracks, "MI_TRACKS", sTracks);
  DestroyObject (oSelf);
}
