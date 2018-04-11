

int StartingConditional()
{
    if (!GetIsObjectValid(GetPCSpeaker())) return FALSE;
    return ( Random(12) == 0 );
}
