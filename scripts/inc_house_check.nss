/* inc_house_check */
#include "inc_backgrounds"
// Returns TRUE if PC is a member of House Drannis
int isDrannis(object oPC);
// Returns TRUE if PC is a member of House Erenia
int isErenia(object oPC);
// Returns TRUE if PC is a member of House Renerrin
int isRenerrin(object oPC);
// Returns TRUE if PC is an Imperial
int isImperial(object oPC);
// Returns TRUE if the PC has no faction assigned.
int isUnaligned(object oPC);

int isDrannis(object oPC)
{
    return (miBAGetBackground(oPC) == MI_BA_DRANNIS);
}

int isErenia(object oPC)
{
    return (miBAGetBackground(oPC) == MI_BA_ERENIA);
}

int isRenerrin(object oPC)
{
    return (miBAGetBackground(oPC) == MI_BA_RENERRIN);
}

int isImperial(object oPC)
{
    return (miBAGetBackground(oPC) == MI_BA_IMPERIAL);
}

int isShadow(object oPC)
{
    return (miBAGetBackground(oPC) == MI_BA_SHADOW);
}

int isWarden(object oPC)
{
	return (miBAGetBackground(oPC) == MI_BA_WARDEN);
}

int isUnaligned(object oPC)
{
    return (miBAGetBackground(oPC) == MI_BA_NONE);
}