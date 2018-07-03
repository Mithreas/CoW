void main()
{

object oPC = GetEnteringObject();

if (!GetIsPC(oPC)) return;

if (d100()<=10)
   {
   SendMessageToPC(oPC, "Go Away!");

   }
else if (d100()<=10)
   {
   SendMessageToPC(oPC, "Whoooo aaaaare yooooouuuuu?");

   }
else if (d100()<=10)
   {
   SendMessageToPC(oPC, "Look behind you!");

   }
else if (d100()<=10)
   {
   SendMessageToPC(oPC, "Run while you can!");

   }
else if (d100()<=5)
   {
   SendMessageToPC(oPC, "Danger...");

   }
else if (d100()<=15)
   {
   SendMessageToPC(oPC, "Watch out!");

   }
else if (d100()<=20)
   {
   SendMessageToPC(oPC, "Shhhhhh!");

   }
else
   {
   SendMessageToPC(oPC, "You hear the wind rustling through the trees.");

   }

}

