//::///////////////////////////////////////////////
//:: Associate Control
//:: x3_pl_tool01
//:://////////////////////////////////////////////
/*
    Main driver for RTS-style associate control.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: January 13, 2016
//:://////////////////////////////////////////////

#include "inc_associates"

void main()
{
    int nAssociateCommand;
    object oAssociate;
    object oTarget = GetSpellTargetObject();

    if(GetIsControllableAssociate(oTarget))
        SetControlledAssociate(oTarget);
    else
    {
        oAssociate = GetControlledAssociate();
        if(!GetIsObjectValid(oAssociate))
        {
            SendMessageToPC(OBJECT_SELF, ERROR_NO_ASSOCIATE_SELECTED);
            return;
        }
        IssueAssociateCommands(oAssociate, DetermineAssociateCommand());
    }
}
