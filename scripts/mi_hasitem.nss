int StartingConditional()
{
    object nSpade = GetItemPossessedBy(GetPCSpeaker(), "per_spade");
    int nRetval = 0;

    if (nSpade != OBJECT_INVALID)
    {
      nRetval = 1;
    }

    return (nSpade != OBJECT_INVALID);
}
