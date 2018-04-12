#include "inc_chatutils"
void main()
{
    object oPC   = GetPCSpeaker();
    int nID      = GetLocalInt(OBJECT_SELF, "MI_BODYPART");
    int nValue   = StringToInt(chatGetLastMessage(oPC));

    if (nValue == -1) return;

    SetColor(oPC, nID, nValue);
}


