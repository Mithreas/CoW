#include "inc_chatutils"
#include "inc_time"
#include "inc_data_arr"
#include "inc_examine"
#include "inc_forum"
#include "x3_inc_string"

const string SUBJECT_ARRAY_TAG = "forum_subject";
const string CONTENTS_ARRAY_TAG = "forum_content";

void UpdateDbCache();

void UpdateDbCache()
{
    int timestamp = gsTIGetActualTimestamp();

    if (timestamp - 300 <= GetLocalInt(OBJECT_SELF, "MANUAL_LAST_DB_PULL"))
    {
        return; // Only query the DB once every 30 secs.
    }

    SetLocalInt(OBJECT_SELF, "MANUAL_LAST_DB_PULL", timestamp);

    StringArray_Clear(OBJECT_SELF, SUBJECT_ARRAY_TAG);
    StringArray_Clear(OBJECT_SELF, CONTENTS_ARRAY_TAG);

    string topicIds = GetTopicIds(31); // Mechanical change forum ID is 31.

    if (topicIds != "")
    {
        string parsedTopic = StringParse(topicIds);
        topicIds = StringRemoveParsed(topicIds, parsedTopic);

        while (parsedTopic != "")
        {
            int topicId = StringToInt(parsedTopic);

            if (!GetIsTopicSticky(topicId))
            {
                int post = StringToInt(StringParse(GetPostIdsInTopic(topicId)));
                StringArray_PushBack(OBJECT_SELF, SUBJECT_ARRAY_TAG, GetPostSubject(post));
                StringArray_PushBack(OBJECT_SELF, CONTENTS_ARRAY_TAG, GetPostContents(post));
            }

            parsedTopic = StringParse(topicIds);
            topicIds = StringRemoveParsed(topicIds, parsedTopic);
        }
    }
}

void main()
{
    UpdateDbCache();
    string params = GetStringLowerCase(chatGetParams(OBJECT_SELF));

    if (params == "?" || params == "")
    {
        string manualList = "Available manuals:\n\n";
        int manualCount = StringArray_Size(OBJECT_SELF, SUBJECT_ARRAY_TAG);

        int i = 0;
        while (i < manualCount)
        {
            manualList += "- " + chatCommandParameter(StringArray_At(OBJECT_SELF, SUBJECT_ARRAY_TAG, i)) + "\n";
            ++i;
        }

        DisplayTextInExamineWindow(
            chatCommandTitle("-manual") + " " + chatCommandParameter("[manual]"),
            "Opens up the requested " + chatCommandParameter("[manual]") +
            " in an examine window which describes Arelith specific changes.\n\n" +
            "If you would like to contribute to the contents of these pages, sign up on the forums!\n\n" +
            manualList);
    }
    else
    {
        int manualIndex = ARRAY_INVALID_INDEX;
        int manualCount = StringArray_Size(OBJECT_SELF, SUBJECT_ARRAY_TAG);

        string subject;

        int i ;
        for (i = 0; i < manualCount; ++i)
        {
            // We don't use StringArray_Find here because we want a partial and lower-case find ...
            subject = StringArray_At(OBJECT_SELF, SUBJECT_ARRAY_TAG, i);
            if (GetStringLeft(GetStringLowerCase(subject), GetStringLength(params)) == params)
            {
                manualIndex = i;
                break;
            }
        }

        if (manualIndex == ARRAY_INVALID_INDEX)
        {
            SendMessageToPC(OBJECT_SELF,
                "You entered " + params + ", which is not a valid manual! " +
                "Type -manual ? for a list of valid manuals.");
        }
        else
        {
            DisplayTextInExamineWindow(
                chatCommandParameter(subject),
                StringArray_At(OBJECT_SELF, CONTENTS_ARRAY_TAG, i));
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}
