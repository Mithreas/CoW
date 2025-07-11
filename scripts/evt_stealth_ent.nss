#include "inc_rename"
#include "inc_timelock"
#include "inc_divination"
#include "inc_xfer"
#include "inc_class"

void RoundStealthTimerIncrement()
{
    int existingTimer = GetLocalInt(OBJECT_SELF, "StealthTimer");

    if (existingTimer == -1) // We've exited stealth.
    {
        if (!GetLocalInt(OBJECT_SELF, "Reachable"))
        {
            // We're now reachable again.
            miFXUpdatePlayerReachable(OBJECT_SELF, TRUE);
            //SendMessageToPC(OBJECT_SELF, "You are now reachable by Speedy Messengers.");
        }
    }
    else
    {
        SetLocalInt(OBJECT_SELF, "StealthTimer", existingTimer + 6);

        if (existingTimer + 6 >= 30 && GetLocalInt(OBJECT_SELF, "Reachable"))
        {
            miFXUpdatePlayerReachable(OBJECT_SELF, FALSE);
            //SendMessageToPC(OBJECT_SELF, "You are no longer reachable by Speedy Messengers.");
        }

        DelayCommand(6.0, RoundStealthTimerIncrement());
    }
}

void UpdateKoboldHIPS(object oPC, int bEnable)
{
  object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
  
  if (GetResRef(oHide) != "x2_it_koboldcomm") return;
  
  if (bEnable) 
  {
	IPSafeAddItemProperty(oHide, ItemPropertyBonusFeat(IP_CONST_FEAT_HIDE_IN_PLAIN_SIGHT), 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);
	return;
  }
  
  itemproperty iprop = GetFirstItemProperty(oHide);
  
  while (GetIsItemPropertyValid(iprop))
  {
    if (GetItemPropertyType(iprop) == ITEM_PROPERTY_BONUS_FEAT &&
	    GetItemPropertySubType(iprop) == IP_CONST_FEAT_HIDE_IN_PLAIN_SIGHT)
	{
	  RemoveItemProperty(oHide, iprop);
	}
	
	iprop = GetNextItemProperty(oHide);
  }
}

void main()
{
    object oPC = OBJECT_SELF;
    if (GetIsPC(oPC))
    {
        if(GetIsTimelocked(oPC, "Hide in Plain Sight"))
        {
            NWNX_Creature_RemoveFeat(oPC, FEAT_HIDE_IN_PLAIN_SIGHT);
			UpdateKoboldHIPS(oPC, FALSE);
        }
        else if(!GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oPC))
        {
            UpdateRangerHiPS(oPC);
            if(GetIsShadowMage(oPC))
                AddShadowMageFeats(oPC);
            if (GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC) >= 1)
                AddKnownFeat(oPC, FEAT_HIDE_IN_PLAIN_SIGHT, GetLevelByClassLevel(oPC, CLASS_TYPE_SHADOWDANCER, 1));
			UpdateKoboldHIPS(oPC, TRUE);
        }

        if (GetHasFeat(FEAT_HIDE_IN_PLAIN_SIGHT, oPC))
        {
            SetIsTimelockMuted(OBJECT_SELF, "Hide in Plain Sight", TRUE);
        }

        SetLocalInt(oPC, "StealthTimer", 0);
        DelayCommand(6.0, RoundStealthTimerIncrement());
		
		int nTimeout = GetLocalInt(oPC, "AIR_TIMEOUT");
		if (gsTIGetActualTimestamp() > nTimeout)
		{
          miDVGivePoints(oPC, ELEMENT_AIR, 1.0);
		  SetLocalInt(oPC, "AIR_TIMEOUT", gsTIGetActualTimestamp() + 60);
		}  
		
        svSetAffix(oPC, STEALTH_PREFIX, TRUE);
    }
    else
        SetName(OBJECT_SELF, STEALTH_PREFIX_S + GetName(OBJECT_SELF, TRUE) + "</c>");

}
