// Despite the function name, returns TRUE if the PC is at the henchman limit.

int StartingConditional()
{
    object oPC       = GetPCSpeaker();

    int nLoop, nCount = 0;

    for (nLoop = 1; nLoop <= GetMaxHenchmen(); nLoop++)
    {
        object oAssociate = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, nLoop);

        if (GetIsObjectValid(oAssociate))
            nCount++;
    }

    if (nCount < GetMaxHenchmen())
        return FALSE;

    return TRUE;
}
