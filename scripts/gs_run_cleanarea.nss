#include "inc_area"
#include "inc_boss"
#include "inc_common"
#include "inc_encounter"
#include "inc_flag"

const int GS_TIMEOUT = 660; //11 mins - area timeout is 600 +/- 60.  This should minimise the chance of getting stacking bosses...!

// Determine if a creature is possessed/dominated/summoned etc.
// by a PC
int __GetIsPCPossessed(object oCreature)
{
    object oMaster = GetMaster(oCreature);
    if (!GetIsObjectValid(oMaster))
        return FALSE;
    return GetIsPC(oMaster);
}

void main()
{
    if (! GetLocalInt(OBJECT_SELF, "GS_ENABLED"))
    {
        gsARUnregisterArea(OBJECT_SELF);
        return;
    }

    object oModule     = GetModule();
    int nTimestamp     = GetLocalInt(oModule, "GS_TIMESTAMP");
    int nTimestampArea = GetLocalInt(OBJECT_SELF, "GS_TIMESTAMP");

    //clean up area
    if (nTimestampArea != nTimestamp && GetLocalInt(OBJECT_SELF, "DM_FORCE_ACTIVE") != 1)
    {
        object oObject  = GetFirstObjectInArea(OBJECT_SELF);
        object oItem    = OBJECT_INVALID;
        string sString  = "";
        int nTimeout    = nTimestamp - nTimestampArea > GS_TIMEOUT;
        int nUnregister = TRUE;

        while (GetIsObjectValid(oObject))
        {
            switch (GetObjectType(oObject))
            {
            case OBJECT_TYPE_AREA_OF_EFFECT:

                break;

            case OBJECT_TYPE_CREATURE:

                //dead creature
                if (GetIsDead(oObject))
                {
                    //destroy creature
                    if (gsFLGetFlag(GS_FL_MORTAL, oObject))
                    {
                        gsCMDestroyObject(oObject);
                    }

                    break;
                }

                //encounter creature
                if (gsENGetIsEncounterCreature(oObject))
                {
                    //destroy creature
                    if (nTimeout ||
                        GetLocalInt(oObject, "GS_TIMEOUT") < nTimestamp)
                    {
                        if (!__GetIsPCPossessed(oObject))
                        {
                            gsCMDestroyObject(oObject);
                            break;
                        }
                    }

                    nUnregister = FALSE;
                    break;
                }

                //boss creature
                if (gsBOGetIsBossCreature(oObject))
                {
                    //destroy creature
                    if (nTimeout ||
                        GetLocalInt(oObject, "GS_TIMEOUT") < nTimestamp)
                    {
                        if (!__GetIsPCPossessed(oObject))
                        {
                            gsCMDestroyObject(oObject);
                            break;
                        }
                    }

                    nUnregister = FALSE;
                    break;
                }

                sString = GetTag(oObject);

                break;

            case OBJECT_TYPE_DOOR:

            case OBJECT_TYPE_ENCOUNTER:

                break;

            case OBJECT_TYPE_ITEM:

                if (! GetLocalInt(oObject, "GS_STATIC")  ||
                    GetResRef(oObject) == "gs_placeable016" ||
                    GetName(oObject) == "Remains")
                {
                  //destroy item
                  if (nTimeout)
                  {
                      gsCMDestroyObject(oObject);
                      break;
                  }

                  nUnregister = FALSE;
                  break;
                }
            case OBJECT_TYPE_PLACEABLE:

                //dynamic
                if (! GetLocalInt(oObject, "GS_STATIC"))
                {
                    //destroy placeable
                    if (nTimeout)
                    {
                        gsCMDestroyObject(oObject);
                        break;
                    }

                    nUnregister = FALSE;
                }

                break;

            case OBJECT_TYPE_STORE:

                break;

            case OBJECT_TYPE_TRIGGER:

                break;

            case OBJECT_TYPE_WAYPOINT:

                string sTag = GetTag(oObject);

                // Dynamic AoE encounters
                if (sTag == "GU_ENCOUNTER" ||
                    sTag == "GU_BOSS")
                {
                    if (nTimeout)
                    {
                        object oAOE = GetLocalObject(oObject, "GU_EN_AOE");
                        if (!GetIsObjectValid(oAOE))
                            Error(ENCOUNTER, "Cleaning up encounter with no AOE");
                        DestroyObject(oAOE);
                        DestroyObject(oObject);
                        break;
                    }

                  nUnregister = FALSE;
                  break;
                }

                break;
            }

            oObject = GetNextObjectInArea(OBJECT_SELF);
        }

        if (nUnregister) gsARUnregisterArea(OBJECT_SELF);
    }
}
