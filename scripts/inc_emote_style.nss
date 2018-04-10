#include "gs_inc_pc"

// NOTE: To add a new emote style, update the constants here, then introduce additional code in translator.rb.
const int EMOTE_STYLE_STANDARD = 0;
const int EMOTE_STYLE_NOVEL = 1;

const int EMOTE_STYLE_FIRST = EMOTE_STYLE_STANDARD;
const int EMOTE_STYLE_LAST = EMOTE_STYLE_NOVEL;

void SetEmoteStyle(object obj, int style);
int GetEmoteStyle(object obj);

void SetEmoteStyle(object obj, int style)
{
    SetLocalInt(gsPCGetCreatureHide(obj), "EMOTE_STYLE", style);
}

int GetEmoteStyle(object obj)
{
    return GetLocalInt(gsPCGetCreatureHide(obj), "EMOTE_STYLE");
}
