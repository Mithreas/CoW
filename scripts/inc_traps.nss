// inc_traps
// Split from mi_inc_traps to avoid dependency issues.
// Includes universal trap functions.

//-------------------------------------------------------------------------------------------

// Clear traps near an object
void trapClearTrapsNear(object oObject, float fDistance = 10.0f, int bPC_Only = TRUE);

//-------------------------------------------------------------------------------------------

void trapClearTrapsNear(object oObject, float fDistance = 10.0f, int bPC_Only = TRUE)
{
    int nCnt = 1;
    object oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);

    // Search trap-able objects in range.
    while(GetIsObjectValid(oTrap) && GetDistanceToObject(oTrap) <= fDistance)
    {
        // Disable traps within that range.  Only do PC-made traps if bPC_Only is TRUE.
        if(GetIsTrapped(oTrap) && (!bPC_Only || GetTrapCreator(oTrap) != OBJECT_INVALID))
        {
            SetTrapDisabled(oTrap);
        }

        // Get next object.
        nCnt++;
        oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    }
}
