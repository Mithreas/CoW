// Fancy sound and light show, plus clock.

void main()
{
PlaySound("as_cv_gongring3");

object oCaster;
oCaster = GetObjectByTag("FEVMG_CLOCK_1");

object oTarget;
oTarget = GetObjectByTag("FEVMG_CLOCK_2");

AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_RAY_OF_FROST, oTarget, METAMAGIC_ANY, TRUE, 3, PROJECTILE_PATH_TYPE_DEFAULT, FALSE));

oCaster = GetObjectByTag("FEVMG_CLOCK_2");

oTarget = GetObjectByTag("FEVMG_CLOCK_3");

DelayCommand(0.3f, AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_RAY_OF_FROST, oTarget, METAMAGIC_ANY, TRUE, 3, PROJECTILE_PATH_TYPE_DEFAULT, FALSE)));

oCaster = GetObjectByTag("FEVMG_CLOCK_3");

oTarget = GetObjectByTag("FEVMG_CLOCK_4");

DelayCommand(0.6f, AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_RAY_OF_FROST, oTarget, METAMAGIC_ANY, TRUE, 3, PROJECTILE_PATH_TYPE_DEFAULT, FALSE)));

oCaster = GetObjectByTag("FEVMG_CLOCK_4");

oTarget = GetObjectByTag("FEVMG_CLOCK_5");

DelayCommand(0.9f, AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_RAY_OF_FROST, oTarget, METAMAGIC_ANY, TRUE, 3, PROJECTILE_PATH_TYPE_DEFAULT, FALSE)));

oCaster = GetObjectByTag("FEVMG_CLOCK_5");

oTarget = GetObjectByTag("FEVMG_CLOCK_6");

DelayCommand(1.2f, AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_RAY_OF_FROST, oTarget, METAMAGIC_ANY, TRUE, 3, PROJECTILE_PATH_TYPE_DEFAULT, FALSE)));

oTarget = GetObjectByTag("FEVMG_CLOCK_6");

//Visual effects can't be applied to waypoints, so if it is a WP
//the VFX will be applied to the WP's location instead

int nInt;
nInt = GetObjectType(oTarget);

DelayCommand(1.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_TIME_STOP), oTarget));

int nTime = GetTimeHour();
string sSuffix = "th";
if (nTime == 1 || nTime == 21) sSuffix = "st";
if (nTime == 2 || nTime == 22) sSuffix = "nd";
if (nTime == 3 || nTime == 23) sSuffix = "rd";

DelayCommand(1.5f, AssignCommand(oTarget, SpeakString("It is the " + IntToString(nTime) + sSuffix + " hour of the clock.")));

}