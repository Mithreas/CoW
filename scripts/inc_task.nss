/* TASK Library by Gigaschatten */

//void main() {}

const int GS_TA_FETCH_SLUG    = 0;
const int GS_TA_HEAT_SLUG     = 1;
const int GS_TA_WORK_AT_ANVIL = 2;
const int GS_TA_COOL_SLUG     = 3;
const int GS_TA_DANCE         = 4;
const int GS_TA_MINE_AT_ROCK  = 5;
const int GS_TA_TORTURE       = 6;

const float GS_TA_RANGE       = 40.0;
const int GS_TA_LIMIT         = 15;

int gsTAMatchOffset;
int gsTAMatchValue1;
int gsTAMatchValue2;

//register or unregister nTaskNumber assigning nEventNumber
void gsTARegisterTask(int nTaskNumber, int nEventNumber, int nValid = TRUE);
//add or remove listener nTaskNumber to/from caller
void gsTASetTaskListener(int nTaskNumber, int nValid = TRUE, int nLimit = TRUE);
//return TRUE if caller is listening for nTaskNumber
int gsTAGetIsTaskListener(int nTaskNumber);
//switch from nDisableTask to nEnableTask
void gsTASwitchTask(int nDisableTask, int nEnableTask);
//apply trigger nTaskNumber to any object of nObjectType matching sTagPattern within fDistance of caller
void gsTASeekTaskTrigger(string sTagPattern, int nTaskNumber, int nObjectType = OBJECT_TYPE_ALL, float fDistance = 0.0);
//apply trigger nTaskNumber to oTarget
void gsTASetTaskTrigger(object oTarget, int nTaskNumber);
//return TRUE if trigger nTaskNumber is assigned to oTarget
int gsTAGetIsTaskTrigger(object oTarget, int nTaskNumber);
//return last object that triggered taskevent on oCreature
object gsTAGetLastTaskTrigger(object oCreature = OBJECT_SELF);
//remove trigger nTaskNumber from oTarget
void gsTAReleaseTaskTrigger(object oTarget, int nTaskNumber);
//return first task greater than nTaskOffset matching nTask and nTaskTarget
int gsTAGetFirstTaskMatch(int nTask, int nTaskTarget, int nTaskOffset = FALSE);
//return next task matching values initialized by gsTAGetFirstTaskMatch
int gsTAGetNextTaskMatch();
//return TRUE if task event is raised on caller
int gsTADetermineTaskTarget();

void gsTARegisterTask(int nTaskNumber, int nEventNumber, int nValid = TRUE)
{
    object oModule     = GetModule();
    string sTaskNumber = IntToString(FloatToInt(pow(2.0, IntToFloat(nTaskNumber))));

    if (nValid) SetLocalInt(oModule, "GS_TA_REGISTRY_" + sTaskNumber, nEventNumber);
    else        DeleteLocalInt(oModule, "GS_TA_REGISTRY_" + sTaskNumber);
}
//----------------------------------------------------------------
void gsTASetTaskListener(int nTaskNumber, int nValid = TRUE, int nLimit = TRUE)
{
    int nTask    = GetLocalInt(OBJECT_SELF, "GS_TA_LISTENER");
    int nNewTask = nTask;

    nTaskNumber  = FloatToInt(pow(2.0, IntToFloat(nTaskNumber)));

    if (nValid)
    {
        nNewTask |= nTaskNumber;
        SetLocalInt(OBJECT_SELF, "GS_TA_LIMIT_" + IntToString(nTaskNumber), nLimit);
    }
    else
    {
        nNewTask &= ~nTaskNumber;
        DeleteLocalInt(OBJECT_SELF, "GS_TA_LIMIT_" + IntToString(nTaskNumber));
    }

    SetLocalInt(OBJECT_SELF, "GS_TA_LISTENER", nNewTask);
}
//----------------------------------------------------------------
int gsTAGetIsTaskListener(int nTaskNumber)
{
    return GetLocalInt(OBJECT_SELF, "GS_TA_LISTENER") & FloatToInt(pow(2.0, IntToFloat(nTaskNumber)));
}
//----------------------------------------------------------------
void gsTASwitchTask(int nDisableTask, int nEnableTask)
{
    gsTASetTaskListener(nEnableTask);
    gsTASetTaskListener(nDisableTask, FALSE);
}
//----------------------------------------------------------------
void gsTASeekTaskTrigger(string sTagPattern, int nTaskNumber, int nObjectType = OBJECT_TYPE_ALL, float fDistance = 0.0)
{
    object oObject = GetNearestObject(nObjectType, OBJECT_SELF, 1);
    int nNth       = 1;

    while (GetIsObjectValid(oObject) &&
           (fDistance == 0.0 ||
            GetDistanceToObject(oObject) <= fDistance))
    {
        if (TestStringAgainstPattern(sTagPattern, GetTag(oObject)))
        {
            gsTASetTaskTrigger(oObject, nTaskNumber);
        }

        oObject = GetNearestObject(nObjectType, OBJECT_SELF, ++nNth);
    }
}
//----------------------------------------------------------------
void gsTASetTaskTrigger(object oTarget, int nTaskNumber)
{
    int nTask  = GetLocalInt(oTarget, "GS_TA_TRIGGER");

    nTask     |= FloatToInt(pow(2.0, IntToFloat(nTaskNumber)));
    SetLocalInt(oTarget, "GS_TA_TRIGGER", nTask);
}
//----------------------------------------------------------------
int gsTAGetIsTaskTrigger(object oTarget, int nTaskNumber)
{
    nTaskNumber = FloatToInt(pow(2.0, IntToFloat(nTaskNumber)));
    return GetLocalInt(oTarget, "GS_TA_TRIGGER") & nTaskNumber;
}
//----------------------------------------------------------------
object gsTAGetLastTaskTrigger(object oCreature = OBJECT_SELF)
{
    return GetLocalObject(oCreature, "GS_TA_TARGET");
}
//----------------------------------------------------------------
void gsTAReleaseTaskTrigger(object oTarget, int nTaskNumber)
{
    int nTask  = GetLocalInt(oTarget, "GS_TA_TRIGGER");

    nTask     &= ~FloatToInt(pow(2.0, IntToFloat(nTaskNumber)));
    SetLocalInt(oTarget, "GS_TA_TRIGGER", nTask);
}
//----------------------------------------------------------------
int gsTAGetFirstTaskMatch(int nTask, int nTaskTarget, int nTaskOffset = FALSE)
{
    gsTAMatchValue1 = nTask;
    gsTAMatchValue2 = nTaskTarget;

    if (gsTAMatchValue1 & gsTAMatchValue2)
    {
        int nNth;

        for (; nTaskOffset < 32; nTaskOffset++)
        {
            nNth = FloatToInt(pow(2.0, IntToFloat(nTaskOffset)));

            if (nNth & gsTAMatchValue1 &&
                nNth & gsTAMatchValue2)
            {
                gsTAMatchOffset++;
                return nNth;
            }
        }
    }

    gsTAMatchOffset = FALSE;
    return FALSE;
}
//----------------------------------------------------------------
int gsTAGetNextTaskMatch()
{
    // Bugged - gsTAMatchOffset is reset to 0 in gsTAGetFirstTaskMatch.
    // Do not call.
    return gsTAGetFirstTaskMatch(gsTAMatchValue1, gsTAMatchValue2, gsTAMatchOffset);
}
//----------------------------------------------------------------
int gsTADetermineTaskTarget()
{
    int nTask = GetLocalInt(OBJECT_SELF, "GS_TA_LISTENER");
    if (! nTask) return FALSE;
    int nLimit;
    int nCount;

    int nTaskTarget;
    int nTaskMatch;
    int nTaskEvent;

    int nNth = 1;
    int _nTask;
    int _nNth;
    int __nNth;
    object _oTarget;
    object __oTarget;
    int nValid;

    //seek task target
    object oTarget = GetNearestObject(OBJECT_TYPE_ALL);

    while (nNth <= GS_TA_LIMIT &&
           GetIsObjectValid(oTarget) &&
           GetDistanceToObject(oTarget) < GS_TA_RANGE)
    {
        //compare
        nTaskTarget = GetLocalInt(oTarget, "GS_TA_TRIGGER");
        nTaskMatch  = gsTAGetFirstTaskMatch(nTask, nTaskTarget);

        while (nTaskMatch)
        {
            //limit
            nLimit = GetLocalInt(OBJECT_SELF, "GS_TA_LIMIT_" + IntToString(nTaskMatch));

            if (nLimit)
            {
                nCount   = 0; //limit counter

                //alternative listener near target
//................................................................
                _nNth    = 1;
                _oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oTarget);

                while (_nNth <= GS_TA_LIMIT &&
                       GetIsObjectValid(_oTarget) &&
                       _oTarget != OBJECT_SELF &&
                       GetDistanceToObject(_oTarget) < GS_TA_RANGE &&
                       nCount < nLimit)
                {
                    _nTask = GetLocalInt(_oTarget, "GS_TA_LISTENER");

                    if (_nTask & nTaskMatch) //match
                    {
                        nValid = TRUE;

                        //alternative listener potential target
//................................................................
                        __nNth    = 1;
                        __oTarget = GetNearestObject(OBJECT_TYPE_ALL, _oTarget);

                        while (__nNth <= GS_TA_LIMIT &&
                               GetIsObjectValid(__oTarget) &&
                               __oTarget != oTarget &&
                               GetDistanceBetween(_oTarget, __oTarget) < GS_TA_RANGE)
                        {
                            //alternative target
                            if (_nTask & GetLocalInt(__oTarget, "GS_TA_TRIGGER"))
                            {
                                nValid = FALSE;
                                break;
                            }

                            __oTarget = GetNearestObject(OBJECT_TYPE_ALL, _oTarget, ++__nNth);
                        }
//................................................................
                        if (nValid) nCount++; //same target
                    }
                    _oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oTarget, ++_nNth);
                }
//................................................................
            }

            //raise task event
            if (! nLimit || nCount < nLimit)
            {
                nTaskEvent = GetLocalInt(GetModule(), "GS_TA_REGISTRY_" + IntToString(nTaskMatch));

                if (nTaskEvent)
                {
                    SetLocalObject(OBJECT_SELF, "GS_TA_TARGET", oTarget);
                    SignalEvent(OBJECT_SELF, EventUserDefined(nTaskEvent));

                    return TRUE;
                }
            }

            // Removed - method is bugged and results in TMI in the following
            // scenario:  actor1 - target - - - - actor2
            // actor2 will trigger a TMI.
            //nTaskMatch = gsTAGetNextTaskMatch();
            nTaskMatch = FALSE;
        }

        oTarget = GetNearestObject(OBJECT_TYPE_ALL, OBJECT_SELF, ++nNth);
    }

    //no trigger found
    SignalEvent(OBJECT_SELF, EventUserDefined(8000));
    return FALSE;
}
