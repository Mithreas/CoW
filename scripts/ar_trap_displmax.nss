void main()
{

object oPC = GetEnteringObject();

if (!GetIsPC(oPC)) return;

object oTarget;
oTarget = oPC;

ActionCastSpellAtObject(SPELL_MORDENKAINENS_DISJUNCTION, oTarget, METAMAGIC_ANY, TRUE, 25, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);

}

