/*
 * cr1_2 - second door puzzle in Crumbling Ruins
 * Pattern of 12 runestones in a + shape:
 *    0  1
 * 2  3  4  5
 * 6  7  8  9
 * 10       11 
 * Four possible runes can be shown.
 * Stepping on a rune changes the 2 or 4 adjacent runes.
 * When all twelve runes show the same symbol, the door for that symbol opens.
 * On reset, randomise the runestones. 
 *
 * Doors - cr1_2_x
 * Stones - cr1_2x (this script goes in OnUsed)
 * Reset - GS_ACTIVATOR (this script goes in GS_SCRIPT var)
 *
 */
 
void OpenDoor(string sDoor)
{
  object oDoor = GetObjectByTag(sDoor);
  SetLocked (oDoor, FALSE);
  DelayCommand(0.5, AssignCommand(oDoor, ActionOpenDoor(oDoor)));
}
 
void ChangeStoneAppearance(int nStone)
{
  object oStone = GetObjectByTag("cr1_2" + IntToString(nStone));

  location lLoc = GetLocation(oStone);
  string   sTag = GetTag(oStone);
  
  string sResRef = GetResRef(oStone);
  string sNewRes = "";
  
  if (sResRef == "cr1_21")
  {
    sNewRes = "cr1_22";
  }
  else if (sResRef == "cr1_22")
  {
    sNewRes = "cr1_23";
  }
  else if (sResRef == "cr1_23")
  {
    sNewRes = "cr1_24";
  }
  else
  {
    sNewRes = "cr1_21";
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
  ChangeStoneAppearance(10);
  ChangeStoneAppearance(11);
 
  // Delay to allow the delete/recreate to happen before the next call is triggered. 
  DelayCommand(0.1f, ChangeStoneAppearance(d12()-1));
  DelayCommand(0.2f, ChangeStoneAppearance(d12()-1));
  DelayCommand(0.3f, ChangeStoneAppearance(d12()-1));
  DelayCommand(0.4f, ChangeStoneAppearance(d12()-1));
  DelayCommand(0.5f, ChangeStoneAppearance(d12()-1));
  DelayCommand(0.6f, ChangeStoneAppearance(d12()-1));
  DelayCommand(0.7f, ChangeStoneAppearance(d12()-1));
  DelayCommand(0.8f, ChangeStoneAppearance(d12()-1));
  DelayCommand(0.9f, ChangeStoneAppearance(d12()-1));
  DelayCommand(1.0f, ChangeStoneAppearance(d12()-1));
  DelayCommand(1.1f, ChangeStoneAppearance(d12()-1));
  DelayCommand(1.2f, ChangeStoneAppearance(d12()-1));
  DelayCommand(1.3f, ChangeStoneAppearance(d12()-1));
}

void CheckComplete()
{
  int s1 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_20")), 1));
  int s2 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_21")), 1));
  int s3 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_22")), 1));
  int s4 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_23")), 1));
  int s5 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_24")), 1));
  int s6 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_25")), 1));
  int s7 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_26")), 1));
  int s8 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_27")), 1));
  int s9 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_28")), 1));
  int s10 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_29")), 1));
  int s11 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_210")), 1));
  int s12 = StringToInt(GetStringRight(GetResRef(GetObjectByTag("cr1_211")), 1));
  

  if (s1 == 1 && s2 == 1 && s3 == 1 && s4 == 1 && s5 == 1 && s6 == 1 &&
      s7 == 1 && s8 == 1 && s9 == 1 && s10 == 1 && s11 == 1 && s12 == 1)
  {
    OpenDoor("cr1_2_1");
  }
  else if (s1 == 2 && s2 == 2 && s3 == 2 && s4 == 2 && s5 == 2 && s6 == 2 &&
           s7 == 2 && s8 == 2 && s9 == 2 && s10 == 2 && s11 == 2 && s12 == 2)
  {
    OpenDoor("cr1_2_2");
  }
  else if (s1 == 3 && s2 == 3 && s3 == 3 && s4 == 3 && s5 == 3 && s6 == 3 &&
           s7 == 3 && s8 == 3 && s9 == 3 && s10 == 3 && s11 == 3 && s12 == 3)
  {
    OpenDoor("cr1_2_3");
  }  
  else if (s1 == 4 && s2 == 4 && s3 == 4 && s4 == 4 && s5 == 4 && s6 == 4 &&
           s7 == 4 && s8 == 4 && s9 == 4 && s10 == 4 && s11 == 4 && s12 == 4)
  {
    OpenDoor("cr1_2_4");
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
  else if (GetTag(oSelf) == "cr1_20")
  {
    ChangeStoneAppearance(1);
    ChangeStoneAppearance(3);
  }
  else if (GetTag(oSelf) == "cr1_21")
  {
    ChangeStoneAppearance(0);
    ChangeStoneAppearance(4);
  }
  else if (GetTag(oSelf) == "cr1_22")
  {
    ChangeStoneAppearance(3);
    ChangeStoneAppearance(6);
  }
  else if (GetTag(oSelf) == "cr1_23")
  {
    ChangeStoneAppearance(0);
    ChangeStoneAppearance(2);
    ChangeStoneAppearance(4);
    ChangeStoneAppearance(7);
  }
  else if (GetTag(oSelf) == "cr1_24")
  {
    ChangeStoneAppearance(1);
    ChangeStoneAppearance(3);
    ChangeStoneAppearance(5);
    ChangeStoneAppearance(8);
  }
  else if (GetTag(oSelf) == "cr1_25")
  {
    ChangeStoneAppearance(4);
    ChangeStoneAppearance(9);
  } 
  else if (GetTag(oSelf) == "cr1_26")
  {
    ChangeStoneAppearance(2);
    ChangeStoneAppearance(7);
    ChangeStoneAppearance(10);
  }
  else if (GetTag(oSelf) == "cr1_27")
  {
    ChangeStoneAppearance(3);
    ChangeStoneAppearance(6);
    ChangeStoneAppearance(8);
  }
  else if (GetTag(oSelf) == "cr1_28")
  {
    ChangeStoneAppearance(4);
    ChangeStoneAppearance(7);
    ChangeStoneAppearance(9);
  }
  else if (GetTag(oSelf) == "cr1_29")
  {
    ChangeStoneAppearance(5);
    ChangeStoneAppearance(8);
    ChangeStoneAppearance(11);
  }
  else if (GetTag(oSelf) == "cr1_210")
  {
    ChangeStoneAppearance(6);
  }
  else if (GetTag(oSelf) == "cr1_211")
  {
    ChangeStoneAppearance(9);
  }
  
  CheckComplete();  
}