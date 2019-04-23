#include "__server_config"
#include "inc_chatutils"
#include "inc_customspells"
#include "inc_xfer"
#include "inc_spell"
#include "inc_worship"
#include "inc_examine"
#include "inc_spells"

const string HELP_1 = "Use this to project an illusionary image of yourself to a <cÿ× >[Target]</c> or summon one at your side.\n\n";
const string HELP_2 = "If a <cÿ× >[Target]</c> is specified:\n\n";
const string HELP_3 = "The image will appear before the target, speak one line of text (which you will be prompted to speak after using the command), and then vanish. The name of the <cÿ× >[Target]</c> need only be the first few letters of a character, so 'Joh' will work on 'John Doe'. You can also send -send_image as a tell to someone to send your image to that person. To cancel once begun, use -cancel.\n\n";
const string HELP_4 = "If a <cÿ× >[Target]</c> is not specified:\n\n";
const string HELP_5 = "The image will appear at your side and join your party as a henchman for 1 hour / caster level or until rest. It will possess any equipment you are wearing, and can be sent into combat, but will not have access to any of your spells. You may also use the -associate chat command to speak through it.";

void main()
{
    // Command not valid
    if (!ALLOW_SENDING) return;

    object oSpeaker = OBJECT_SELF;
    string sParams = chatGetParams(oSpeaker);
    object oTarget = chatGetTarget(oSpeaker);
    int nProjectImage = FALSE;
    string sPCID = "";
    string sServer = "";

    chatVerifyCommand(oSpeaker);

    // Help menu.
    if(sParams == "?")
    {
        DisplayTextInExamineWindow(chatCommandTitle("-project_image") + " " + chatCommandParameter("[Target]"), HELP_1 + HELP_2 + HELP_3 + HELP_4 + HELP_5);
        return;
    }
    // Invalid. Send error and exit.
    if(!GetCanSendImage(oSpeaker))
    {
        SendMessageToPC(oSpeaker, "<cþ  >You must have Epic Spell Focus in Illusion to send your image.");
        return;
    }
    // Not available yet. Send error and exit.
    if(!miSPGetCanCastSpell(oSpeaker, CUSTOM_SPELL_SEND_IMAGE))
    {
        SendMessageToPC(oSpeaker,"<cþ  >You cannot use this ability yet. It's available once per rest.");
        return;
    }
    // Send image but no target exists. Attempt to find one from parameters.
    if(sParams != "" && !GetIsObjectValid(oTarget))
    {
        SQLExecStatement("SELECT s.pcid,s.server FROM mixf_currentplayers AS s " +
          "INNER JOIN gs_pc_data AS p ON s.pcid = p.id WHERE p.name LIKE ?",
          sParams + "%");

        if(SQLFetch())
        {
            sPCID = SQLGetData(1);
            sServer = SQLGetData(2);
            if(sServer == miXFGetCurrentServer())
            {
                oTarget = gsPCGetPlayerByID(sPCID);
            }
        }
        else
        {
            // Just exit if no target. Typos should not consume piety or spell components.
            SendMessageToPC(oSpeaker, "Could not find " + sParams);
            return;
        }
    }

    // No target, no parameters. Do project image.
    if(sParams == "" && !GetIsObjectValid(oTarget))
    {
    	//Miesny_Jez Reduce Piety/Spell Components only when creating a clone
    	if((GetLevelByClass(CLASS_TYPE_CLERIC, oSpeaker) >= 17 || GetLevelByClass(CLASS_TYPE_DRUID, oSpeaker) >= 17) && !gsWOAdjustPiety(oSpeaker, -5.0, FALSE))
	    {
	        FloatingTextStringOnCreature("You are not pious enough for " + GetDeity(oSpeaker) + " to grant you that spell now.", OBJECT_SELF, FALSE);
	        return;
	    }
	    // ... and spell components.
	    else if(GetLevelByClass(CLASS_TYPE_CLERIC, oSpeaker) < 17 && GetLevelByClass(CLASS_TYPE_DRUID, oSpeaker) < 17)
	    {
		    gsSTDoCasterDamage(oSpeaker, 5);
	    }
	    
        miDoCastingAnimation(oSpeaker);
        AssignCommand(oSpeaker, ProjectImage());
        miSPHasCastSpell(oSpeaker, CUSTOM_SPELL_SEND_IMAGE);
        DeleteLocalInt(OBJECT_SELF, "MI_SENDING");
    }
    // Send image logic.
    else
    {
	
	    if (!miREHasRelationship(oSpeaker, oTarget))
	    {
          SendMessageToPC(oSpeaker, "<cþ£ >You may only send a message to someone you have previously interacted with.");
	    }
        else if (GetIsObjectValid(oTarget))
        {
            SetLocalInt(oSpeaker, "MI_SENDING", 1);
            SetLocalObject(oSpeaker, "MI_SEND_TARGET", oTarget);
            SendMessageToPC(oSpeaker, "((Speak the message you wish to send. You must speak it as a single line.))");
        }
        else if (sPCID != "")
        {
            SetLocalInt(oSpeaker, "MI_SENDING", 1);
            SetLocalString(oSpeaker, "MI_SEND_TARGET", sPCID);
            SetLocalString(oSpeaker, "MI_SEND_TARGET_SERVER", sServer);
            SendMessageToPC(oSpeaker, "((Speak the message you wish to send. You must speak it as a single line.))");
        }
        else
        {
            SendMessageToPC(oSpeaker, "<cþ£ >Could not find character: " + sParams);
        }
    }
}
