#include "nwnx_player"

// Creates an invisible object, forces the provided object to examine it, then immediately destroys it.
void DisplayTextInExamineWindow(string title, string text, object obj = OBJECT_SELF);

void DisplayTextInExamineWindow(string title, string text, object obj = OBJECT_SELF)
{
    object tempHelpObj = CreateObject(OBJECT_TYPE_PLACEABLE, "gs_null", GetLocation(obj));
    SetDescription(tempHelpObj, title + "\n\n" + text);
    NWNX_Player_ForcePlaceableExamineWindow(obj, tempHelpObj);
    DestroyObject(tempHelpObj);
}