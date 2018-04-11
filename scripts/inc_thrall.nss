#include "gs_inc_pc"
#include "inc_effect"
#include "inc_math"

// Returns TRUE if the character is currently offering blood.
int ThrallIsOffering(object char)
{
    return GetLocalInt(char, "THRALL_BITE_QUEUED");
}

// Sets whether a thrall is currently offering blood.
void ThrallSetOffering(object char, int value)
{
    SetLocalInt(char, "THRALL_BITE_QUEUED", value);
}

int ThrallGetLastFeedTime(object char)
{
    return GetLocalInt(gsPCGetCreatureHide(char), "THRALL_LAST_FEED_TIME");
}

void ThrallSetLastFeedTime(object char, int value)
{
    SetLocalInt(gsPCGetCreatureHide(char), "THRALL_LAST_FEED_TIME", value);
}

int ThrallGetFeedCount(object char)
{
    return GetLocalInt(gsPCGetCreatureHide(char), "THRALL_FEED_COUNT");
}

void ThrallSetFeedCount(object char, int value)
{
    SetLocalInt(gsPCGetCreatureHide(char), "THRALL_FEED_COUNT", value);
}

int ThrallGetLastFedFromTime(object char)
{
    return GetLocalInt(gsPCGetCreatureHide(char), "THRALL_LAST_FED_FROM_TIME");
}

void ThrallSetLastFedFromTime(object char, int value)
{
    SetLocalInt(gsPCGetCreatureHide(char), "THRALL_LAST_FED_FROM_TIME", value);
}

int ThrallGetFedFromCount(object char)
{
    return GetLocalInt(gsPCGetCreatureHide(char), "THRALL_FED_FROM_COUNT");
}

void ThrallSetFedFromCount(object char, int value)
{
    SetLocalInt(gsPCGetCreatureHide(char), "THRALL_FED_FROM_COUNT", value);
}

// This should be called once every round.
void ThrallHeartbeat(object char)
{
    // Remove any existing effects.
    RemoveTaggedEffects(char, EFFECT_TAG_VAMPIRE);

    // Reset last feed and fed from timers as appropriate.
    int time = GetModuleTime();

    int fedFromCount = ThrallGetFedFromCount(char);
    int feedCount = ThrallGetFeedCount(char);

    if (fedFromCount)
    {
        int lastFedFromTime = ThrallGetLastFedFromTime(char);
        int lastFedFromTimeout = (1 * 60 * 60 * 24) / 10; // 1 days, converted to 1 days of game time.
        if (abs(time - lastFedFromTime) >= lastFedFromTimeout)
        {
            ThrallSetFedFromCount(char, 0);
            FloatingTextStringOnCreature("You have fully recovered from your recent 'blood donation'.", char, FALSE);
            fedFromCount = 0;
        }
    }

    if (feedCount)
    {
        int lastFeedTime = ThrallGetLastFeedTime(char);
        int lastFeedTimeTimeout = (1 * 60 * 60 * 24 ) / 10; // 1 days, converted to 1 days of game time.
        if (abs(time - lastFeedTime) >= lastFeedTimeTimeout)
        {
            ThrallSetFeedCount(char, 0);
            FloatingTextStringOnCreature("The positive effects of your recent feeding have faded.", char, FALSE);
            feedCount = 0;
        }
    }

    int conBuffFromFeeding = MinInt(4, feedCount);
    int conDebuffFromBeingFedFrom = fedFromCount * 2;

    int finalResolvedCon = conBuffFromFeeding - conDebuffFromBeingFedFrom;

    if (finalResolvedCon > 0)
    {
        ApplyTaggedEffectToObject(
            DURATION_TYPE_PERMANENT,
            ExtraordinaryEffect(EffectAbilityIncrease(ABILITY_CONSTITUTION, finalResolvedCon)),
            char,
            0.0,
            EFFECT_TAG_VAMPIRE);
    }
    else if (finalResolvedCon < 0)
    {
        ApplyTaggedEffectToObject(
            DURATION_TYPE_PERMANENT,
            ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_CONSTITUTION, finalResolvedCon)),
            char,
            0.0,
            EFFECT_TAG_VAMPIRE);
    }
}
