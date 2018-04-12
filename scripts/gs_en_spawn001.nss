#include "inc_encounter"

void main()
{
    object oObject = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC,
                                        OBJECT_SELF, 1,
                                        CREATURE_TYPE_RACIAL_TYPE, RACIAL_TYPE_CONSTRUCT,
                                        CREATURE_TYPE_IS_ALIVE, TRUE);
    string sTag    = "";
    int nNth       = 1;

    while (GetIsObjectValid(oObject))
    {
        sTag = GetTag(oObject);

        if ((sTag == "GS_ENCOUNTER" ||
             sTag == "GS_BOSS") &&
            ! GetLocalInt(oObject, "GS_ENABLED") &&
            GetDistanceToObject(oObject) <= GS_EN_DISTANCE)
        {
            SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
            DestroyObject(OBJECT_SELF);
            return;
        }

        oObject = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC,
                                     OBJECT_SELF, ++nNth,
                                     CREATURE_TYPE_RACIAL_TYPE, RACIAL_TYPE_CONSTRUCT,
                                     CREATURE_TYPE_IS_ALIVE, TRUE);
    }

    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        ExtraordinaryEffect(EffectCutsceneParalyze()),
                        OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        ExtraordinaryEffect(EffectCutsceneGhost()),
                        OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY)),
                        OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                        ExtraordinaryEffect(EffectTrueSeeing()),
                        OBJECT_SELF);

    SetAILevel(OBJECT_SELF, AI_LEVEL_LOW);
    SetLocalInt(OBJECT_SELF, "INANIMATE_OBJECT", 1);
}
