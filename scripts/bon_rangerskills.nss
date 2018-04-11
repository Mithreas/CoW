//::///////////////////////////////////////////////
//:: Bonus: Ranger Skills
//:: bon_rangerksills
//:://////////////////////////////////////////////
/*
    Grants an additional +2 skill points to
    rangers.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 11, 2016
//:://////////////////////////////////////////////

#include "gs_inc_common"
#include "inc_array"
#include "inc_generic"
#include "inc_levelbonuses"
#include "inc_generic"

// Reapplies ranger skill bonuses to the PC.
void ReapplyRangerSkills(object oPC);

void main()
{
    int nLevel = GetLevelBonusParamLevel(OBJECT_SELF);
    int nSkillBonus;
    object oHide = gsPCGetCreatureHide(OBJECT_SELF);

    if(!GetIntArraySize(oHide, "RangerSkillBonuses"))
    {
        CreateIntArray(oHide, "RangerSkillBonuses", 30);
    }

    switch(GetLevelBonusParamApplyRemove(OBJECT_SELF))
    {
        case LEVEL_BONUS_APPLY:
            if(NWNX_Creature_GetClassByLevel(OBJECT_SELF, nLevel) == CLASS_TYPE_RANGER)
            {
                IncreasePCSkillPoints(OBJECT_SELF, (nLevel == 1) ? 8 : 2, (nLevel == 1));
                // Track the level at which the bonus for nLevel was applied.
                SetArrayInt(oHide, "RangerSkillBonuses", nLevel - 1, GetHitDice(OBJECT_SELF));
            }
            break;
        case LEVEL_BONUS_REMOVE:
            if(!GetLocalInt(OBJECT_SELF, "RangerSkillsReapplied"))
            {
                SetLocalInt(OBJECT_SELF, "RangerSkillsReapplied", TRUE);
                DelayCommand(0.0, ReapplyRangerSkills(OBJECT_SELF));
            }
            break;
    }
}

//::///////////////////////////////////////////////
//:: ReapplyRangerSkills
//:://////////////////////////////////////////////
/*
    Reapplies ranger skill bonuses to the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 11, 2016
//:://////////////////////////////////////////////
void ReapplyRangerSkills(object oPC)
{
    int i;
    int nHitDice = GetHitDice(oPC);
    object oHide = gsPCGetCreatureHide(oPC);

    DeleteLocalInt(oPC, "RangerSkillsReapplied");
    for(i = PC_MIN_LEVEL; i <= PC_MAX_LEVEL; i++)
    {
        // Upon deleveling, for each element where the level at which the bonus was
        // applied exceeds our current level, reapply the skill bonus.
        if(GetArrayInt(oHide, "RangerSkillBonuses", i - 1) >= nHitDice && nHitDice >= i)
        {
            SetArrayInt(oHide, "RangerSkillBonuses", i - 1, 0);
            ApplyLevelBonuses(oPC, i, CLASS_TYPE_RANGER, "rangerskills", TRUE);
        }
    }
}
