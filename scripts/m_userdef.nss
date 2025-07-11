// For module wide events, such as HTTP Responses.
#include "nwnx_httpclient"
#include "nwnx_events"
void main()
{
    string sEvent = NWNX_Events_GetCurrentEvent();

    if (sEvent == "NWNX_ON_HTTPCLIENT_SUCCESS")
    {
		int nRequestId = StringToInt(NWNX_Events_GetEventData("REQUEST_ID"));
        struct NWNX_HTTPClient_Request rResponse = NWNX_HTTPClient_GetRequest(nRequestId);
        SendMessageToPC(GetFirstPC(), "AI Response: " + rResponse.sData);
    }
    else if (sEvent == "NWNX_ON_HTTPCLIENT_FAILED")
    {
        SendMessageToPC(GetFirstPC(), "HTTP request failed.");
    }
}