//  ----------------------------------------------------------------------------
//  sj_debug_i
//  ----------------------------------------------------------------------------
/*
    Debug Library
/*
//  ----------------------------------------------------------------------------
/*
    Version: 0.00 - 26/06/04 - Sunjammer
    - cut-down version for use with sj_tilemagic_i

*/
//  ----------------------------------------------------------------------------


//  ----------------------------------------------------------------------------
//  CONSTANTS
//  ----------------------------------------------------------------------------

// name of setting variables
const string SJ_VAR_DEBUG_ACTIVE    = "sj_debug_active";
const string SJ_VAR_DEBUG_ERROR     = "sj_debug_error";
const string SJ_VAR_DEBUG_LEVEL     = "sj_debug_level";
const string SJ_VAR_DEBUG_VOLUME    = "sj_debug_volume";

// debug levels
const int SJ_DEBUG_LEVEL_ERROR      = 0;    // errors
const int SJ_DEBUG_LEVEL_TRACE      = 1;    // errors & trace
const int SJ_DEBUG_LEVEL_WATCH      = 2;    // errors & trace & watch

// debug volumes
const int SJ_DEBUG_VOLUME_SILENT    = 0;    // log
const int SJ_DEBUG_VOLUME_QUIET     = 1;    // log & DMs
const int SJ_DEBUG_VOLUME_NOISY     = 2;    // log & DMs & PCs

// prefixes for printing
const string SJ_DEBUG_PREFIX_ERROR  = "** ERROR: ";
const string SJ_DEBUG_PREFIX_TRACE  = "** TRACE: ";
const string SJ_DEBUG_PREFIX_WATCH  = "** WATCH: ";

// debug error message
const string SJ_DEBUG_TEXT_ERROR    = "An error occured at time when there was no-one to notify.  Please check the server log for details.";


//  ----------------------------------------------------------------------------
//  PROTOTYPES
//  ----------------------------------------------------------------------------

// Sends sMessage to all players
//  - sMessage:     string to display
void SendMessageToAllPCs(string sMessage);

// Writes sMessage to the server log file and sends it as a server message to
// all DMs and PCs as required. Arguements and module settings are interpreted
// so as to provide the most information to the most recipients.
//  - sMessage:     string to print/display
//  - nActive:      TRUE or FALSE, is subject to module settings
//  - nLevel:       SJ_DEBUG_LEVEL_* constant, is subject to module settings
//  - nVolume:      SJ_DEBUG_VOLUME_* constant, is subject to module settings
void SJ_Debug(string sMessage, int nActive = FALSE, int nLevel = 0, int nVolume = 0);

// Returns the module debug active state. The active state controls if debug
// messages are logged or displayed by default. The default active state can be
// overridden by nActive to TRUE in individual function calls.
//  * Returns:      TRUE or FALSE
//  * OnError:      returns FALSE
int SJ_Debug_GetActive();

// Returns the module debug level. The level contols which type of debug
// messages are logged or displayed. Messages exceeding the module debug level
// will be ignored.
//  * Returns:      SJ_DEBUG_LEVEL_* constant
//  * OnError:      returns 0
int SJ_Debug_GetLevel();

// Returns the module debug volume. The volume controls which clients apps will
// recieve any debug messages.
//  * Returns:      SJ_DEBUG_VOLUME_* constant
//  * OnError:      returns 0
int SJ_Debug_GetVolume();

// Returns the module debug error flag. The debug error flag ensures that at
// least one DM is notified if an error has occurred.
//  - OnError:       TRUE or FALSE
void SJ_Debug_SetErrorFlag(int nError);


//  ----------------------------------------------------------------------------
//  FUNCTIONS
//  ----------------------------------------------------------------------------

void SendMessageToAllPCs(string sMessage)
{
    // find each PC and display message
    object oPC = GetFirstPC();
    while(GetIsObjectValid(oPC))
    {
        SendMessageToPC(oPC, sMessage);
        oPC = GetNextPC();
    }
}

void SJ_Debug(string sMessage, int nActive = FALSE, int nLevel = 0, int nVolume = 0)
{
    // if either param or setting is active ...
    if(nActive || SJ_Debug_GetActive())
    {
        // and the level is within set level ...
        if(nLevel <= SJ_Debug_GetLevel())
        {
            // then start debugging!
            int nDebugVolume = SJ_Debug_GetVolume();

            // print to server log ...
            PrintString(sMessage);

            // and send message to DMs when either volume exceeds silent ...
            if(nVolume > SJ_DEBUG_VOLUME_SILENT || nDebugVolume > SJ_DEBUG_VOLUME_SILENT)
            {
                object oPC = GetFirstPC();
                while(GetIsObjectValid(oPC))
                {
                    // provided at least one DM is on:
                    if(GetIsDM(oPC))
                    {
                        // display debug message and crop the error flag
                        SendMessageToAllDMs(sMessage);
                        SJ_Debug_SetErrorFlag(FALSE);
                        break;
                    }
                    oPC = GetNextPC();
                }
            }

            // and send message to PCs when either volume exceeds quiet.
            if(nVolume > SJ_DEBUG_VOLUME_QUIET || nDebugVolume > SJ_DEBUG_VOLUME_QUIET)
            {
                SendMessageToAllPCs(sMessage);
            }
        }
    }
}


int SJ_Debug_GetActive()
{
    return GetLocalInt(GetModule(), SJ_VAR_DEBUG_ACTIVE);
}


int SJ_Debug_GetLevel()
{
    return GetLocalInt(GetModule(), SJ_VAR_DEBUG_LEVEL);
}


int SJ_Debug_GetVolume()
{
    return GetLocalInt(GetModule(), SJ_VAR_DEBUG_VOLUME);
}


void SJ_Debug_SetErrorFlag(int nError)
{
    SetLocalInt(GetModule(), SJ_VAR_DEBUG_ERROR, nError);
}
