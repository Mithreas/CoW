// Put on a bookcase OnUsed slot.  When used, triggers the -research function, even in areas that are not libraries.
void StartResearch(object oPC)
{
  // A separate function to be assigned as a command, as the PC's facing doesn't change
  // till after OnUsed scripts are done.
  SetLocalLocation(oPC, "research_location", GetLocation(oPC));
  AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
  DelayCommand(6.0, ExecuteScript("mi_reshb", oPC));
}

void main()
{
    object oPC = GetLastUsedBy();
	
    // If already researching, ignore this use.
    location lResLoc = GetLocalLocation(oPC, "research_location");
    if (GetIsObjectValid(GetAreaFromLocation(lResLoc)))
    {
      // PC is already researching, so return.
      return;
    }  

    DelayCommand(6.0f, StartResearch(oPC));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_READ));
}