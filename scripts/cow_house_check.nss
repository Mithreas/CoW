/* cow_house_check */
// Returns TRUE if PC is a member of House Drannis
int isDrannis(object oPC);
// Returns TRUE if PC is a member of House Erenia
int isErenia(object oPC);
// Returns TRUE if PC is a member of House Renerrin
int isRenerrin(object oPC);
// Returns TRUE if PC is an Imperial
int isImperial(object oPC);

int isDrannis(object oPC)
{
    return (GetSubRace(oPC) == "House Drannis");
}

int isErenia(object oPC)
{
    return (GetSubRace(oPC) == "House Erenia");
}

int isRenerrin(object oPC)
{
    return (GetSubRace(oPC) == "House Renerrin");
}

int isImperial(object oPC)
{
    return (GetSubRace(oPC) == "Imperial");
}

int isShadow(object oPC)
{
    return (GetSubRace(oPC) == "Shadow");
}
