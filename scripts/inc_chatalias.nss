// This file provides functionality to add and resolve chat command aliases.

#include "inc_chatcomm"
#include "inc_language"
#include "inc_data_arr"
#include "inc_emotes"
#include "x3_inc_string"

const string ALIAS_ARRAY_KEY_TAG = "ALIAS_KEYS";
const string ALIAS_ARRAY_VALUE_TAG = "ALIAS_VALUE";

// Initialises all of the chat aliases. Should be called on module startup.
void chatInitAliases();

// Adds an alias to the list of aliases. Examples include:
// from: -sit, to: -emote sit
// from: -a, to: -associate
void chatAddAlias(string from /* alias */, string to /* command */);

// Given the provided command, resolves any aliases.
// May return unchanged if no such aliases exist.
struct fbCHCommand chatResolveAlias(struct fbCHCommand command);

void chatInitAliases()
{
    // Alias all of the emotes in form [emote] -> -emote [emote].
    int i = EMOTE_FIRST;
    while (i <= EMOTE_LAST)
    {
        string emoteAsStr = GetStringLowerCase(EmoteIdToString(i));
        chatAddAlias(emoteAsStr, "emote " + emoteAsStr);
        ++i;
    }

    // Languages!
    i = GS_LA_LANGUAGE_FIRST;
    while (i <= GS_LA_LANGUAGE_LAST)
    {
        string language = gsLAGetLanguageKey(i);
        chatAddAlias(language, "language " + language);
        ++i;
    }

    // Alias -a and -f to -associate.
    chatAddAlias("a", "associate");
    chatAddAlias("f", "associate");

    // -stream aliases
    chatAddAlias("ddef", "stream d def");
    chatAddAlias("sil", "stream d sil");
    chatAddAlias("pri", "stream d pri");
    chatAddAlias("red", "stream d red");
    chatAddAlias("dra", "stream d dra");
    chatAddAlias("gol", "stream d gol");
    chatAddAlias("edef", "stream e def");
    chatAddAlias("air", "stream e air");
    chatAddAlias("ear", "stream e ear");
    chatAddAlias("fir", "stream e fir");
    chatAddAlias("wat", "stream e wat");
    chatAddAlias("odef", "stream o def");
    chatAddAlias("cel", "stream o cel");
    chatAddAlias("sla", "stream o sla");
    chatAddAlias("dev", "stream o dev");
    chatAddAlias("yug", "stream o yug");
    chatAddAlias("dem", "stream o dem");
    chatAddAlias("mum", "stream u mum");
    chatAddAlias("gho", "stream u gho");
    chatAddAlias("vam", "stream u vam");
    chatAddAlias("sha", "stream d sha");

    // Walk modes!
    chatAddAlias("alwayswalk", "walk alwayswalk");
    chatAddAlias("naturalwalk", "walk naturalwalk");

    // Help americans out a bit.
    chatAddAlias("color_mode", "colour_mode");

    //Use Feat
    chatAddAlias("calledshot", "usefeat calledshot");
    chatAddAlias("deatharrow", "usefeat deatharrow");
    chatAddAlias("knockdown", "usefeat knockdown");
    chatAddAlias("deathtouch", "usefeat deathtouch");
    chatAddAlias("disarm", "usefeat disarm");
    chatAddAlias("kidamage", "usefeat kidamage");
    chatAddAlias("oathwrath", "usefeat oathwrath");
    chatAddAlias("seekerarrow", "usefeat seekerarrow");
    chatAddAlias("smiteevil", "usefeat smiteevil");
    chatAddAlias("smitegood", "usefeat smitegood");
    chatAddAlias("stunfist", "usefeat stunfist");
    chatAddAlias("undeadgraft", "usefeat undeadgraft");
}

void chatAddAlias(string from /* alias */, string to /* command */)
{
    if (!StringArray_Contains(GetModule(), ALIAS_ARRAY_KEY_TAG, from))
    {
        StringArray_PushBack(GetModule(), ALIAS_ARRAY_KEY_TAG, from);
        StringArray_PushBack(GetModule(), ALIAS_ARRAY_VALUE_TAG, to);
    }
}

struct fbCHCommand chatResolveAlias(struct fbCHCommand command)
{
    int index = StringArray_Find(GetModule(), ALIAS_ARRAY_KEY_TAG, command.sText);

    if (index != NWNX_DATA_INVALID_INDEX)
    {
        string storedCommand = StringArray_At(GetModule(), ALIAS_ARRAY_VALUE_TAG, index);
        string text = StringParse(storedCommand);
        string params = StringRemoveParsed(storedCommand, text);

        struct fbCHCommand resolvedAlias;
        resolvedAlias.sText = text;
        resolvedAlias.sParams = params;

        if (command.sParams != "")
        {
            if (resolvedAlias.sParams != "")
            {
                resolvedAlias.sParams += " ";
            }

            resolvedAlias.sParams += command.sParams;
        }

        return resolvedAlias;
    }

    return command;
}
