#include "inc_listener"

void main()
{
    string sMessage = gsLIGetLastMessage();
    sMessage        = GetStringLeft(sMessage, 500);

    gsLIClearLastMessage();
    SetLocalString(OBJECT_SELF, "GS_ME_TEXT_2", sMessage);
}
