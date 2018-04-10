//  ScarFace's Persistent Banking system  - Anti-Cheat -
int StartingConditional()
{
    if (GetLocalInt(OBJECT_SELF, "ANTI_CHEAT"))
    {
        DeleteLocalInt(OBJECT_SELF, "ANTI_CHEAT");
        return TRUE;
    }
    return FALSE;
}
