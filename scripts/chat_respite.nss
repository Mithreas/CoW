//::///////////////////////////////////////////////
//:: chat_respite
//:: Chat: Respite
//:://////////////////////////////////////////////
/*
    Triggers the -respite spell, an epic spell
    for healers that makes creatures in the zone
    immortal, provides crowd control immunity,
    and heals all allies once it expires.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: June 13, 2016
//:://////////////////////////////////////////////

#include "inc_chatutils"
#include "inc_worship"
#include "inc_examine"
#include "inc_spells"
#include "inc_tempvars"
#include "inc_class"

const string HELP = "At level 28, pure healers gain access to the epic Respite spell:\n\nRespite\nCaster Level(s): Healer 10\nInnate Level: 10\nSchool: Abjuration\nDescriptor(s):\nComponent(s):\nCasting Time: Instant\nRange: Personal\nArea of Effect / Target: 4.0 meters\nDuration: 9 Seconds\nAdditional Counter Spells:\nSave: Harmless\nSpell Resistance: No\n\n";
const string HELP_2 = "The healer creates a zone that defies death itself. Creatures within the area of effect become immune to all forms of crowd control (except Timestop) and cannot be reduced to less than one hit point. When the spell expires, all allies within the area of effect are healed for 150 points of damage.";

void main()
{
    string sParams  = chatGetParams(OBJECT_SELF);
    location lSource = GetLocation(OBJECT_SELF);
    object oRespite;

    if(sParams == "?")
    {
        DisplayTextInExamineWindow(chatCommandTitle("-respite"), HELP + HELP_2);
    }
    else
    {
        if(GetIsHealer(OBJECT_SELF) && GetLevelByClass(CLASS_TYPE_CLERIC) >= 28)
        {
            if(!GetLocalInt(OBJECT_SELF, "RespiteDepleted"))
            {
                if(gsWOAdjustPiety(OBJECT_SELF, -5.0f, FALSE))
                {
                    SetTempInt(OBJECT_SELF, "RespiteDepleted", TRUE, TEMP_VARIABLE_EXPIRATION_EVENT_REST);
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_WORD), lSource);
                    CreateNonStackingPersistentAoE(DURATION_TYPE_TEMPORARY, 52, lSource, 9.0, "ent_respite", "null", "ext_respite", SPELL_ID_UNDEFINED, OBJECT_SELF,
                        CLASS_TYPE_CLERIC, BLUEPRINT_STATIC_VFX, "Respite", VFX_DUR_PROT_EPIC_ARMOR_2, VFX_DUR_AURA_FIRE);
                }
                else
                {
                    FloatingTextStringOnCreature("You are not pious enough for " + GetDeity(OBJECT_SELF) + " to grant you that spell now.", OBJECT_SELF, FALSE);
                }
            }
            else
            {
                SendMessageToPC(OBJECT_SELF ,"<cþ  >You cannot use this ability yet. It's available once per rest.");
            }
        }
        else
        {
            SendMessageToPC(OBJECT_SELF, "<cþ  >You must be a pure 28th level healer to cast Respite.");
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}
