// inc_quickbar.nss
//
//
// Exposes a series of methods that allow interaction with a PC's quickbar.

#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "x3_inc_string"

// CONSTANTS

const int QUICKBARSLOT_PG1_1 = 0;
const int QUICKBARSLOT_PG1_2 = 1;
const int QUICKBARSLOT_PG1_3 = 2;
const int QUICKBARSLOT_PG1_4 = 3;
const int QUICKBARSLOT_PG1_5 = 4;
const int QUICKBARSLOT_PG1_6 = 5;
const int QUICKBARSLOT_PG1_7 = 6;
const int QUICKBARSLOT_PG1_8 = 7;
const int QUICKBARSLOT_PG1_9 = 8;
const int QUICKBARSLOT_PG1_10 = 9;
const int QUICKBARSLOT_PG1_11 = 10;
const int QUICKBARSLOT_PG1_12 = 11;

const int QUICKBARSLOT_PG2_1 = 12;
const int QUICKBARSLOT_PG2_2 = 13;
const int QUICKBARSLOT_PG2_3 = 14;
const int QUICKBARSLOT_PG2_4 = 15;
const int QUICKBARSLOT_PG2_5 = 16;
const int QUICKBARSLOT_PG2_6 = 17;
const int QUICKBARSLOT_PG2_7 = 18;
const int QUICKBARSLOT_PG2_8 = 19;
const int QUICKBARSLOT_PG2_9 = 20;
const int QUICKBARSLOT_PG2_10 = 21;
const int QUICKBARSLOT_PG2_11 = 22;
const int QUICKBARSLOT_PG2_12 = 23;

const int QUICKBARSLOT_PG3_1 = 24;
const int QUICKBARSLOT_PG3_2 = 25;
const int QUICKBARSLOT_PG3_3 = 26;
const int QUICKBARSLOT_PG3_4 = 27;
const int QUICKBARSLOT_PG3_5 = 28;
const int QUICKBARSLOT_PG3_6 = 29;
const int QUICKBARSLOT_PG3_7 = 30;
const int QUICKBARSLOT_PG3_8 = 31;
const int QUICKBARSLOT_PG3_9 = 32;
const int QUICKBARSLOT_PG3_10 = 33;
const int QUICKBARSLOT_PG3_11 = 34;
const int QUICKBARSLOT_PG3_12 = 35;

const int QUICKBARSLOT_COUNT = 36;

const string QUICKBARSLOT_DELIM = " "; // String delimiter between quickslot components
const string QUICKBAR_DELIM = "~"; // String delimiter between quickslots in quickbar

// END CONSTANTS


// DECLARATIONS

// Returns the whole quickbar of the provided PC.
string GetQuickBar(object pc);

// Sets the provided PCs quickbar to the provided quickbar.
void SetQuickBar(object pc, string data);

// Returns the quickbarslot structure of the provided slot ID (QUICKBARSLOT_*).
struct QuickBarSlot GetQuickBarSlot(object pc, int slot);

// Sets the provided slot. The ID is provided in the qbs struct.
void SetQuickBarSlot(object pc, struct QuickBarSlot qbs);

// Converts the string representation of a quickbarslot to the struct format.
string QuickBarSlotToString(struct QuickBarSlot qbs);

// Converts the struct format of a quickbarslot to a string representation.
struct QuickBarSlot StringToQuickBarSlot(string data);

// END DECLARATIONS


// DEFINITIONS

string GetQuickBar(object pc)
{
    string data;

    int i = 0;
    while (i < QUICKBARSLOT_COUNT)
    {
        data = data + QuickBarSlotToString(GetQuickBarSlot(pc, i)) + QUICKBAR_DELIM;
        ++i;
    }

    return data;
}

void SetQuickBar(object pc, string data)
{
    int i = 0;
    while (i < QUICKBARSLOT_COUNT)
    {
        string parsed = StringParse(data, QUICKBAR_DELIM);
        SetQuickBarSlot(pc, StringToQuickBarSlot(parsed));
        data = StringRemoveParsed(data, parsed, QUICKBAR_DELIM);
        ++i;
    }
}

struct QuickBarSlot GetQuickBarSlot(object pc, int slot)
{
    return StringToQuickBarSlot(GetRawQuickBarSlot(pc, slot));
}

void SetQuickBarSlot(object pc, struct QuickBarSlot qbs)
{
    SetRawQuickBarSlot(pc, QuickBarSlotToString(qbs));
}

string QuickBarSlotToString(struct QuickBarSlot qbs)
{
    return IntToString(qbs.slot) + QUICKBARSLOT_DELIM +
           IntToString(qbs.type) + QUICKBARSLOT_DELIM +
           IntToString(qbs.class) + QUICKBARSLOT_DELIM +
           IntToString(qbs.id) + QUICKBARSLOT_DELIM +
           IntToString(qbs.meta);
}

struct QuickBarSlot StringToQuickBarSlot(string data)
{
    struct QuickBarSlot qbs;
    string parse;

    parse     = StringParse(data, QUICKBARSLOT_DELIM);
    qbs.slot  = StringToInt(parse);
    data      = StringRemoveParsed(data, parse, QUICKBARSLOT_DELIM);

    parse     = StringParse(data, QUICKBARSLOT_DELIM);
    qbs.type  = StringToInt(parse);
    data      = StringRemoveParsed(data, parse, QUICKBARSLOT_DELIM);

    parse     = StringParse(data, QUICKBARSLOT_DELIM);
    qbs.class = StringToInt(parse);
    data      = StringRemoveParsed(data, parse, QUICKBARSLOT_DELIM);

    parse     = StringParse(data, QUICKBARSLOT_DELIM);
    qbs.id    = StringToInt(parse);

    qbs.meta  = StringToInt(StringRemoveParsed(data, parse, QUICKBARSLOT_DELIM));

    return qbs;
}

// END DEFINITIONS