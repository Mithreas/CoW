#include "gs_inc_common"
#include "gs_inc_time"
#include "mi_inc_divinatio"

const int GS_DAMAGE = 25;

int GetAdjustedDamage(int nDamageType)
{
  // GetDamageDealtByType returns -1 if no damage of that type was done.
  int nDamage = GetDamageDealtByType(nDamageType);

  if (nDamage != -1) return nDamage;
  else return 0;
}

void main()
{
    object oDamager  = GetLastDamager();

    // Addition by Mithreas to restrict allowable damage types.
    // Note - weapon damage doesn't count as slashing/piercing/bludgeoning.
    // Yes, that seems odd and counter-intuitive. But that's what testing shows.
    int nActualDamage =
                  GetAdjustedDamage(DAMAGE_TYPE_BASE_WEAPON) +
                  GetAdjustedDamage(DAMAGE_TYPE_PIERCING) +
                  GetAdjustedDamage(DAMAGE_TYPE_BLUDGEONING) +
                  GetAdjustedDamage(DAMAGE_TYPE_SLASHING) +
                  GetAdjustedDamage(DAMAGE_TYPE_FIRE) +
                  GetAdjustedDamage(DAMAGE_TYPE_COLD);

    // There's a biobug which means that the script only "sees" the damage from
    // the last attack of one or more simultaneous attacks. So always heal
    // all the damage done, and destroy the placeable ourselves once we've
    // taken 250 "counted" damage.
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectHeal(GetTotalDamageDealt()),
                        OBJECT_SELF);

    int nDamage = nActualDamage + GetLocalInt(OBJECT_SELF, "GS_DAMAGE");
    // End addition but note change below to nDamage.

	// Septire - Commented this out so familiars and NPCs can harvest resources
    // if (! GetIsPC(oDamager))              return;
    // if (GetIsPossessedFamiliar(oDamager)) return;
    string sTemplate = GetLocalString(OBJECT_SELF, "GS_TEMPLATE");
    if (sTemplate == "")                  return;
    int nChance      = GetLocalInt(OBJECT_SELF, "GS_CHANCE");
    if (nChance < 1)                      return;
    //int nDamage      = GetLocalInt(OBJECT_SELF, "GS_DAMAGE") +
    //                   GetTotalDamageDealt();

    // Divination plugin.
    miDVGivePoints(oDamager, ELEMENT_EARTH, 1.0);

	location lTarget = GetLocation(oDamager);
	
	if (GetDistanceBetween(oDamager, OBJECT_SELF) > 2.0)
	{
	  lTarget = GetLocation(OBJECT_SELF);
	}
	
	// Septire - Added resource collection --[
    object oItem;
    object oGroundItem = OBJECT_INVALID;
    int nCounter = 0;
    string sTag = GetLocalString(OBJECT_SELF, "ResourceTag");
    if (sTag == "")
    {
        // Create the item far away and get the tag, then destroy the item.
        vector vTemp = GetPosition(oDamager);
        vTemp = Vector(vTemp.x, vTemp.y, vTemp.z - 25.0);
        location lTemp = Location(GetArea(OBJECT_SELF), vTemp, 0.0);
        object oTemp = CreateObject(OBJECT_TYPE_ITEM, sTemplate, lTemp);

        sTag = GetTag(oTemp);
        SetLocalString(OBJECT_SELF, "ResourceTag", sTag);

        DestroyObject(oTemp);
        // SpeakString(sTag);
    }

    while (nDamage >= GS_DAMAGE)
    {
        if (nChance + Random(100) >= 100)
        {
            oGroundItem = GetNearestObjectByTag(sTag, OBJECT_SELF);

            // Septire - Added code to give ore directly to attacker --[
            if (GetDistanceToObject(oDamager) < 10.0 && GetDistanceToObject(oDamager) > 0.0 &&
                (GetMaster(oDamager) != OBJECT_INVALID && GetArea(oDamager) == GetArea(GetMaster(oDamager)) ||
                 GetMaster(oDamager) == OBJECT_INVALID))
            {
                // Attacker nearby, either it's a summon and the master is in the area,
                // or it's something that doesn't have a master
                if (GetMaster(oDamager) != OBJECT_INVALID)
                {
                    // SpeakString("Give to master");
                    oItem = CreateItemOnObject(sTemplate, GetMaster(oDamager));
                    SetIdentified(oItem, TRUE);
                    SetStolenFlag(oItem, FALSE);
                }
                else
                {
                    // SpeakString("Give");
                    oItem = CreateItemOnObject(sTemplate, oDamager);
                    SetIdentified(oItem, TRUE);
                    SetStolenFlag(oItem, FALSE);
                }
            }
            // ]--
            else if (oGroundItem == OBJECT_INVALID || GetDistanceToObject(oGroundItem) >= 10.0)
            {
                // Attacker is too far away or there's no initial stack on the ground
                // Initialize the stack.
                // SpeakString("New");
                oItem = CreateObject(OBJECT_TYPE_ITEM, sTemplate, lTarget);
                SetIdentified(oItem, TRUE);
                SetStolenFlag(oItem, FALSE);
            }
            else if (GetDistanceToObject(oGroundItem) < 10.0 && GetNumStackedItems(oGroundItem)+1 <= 99)
            {
                // Stack exists, increment the stack size by 1
                // SpeakString("Modify");
                if (nCounter == 0)
                {
                    nCounter = GetNumStackedItems(oGroundItem) + 1;
                }
                else
                {
                    nCounter += 1;
                }
            }
            else
            {
                // Can't increment the stack size, create a new stack.
                // It will keep creating new stacks, no resource should drop > 99 ore though
                // SpeakString("Overflow");
                oItem = CreateObject(OBJECT_TYPE_ITEM, sTemplate, lTarget);
                SetIdentified(oItem, TRUE);
                SetStolenFlag(oItem, FALSE);
            }

        }
        nDamage -= GS_DAMAGE;
    }

    if (nCounter > 0 && oGroundItem != OBJECT_INVALID)
    {
        // Finally, update the stack.
        SetItemStackSize(oGroundItem, nCounter);
    }
    // ]--

    // Addition by Mithreas - check whether this placeable should be destroyed.
    // Remove this section if you want to allow placeables to be healed...
    int nTotalDamage = nActualDamage +
                       GetLocalInt(OBJECT_SELF, "GS_TOTAL_DAMAGE");
    //SpeakString("Cumulative damage: " + IntToString(nTotalDamage));

    if (nTotalDamage > GetMaxHitPoints() && !GetLocalInt(OBJECT_SELF, "destroyed"))
    {
      SetLocalInt(OBJECT_SELF, "destroyed", 1);
      int GS_TIMEOUT = 7200; //2 hours
      gsCMCreateRecreator(gsTIGetActualTimestamp() + GS_TIMEOUT);
      DestroyObject(OBJECT_SELF);
    }
    else  SetLocalInt(OBJECT_SELF, "GS_TOTAL_DAMAGE", nTotalDamage);
    // End addition.

    SetLocalInt(OBJECT_SELF, "GS_DAMAGE", nDamage);
}
