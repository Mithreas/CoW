#include "inc_chat"

void main()
{
    SendMessageToPC(OBJECT_SELF, "-familiar has been removed; please use -associate instead. Type -associate ? for help.");
    chatVerifyCommand(OBJECT_SELF);
}