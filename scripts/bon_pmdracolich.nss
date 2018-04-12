//::///////////////////////////////////////////////
//:: Bonus: Palemaster Dracolich
//:: bon_pmdracolich
//:://////////////////////////////////////////////
/*
    Updates presence of the dracolich stream
    for pale masters.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: March 9, 2017
//:://////////////////////////////////////////////

#include "inc_common"
#include "inc_levelbonuses"
#include "inc_sumstream"

void main()
{
    int nLevel = GetLevelBonusParamLevel(OBJECT_SELF);
    object oHide = gsPCGetCreatureHide(OBJECT_SELF);

    switch(GetLevelBonusParamApplyRemove(OBJECT_SELF))
    {
        case LEVEL_BONUS_APPLY:
            if(GetLevelByClass(CLASS_TYPE_PALEMASTER) == 1 && !GetKnowsSummonStream(OBJECT_SELF, STREAM_TYPE_DRAGON, STREAM_DRAGON_UNDEAD))
            {
                AddKnownSummonStream(OBJECT_SELF, STREAM_TYPE_DRAGON, STREAM_DRAGON_UNDEAD);
                SetLocalInt(oHide, "DracolichStreamFromPM", TRUE);
            }
            break;
        case LEVEL_BONUS_REMOVE:
            if(!GetLevelByClass(CLASS_TYPE_PALEMASTER) && GetLocalInt(oHide, "DracolichStreamFromPM"))
            {
                RemoveKnownSummonStream(OBJECT_SELF, STREAM_TYPE_DRAGON, STREAM_DRAGON_UNDEAD);
                DeleteLocalInt(oHide, "DracolichStreamFromPM");
            }
            break;
    }
}
