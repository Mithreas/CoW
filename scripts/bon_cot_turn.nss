//::///////////////////////////////////////////////
//:: Bonus: CoT Turn Undead
//:: bon_cot_turn
//:://////////////////////////////////////////////
/*
    Grants Turn Undead to CoT at level 6
    Divine Might at 8
    and Divine Shield at 10
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "inc_levelbonuses"

void main()
{
    // Get the level at which this function is called.
    int nLevel = GetLevelBonusParamLevel(OBJECT_SELF);

    // Not feat level
    if (nLevel != 10 && nLevel != 8 && nLevel != 6)
        return;

    int bApplyOrRemove = GetLevelBonusParamApplyRemove(OBJECT_SELF);

    if (bApplyOrRemove == LEVEL_BONUS_APPLY) {
        if (nLevel == 6) {
            // We already know this feat
            if (GetKnowsFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
            return;
            AddKnownFeat(OBJECT_SELF, FEAT_TURN_UNDEAD, GetLevelByClassLevel(OBJECT_SELF, CLASS_TYPE_DIVINECHAMPION, 6));
        } else if (nLevel == 8) {
            // We already know this feat
            if (GetKnowsFeat(FEAT_DIVINE_MIGHT, OBJECT_SELF))
            return;
            AddKnownFeat(OBJECT_SELF, FEAT_DIVINE_MIGHT, GetLevelByClassLevel(OBJECT_SELF, CLASS_TYPE_DIVINECHAMPION, 8));
        } else if (nLevel == 10) {
            // We already know this feat
            if (GetKnowsFeat(FEAT_DIVINE_SHIELD, OBJECT_SELF))
            return;
            AddKnownFeat(OBJECT_SELF, FEAT_DIVINE_SHIELD, GetLevelByClassLevel(OBJECT_SELF, CLASS_TYPE_DIVINECHAMPION, 10));
        }
    } else if (bApplyOrRemove == LEVEL_BONUS_REMOVE) {
        if (nLevel == 6)
            NWNX_Creature_RemoveFeat(OBJECT_SELF, FEAT_TURN_UNDEAD);
        else if (nLevel == 8)
            NWNX_Creature_RemoveFeat(OBJECT_SELF, FEAT_DIVINE_MIGHT);
        else if (nLevel == 10)
            NWNX_Creature_RemoveFeat(OBJECT_SELF, FEAT_DIVINE_SHIELD);
    }
}

