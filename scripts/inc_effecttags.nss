//::///////////////////////////////////////////////
//:: Effect Tags (List)
//:: inc_effecttags
//:://////////////////////////////////////////////
/*
    Centralized list of all unique tags used
    by ApplyTaggedEffectToObject() and
    GetEffectTag() from inc_effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 22, 2016
//:://////////////////////////////////////////////

// Mith: rewrote this to use bitwise flags within the EE GetTaggedEffect string.
const int EFFECT_TAG_CONSOLE_COMMAND_DISPELLABLE = 0x00000001;
const int EFFECT_TAG_RESPITE                     = 0x00000002;
const int EFFECT_TAG_DURATION_MARKER             = 0x00000004;
const int EFFECT_TAG_OVERHEAL                    = 0x00000008;
const int EFFECT_TAG_CHARACTER_BONUS             = 0x00000010;
const int EFFECT_TAG_CROWD_CONTROL_IMMUNITY      = 0x00000020;
const int EFFECT_TAG_WEAPON_BONUS                = 0x00000040;
const int EFFECT_TAG_SUBDUAL                     = 0x00000080;

const int EFFECT_TAG_PARRY                       = 0x00000100;
const int EFFECT_TAG_TWOHAND                     = 0x00000200;
const int EFFECT_TAG_DEATH                       = 0x00000400;
const int EFFECT_TAG_AURA                        = 0x00000800;
const int EFFECT_TAG_DOT                         = 0x00001000;
const int EFFECT_TAG_POISON                      = 0x00002000;
const int EFFECT_TAG_DISEASE                     = 0x00004000;
const int EFFECT_TAG_SCRY                        = 0x00008000;

const int EFFECT_TAG_DISGUISE                    = 0x00010000;
const int EFFECT_TAG_TRIBAL_GOBLIN               = 0x00020000;
const int EFFECT_TAG_BOON                        = 0x00040000;
const int EFFECT_TAG_VAMPIRE                     = 0x00080000;
const int EFFECT_TAG_SPELLSWORD                  = 0x00100000;
const int EFFECT_TAG_BARBARIAN                   = 0x00200000;
const int EFFECT_TAG_REVIVAL                     = 0x00400000;
const int EFFECT_TAG_MAJORAWARD                  = 0x00800000;

const int EFFECT_TAG_BLACKSTAFF                  = 0x01000000;
const int EFFECT_TAG_DIVINE_MIGHT                = 0x02000000;
const int EFFECT_TAG_MOUNTED                     = 0x04000000;
const int EFFECT_TAG_EFFECT_TAG_FIGHTERBAB       = 0x08000000;
const int EFFECT_TAG_ROGUE                       = 0x10000000;
const int EFFECT_TAG_EMPTY10                     = 0x20000000;
const int EFFECT_TAG_EMPTY11                     = 0x40000000;
const int EFFECT_TAG_EMPTY12                     = 0x80000000;
