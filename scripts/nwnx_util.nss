#include "nwnx"
  
 const string NWNX_Util = "NWNX_Util"; 
  
 const int NWNX_UTIL_RESREF_TYPE_NSS       = 2009;
 const int NWNX_UTIL_RESREF_TYPE_NCS       = 2010;
 const int NWNX_UTIL_RESREF_TYPE_AREA_ARE  = 2012;
 const int NWNX_UTIL_RESREF_TYPE_TWODA     = 2017;
 const int NWNX_UTIL_RESREF_TYPE_AREA_GIT  = 2023;
 const int NWNX_UTIL_RESREF_TYPE_ITEM      = 2025;
 const int NWNX_UTIL_RESREF_TYPE_CREATURE  = 2027;
 const int NWNX_UTIL_RESREF_TYPE_DIALOG    = 2029;
 const int NWNX_UTIL_RESREF_TYPE_TRIGGER   = 2032;
 const int NWNX_UTIL_RESREF_TYPE_SOUND     = 2035;
 const int NWNX_UTIL_RESREF_TYPE_ENCOUNTER = 2040;
 const int NWNX_UTIL_RESREF_TYPE_DOOR      = 2042;
 const int NWNX_UTIL_RESREF_TYPE_PLACEABLE = 2044;
 const int NWNX_UTIL_RESREF_TYPE_STORE     = 2051;
 const int NWNX_UTIL_RESREF_TYPE_WAYPOINT  = 2058;
  
 struct NWNX_Util_WorldTime
 {
     int nCalendarDay; 
     int nTimeOfDay; 
 };
  
 struct NWNX_Util_HighResTimestamp
 {
     int seconds; 
     int microseconds; 
 };
  
 string NWNX_Util_GetCurrentScriptName(int depth = 0);
  
 string NWNX_Util_GetAsciiTableString();
  
 int NWNX_Util_Hash(string str);
  
 string NWNX_Util_GetCustomToken(int customTokenNumber);
  
 itemproperty NWNX_Util_EffectToItemProperty(effect e);
  
 effect NWNX_Util_ItemPropertyToEffect(itemproperty ip);
  
 string NWNX_Util_StripColors(string str);
  
 int NWNX_Util_IsValidResRef(string resref, int type = NWNX_UTIL_RESREF_TYPE_CREATURE);
  
 string NWNX_Util_GetEnvironmentVariable(string sVarname);
  
 int NWNX_Util_GetMinutesPerHour();
  
 void NWNX_Util_SetMinutesPerHour(int minutes);
  
 string NWNX_Util_EncodeStringForURL(string str);
  
 int NWNX_Util_Get2DARowCount(string str);
  
 string NWNX_Util_GetFirstResRef(int nType, string sRegexFilter = "", int bModuleResourcesOnly = TRUE);
  
 string NWNX_Util_GetNextResRef();
  
 int NWNX_Util_GetServerTicksPerSecond();
  
 object NWNX_Util_GetLastCreatedObject(int nObjectType, int nNthLast = 1);
  
 string NWNX_Util_AddScript(string sFileName, string sScriptData, int bWrapIntoMain = FALSE, string sAlias = "NWNX");
  
 string NWNX_Util_GetNSSContents(string sScriptName, int nMaxLength = -1);
  
 int NWNX_Util_AddNSSFile(string sFileName, string sContents, string sAlias = "NWNX");
  
 int NWNX_Util_RemoveNWNXResourceFile(string sFileName, int nType, string sAlias = "NWNX");
  
 void NWNX_Util_SetInstructionLimit(int nInstructionLimit);
  
 int NWNX_Util_GetInstructionLimit();
  
 void NWNX_Util_SetInstructionsExecuted(int nInstructions);
  
 int NWNX_Util_GetInstructionsExecuted();
  
 int NWNX_Util_RegisterServerConsoleCommand(string sCommand, string sScriptChunk);
  
 void NWNX_Util_UnregisterServerConsoleCommand(string sCommand);
  
 int NWNX_Util_PluginExists(string sPlugin);
  
 string NWNX_Util_GetUserDirectory();
  
 int NWNX_Util_GetScriptReturnValue();
  
 object NWNX_Util_CreateDoor(string sResRef, location locLocation, string sNewTag = "", int nAppearanceType = -1);
  
 void NWNX_Util_SetItemActivator(object oObject);
  
 struct NWNX_Util_WorldTime NWNX_Util_GetWorldTime(float fAdjustment = 0.0f);
  
 void NWNX_Util_SetResourceOverride(int nResType, string sOldName, string sNewName);
  
 string NWNX_Util_GetResourceOverride(int nResType, string sName);
  
 int NWNX_Util_GetScriptParamIsSet(string sParamName);
  
 void NWNX_Util_SetDawnHour(int nDawnHour);
  
 void NWNX_Util_SetDuskHour(int nDuskHour);
  
 struct NWNX_Util_HighResTimestamp NWNX_Util_GetHighResTimeStamp();
  
  
 string NWNX_Util_GetCurrentScriptName(int depth = 0)
 {
     string sFunc = "GetCurrentScriptName";
     NWNX_PushArgumentInt(NWNX_Util, sFunc, depth);
     NWNX_CallFunction(NWNX_Util, sFunc);
     return NWNX_GetReturnValueString(NWNX_Util, sFunc);
 }
  
 string NWNX_Util_GetAsciiTableString()
 {
     string sFunc = "GetAsciiTableString";
     NWNX_CallFunction(NWNX_Util, sFunc);
     return NWNX_GetReturnValueString(NWNX_Util, sFunc);
 }
  
 int NWNX_Util_Hash(string str)
 {
     string sFunc = "Hash";
     NWNX_PushArgumentString(NWNX_Util, sFunc, str);
     NWNX_CallFunction(NWNX_Util, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Util, sFunc);
 }
  
 string NWNX_Util_GetCustomToken(int customTokenNumber)
 {
     string sFunc = "GetCustomToken";
     NWNX_PushArgumentInt(NWNX_Util, sFunc, customTokenNumber);
     NWNX_CallFunction(NWNX_Util, sFunc);
     return NWNX_GetReturnValueString(NWNX_Util, sFunc);
 }
  
 itemproperty NWNX_Util_EffectToItemProperty(effect e)
 {
     string sFunc = "EffectTypeCast";
     NWNX_PushArgumentEffect(NWNX_Util, sFunc, e);
     NWNX_CallFunction(NWNX_Util, sFunc);
     return NWNX_GetReturnValueItemProperty(NWNX_Util, sFunc);
 }
  
 effect NWNX_Util_ItemPropertyToEffect(itemproperty ip)
 {
     string sFunc = "EffectTypeCast";
     NWNX_PushArgumentItemProperty(NWNX_Util, sFunc, ip);
     NWNX_CallFunction(NWNX_Util, sFunc);
     return NWNX_GetReturnValueEffect(NWNX_Util, sFunc);
 }
  
 string NWNX_Util_StripColors(string str)
 {
     string sFunc = "StripColors";
     NWNX_PushArgumentString(NWNX_Util, sFunc, str);
     NWNX_CallFunction(NWNX_Util, sFunc);
     return NWNX_GetReturnValueString(NWNX_Util, sFunc);
 }
  
 int NWNX_Util_IsValidResRef(string resref, int type = NWNX_UTIL_RESREF_TYPE_CREATURE)
 {
     string sFunc = "IsValidResRef";
     NWNX_PushArgumentInt(NWNX_Util, sFunc, type);
     NWNX_PushArgumentString(NWNX_Util, sFunc, resref);
     NWNX_CallFunction(NWNX_Util, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Util, sFunc);
 }
  
 string NWNX_Util_GetEnvironmentVariable(string sVarname)
 {
     string sFunc = "GetEnvironmentVariable";
     NWNX_PushArgumentString(NWNX_Util, sFunc, sVarname);
     NWNX_CallFunction(NWNX_Util, sFunc);
     return NWNX_GetReturnValueString(NWNX_Util, sFunc);
 }
  
 int NWNX_Util_GetMinutesPerHour()
 {
     string sFunc = "GetMinutesPerHour";
     NWNX_CallFunction(NWNX_Util, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Util, sFunc);
 }
  
 void NWNX_Util_SetMinutesPerHour(int minutes)
 {
     string sFunc = "SetMinutesPerHour";
     NWNX_PushArgumentInt(NWNX_Util, sFunc, minutes);
     NWNX_CallFunction(NWNX_Util, sFunc);
 }
  
 string NWNX_Util_EncodeStringForURL(string sURL)
 {
     string sFunc = "EncodeStringForURL";
  
     NWNX_PushArgumentString(NWNX_Util, sFunc, sURL);
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     return NWNX_GetReturnValueString(NWNX_Util, sFunc);
 }
  
 int NWNX_Util_Get2DARowCount(string str)
 {
     string sFunc = "Get2DARowCount";
     NWNX_PushArgumentString(NWNX_Util, sFunc, str);
     NWNX_CallFunction(NWNX_Util, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Util, sFunc);
 }
  
 string NWNX_Util_GetFirstResRef(int nType, string sRegexFilter = "", int bModuleResourcesOnly = TRUE)
 {
     string sFunc = "GetFirstResRef";
  
     NWNX_PushArgumentInt(NWNX_Util, sFunc, bModuleResourcesOnly);
     NWNX_PushArgumentString(NWNX_Util, sFunc, sRegexFilter);
     NWNX_PushArgumentInt(NWNX_Util, sFunc, nType);
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     return NWNX_GetReturnValueString(NWNX_Util, sFunc);
 }
  
 string NWNX_Util_GetNextResRef()
 {
     string sFunc = "GetNextResRef";
  
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     return NWNX_GetReturnValueString(NWNX_Util, sFunc);
 }
  
 int NWNX_Util_GetServerTicksPerSecond()
 {
     string sFunc = "GetServerTicksPerSecond";
  
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Util, sFunc);
 }
  
 object NWNX_Util_GetLastCreatedObject(int nObjectType, int nNthLast = 1)
 {
     string sFunc = "GetLastCreatedObject";
  
     NWNX_PushArgumentInt(NWNX_Util, sFunc, nNthLast);
     NWNX_PushArgumentInt(NWNX_Util, sFunc, nObjectType);
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     return NWNX_GetReturnValueObject(NWNX_Util, sFunc);
 }
  
 string NWNX_Util_AddScript(string sFileName, string sScriptData, int bWrapIntoMain = FALSE, string sAlias = "NWNX")
 {
     string sFunc = "AddScript";
  
     NWNX_PushArgumentString(NWNX_Util, sFunc, sAlias);
     NWNX_PushArgumentInt(NWNX_Util, sFunc, bWrapIntoMain);
     NWNX_PushArgumentString(NWNX_Util, sFunc, sScriptData);
     NWNX_PushArgumentString(NWNX_Util, sFunc, sFileName);
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     return NWNX_GetReturnValueString(NWNX_Util, sFunc);
 }
  
 string NWNX_Util_GetNSSContents(string sScriptName, int nMaxLength = -1)
 {
     string sFunc = "GetNSSContents";
  
     NWNX_PushArgumentInt(NWNX_Util, sFunc, nMaxLength);
     NWNX_PushArgumentString(NWNX_Util, sFunc, sScriptName);
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     return NWNX_GetReturnValueString(NWNX_Util, sFunc);
 }
  
 int NWNX_Util_AddNSSFile(string sFileName, string sContents, string sAlias = "NWNX")
 {
     string sFunc = "AddNSSFile";
  
     NWNX_PushArgumentString(NWNX_Util, sFunc, sAlias);
     NWNX_PushArgumentString(NWNX_Util, sFunc, sContents);
     NWNX_PushArgumentString(NWNX_Util, sFunc, sFileName);
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Util, sFunc);
 }
  
 int NWNX_Util_RemoveNWNXResourceFile(string sFileName, int nType, string sAlias = "NWNX")
 {
     string sFunc = "RemoveNWNXResourceFile";
  
     NWNX_PushArgumentString(NWNX_Util, sFunc, sAlias);
     NWNX_PushArgumentInt(NWNX_Util, sFunc, nType);
     NWNX_PushArgumentString(NWNX_Util, sFunc, sFileName);
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Util, sFunc);
 }
  
 void NWNX_Util_SetInstructionLimit(int nInstructionLimit)
 {
     string sFunc = "SetInstructionLimit";
  
     NWNX_PushArgumentInt(NWNX_Util, sFunc, nInstructionLimit);
     NWNX_CallFunction(NWNX_Util, sFunc);
 }
  
 int NWNX_Util_GetInstructionLimit()
 {
     string sFunc = "GetInstructionLimit";
  
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Util, sFunc);
 }
  
 void NWNX_Util_SetInstructionsExecuted(int nInstructions)
 {
     string sFunc = "SetInstructionsExecuted";
  
     NWNX_PushArgumentInt(NWNX_Util, sFunc, nInstructions);
     NWNX_CallFunction(NWNX_Util, sFunc);
 }
  
 int NWNX_Util_GetInstructionsExecuted()
 {
     string sFunc = "GetInstructionsExecuted";
  
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Util, sFunc);
 }
  
 int NWNX_Util_RegisterServerConsoleCommand(string sCommand, string sScriptChunk)
 {
     string sFunc = "RegisterServerConsoleCommand";
  
     NWNX_PushArgumentString(NWNX_Util, sFunc, sScriptChunk);
     NWNX_PushArgumentString(NWNX_Util, sFunc, sCommand);
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Util, sFunc);
 }
  
 void NWNX_Util_UnregisterServerConsoleCommand(string sCommand)
 {
     string sFunc = "UnregisterServerConsoleCommand";
  
     NWNX_PushArgumentString(NWNX_Util, sFunc, sCommand);
     NWNX_CallFunction(NWNX_Util, sFunc);
 }
  
 int NWNX_Util_PluginExists(string sPlugin)
 {
     string sFunc = "PluginExists";
     NWNX_PushArgumentString(NWNX_Util, sFunc, sPlugin);
     NWNX_CallFunction(NWNX_Util, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Util, sFunc);
 }
  
 string NWNX_Util_GetUserDirectory()
 {
     string sFunc = "GetUserDirectory";
     NWNX_CallFunction(NWNX_Util, sFunc);
     return NWNX_GetReturnValueString(NWNX_Util, sFunc);
 }
  
 int NWNX_Util_GetScriptReturnValue()
 {
     string sFunc = "GetScriptReturnValue";
  
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Util, sFunc);
 }
  
 object NWNX_Util_CreateDoor(string sResRef, location locLocation, string sNewTag = "", int nAppearanceType = -1)
 {
     string sFunc = "CreateDoor";
  
     vector vPosition = GetPositionFromLocation(locLocation);
  
     NWNX_PushArgumentInt(NWNX_Util, sFunc, nAppearanceType);
     NWNX_PushArgumentString(NWNX_Util, sFunc, sNewTag);
     NWNX_PushArgumentFloat(NWNX_Util, sFunc, GetFacingFromLocation(locLocation));
     NWNX_PushArgumentFloat(NWNX_Util, sFunc, vPosition.z);
     NWNX_PushArgumentFloat(NWNX_Util, sFunc, vPosition.y);
     NWNX_PushArgumentFloat(NWNX_Util, sFunc, vPosition.x);
     NWNX_PushArgumentObject(NWNX_Util, sFunc, GetAreaFromLocation(locLocation));
     NWNX_PushArgumentString(NWNX_Util, sFunc, sResRef);
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     return NWNX_GetReturnValueObject(NWNX_Util, sFunc);
 }
  
 void NWNX_Util_SetItemActivator(object oObject)
 {
     string sFunc = "SetItemActivator";
  
     NWNX_PushArgumentObject(NWNX_Util, sFunc, oObject);
     NWNX_CallFunction(NWNX_Util, sFunc);
 }
  
 struct NWNX_Util_WorldTime NWNX_Util_GetWorldTime(float fAdjustment = 0.0f)
 {
     string sFunc = "GetWorldTime";
  
     NWNX_PushArgumentFloat(NWNX_Util, sFunc, fAdjustment);
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     struct NWNX_Util_WorldTime strWorldTime;
     strWorldTime.nTimeOfDay = NWNX_GetReturnValueInt(NWNX_Util, sFunc);
     strWorldTime.nCalendarDay = NWNX_GetReturnValueInt(NWNX_Util, sFunc);
  
     return strWorldTime;
 }
  
 void NWNX_Util_SetResourceOverride(int nResType, string sOldName, string sNewName)
 {
     string sFunc = "SetResourceOverride";
  
     NWNX_PushArgumentString(NWNX_Util, sFunc, sNewName);
     NWNX_PushArgumentString(NWNX_Util, sFunc, sOldName);
     NWNX_PushArgumentInt(NWNX_Util, sFunc, nResType);
     NWNX_CallFunction(NWNX_Util, sFunc);
 }
  
 string NWNX_Util_GetResourceOverride(int nResType, string sName)
 {
     string sFunc = "GetResourceOverride";
  
     NWNX_PushArgumentString(NWNX_Util, sFunc, sName);
     NWNX_PushArgumentInt(NWNX_Util, sFunc, nResType);
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     return NWNX_GetReturnValueString(NWNX_Util, sFunc);
 }
  
 int NWNX_Util_GetScriptParamIsSet(string sParamName)
 {
     string sFunc = "GetScriptParamIsSet";
  
     NWNX_PushArgumentString(NWNX_Util, sFunc, sParamName);
     NWNX_CallFunction(NWNX_Util, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Util, sFunc);
 }
  
 void NWNX_Util_SetDawnHour(int nDawnHour)
 {
     string sFunc = "SetDawnHour";
  
     NWNX_PushArgumentInt(NWNX_Util, sFunc, nDawnHour);
     NWNX_CallFunction(NWNX_Util, sFunc);
 }
  
 void NWNX_Util_SetDuskHour(int nDuskHour)
 {
     string sFunc = "SetDuskHour";
  
     NWNX_PushArgumentInt(NWNX_Util, sFunc, nDuskHour);
     NWNX_CallFunction(NWNX_Util, sFunc);
 }
  
 struct NWNX_Util_HighResTimestamp NWNX_Util_GetHighResTimeStamp()
 {
     struct NWNX_Util_HighResTimestamp t;
     string sFunc = "GetHighResTimeStamp";
  
     NWNX_CallFunction(NWNX_Util, sFunc);
     t.microseconds = NWNX_GetReturnValueInt(NWNX_Util, sFunc);
     t.seconds = NWNX_GetReturnValueInt(NWNX_Util, sFunc);
     return t;
 }