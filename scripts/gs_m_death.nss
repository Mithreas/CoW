#include "gs_inc_death"
#include "inc_subdual"

void main()
{
    object oDied = GetLastPlayerDied();

    object oKiller = GetLastHostileActor(oDied);

    if (gsFLGetAreaFlag("PVP", oDied))
    {
        DelayCommand(20.0, ApplyResurrection(oDied));
        return;
    }

    // check for subdual mode

    // first check if oKiller = oDied or OBJECT_INVALID, this seems to happen when bleeding to death in gs_m_dying

    // get subdual data from both killer and victim
    int iSubdualVictim = gvd_GetSubdualMode(oDied);
    int iSubdualKiller = gvd_GetSubdualMode(oKiller);
    int iSubdualStateVictim = gvd_GetSubdualState(oDied);

    //WriteTimestampedLogEntry("SUBDUAL SYSTEM TEMP LOG 01: " + GetName(oDied) + ", with subdualmode = " + IntToString(iSubdualVictim) + " and subdualstate = " + IntToString(iSubdualStateVictim) + " was killed/subdued by : " + GetName(oKiller) + " with subdualmode = " + IntToString(iSubdualKiller));

    // extra check needed when bled to death, since oKiller will be invalid object in that case
    if (oKiller == OBJECT_INVALID) {

      // if bled to death as a result of subdual fight, there wil be able object variable on the victim already (done in gs_m_dying)
      oKiller = GetLocalObject(oDied, "GVD_SUBDUAL_ATTACKER");

      //WriteTimestampedLogEntry("SUBDUAL SYSTEM TEMP LOG 02: " + GetName(oDied) + ", with subdualmode = " + IntToString(iSubdualVictim) + " and subdualstate = " + IntToString(iSubdualStateVictim) + " was killed/subdued by : " + GetName(oKiller) + " with subdualmode = " + IntToString(iSubdualKiller));

      if (oKiller != OBJECT_INVALID) {
        // we're sure the killer was in subdual mode (already checked in gs_m_dying), we use this also to prevent a PC from (accidentily cancelling subdual mode while the target is bleeding to death)
        iSubdualKiller = 1;
      }
    } 

    // 5% chance on death if the victim is not in subdual mode
    int iSubdualDeath = 0;
    int iSubdualTimeout = 40 + d20(1);
    if (iSubdualKiller != 0) {

      WriteTimestampedLogEntry("SUBDUAL SYSTEM: " + GetName(oDied) + ", with subdualmode = " + IntToString(iSubdualVictim) + " and subdualstate = " + IntToString(iSubdualStateVictim) + " was subdued by : " + GetName(oKiller) + ". AccidentalDeath (5%) = " + IntToString(iSubdualDeath));

      if (iSubdualVictim == 0) {
        iSubdualDeath = (d20(1) == 1);

        if (iSubdualDeath == 1) {
          FloatingTextStringOnCreature("Your last blow was lethal!", oKiller);
        }
      } else {
        // both combatants were in subdual mode, zero chance of death and shorter time-out
        iSubdualTimeout = 15 + d10(1);
      }
    }

    // clean-up variable
    DeleteLocalObject(oDied, "GVD_SUBDUAL_ATTACKER");

    // testing: if (1==1) {
    if ((iSubdualKiller != 0) && (iSubdualStateVictim == 0) && (iSubdualDeath == 0)) {
      // treat the victim as unconscious instead of dead
      gvd_ApplyUnconscious(oDied, iSubdualTimeout);
    
    } else {

      switch(CheckLifeline(oDied))
      {
        case LIFELINE_UNAVAILABLE:
            DoDeath(oDied);
            break;
        case LIFELINE_FAILED:
            DelayCommand(8.0, DoDeath(oDied));
            break;
      }
    }

}

