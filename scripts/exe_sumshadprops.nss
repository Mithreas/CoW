//::///////////////////////////////////////////////
//:: Executed Script: Summoned Shadow Properties
//:: exe_sumshadprops
//:://////////////////////////////////////////////
/*
    Sets stats and applies properties for
    shadows summoned via the shadow conjuration
    line.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 17, 2016
//:://////////////////////////////////////////////

#include "inc_generic"
#include "inc_spells"
#include "nwnx_alts"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"

// Creates a random weapon (out of an assortment) on the caller.
object CreateRandomWeapon();
// Forces the caller to equip the given items.
void EquipItems(object oArmor, object oHelm, object oWeapon);

void main()
{
    object oMaster = GetMaster(OBJECT_SELF);
    int i;
    int nAB = GetAbilityModifier(GetCreatureLastSpellCastAbility(oMaster), oMaster);
    int nConcealment = 50 + GetSpellFocusLevel(oMaster, SPELL_SCHOOL_ILLUSION) * 10;
    int nLevel = GetCreatureLastSpellCasterLevel(oMaster);
    object oArmor, oHelm, oWeapon;

    CopyCreatureAppearance(oMaster, OBJECT_SELF);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE)), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackIncrease(nAB)), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectConcealment(nConcealment)), OBJECT_SELF);

    for(i = 1; i < nLevel; i++)
    {
        LevelUpHenchman(OBJECT_SELF);
    }

    NWNX_Creature_SetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH, 10);

    RemovePackageFeats(OBJECT_SELF, PACKAGE_OUTSIDER);

    SetAllSkillRanks(OBJECT_SELF, 0);
    NWNX_Creature_SetSkillRank(OBJECT_SELF, SKILL_HIDE, nLevel + 3);
    NWNX_Creature_SetSkillRank(OBJECT_SELF, SKILL_MOVE_SILENTLY, nLevel + 3);
    NWNX_Creature_SetSkillRank(OBJECT_SELF, SKILL_LISTEN, nLevel + 3);
    NWNX_Creature_SetSkillRank(OBJECT_SELF, SKILL_SPOT, nLevel + 3);
    AddKnownFeat(OBJECT_SELF, FEAT_IMPROVED_KNOCKDOWN);

    oWeapon = CreateRandomWeapon();
    SetDroppableFlag(oWeapon, FALSE);
    RemoveAllItemProperties(oWeapon);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyNoDamage(), oWeapon);

    oArmor = CopyItem(GetItemInSlot(INVENTORY_SLOT_CHEST, oMaster), OBJECT_SELF);
    RemoveAllItemProperties(oArmor);
    SetDroppableFlag(oArmor, FALSE);

    if(!GetHiddenWhenEquipped(GetItemInSlot(INVENTORY_SLOT_HEAD, oMaster)))
    {
        oHelm = CopyItem(GetItemInSlot(INVENTORY_SLOT_HEAD, oMaster), OBJECT_SELF);
        RemoveAllItemProperties(oHelm);
        SetDroppableFlag(oHelm, FALSE);
    }

    ClearAllActions();
    EquipItems(oArmor, oHelm, oWeapon);
}

//::///////////////////////////////////////////////
//:: CreateRandomWeapon
//:://////////////////////////////////////////////
/*
    Creates a random weapon (out of an assortment)
    on the caller.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 17, 2016
//:://////////////////////////////////////////////
object CreateRandomWeapon()
{
    int nNumWeapons;

    switch(GetCreatureSize(OBJECT_SELF))
    {
        case CREATURE_SIZE_TINY:
            nNumWeapons = 10;
            break;
        case CREATURE_SIZE_SMALL:
            nNumWeapons = 21;
            break;
        default:
            nNumWeapons = 27;
            break;
    }

    switch(Random(nNumWeapons))
    {
        // Tiny/Small Weapons
        case 0:  return CreateItemOnObject("nw_wswdg001");   // Dagger
        case 1:  return CreateItemOnObject("nw_waxhn001");   // Handaxe
        case 2:  return CreateItemOnObject("nw_wspka001");   // Kama
        case 3:  return CreateItemOnObject("nw_wswka001");   // Katana
        case 4:  return CreateItemOnObject("nw_wspku001");   // Kukri
        case 5:  return CreateItemOnObject("nw_wblhl001");   // Light Hammer
        case 6:  return CreateItemOnObject("nw_wblml001");   // Mace
        case 7:  return CreateItemOnObject("nw_wswss001");   // Short Sword
        case 8:  return CreateItemOnObject("nw_wspsc001");   // Sickle
        case 9:  return CreateItemOnObject("x2_it_wpwhip");  // Whip
        // Medium Weapons
        case 10:  return CreateItemOnObject("nw_wswbs001");  // Bastard Sword
        case 11: return CreateItemOnObject("nw_waxbt001");   // Battleaxe
        case 12: return CreateItemOnObject("nw_wblcl001");   // Club
        case 13: return CreateItemOnObject("x2_wdwraxe001"); // Dwarven Waraxe
        case 14: return CreateItemOnObject("nw_wblfl001");   // Light Flail
        case 15: return CreateItemOnObject("nw_wswls001");   // Longsword
        case 16: return CreateItemOnObject("nw_wblms001");   // Morningstar
        case 17: return CreateItemOnObject("nw_wswrp001");   // Rapier
        case 18: return CreateItemOnObject("nw_wswsc001");   // Scimitar
        case 19: return CreateItemOnObject("nw_wplss001");   // Spear
        case 20: return CreateItemOnObject("nw_wblhw001");   // Warhammer
        // Large Weapons
        case 21: return CreateItemOnObject("nw_waxgr001");   // Greataxe
        case 22: return CreateItemOnObject("nw_wswgs001");   // Greatsword
        case 23: return CreateItemOnObject("nw_wplhb001");   // Halberd
        case 24: return CreateItemOnObject("nw_wblfh001");   // Heavy Flail
        case 25: return CreateItemOnObject("nw_wplsc001");   // Scythe
        case 26: return CreateItemOnObject("nw_wpltr001");   // Trident
    }
    return OBJECT_INVALID;
}

//::///////////////////////////////////////////////
//:: EquipItems
//:://////////////////////////////////////////////
/*
    Forces the caller to equip the given items.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 17, 2016
//:://////////////////////////////////////////////
void EquipItems(object oArmor, object oHelm, object oWeapon)
{
    ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST);
    ActionEquipItem(oHelm, INVENTORY_SLOT_HEAD);
    ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND);
    ActionDoCommand(SetCommandable(TRUE, OBJECT_SELF));
    SetCommandable(FALSE, OBJECT_SELF);
}
