#include "ar_utils"

void main()
{
    object oDefender = GetObjectByTagInAreaEx("AR_DUER_ROTHGUARD", GetArea(OBJECT_SELF));

    //::  Duergar RAGE!
    if ( GetIsObjectValid(oDefender) ) {
        ChangeToStandardFaction(oDefender, STANDARD_FACTION_HOSTILE);
        PlayVoiceChat(VOICE_CHAT_ATTACK,oDefender);
        AssignCommand(oDefender, ClearAllActions());
        AssignCommand(oDefender, ActionSpeakString("ME ROTHE!  ME BEAUTIFUL ROTHE!  I'LL KILL YEH!!!"));

        DelayCommand(1.0, AssignCommand(oDefender, WrapperActionAttack(GetLastKiller())));
    }

    ExecuteScript("gs_ai_death", OBJECT_SELF);
}
