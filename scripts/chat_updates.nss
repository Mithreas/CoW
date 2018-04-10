#include "fb_inc_chatutils"
#include "inc_examine"
#include "inc_forum"
#include "x3_inc_string"

void main()
{
    string params = chatGetParams(OBJECT_SELF);

    if (params == "?")
    {
        DisplayTextInExamineWindow(
            chatCommandTitle("-updates"),
            "Displays all updates taken from the Arelith updates thread on the forums.");
    }
    else
    {
        string content = "";

        string posts = GetPostIdsInTopic(25, TRUE); // Update thread ID, newest posts first.
        string parsedPost = StringParse(posts);
        posts = StringRemoveParsed(posts, parsedPost);

        while (parsedPost != "")
        {
            int post = StringToInt(parsedPost);
            content += StringToRGBString(GetPostSubject(post), "970") + "\n";
            content += GetPostTime(post) + "\n\n";
            content += GetPostContents(post) + "\n\n";
            parsedPost = StringParse(posts);
            posts = StringRemoveParsed(posts, parsedPost);
        }

        DisplayTextInExamineWindow("Arelith Updates", content);
    }

    chatVerifyCommand(OBJECT_SELF);
}
