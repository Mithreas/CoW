
//called from keg of ale in the Trawlers - Front
//Gives ale if keg is unlocked.
// else speak message

void main()
{

if (GetLocked(OBJECT_SELF) == FALSE)
{
CreateItemOnObject("nw_it_mpotion022", GetLastUsedBy());
}
else
{
AssignCommand(OBJECT_SELF, ActionSpeakString("The tap is locked."));
ClearAllActions();
}
}
