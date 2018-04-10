#include "gs_inc_combat"
#include "gs_inc_event"
#include "gs_inc_ai"

void main()
{
    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_CONVERSATION));

    object oSpeaker = GetLastSpeaker();
    object oTarget  = OBJECT_INVALID;

    SetListening(OBJECT_SELF, FALSE);

    switch (GetListenPatternNumber())
	// Listen patterns are set up in gs_ai_spawn.  Currently only ATTACK_TARGET 
	// and REQUEST_REINFORCEMENTS are set (i.e. PVP and theft are disabled).
    {
    case -1:
        if (! gsCBGetHasAttackTarget() &&
            gsCBGetIsPerceived(oSpeaker))
        {
            ClearAllActions(TRUE);
            SetAILevel(OBJECT_SELF, GU_AI_LEVEL_DIALOGUE);
            BeginConversation();
        }
        break;

    case 10000: //GS_AI_ATTACK_TARGET
        if (! (GetLevelByClass(CLASS_TYPE_COMMONER) ||
               gsCBGetHasAttackTarget()))
        {
		    // Look about.			
			if (d2() == 2) PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT);
			else PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT);
			  
		    // Make an intelligence check to try and figure out the source.
			float fDelay = IntToFloat(Random(4));
			int nInt     = GetAbilityModifier(ABILITY_INTELLIGENCE, OBJECT_SELF);
			int nChance = (nInt < 0) ? 25 : (25 + 10 * nInt);
			if (GetRacialType(oSpeaker) != GetRacialType(OBJECT_SELF)) nChance -= 20;
			
			if (d100() < nChance)
			{
			  // I see it!
			  SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, FALSE);
              DelayCommand(fDelay, gsCBDetermineAttackTarget(oSpeaker));
			}
			else
			{
			  // Something is happening, but I don't know what!
			  if (d4() == 4) DelayCommand(fDelay, PlayVoiceChat(VOICE_CHAT_SEARCH));
			  SetActionMode(OBJECT_SELF, ACTION_MODE_DETECT, TRUE);
			}
        }
        break;

    case 10001: //GS_AI_PVP
        oTarget = GetLocalObject(oSpeaker, "GS_PVP_TARGET");

        if (GetIsObjectValid(oTarget) &&
            ! GetIsEnemy(oTarget))
        {
            gsCBDetermineCombatRound(oSpeaker);
        }
        break;

    case 10002: //GS_AI_THEFT
        if (GetIsSkillSuccessful(OBJECT_SELF, SKILL_SPOT, GetSkillRank(SKILL_PICK_POCKET, oSpeaker) + d20()))
        {
            gsCBDetermineCombatRound(oSpeaker);
        }
        break;

    case 10003: //GS_AI_REQUEST_REINFORCEMENT
        if (! GetIsEnemy(oSpeaker)) gsCBSetReinforcementRequestedBy(oSpeaker);
        break;
    }

    SetListening(OBJECT_SELF, TRUE);
}
