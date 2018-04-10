#include "fb_inc_chat"

void main()
{
    SendMessageToPC(OBJECT_SELF, "-send_image has been removed; please use -project_image instead. Type -project_image ? for help.");
    chatVerifyCommand(OBJECT_SELF);
}