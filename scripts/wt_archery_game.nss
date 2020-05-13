#include "inc_rename"

void main()
{
    //Who is shooting?
    object oArcher = GetLastAttacker(OBJECT_SELF);
    string sArcherName = "";
    if(GetIsPC(oArcher) == TRUE) {
        sArcherName = svGetPCNameOverride(oArcher);
    }
    else {
        sArcherName = GetName(oArcher);
    }

    //Declare all the variables
    int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, oArcher);
    int nAbilityRoll = 0;
    int nWeaponFocusRoll = 0;
    int nImpCriticalRoll = 0;
    int nEpicFocusRoll = 0;
    string sPointScore = "";
    string sDistance = "";

    //Weapon Focus
    int nLongbowFocus = GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW, oArcher);
    int nShortbowFocus = GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW, oArcher);
    int nLightCrossbowFocus = GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW, oArcher);
    int nHeavyCrossbowFocus = GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW, oArcher);

    //Improved Critical
    int nLongbowImpCritical = GetHasFeat(FEAT_IMPROVED_CRITICAL_LONGBOW, oArcher);
    int nShortbowImpCritical = GetHasFeat(FEAT_IMPROVED_CRITICAL_SHORTBOW, oArcher);
    int nLightCrossbowImpCritical = GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW, oArcher);
    int nHeavyCrossbowImpCritical = GetHasFeat(FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW, oArcher);

    //Epic Weapon Focus
    int nLongbowEpicFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_LONGBOW, oArcher);
    int nShortbowEpicFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_LONGBOW, oArcher);
    int nLightCrossbowEpicFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_LIGHTCROSSBOW, oArcher);
    int nHeavyCrossbowEpicFocus = GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_HEAVYCROSSBOW, oArcher);

    //Zen Archery
    int nZenArchery = GetHasFeat(FEAT_ZEN_ARCHERY, oArcher);

    //Get Base Attack Bonus
    int nBAB = ((GetBaseAttackBonus(oArcher))/8) * d4(1);

    //Weapon Focus Variable
    if(nLongbowFocus || nShortbowFocus || nLightCrossbowFocus || nHeavyCrossbowFocus)
    {
        nWeaponFocusRoll = d4(1);
    }
    else
    {
        nWeaponFocusRoll = 0;
    };

    //Improved Critical Variable
    if(nLongbowImpCritical || nShortbowImpCritical || nLightCrossbowImpCritical || nHeavyCrossbowImpCritical)
    {
        nImpCriticalRoll = d4(1);
    }
    else
    {
        nImpCriticalRoll = 0;
    };

    //Epic Weapon Focus Variable
    if(nLongbowEpicFocus || nShortbowEpicFocus || nLightCrossbowEpicFocus || nHeavyCrossbowEpicFocus)
    {
        nEpicFocusRoll = d4(2);
    }
    else
    {
        nEpicFocusRoll = 0;
    };

    //Zen Archery Variable
    if(nZenArchery)
    {
        nAbilityRoll = GetAbilityModifier(ABILITY_WISDOM, oArcher);
    }
    else
    {
        nAbilityRoll = nDexMod;
    };

    //Tally the total score
    int nTotalScore = nWeaponFocusRoll + nImpCriticalRoll + nEpicFocusRoll + nBAB + nAbilityRoll;
    //int nTotalScore = 2;

    //Calculate Distance, then points
    if(GetDistanceBetween(oArcher, OBJECT_SELF) < 12.0)
    {
        //int nTotalScore = nRawScore;
        sDistance = " a short distance";

        //Match the score to point DCs
        if(nTotalScore <= 9)
        {
            sPointScore = "10";
        }
        else if((nTotalScore == 10) | (nTotalScore == 10))
        {
            sPointScore = "20";
        }
        else if(nTotalScore == 12)
        {
            sPointScore = "30";
        }
        else if((nTotalScore == 13) | (nTotalScore == 14))
        {
            sPointScore = "40";
        }
        else if(nTotalScore >= 15)
        {
            sPointScore = "a bullseye!  That's 50";
        }
    }
    else if((GetDistanceBetween(oArcher, OBJECT_SELF) <= 25.0) && (GetDistanceBetween(oArcher, OBJECT_SELF) >= 12.0))
    {
        //int nTotalScore = nRawScore;
        sDistance = " an average distance";

        //Match the score to point DCs
        if(nTotalScore <= 15)
        {
            sPointScore = "10";
        }
        else if((nTotalScore >= 16) && (nTotalScore <= 18))
        {
            sPointScore = "20";
        }
        else if((nTotalScore >= 19) && (nTotalScore <= 21))
        {
            sPointScore = "30";
        }
        else if((nTotalScore >= 22) && (nTotalScore <= 24))
        {
            sPointScore = "40";
        }
        else if(nTotalScore >= 25)
        {
            sPointScore = "a bullseye!  That's 50";
        }
    }
    else if((GetDistanceBetween(oArcher, OBJECT_SELF) > 25.0))
    {
        //int nTotalScore = nRawScore;
        sDistance = " a long distance";

        //Match the score to point DCs
        if(nTotalScore <= 24)
        {
            sPointScore = "10";
        }
        else if((nTotalScore >= 25) && (nTotalScore <= 27))
        {
            sPointScore = "20";
        }
        else if((nTotalScore >= 28) && (nTotalScore <= 30))
        {
            sPointScore = "30";
        }
        else if((nTotalScore >= 31) && (nTotalScore <= 32))
        {
            sPointScore = "40";
        }
        else if(nTotalScore >= 33)
        {
            sPointScore = "a bullseye!  That's 50";
        }
    };

    //Speak the string if it's the correct weapon type
    object oArcherWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oArcher);
    int nLevel = (GetLevelByPosition(1, oArcher)) + (GetLevelByPosition(2, oArcher)) + (GetLevelByPosition(3, oArcher));
    int nRealBAB = nLevel;
    //SetLocalInt(oArcher, "REPEAT_SPEAK", TRUE);
    if (nLevel > 20)
    {
        nRealBAB = nLevel - (((nLevel + 1)-20)/2);
    }
    if(GetWeaponRanged(oArcherWeapon) == TRUE)
    {
        if(GetLocalInt(oArcher, "REPEAT_SPEAK") == TRUE)
        {
            DelayCommand(2.0f, SpeakString(sArcherName + " scores " + sPointScore + " points from" + sDistance));
            DelayCommand(2.0f, FloatingTextStringOnCreature(sArcherName + " scores " + sPointScore + " points from" + sDistance, oArcher, FALSE));
            if (nRealBAB >= 16)
            {
                SetLocalInt(oArcher, "REPEAT_SPEAK", FALSE);
            }
        }
        else
        {
            SetLocalInt(oArcher, "REPEAT_SPEAK", TRUE);
        }
        AssignCommand(oArcher, ClearAllActions(TRUE));
    }
    else
    {
        if(d6(1) == 1)
        {
            FloatingTextStringOnCreature("You're doing it wrong!", oArcher, FALSE);
        }
    }
}
