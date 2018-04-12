#include "nw_o0_itemmaker"
#include "inc_chatutils"
#include "gs_inc_state"
#include "zzdlg_color_inc"
#include "inc_names"
#include "ar_utils"

const int SINGLE        = 0;
const int DOUBLE        = 1;
const int TRIPPLE       = 2;
const int OUTER_BULL    = 3;
const int INNER_BULL    = 4;

const float MSG_RADIUS          = 12.0f;
const string txtGreener         = "<c úš>";
const int SCORE_501             = 501;
const int SKILL_INCREASE_CAP    = 40;
const float DART_SKILL_INC      = 0.2;
const float MAX_DART_SKILL      = 13.0;
const string DART_SKILL         = "AR_DART_SKILL";

struct DartTarget {
    int nBoard;
    int nValue;
};

struct DartTarget getDartTarget(string sTarget) {
    sTarget = GetStringUpperCase(sTarget);
    sTarget = StringReplace(sTarget, " ", "");

    struct DartTarget dartTarget;
    dartTarget.nBoard  = -1;
    dartTarget.nValue  = -1;

    int len = 0;
    string sBoardStr = "";
    if      ( GetSubString(sTarget, 0, 6) == "SINGLE" )     { sBoardStr = "S"; len = 6; }
    else if ( GetSubString(sTarget, 0, 6) == "DOUBLE" )     { sBoardStr = "D"; len = 6; }
    else if ( GetSubString(sTarget, 0, 7) == "TRIPPLE" )    { sBoardStr = "T"; len = 7; }
    else if ( GetSubString(sTarget, 0, 2) == "OB" )         { sBoardStr = "OB"; len = 2; }
    else if ( GetSubString(sTarget, 0, 2) == "IB" )         { sBoardStr = "IB"; len = 2; }
    else if ( GetSubString(sTarget, 0, 9) == "OUTERBULL" )  { sBoardStr = "OB"; len = 9; }
    else if ( GetSubString(sTarget, 0, 9) == "INNERBULL" )  { sBoardStr = "IB"; len = 9; }
    else if ( GetSubString(sTarget, 0, 1) == "S" )          { sBoardStr = "S"; len = 1; }
    else if ( GetSubString(sTarget, 0, 1) == "D" )          { sBoardStr = "D"; len = 1; }
    else if ( GetSubString(sTarget, 0, 1) == "T" )          { sBoardStr = "T"; len = 1; }

    string sBoard = sBoardStr;
    string sValue = GetSubString(sTarget, len, GetStringLength(sTarget)-1);
    //SendMessageToPC(GetFirstPC(), "DEBUG String Board: " + sBoardStr + "   Value: " +  sValue);

    if (sBoard != "" && len != 0) {
        int nBoard = SINGLE;
        if (sBoard == "D")       nBoard = DOUBLE;
        else if (sBoard == "T")  nBoard = TRIPPLE;
        else if (sBoard == "OB") nBoard = OUTER_BULL;
        else if (sBoard == "IB") nBoard = INNER_BULL;

        dartTarget.nBoard  = nBoard;
        dartTarget.nValue  = sValue != "" ? StringToInt(sValue) : -1;

        //::  Bull
        if ( nBoard == OUTER_BULL )       dartTarget.nValue = 25;
        else if ( nBoard == INNER_BULL )  dartTarget.nValue = 50;
    }

    //::  If invalid values, just raondmize something as in 'Free throwing.
    //::  This for instance when the player does not give a proper target.
    if (dartTarget.nBoard == -1) {
        switch(d4()) {
            case 1:
            dartTarget.nBoard = SINGLE;
            break;
            case 2:
            dartTarget.nBoard = DOUBLE;
            break;
            case 3:
            dartTarget.nBoard = TRIPPLE;
            break;
            case 4:
            dartTarget.nBoard = d2() == 2 ? OUTER_BULL : INNER_BULL;
            break;
        }
    }
    if (dartTarget.nValue == -1) {
        dartTarget.nValue = d20();
        if ( dartTarget.nBoard == OUTER_BULL )       dartTarget.nValue = 25;
        else if ( dartTarget.nBoard == INNER_BULL )  dartTarget.nValue = 50;
    }

    //SendMessageToPC(GetFirstPC(), "DEBUG String Board (INT): " + IntToString(dartTarget.nBoard) + "   Value: " +  IntToString(dartTarget.nValue));
    return dartTarget;
}

void prettyFormat(object oPC, string sPrefix, string sMessage, int bUseSpeak = FALSE) {
    string sSuffix = sPrefix != "" ? "</c>" : "";

    if (!bUseSpeak) DelayCommand(0.5, FloatingTextStringOnCreature(sPrefix + sMessage + sSuffix, oPC, FALSE));
    else            DelayCommand(0.6, SpeakString(sPrefix + sMessage + sSuffix));
}

void abortAttack(object oPC) {
    DelayCommand(0.22, AssignCommand(oPC, ClearAllActions(TRUE)));
}

int getBonusRoll(object oPC, object oWeapon) {
    int nBonus = 0;
    float fSober = gsSTGetState(GS_ST_SOBRIETY, oPC);

    //::  Being a little bit drunk helps the roll.
    //::  Anything between [-1  to  -25] will increase roll.
    //::  After -25 Sobriety it gets negative instead.
    if ( fSober < 0.0 ) {
        int nSoberRoll = 0;

        if (fSober >= -25.0) {     //::  Positive
            float p = fabs(fSober) / 25.0;
            nSoberRoll = FloatToInt(6 * p);
        } else {                    //::  Negative
            float p = fabs(fSober-25.0) / 75.0;
            nSoberRoll = -FloatToInt(5 * p);
        }

        nBonus += nSoberRoll;
    }

    if ( GetHasFeat(FEAT_DIRTY_FIGHTING, oPC) )         nBonus += 2;
    if ( GetHasFeat(FEAT_ZEN_ARCHERY, oPC) )            nBonus += 2;
    if ( GetHasFeat(FEAT_WEAPON_FOCUS_DART, oPC) )      nBonus += 2;
    if ( GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_DART, oPC) ) nBonus += 2;

    //::  Every 10 rank of Spot gives another +1
    int nSpot = GetSkillRank(SKILL_SPOT, oPC);
    if (nSpot > 0) {
        nBonus += nSpot / 10;
    }

    //::  Every 10 rank of Concentration gives another +1
    int nConc = GetSkillRank(SKILL_CONCENTRATION, oPC);
    if (nConc > 0) {
        nBonus += nConc / 10;
    }

    //::  Negative CHA helps apparently according to the pro ;)
    int nCha = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    if ( nCha < 0 ) {
        nBonus += abs(nCha);
    }

    //::  Weapon Enchantment Bonus
    nBonus += IPGetWeaponEnhancementBonus(oWeapon);

    return nBonus;
}

//::  Sets up score datastructure arrays on board
void setup() {
    if ( GetLocalInt(OBJECT_SELF, "AR_ONCE") )   return;
    SetLocalInt(OBJECT_SELF, "AR_ONCE", TRUE);

    SetLocalArrayInt(OBJECT_SELF, "DART", 0, 20);
    SetLocalArrayInt(OBJECT_SELF, "DART", 1, 1);
    SetLocalArrayInt(OBJECT_SELF, "DART", 2, 18);
    SetLocalArrayInt(OBJECT_SELF, "DART", 3, 4);
    SetLocalArrayInt(OBJECT_SELF, "DART", 4, 13);
    SetLocalArrayInt(OBJECT_SELF, "DART", 5, 6);
    SetLocalArrayInt(OBJECT_SELF, "DART", 6, 10);
    SetLocalArrayInt(OBJECT_SELF, "DART", 7, 15);
    SetLocalArrayInt(OBJECT_SELF, "DART", 8, 2);
    SetLocalArrayInt(OBJECT_SELF, "DART", 9, 17);

    SetLocalArrayInt(OBJECT_SELF, "DART", 10, 3);
    SetLocalArrayInt(OBJECT_SELF, "DART", 11, 19);
    SetLocalArrayInt(OBJECT_SELF, "DART", 12, 7);
    SetLocalArrayInt(OBJECT_SELF, "DART", 13, 16);
    SetLocalArrayInt(OBJECT_SELF, "DART", 14, 8);
    SetLocalArrayInt(OBJECT_SELF, "DART", 15, 11);
    SetLocalArrayInt(OBJECT_SELF, "DART", 16, 14);
    SetLocalArrayInt(OBJECT_SELF, "DART", 17, 9);
    SetLocalArrayInt(OBJECT_SELF, "DART", 18, 12);
    SetLocalArrayInt(OBJECT_SELF, "DART", 19, 5);
}

int getDartDataIndex(int nValue) {
    int i = 0;

    for (; i < 20; i++) {
        int nVal = GetLocalArrayInt(OBJECT_SELF, "DART", i);
        if ( nVal == nValue ) return i;
    }

    return -1;
}

void main()
{
    setup();    //::  Only called once really, just setup data structure
    NWNX_Object_SetCurrentHitPoints(OBJECT_SELF, 10000);
    int bDebug = GetLocalInt(OBJECT_SELF, "AR_DEBUG");

    object oPC = GetLastAttacker();
    abortAttack(oPC);
    if ( !GetIsPC(oPC) && !GetIsDM(oPC) || !GetIsObjectValid(oPC) )   return;

    //::  Dist check
    float dist = GetDistanceBetween(oPC, OBJECT_SELF);
    if (dist <= 0.0 || dist > RADIUS_SIZE_COLOSSAL) {
        SendMessageToPC(oPC, "You're too far away to hit the Dartboard reliably.");
        return;
    }


    object oWeap = GetLastWeaponUsed(oPC);
    if ( !GetIsObjectValid(oWeap) )  return;

    int iWeapType = GetBaseItemType(oWeap);
    if (iWeapType != BASE_ITEM_DART)    return;

    //::  Get dartboard target
    string sTarget = chatGetLastMessage(oPC);
    struct DartTarget dartTarget = getDartTarget(sTarget);

    int nDataIndex  = getDartDataIndex(dartTarget.nValue);   //::  Array position for Dart Target score value...  ugly
    int bSingle     = dartTarget.nBoard == SINGLE;
    int bDouble     = dartTarget.nBoard == DOUBLE;
    int bTripple    = dartTarget.nBoard == TRIPPLE;
    int bOB         = dartTarget.nBoard == OUTER_BULL;
    int bIB         = dartTarget.nBoard == INNER_BULL;
    if (bOB || bIB) nDataIndex = -1 + d20();

    if (dartTarget.nBoard == -1 || dartTarget.nValue == -1 || nDataIndex == -1) {
        SendMessageToPC(oPC, txtRed + "Invalid Hit!  Did you format the text correct?  E.g 'S20' before throwing the dart?</c>");
        return;
    }


    //::  Calc Player Dart roll
    object oHide = gsPCGetCreatureHide(oPC);
    float fCurrentDartSkill = GetLocalFloat(oHide, DART_SKILL);
    int nMulDC           = dartTarget.nBoard + 1;
    int nDC              = 10 + (6*nMulDC);     //::  DC at 16 SINGLE, 22 DOUBLE, 28 TRIPPLE, 34 Outer Bull, 40 Inner Bull
    int nBounce          = 3 * nMulDC;
    int nDartSkillBonus  = FloatToInt(fCurrentDartSkill);
    int nBonus           = getBonusRoll(oPC, oWeap) + nDartSkillBonus;
    int nDiceRoll        = d20();
    int nRoll            = nDiceRoll + nBonus;
    float fRatio         = IntToFloat(nRoll / nDC);
    int nPlayerScoreLeft = GetLocalInt(oPC, "DART_SCORE") == 0 ? SCORE_501 : GetLocalInt(oPC, "DART_SCORE");
    int nScore           = 0;

    if (bDebug)
        SendMessageToPC(oPC, "Roll was: " + IntToString(nRoll) + " (Dice: " + IntToString(nDiceRoll) + " Bonus: " + IntToString(nBonus) + ") " + " against DC " + IntToString(nDC) + "  Array Index: " + IntToString(nDataIndex));

    //::  Natural 20, always success!
    if (nDiceRoll == 20) fRatio = 1.0;

    //::  Bounce Failure or rolling 1!
    if (d100() <= nBounce || nDiceRoll == 1) {
        ar_MessageAllPlayersInRadius(oPC, txtRed, fbNAGetGlobalDynamicName(oPC) + "'s dart bounced!", TRUE, MSG_RADIUS);
        return;
    }

    //::  Great Success!
    if ( fRatio >= 1.0 ) {
        nScore = !bOB && !bIB ? dartTarget.nValue * nMulDC : dartTarget.nValue;
        string sTargetScore = dartTarget.nBoard == SINGLE ? "Single" : dartTarget.nBoard == DOUBLE ? "Double" : "Treble";
        if (bOB)        sTargetScore = "Outer Bull";
        else if (bIB)   sTargetScore = "Inner Bull";
        else            sTargetScore = sTargetScore + " " + IntToString(dartTarget.nValue);

        ar_MessageAllPlayersInRadius(oPC, txtGreener, fbNAGetGlobalDynamicName(oPC) + " hit the target " + sTargetScore + "!", TRUE, MSG_RADIUS);
    }
    //::  No so great...
    else {
        float p = 1.0 - fRatio;

        //::  Cap it
        if ( nDartSkillBonus > 6 ) nDartSkillBonus = 6;

        int nHorCap = FloatToInt((8-nDartSkillBonus) * p);          //::  Cap values are narrowed down for more experienced dart players
        int nVerCap = FloatToInt((8-dartTarget.nBoard) * p);        //::  Closer to Bullseye better chance not to miss board entirely!


        int nFluctuationHor = -nHorCap + Random((nHorCap+1)*2);
        int nFluctuationVer = -nVerCap + Random((nVerCap+1)*2);

        //::  Can never miss board if good enough
        if (nDartSkillBonus > 4) nFluctuationVer = Random(8-nDartSkillBonus);

        //::  Visualize the dart board as a 2D grid sort of, yeah makes sense...  probably
        //::  Get new offshot position on the dart board
        int nHorPos = nDataIndex + nFluctuationHor;
        int nVerPos = nFluctuationVer;

        if (nVerPos < 0 || nVerPos > 7) {
            ar_MessageAllPlayersInRadius(oPC, txtRed, fbNAGetGlobalDynamicName(oPC) + " missed the board!", TRUE, MSG_RADIUS);
            return;
        }

        //::  Loop horizontal
        if (nHorPos < 0)        nHorPos = 20 + nHorPos;
        else if (nHorPos > 19)  nHorPos = nHorPos - 20;

        //::  We fluked the shot but we might have gotten some score anyway
        int nMul = SINGLE;
        int nBoard = dartTarget.nBoard;
        if (nVerPos == 0) nMul = nBoard; //::  We got the shot anyway, vertically
        else if (nVerPos % 2 != 0 ) {
            if      ( nBoard == SINGLE )  nMul = nVerPos > 0 ? DOUBLE : TRIPPLE;
            else if ( nBoard == DOUBLE )  nMul = SINGLE;
            else if ( nBoard == TRIPPLE ) nMul = SINGLE;
        }
        else if (nVerPos % 2 == 0 ) {
            if      ( nBoard == SINGLE )  nMul = SINGLE;
            else if ( nBoard == DOUBLE )  nMul = TRIPPLE;
            else if ( nBoard == TRIPPLE ) nMul = nVerPos > 0 ? DOUBLE : SINGLE;
        }

        dartTarget.nBoard = nMul;
        string prefix = nMul == SINGLE ? "Single" : nMul == DOUBLE ? "Double" : "Treble";
        nMul++;

        int nScoreVal = GetLocalArrayInt(OBJECT_SELF, "DART", nHorPos);
        nScore = nScoreVal * nMul;

        ar_MessageAllPlayersInRadius(oPC, txtOrange, fbNAGetGlobalDynamicName(oPC) + " fallouts at " + prefix + " " + IntToString(nScoreVal) + ".", TRUE, MSG_RADIUS);
    }


    //::  Check results
    if (nPlayerScoreLeft - nScore < 0 || nPlayerScoreLeft - nScore == 1) {
        nPlayerScoreLeft = nPlayerScoreLeft;
        prettyFormat(OBJECT_SELF, txtRed, fbNAGetGlobalDynamicName(oPC) + " busted with a score of " + IntToString(nPlayerScoreLeft - nScore) + ". Score reset to " + IntToString(nPlayerScoreLeft) + ".", TRUE);
    }
    //::  Win?
    else if (nPlayerScoreLeft - nScore == 0) {
        if ( dartTarget.nBoard == DOUBLE || dartTarget.nBoard == INNER_BULL ) {    //::  Win
            nPlayerScoreLeft = SCORE_501;
            prettyFormat(OBJECT_SELF, txtLime, fbNAGetGlobalDynamicName(oPC) + " won the Leg!", TRUE);
        }
        else {
            nPlayerScoreLeft = nPlayerScoreLeft;
            prettyFormat(OBJECT_SELF, txtRed, fbNAGetGlobalDynamicName(oPC) + " didn't end with a Double. Score reset to " + IntToString(nPlayerScoreLeft) + ".", TRUE);
        }
    }
    //::
    else {
        nPlayerScoreLeft -= nScore;
        prettyFormat(OBJECT_SELF, txtOlive, "Current Score for " + fbNAGetGlobalDynamicName(oPC) + " " + IntToString(nPlayerScoreLeft) + ".", TRUE);
    }

    //::  Increase Player Dart Skill
    int nThrownDarts = GetLocalInt(oPC, "DART_THROWN") + 1;
    if (nThrownDarts >= SKILL_INCREASE_CAP) {
        nThrownDarts = 0;

        if ( fCurrentDartSkill < MAX_DART_SKILL ) {
            SetLocalFloat(oHide, DART_SKILL, fCurrentDartSkill + DART_SKILL_INC);
            SendMessageToPC(oPC, txtGreen + "Your dart skill has increased.</c>");
        }
    }
    SetLocalInt(oPC, "DART_THROWN", nThrownDarts);

    //::  Keep track of Player Score
    SetLocalInt(oPC, "DART_SCORE", nPlayerScoreLeft);
}
