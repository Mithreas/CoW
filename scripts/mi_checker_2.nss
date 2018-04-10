#include "mi_inc_checker"
#include "mi_log"

// Returns TRUE if the PC is a completely legal first level character, false
// otherwise. Method _1 initialises variables and checks stats and hitpoints.
// Method _2 checks feats. Method _3 checks skills. (Broken up to avoid TMI
// errors).
void miCheckIfCharacterIsLegal_2(object oPC);


void miCheckIfCharacterIsLegal_2(object oPC)
{
  Trace(CHECKER, "Checking feats for " + GetName(oPC));
  int nNumFeats = GetLocalInt(oPC, "MI_CHECK_FEATS");
  int nFeat;
  int nCountFeats = 0;
  string sFeatList = "";
  // Break the list of feats up into chunks to minimise processing.
  for (nFeat = 0; nFeat < 52; nFeat++)
  {
    if (GetHasFeat(nFeat, oPC))
    {
      sFeatList += IntToString(nFeat) + ", ";
      nCountFeats++;
    }
  }
  for (nFeat = 90; nFeat < 128; nFeat++)
  {
    if (GetHasFeat(nFeat, oPC))
    {
      sFeatList += IntToString(nFeat) + ", ";
      nCountFeats++;
    }
  }
  for (nFeat = 166; nFeat < 427; nFeat++)
  {
    if (GetHasFeat(nFeat, oPC))
    {
      sFeatList += IntToString(nFeat) + ", ";
      nCountFeats++;
    }
  }
  for (nFeat = 1087; nFeat < 1096; nFeat++)
  {
    if (GetHasFeat(nFeat, oPC))
    {
      sFeatList += IntToString(nFeat) + ", ";
      nCountFeats++;
    }
  }
  // Check a few feats by hand. These were added in HOTU and by checking them
  // manually we avoid having to cycle through 500 more feats.
  if (GetHasFeat(871, oPC)) nCountFeats++; // Curse song
  if (GetHasFeat(915, oPC)) nCountFeats++; // Skill Focus: bluff
  if (GetHasFeat(916, oPC)) nCountFeats++; // Skill Focus: intimidate
  if (GetHasFeat(944, oPC)) nCountFeats++; // Brew Potion
  if (GetHasFeat(945, oPC)) nCountFeats++; // Scribe Scroll
  if (GetHasFeat(946, oPC)) nCountFeats++; // Craft Wand
  if (GetHasFeat(952, oPC)) nCountFeats++; // Wpn Focus: Dw. axe
  if (GetHasFeat(993, oPC)) nCountFeats++; // Wpn Focus: Whip

  if (nCountFeats > nNumFeats)
  {
    Error(CHECKER, GetName(oPC) + " has illegal number of feats ("
     + IntToString(nCountFeats) + ") - should have " + IntToString(nNumFeats));
    Log(CHECKER, "Feat list: " + sFeatList);
    miBootAndBanPC(oPC);
    return;
  }

  SendMessageToPC(oPC, "Checked feats.");
  DelayCommand(0.5, ExecuteScript("mi_checker_3", oPC));
}


void main()
{
  miCheckIfCharacterIsLegal_2(OBJECT_SELF);
}
