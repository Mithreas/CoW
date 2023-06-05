#include "inc_chat"
#include "inc_common"

void main()
{
    string params = chatGetParams(OBJECT_SELF);
	gsCMOpenNUIWindow(OBJECT_SELF, params);
	
    chatVerifyCommand(OBJECT_SELF);
}