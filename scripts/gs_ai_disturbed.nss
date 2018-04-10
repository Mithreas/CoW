#include "gs_inc_combat"
#include "gs_inc_event"

void main()
{
    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_DISTURBED));

    if (GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_STOLEN &&
        ! gsCBGetIsInCombat())
    {
        PlayVoiceChat(VOICE_CHAT_CUSS);
        gsCBDetermineCombatRound(GetLastDisturbed());
    }
}
