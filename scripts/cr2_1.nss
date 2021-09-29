// Rune puzzle.
// Works similarly to the game 21.
// The player has two levers which work as "stick" and "twist".
// "Twist" generates them a fresh rune.  Runes have value 1-7.  
// The goal is to hit 15, or to draw 5 runes and be under 15, or 
// to have fewer than 15 and more than the other player.
// Once the player hits "Stick", the game will draw a fresh set of
// runes to try and beat the player's score.  
// If the player wins (closer to 15 and not bust) then the next door
// opens.  If the player loses or draws, then the next door closes.
// There are two locked doors, so the player has to win two rounds
// in a row to progress.
void ClearBoard(int bResetDoors);
void CloseDoor(object oDoor);
void OpenDoor(object oDoor);
void PlayLoseVFX();
void PlayWinVFX();
void Stick();
void Twist();
void CreateObjectVoid(int nObjectType, string sResRef, location lLoc, int bAnim, string sNewTag);

void CreateObjectVoid(int nObjectType, string sResRef, location lLoc, int bAnim, string sNewTag)
{
  CreateObject(nObjectType, sResRef, lLoc, bAnim, sNewTag);
}

void PlayLoseVFX()
{
  object oWP = GetObjectByTag("WP_cr2_1_VFX");
  
  object oLight = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_solred", GetLocation(oWP));
  
  DelayCommand(5.0f, DestroyObject(oLight));
}

void PlayWinVFX()
{
  object oWP = GetObjectByTag("WP_cr2_1_VFX");
  
  object oLight = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_solgreen", GetLocation(oWP));
  
  DelayCommand(5.0f, DestroyObject(oLight));
}

void CloseDoor(object oDoor)
{
  SetLocked (oDoor, TRUE);
  DelayCommand(0.5, AssignCommand(oDoor, ActionCloseDoor(oDoor))); 
}

void OpenDoor(object oDoor)
{
  SetLocked (oDoor, FALSE);
  DelayCommand(0.5, AssignCommand(oDoor, ActionOpenDoor(oDoor))); 
}

void ClearBoard(int bResetDoors)
{
  DestroyObject(GetObjectByTag("cr2_1_1_1"));
  DestroyObject(GetObjectByTag("cr2_1_1_2"));
  DestroyObject(GetObjectByTag("cr2_1_1_3"));
  DestroyObject(GetObjectByTag("cr2_1_1_4"));
  DestroyObject(GetObjectByTag("cr2_1_1_5"));
  
  DestroyObject(GetObjectByTag("cr2_1_2_1"));
  DestroyObject(GetObjectByTag("cr2_1_2_2"));
  DestroyObject(GetObjectByTag("cr2_1_2_3"));
  DestroyObject(GetObjectByTag("cr2_1_2_4"));
  DestroyObject(GetObjectByTag("cr2_1_2_5"));
  
  if (bResetDoors)
  {
	CloseDoor(GetObjectByTag("cr2_1_d1"));
	CloseDoor(GetObjectByTag("cr2_1_d2"));
  }
  
  object oScoreKeeper = GetObjectByTag("cr2_1_twist");
  SetLocalInt(oScoreKeeper, "SCORE", 0);
  SetLocalInt(oScoreKeeper, "COUNT", 0);
  SetLocalInt(oScoreKeeper, "LOCKED", 0);
}

void Stick()
{
	int nPlayerScore = GetLocalInt(GetObjectByTag("cr2_1_twist"), "SCORE");
	int nMyScore = 0;
	int count = 1;
	int rune;
	
	while (nMyScore < nPlayerScore && count < 6)
	{
	  rune = Random(7) + 1;
	  nMyScore += rune;
	  
	  DelayCommand(IntToFloat(count), 
	    CreateObjectVoid(OBJECT_TYPE_PLACEABLE, 
					"cr2_" + IntToString(rune), 
					GetLocation(GetObjectByTag("WP_cr2_1_2_" + IntToString(count))), 
					FALSE, 
					"cr2_1_2_" + IntToString(count)));
	  
	  count++;
	}
	
	if (nMyScore <= 15)
	{
		// Player loses (or a tie, which is still a loss).
		DelayCommand(IntToFloat(count), CloseDoor(GetObjectByTag("cr2_1_d1")));
		
		DelayCommand(IntToFloat(count), PlayLoseVFX());
	}
	else
	{
		// Player wins
		// First or second win?
		if (GetLocked(GetObjectByTag("cr2_1_d1")) == FALSE)
		{
			// We're done here.
			DelayCommand(IntToFloat(count), OpenDoor(GetObjectByTag("cr2_1_d2")));
		}
		else
		{
			DelayCommand(IntToFloat(count), OpenDoor(GetObjectByTag("cr2_1_d1")));		
		}
		
		DelayCommand(IntToFloat(count), PlayWinVFX());
	}
	
	DelayCommand (IntToFloat(count) + 5.0f, ClearBoard(FALSE));
	SetLocalInt(GetObjectByTag("cr2_1_twist"), "LOCKED", TRUE);
}

void Twist()
{
	int nMyScore = GetLocalInt(OBJECT_SELF, "SCORE");
	int nMyCount = GetLocalInt(OBJECT_SELF, "COUNT") + 1;
	int rune = Random(7) + 1;

	CreateObject(OBJECT_TYPE_PLACEABLE, 
				"cr2_" + IntToString(rune), 
				GetLocation(GetObjectByTag("WP_cr2_1_1_" + IntToString(nMyCount))), 
				FALSE, 
				"cr2_1_1_" + IntToString(nMyCount));
	
	nMyScore += rune;
	
	if (nMyScore > 15)
	{
		// Bust.
		PlayLoseVFX();
		DelayCommand(5.0f, ClearBoard(TRUE));
		SetLocalInt(OBJECT_SELF, "LOCKED", TRUE);
	}
	else if (nMyCount == 5)
	{
		// We win - 5 tiles under 16.
		PlayWinVFX();
		// First or second win?
		if (GetLocked(GetObjectByTag("cr2_1_d1")) == FALSE)
		{
			// We're done here.
			OpenDoor(GetObjectByTag("cr2_1_d2"));
		}
		else
		{
			OpenDoor(GetObjectByTag("cr2_1_d1"));		
		}
		
		DelayCommand(5.0f, ClearBoard(FALSE));
		SetLocalInt(OBJECT_SELF, "LOCKED", TRUE);
	}
	else
	{
		// Still in the game. 
		SetLocalInt(OBJECT_SELF, "SCORE", nMyScore);
		SetLocalInt(OBJECT_SELF, "COUNT", nMyCount);
	}
}

void main()
{
  if (GetLocalInt(GetObjectByTag("cr2_1_twist"), "LOCKED"))
  {
    SpeakString("It's stuck.");
	return;
  }
  
  string sTag = GetTag(OBJECT_SELF);
  int bActive = GetLocalInt(OBJECT_SELF, "ACTIVE");
  SetLocalInt(OBJECT_SELF, "ACTIVE", !bActive);
  
  if (sTag == "cr2_1_stick")
  {
    // Stick
	Stick();
    if (bActive) ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
	else ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
  }
  else if (sTag == "cr2_1_twist")
  {
    // Twist
	Twist();
    if (bActive) ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
	else ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
  }
  else if (sTag == "GS_ACTIVATOR")
  {
    // Reset.
	ClearBoard(TRUE);
  }

}