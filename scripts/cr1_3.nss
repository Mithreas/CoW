/*
 * cr1_3 - third door puzzle in Crumbling Ruins
 * 10 runestones behind 10 doors.  Each runestone toggles 3 doors
 * and changes 1-4 other runestones' symbol.  
 * Two possible runes can be shown.
 * When all 10 runes show the same symbol, the door opens.
 * On reset, randomise the runestones. 
 *
 * Effective layout
 *   0
 * 1 2 3
 * 4 5 6
 * 7 8 9
 * Doors - cr1_3x (master door is cr1_3)
 * Stones - cr1_3_x (this script goes in OnUsed)
 * Reset - GS_ACTIVATOR (this script goes in GS_SCRIPT var)
 *
 */
 
void ToggleDoor(string sDoor)
{
  object oDoor = GetObjectByTag(sDoor);
  
  if (GetLocked(oDoor) == FALSE)
  {
    SetLocked(oDoor, TRUE);
    DelayCommand(0.5, AssignCommand(oDoor, ActionCloseDoor(oDoor)));
  }
  else
  {
    SetLocked (oDoor, FALSE);
    DelayCommand(0.5, AssignCommand(oDoor, ActionOpenDoor(oDoor)));
  }
}
 
void ChangeStoneAppearance(int nStone)
{
  object oStone = GetObjectByTag("cr1_3_" + IntToString(nStone));

  location lLoc = GetLocation(oStone);
  string   sTag = GetTag(oStone);
  
  string sResRef = GetResRef(oStone);
  string sNewRes = "";
  
  if (sResRef == "cr1_12" || sResRef == "cr1_32")
  {
    sNewRes = "cr1_31";
  }
  else
  {
    sNewRes = "cr1_32";
  }
  
  SetPlotFlag(oStone, FALSE);
  DestroyObject(oStone);
  object oNewStone = CreateObject(OBJECT_TYPE_PLACEABLE, sNewRes, lLoc, FALSE, sTag);
  SetName(oNewStone, "Runestone");
  SetLocalInt(oNewStone, "GS_STATIC", TRUE);
}

void Reset()
{
  ChangeStoneAppearance(0);
  ChangeStoneAppearance(1);
  ChangeStoneAppearance(2);
  ChangeStoneAppearance(3);
  ChangeStoneAppearance(4);
  ChangeStoneAppearance(5);
  ChangeStoneAppearance(6);
  ChangeStoneAppearance(7);
  ChangeStoneAppearance(8);
  ChangeStoneAppearance(9);
 
  // Delay to allow the delete/recreate to happen before the next call is triggered. 
  DelayCommand(0.1f, ChangeStoneAppearance(d10()-1));
  DelayCommand(0.2f, ChangeStoneAppearance(d10()-1));
  DelayCommand(0.3f, ChangeStoneAppearance(d10()-1));
  DelayCommand(0.4f, ChangeStoneAppearance(d10()-1));
  DelayCommand(0.5f, ChangeStoneAppearance(d10()-1));
  DelayCommand(0.6f, ChangeStoneAppearance(d10()-1));
  DelayCommand(0.7f, ChangeStoneAppearance(d10()-1));
  DelayCommand(0.8f, ChangeStoneAppearance(d10()-1));
  DelayCommand(0.9f, ChangeStoneAppearance(d10()-1));
  DelayCommand(1.0f, ChangeStoneAppearance(d10()-1));
  DelayCommand(1.1f, ChangeStoneAppearance(d10()-1));
}

void CheckComplete()
{
  int s1 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_3_0")), 1));
  int s2 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_3_1")), 1));
  int s3 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_3_2")), 1));
  int s4 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_3_3")), 1));
  int s5 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_3_4")), 1));
  int s6 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_3_5")), 1));
  int s7 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_3_6")), 1));
  int s8 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_3_7")), 1));
  int s9 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_3_8")), 1));
  int s10 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_3_9")), 1));
  

  if (s1 == 1 && s2 == 1 && s3 == 1 && s4 == 1 && s5 == 1 && s6 == 1 &&
      s7 == 1 && s8 == 1 && s9 == 1 && s10 == 1)
  {
    ToggleDoor("cr1_23");
  }
  else if (s1 == 2 && s2 == 2 && s3 == 2 && s4 == 2 && s5 == 2 && s6 == 2 &&
           s7 == 2 && s8 == 2 && s9 == 2 && s10 == 2)
  {
    ToggleDoor("cr1_3");
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
  else if (GetTag(oSelf) == "cr1_3_0")
  {
    ChangeStoneAppearance(2);
	ToggleDoor("cr1_31");
	ToggleDoor("cr1_33");
	ToggleDoor("cr1_35");
  }
  else if (GetTag(oSelf) == "cr1_3_1")
  {
    ChangeStoneAppearance(2);
    ChangeStoneAppearance(4);
	ToggleDoor("cr1_32");
	ToggleDoor("cr1_34");
	ToggleDoor("cr1_36");
  }
  else if (GetTag(oSelf) == "cr1_3_2")
  {
    ChangeStoneAppearance(0);
    ChangeStoneAppearance(1);
    ChangeStoneAppearance(3);
    ChangeStoneAppearance(5);
	ToggleDoor("cr1_33");
	ToggleDoor("cr1_35");
	ToggleDoor("cr1_37");
  }
  else if (GetTag(oSelf) == "cr1_3_3")
  {
    ChangeStoneAppearance(2);
    ChangeStoneAppearance(6);
	ToggleDoor("cr1_34");
	ToggleDoor("cr1_36");
	ToggleDoor("cr1_38");
  }
  else if (GetTag(oSelf) == "cr1_3_4")
  {
    ChangeStoneAppearance(1);
    ChangeStoneAppearance(5);
    ChangeStoneAppearance(7);
	ToggleDoor("cr1_35");
	ToggleDoor("cr1_37");
	//ToggleDoor("cr1_39");
  }
  else if (GetTag(oSelf) == "cr1_3_5")
  {
    ChangeStoneAppearance(2);
    ChangeStoneAppearance(4);
    ChangeStoneAppearance(6);
    ChangeStoneAppearance(8);
	ToggleDoor("cr1_36");
	ToggleDoor("cr1_38");
	ToggleDoor("cr1_30");
  } 
  else if (GetTag(oSelf) == "cr1_3_6")
  {
    ChangeStoneAppearance(3);
    ChangeStoneAppearance(5);
    ChangeStoneAppearance(9);
	ToggleDoor("cr1_37");
	//ToggleDoor("cr1_39");
	ToggleDoor("cr1_31");
  }
  else if (GetTag(oSelf) == "cr1_3_7")
  {
    ChangeStoneAppearance(4);
    ChangeStoneAppearance(8);
	ToggleDoor("cr1_38");
	ToggleDoor("cr1_30");
	ToggleDoor("cr1_32");
  }
  else if (GetTag(oSelf) == "cr1_3_8")
  {
    ChangeStoneAppearance(5);
    ChangeStoneAppearance(7);
    ChangeStoneAppearance(9);
	//ToggleDoor("cr1_39");
	ToggleDoor("cr1_31");
	ToggleDoor("cr1_33");
  }
  else if (GetTag(oSelf) == "cr1_3_9")
  {
    ChangeStoneAppearance(6);
    ChangeStoneAppearance(8);
	ToggleDoor("cr1_30");
	ToggleDoor("cr1_32");
	ToggleDoor("cr1_34");
  }
  
  CheckComplete();  
}