// awrit_co11
// Writ discard.

#include "inc_quest"

void main()
{
    object oSpeaker = GetPCSpeaker();
    object oWrit = GetQuestWrit(oSpeaker);

    DelayCommand(0.2, DestroyObject(oWrit));
}


