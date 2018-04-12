#include "fb_inc_chatutils"
#include "inc_wildmagic"
#include "inc_customspells"
#include "inc_examine"

const string HELP = "Wild Mages can use the <c€€ >-surge</c> spell at least once per rest and will gain an additional use every 6th Wizard Level. Surge will make sure the next spellcast will always produce a Wild Surge. Wild Surges always replenish the last spellcast for the user.";

void main()
{

    object oSpeaker = OBJECT_SELF;
    string sParams  = chatGetParams(oSpeaker);

    if (sParams == "?")
    {
        DisplayTextInExamineWindow("-surge", HELP);
    }
    else
    {
        object oHide        = gsPCGetCreatureHide(oSpeaker);
        int isWildMage      = GetLocalInt(oHide, AR_WILD_MAGE);

        if ( isWildMage )
        {
            int bSurgeActive = GetLocalInt(oSpeaker, AR_SURGE_ACTIVE);

            //::  Surge once per rest
            if(!bSurgeActive && miSPGetCanCastSpell(oSpeaker, CUSTOM_SPELL_SURGE))
            {
                //::  Wild Mages can use an extra -surge every 6 Wizard Levels.
                //::  At a maximum of 6 surges at Level 30, pure Wiz.
                int nWizLevel       = GetLevelByClass(CLASS_TYPE_WIZARD, oSpeaker);
                int nExtraSurge     = nWizLevel / 6;
                int nMax            = 1 + nExtraSurge;
                int nCurrentUses    = GetLocalInt (oSpeaker, AR_SURGE_USES) + 1;
                SetLocalInt (oSpeaker, AR_SURGE_USES, nCurrentUses);

                //::  Uses exceed Max, set spell as spent.
                if ( nCurrentUses >= nMax ) {
                    miSPHasCastSpell(oSpeaker, CUSTOM_SPELL_SURGE);
                }

                miDoCastingAnimation(oSpeaker);

                SetLocalInt(oSpeaker, AR_SURGE_ACTIVE, TRUE);
                DelayCommand(1.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DECK), oSpeaker) );
                DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_AURA_PULSE_BLUE_GREEN), oSpeaker, 2.0f) );
                SendMessageToPC(oSpeaker,"<c € >Surge active.</c>");
                PlaySound("as_mg_frstmagic1");
            }
            else if (bSurgeActive) {
                SendMessageToPC(oSpeaker,"<cþ  >Surge is already active.");
            }
            else
            {
                SendMessageToPC(oSpeaker,"<cþ  >You cannot use this ability yet. " +
                                        "It's available after rest.");
            }
        }
        else
        {
            SendMessageToPC(oSpeaker, "<cþ  >You must be a Wild Mage to open a Wild Surge.");
        }
    }

    chatVerifyCommand(oSpeaker);
}
