void main()
{
object oPC = GetEnteringObject();
if (!GetIsPC(oPC)) return;
if (GetSubRace(oPC)!="House Drannis")
   return;
if (GetHitDice(oPC) < 12)
   return;
if (GetItemPossessedBy(oPC, "Tallanais_gift")!= OBJECT_INVALID)
   return;
}
