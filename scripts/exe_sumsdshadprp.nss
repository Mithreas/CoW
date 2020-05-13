//::///////////////////////////////////////////////
//:: Executed Script: Summoned Shadowdancer
//:: Shadow Properties
//:: exe_sumsdshadprp
//:://////////////////////////////////////////////
/*
    Sets stats and applies properties for
    shadowdancer shadows.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 12, 2016
//:://////////////////////////////////////////////

#include "inc_generic"
#include "inc_item"
#include "inc_rename"
#include "inc_spells"
#include "inc_string"
#include "nwnx_alts"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"

// Forces the caller to equip the given items.
void EquipItems(object oArmor, object oHelm, object oWeapon1, object oWeapon2);

void main()
{
    object oMaster = GetMaster(OBJECT_SELF);
    object oArmor;
    object oHelm;
    object oWeapon1;
    object oWeapon2;
    int bCreateWeapon = GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMaster)) ||
        (!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMaster)) && !GetHasFeat(FEAT_IMPROVED_UNARMED_STRIKE, oMaster));
    int bEpic = GetHasFeat(FEAT_EPIC_EPIC_SHADOWLORD, oMaster);
    int nLevel = GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oMaster) + 5 + bEpic * 5;
    int nConcealment = 50 + nLevel;
    int i;
    string sName;

    SetLocalInt(OBJECT_SELF, "TELEPORT_TO_OWNER_ON_HIT", 1);

    CopyCreatureAppearance(oMaster, OBJECT_SELF);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR)), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectConcealment(nConcealment)), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneGhost()), OBJECT_SELF);

    for(i = 1; i < nLevel; i++)
    {
        LevelUpHenchman(OBJECT_SELF);
    }

    NWNX_Creature_SetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH, GetAbilityScore(oMaster, ABILITY_STRENGTH));
    NWNX_Creature_SetAbilityScore(OBJECT_SELF, ABILITY_DEXTERITY, GetAbilityScore(oMaster, ABILITY_DEXTERITY));
    NWNX_Creature_SetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION, GetAbilityScore(oMaster, ABILITY_CONSTITUTION));
    NWNX_Object_SetCurrentHitPoints(OBJECT_SELF, GetMaxHitPoints());

    RemovePackageFeats(OBJECT_SELF, PACKAGE_OUTSIDER);
    if(GetHasFeat(FEAT_AMBIDEXTERITY, oMaster)) AddKnownFeat(OBJECT_SELF, FEAT_AMBIDEXTERITY);
    if(GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oMaster)) AddKnownFeat(OBJECT_SELF, FEAT_TWO_WEAPON_FIGHTING);
    if(GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING, oMaster)) AddKnownFeat(OBJECT_SELF, FEAT_IMPROVED_TWO_WEAPON_FIGHTING);
    if(GetHasFeat(FEAT_WEAPON_FINESSE, oMaster)) AddKnownFeat(OBJECT_SELF, FEAT_WEAPON_FINESSE);
    if(GetHasFeat(FEAT_EVASION, oMaster)) AddKnownFeat(OBJECT_SELF, FEAT_EVASION);
    if(GetHasFeat(FEAT_IMPROVED_EVASION, oMaster)) AddKnownFeat(OBJECT_SELF, FEAT_IMPROVED_EVASION);
    if(GetHasFeat(FEAT_EPIC_DODGE, oMaster)) AddKnownFeat(OBJECT_SELF, FEAT_EPIC_DODGE);
    if(GetHasFeat(FEAT_UNCANNY_DODGE_1, oMaster)) AddKnownFeat(OBJECT_SELF, FEAT_UNCANNY_DODGE_1);
    if(GetHasFeat(FEAT_UNCANNY_DODGE_2, oMaster)) AddKnownFeat(OBJECT_SELF, FEAT_UNCANNY_DODGE_2);
    if(GetHasFeat(FEAT_UNCANNY_DODGE_3, oMaster)) AddKnownFeat(OBJECT_SELF, FEAT_UNCANNY_DODGE_3);
    if(GetHasFeat(FEAT_UNCANNY_DODGE_4, oMaster)) AddKnownFeat(OBJECT_SELF, FEAT_UNCANNY_DODGE_4);
    if(GetHasFeat(FEAT_UNCANNY_DODGE_5, oMaster)) AddKnownFeat(OBJECT_SELF, FEAT_UNCANNY_DODGE_5);
    if(GetHasFeat(FEAT_UNCANNY_DODGE_6, oMaster)) AddKnownFeat(OBJECT_SELF, FEAT_UNCANNY_DODGE_6);
    if(GetHasFeat(FEAT_DEFENSIVE_ROLL, oMaster)) AddKnownFeat(OBJECT_SELF, FEAT_DEFENSIVE_ROLL);
    if(GetHasFeat(374, oMaster) && GetArmorWeight(GetItemInSlot(INVENTORY_SLOT_CHEST, oMaster)) <= ARMOR_WEIGHT_LIGHT) // Ranger Dual-Wield
    {
        // Add Ambidexterity/TWF instead of the Dual-Wield feat, since the latter is hardcoded to rangers.
        AddKnownFeat(OBJECT_SELF, FEAT_AMBIDEXTERITY);
        AddKnownFeat(OBJECT_SELF, FEAT_TWO_WEAPON_FIGHTING);
    }
    if(GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oMaster) >= 5)
    {
        AddKnownFeat(OBJECT_SELF, FEAT_HIDE_IN_PLAIN_SIGHT);
    }

    SetAllSkillRanks(OBJECT_SELF, 0);
    NWNX_Creature_SetSkillRank(OBJECT_SELF, SKILL_DISCIPLINE, nLevel + 3);
    NWNX_Creature_SetSkillRank(OBJECT_SELF, SKILL_HIDE, nLevel + 3);
    NWNX_Creature_SetSkillRank(OBJECT_SELF, SKILL_MOVE_SILENTLY, nLevel + 3);
    NWNX_Creature_SetSkillRank(OBJECT_SELF, SKILL_LISTEN, nLevel + 3);
    NWNX_Creature_SetSkillRank(OBJECT_SELF, SKILL_SPOT, nLevel + 3);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectRegenerate(nLevel / 3, 6.0)), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageReduction(nLevel / 3, DAMAGE_POWER_PLUS_SIX)), OBJECT_SELF);

    if(bCreateWeapon)
    {
        AddKnownFeat(OBJECT_SELF, FEAT_IMPROVED_UNARMED_STRIKE);
    }
    else
    {
        oWeapon1 = CopyItem(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oMaster), OBJECT_SELF);
        oWeapon2 = CopyItem(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oMaster), OBJECT_SELF);
    }
    SetDroppableFlag(oWeapon1, FALSE);
    RemoveAllItemProperties(oWeapon1);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyNoDamage(), oWeapon1);
    SetDroppableFlag(oWeapon2, FALSE);
    RemoveAllItemProperties(oWeapon2);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyNoDamage(), oWeapon2);

    oArmor = CopyItem(GetItemInSlot(INVENTORY_SLOT_CHEST, oMaster), OBJECT_SELF);
    RemoveAllItemProperties(oArmor);
    SetDroppableFlag(oArmor, FALSE);

    if(!GetHiddenWhenEquipped(GetItemInSlot(INVENTORY_SLOT_HEAD, oMaster)))
    {
        oHelm = CopyItem(GetItemInSlot(INVENTORY_SLOT_HEAD, oMaster), OBJECT_SELF);
        RemoveAllItemProperties(oHelm);
        SetDroppableFlag(oHelm, FALSE);
    }

    if(bEpic)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSpellImmunity(SPELL_BANISHMENT)), OBJECT_SELF);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSpellImmunity(SPELL_DISMISSAL)), OBJECT_SELF);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSpellImmunity(SPELL_WORD_OF_FAITH)), OBJECT_SELF);

        SetDescription(OBJECT_SELF, GetDescription(oMaster));
        SetName(OBJECT_SELF, svGetPCNameOverride(oMaster));
        SetPortraitResRef(OBJECT_SELF, GetPortraitResRef(oMaster));
        NWNX_Creature_SetSoundset(OBJECT_SELF, NWNX_Creature_GetSoundset(oMaster));
    }
    else
    {
        sName = GetSubStringBetween(svGetPCNameOverride(oMaster), "", " ");
        if(sName == "") sName = svGetPCNameOverride(oMaster);
        SetName(OBJECT_SELF, PossessiveString(sName) + " Shadow");
    }

    ClearAllActions();
    EquipItems(oArmor, oHelm, oWeapon1, oWeapon2);
}

//::///////////////////////////////////////////////
//:: EquipItems
//:://////////////////////////////////////////////
/*
    Forces the caller to equip the given items.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 12, 2016
//:://////////////////////////////////////////////
void EquipItems(object oArmor, object oHelm, object oWeapon1, object oWeapon2)
{
    ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST);
    ActionEquipItem(oHelm, INVENTORY_SLOT_HEAD);
    ActionEquipItem(oWeapon1, INVENTORY_SLOT_RIGHTHAND);
    ActionEquipItem(oWeapon2, INVENTORY_SLOT_LEFTHAND);
    ActionDoCommand(SetCommandable(TRUE, OBJECT_SELF));
    SetCommandable(FALSE, OBJECT_SELF);
}
