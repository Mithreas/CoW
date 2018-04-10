/*
  Name: mi_describe
  Author: Mithreas
  Version: 1.0
  Date: 11 Sep 05

  Description: This script is used to describe an area. Put it in the OnEnter
  handler for a trigger, and store a string variable in the trigger with the
  name "description" (case sensitive). When a PC enters the trigger, they will
  receive a server message (yellow text in the server window) with the
  description.
*/
void main()
{
   object oPC = GetEnteringObject();

   if (GetIsPC(oPC))
   {
     string sDescription = GetLocalString(OBJECT_SELF, "description");
     SendMessageToPC(oPC, sDescription);
   }


}
