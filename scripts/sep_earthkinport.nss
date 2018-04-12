#include "inc_common"
void main()
{
    object oUser   = GetLastUsedBy();
    if (! GetIsPC(oUser)) return;
    string sTag    = GetLocalString(OBJECT_SELF, "CustomFlag");
    object oTarget = GetWaypointByTag(sTag);

    string sSubrace = GetSubRace(oUser);
    int bDuergar = TestStringAgainstPattern("**Duergar**", GetSubRace(oUser));
    int bGoblin = TestStringAgainstPattern("**Goblin**", GetSubRace(oUser));
    int bKobold = TestStringAgainstPattern("**Kobold**", GetSubRace(oUser));
    int bImp = TestStringAgainstPattern("**Imp**", GetSubRace(oUser));

    if ((!bDuergar)&&(!bKobold)&&(!bGoblin)&&!bImp)
    {
        if ((GetRacialType(oUser) == RACIAL_TYPE_GNOME)||
            (GetRacialType(oUser) == RACIAL_TYPE_DWARF)||
            (GetRacialType(oUser) == RACIAL_TYPE_HALFLING))
            {
                gsCMTeleportToObject(oUser, oTarget, FALSE);
            }
        else
        {
        SendMessageToPC(oUser, "This portal only functions for gnomes, dwarves, and halflings who are a part of the Earthkin Alliance.");
        }
    }
    else
    {
        SendMessageToPC(oUser, "Duergar, Goblins, Imps and Kobolds are not a part of the Earthkin Alliance. The portal does not function.");
    }
}
