#include "fb_inc_chatutils"
const string HELP = "DM command: Mark your current location, or by passing parameter j to this function, jump to previously marked location. Example usage: -mark to set your current location, -mark j to jump back to your previous -mark. NEW: Send -mark to a player as a tell to track them. -mark j to jump to that player later. MORE NEW: -mark l (letter L) to mark the location of your target. -mark j to jump to your saved location.";
#include "inc_examine"

void main()
{
  object oSpeaker = OBJECT_SELF;
  location lMarkedLocation = GetLocalLocation(oSpeaker, "markLoc");
  object oMarkedObject = GetLocalObject(oSpeaker, "markObj");
  object oTellTarget = chatGetTarget(oSpeaker);

  // Command not valid
  if (!GetIsDM(oSpeaker)) return;

  string sParams = chatGetParams(oSpeaker);
  if (sParams == "?") {
    // -mark ?
	DisplayTextInExamineWindow("-mark", HELP);
  }
  else if (sParams == "j tome") {
    // -mark j tome (Object)
    if (oMarkedObject != OBJECT_INVALID) {
      AssignCommand(oMarkedObject, JumpToLocation(GetLocation(oSpeaker)));
    }
    // -mark j (No marked object)
    else {
      SendMessageToPC(oSpeaker, "You need to mark something first. Send a tell to the person saying -mark.");
    }
  }
  else if (sParams == "j") {
    // [Tell] -mark j (Object)
    if (oTellTarget != OBJECT_INVALID && oMarkedObject != OBJECT_INVALID) {
      AssignCommand(oTellTarget, JumpToObject(oMarkedObject));
    }
    // [Tell] -mark j (Location)
    else if (oTellTarget != OBJECT_INVALID && GetAreaFromLocation(lMarkedLocation) != OBJECT_INVALID) {
      AssignCommand(oTellTarget, JumpToLocation(lMarkedLocation));   
    }
    // -mark j (Object)
	else if (oMarkedObject != OBJECT_INVALID) {
	  AssignCommand(oSpeaker, JumpToObject(oMarkedObject));
	}
    // -mark j (Location)
	else if (GetAreaFromLocation(lMarkedLocation) != OBJECT_INVALID) {
	  AssignCommand(oSpeaker, JumpToLocation(lMarkedLocation));
	}
    // -mark j (No Object or Location stored)
	else if (oMarkedObject == OBJECT_INVALID && GetAreaFromLocation(lMarkedLocation) == OBJECT_INVALID)	{
	  SendMessageToPC(oSpeaker, "Your previous mark on this server was not found. Try placing a mark first.");	
	}
    // Should never be reached.
	else {
	  SendMessageToPC(oSpeaker, "Bad things happened with this tool. Let a dev know.");
	}
  }
  else if (sParams == "l")  {
    // [Tell] -mark l  
	if (oTellTarget != OBJECT_INVALID) {
	  SetLocalLocation(oSpeaker, "markLoc", GetLocation(oTellTarget));
	  DeleteLocalObject(oSpeaker, "markObj");
	  SendMessageToPC(oSpeaker, "Mark has been set in " + GetName(GetArea(oTellTarget)));	
	}
    // -mark l
	else {
	  SendMessageToPC(oSpeaker, "You need to send a tell to a player like this: -mark l. That will mark their current location as your marked location. If you want to mark your own location just use -mark.");
	}
  }
  else {
    // [Tell] -mark
	if (oTellTarget != OBJECT_INVALID)	{
	  SetLocalObject(oSpeaker, "markObj", oTellTarget);
	  DeleteLocalLocation(oSpeaker, "markLoc");
	  SendMessageToPC(oSpeaker, "Mark has been set on " + GetName(oTellTarget));
	}
    // -mark
	else {
	  SetLocalLocation(oSpeaker, "markLoc", GetLocation(oSpeaker));
	  DeleteLocalObject(oSpeaker, "markObj");
	  SendMessageToPC(oSpeaker, "Mark has been set in " + GetName(GetArea(oSpeaker)));
	}
  }

  chatVerifyCommand(oSpeaker);
}