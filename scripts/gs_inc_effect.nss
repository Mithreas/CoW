/* EFFECT Library by Gigaschatten */

//void main() {}

//apply blood effect on caller
void gsFXBleed();
//remove all negative effects and heal oCreature
void gsFXRestore(object oCreature = OBJECT_SELF);
//remove effects of nType and nSubType applied by oCreator from oObject. If
//nArmour is true, all movement penalties will be removed.
void gsFXRemoveEffect(object oObject, object oCreator = OBJECT_INVALID, int nType = FALSE, int nSubType = FALSE, int nArmour = FALSE);
//create circle of sTemplate from fStart to fEnd with fPace, fRadius, fFacing and a deviation of nRandom at height fFloor around caller
void gsFXCreateCircle(float fStart, float fEnd, float fPace, float fRadius, float fFloor, float fFacing, int nRandom, string sTemplate);
//return TRUE if mind of oCreature is affected by an effect
int gsFXGetHasMindAffactingEffect(object oCreature = OBJECT_SELF);
//remove all area of effects in oArea
void gsFXRemoveAllAOLs(object oArea);

void gsFXBleed()
{
    int nDamage     = GetTotalDamageDealt();
    if (nDamage == 0) return;

    int nHitPoints  = GetCurrentHitPoints();
    int nColor      = 0;
    int nEffect     = EFFECT_TYPE_INVALIDEFFECT;

    switch (GetRacialType(OBJECT_SELF))
    {
    //bone
    case RACIAL_TYPE_UNDEAD:
        nColor = 0;
        break;

    //green
    case RACIAL_TYPE_DRAGON:
    case RACIAL_TYPE_HUMANOID_GOBLINOID:
    case RACIAL_TYPE_HUMANOID_ORC:
    case RACIAL_TYPE_HUMANOID_REPTILIAN:
    case RACIAL_TYPE_OOZE:
    case RACIAL_TYPE_VERMIN:
        nColor = 1;
        break;

    //red
    default:
    case RACIAL_TYPE_ABERRATION:
    case RACIAL_TYPE_ANIMAL:
    case RACIAL_TYPE_BEAST:
    case RACIAL_TYPE_DWARF:
    case RACIAL_TYPE_ELF:
    case RACIAL_TYPE_FEY:
    case RACIAL_TYPE_GIANT:
    case RACIAL_TYPE_GNOME:
    case RACIAL_TYPE_HALFELF:
    case RACIAL_TYPE_HALFLING:
    case RACIAL_TYPE_HALFORC:
    case RACIAL_TYPE_HUMAN:
    case RACIAL_TYPE_HUMANOID_MONSTROUS:
    case RACIAL_TYPE_MAGICAL_BEAST:
    case RACIAL_TYPE_OUTSIDER:
    case RACIAL_TYPE_SHAPECHANGER:
        nColor = 2;
        break;

    //white
    case RACIAL_TYPE_CONSTRUCT:
    case RACIAL_TYPE_ELEMENTAL:
        nColor = 3;
        break;

    //yellow
        nColor = 4;
        break;
    }

    if (nDamage <= 10)
    {
        switch (nColor)
        {
        case 0: if (nHitPoints <= 0) nEffect = VFX_COM_CHUNK_BONE_MEDIUM;                            break;
        case 1: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_REG_GREEN  : VFX_COM_CHUNK_GREEN_SMALL;   break;
        case 2: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_REG_RED    : VFX_COM_CHUNK_RED_SMALL;     break;
        case 3: nEffect =                    VFX_COM_BLOOD_REG_WIMP;                                 break;
        case 4: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_REG_YELLOW : VFX_COM_CHUNK_YELLOW_SMALL;  break;
        }
    }
    else if (nDamage <= 20)
    {
        switch (nColor)
        {
        case 0: if (nHitPoints <= 0) nEffect = VFX_COM_CHUNK_BONE_MEDIUM;                            break;
        case 1: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_LRG_GREEN  : VFX_COM_CHUNK_GREEN_MEDIUM;  break;
        case 2: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_LRG_RED    : VFX_COM_CHUNK_RED_MEDIUM;    break;
        case 3: nEffect =                    VFX_COM_BLOOD_LRG_WIMP;                                 break;
        case 4: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_LRG_YELLOW : VFX_COM_CHUNK_YELLOW_MEDIUM; break;
        }
    }
    else
    {
        switch (nColor)
        {
        case 0: if (nHitPoints <= 0) nEffect = VFX_COM_CHUNK_BONE_MEDIUM;                            break;
        case 1: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_CRT_GREEN  : VFX_COM_CHUNK_GREEN_MEDIUM;  break;
        case 2: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_CRT_RED    : VFX_COM_CHUNK_RED_LARGE;     break;
        case 3: nEffect =                    VFX_COM_BLOOD_CRT_WIMP;                                 break;
        case 4: nEffect = (nHitPoints > 0) ? VFX_COM_BLOOD_CRT_YELLOW : VFX_COM_CHUNK_YELLOW_MEDIUM; break;
        }
    }

    if (nEffect != EFFECT_TYPE_INVALIDEFFECT)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nEffect), OBJECT_SELF);
    }

    if (nHitPoints > 0)
    {
        switch (Random(3))
        {
        case 0: PlayVoiceChat(VOICE_CHAT_PAIN1); break;
        case 1: PlayVoiceChat(VOICE_CHAT_PAIN2); break;
        case 2: PlayVoiceChat(VOICE_CHAT_PAIN3); break;
        }
    }
    else
    {
        PlayVoiceChat(VOICE_CHAT_DEATH);
    }
}
//----------------------------------------------------------------
void gsFXRestore(object oCreature = OBJECT_SELF)
{
    effect eEffect = GetFirstEffect(oCreature);

    while (GetIsEffectValid(eEffect))
    {
        switch (GetEffectType(eEffect))
        {
        case EFFECT_TYPE_ABILITY_DECREASE:
        case EFFECT_TYPE_AC_DECREASE:
        case EFFECT_TYPE_ARCANE_SPELL_FAILURE:
        case EFFECT_TYPE_ATTACK_DECREASE:
        case EFFECT_TYPE_BLINDNESS:
        case EFFECT_TYPE_CHARMED:
        case EFFECT_TYPE_CONFUSED:
        case EFFECT_TYPE_CURSE:
        case EFFECT_TYPE_DAMAGE_DECREASE:
        case EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE:
        case EFFECT_TYPE_DARKNESS:
        case EFFECT_TYPE_DAZED:
        case EFFECT_TYPE_DEAF:
        case EFFECT_TYPE_DISEASE:
        case EFFECT_TYPE_DOMINATED:
        case EFFECT_TYPE_ENTANGLE:
        case EFFECT_TYPE_FRIGHTENED:
        case EFFECT_TYPE_MISS_CHANCE:
        case EFFECT_TYPE_MOVEMENT_SPEED_DECREASE:
        case EFFECT_TYPE_NEGATIVELEVEL:
        case EFFECT_TYPE_PARALYZE:
        case EFFECT_TYPE_PETRIFY:
        case EFFECT_TYPE_POISON:
        case EFFECT_TYPE_SAVING_THROW_DECREASE:
        case EFFECT_TYPE_SILENCE:
        case EFFECT_TYPE_SKILL_DECREASE:
        case EFFECT_TYPE_SLEEP:
        case EFFECT_TYPE_SLOW:
        case EFFECT_TYPE_SPELL_FAILURE:
        case EFFECT_TYPE_SPELL_RESISTANCE_DECREASE:
        case EFFECT_TYPE_STUNNED:
        case EFFECT_TYPE_TURN_RESISTANCE_DECREASE:
        case EFFECT_TYPE_TURNED:
            RemoveEffect(oCreature, eEffect);
        }

        eEffect = GetNextEffect(oCreature);
    }

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectHeal(GetMaxHitPoints(oCreature) + 10),
        oCreature);
}
//----------------------------------------------------------------
void gsFXRemoveEffect(object oObject, object oCreator = OBJECT_INVALID, int nType = FALSE, int nSubType = FALSE, int nArmour = FALSE)
{
    effect eEffect = GetFirstEffect(oObject);

    while (GetIsEffectValid(eEffect))
    {
        if ((oCreator == OBJECT_INVALID ||
             GetEffectCreator(eEffect) == oCreator) &&
            (nType == FALSE ||
             GetEffectType(eEffect) == nType) &&
            (nSubType == FALSE ||
             GetEffectSubType(eEffect) == nSubType))
        {
            RemoveEffect(oObject, eEffect);
        }

        // Edit by Mithreas (added lines below plus nArmour parameter):
        //   Bugfix to cases where move speed decrease from armour was sometimes
        //   permanent. --[
        if (nArmour &&
            GetEffectType(eEffect) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE &&
            GetEffectSubType(eEffect) == SUBTYPE_SUPERNATURAL)
        {
            RemoveEffect(oObject, eEffect);
        }
        // ]-- End edit.

        eEffect = GetNextEffect(oObject);
    }
}
//----------------------------------------------------------------
void gsFXCreateCircle(float fStart, float fEnd, float fPace, float fRadius, float fFloor, float fFacing, int nRandom, string sTemplate)
{
    object oArea       = GetArea(OBJECT_SELF);
    location lLocation;
    vector vPosition   = GetPosition(OBJECT_SELF);
    vPosition.z       += fFloor;
    int nRandomCenter  = nRandom;
    nRandom           += 1;

    while (fStart < fEnd)
    {
        lLocation  = Location(oArea,
                              vPosition + AngleToVector(fStart) * fRadius,
                              fStart + IntToFloat(Random(nRandom) - nRandomCenter) + fFacing);
        CreateObject(OBJECT_TYPE_PLACEABLE, sTemplate, lLocation);
        fStart    += fPace;
    }
}
//----------------------------------------------------------------
int gsFXGetHasMindAffactingEffect(object oCreature = OBJECT_SELF)
{
    effect eEffect = GetFirstEffect(oCreature);

    while (GetIsEffectValid(eEffect))
    {
        switch (GetEffectType(eEffect))
        {
        case EFFECT_TYPE_CONFUSED:
        case EFFECT_TYPE_CUTSCENE_PARALYZE:
        case EFFECT_TYPE_CUTSCENEIMMOBILIZE:
        case EFFECT_TYPE_DAZED:
        case EFFECT_TYPE_DOMINATED:
        case EFFECT_TYPE_FRIGHTENED:
        case EFFECT_TYPE_PETRIFY:
        case EFFECT_TYPE_SLEEP:
        case EFFECT_TYPE_STUNNED:
            return TRUE;
        }

        eEffect = GetNextEffect(oCreature);
    }

    return FALSE;
}
//----------------------------------------------------------------
void gsFXRemoveAllAOLs(object oArea)
{
    object oObject = GetFirstObjectInArea(oArea);

    while (GetIsObjectValid(oObject))
    {
        if (GetObjectType(oObject) == OBJECT_TYPE_AREA_OF_EFFECT) DestroyObject(oObject);
        oObject = GetNextObjectInArea(oArea);
    }
}
