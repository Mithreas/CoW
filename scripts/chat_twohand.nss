#include "inc_chatutils"
#include "inc_examine"
#include "inc_bonuses"

const string HELP = "Large creatures can activate this mode for two-handing Large melee weapons. Activate by using: <cþôh>-twohand</c>, deactivate by typing the command again. While this mode is active no off-hand can be equipped. Medium sized creatures can also apply Two-handing mode with a Bastard Sword.";

void main()
{
    object oSpeaker = OBJECT_SELF;
    string sParams  = chatGetParams(oSpeaker);

    if (sParams == "?")
    {
        DisplayTextInExamineWindow("-twohand", HELP);
    }
    else
    {
        if ( GetIsPC(oSpeaker) && !GetIsDM(oSpeaker) &&
             GetCreatureSize(oSpeaker) >= CREATURE_SIZE_MEDIUM )
        {
            object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSpeaker);
            //::  Deactivate
            if ( GetLocalInt(oSpeaker, "AR_TWO_HAND") ) {
                SendMessageToPC(oSpeaker, " <c€€€>Two-Handed Mode Disabled.");
                DeleteLocalInt(oSpeaker, "AR_TWO_HAND");
                RemoveTaggedEffects(oSpeaker, EFFECT_TAG_TWOHAND);
            }
            //::  Activate
            else {
                SendMessageToPC(oSpeaker, " <c € >Two-Handed Mode Activated.");
                SetLocalInt(oSpeaker, "AR_TWO_HAND", TRUE);
                ApplyTwoHandedBonus(oWeapon);

                //::  Unequip Offhand
                object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSpeaker);
                if ( GetIsObjectValid(oOffHand) ) {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oSpeaker, 0.75);
                    DelayCommand(0.5, AssignCommand(oSpeaker, _arUnEquipItem(oOffHand)));
                }
            }
        }
        else
        {
            SendMessageToPC(oSpeaker, "<cþ  >Only Large Creatures carrying a Large melee weapon or Medium Creatures carrying a Bastard Sword can activate this mode.");
        }
    }

    chatVerifyCommand(oSpeaker);
}
