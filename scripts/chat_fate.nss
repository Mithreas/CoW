#include "fb_inc_chatutils"
#include "ar_sys_faerzress"
#include "inc_examine"

const string HELP = "Wild Mages can use the Fatidical Manipulation (<c€€ >-fate</c>) spell once per rest.  By using Fatidical Manipulation the next spell will always provide a non-replenishable Wild Surge effect from a span starting from a picked value, e.g -fate 50, and ending at +8 from that value (Example: 50-58). The span decreases by 1 for each Wild Mage Level after 21, to be perfect at Level 28.";

void main()
{

    object oSpeaker = OBJECT_SELF;
    string sParams  = chatGetParams(oSpeaker);

    if (sParams == "?")
    {
        DisplayTextInExamineWindow("-fate", HELP);
    }
    else
    {
        object oHide        = gsPCGetCreatureHide(oSpeaker);
        int isWildMage      = GetLocalInt(oHide, AR_WILD_MAGE);
        int nWizLevel       = GetLevelByClass(CLASS_TYPE_WIZARD, oSpeaker);

        if ( isWildMage && nWizLevel >= 21 )
        {
            int nSurge = StringToInt(sParams);
            if (nSurge < 1 || nSurge > 100) {
                SendMessageToPC(oSpeaker, "<cþ  >Please enter a value between 1-100 after -fate.  E.g -fate 50.");
                return;
            }

            //::  Fate once per rest and only for Level 21 Wiz and above
            if( miSPGetCanCastSpell(oSpeaker, CUSTOM_SPELL_FATE) )
            {
                miSPHasCastSpell(oSpeaker, CUSTOM_SPELL_FATE);
                miDoCastingAnimation(oSpeaker);

                //::  Calculate what Surge based on Wizard Level.
                //::  Level 21 there is a chance between Surge picked to a span of +8 and at Level 28 it is perfect.
                if (nWizLevel < 28) {
                    int nSpan = (28 - nWizLevel) + 1;
                    int nRand = Random(nSpan);
                    nSurge += nRand;
                    //::  If exceeding 100, restart from bottom of table
                    if ( nSurge > 100 ) {
                        nSurge = nSurge - 100;
                    }

                    //::  Safety Clamp, shouldn't happen...  ever.
                    if ( nSurge < 1 )       nSurge = 1;
                    else if (nSurge > 100)  nSurge = 100;
                }

                SetLocalInt(oSpeaker, AR_FATE_ACTIVE, TRUE);
                SetLocalInt(oSpeaker, AR_FATE_USE, nSurge);

                DelayCommand(1.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_TIME_STOP), oSpeaker) );
                DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_PULSE_PURPLE_BLACK), oSpeaker, 2.0f) );
                SendMessageToPC(oSpeaker,"<c € >Fatidical Manipulation active.</c>");
                PlaySound("sff_screenshake");
            }
            else
            {
                SendMessageToPC(oSpeaker,"<cþ  >You cannot use this ability yet. " +
                                        "It's available after rest.");
            }
        }
        else
        {
            SendMessageToPC(oSpeaker, "<cþ  >You must be a Wild Mage of at least Level 21 to use the Fatidical Manipulation Spell.");
        }
    }

    chatVerifyCommand(oSpeaker);
}
