

int StartingConditional()
{
    if (!GetIsObjectValid(GetPCSpeaker())) return FALSE;
    return ( Random(6) == 0 );
}
