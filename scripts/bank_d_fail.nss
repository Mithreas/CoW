//  ScarFace's Persistent Banking system  - Deposit Failed -
int StartingConditional()
{
    return(GetGold(GetPCSpeaker()) < StringToInt(GetLocalString(OBJECT_SELF, "GOLD")));
}
