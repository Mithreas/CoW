#include "inc_chatutils"
#include "inc_examine"
#include "inc_effect"

const string HELP = "The -blind command applies a permanent blindness effect to your character, for use as a roleplaying tool. If you want to remove this effect, simply use the -dispel command.";

void main()
{
  object oSpeaker = OBJECT_SELF;
  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-blind", HELP);
  }
  else
  {
    ApplyTaggedEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectBlindness()), oSpeaker, 0.0, EFFECT_TAG_CONSOLE_COMMAND_DISPELLABLE);
    SendMessageToPC(oSpeaker, "You are now blind! Remember, you can remove this effect by using the -dispel command.");
    Log(CHATCMD, GetName(oSpeaker) + " used -blind.");
  }

  chatVerifyCommand(oSpeaker);
}
