
void main()
{

    // Remove some gold from the player
    TakeGoldFromCreature(500, GetPCSpeaker(), TRUE);

    // destroy the NPC after 3 seconds
    SendMessageToPC(GetPCSpeaker(),"The guard nods and then gets out of your way.");
    SetIsDestroyable(TRUE);
    DestroyObject(OBJECT_SELF, 3.0f);
}
