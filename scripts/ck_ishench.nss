// Returns TRUE if the PC speaker is this henchman's boss.

int StartingConditional()
{
    object oPC       = GetPCSpeaker();
	   object oHench	   = OBJECT_SELF;
    int nLoop = 0;

    for (nLoop = 1; nLoop <= GetMaxHenchmen(); nLoop++)
    {
        object oAssociate = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, nLoop);

        if (GetIsObjectValid(oAssociate) && oAssociate == oHench)
            return TRUE;
    }


	   return FALSE;
}
