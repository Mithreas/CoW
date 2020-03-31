//::///////////////////////////////////////////////
//:: chat_losexp
//:: Chat utility for removing XP
//:://////////////////////////////////////////////
/*
    Provides a -function in the chat bar to 
	remove a certain amount of XP
*/
//:://////////////////////////////////////////////
//:: Created By: Kirito
//:: Created On: November 8, 2017
//:://////////////////////////////////////////////

//:: Includes
#include "inc_log"
#include "inc_chatutils.nss"
#include "x3_inc_string"
#include "inc_examine"
#include "inc_pc"
#include "inc_xp"

const string HELP = "This command will remove the amount of XP specified. Eg. -losexp 1500 will remove 1500 from the character. All uses of this function are logged for DM monitoring";

void main()
{ 
    object oSpeaker = OBJECT_SELF;
	object oHide = gsPCGetCreatureHide(oSpeaker);
	string sParams  = chatGetParams(oSpeaker);
	int nCharXP = GetXP(oSpeaker);
	int nSetXP = nCharXP;
	int nXPCount = GetLocalInt(oHide,"LoseXPCount");
	
	
        if (sParams == "?" || sParams == "")
	{
        DisplayTextInExamineWindow("-losexp", HELP);
	}
	else
	{
		int nRemoveXP = StringToInt(sParams);
		if (nRemoveXP == 0)
		{
			SendMessageToPC(oSpeaker, "Please enter a value greater than 0 after -losexp.  E.g -losexp 50.");
			return;
		}
		else if (nRemoveXP < 1) 
		{
			SendMessageToPC(oSpeaker, "Please do not try and exploit the tool.");
			nRemoveXP = nRemoveXP*-1;
			Log("LOSEXP", "PC " + GetName(oSpeaker) + ", attempted to remove negative experience points.");
		}
		
		if (nRemoveXP > nCharXP)
		{
			nSetXP = 1;
			nRemoveXP = nCharXP - 1;
		}
		else
		{
			nSetXP = nCharXP - nRemoveXP;
		}
		
		if (nSetXP < nCharXP && nSetXP > 0)
		{	
			//track number of times used
			if (nXPCount > 0)
			{ 
				nXPCount++;
			}
			else
			{
				nXPCount = 1;
			}
			SetLocalInt(oHide,"LoseXPCount", nXPCount);
			
			//Add skill points to pool
			int nSkillPoints = 0;
			//looking at previous XP needed to gain current level
			int nLevelXP = (GetHitDice(oSpeaker) - 1) * 1000; 
			int nXPPool = nRemoveXP;
			int nCount = 0;
			
			while (nXPPool >= nLevelXP && nCount < 30)
			{
				nSkillPoints = nSkillPoints + 2;
				nXPPool = nXPPool - nLevelXP;
				nLevelXP = nLevelXP - 1000;
				nCount++;
			}
			
			if (nCount >= 30 || nSkillPoints > 58)
			{
				SendMessageToPC(oSpeaker, "Something went wrong, please take a screen shot and report on the forums.");
				return;
			}
			else if (nSkillPoints > 0)
			{
				int nOldSkillPoints = GetLocalInt(oHide,"SkillPointPool");
				SetLocalInt(oHide,"SkillPointPool",nSkillPoints + nOldSkillPoints);
				SendMessageToPC(oSpeaker, "You can decrease " + IntToString(nSkillPoints + nOldSkillPoints) + " skillpoints now. WARNING: this option will be gone after you gain another level.");
				Log("LOSECRAFT", "PC " + GetName(oSpeaker) + "has used -losexp and gained" + IntToString(nSkillPoints) + " skill points. This gives a new total of " + IntToString(nSkillPoints + nOldSkillPoints) + " skill points.");
			}
			
			//remove the xp
			gsXPGiveExperience(oSpeaker, -nRemoveXP);
			SendMessageToPC(oSpeaker, "Removed " + IntToString(nRemoveXP) + " experience points.");
			Log("LOSEXP", "PC " + GetName(oSpeaker) + "has used -losexp " + IntToString(nXPCount) + " times, this time to  remove " + IntToString(nRemoveXP) + " experience points from " + IntToString(nCharXP) + " to " + IntToString(nSetXP) + ".");
			if (nSetXP < 1000)
			{
				SendMessageToPC(OBJECT_SELF, StringToRGBString("Do NOT log out at level 1, else you may lose everything in your inventory.",STRING_COLOR_RED));
			}
			
		}
		else
		{
			SendMessageToPC(oSpeaker, "Something went wrong, please take a screen shot and report on the forums.");
			return;
		}
	}
	chatVerifyCommand(oSpeaker);
}