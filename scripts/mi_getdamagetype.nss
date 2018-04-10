// See gs_m_dying.  Basically we use this to work out how we died so that
// we can later tell investigators.
void main()
{
  int nAcid = GetDamageDealtByType(DAMAGE_TYPE_ACID);
  int nBlud = GetDamageDealtByType(DAMAGE_TYPE_BLUDGEONING);
  int nCold = GetDamageDealtByType(DAMAGE_TYPE_COLD);
  int nDiv  = GetDamageDealtByType(DAMAGE_TYPE_DIVINE);
  int nElec = GetDamageDealtByType(DAMAGE_TYPE_ELECTRICAL);
  int nFire = GetDamageDealtByType(DAMAGE_TYPE_FIRE);
  int nMag  = GetDamageDealtByType(DAMAGE_TYPE_MAGICAL);
  int nNeg  = GetDamageDealtByType(DAMAGE_TYPE_NEGATIVE);
  int nPrce = GetDamageDealtByType(DAMAGE_TYPE_PIERCING);
  int nPos  = GetDamageDealtByType(DAMAGE_TYPE_POSITIVE);
  int nSlsh = GetDamageDealtByType(DAMAGE_TYPE_SLASHING);
  int nSon  = GetDamageDealtByType(DAMAGE_TYPE_SONIC);

  // Ordering for ties.
  int nHighest = nAcid;
  string sType    = "Acid";

  if (nBlud > nHighest) sType = "Bludgeoning";
  if (nCold > nHighest) sType = "Frost";
  if (nDiv > nHighest)  sType = "Holy";
  if (nElec > nHighest) sType = "Electrical";
  if (nFire > nHighest) sType = "Fire";
  if (nMag > nHighest)  sType = "Magical Force";
  if (nNeg > nHighest)  sType = "Negative Energy";
  if (nPrce > nHighest) sType = "Piercing";
  if (nPos > nHighest)  sType = "Positive Energy";
  if (nSlsh > nHighest) sType = "Slashing";
  if (nSon > nHighest)  sType = "Sonic";

  SetLocalString(OBJECT_SELF, "MI_DAMAGE_TYPE", sType);
}
