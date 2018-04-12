#include "inc_wildmagic"
#include "inc_customspells"
#include "inc_chatutils"
#include "inc_examine"

const string HELP = "Wild Mages can use the Chaos Shield (<c€€ >-chaos</c>) spell once per rest.  When casting Chaos Shield the caster will be surrounded by a protective aura lasting 1 Round / Caster Level.  There is a 20% chance for Enemies entering the aura to be afflicted by a random negative Surge.";

void main()
{

    object oSpeaker = OBJECT_SELF;
    string sParams  = chatGetParams(oSpeaker);

    if (sParams == "?")
    {
        DisplayTextInExamineWindow("-chaos", HELP);
    }
    else
    {
        object oHide        = gsPCGetCreatureHide(oSpeaker);
        int isWildMage      = GetLocalInt(oHide, AR_WILD_MAGE);
        int iMagic          = gsFLGetAreaFlag("OVERRIDE_MAGIC", oSpeaker);

        if ( isWildMage && GetLevelByClass(CLASS_TYPE_WIZARD, oSpeaker) >= 9 )
        {
            //::  Chaos once per rest and only for Level 9 Wiz and above
            if( !iMagic && miSPGetCanCastSpell(oSpeaker, CUSTOM_SPELL_CHAOS) )
            {
                miSPHasCastSpell(oSpeaker, CUSTOM_SPELL_CHAOS);
                miDoCastingAnimation(oSpeaker);

                //SetLocalInt(oSpeaker, AR_CHAOS_ACTIVE, TRUE);
                DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_PULSE_MAGENTA_RED), oSpeaker, 2.0f) );
                DelayCommand(1.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DEMON_HAND), oSpeaker) );
                SendMessageToPC(oSpeaker, "<c € >Chaos Shield active.</c>");
                PlaySound("sff_screenshake");

                AssignCommand(oSpeaker, ar_DoChaosShield(oSpeaker));
                //int nCasterLevel = ar_GetHighestSpellCastingClassLevel(oSpeaker);
                //DelayCommand(RoundsToSeconds(nCasterLevel), DeleteLocalInt(oSpeaker, AR_CHAOS_ACTIVE));
            }
            else if (iMagic)
            {
                SendMessageToPC(oSpeaker,"<cþ  >Chaos can not be used in Anti-Magic areas.");
            }
            else
            {
                SendMessageToPC(oSpeaker,"<cþ  >You cannot use this ability yet. " +
                                        "It's available after rest.");
            }
        }
        else
        {
            SendMessageToPC(oSpeaker, "<cþ  >You must be a Wild Mage of at least Level 9 to use the Chaos Shield Spell.");
        }
    }

    chatVerifyCommand(oSpeaker);
}
