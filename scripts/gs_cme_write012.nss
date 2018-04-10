#include "gs_inc_listener"

void main()
{
    string sMessage = gsLIGetLastMessage();
    sMessage        = GetStringLeft(sMessage, 64);

    gsLIClearLastMessage();
    SetLocalString(OBJECT_SELF, "GS_ME_TITLE", sMessage);
}
