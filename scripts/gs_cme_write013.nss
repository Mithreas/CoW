#include "inc_listener"

void main()
{
    string sMessage = gsLIGetLastMessage();
    sMessage        = GetStringLeft(sMessage, 400);

    gsLIClearLastMessage();
    SetLocalString(OBJECT_SELF, "GS_ME_TEXT_1", sMessage);
}
