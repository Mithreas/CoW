#include "inc_effect"
#include "inc_math"
#include "inc_random"

// Applies the appropriate positives and negatives for the provided blood levels.
// This should be called whenever blood levels change to handle RP-related text.
void VampireApplyBloodChange(object char, float oldBlood, float newBlood)
{
    if (newBlood == -100.0)
    {
        FloatingTextStringOnCreature("Deprived of a fresh blood source for too long, you wither away into a dry husk.",
            char, FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), char);
        return;
    }
    else if (newBlood < 0.0)
    {
        string message = "";

        if (newBlood < -75.0 && oldBlood >= -75.0)
        {
            message = "The hunger is unbearable. You find it nearly impossible to resist the call of blood. You must feed, soon.";
        }
        else if (newBlood < -50.0 && oldBlood >= -50.0)
        {
            message = "Your thoughts are clouded by your desire for blood. You have to feed.";
        }
        else if (newBlood < -25.0 && oldBlood >= -25.0)
        {
            message = "You feel empty; hollow. You need to feed.";
        }
        else if (newBlood < 0.0 && oldBlood >= 0.0)
        {
            message = "You feel a hunger well deep inside of you. You want to feed.";
        }

        if (message != "")
        {
            FloatingTextStringOnCreature(message, char, FALSE);
        }
    }
}

// Returns TRUE if the provided character is a vampire.
int VampireIsVamp(object char)
{
    return gsSUGetSubRaceByName(GetSubRace(char)) == GS_SU_SPECIAL_VAMPIRE;
}

// Returns TRUE if the vampire is inside sunlight.
int VampireInSunlight(object char)
{
    object area = GetArea(char);
    int dayTime = GetIsDay() || GetIsDawn();
    int aboveGround = GetIsAreaAboveGround(area) == AREA_ABOVEGROUND;
    int interior = GetIsAreaInterior(area);
    return dayTime && aboveGround && !interior;
}

int VampireInGaseousForm(object char)
{
    return GetLocalInt(char, "VAMPIRE_IN_GASEOUS_FORM");
}

void VampireSetInGaseousForm(object char, int value)
{
    SetLocalInt(char, "VAMPIRE_IN_GASEOUS_FORM", value);
}

int VampireGetGaseousFormActiveTime(object char)
{
    return GetLocalInt(char, "VAMPIRE_GASEOUS_FORM_TIME");
}

void VampireSetGaseousFormActivateTime(object char, int value)
{
    SetLocalInt(char, "VAMPIRE_GASEOUS_FORM_TIME", value);
}

void _VampireApplyGaseousFormEffects(object char)
{
    ApplyTaggedEffectToObject(
        DURATION_TYPE_PERMANENT,
        ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE)),
        char,
        0.0,
        EFFECT_TAG_VAMPIRE);

    ApplyTaggedEffectToObject(
        DURATION_TYPE_PERMANENT,
        ExtraordinaryEffect(EffectCutsceneGhost()),
        char,
        0.0,
        EFFECT_TAG_VAMPIRE);

    ApplyTaggedEffectToObject(
        DURATION_TYPE_PERMANENT,
        ExtraordinaryEffect(EffectAttackDecrease(50, ATTACK_BONUS_MISC)),
        char,
        0.0,
        EFFECT_TAG_VAMPIRE);

    ApplyTaggedEffectToObject(
        DURATION_TYPE_PERMANENT,
        ExtraordinaryEffect(EffectSpellFailure(100)),
        char,
        0.0,
        EFFECT_TAG_VAMPIRE);
}

int VampireCanEnterGaseousForm(object char)
{
    int time = GetModuleTime();
    int timestamp = VampireGetGaseousFormActiveTime(char);
    int timeout = (1 * 60 * 60 * 24) / 10;  // Gaseous form can occur once every game day.
    return timestamp == 0 || abs(time - timestamp) >= timeout;
}

// This should be called once every round.
void VampireHeartbeat(object char, float blood)
{
    // First, remove all vampire tagged effects ...
    RemoveTaggedEffects(char, EFFECT_TAG_VAMPIRE);

    // Find the maximum extents of buffs we can have for our level.
    float level = IntToFloat(GetHitDice(char));

    int maxMoveSpeed = FloatToInt((level + 5.0) / 10.0) * 5; // 5% extra move speed every 10 levels starting at 5.
    int maxRegen = FloatToInt(level / 5.0) + 1; // 1 every 5 levels, scaling to +7 at level 30.

    int maxCon = 0; // +2 at 10, +2 at 30
    int maxStr = 0; // +1 at 1, +1 at 20
    int maxDex = 0; // +1 at 1, +1 at 20

    if (level >= 1.0)
    {
        maxStr += 1;
        maxDex += 1;
    }

    if (level >= 10.0)
    {
        maxCon += 2;
    }

    if (level >= 20.0)
    {
        maxStr += 1;
        maxDex += 1;
    }

    if (level >= 30.0)
    {
        maxCon += 2;
    }

    int moveSpeedToApply = 0;
    int regenToApply = 0;
    int conToApply = 0;
    int strToApply = 0;
    int dexToApply = 0;

    // The amount of consecutive rounds we've been in sunlight so far.
    int roundsInSunlight = GetLocalInt(char, "VAMPIRE_ROUNDS_IN_SUNLIGHT");

    if (VampireInSunlight(char))
    {
        // We're in the sunlight ... so we need to apply harsh penalties.
        roundsInSunlight += 1;

        string message = "";

        if (roundsInSunlight == 1)
        {
            message = "You step into the sunlight. It burns your skin.";
        }
        else if (roundsInSunlight == 4)
        {
            message = "The brightness is overpowering. You lose your vision.";
        }
        else if (roundsInSunlight == 7)
        {
            message = "You feel the exterior of your skin begin to sear.";
        }
        else if (roundsInSunlight == 10)
        {
            message = "Your body is wracked by the sunlight.";
        }
        else if (roundsInSunlight == 13)
        {
            message = "The pain is overwhelming. The end is near.";
        }
        else if (roundsInSunlight == 16)
        {
            // Instant death ... we've been in the sun far too long. Nearing a minute and a half.
            message = "You shuffle off this (im)mortal coil; your body is now ash.";
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), char);
            return;
        }

        if (message != "")
        {
            FloatingTextStringOnCreature(message, char, TRUE);
        }

        // We gain blindness from the fourth round onwards.
        if (roundsInSunlight >= 4)
        {
            ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectBlindness()), char, 0.0, EFFECT_TAG_VAMPIRE);
        }

        // Regen starting at -2 and doubling every round we're in the sun. E.g. -2, -4, -8, -16, so on and so forth
        regenToApply -= FloatToInt(pow(2.0, IntToFloat(roundsInSunlight)));

        // Automatically apply the maximum possible negatives.
        moveSpeedToApply -= maxMoveSpeed;
        conToApply -= maxCon;
        strToApply -= maxStr;
        dexToApply -= maxDex;
    }
    else
    {
        roundsInSunlight = 0;

        // Calculate blood related scaling bonuses.
        if (blood == 100.0)
        {
            moveSpeedToApply += MinInt(15, maxMoveSpeed);
            regenToApply += MinInt(6, maxRegen);
            conToApply += maxCon;
            strToApply += maxStr;
            dexToApply += maxDex;
        }
        else if (blood >= 75.0)
        {
            moveSpeedToApply += MinInt(10, maxMoveSpeed);
            regenToApply += MinInt(4, maxRegen);
            conToApply += MinInt(3, maxCon);
            strToApply += maxStr;
            dexToApply += maxDex;
        }
        else if (blood >= 50.0)
        {
            moveSpeedToApply += MinInt(5, maxMoveSpeed);
            regenToApply += MinInt(2, maxRegen);
            conToApply += MinInt(2, maxCon);
            strToApply += MinInt(1, maxStr);
            dexToApply += MinInt(1, maxDex);
        }
        else if (blood >= 25.0)
        {
            regenToApply += MinInt(1, maxRegen);
            conToApply += MinInt(1, maxCon);
        }
        else if (blood >= 0.0)
        {
            // No bonuses from 0 to 25.
        }
        // TODO: Negative drains don't worry, except regen, due to vamp's immunity to drain.
        // We need some way to bypass this.
        else if (blood >= -25.0)
        {
            conToApply -= MinInt(1, maxCon);
        }
        else if (blood >= -50.0)
        {
            conToApply -= MinInt(2, maxCon);
            strToApply -= MinInt(1, maxStr);
            dexToApply -= MinInt(1, maxDex);
        }
        else if (blood >= -75.0)
        {
            regenToApply -= MinInt(3, maxRegen);
            conToApply -= MinInt(3, maxCon);
            strToApply -= maxStr;
            dexToApply -= maxDex;
        }
        else
        {
            regenToApply -= MinInt(6, maxRegen);
            conToApply -= maxCon;
            strToApply -= maxStr;
            dexToApply -= maxDex;
        }
    }

    SetLocalInt(char, "VAMPIRE_ROUNDS_IN_SUNLIGHT", roundsInSunlight);

    // Now handle applying our bonuses.
    if (moveSpeedToApply)
    {
        // TODO: NWNX. For now we're just using move speed increase, which stacks incorrectly with haste.
        ApplyTaggedEffectToObject(
            DURATION_TYPE_PERMANENT,
            ExtraordinaryEffect(EffectMovementSpeedIncrease(moveSpeedToApply)),
            char,
            0.0,
            EFFECT_TAG_VAMPIRE);
    }

    if (regenToApply > 0)
    {
        if (GetCurrentHitPoints(char) < GetMaxHitPoints(char))
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(regenToApply), char);
        }
    }
    else if (regenToApply < 0)
    {
        if (GetCurrentHitPoints(char) + regenToApply > -10)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(-regenToApply), char);
        }
    }

    if (conToApply > 0)
    {
        ApplyTaggedEffectToObject(
            DURATION_TYPE_PERMANENT,
            ExtraordinaryEffect(EffectAbilityIncrease(ABILITY_CONSTITUTION, conToApply)),
            char,
            0.0,
            EFFECT_TAG_VAMPIRE);
    }
    else if (conToApply < 0)
    {
        ApplyTaggedEffectToObject(
            DURATION_TYPE_PERMANENT,
            ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_CONSTITUTION, conToApply)),
            char,
            0.0,
            EFFECT_TAG_VAMPIRE);
    }

    if (strToApply > 0)
    {
        ApplyTaggedEffectToObject(
            DURATION_TYPE_PERMANENT,
            ExtraordinaryEffect(EffectAbilityIncrease(ABILITY_STRENGTH, strToApply)),
            char,
            0.0,
            EFFECT_TAG_VAMPIRE);
    }
    else if (strToApply < 0)
    {
        ApplyTaggedEffectToObject(
            DURATION_TYPE_PERMANENT,
            ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_STRENGTH, strToApply)),
            char,
            0.0,
            EFFECT_TAG_VAMPIRE);
    }

    if (dexToApply > 0)
    {
        ApplyTaggedEffectToObject(
            DURATION_TYPE_PERMANENT,
            ExtraordinaryEffect(EffectAbilityIncrease(ABILITY_DEXTERITY, dexToApply)),
            char,
            0.0,
            EFFECT_TAG_VAMPIRE);
    }
    else if (dexToApply < 0)
    {
        ApplyTaggedEffectToObject(
            DURATION_TYPE_PERMANENT,
            ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_DEXTERITY, dexToApply)),
            char,
            0.0,
            EFFECT_TAG_VAMPIRE);
    }


    int gaseousForm = VampireInGaseousForm(char);

    if (gaseousForm)
    {
        int time = GetModuleTime();
        int timestamp = VampireGetGaseousFormActiveTime(char);
        int timeout = 12;  // Gaseous form lasts for 12 seconds.

        if (abs(time - timestamp) >= timeout)
        {
            SetImmortal(char, FALSE);
            FloatingTextStringOnCreature("You leave gaseous form, returning to your normal body.", char, TRUE);
            VampireSetInGaseousForm(char, FALSE);
        }
        else
        {
            _VampireApplyGaseousFormEffects(char);
        }
    }
}

// Returns TRUE if a bite attack is queued.
int VampireBiteAttackIsQueued(object char)
{
    return GetLocalInt(char, "VAMPIRE_BITE_QUEUED");
}

// Queues a bite attack.
void VampireBiteAttackSetQueued(object char, int value)
{
    SetLocalInt(char, "VAMPIRE_BITE_QUEUED", value);
}

// Resolves a bite attack from char to target, assuming that one is already queued.
// The return value is the amount of blood that should be drained.
float VampireBiteAttackResolve(object char, object target)
{
    float baseBlood = 2.5 * GetCreatureSize(char);

    int curHp = GetCurrentHitPoints(char);
    int maxHp = GetMaxHitPoints(char);

    if (curHp < maxHp)
    {
        int baseHealPercentageLow = 7 * GetCreatureSize(char);
        int baseHealPercentageHigh = ClampedRandom(0, baseHealPercentageLow);
        int baseHealPercentage = baseHealPercentageLow + baseHealPercentageHigh;

        int toHeal = MinInt(maxHp - curHp, FloatToInt(maxHp * (baseHealPercentage / 100.0)));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(toHeal), char);
    }

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL), target);

    return baseBlood;
}

void VampireEnterGaseousForm(object char)
{
    int time = GetModuleTime();
    VampireSetInGaseousForm(char, TRUE);
    VampireSetGaseousFormActivateTime(char, GetModuleTime());
    ApplyResurrection(char);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1 - GetCurrentHitPoints(char)), char);
    SetImmortal(char, TRUE);
    _VampireApplyGaseousFormEffects(char);
    FloatingTextStringOnCreature("You enter gaseous form and become immune to damage for a short time.", char, TRUE);
}

// Returns TRUE if the vampire is currently offering blood.
int VampireIsOffering(object char)
{
    return GetLocalInt(char, "VAMPIRE_BITE_QUEUED");
}

// Sets whether the vampire is currently offering blood.
void VampireSetOffering(object char, int value)
{
    SetLocalInt(char, "VAMPIRE_BITE_QUEUED", value);
}