// Conversational hook to unassign NPC as a PC henchman
// If there is a waypoint origin point fot the NPC, return them to there.

void main()
{
    object oPC       = GetPCSpeaker();
	   object oHench	 = OBJECT_SELF;

    RemoveHenchman(oPC, oHench);
	   AssignCommand( oHench, ClearAllActions());
    AssignCommand( oHench, SpeakString("I will stand down, then.") );

	   // Look for waypoint.
	   object oWaypoint = GetObjectByTag("HENCH_RETURN_WP_" + GetTag(oHench));
	   if (oWaypoint == OBJECT_INVALID)
		      return;
	   else {
		      AssignCommand(oHench, SpeakString("*departs*"));
		      AssignCommand(oHench, ActionJumpToObject(oWaypoint));
		      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectLinkEffects(EffectVisualEffect(VFX_IMP_HEALING_X), EffectHeal(GetMaxHitPoints())), oHench);
    	}
}
