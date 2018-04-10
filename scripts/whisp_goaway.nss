void main()
{

object oPC = GetEnteringObject();

if (!GetIsPC(oPC)) return;

SendMessageToPC(oPC, "Go away!");

}

