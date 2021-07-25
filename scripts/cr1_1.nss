/*
 * cr1_1 - first door puzzle in Crumbling Ruins
 * Pattern of 6 runestones in two rows of three.
 * Three possible runes can be shown.
 * Stepping on a rune changes the 2 or 3 adjacent runes.
 * When all six runes show the same symbol, the door for that symbol opens.
 * On reset, randomise the runestones. 
 *
 * Doors - cr1_1x
 * Stones - cr1_1_x (this script goes in OnUsed)
 * Reset - GS_ACTIVATOR (this script goes in GS_SCRIPT var)
 *
 * Layout - 
 *  1 2 3
 *  4 5 6
 */
 
void OpenDoor(string sDoor)
{
  object oDoor = GetObjectByTag(sDoor);
  SetLocked (oDoor, FALSE);
  DelayCommand(0.5, AssignCommand(oDoor, ActionOpenDoor(oDoor)));
}
 
void ChangeStoneAppearance(int nStone)
{
  object oStone = GetObjectByTag("cr1_1_" + IntToString(nStone));

  location lLoc = GetLocation(oStone);
  string   sTag = GetTag(oStone);
  
  string sResRef = GetResRef(oStone);
  string sNewRes = "";
  
  if (sResRef == "cr1_11")
  {
    sNewRes = "cr1_12";
  }
  else if (sResRef == "cr1_12")
  {
    sNewRes = "cr1_13";
  }
  else
  {
    sNewRes = "cr1_11";
  }
  
  SetPlotFlag(oStone, FALSE);
  DestroyObject(oStone);
  object oNewStone = CreateObject(OBJECT_TYPE_PLACEABLE, sNewRes, lLoc, FALSE, sTag);
  SetName(oNewStone, "Runestone");
}

void Reset()
{
  ChangeStoneAppearance(1);
  ChangeStoneAppearance(2);
  ChangeStoneAppearance(3);
  ChangeStoneAppearance(4);
  ChangeStoneAppearance(5);
  ChangeStoneAppearance(6);
 
  // Delay to allow the delete/recreate to happen before the next call is triggered. 
  DelayCommand(0.1f, ChangeStoneAppearance(d6()));
  DelayCommand(0.2f, ChangeStoneAppearance(d6()));
  DelayCommand(0.3f, ChangeStoneAppearance(d6()));
  DelayCommand(0.4f, ChangeStoneAppearance(d6()));
  DelayCommand(0.5f, ChangeStoneAppearance(d6()));
  DelayCommand(0.6f, ChangeStoneAppearance(d6()));
}

void CheckComplete()
{
  int s1 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_1_1")), 1));
  int s2 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_1_2")), 1));
  int s3 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_1_3")), 1));
  int s4 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_1_4")), 1));
  int s5 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_1_5")), 1));
  int s6 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_1_6")), 1));

  if (s1 == 1 && s2 == 1 && s3 == 1 && s4 == 1 && s5 == 1 && s6 == 1)
  {
    OpenDoor("cr1_11");
  }
  else if (s1 == 2 && s2 == 2 && s3 == 2 && s4 == 2 && s5 == 2 && s6 == 2)
  {
    OpenDoor("cr1_12");
  }
  else if (s1 == 3 && s2 == 3 && s3 == 3 && s4 == 3 && s5 == 3 && s6 == 3)
  {
    OpenDoor("cr1_13");
  }  
}

void main()
{
  object oSelf = OBJECT_SELF;
  
  if (GetTag(oSelf) == "GS_ACTIVATOR")
  {
    // This is the reset placeable. a_enter will call this script when the area
	// is reset.
	Reset();
	return;
  }
  else if (GetTag(oSelf) == "cr1_1_1")
  {
    ChangeStoneAppearance(2);
    ChangeStoneAppearance(4);
  }
  else if (GetTag(oSelf) == "cr1_1_2")
  {
    ChangeStoneAppearance(1);
    ChangeStoneAppearance(3);
    ChangeStoneAppearance(5);
  }
  else if (GetTag(oSelf) == "cr1_1_3")
  {
    ChangeStoneAppearance(2);
    ChangeStoneAppearance(6);
  }
  else if (GetTag(oSelf) == "cr1_1_4")
  {
    ChangeStoneAppearance(1);
    ChangeStoneAppearance(5);
  }
  else if (GetTag(oSelf) == "cr1_1_5")
  {
    ChangeStoneAppearance(2);
    ChangeStoneAppearance(4);
    ChangeStoneAppearance(6);
  }
  else if (GetTag(oSelf) == "cr1_1_6")
  {
    ChangeStoneAppearance(3);
    ChangeStoneAppearance(5);
  }
  
  CheckComplete();  
}