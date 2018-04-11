//::///////////////////////////////////////////////
//:: Executed Script: Modify Attacks
//:: exe_modattacks
//:://////////////////////////////////////////////
/*
    Sets the caller's number of attacks to a
    given number.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 22, 2017
//:://////////////////////////////////////////////

void main()
{
    int nAttacks = GetLocalInt(OBJECT_SELF, "SET_ATTACKS");

    SetBaseAttackBonus(nAttacks);
}
