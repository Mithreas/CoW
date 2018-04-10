#include "zdlg_registrar_i"

// The meat 'n veg of zdlg_registrar: put all text spoken by the NPC here.
void UniqueConversation()
{
  SetText(TEXT_ANYTHING_ELSE, "Alright. Anything else I can do for you?");
  SetText(TEXT_APPLY_CONFIRM, "Excellent. There is a one-time fee of %1 gold: You must have the gold upon your person. Is that fine by you?");
  SetText(TEXT_ELECTION_PROGRESS, "I know you're impatient, but I really can't tell you that until the challenge is over.");
  SetText(TEXT_FOREIGN_PROMPT, "Right, what policy decisions do you need to make?\n\n<c  þ>[Speak the name of a nation before choosing]</c>");
  SetText(TEXT_FOREIGN_TRADE_CLOSE, "So, you want to close off trade with %1?");
  SetText(TEXT_FOREIGN_TRADE_OPEN, "So, you want to start supplying %1 with our excess goods for money?");
  SetText(TEXT_FOREIGN_VASSAL, "This is quite serious. Are you really set on handing over full leadership rights to the leaders of %1? There is no going back without their permission if you are.");
  SetText(TEXT_FOREIGN_WAR_CEASE, "So, I should tell our guards to leave anyone from %1 alone from now on?");
  SetText(TEXT_FOREIGN_WAR_DECLARE, "Okay, so I should let our guards know that they should attack anyone from %1 on sight from now on, correct?");
  SetText(TEXT_GOODBYE_CANCEL, "Farewell then.");
  SetText(TEXT_GOODBYE_DONE, "It is done. Farewell.");
  SetText(TEXT_PERSONAL_PROMPT, "Right. What shall it be then, and who is this about?\n\n<c  þ>[Speak the name of a person before choosing: <c þ >[...]</c> is a placeholder for the name you speak.]</c>");
  SetText(TEXT_RESIGN_CONFIRM, "I'm sorry to hear that: are you set on resigning?");
  SetText(TEXT_RESIGN_VASSAL_CONFIRM, "Really? We are to be free now?");
  SetText(TEXT_RESIGN_DONE, "Then it has been an honour working for you. Farewell.");
  SetText(TEXT_SELECT_NAME, "Which of the following did you mean?");
  SetText(TEXT_TAX_PROMPT, "So, what should the new tax rate be? Currently we are charging taxes on everything at %1%.\n\n<c  þ>((Please include the decimal point, i.e. 10.0 not 10))</c>");
  SetText(TEXT_WELCOME_BANISHED, "Begone, criminal.  I'm not speaking to the likes of you.");
  SetText(TEXT_WELCOME_CANDIDATE, "Welcome back, %f! Good luck in the challenge. Is there anything I can do for you?");
  SetText(TEXT_WELCOME_MEMBER, "Good %t, %f. How can I help you?");
  SetText(TEXT_WELCOME_NONVOTER, "Good %t, %f. Are you here to show your support in the upcoming challenge, perchance?");
  SetText(TEXT_WELCOME_OUTSIDER, "Good %t. Can I help?");
  SetText(TEXT_WELCOME_VOTER, "Good %t, %f. The challenge is still not over. How can I be of assistance?");
  SetText(TEXT_WHO, "Who? Sorry, I didn't catch that. <c þ >(Speak the name of the target here. You can skip this screen by speaking the name before choosing an option with [...] in it.)</c>");
  SetText(TEXT_VOTE_PROMPT, "Who will have your support? ");
  SetText(TEXT_CAN_CIT, "Are you sure you wish to remove your citizenship?");
  SetText(TEXT_WELCOME_CANNOTVOTE, "Good %t, %f. There is a challenge happening now. However, you must wait longer until you are eligible to vote.");
  SetText(TEXT_APCAN, "Which faction will you be representing in the challange? <cþ  >((WARNING: The faction name should represent the setting. NO character names, blank fields, slogans or anything harmful to the setting. Factions that do not comply will be removed from the settlement as well as their members!))</c>");
  SetText(TEXT_REPLACE, "Which member should be the new settlement leader?");
  SetText(TEXT_NOBLE, "Who shall we grant nobility? Number of Nobles: %1. You may remove: %2.");
}

void main()
{
  miZDRun();
}
