const int GS_CREATURE_PART = CREATURE_PART_LEFT_BICEP;

void main()
{
    object oSpeaker = GetPCSpeaker();
    object oItem    = GetItemInSlot(INVENTORY_SLOT_CHEST, oSpeaker);
    int nModelType  = GetCreatureBodyPart(GS_CREATURE_PART, oSpeaker);

    if (GetIsObjectValid(oItem)) AssignCommand(oSpeaker, ActionUnequipItem(oItem));

    switch (nModelType)
    {
    case CREATURE_MODEL_TYPE_SKIN:
        SetCreatureBodyPart(GS_CREATURE_PART, CREATURE_MODEL_TYPE_TATTOO, oSpeaker);
        break;

    case CREATURE_MODEL_TYPE_TATTOO:
        SetCreatureBodyPart(GS_CREATURE_PART, CREATURE_MODEL_TYPE_SKIN, oSpeaker);
        break;

    default:
        return;
    }

    switch (Random(3))
    {
    case 0: PlayVoiceChat(VOICE_CHAT_PAIN1, oSpeaker); break;
    case 1: PlayVoiceChat(VOICE_CHAT_PAIN2, oSpeaker); break;
    case 2: PlayVoiceChat(VOICE_CHAT_PAIN3, oSpeaker); break;
    }
}
