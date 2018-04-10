// This file governs loot distribution chance.
//
// Broadly speaking, loot distribution is set up based on CATEGORIES and BUCKETS.
// A category is something overarching, whereas a bucket is something more refined.
// One might think of a category as "epicloot" and a bucket as "chest" or "boss".
//

#include "inc_data_arr"
#include "inc_random"
#include "inc_time"

// ----- PUBLIC API ------

struct LootDistributionHistory
{
    // The number of drops since timeout.
    int drops;

    // The timestamp of the first time this object was operated on.
    // This is in seconds, server time.
    int timestamp;
};

struct LootDistrbutionResults
{
    string category;
    string bucket;

    // Has the system decided to create a drop?
    int createDrop;

    // Is the drop an accelerated drop? (e.g. did it pull from any chance except the last?)
    int acceleratedDrop;
};

// Sets the timeout for the loot category. This timeout is in seconds.
// Every timeout period, the drop count will reset.
void SetLootCategoryTimeout(string category, int timeout);

// Adds a drop chance (percentage, from 0.0f to 100.0f) to the bucket.
// If adding more than one drop chance to a bucket, the amount of loot drops
// will determine which chance is used.
void AddLootBucketChance(string category, string bucket, float chance);

// Returns the loot distribution history for the object in the category.
struct LootDistributionHistory GetLootDistributionHistory(object obj, string category);

// Rolls for loot in the bucket for the object. Returns the results.
// Note that the results are NOT accepted until you call AcceptLootDistributionResults.
struct LootDistrbutionResults GetLootDistributionResults(object obj, string category, string bucket);

// Accepts the loot distribution results. This will handle incrementing the drop count.
void AcceptLootDistributionResults(object obj, struct LootDistrbutionResults results);

// ------ INTERNAL API ------

string INTERNAL_GetArrayName(string category, string bucket);
void INTERNAL_RefreshHistory(object obj, string category);

int INTERNAL_GetDrops(object obj, string category);
int INTERNAL_GetTimestamp(object obj, string category);
void INTERNAL_SetDrops(object obj, string category, int drops);
void INTERNAL_SetTimestamp(object obj, string category, int timestamp);

//
// -----
//

void SetLootCategoryTimeout(string category, int timeout)
{
    SetLocalInt(GetModule(), "LOOTDIST_" + category + "_TIMEOUT", timeout);
}

void AddLootBucketChance(string category, string bucket, float chance)
{
    FloatArray_PushBack(GetModule(), INTERNAL_GetArrayName(category, bucket), chance > 100.0f ? 100.0f : chance);
}

struct LootDistributionHistory GetLootDistributionHistory(object obj, string category)
{
    INTERNAL_RefreshHistory(obj, category);
    struct LootDistributionHistory history;
    history.drops = INTERNAL_GetDrops(obj, category);
    history.timestamp = INTERNAL_GetTimestamp(obj, category);
    return history;
}

struct LootDistrbutionResults GetLootDistributionResults(object obj, string category, string bucket)
{
    INTERNAL_RefreshHistory(obj, category);

    struct LootDistrbutionResults results;
    results.createDrop = FALSE;

    object arrayObj = GetModule();
    string arrayName = INTERNAL_GetArrayName(category, bucket);

    int ruleCount = FloatArray_Size(arrayObj, arrayName);

    if (ruleCount > 0)
    {
        int dropCount = INTERNAL_GetDrops(obj, category);
        int ruleIndex = ruleCount > dropCount ? dropCount : ruleCount - 1;
        float rule = FloatArray_At(arrayObj, arrayName, ruleIndex);

        if (PercentageRandom(rule))
        {
            results.category = category;
            results.bucket = bucket;
            results.createDrop = TRUE;
            results.acceleratedDrop = dropCount + 1 < ruleCount;
        }
    }

    return results;
}

void AcceptLootDistributionResults(object obj, struct LootDistrbutionResults results)
{
    if (results.createDrop)
    {
        int drops = INTERNAL_GetDrops(obj, results.category);
        INTERNAL_SetDrops(obj, results.category, drops + 1);
    }
}

string INTERNAL_GetArrayName(string category, string bucket)
{
    return "LOOSTDIST_" + category + "_" + bucket;
}

void INTERNAL_RefreshHistory(object obj, string category)
{
    int categoryTimeout = GetLocalInt(GetModule(), "LOOTDIST_" + category + "_TIMEOUT");
    int objectTime = INTERNAL_GetTimestamp(obj, category);
    int actualTime = GetModuleTime();

    if (abs(actualTime - objectTime) >= categoryTimeout)
    {
        INTERNAL_SetTimestamp(obj, category, actualTime);
        INTERNAL_SetDrops(obj, category, 0);
    }
}

int INTERNAL_GetDrops(object obj, string category)
{
    return GetLocalInt(obj, "LOOTDIST_" + category + "_DROPS");
}

int INTERNAL_GetTimestamp(object obj, string category)
{
    return GetLocalInt(obj, "LOOTDIST_" + category + "_TIMEOUT");
}

void INTERNAL_SetDrops(object obj, string category, int drops)
{
    SetLocalInt(obj, "LOOTDIST_" + category + "_DROPS", drops);
}

void INTERNAL_SetTimestamp(object obj, string category, int timestamp)
{
    SetLocalInt(obj, "LOOTDIST_" + category + "_TIMEOUT", timestamp);
}
