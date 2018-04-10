int StartingConditional()
{
    object oCaptain     = GetObjectByTag("aas_captain");
    int iIsSailing      = GetLocalInt(oCaptain, "liAtSea");

    if (iIsSailing){
        return FALSE;
    }

    return TRUE;
}
