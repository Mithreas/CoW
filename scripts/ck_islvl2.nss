// Batra: edited ck_islvl10

int StartingConditional()
{

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetHitDice(GetPCSpeaker()) <= 2)
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
