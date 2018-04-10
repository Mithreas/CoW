

int StartingConditional()
{
    if (!GetIsObjectValid(GetPCSpeaker())) return FALSE;
    return ( Random(3) == 0 );
}
