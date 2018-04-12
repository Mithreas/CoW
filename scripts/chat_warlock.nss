#include "inc_chatutils"
#include "inc_warlock"
#include "inc_examine"

const string HELP1 = "Use this command to set your warlock's eldritch blast <cÿ× >[Damage Type]</c> and activate/deactivate glowing eyes. If no <cÿ× >[Damage Type]</c> is specified, then you will be able to select one from a conversation window.\n\nValid <cÿ× >[Damage Type]</c> Parameters:\n- (mag)ic\n- fire\n- cold, ice\n- acid\n- (elec)trical, (light)ning\n- (neg)ative\n- (pos)itive\n\nText in parentheses represents shortcuts (i.e. 'neg', 'negative', and 'negqwerty' will all set your damage type to negative energy damage).";
const string HELP2 = "\n\nAdding <cÿ× >glow</c> after a <cÿ× >[Damage Type]</c> will both set your blast element and make your character's eyes glow the associated color.\nEx.: <cÿ× >-warlock neg glow</c>\n\nType <cÿ× >r</c> or <cÿ× >remove</c> after -warlock to deactivate glowing eyes without needing to -dispel your character's active effects.\nEx.: <cÿ× >-warlock r</c>, <cÿ× >-warlock remove</c>";

void main()
{
    object oSpeaker = OBJECT_SELF;
    object oTarget = chatGetTarget(oSpeaker);
    int nDamageType = -1;
    int nPact = miWAGetIsWarlock(oSpeaker);
    int nWarlockLevel = GetLevelByClass(CLASS_TYPE_BARD, oSpeaker);
    string sDamageType;
    string sParam = chatGetParams(oSpeaker);

    chatVerifyCommand(oSpeaker);

    // Help text.
    if(sParam == "?")
    {
        DisplayTextInExamineWindow(chatCommandTitle("-warlock") + " " + chatCommandParameter("[Damage Type]"), HELP1 + HELP2);
        return;
    }
    // Not a warlock? Send an error then exit.
    else if(!nPact)
    {
        SendMessageToPC(oSpeaker, "You must be a warlock to use that command.");
        return;
    }
    // No parameter? Bring up the default conversation window.
    else if(sParam == "")
    {
        SetLocalString(oSpeaker, "dialog", "zdlg_warlock_sta");
        AssignCommand(oSpeaker, ActionStartConversation(oSpeaker, "zdlg_converse", TRUE, FALSE));
        return;
    }
    // Remove glowing eyes.
    else if(sParam == "r" | sParam == "remove")
    {
        _miWARemoveGlowingEyes(oSpeaker);
        return;
    }
    // Magical damage type. Applies to both pacts.
    else if(GetStringLeft(sParam, 3) == "mag" && nWarlockLevel >= 12)
    {
        nDamageType = WARLOCK_ELEMENT_MAGIC;
        sDamageType = "magic";
    }
    // Check for fey damage types.
    else if(nPact == PACT_FEY)
    {
        if((GetStringLeft(sParam, 4) == "cold" || GetStringLeft(sParam, 3) == "ice"))
        {
            nDamageType = WARLOCK_ELEMENT_COLD;
            sDamageType = "cold";
        }
        else if((GetStringLeft(sParam, 4) == "elec" || GetStringLeft(sParam, 5) == "light") && nWarlockLevel >= 4)
        {
            nDamageType = WARLOCK_ELEMENT_LIGHTNING;
            sDamageType = "electrical";
        }
        else if(GetStringLeft(sParam, 3) == "pos" && nWarlockLevel >= 8)
        {
            nDamageType = WARLOCK_ELEMENT_POSITIVE;
            sDamageType = "positive energy";
        }
    }
    // Check for abyssal/infernal damage types.
    else
    {
        if(GetStringLeft(sParam, 4) == "fire")
        {
            nDamageType = WARLOCK_ELEMENT_FIRE;
            sDamageType = "fire";
        }
        else if(GetStringLeft(sParam, 4) == "acid" && nWarlockLevel >= 4)
        {
            nDamageType = WARLOCK_ELEMENT_ACID;
            sDamageType = "acid";
        }
        else if(GetStringLeft(sParam, 3) == "neg" && nWarlockLevel >= 8)
        {
            nDamageType = WARLOCK_ELEMENT_NEGATIVE;
            sDamageType = "negative energy";
        }
    }
    
    // We didn't find a valid damage type.
    if(nDamageType == -1)
    {
        SendMessageToPC(oSpeaker, "Either that parameter was invalid or you are unable to select that damage type. Type -warlock ? for a list of valid parameters.");
        return;
    }
    // Update damage type if we got this far.
    miWASetDamageType(nDamageType, oSpeaker);
    if(GetStringRight(sParam, 5) == " glow")
    {
        _miWADoGlowingEyes(oSpeaker, miWAGetDamageType(oSpeaker));
    }
    SendMessageToPC(oSpeaker, "Your eldritch blast will now deal " + sDamageType + " damage.");
}