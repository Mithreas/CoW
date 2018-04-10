// Return FALSE if the PC is 5 levels below the Henchman

int StartingConditional()
{
    object oPC       = GetPCSpeaker();
    object oHench     = OBJECT_SELF;
    int nLvl      = GetHitDice(oPC);
    int nHenchLvl = GetHitDice(oHench);

    if (nLvl < nHenchLvl - 5)
        return TRUE;

    return FALSE;
}
