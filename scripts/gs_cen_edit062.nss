#include "inc_encounter"

int StartingConditional()
{
    object oArea = GetArea(OBJECT_SELF);
    int nOffset  = 0;
    int nSlot    = 0;
    int nNth     = 1;
    int bNight = GetLocalInt(GetPCSpeaker(), "NIGHT");

    for (; nNth <= GS_EN_LIMIT_SLOT; nNth++)
    {
        if (gsENGetCreatureTemplate(nNth, oArea, bNight) != "")
            SetLocalInt(OBJECT_SELF, "GS_EN_SLOT_" + IntToString(++nSlot), nNth);
    }

    if (GetLocalObject(OBJECT_SELF, "GS_EN_AREA") != oArea)
    {
        SetLocalObject(OBJECT_SELF, "GS_EN_AREA", oArea);
    }
    else if (nSlot)
    {
        nOffset = GetLocalInt(OBJECT_SELF, "GS_EN_OFFSET");
        while (nOffset >= nSlot) nOffset -= 10;
    }

    SetLocalInt(OBJECT_SELF, "GS_EN_OFFSET", nOffset);
    SetLocalInt(OBJECT_SELF, "GS_EN_COUNT", nSlot);
    SetCustomToken(100, IntToString(gsENGetEncounterChance(oArea)));
    SetCustomToken(101, FloatToString(gsENGetMinimumRating(oArea), 0, 1));
    SetCustomToken(102, IntToString(nOffset / 10 + 1));
    SetCustomToken(103, IntToString(nSlot ? (nSlot - 1) / 10 + 1 : 1));
    return TRUE;
}
