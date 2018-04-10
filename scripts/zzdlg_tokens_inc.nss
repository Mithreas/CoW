// zzdlg_tokens_inc
//
// Copyright 2005-2006 by Greyhawk0
//
//  English dependant as of now!
//
//  As of now, gender is treated as male, if both/none/other is the case. I know
// where to find the string tables, 4860ish, for somethings here. This would
// kindof mess up though in foreign languages. I guess for multi-lingual mods,
// they will need to do tons extra anyways.

// Token for Day/Night.
string dlgTokenDayNight(int bLower = TRUE);
string dlgTokenDayNight(int bLower = TRUE)
{
    if (GetIsDay() == TRUE)
    {
        if (bLower) return "day";
        else return "Day";
    }
    else
    {
        if (bLower) return "night";
        else return "Night";
    }
}

// Token for morning, afternoon, evening, night.
string dlgTokenQuarterDay(int bLower = TRUE);
string dlgTokenQuarterDay(int bLower = TRUE)
{
    int iHour = GetTimeHour();
    if (iHour < 6)          // 12:00am - 5:59am  night
    {
        if (bLower) return "night";
        else return "Night";
    }
    else if (iHour < 12)    // 6:00am  - 11:59am morning
    {
        if (bLower) return "morning";
        else return "Morning";
    }
    else if (iHour <= 18)   // 12:00pm - 5:59pm  afternoon
    {
        if (bLower) return "afternoon";
        else return "Afternoon";
    }
    else                    // 6:00pm  - 11:59pm evening
    {
        if (bLower) return "evening";
        else return "Evening";
    }
}

// Token for year.
string dlgTokenYear();
string dlgTokenYear()
{
    return ( IntToString( GetCalendarYear() ) );
}

// Token for month.
string dlgTokenMonth();
string dlgTokenMonth()
{
    return ( IntToString( GetCalendarMonth() ) );
}

// Token for day.
string dlgTokenDay();
string dlgTokenDay()
{
    return ( IntToString( GetCalendarDay() ) );
}

// Token for player name.
string dlgTokenPlayerName(object oTarget);
string dlgTokenPlayerName(object oTarget)
{
    return ( GetPCPlayerName(oTarget) );
}

// Token for full name.
string dlgTokenFullName(object oTarget);
string dlgTokenFullName(object oTarget)
{
    return ( GetName(oTarget) );
}

// Token for first name. Honestly a guess, but normal names should work.
string dlgTokenFirstName(object oTarget);
string dlgTokenFirstName(object oTarget)
{
    string sName =  GetName(oTarget);

    int iPos = FindSubString(sName, " ");

    sName = GetSubString(sName, 0, iPos);

    return ( sName );
}

// Token for last name. Honestly a guess, but normal names should work.
string dlgTokenLastName(object oTarget);
string dlgTokenLastName(object oTarget)
{
    string sName =  GetName(oTarget);

    int iPos = FindSubString(sName, " ");

    sName = GetSubString(sName, iPos + 1, GetStringLength(sName) - iPos);

    return ( sName );
}

// Token for hour. Militarytime == 0-23, otherwise 1-12 with am/pm tag.
string dlgTokenTime(int bMilitaryTime = FALSE, int bAM_PM = TRUE);
string dlgTokenTime(int bMilitaryTime = FALSE, int bAM_PM = TRUE)
{
    int iHour = GetTimeHour();
    int iMinutes = GetTimeMinute();
    int iSeconds = GetTimeSecond();

    if (bMilitaryTime)
    {
        return ( IntToString(iHour) + ":" + IntToString(iMinutes) + ":" + IntToString(iSeconds) );
    }
    else
    {
        string sTime;
        string sAM;
        if (iHour < 12)//am
        {
            if (iHour == 0) sTime = "12";
            sTime = ( IntToString(iHour) );
            sAM = "AM";
        }
        else
        {
            if (iHour == 12) sTime = "12";
            sTime = ( IntToString(iHour-12) );
            sAM = "PM";
        }

        sTime += ( ":" + IntToString(iMinutes) + ":" + IntToString(iSeconds) );
        if (bAM_PM) sTime += sAM;

        return sTime;
    }
}

// Token for Bitch/Bastard curse.
string dlgTokenBitchBastard(object oTarget, int bLower = TRUE);
string dlgTokenBitchBastard(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "bastard";
        else return "Bastard";
    }
    else
    {
        if (bLower) return "bitch";
        else return "Bitch";
    }
}

// Token for Boy/Girl.
string dlgTokenBoyGirl(object oTarget, int bLower = TRUE);
string dlgTokenBoyGirl(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "boy";
        else return "Boy";
    }
    else
    {
        if (bLower) return "girl";
        else return "Girl";
    }
}

// Token for Boy/Girl.
string dlgTokenSirMadam(object oTarget, int bLower = TRUE);
string dlgTokenSirMadam(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "sir";
        else return "Sir";
    }
    else
    {
        if (bLower) return "madam";
        else return "Madam";
    }
}

// Token for Man/Woman.
string dlgTokenManWoman(object oTarget, int bLower = TRUE);
string dlgTokenManWoman(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "man";
        else return "Man";
    }
    else
    {
        if (bLower) return "woman";
        else return "Woman";
    }
}

// Gives the name of the class, plural if specified. Uses the highest leveled
// class.
string dlgTokenClass(object oTarget, int bPlural = FALSE, int bLower = TRUE);
string dlgTokenClass(object oTarget, int bPlural = FALSE, int bLower = TRUE)
{
    int iLevel1 = GetLevelByClass(GetClassByPosition(1, oTarget), oTarget);
    int iLevel2 = GetLevelByClass(GetClassByPosition(2, oTarget), oTarget);
    int iLevel3 = GetLevelByClass(GetClassByPosition(3, oTarget), oTarget);
    int iBiggestClass;

    if (iLevel1 > iLevel2)
    {
        if (iLevel1 > iLevel3) iBiggestClass = GetClassByPosition(1, oTarget);
        else iBiggestClass = GetClassByPosition(3, oTarget);
    }
    else
    {
        if (iLevel2 > iLevel3) iBiggestClass = GetClassByPosition(2, oTarget);
        else iBiggestClass = GetClassByPosition(3, oTarget);
    }

    string sClassref;

    if (bPlural==TRUE) sClassref = Get2DAString( "classes", "Plural", iBiggestClass );
    else if (bLower==TRUE) sClassref = Get2DAString( "classes", "Lower", iBiggestClass );
    else sClassref = Get2DAString( "classes", "Name", iBiggestClass );

    string sClassname = GetStringByStrRef( StringToInt( sClassref ), GetGender( oTarget ) );

    if (bPlural && bLower) return ( GetStringLowerCase( sClassname ) );

    return ( sClassname );
}

// Grabs the diety.
string dlgTokenDiety(object oTarget);
string dlgTokenDiety(object oTarget)
{
    return ( GetDeity( oTarget ) );
}

//  Grabs whether the object is good, evil, or neutral in that respect.
string dlgTokenGoodEvil(object oTarget, int bLower = TRUE);
string dlgTokenGoodEvil(object oTarget, int bLower = TRUE)
{
    int iAlign = GetAlignmentGoodEvil(oTarget);
    if (iAlign == ALIGNMENT_GOOD)
    {
        if (bLower) return "good";
        else return "Good";
    }
    else if (iAlign == ALIGNMENT_EVIL)
    {
        if (bLower) return "evil";
        else return "Evil";
    }
    else
    {
        if (bLower) return "neutral";
        else return "Neutral";
    }
}

//  Grabs whether the object is lawful, chaotic, or neutral in that respect.
string dlgTokenLawfulChaotic(object oTarget, int bLower = TRUE);
string dlgTokenLawfulChaotic(object oTarget, int bLower = TRUE)
{
    int iAlign = GetAlignmentGoodEvil(oTarget);
    if (iAlign == ALIGNMENT_LAWFUL)
    {
        if (bLower) return "lawful";
        else return "Lawful";
    }
    else if (iAlign == ALIGNMENT_CHAOTIC)
    {
        if (bLower) return "chaotic";
        else return "Chaotic";
    }
    else
    {
        if (bLower) return "neutral";
        else return "Neutral";
    }
}

// Returns the alignment of the object. bLower1 is first word and bLower2 is second word.
string dlgTokenAlignment(object oTarget, int bLower1 = TRUE, int bLower2 = TRUE);
string dlgTokenAlignment(object oTarget, int bLower1 = TRUE, int bLower2 = TRUE)
{
    string sFirst = dlgTokenGoodEvil(oTarget, bLower1);
    string sSecond = dlgTokenLawfulChaotic(oTarget, bLower2);

    if (sFirst == "neutral" || sFirst == "Neutral")
    {
        if (sSecond == "neutral" || sSecond == "Neutral")
        {
            return ( ( bLower1?"t":"T" ) + "rue " + ( bLower2?"n":"N" ) + "eutral" );
        }
    }

    return ( sFirst + sSecond );
}

// Token for Brother/Sister.
string dlgTokenBrotherSister(object oTarget, int bLower = TRUE);
string dlgTokenBrotherSister(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "brother";
        else return "Brother";
    }
    else
    {
        if (bLower) return "sister";
        else return "Sister";
    }
}

// Token for He/She.
string dlgTokenHeShe(object oTarget, int bLower = TRUE);
string dlgTokenHeShe(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "he";
        else return "He";
    }
    else
    {
        if (bLower) return "she";
        else return "She";
    }
}

// Token for His/Hers.
string dlgTokenHisHers(object oTarget, int bLower = TRUE);
string dlgTokenHisHers(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "his";
        else return "His";
    }
    else
    {
        if (bLower) return "hers";
        else return "Hers";
    }
}

// Token for Him/Her.
string dlgTokenHimHer(object oTarget, int bLower = TRUE);
string dlgTokenHimHer(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "him";
        else return "Him";
    }
    else
    {
        if (bLower) return "her";
        else return "Her";
    }
}

// Token for Him/Her.
string dlgTokenHimHers(object oTarget, int bLower = TRUE);
string dlgTokenHimHers(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "him";
        else return "Him";
    }
    else
    {
        if (bLower) return "hers";
        else return "Hers";
    }
}

// Token for Lad/Lass.
string dlgTokenLadLass(object oTarget, int bLower = TRUE);
string dlgTokenLadLass(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "lad";
        else return "Lad";
    }
    else
    {
        if (bLower) return "lass";
        else return "Lass";
    }
}

// Token for Lord/Lady.
string dlgTokenLordLady(object oTarget, int bLower = TRUE);
string dlgTokenLordLady(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "lord";
        else return "Lord";
    }
    else
    {
        if (bLower) return "lady";
        else return "Lady";
    }
}

// Token for Male/Female.
string dlgTokenMaleFemale(object oTarget, int bLower = TRUE);
string dlgTokenMaleFemale(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "male";
        else return "Male";
    }
    else
    {
        if (bLower) return "female";
        else return "Female";
    }
}

// Token for Master/Mistress.
string dlgTokenMasterMistress(object oTarget, int bLower = TRUE);
string dlgTokenMasterMistress(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "master";
        else return "Master";
    }
    else
    {
        if (bLower) return "mistress";
        else return "Mistress";
    }
}

// Token for Mister/Missus.
string dlgTokenMisterMissus(object oTarget, int bLower = TRUE);
string dlgTokenMisterMissus(object oTarget, int bLower = TRUE)
{
    int iGender = GetGender(oTarget);
    if (iGender != GENDER_FEMALE)
    {
        if (bLower) return "mister";
        else return "Mister";
    }
    else
    {
        if (bLower) return "missus";
        else return "Missus";
    }
}

// Token for target's level.
string dlgTokenLevel(object oTarget);
string dlgTokenLevel(object oTarget)
{
    int iLevel = GetLevelByPosition(1, oTarget);
    iLevel += GetLevelByPosition(2, oTarget);
    iLevel += GetLevelByPosition(3, oTarget);
    return ( IntToString(iLevel) );
}

// Token for target's race.
string dlgTokenRace(object oTarget, int bPlural = FALSE, int bLower = TRUE);
string dlgTokenRace(object oTarget, int bPlural = FALSE, int bLower = TRUE)
{
    int iRace = GetRacialType(oTarget);

    string sRaceref;

    if (bPlural==TRUE) sRaceref = Get2DAString( "racialtypes", "NamePlural", iRace );
    else if (bLower==TRUE) sRaceref = Get2DAString( "racialtypes", "ConverNameLower", iRace );
    else sRaceref = Get2DAString( "racialtypes", "ConverName", iRace );

    string sRacename = GetStringByStrRef( StringToInt( sRaceref ), GetGender( oTarget ) );

    if (bPlural && bLower) return ( GetStringLowerCase( sRacename ) );

    return ( sRacename );
}

// Token for target's race.
string dlgTokenSubRace(object oTarget);
string dlgTokenSubRace(object oTarget)
{
    return ( GetSubRace(oTarget) );
}

