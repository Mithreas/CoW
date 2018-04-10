/*
  Standard include utility for scripts involving disguised PCs.

*/
string DISGUISED = "disguised";

/*
  Change the appearance of the specified creature.
*/
void ChangeAppearance(object oPC, int nAppearance)
{
  SetCreatureAppearanceType(oPC, nAppearance);
  FloatingTextStringOnCreature("Used disguise kit", oPC);
}

/*
  The disguised character makes a Perform or Bluff check, opposed by the
  Spot check of the spotter.  sDescription is given to any PCs involved
  as a server message.

  nMultiplier is intended to be used to "weight" the decision in favour of the
  spotter - ideally, the calling code should set it to the number of times
  this NPC has tried to recognise this PC. Negative multipliers are ignored.
*/
int SeeThroughDisguise(object oDisguised,
                       object oSpotter,
                       string sDescription,
                       int    nMultiplier)
{
  if (GetIsPC(oDisguised))
  {
    SendMessageToPC(oDisguised, sDescription);
  }

  if (GetIsPC(oSpotter))
  {
    SendMessageToPC(oDisguised, sDescription);
  }

  int nPerform = GetSkillRank(SKILL_PERFORM, oDisguised);
  int nBluff   = GetSkillRank(SKILL_BLUFF,   oDisguised);
  int nSpot    = GetSkillRank(SKILL_SPOT,    oSpotter);
  int nResult  = 0;

  if (nPerform > nBluff)
  {
    nResult = ( (d20() + nPerform) < (d20(nMultiplier) + nSpot) );
  }
  else
  {
    nResult = ( (d20() + nBluff) < (d20(nMultiplier) + nSpot) );
  }

  if (nResult)
  {
    if (GetIsPC(oDisguised))
    {
      SendMessageToPC(oDisguised, "Recognised!");
    }

    if (GetIsPC(oSpotter))
    {
      SendMessageToPC(oSpotter, "Recognised!");
    }
  }
  else
  {
    if (GetIsPC(oDisguised))
    {
      SendMessageToPC(oDisguised, "Not recognised!");
    }

    if (GetIsPC(oSpotter))
    {
      SendMessageToPC(oSpotter, "Not recognised!");
    }
  }

  return nResult;
}

