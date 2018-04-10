//::  Returns TRUE if PC has 700 or more gold

int StartingConditional()
{
    return GetGold(GetPCSpeaker()) >= 700;
}
