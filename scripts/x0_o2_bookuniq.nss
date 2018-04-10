#include "inc_nwnloot"
void main()
{
    object oPC = GetLastOpenedBy();
    string sUsername = "N/A";
    if (oPC != OBJECT_INVALID && GetIsPC(oPC))
    {
        sUsername = GetPCPlayerName(oPC);
    }
    else if (oPC == OBJECT_INVALID)
    {
          oPC = GetLastDamager();
          if (oPC != OBJECT_INVALID && GetIsPC(oPC))
          {
                sUsername = GetPCPlayerName(oPC);
          }
    }
    logNWNLootContainer(sUsername);
}