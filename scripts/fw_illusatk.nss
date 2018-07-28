// On hit cast script for illusionary attacks.  Invoked by x2_s3_onhitcast
// for items with the tag "fw_illusatk". 
#include "x2_inc_switches"

//-------------------------------------------------------------------
// Illusions may be equipped with either a bow or a slashing weapon.
// They must be set up with "no damage" properties and no str bonus,
// the On Hit Cast Spell Unique Power ability, and the tag fw_illusatk
// (this goes on the arrows for a bow).  Set the items as plot so they
// don't drop.
// 
// If the NPC hits the PC, the PC makes a Will save.
// On success, the PC takes no damage.  On failure, we do piercing or
// slashing damage according to whether it's a ranged attack or not.
//-------------------------------------------------------------------
void main()
{
    int nEvent =GetUserDefinedItemEventNumber();

    // * This code runs when the item has the OnHitCastSpell: Unique power property
    // * and it hits a target(weapon) or is being hit (armor)
    // * Note that this event fires for non PC creatures as well.
    if (nEvent ==X2_ITEM_EVENT_ONHITCAST)
    {
        object oSpellTarget = GetSpellTargetObject();
        int nDC = GetHitDice(OBJECT_SELF) + 10;
		
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
		
        if (!WillSave(oSpellTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
        {
          int nDam = d8(GetHitDice(OBJECT_SELF) / 5);
	
	      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, GetWeaponRanged(oWeapon) ? DAMAGE_TYPE_PIERCING : DAMAGE_TYPE_SLASHING), oSpellTarget);
        }
		
    }
}	