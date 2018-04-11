// chat_ranger

#include "fb_inc_chatutils"
#include "gs_inc_common"
#include "inc_ranger"
#include "zzdlg_color_inc"
#include "inc_examine"
#include "nwnx_creature"

void main()
{

    // Set parameters
    object oPC = OBJECT_SELF;
    object oHide = gsPCGetCreatureHide(oPC);
    string sParams = chatGetParams(oPC);

    chatVerifyCommand(oPC);

    // Help String
    string sHelp = "This command allows a ranger to learn Studied Enemies as an expansion of the Favored Enemy system.  ";
    sHelp += "Every five class levels, a ranger may pick up an additional Favored Enemy feat by first slaying a hundred examples of the race ";
    sHelp += "she wishes to study.  Then she can use the console command " + txtYellow + "-ranger study [race name]</c> to pick up the ";
    sHelp += "appropriate favored enemy feat.\n";
    // sHelp += "A ranger may also use the command to unlearn a Studied Enemy.  She can do so by entering "+ txtYellow + "-ranger unlearn [race name]</c>.  ";
    // sHelp += "This may be useful to do just before leveling up, if the ranger wishes to pick that race as part of their Favored Enemy feat selection.";

    // Non-ranger.  Display help and end.
    if (!GetLevelByClass(CLASS_TYPE_RANGER, oPC))
    {
        DisplayTextInExamineWindow("-ranger", sHelp);
        SendMessageToPC(oPC, "You are not a ranger.");
        return;
    }

    // Combat log display of current Studied enemies.
    int nPossible = GetLevelByClass(CLASS_TYPE_RANGER, oPC) / 5;
    int nStudied = TotalStudiedEnemies(oPC);
    SendMessageToPC(oPC, "Total Studied Enemies: " + IntToString(nStudied) + " / " + IntToString(nPossible));

    int i, nFeat, nRacialType;
    for (i = 1; i <=6; i++)
    {
        nFeat = GetArrayInt(oHide, RSTUDIED, i);
        nRacialType = FeatToRacialType(nFeat);
        if (nRacialType != -1 && GetHasFeat(nFeat, oPC))
            SendMessageToPC(oPC, "Studied Enemy: " + RaceToStringName(nRacialType));
    }

    // Show help
    if (sParams == "?" || sParams == "")
    {
        DisplayTextInExamineWindow("-ranger", sHelp);
        return;
    }

    // Splice parameters.  Study or Unlearn.
    string sCommand = GetStringLowerCase(GetStringLeft(sParams, 5));
    string sEnteredRace;
    if (sCommand == "study")
        sEnteredRace = GetStringLowerCase(GetSubString(sParams, 6, GetStringLength(sParams) - 5));
    // else if (sCommand == "unlearn")
    //    sEnteredRace = GetStringLowerCase(GetSubString(sParams, 8, GetStringLength(sParams) - 7));
    else
    {
        DisplayTextInExamineWindow("-ranger", sHelp);
        return;
    }

    // Reset vars
    nFeat = 0;
    nRacialType = 0;

    // We're trying to learn a new Studied Enemy
    if (sCommand == "study")
    {
        if (nStudied >= nPossible)
        {
            SendMessageToPC(oPC, "You have already reached the maximum number of Studied Enemies you can have at your ranger level. (" + IntToString(nStudied) + " / " + IntToString(nPossible) + ")");
            return;
        }

        nRacialType = StringToRaceType(sEnteredRace);

        if (nRacialType == -1)
        {
            SendMessageToPC(oPC, "'" + sEnteredRace + "' is not a race that you can study as your enemy.");
            return;
        }

        // Confirmed race type
        nFeat = RaceToFEFeat(nRacialType);

        if (GetHasFeat(nFeat, oPC))
        {
            SendMessageToPC(oPC, "You have already studied the " + RaceToStringName(nRacialType) + ", and treat that race as a favored enemy.");
            return;
        }

        int nTally = GetArrayInt(oHide, RKILL, nRacialType);

        if (nTally < 100)
        {
            SendMessageToPC(oPC, "You must slay more examples of the " + RaceToStringName(nRacialType) + " race before you can count that race as a Studied Enemy.  Current count: " + IntToString(nTally) + " / 100");
            return;
        }

        // Now adding the Studied Enemy.  First, find a free slot.
        int nExistingFeat;
        int bAdded = FALSE;

        for (i = 1; i <=6; i++)
        {
            nExistingFeat = GetArrayInt(oHide, RSTUDIED, i);
            if (!bAdded && FeatToRacialType(nExistingFeat) == -1 && (!nExistingFeat || !GetHasFeat(nExistingFeat, oPC)))
            {
                AddKnownFeat(oPC, nFeat, GetLevelByClassLevel(oPC, CLASS_TYPE_RANGER, GetLevelByClass(CLASS_TYPE_RANGER, oPC)));
                SetArrayInt(oHide, RSTUDIED, i, nFeat);
                bAdded = TRUE;
            }
        }

        if (bAdded) SendMessageToPC(oPC, "You have thoroughly studied the " + RaceToStringName(nRacialType) + " race, and now treat it as a Favored Enemy.");
        else SendMessageToPC(oPC, "You have already reached the maximum number of Studied Enemies you can have at your ranger level. (" + IntToString(nPossible) + ")");
    }
    /* Uncomment if implementing the 'unlearn' option for -ranger
    else if (sCommand == "unlearn")
    {
        nRacialType = StringToRaceType(sEnteredRace);

        if (nRacialType == -1)
        {
            SendMessageToPC(oPC, "'" + sEnteredRace + "' is not a race that you can study as your enemy, let alone unlearn what you have studied about them.");
            return;
        }

        // Confirmed race type
        nFeat = RaceToFEFeat(nRacialType);

        if (!GetHasFeat(nFeat, oPC))
        {
            SendMessageToPC(oPC, "You have not studied " + RaceToStringName(nRacialType) + " to the point of treating that race as a Favored Enemy.");
            return;
        }

        // See if this is a learned feat
        int nExistingFeat;
        int bRemoved = FALSE;

        for (i = 1; i <=6; i++)
        {
            nExistingFeat = GetArrayInt(oHide, RSTUDIED, i);
            if (!bRemoved && nFeat == nExistingFeat)
            {
                // Remove Feat
                RemoveKnownFeat(oPC, nFeat);
                // Reset variable
                DeleteArrayInt(oHide, RSTUDIED, i);
                bRemoved = TRUE;
            }
        }
        if (bRemoved) SendMessageToPC(oPC, "You have ceased treating the " + RaceToStringName(nRacialType) + " race as a Studied Enemy, and emptied your mind of your knowledge of them.");
        else SendMessageToPC(oPC, "You have not studied " + RaceToStringName(nRacialType) + " to the point of treating that race as a Favored Enemy.");
    }
    */

}
