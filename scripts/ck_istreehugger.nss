#include "inc_pc"
int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();
    int nBonus = GetLocalInt(gsPCGetCreatureHide(oSpeaker), "FL_BONUS_RGR_LEVELS");
    return GetLevelByClass(CLASS_TYPE_DRUID, oSpeaker) >= 4 ||
           GetLevelByClass(CLASS_TYPE_RANGER, oSpeaker) + nBonus >= 4;
}
