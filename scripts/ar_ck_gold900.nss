//::  Returns TRUE if PC has 900 or more gold

int StartingConditional()
{
    return GetGold(GetPCSpeaker()) >= 900;
}
