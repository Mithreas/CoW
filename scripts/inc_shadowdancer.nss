//::///////////////////////////////////////////////
//:: Shadowdancer Library
//:: inc_shadowdancer
//:://////////////////////////////////////////////
/*
    Contains helper functions for code related
    to the shadowdancer class.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 27, 2017
//:://////////////////////////////////////////////

#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"
#include "mi_inc_class"

/**********************************************************************
 * CONFIG PARAMETERS
 **********************************************************************/

// Radius in which the shadowdancer gains bonus sneak attack from its shadow.
const float SD_SHADOW_AURA_RADIUS = 10.0;

// Controls the rate at which the shadowdancer gains bonus sneak attack from
// its shadow.
const int BASE_SHADOW_SNEAK_ATTACK_BONUS = 0;
const int HIT_DICE_PER_SHADOW_SNEAK_ATTACK_BONUS = 3;

/**********************************************************************
 * CONSTANT DEFINITIONS
 **********************************************************************/

// IP Const Improved Sneak Attack feats.
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1D6 = 41;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_2D6 = 42;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_3D6 = 43;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_4D6 = 44;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_5D6 = 45;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_6D6 = 46;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_7D6 = 47;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_8D6 = 48;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_9D6 = 49;
const int IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_10D6 = 50;

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Returns TRUE if the IP property feat is one granted by a shadowdancer shadow's aura.
int GetIsShadowdancerBonusSneakAttackFeat(int nIPFeat);
// Returns the master's base sneak attack bonus level -- which corresponds to existing
// improved sneak attack feats.
int GetShadowdancerBaseSneakAttackBonusLevel(object oShadowdancer);
// Grants shadowdancer sneak attack bonuses to the shadowdancer (e.g. those granted
// via summoned shadow).
void GrantShadowdancerSneakAttackBonus(object oShadowdancer, object oShadow = OBJECT_SELF);
// Removes all shadowdancer sneak attack bonuses from the shadowdancer (i.e. those
// granted via summoned shadow).
void RemoveShadowdancerSneakAttackBonus(object oShadowdancer, object oShadow = OBJECT_SELF);
// Updates the shadowdancer's current sneak attack bonus, refreshing it if the shadowdancer
// is in range of the shadow and removing it otherwise.
void UpdateShadowdancerSneakAttackBonus(object oShadow = OBJECT_SELF);

/**********************************************************************
 * PRIVATE FUNCTION PROTOTYPES
 **********************************************************************/

/* Private function used to resolve timing issues. */
void _GrantShadowdancerSneakAttackBonus(object oShadowdancer, object oShadow);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: GetIsShadowdancerBonusSneakAttackFeat
//:://////////////////////////////////////////////
/*
    Returns TRUE if the IP property feat is one
    granted by a shadowdancer shadow's aura.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 12, 2016
//:://////////////////////////////////////////////
int GetIsShadowdancerBonusSneakAttackFeat(int nIPFeat)
{
    return nIPFeat == IP_CONST_FEAT_SNEAK_ATTACK_1D6
        || (nIPFeat >= IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1D6 && nIPFeat <= IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_10D6);
}

//::///////////////////////////////////////////////
//:: GetShadowdancerBaseSneakAttackBonusLevel
//:://////////////////////////////////////////////
/*
    Returns the master's base sneak attack
    bonus level -- which corresponds to existing
    improved sneak attack feats.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: September 12, 2016
//:://////////////////////////////////////////////
int GetShadowdancerBaseSneakAttackBonusLevel(object oShadowdancer)
{
    if(GetKnowsFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_10, oShadowdancer))
        return 10;
    if(GetKnowsFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_9, oShadowdancer))
        return 9;
    if(GetKnowsFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_8, oShadowdancer))
        return 8;
    if(GetKnowsFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_7, oShadowdancer))
        return 7;
    if(GetKnowsFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_6, oShadowdancer))
        return 6;
    if(GetKnowsFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_5, oShadowdancer))
        return 5;
    if(GetKnowsFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_4, oShadowdancer))
        return 4;
    if(GetKnowsFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_3, oShadowdancer))
        return 3;
    if(GetKnowsFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_2, oShadowdancer))
        return 2;
    if(GetKnowsFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1, oShadowdancer))
        return 1;
    return 0;
}

 //::///////////////////////////////////////////////
//:: GrantShadowdancerSneakAttackBonus
//:://////////////////////////////////////////////
/*
    Grants shadowdancer sneak attack bonuses
    to the shadowdancer (e.g. those granted
    via summoned shadow).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 27, 2017
//:://////////////////////////////////////////////
void GrantShadowdancerSneakAttackBonus(object oShadowdancer, object oShadow = OBJECT_SELF)
{
    if(GetObjectType(oShadow) == OBJECT_TYPE_AREA_OF_EFFECT) oShadow = GetAreaOfEffectCreator();
    if(GetMaster(oShadow) != oShadowdancer || GetIsDead(oShadow)) return;
	if(GetIsShadowMage(oShadowdancer)) return;

    RemoveShadowdancerSneakAttackBonus(oShadowdancer);
    DelayCommand(0.0, _GrantShadowdancerSneakAttackBonus(oShadowdancer, oShadow));
}

//::///////////////////////////////////////////////
//:: RemoveShadowdancerSneakAttackBonus
//:://////////////////////////////////////////////
/*
    Removes all shadowdancer sneak attack
    bonuses from the shadowdancer (i.e. those
    granted via summoned shadow).
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 27, 2017
//:://////////////////////////////////////////////
void RemoveShadowdancerSneakAttackBonus(object oShadowdancer, object oShadow = OBJECT_SELF)
{
    if(GetObjectType(oShadow) == OBJECT_TYPE_AREA_OF_EFFECT) oShadow = GetAreaOfEffectCreator();
    if(GetIsObjectValid(GetMaster(oShadow)) && GetMaster(oShadow) != oShadowdancer) return;

    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oShadowdancer);
    itemproperty ip = GetFirstItemProperty(oHide);

    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyDurationType(ip) == DURATION_TYPE_TEMPORARY && GetIsShadowdancerBonusSneakAttackFeat(GetItemPropertySubType(ip)))
        {
            RemoveItemProperty(oHide, ip);
        }
        ip = GetNextItemProperty(oHide);
    }
}

//::///////////////////////////////////////////////
//:: UpdateShadowdancerSneakAttackBonus
//:://////////////////////////////////////////////
/*
    Updates the shadowdancer's current sneak
    attack bonus, refreshing it if the shadowdancer
    is in range of the shadow and removing it
    otherwise.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 27, 2016
//:://////////////////////////////////////////////
void UpdateShadowdancerSneakAttackBonus(object oShadow = OBJECT_SELF)
{
    object oShadowdancer = GetMaster(oShadow);

    if(GetDistanceBetween(oShadowdancer, oShadow) <= SD_SHADOW_AURA_RADIUS && GetArea(oShadowdancer) == GetArea(oShadow))
        GrantShadowdancerSneakAttackBonus(oShadowdancer);
}

/**********************************************************************
 * PRIVATE FUNCTION DEFINITIONS
 **********************************************************************/

 //::///////////////////////////////////////////////
//:: GrantShadowdancerSneakAttackBonus
//:://////////////////////////////////////////////
/*
    Private function used to resolve timing
    issues.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 27, 2017
//:://////////////////////////////////////////////
void _GrantShadowdancerSneakAttackBonus(object oShadowdancer, object oShadow)
{
    int nBonusLevel = GetHitDice(oShadow) / HIT_DICE_PER_SHADOW_SNEAK_ATTACK_BONUS +
        GetShadowdancerBaseSneakAttackBonusLevel(oShadowdancer) + BASE_SHADOW_SNEAK_ATTACK_BONUS;
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oShadowdancer);;

    if(nBonusLevel > 10) nBonusLevel = 10;

    if(!GetHasFeat(FEAT_SNEAK_ATTACK, oShadowdancer) && !GetHasFeat(FEAT_BLACKGUARD_SNEAK_ATTACK_1D6, oShadowdancer))
    {
        nBonusLevel--;
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyBonusFeat(IP_CONST_FEAT_SNEAK_ATTACK_1D6), oHide, 86400.0);
    }

    if(nBonusLevel <= 0) return;

    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyBonusFeat(IP_CONST_FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1D6 - 1 + nBonusLevel), oHide, 86400.0);
}
