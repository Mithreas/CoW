void main()
{
    object oPlayer = GetPCSpeaker();
    if (oPlayer == OBJECT_INVALID)
    {
        oPlayer = GetExitingObject();
    }

    if(IsInConversation(oPlayer) == TRUE)
    {
        ClearAllActions();
    }

    object oDress = GetLocalObject(oPlayer, "dresslent");
    if (oDress != OBJECT_INVALID)
    {
        DestroyObject(oDress);
    }
}
