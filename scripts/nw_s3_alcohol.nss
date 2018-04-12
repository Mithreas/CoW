#include "inc_state"
#include "inc_text"

void main()
{
    object oCaster      = GetLastSpellCaster();
    object oTarget      = GetSpellTargetObject();
    float fConstitution = IntToFloat(GetAbilityScore(oTarget, ABILITY_CONSTITUTION));
    float fSobriety     = 0.0;
    float fRest         = 0.0;

    switch (GetRacialType(oTarget))
    {
    case RACIAL_TYPE_CONSTRUCT:
    case RACIAL_TYPE_UNDEAD:
        return;
    }

    switch (GetSpellId())
    {
    case 406: //beer
    case 407: //wine
        fSobriety = -250.0 / fConstitution;
        fRest     = -25.0 / fConstitution;
        break;

    case 408: //spirit
        fSobriety = -500.0 / fConstitution;
        fRest     = -50.0 / fConstitution;
        break;
    }

    //AssignCommand(oTarget, SpeakString(GS_T_16777236));
    if (oCaster != oTarget) AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
    AssignCommand(oTarget, gsSTAdjustState(GS_ST_SOBRIETY, fSobriety));
    AssignCommand(oTarget, gsSTAdjustState(GS_ST_REST,     fRest));
}
