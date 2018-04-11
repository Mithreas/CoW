/*
  Name: inc_teleport
  Author: Mithreas
  Date: 5 Feb 06
  Description: Teleports a PC and their associates (summons/companions/etc)
*/
// Jump a PC and all their companions to a location.
void JumpAllToLocation(object oPC, location lLocation);

void JumpAllToLocation(object oPC, location lLocation)
{
    int i, j;
    object oAssociate;

    AssignCommand(oPC, JumpToLocation(lLocation));

    for(i = ASSOCIATE_TYPE_HENCHMAN; i <= ASSOCIATE_TYPE_DOMINATED; i++)
    {
        while(GetIsObjectValid(oAssociate = GetAssociate(i, oPC, ++j)))
        {
            AssignCommand(oAssociate, ClearAllActions());
            AssignCommand(oAssociate, JumpToLocation(lLocation));
            if(i == ASSOCIATE_TYPE_DOMINATED) break;
        }
        j = 0;
    }
}

// Jump a PC and all their companions to an object.
void JumpAllToObject(object oPC, object oTarget);

void JumpAllToObject(object oPC, object oTarget)
{
    int i, j;
    object oAssociate;

    AssignCommand(oPC, JumpToObject(oTarget));

    for(i = ASSOCIATE_TYPE_HENCHMAN; i <= ASSOCIATE_TYPE_DOMINATED; i++)
    {
        while(GetIsObjectValid(oAssociate = GetAssociate(i, oPC, ++j)))
        {
            AssignCommand(oAssociate, ClearAllActions());
            AssignCommand(oAssociate, JumpToObject(oTarget));
            if(i == ASSOCIATE_TYPE_DOMINATED) break;
        }
        j = 0;
    }
}
