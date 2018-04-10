// VOICE CONFIGURATION - NEW IN 1.07 and UP

// Set this to 0 if you want to DISABLE listening by NPCs for performance reasons.
// See readme for additional information regarding possible issues and effects.
const int DMFI_LISTENING_GLOBAL = 1;


// NOTE: OMW_COLORS is an invisible object that must be present in your module.
// It has high ascii characters in the name and is used to get the color codes.
// This was ripped wholeheartedly by an example posted by Richterm on the bioboards.

string DST_COLOR_TAGS = GetName(GetObjectByTag("dem_color_text"));
string DST_COLOR_WHITE = GetSubString(DST_COLOR_TAGS, 0, 6);
string DST_COLOR_YELLOW = GetSubString(DST_COLOR_TAGS, 6, 6);
string DST_COLOR_MAGENTA = GetSubString(DST_COLOR_TAGS, 12, 6);
string DST_COLOR_CYAN = GetSubString(DST_COLOR_TAGS, 18, 6);
string DST_COLOR_RED = GetSubString(DST_COLOR_TAGS, 24, 6);
string DST_COLOR_GREEN = GetSubString(DST_COLOR_TAGS, 30, 6);
string DST_COLOR_BLUE = GetSubString(DST_COLOR_TAGS, 36, 6);

// Colors for each type of roll. Change the colors if you like.
string DMFI_ROLL_COLOR = DST_COLOR_CYAN;
string DST_COLOR_NORMAL = DST_COLOR_WHITE;

int DMW_START_CUSTOM_TOKEN = 8000;

//Retrieve targetting information
object oMySpeaker = GetLastSpeaker();
object oMyTarget = GetLocalObject(oMySpeaker, "dmfi_univ_target");
location lMyLoc = GetLocalLocation(oMySpeaker, "dmfi_univ_location");

// checks if a nearby object is destroyable
int dmwand_isnearbydestroyable();
// Check if the target can be created with CreateObject
int dmwand_istargetcreateable();
//Check if target is a destroyable object
int dmwand_istargetdestroyable();
// checks if the wand was NOT clicked on an object
int dmwand_istargetinvalid();
// check if the target has an inventory
int dmwand_istargetinventory();
//Check if the target is not the wand's user
int dmwand_istargetnotme();
//Check if target is an NPC or monster
int dmwand_istargetnpc();
//Check if the target is a PC
int dmwand_istargetpc();
//Check if the target is a PC and not me
int dmwand_istargetpcnme();
// Check if the target is a PC or NPC
// uses the CON score currently
int dmwand_istargetpcornpc();
//Check if the target is a PC or an npc and not me
int dmwand_istargetpcornpcnme();
// Check if target is a placeable
int dmwand_istargetplaceable();
//bulds the conversion
int dmwand_BuildConversationDialog(int nCurrent, int nChoice, string sConversation, string sParams);
int dmw_conv_ListPlayers(int nCurrent, int nChoice, string sParams = "");
int dmw_conv_Start(int nCurrent, int nChoice, string sParams = "");
void dmwand_BuildConversation(string sConversation, string sParams);
void dmwand_StartConversation();

// DMFI Color Text function.  It returns a colored string.
// sText is the string that will be colored and sColor is the color
// options: yellow, magenta, cyan, red, green, blue - truncated at first letter
// Ex: sMsg = ColorText(sMsg, "y");  //Add the include file - yields yellow colored msg.
string ColorText(string sText, string sColor);
string ColorText(string sText, string sColor)
{
    string sApply = DST_COLOR_NORMAL;
    string sTest = GetStringLowerCase(GetStringLeft(sColor, 1));
    if (sTest=="y")  sApply = DST_COLOR_YELLOW;
    else if (sTest == "m") sApply = DST_COLOR_MAGENTA;
    else if (sTest == "c") sApply = DST_COLOR_CYAN;
    else if (sTest == "r") sApply = DST_COLOR_RED;
    else if (sTest == "g") sApply = DST_COLOR_GREEN;
    else if (sTest == "r") sApply = DST_COLOR_BLUE;

    string sFinal = sApply + sText + DST_COLOR_NORMAL;
    return sFinal;
}


int dmwand_isnearbydestroyable()
{
   object oMyTest = GetFirstObjectInShape(SHAPE_CUBE, 0.6, lMyLoc, FALSE, OBJECT_TYPE_ALL);
   int nTargetType = GetObjectType(oMyTest);
   return (GetIsObjectValid(oMyTest) && (! GetIsPC(oMyTest)) && ((nTargetType == OBJECT_TYPE_ITEM) || (nTargetType == OBJECT_TYPE_PLACEABLE) || (nTargetType == OBJECT_TYPE_CREATURE)));
}

int dmwand_istargetcreateable()
{
   if(! GetIsObjectValid(oMyTarget)) { return FALSE; }

   int nTargetType = GetObjectType(oMyTarget);
   return ((nTargetType == OBJECT_TYPE_ITEM) || (nTargetType == OBJECT_TYPE_PLACEABLE) || (nTargetType == OBJECT_TYPE_CREATURE));
}

int dmwand_istargetdestroyable()
{
   if(! GetIsObjectValid(oMyTarget)) { return FALSE; }

   int nTargetType = GetObjectType(oMyTarget);
   if(! GetIsPC(oMyTarget))
   {
      return ((nTargetType == OBJECT_TYPE_ITEM) || (nTargetType == OBJECT_TYPE_PLACEABLE) || (nTargetType == OBJECT_TYPE_CREATURE));
   }
   return FALSE;
}

int dmwand_istargetinvalid()
{
   return !GetIsObjectValid(oMyTarget);
}

int dmwand_istargetinventory()
{
   return (GetIsObjectValid(oMyTarget) && GetHasInventory(oMyTarget));
}

int dmwand_istargetnotme()
{
   return (GetIsObjectValid(oMyTarget) && (oMySpeaker != oMyTarget));
}

int dmwand_istargetpc()
{
   return (GetIsObjectValid(oMyTarget) && GetIsPC(oMyTarget));
}

int dmwand_istargetpcnme()
{
   return (GetIsObjectValid(oMyTarget) && GetIsPC(oMyTarget) && (oMySpeaker != oMyTarget));
}

int dmwand_istargetpcornpc()
{
   return (GetIsObjectValid(oMyTarget) && GetAbilityScore(oMyTarget, ABILITY_CONSTITUTION));
}

int dmwand_istargetnpc()
{
   return (dmwand_istargetpcornpc() && (!GetIsPC(oMyTarget)));
}

int dmwand_istargetpcornpcnme()
{
   return (dmwand_istargetpcornpc() && (oMySpeaker != oMyTarget));
}

int dmwand_istargetplaceable()
{
   if(! GetIsObjectValid(oMyTarget)) { return FALSE; }

   int nTargetType = GetObjectType(oMyTarget);
   return (nTargetType == OBJECT_TYPE_PLACEABLE);
}

int dmw_conv_Start(int nCurrent, int nChoice, string sParams = "")
{
   string sText = "";
   string sCall = "";
   string sCallParams = "";

   switch(nCurrent)
   {
      case 0:
         nCurrent = 0;
         sText =       "Hello there, DM.  What can I do for you?";
         sCall =       "";
         sCallParams = "";
         break;

      case 1:
         nCurrent = 1;
         if(dmwand_istargetpcnme())
         {
            sText =       "Penguin this player.";
            sCall =       "func_Toad";
            sCallParams = "";
            break;
         }
      case 2:
         nCurrent = 2;
         if(dmwand_istargetpcnme())
         {
            sText =       "Unpenguin this player.";
            sCall =       "func_Untoad";
            sCallParams = "";
            break;
         }
      case 3:
         nCurrent = 3;
         if(dmwand_istargetpcnme())
         {
            sText =       "Boot this player.";
            sCall =       "func_KickPC";
            sCallParams = "";
            break;
         }
      case 4:
         nCurrent = 4;
         if(dmwand_istargetinvalid())
         {
            sText =       "List all players...";
            sCall =       "conv_ListPlayers";
            sCallParams = "func_PlayerListConv";
            break;
         }

      case 5:
         nCurrent = 5;
         if(dmwand_istargetpcnme())
         {
            sText =       "Jump this player to my location.";
            sCall =       "func_JumpPlayerHere";
            sCallParams = "";
            break;
         }
      case 6:
         nCurrent = 6;
         if(dmwand_istargetpcnme())
         {
            sText =       "Jump me to this player's location.";
            sCall =       "func_JumpToPlayer";
            sCallParams = "";
            break;
         }
      case 7:
         nCurrent = 7;
         if(dmwand_istargetpcnme())
         {
            sText =       "Jump this player's party to my location.";
            sCall =       "func_JumpPartyHere";
            sCallParams = "";
            break;
         }
      default:
         nCurrent = 0;
         sText =       "";
         sCall =       "";
         sCallParams = "";
         break;
   }

   SetLocalString(oMySpeaker, "dmw_dialog" + IntToString(nChoice), sText);
   SetLocalString(oMySpeaker, "dmw_function" + IntToString(nChoice), sCall);
   SetLocalString(oMySpeaker, "dmw_params" + IntToString(nChoice), sCallParams);

   return nCurrent;
}

void DMFI_untoad(object oTarget, object oUser)
{
if (GetLocalInt(oTarget, "toaded")==1)
    {
    effect eMyEffect = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eMyEffect))
             {
             if(GetEffectType(eMyEffect) == EFFECT_TYPE_POLYMORPH ||
                GetEffectType(eMyEffect) == EFFECT_TYPE_PARALYZE)
                                 RemoveEffect(oTarget, eMyEffect);

             eMyEffect = GetNextEffect(oTarget);
             }
     }
else
               {
               FloatingTextStringOnCreature("Dude, he is no toad!", oUser);
               }
}

void DMFI_toad(object oTarget, object oUser)
{
              effect ePenguin = EffectPolymorph(POLYMORPH_TYPE_PENGUIN);
              effect eParalyze = EffectParalyze();
              SendMessageToPC(oUser, "Penguin?  Don't you mean toad?");
              AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePenguin, oTarget));
              AssignCommand(oTarget, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eParalyze, oTarget));
              SetLocalInt(oTarget, "toaded", 1);
}

void dmwand_KickPC(object oTarget, object oUser)
{
   // Create a lightning strike, thunder, scorch mark, and random small
   // lightnings at target's location
   location lMyLoc = GetLocation (oTarget);
   AssignCommand( oUser, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), lMyLoc));
   AssignCommand ( oUser, PlaySound ("as_wt_thundercl3"));
   object oScorch = CreateObject ( OBJECT_TYPE_PLACEABLE, "plc_weathmark", lMyLoc, FALSE);
   object oTargetArea = GetArea(oUser);
   int nXPos, nYPos, nCount;
   for(nCount = 0; nCount < 5; nCount++)
   {
      nXPos = Random(10) - 5;
      nYPos = Random(10) - 5;

      vector vNewVector = GetPositionFromLocation(lMyLoc);
      vNewVector.x += nXPos;
      vNewVector.y += nYPos;

      location lNewLoc = Location(oTargetArea, vNewVector, 0.0);
      AssignCommand( oUser, ApplyEffectAtLocation ( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_S), lNewLoc));
   }
   DelayCommand ( 20.0, DestroyObject ( oScorch));

   SendMessageToAllDMs (GetName(oTarget) + " was booted from the game.  PC CD KEY: " + GetPCPublicCDKey(oTarget) + " PC IP ADDRESS: " + GetPCIPAddress(oTarget));
   PrintString(GetName(oTarget) + " was booted from the game.  PC CD KEY: " + GetPCPublicCDKey(oTarget) + " PC IP ADDRESS: " + GetPCIPAddress(oTarget));

   // Kick the target out of the game
   BootPC(oTarget);
}

void dmwand_JumpPlayerHere()
{
   location lJumpLoc = GetLocation(oMySpeaker);
   AssignCommand(oMyTarget, ClearAllActions());
   AssignCommand(oMyTarget, ActionJumpToLocation(lJumpLoc));
}

//Added by hahnsoo, jumps a party to the DM
void dmwand_JumpPartyHere()
{
   location lJumpLoc = GetLocation(oMySpeaker);
    object oParty = GetFirstFactionMember(oMyTarget);
    while (GetIsObjectValid(oParty))
    {
        AssignCommand(oParty, ClearAllActions());
        AssignCommand(oParty, ActionJumpToLocation(lJumpLoc));
        oParty = GetNextFactionMember(oMyTarget);
    }
}

void dmwand_JumpToPlayer()
{
   location lJumpLoc = GetLocation(oMyTarget);
   AssignCommand(oMySpeaker, ActionJumpToLocation(lJumpLoc));
}

void dmwand_PlayerListConv(string sParams)
{
   int nPlayer = StringToInt(sParams);
   int nCache;
   int nCount;

   object oPlayer = GetLocalObject(oMySpeaker, "dmw_playercache" + IntToString(nPlayer));
   oMyTarget = oPlayer;
   SetLocalObject(oMySpeaker, "dmfi_univ_target", oMyTarget);

   //Go back to the first conversation level
   dmwand_BuildConversation("Start", "");
}

//::///////////////////////////////////////////////
//:: File: dmw_conv_inc
//::
//:: Conversation functions for the DM's Helper
//:://////////////////////////////////////////////

int dmwand_BuildConversationDialog(int nCurrent, int nChoice, string sConversation, string sParams)
{

   if(TestStringAgainstPattern(sConversation, "ListPlayers"))
   {
      return dmw_conv_ListPlayers(nCurrent, nChoice, sParams);
   }

   if(TestStringAgainstPattern(sConversation, "Start"))
   {
      return dmw_conv_Start(nCurrent, nChoice, sParams);
   }

   return FALSE;
}

void dmwand_BuildConversation(string sConversation, string sParams)
{
   int nLast;
   int nTemp;
   int nChoice = 1;
   int nCurrent = 1;
   int nMatch;

   if(TestStringAgainstPattern(sParams, "prev"))
   {
      //Get the number choice to start with
      nCurrent = GetLocalInt(oMySpeaker, "dmw_dialogprev");

      //Since we're going to the previous page, there will be a next
      SetLocalString(oMySpeaker, "dmw_dialog9", "Next ->");
      SetLocalString(oMySpeaker, "dmw_function9", "conv_" + sConversation);
      SetLocalString(oMySpeaker, "dmw_params9", "next");
      SetLocalInt(oMySpeaker, "dmw_dialognext", nCurrent);

      nChoice = 8;
      for(;nChoice >= 0; nChoice--)
      {
         int nTemp1 = nCurrent;
         int nTemp2 = nCurrent;
         nMatch = nTemp2;
         while((nCurrent == nMatch) && (nTemp2 > 0))
         {
            nTemp2--;
            nMatch = dmwand_BuildConversationDialog(nTemp2, nChoice, sConversation, sParams);
         }

         if(nTemp2 <= 0)
         {
            //we went back too far for some reason, so make this choice blank
            SetLocalString(oMySpeaker, "dmw_dialog" + IntToString(nChoice), "");
            SetLocalString(oMySpeaker, "dmw_function" + IntToString(nChoice), "");
            SetLocalString(oMySpeaker, "dmw_params" + IntToString(nChoice), "");
         }
         nLast = nTemp;
         nTemp = nTemp1;
         nTemp1 = nMatch;
         nCurrent = nMatch;
      }

      if(nMatch > 0)
      {
         SetLocalString(oMySpeaker, "dmw_dialog1", "<- previous");
         SetLocalString(oMySpeaker, "dmw_function1", "conv_" + sConversation);
         SetLocalString(oMySpeaker, "dmw_params1", "prev");
         SetLocalInt(oMySpeaker, "dmw_dialogprev", nLast);
      }

      //fill the NPC's dialog spot
      //(saved for last because the build process tromps on it)
      dmwand_BuildConversationDialog(0, 0, sConversation, sParams);
   }
   else
   {
      //fill the NPC's dialog spot
      dmwand_BuildConversationDialog(0, 0, sConversation, sParams);

      //No parameters specified, start at the top of the conversation
      if(sParams == "")
      {
         nChoice = 1;
         nCurrent = 1;
      }

      //A "next->" choice was selected
      if(TestStringAgainstPattern(sParams, "next"))
      {
         //get the number choice to start with
         nCurrent = GetLocalInt(oMySpeaker, "dmw_dialognext");

         //set this as the number for the "previous" choice to use
         SetLocalInt(oMySpeaker, "dmw_dialogprev", nCurrent);

         //Set the first dialog choice to be "previous"
         nChoice = 2;
         SetLocalString(oMySpeaker, "dmw_dialog1", "<- Previous");
         SetLocalString(oMySpeaker, "dmw_function1", "conv_" + sConversation);
         SetLocalString(oMySpeaker, "dmw_params1", "prev");
      }

      //Loop through to build the dialog list
      for(;nChoice <= 10; nChoice++)
      {
         nMatch = dmwand_BuildConversationDialog(nCurrent, nChoice, sConversation, sParams);
         //nLast will be the value of the choice before the last one
         nLast = nTemp;
         nTemp = nMatch;
         if(nMatch > 0) { nCurrent = nMatch; }
         if(nMatch == 0) { nLast = 0; }
         nCurrent++;
      }

      //If there were enough choices to fill 10 spots, make spot 9 a "next"
      if(nLast > 0)
      {
         SetLocalString(oMySpeaker, "dmw_dialog9", "Next ->");
         SetLocalString(oMySpeaker, "dmw_function9", "conv_" + sConversation);
         SetLocalString(oMySpeaker, "dmw_params9", "next");
         SetLocalInt(oMySpeaker, "dmw_dialognext", nLast);
      }
   }
}

int dmw_conv_ListPlayers(int nCurrent, int nChoice, string sParams = "")
{
   string sText = "";
   string sCall = "";
   string sCallParams = "";
   object oPlayer;
   int nCache;

   if((! TestStringAgainstPattern(sParams, "next")) && (! TestStringAgainstPattern(sParams, "prev")))
   {
      //This is the first time running this function, so cache the objects
      // of all players... we don't want our list swapping itself around every
      // time you change a page
      SetLocalString(oMySpeaker, "dmw_playerfunc", sParams);
      int nCount = 1;
      oPlayer = GetFirstPC();
      while(GetIsObjectValid(oPlayer))
      {
         SetLocalObject(oMySpeaker, "dmw_playercache" + IntToString(nCount), oPlayer);
         oPlayer = GetNextPC();
         nCount++;
      }
      nCount--;
      SetLocalInt(oMySpeaker, "dmw_playercache", nCount);
   }

   string sFunc = GetLocalString(oMySpeaker, "dmw_playerfunc");
   nCache = GetLocalInt(oMySpeaker, "dmw_playercache");

   switch(nCurrent)
   {
      case 0:
         nCurrent = 0;
         sText =       "Who would you like to work on?";
         sCall =       "";
         sCallParams = "";
         break;
      default:
         //Find the next player in the cache who is valid
         oPlayer = GetLocalObject(oMySpeaker, "dmw_playercache" + IntToString(nCurrent));
         while((! GetIsObjectValid(oPlayer)) && (nCurrent <= nCache))
         {
            nCurrent++;
            oPlayer = GetLocalObject(oMySpeaker, "dmw_playercache" + IntToString(nCurrent));
         }

         if(nCurrent > nCache)
         {
            //We've run out of cache, any other spots in this list should be
            //skipped
            nCurrent = 0;
            sText =       "";
            sCall =       "";
            sCallParams = "";
         }
         else
         {
            //We found a player, set up the list entry
            sText =       GetName(oPlayer) + " (" + GetPCPlayerName(oPlayer) + ")";
            sCall =       sFunc;
            sCallParams = IntToString(nCurrent);
         }
         break;
   }

   SetLocalString(oMySpeaker, "dmw_dialog" + IntToString(nChoice), sText);
   SetLocalString(oMySpeaker, "dmw_function" + IntToString(nChoice), sCall);
   SetLocalString(oMySpeaker, "dmw_params" + IntToString(nChoice), sCallParams);

   return nCurrent;
}

void dmwand_DoDialogChoice(int nChoice)
{
   string sCallFunction = GetLocalString(oMySpeaker, "dmw_function" + IntToString(nChoice));
   string sCallParams = GetLocalString(oMySpeaker, "dmw_params" + IntToString(nChoice));
   string sNav = "";

   string sStart = GetStringLeft(sCallFunction, 5);
   int nLen = GetStringLength(sCallFunction) - 5;
   string sCall = GetSubString(sCallFunction, 5, nLen);

   if(TestStringAgainstPattern("conv_", sStart))
   {
      dmwand_BuildConversation(sCall, sCallParams);
   }
   else
   {

      if(TestStringAgainstPattern("PlayerListConv", sCall))
      {
         dmwand_PlayerListConv(sCallParams);
         return;
      }

      if(TestStringAgainstPattern("Toad", sCall))
      {
         DMFI_toad(oMyTarget, oMySpeaker);
         return;
      }
      if(TestStringAgainstPattern("Untoad", sCall))
      {
         DMFI_untoad(oMyTarget, oMySpeaker);
         return;
      }
      if(TestStringAgainstPattern("KickPC", sCall))
      {
         dmwand_KickPC(oMyTarget, oMySpeaker);
         return;
      }

      if(TestStringAgainstPattern("JumpPlayerHere", sCall))
      {
         dmwand_JumpPlayerHere();
         return;
      }
      if(TestStringAgainstPattern("JumpToPlayer", sCall))
      {
         dmwand_JumpToPlayer();
         return;
      }
      if(TestStringAgainstPattern("JumpPartyHere", sCall))
      {
         dmwand_JumpPartyHere();
         return;
      }
   }
}
