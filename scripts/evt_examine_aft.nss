#include "inc_disguise"
#include "nwnx_events"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"

void main()
{
    object examiner = OBJECT_SELF;
    object examinee = NWNX_Object_StringToObject(NWNX_Events_GetEventData("EXAMINEE_OBJECT_ID"));
    int objectType = GetObjectType(examinee);
    if(GetLocalInt(examinee, "DO_NOT_REVERT") == 1) return;

    if (objectType == OBJECT_TYPE_ITEM)
    {
        string originalDescription = GetLocalString(examinee, "OriginalObjectDescription");
        DeleteLocalString(examinee, "OriginalObjectDescription");

        if (originalDescription != "")
        {
            SetDescription(examinee, originalDescription);
        }
    }
    else if (objectType == OBJECT_TYPE_CREATURE)
    {
        if (GetIsDM(examiner) || GetIsDM(examinee))
        {
            return;
        }

        SetDescription(examinee, GetLocalString(examinee, "MI_LOOK_OLD_DESC"));
        DeleteLocalString(examinee, "MI_LOOK_OLD_DESC");

        if (GetLocalInt(examiner, "MI_LOOK_BROKE_" + ObjectToString(examinee)))
        {
            HidePortrait(examinee);
        }
    }
}