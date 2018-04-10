#include "fb_inc_chatutils"
#include "gs_inc_pc"
#include "inc_examine"

const string HELP = "-hood [variant]. Dons a hood. If variant is passed in, equips that variant instead.";

const int INVALID_HEAD_ID = 0;

int getDesiredHeadId(int variant);
void toggleHood(int desiredHeadId);
void restoreHead();

void main()
{
    string params = chatGetParams(OBJECT_SELF);

    if (params == "?")
    {
        DisplayTextInExamineWindow("-hood", HELP);
    }
    else
    {
        int toggle = params == "" ? TRUE : FALSE;
        int desiredHeadId = getDesiredHeadId(StringToInt(params));

        if (desiredHeadId == INVALID_HEAD_ID)
        {
            SendMessageToPC(OBJECT_SELF, "No hood exists for your appearance type!");
        }
        else
        {
            if (!toggle)
            {
                restoreHead(); // We specifically have a variant. Restore before toggling.
            }

            toggleHood(desiredHeadId);
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}

int getDesiredHeadId(int variant)
{
    int desiredHeadId = INVALID_HEAD_ID;

    switch (GetAppearanceType(OBJECT_SELF))
    {
        case APPEARANCE_TYPE_DWARF:

            desiredHeadId = GetGender(OBJECT_SELF) == GENDER_MALE ? INVALID_HEAD_ID : 3;
            break;

        case APPEARANCE_TYPE_ELF:

            desiredHeadId = GetGender(OBJECT_SELF) == GENDER_MALE ? 15 : 14;
            break;

        case APPEARANCE_TYPE_GNOME:

            desiredHeadId = GetGender(OBJECT_SELF) == GENDER_MALE ? 6 : 5;
            break;

        case APPEARANCE_TYPE_HALF_ELF:
        case APPEARANCE_TYPE_HUMAN:

            if (GetGender(OBJECT_SELF) == GENDER_MALE)
            {
                desiredHeadId = 2;
            }
            else
            {
                desiredHeadId = variant == 1 ? 12 : 143;
            }
            break;

        case APPEARANCE_TYPE_HALF_ORC:

            desiredHeadId = GetGender(OBJECT_SELF) == GENDER_MALE ? INVALID_HEAD_ID : 2;
            break;

        case APPEARANCE_TYPE_HALFLING:

            desiredHeadId = GetGender(OBJECT_SELF) == GENDER_MALE ? 9 : 10;
            break;
    }

    return desiredHeadId;
}

void toggleHood(int desiredHeadId)
{
    object hide = gsPCGetCreatureHide(OBJECT_SELF);
    int savedHeadId = GetLocalInt(hide, "HEAD");
    int currentHeadId = GetCreatureBodyPart(CREATURE_PART_HEAD, OBJECT_SELF);

    if (currentHeadId == desiredHeadId || savedHeadId != INVALID_HEAD_ID) // We already have a hood; restore.
    {
        restoreHead();
    }
    else // Save old head and use new one.
    {
        SetLocalInt(hide, "HEAD", currentHeadId);
        SetCreatureBodyPart(CREATURE_PART_HEAD, desiredHeadId, OBJECT_SELF);
    }
}

void restoreHead()
{
    object hide = gsPCGetCreatureHide(OBJECT_SELF);
    int savedHeadId = GetLocalInt(hide, "HEAD");

    if (savedHeadId != INVALID_HEAD_ID)
    {
        SetCreatureBodyPart(CREATURE_PART_HEAD, savedHeadId, OBJECT_SELF);
        SetLocalInt(hide, "HEAD", INVALID_HEAD_ID);
    }
}