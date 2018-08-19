void main()
{
// 2018-08-11 I forget what this was for.
object oPC = GetEnteringObject();
if (!GetIsPC(oPC)) return;
if (GetSubRace(oPC)!="House Drannis")  // This won't work any more.
   return;
if (GetHitDice(oPC) < 12)
   return;
if (GetItemPossessedBy(oPC, "Tallanais_gift")!= OBJECT_INVALID)
   return;
}
