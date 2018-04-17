#include "inc_house_check"
int StartingConditional()
{
    return (!
    (
    isDrannis(GetPCSpeaker()) ||
    isErenia(GetPCSpeaker()) ||
    isRenerrin(GetPCSpeaker()) ||
    isImperial(GetPCSpeaker())
    ));
}
