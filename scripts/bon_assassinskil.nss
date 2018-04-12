//::///////////////////////////////////////////////
//:: Bonus: Assassin Skills
//:: bon_assassinskil
//:://////////////////////////////////////////////
/*
    Grants an additional +2 skill points to
    assassins.
*/
//:://////////////////////////////////////////////

#include "inc_common"
#include "inc_array"
#include "inc_generic"
#include "inc_levelbonuses"
#include "inc_generic"

// Reapplies assassin skill bonuses to the PC.
void ReapplyAssassinSkills(object oPC);

void main()
{
    int nLevel = GetLevelBonusParamLevel(OBJECT_SELF);
    int nSkillBonus;
    object oHide = gsPCGetCreatureHide(OBJECT_SELF);

    if(!GetIntArraySize(oHide, "AssassinSkillBonuses"))
    {
        CreateIntArray(oHide, "AssassinSkillBonuses", 30);
    }

    switch(GetLevelBonusParamApplyRemove(OBJECT_SELF))
    {
        case LEVEL_BONUS_APPLY:
            if(NWNX_Creature_GetClassByLevel(OBJECT_SELF, nLevel) == CLASS_TYPE_ASSASSIN)
            {
                IncreasePCSkillPoints(OBJECT_SELF, (nLevel == 1) ? 8 : 2, (nLevel == 1));
                // Track the level at which the bonus for nLevel was applied.
                SetArrayInt(oHide, "AssassinSkillBonuses", nLevel - 1, GetHitDice(OBJECT_SELF));
            }
            break;
        case LEVEL_BONUS_REMOVE:
            if(!GetLocalInt(OBJECT_SELF, "AssassinSkillsReapplied"))
            {
                SetLocalInt(OBJECT_SELF, "AssassinSkillsReapplied", TRUE);
                DelayCommand(0.0, ReapplyAssassinSkills(OBJECT_SELF));
            }
            break;
    }
}

//::///////////////////////////////////////////////
//:: ReapplyAssassinSkills
//:://////////////////////////////////////////////
/*
    Reapplies assassin skill bonuses to the PC.
*/
//:://////////////////////////////////////////////
void ReapplyAssassinSkills(object oPC)
{
    int i;
    int nHitDice = GetHitDice(oPC);
    object oHide = gsPCGetCreatureHide(oPC);

    DeleteLocalInt(oPC, "AssassinSkillsReapplied");
    for(i = PC_MIN_LEVEL; i <= PC_MAX_LEVEL; i++)
    {
        // Upon deleveling, for each element where the level at which the bonus was
        // applied exceeds our current level, reapply the skill bonus.
        if(GetArrayInt(oHide, "AssassinSkillBonuses", i - 1) >= nHitDice && nHitDice >= i)
        {
            SetArrayInt(oHide, "AssassinSkillBonuses", i - 1, 0);
            ApplyLevelBonuses(oPC, i, CLASS_TYPE_ASSASSIN, "assassinskil", TRUE);
        }
    }
}
