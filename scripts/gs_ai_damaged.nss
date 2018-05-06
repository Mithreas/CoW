#include "inc_combat"
#include "inc_combat2"
#include "inc_effect"
#include "inc_event"
#include "inc_state"
#include "inc_vampire"

void _teleportSummonsToAttacker(object attacker, object attacked);
void _resolveVampireBiteAttacks(object attacker, object attacked);

void main()
{
    SignalEvent(OBJECT_SELF, EventUserDefined(GS_EV_ON_DAMAGED));

    gsFXBleed();
    gsC2SetDamage();

    object oHighestDamager = gsC2GetHighestDamager();
    object oLastDamager    = gsC2GetLastDamager();

    if (GetObjectType(oHighestDamager) == OBJECT_TYPE_AREA_OF_EFFECT)
        oHighestDamager = GetAreaOfEffectCreator(oHighestDamager);
    if (GetObjectType(oLastDamager) == OBJECT_TYPE_AREA_OF_EFFECT)
        oLastDamager    = GetAreaOfEffectCreator(oLastDamager);

    if (gsCBGetHasAttackTarget())
    {
        object oTarget = gsCBGetLastAttackTarget();

        if (GetIsObjectValid(oHighestDamager) &&
            oHighestDamager != oTarget)
        {
            gsCBDetermineCombatRound(oHighestDamager);
        }
    }
    else
    {
        gsCBDetermineCombatRound(oHighestDamager);
    }

    _teleportSummonsToAttacker(oLastDamager, OBJECT_SELF);
    _resolveVampireBiteAttacks(oLastDamager, OBJECT_SELF);
	
	// Crime system hook
	IWasAttacked(OBJECT_SELF, oLastDamager);
}

void _teleportSummonsToAttacker(object attacker, object attacked)
{
    int i;
    for (i = ASSOCIATE_TYPE_HENCHMAN; i < ASSOCIATE_TYPE_DOMINATED; ++i)
    {
        int nth = 1;

        while (TRUE)
        {
            object associate = GetAssociate(i, attacker, nth++);

            if (!GetIsObjectValid(associate))
            {
                break;
            }

            if (GetLocalInt(associate, "TELEPORT_TO_OWNER_ON_HIT") && GetIsAssociateAIEnabled(associate))
            {
                float distanceToMaster = GetDistanceBetween(attacker, associate);

                if (distanceToMaster >= 2.0f)
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE), associate);

                    vector pos = GetPosition(attacker);
                    pos.x += IntToFloat(d2()) - 1.5f;
                    pos.y += IntToFloat(d2()) - 1.5f;

                    AssignCommand(associate, ClearAllActions());
                    AssignCommand(associate, JumpToLocation(Location(GetArea(associate), pos, GetFacing(attacker))));
                    DelayCommand(0.5, AssignCommand(associate, gsCBDetermineCombatRound(attacked)));
                }
            }
        }
    }
}

void _resolveVampireBiteAttacks(object attacker, object attacked)
{
    int ranged = GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, attacker));

    if (VampireIsVamp(attacker) && VampireBiteAttackIsQueued(attacker) && !ranged)
    {
        VampireBiteAttackSetQueued(attacker, FALSE);

        if (!gsSPGetIsLiving(attacked))
        {
            FloatingTextStringOnCreature(GetName(attacked) + "'s flesh does not satisfy your thirst for blood.", attacker, TRUE);
            return;
        }

        FloatingTextStringOnCreature("You sink your teeth into " + GetName(attacked) + "'s soft flesh.", attacker, TRUE);
        float bloodGain = VampireBiteAttackResolve(attacker, attacked);
        gsSTAdjustState(GS_ST_BLOOD, bloodGain, attacker);
        SetTimelock(attacker, 180, "Vampire Bite", 30, 6);
    }
}