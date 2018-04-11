#include "fb_inc_zombie"
#include "gs_inc_common"
#include "gs_inc_effect"
#include "gs_inc_flag"
#include "gs_inc_text"
#include "inc_bloodstains"
#include "x2_inc_itemprop"
#include "gvd_inc_subdual"

//depreciated by inc_bloodstains
//const string GS_TEMPLATE_BLOOD = "plc_bloodstain";

// Dunshine: moved some function to inc_bloodstains to make them useable in other scripts as well

void gsDying(int nHeal = FALSE)
{
    int nHitPoints = GetCurrentHitPoints();

    if (nHitPoints > 0)
    {
        // clean-up variable, since PC will no longer be bleeding to death from a subdual attack
        DeleteLocalObject(OBJECT_SELF, "GVD_SUBDUAL_ATTACKER");

        //if (! nHeal) FadeFromBlack(OBJECT_SELF, FADE_SPEED_SLOWEST);
        SpeakString("GS_AI_ATTACK_TARGET", TALKVOLUME_SILENT_TALK);
        return;
    }

    if (nHitPoints > -10)
    {
        effect eEffect;

        if (! nHeal && Random(100) >= 90)
        {
            nHeal = TRUE;
            //FadeFromBlack(OBJECT_SELF, FADE_SPEED_SLOWEST);
            FloatingTextStringOnCreature(GS_T_16777324, OBJECT_SELF, FALSE);

        }

        if (nHeal)
        {
            eEffect = EffectHeal(1);
        }
        else
        {
            eEffect = EffectDamage(1);

            switch (Random(4))
            {
            case 0: PlayVoiceChat(VOICE_CHAT_PAIN1);  break;
            case 1: PlayVoiceChat(VOICE_CHAT_PAIN2);  break;
            case 2: PlayVoiceChat(VOICE_CHAT_PAIN3);  break;
            case 3: PlayVoiceChat(VOICE_CHAT_HEALME); break;
            }
        }

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, OBJECT_SELF);

        DelayCommand(6.0, gsDying(nHeal));
    }
}
//----------------------------------------------------------------
void main()
{
    object oDying = GetLastPlayerDying();

    AssignCommand(oDying, gsFXBleed());
    AssignCommand(oDying, PlayVoiceChat(VOICE_CHAT_NEARDEATH));

    if (GetIsPossessedFamiliar(oDying) ||
        gsFLGetAreaFlag("PVP", oDying) ||
        fbZGetIsZombie(oDying))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oDying);
        return;
    }
    else
    {
        //CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_BLOOD, GetLocation(oDying));
        //Edited by BM: Replaced to call for custom blood cleanup
        string sDamageType = _GetLargestDamageDealt(oDying);
        BMCreateBloodStainAtLocation(oDying, GetLastHostileActor(oDying), sDamageType);
    }

    // store the last hostile actor in case it's in subdual mode, to be able to grab this in ondeath when a PC bleeds to death
    object oAttacker = GetLastHostileActor(oDying);

    // store last attacker for use in gs_inc_death and gs_m_death
    SetLocalObject(oDying, "GVD_LAST_ATTACKER", oAttacker);

    if (gvd_GetSubdualMode(oAttacker) != 0) {
      // attacker was in subdual mode, store this on the dying PC
      SetLocalObject(oDying, "GVD_SUBDUAL_ATTACKER", oAttacker);

      // we skip the dying phase and go straight to unconcious mode
      effect eEffect = EffectDamage(11);      
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oDying);

    } else {
      // delete variable just in case

      DeleteLocalObject(oDying, "GVD_SUBDUAL_ATTACKER");

      FloatingTextStringOnCreature(GS_T_16777438, oDying, FALSE);
      //FadeToBlack(oDying, FADE_SPEED_SLOWEST); -- removed
      AssignCommand(oDying, DelayCommand(6.0, gsDying()));

    }

}
