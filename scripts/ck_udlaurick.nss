#include "ar_utils"
#include "inc_disguise"

int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    int nPerform = GetSkillRank(SKILL_PERFORM, oSpeaker);
    int nBluff   = GetSkillRank(SKILL_BLUFF, oSpeaker);
    int nSkillRank;

    if (nPerform > nBluff) nSkillRank = nPerform;
    else nSkillRank = nBluff;

    // Includes all UD races, outcasts, but not clamped slaves.
    if (ar_IsPureMonsterCharacter(oSpeaker))
    {
    	   return TRUE;
    }
    else if (ar_IsUDCharacter(oSpeaker, FALSE))
    {
    	   if (GetIsPCDisguised(oSpeaker) && nSkillRank > 40)
        	{
    	       return FALSE;
        	}
        return TRUE;
    }
    return FALSE;
}