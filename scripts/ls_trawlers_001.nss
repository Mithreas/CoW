
// Called from OnEnter handle of 'The Trawlers - Main' and OnConversation handle of the receptionist.
// Makes NPC receptionist sit.
// See ls_trawlers_main for details

void main()
{
object oReceptionist = GetObjectByTag("TRAWLERS_RECEPTIONIST");
object oChair = GetObjectByTag("TRAWLERS_RECEPTION");

AssignCommand(oReceptionist, ClearAllActions());
AssignCommand(oReceptionist, ActionSit(oChair));

ExecuteScript("a_enter", OBJECT_SELF);
}