//:://////////////////////////////////////////////
//::  BODY TAILOR:   body tailor
//::                           onconv (mil tailor)
//:://////////////////////////////////////////////
/*
   this switches back from the mil tailor conversation,
   to the body tailor.  if you have the mil tailor,
   and if you put a conversation branch on there that does this.
*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//:: based on the Mil_Tailor by Milambus Mandragon
//:://////////////////////////////////////////////


void main()
{
   object oPC = GetPCSpeaker();
   object oSelf = OBJECT_SELF;

   object oClothing = GetItemPossessedBy(oSelf, "Clothing");
   object oHelmet =  GetItemPossessedBy(oSelf, "Tlr_Helmet");


   ActionUnequipItem(oClothing);
   ActionUnequipItem(oHelmet);


   ActionStartConversation(oPC, "bodytailor", TRUE, FALSE);


}
