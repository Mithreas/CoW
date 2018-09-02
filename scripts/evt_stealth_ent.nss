#include "inc_names"
#include "inc_timelock"
#include "inc_divination"
#include "inc_xfer"
#include "inc_class"

void RoundStealthTimerIncrement()
{
    int existingTimer = GetLocalInt(OBJECT_SELF, "StealthTimer");

    if (existingTimer == -1) // We've exited stealth.
    {
        if (!GetLocalInt(OBJECT_SELF, "Reachable"))
        {
            // We're now reachable again.
            miFXUpdatePlayerReachable(OBJECT_SELF, TRUE);
            //SendMessageToPC(OBJECT_SELF, "You are now reachable by Speedy Messengers.");
        }
    }
    else
    {
        SetLocalInt(OBJECT_SELF, "StealthTimer", existingTimer + 6);

        if (existingTimer + 6 >= 30 && GetLocalInt(OBJECT_SELF, "Reachable"))
        {
            miFXUpdatePlayerReachable(OBJECT_SELF, FALSE);
            //SendMessageToPC(OBJECT_SELF, "You are no longer reachable by Speedy Messengers.");
        }

        DelayCommand(6.0, RoundStealthTimerIncrement());
    }
}

void main()
{

    object oPC = OBJECT_SELF;
    if (GetIsPC(oPC))
    {
        if(GetIsTimelocked(oPC, "Hide in Plain Sight"))
        {
            if(GetKnownFeatLevel(oPC, FEAT_HIDE_IN_PLAIN_SIGHT) >= 5) //the lowest level someone can get the feat
              NWNX_Creature_RemoveFeat(oPC, FEAT_HIDE_IN_PLAIN_SIGHT);
        }
        else if(!GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oPC))
        {
            UpdateRangerHiPS(oPC);
            if(GetIsShadowMage(oPC))
                AddShadowMageFeats(oPC);
            if (GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC) >= 5)
                AddKnownFeat(oPC, FEAT_HIDE_IN_PLAIN_SIGHT, GetLevelByClassLevel(oPC, CLASS_TYPE_SHADOWDANCER, 5));
        }

        if (GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oPC))
        {
            SetIsTimelockMuted(OBJECT_SELF, "Hide in Plain Sight", TRUE);
        }

        SetLocalInt(oPC, "StealthTimer", 0);
        DelayCommand(6.0, RoundStealthTimerIncrement());
        miDVGivePoints(oPC, ELEMENT_WATER, 1.0);
    }

    fbNAAddNameModifier(oPC, FB_NA_MODIFIER_STEALTH, "<c°°°>", "</c>");
}
