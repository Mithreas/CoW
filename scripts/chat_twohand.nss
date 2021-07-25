#include "inc_chatutils"
#include "inc_examine"
#include "inc_bonuses"
#include "nwnx_item"

const string HELP = "Large creatures can activate this mode for two-handing Large melee weapons. Activate by using: <cþôh>-twohand</c>, deactivate by typing the command again. While this mode is active no off-hand can be equipped. Medium sized creatures can also apply Two-handing mode with a Warhammer or Spear.";
const int BASE_ITEM_LONGSPEAR = 54;

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
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSpeaker);
			
        if ( GetIsPC(oSpeaker) && !GetIsDM(oSpeaker) &&
             (GetCreatureSize(oSpeaker) >= CREATURE_SIZE_MEDIUM  ||
			   ( GetCreatureSize(oSpeaker) == CREATURE_SIZE_MEDIUM &&
		         GetBaseItemType(oWeapon) == BASE_ITEM_WARHAMMER )) )
        {
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
		else if ( GetCreatureSize(oSpeaker) == CREATURE_SIZE_MEDIUM &&
		          (GetBaseItemType(oWeapon) == BASE_ITEM_SHORTSPEAR || 
				   GetBaseItemType(oWeapon) == BASE_ITEM_LONGSPEAR) )
		{
			if (GetBaseItemType(oWeapon) == BASE_ITEM_SHORTSPEAR)
			{			
                //::  Unequip Offhand
                object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oSpeaker);
                if ( GetIsObjectValid(oOffHand) ) {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oSpeaker, 0.75);
                    DelayCommand(0.5, AssignCommand(oSpeaker, _arUnEquipItem(oOffHand)));
                }
				
                SendMessageToPC(oSpeaker, " <c € >Two-Handed Mode Activated.");
				NWNX_Item_SetBaseItemType(oWeapon, BASE_ITEM_LONGSPEAR);
			}
			else
			{
                SendMessageToPC(oSpeaker, " <c€€€>Two-Handed Mode Disabled.");
				NWNX_Item_SetBaseItemType(oWeapon, BASE_ITEM_SHORTSPEAR);
			}
		}		
        else
        {
            SendMessageToPC(oSpeaker, "<cþ  >Only Large Creatures carrying a Large melee weapon or Medium Creatures carrying a Warhammer can activate this mode.");
        }
    }

    chatVerifyCommand(oSpeaker);
}
