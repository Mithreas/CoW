#include "nwnx"
  
 const string NWNX_Object = "NWNX_Object"; 
  
 const int NWNX_OBJECT_LOCALVAR_TYPE_UNKNOWN  = 0;
 const int NWNX_OBJECT_LOCALVAR_TYPE_INT      = 1;
 const int NWNX_OBJECT_LOCALVAR_TYPE_FLOAT    = 2;
 const int NWNX_OBJECT_LOCALVAR_TYPE_STRING   = 3;
 const int NWNX_OBJECT_LOCALVAR_TYPE_OBJECT   = 4;
 const int NWNX_OBJECT_LOCALVAR_TYPE_LOCATION = 5;
  
 const int NWNX_OBJECT_TYPE_INTERNAL_INVALID = -1;
 const int NWNX_OBJECT_TYPE_INTERNAL_GUI = 1;
 const int NWNX_OBJECT_TYPE_INTERNAL_TILE = 2;
 const int NWNX_OBJECT_TYPE_INTERNAL_MODULE = 3;
 const int NWNX_OBJECT_TYPE_INTERNAL_AREA = 4;
 const int NWNX_OBJECT_TYPE_INTERNAL_CREATURE = 5;
 const int NWNX_OBJECT_TYPE_INTERNAL_ITEM = 6;
 const int NWNX_OBJECT_TYPE_INTERNAL_TRIGGER = 7;
 const int NWNX_OBJECT_TYPE_INTERNAL_PROJECTILE = 8;
 const int NWNX_OBJECT_TYPE_INTERNAL_PLACEABLE = 9;
 const int NWNX_OBJECT_TYPE_INTERNAL_DOOR = 10;
 const int NWNX_OBJECT_TYPE_INTERNAL_AREAOFEFFECT = 11;
 const int NWNX_OBJECT_TYPE_INTERNAL_WAYPOINT = 12;
 const int NWNX_OBJECT_TYPE_INTERNAL_ENCOUNTER = 13;
 const int NWNX_OBJECT_TYPE_INTERNAL_STORE = 14;
 const int NWNX_OBJECT_TYPE_INTERNAL_PORTAL = 15;
 const int NWNX_OBJECT_TYPE_INTERNAL_SOUND = 16;
  
 struct NWNX_Object_LocalVariable
 {
     int type; 
     string key; 
 };
  
 int NWNX_Object_GetLocalVariableCount(object obj);
  
 struct NWNX_Object_LocalVariable NWNX_Object_GetLocalVariable(object obj, int index);
  
 object NWNX_Object_StringToObject(string id);
  
 void NWNX_Object_SetPosition(object oObject, vector vPosition, int bUpdateSubareas = TRUE);
  
 int NWNX_Object_GetCurrentHitPoints(object obj);
  
 void NWNX_Object_SetCurrentHitPoints(object obj, int hp);
  
 void NWNX_Object_SetMaxHitPoints(object obj, int hp);
  
 string NWNX_Object_Serialize(object obj);
  
 object NWNX_Object_Deserialize(string serialized);
  
 string NWNX_Object_GetDialogResref(object obj);
  
 void NWNX_Object_SetDialogResref(object obj, string dialog);
  
 void NWNX_Object_SetAppearance(object oPlaceable, int nAppearance);
  
 int NWNX_Object_GetAppearance(object oPlaceable);
  
 int NWNX_Object_GetHasVisualEffect(object obj, int nVFX);
  
 int NWNX_Object_CheckFit(object obj, int baseitem);
  
 int NWNX_Object_GetDamageImmunity(object obj, int damageType);
  
 void NWNX_Object_AddToArea(object obj, object area, vector pos);
  
 int NWNX_Object_GetPlaceableIsStatic(object obj);
  
 void NWNX_Object_SetPlaceableIsStatic(object obj, int isStatic);
  
 int NWNX_Object_GetAutoRemoveKey(object obj);
  
 void NWNX_Object_SetAutoRemoveKey(object obj, int bRemoveKey);
  
 string NWNX_Object_GetTriggerGeometry(object oTrigger);
  
 void NWNX_Object_SetTriggerGeometry(object oTrigger, string sGeometry);
  
 void NWNX_Object_AddIconEffect(object obj, int nIcon, float fDuration=0.0);
  
 void NWNX_Object_RemoveIconEffect(object obj, int nIcon);
  
 void NWNX_Object_Export(string sFileName, object oObject);
  
 int NWNX_Object_GetInt(object oObject, string sVarName);
  
 void NWNX_Object_SetInt(object oObject, string sVarName, int nValue, int bPersist);
  
 void NWNX_Object_DeleteInt(object oObject, string sVarName);
  
 string NWNX_Object_GetString(object oObject, string sVarName);
  
 void NWNX_Object_SetString(object oObject, string sVarName, string sValue, int bPersist);
  
 void NWNX_Object_DeleteString(object oObject, string sVarName);
  
 float NWNX_Object_GetFloat(object oObject, string sVarName);
  
 void NWNX_Object_SetFloat(object oObject, string sVarName, float fValue, int bPersist);
  
 void NWNX_Object_DeleteFloat(object oObject, string sVarName);
  
 void NWNX_Object_DeleteVarRegex(object oObject, string sRegex);
  
 int NWNX_Object_GetPositionIsInTrigger(object oTrigger, vector vPosition);
  
 int NWNX_Object_GetInternalObjectType(object oObject);
  
 int NWNX_Object_AcquireItem(object oObject, object oItem);
  
 void NWNX_Object_SetFacing(object oObject, float fDirection);
  
 void NWNX_Object_ClearSpellEffectsOnOthers(object oObject);
  
 string NWNX_Object_PeekUUID(object oObject);
  
 int NWNX_Object_GetDoorHasVisibleModel(object oDoor);
  
 int NWNX_Object_GetIsDestroyable(object oObject);
  
 int NWNX_Object_DoSpellImmunity(object oDefender, object oCaster);
  
 int NWNX_Object_DoSpellLevelAbsorption(object oDefender, object oCaster);
  
 void NWNX_Object_SetHasInventory(object obj, int bHasInventory);
  
 int NWNX_Object_GetCurrentAnimation(object oObject);
  
 int NWNX_Object_GetAILevel(object oObject);
  
 void NWNX_Object_SetAILevel(object oObject, int nLevel);
  
  
 int NWNX_Object_GetLocalVariableCount(object obj)
 {
     string sFunc = "GetLocalVariableCount";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, obj);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Object, sFunc);
 }
  
 struct NWNX_Object_LocalVariable NWNX_Object_GetLocalVariable(object obj, int index)
 {
     string sFunc = "GetLocalVariable";
  
     NWNX_PushArgumentInt(NWNX_Object, sFunc, index);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, obj);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     struct NWNX_Object_LocalVariable var;
     var.key  = NWNX_GetReturnValueString(NWNX_Object, sFunc);
     var.type = NWNX_GetReturnValueInt(NWNX_Object, sFunc);
     return var;
 }
  
 object NWNX_Object_StringToObject(string id)
 {
     WriteTimestampedLogEntry("WARNING: NWNX_Object_StringToObject() is deprecated, please use the basegame's StringToObject()");
  
     return StringToObject(id);
 }
  
 void NWNX_Object_SetPosition(object oObject, vector vPosition, int bUpdateSubareas = TRUE)
 {
     string sFunc = "SetPosition";
  
     NWNX_PushArgumentInt(NWNX_Object, sFunc, bUpdateSubareas);
     NWNX_PushArgumentFloat(NWNX_Object, sFunc, vPosition.x);
     NWNX_PushArgumentFloat(NWNX_Object, sFunc, vPosition.y);
     NWNX_PushArgumentFloat(NWNX_Object, sFunc, vPosition.z);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
  
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 int NWNX_Object_GetCurrentHitPoints(object creature)
 {
     string sFunc = "GetCurrentHitPoints";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, creature);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_SetCurrentHitPoints(object creature, int hp)
 {
     string sFunc = "SetCurrentHitPoints";
  
     NWNX_PushArgumentInt(NWNX_Object, sFunc, hp);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_SetMaxHitPoints(object creature, int hp)
 {
     string sFunc = "SetMaxHitPoints";
  
     NWNX_PushArgumentInt(NWNX_Object, sFunc, hp);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 string NWNX_Object_Serialize(object obj)
 {
     string sFunc = "Serialize";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, obj);
  
     NWNX_CallFunction(NWNX_Object, sFunc);
     return NWNX_GetReturnValueString(NWNX_Object, sFunc);
 }
  
 object NWNX_Object_Deserialize(string serialized)
 {
     string sFunc = "Deserialize";
  
     NWNX_PushArgumentString(NWNX_Object, sFunc, serialized);
  
     NWNX_CallFunction(NWNX_Object, sFunc);
     return NWNX_GetReturnValueObject(NWNX_Object, sFunc);
 }
  
 string NWNX_Object_GetDialogResref(object obj)
 {
     string sFunc = "GetDialogResref";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, obj);
  
     NWNX_CallFunction(NWNX_Object, sFunc);
     return NWNX_GetReturnValueString(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_SetDialogResref(object obj, string dialog)
 {
     string sFunc = "SetDialogResref";
  
     NWNX_PushArgumentString(NWNX_Object, sFunc, dialog);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, obj);
  
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_SetAppearance(object oPlaceable, int nAppearance)
 {
     string sFunc = "SetAppearance";
  
     NWNX_PushArgumentInt(NWNX_Object, sFunc, nAppearance);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oPlaceable);
  
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 int NWNX_Object_GetAppearance(object oPlaceable)
 {
     string sFunc = "GetAppearance";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oPlaceable);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Object, sFunc);
 }
  
 int NWNX_Object_GetHasVisualEffect(object obj, int nVFX)
 {
     string sFunc = "GetHasVisualEffect";
  
     NWNX_PushArgumentInt(NWNX_Object, sFunc, nVFX);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, obj);
  
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Object, sFunc);
 }
  
 int NWNX_Object_CheckFit(object obj, int baseitem)
 {
     string sFunc = "CheckFit";
  
     NWNX_PushArgumentInt(NWNX_Object, sFunc, baseitem);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, obj);
  
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Object, sFunc);
 }
  
 int NWNX_Object_GetDamageImmunity(object obj, int damageType)
 {
     string sFunc = "GetDamageImmunity";
  
     NWNX_PushArgumentInt(NWNX_Object, sFunc, damageType);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, obj);
  
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_AddToArea(object obj, object area, vector pos)
 {
     string sFunc = "AddToArea";
  
     NWNX_PushArgumentFloat(NWNX_Object, sFunc, pos.z);
     NWNX_PushArgumentFloat(NWNX_Object, sFunc, pos.y);
     NWNX_PushArgumentFloat(NWNX_Object, sFunc, pos.x);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, area);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, obj);
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 int NWNX_Object_GetPlaceableIsStatic(object obj)
 {
     string sFunc = "GetPlaceableIsStatic";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, obj);
  
     NWNX_CallFunction(NWNX_Object, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_SetPlaceableIsStatic(object obj, int isStatic)
 {
     string sFunc = "SetPlaceableIsStatic";
  
     NWNX_PushArgumentInt(NWNX_Object, sFunc, isStatic);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, obj);
  
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 int NWNX_Object_GetAutoRemoveKey(object obj)
 {
     string sFunc = "GetAutoRemoveKey";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, obj);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_SetAutoRemoveKey(object obj, int bRemoveKey)
 {
     string sFunc = "SetAutoRemoveKey";
  
     NWNX_PushArgumentInt(NWNX_Object, sFunc, bRemoveKey);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, obj);
  
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 string NWNX_Object_GetTriggerGeometry(object oTrigger)
 {
     string sFunc = "GetTriggerGeometry";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oTrigger);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueString(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_SetTriggerGeometry(object oTrigger, string sGeometry)
 {
     string sFunc = "SetTriggerGeometry";
  
     NWNX_PushArgumentString(NWNX_Object, sFunc, sGeometry);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oTrigger);
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_AddIconEffect(object obj, int nIcon, float fDuration=0.0)
 {
     string sFunc = "AddIconEffect";
  
     NWNX_PushArgumentFloat(NWNX_Object, sFunc, fDuration);
     NWNX_PushArgumentInt(NWNX_Object, sFunc, nIcon);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, obj);
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_RemoveIconEffect(object obj, int nIcon)
 {
     string sFunc = "RemoveIconEffect";
  
     NWNX_PushArgumentInt(NWNX_Object, sFunc, nIcon);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, obj);
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_Export(string sFileName, object oObject)
 {
     string sFunc = "Export";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_PushArgumentString(NWNX_Object, sFunc, sFileName);
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 int NWNX_Object_GetInt(object oObject, string sVarName)
 {
     string sFunc = "GetInt";
  
     NWNX_PushArgumentString(NWNX_Object, sFunc, sVarName);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_SetInt(object oObject, string sVarName, int nValue, int bPersist)
 {
     string sFunc = "SetInt";
  
     NWNX_PushArgumentInt(NWNX_Object, sFunc, bPersist);
     NWNX_PushArgumentInt(NWNX_Object, sFunc, nValue);
     NWNX_PushArgumentString(NWNX_Object, sFunc, sVarName);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_DeleteInt(object oObject, string sVarName)
 {
     string sFunc = "DeleteInt";
  
     NWNX_PushArgumentString(NWNX_Object, sFunc, sVarName);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 string NWNX_Object_GetString(object oObject, string sVarName)
 {
     string sFunc = "GetString";
  
     NWNX_PushArgumentString(NWNX_Object, sFunc, sVarName);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueString(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_SetString(object oObject, string sVarName, string sValue, int bPersist)
 {
     string sFunc = "SetString";
  
     NWNX_PushArgumentInt(NWNX_Object, sFunc, bPersist);
     NWNX_PushArgumentString(NWNX_Object, sFunc, sValue);
     NWNX_PushArgumentString(NWNX_Object, sFunc, sVarName);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_DeleteString(object oObject, string sVarName)
 {
     string sFunc = "DeleteString";
  
     NWNX_PushArgumentString(NWNX_Object, sFunc, sVarName);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 float NWNX_Object_GetFloat(object oObject, string sVarName)
 {
     string sFunc = "GetFloat";
  
     NWNX_PushArgumentString(NWNX_Object, sFunc, sVarName);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueFloat(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_SetFloat(object oObject, string sVarName, float fValue, int bPersist)
 {
     string sFunc = "SetFloat";
  
     NWNX_PushArgumentInt(NWNX_Object, sFunc, bPersist);
     NWNX_PushArgumentFloat(NWNX_Object, sFunc, fValue);
     NWNX_PushArgumentString(NWNX_Object, sFunc, sVarName);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_DeleteFloat(object oObject, string sVarName)
 {
     string sFunc = "DeleteFloat";
  
     NWNX_PushArgumentString(NWNX_Object, sFunc, sVarName);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_DeleteVarRegex(object oObject, string sRegex)
 {
     string sFunc = "DeleteVarRegex";
  
     NWNX_PushArgumentString(NWNX_Object, sFunc, sRegex);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 int NWNX_Object_GetPositionIsInTrigger(object oTrigger, vector vPosition)
 {
     string sFunc = "GetPositionIsInTrigger";
  
     NWNX_PushArgumentFloat(NWNX_Object, sFunc, vPosition.z);
     NWNX_PushArgumentFloat(NWNX_Object, sFunc, vPosition.y);
     NWNX_PushArgumentFloat(NWNX_Object, sFunc, vPosition.x);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oTrigger);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Object, sFunc);
 }
  
 int NWNX_Object_GetInternalObjectType(object oObject)
 {
     string sFunc = "GetInternalObjectType";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Object, sFunc);
 }
  
 int NWNX_Object_AcquireItem(object oObject, object oItem)
 {
     string sFunc = "AcquireItem";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oItem);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_SetFacing(object oObject, float fDirection)
 {
     string sFunc = "SetFacing";
  
     NWNX_PushArgumentFloat(NWNX_Object, sFunc, fDirection);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_ClearSpellEffectsOnOthers(object oObject)
 {
     string sFunc = "ClearSpellEffectsOnOthers";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 string NWNX_Object_PeekUUID(object oObject)
 {
     string sFunc = "PeekUUID";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueString(NWNX_Object, sFunc);
 }
  
 int NWNX_Object_GetDoorHasVisibleModel(object oDoor)
 {
     string sFunc = "GetDoorHasVisibleModel";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oDoor);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Object, sFunc);
 }
  
 int NWNX_Object_GetIsDestroyable(object oObject)
 {
     string sFunc = "GetIsDestroyable";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Object, sFunc);
 }
  
 int NWNX_Object_DoSpellImmunity(object oDefender, object oCaster)
 {
     string sFunc = "DoSpellImmunity";
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oCaster);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oDefender);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return  NWNX_GetReturnValueInt(NWNX_Object,sFunc);
 }
  
 int NWNX_Object_DoSpellLevelAbsorption(object oDefender, object oCaster)
 {
     string sFunc = "DoSpellLevelAbsorption";
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oCaster);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oDefender);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return  NWNX_GetReturnValueInt(NWNX_Object,sFunc);
 }
  
 void NWNX_Object_SetHasInventory(object obj, int bHasInventory)
 {
     string sFunc = "SetHasInventory";
  
     NWNX_PushArgumentInt(NWNX_Object, sFunc, bHasInventory);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, obj);
  
     NWNX_CallFunction(NWNX_Object, sFunc);
 }
  
 int NWNX_Object_GetCurrentAnimation(object oObject)
 {
     string sFunc = "GetCurrentAnimation";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Object, sFunc);
 }
  
 int NWNX_Object_GetAILevel(object oObject)
 {
     string sFunc = "GetAILevel";
  
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
     NWNX_CallFunction(NWNX_Object, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Object, sFunc);
 }
  
 void NWNX_Object_SetAILevel(object oObject, int nLevel)
 {
     string sFunc = "SetAILevel";
  
     NWNX_PushArgumentInt(NWNX_Object, sFunc, nLevel);
     NWNX_PushArgumentObject(NWNX_Object, sFunc, oObject);
  
     NWNX_CallFunction(NWNX_Object, sFunc);
 }