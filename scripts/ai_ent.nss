// Ents can be punched for Things, and don't fight back. 
#include "inc_event"
#include "inc_behaviors"
#include "inc_time"

void main()
{
    switch (GetUserDefinedEventNumber())
    {
    case GS_EV_ON_BLOCKED:
//................................................................

        break;

    case GS_EV_ON_COMBAT_ROUND_END:
//................................................................

        break;

    case GS_EV_ON_CONVERSATION:
//................................................................
    {
	    // Sadly the code to make NPCs hostile when attacked is hardcoded, 
		// so we have to make this a dialog event not an OnAttacked.
		object oPC       = GetLastSpeaker();
		object oWeapon   = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
		object oCreWpn1  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
		object oCreWpn2  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
		object oCreWpn3  = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
		
		if (! GetIsReactionTypeHostile(oPC, OBJECT_SELF) && !GetIsObjectValid(oWeapon) && !GetIsObjectValid(oCreWpn1) && !GetIsObjectValid(oCreWpn2) && !GetIsObjectValid(oCreWpn3))
		{
		  // Ents don't mind being punched.  
		  int nWood    = GetLocalInt(OBJECT_SELF, "ENT_WOOD_COUNT");
		  int nJuice   = GetLocalInt(OBJECT_SELF, "ENT_JUICE_COUNT");
		  int nTimeout = GetLocalInt(OBJECT_SELF, "ENT_TIMEOUT");
		  
		  if (!nWood && nTimeout < gsTIGetActualTimestamp())
		  {
		    nWood = d20() + 1;		    
		  }
		  
		  if (!nWood)
		  {	    		  
		    FloatingTextStringOnCreature("No more bark or twigs.", oPC);
			break;
		  }
		  else if (!nJuice)
		  {
		    CreateItemOnObject("cnrtwigent", oPC);
			nWood --;
			SetLocalInt(OBJECT_SELF, "ENT_WOOD_COUNT", nWood);
			PlaySound("as_na_branchsnp1");
		  }
		  else
		  {
		    int nCount = d3(1);
			for (nCount; nCount > 0; nCount--) 
			{
		      CreateItemOnObject("cnrbarkent", oPC);
			}  
			nWood --;
			nJuice --;
			SetLocalInt(OBJECT_SELF, "ENT_WOOD_COUNT", nWood);
			SetLocalInt(OBJECT_SELF, "ENT_JUICE_COUNT", nJuice);
			PlaySound("as_na_branchsnp3");			
		  }		
			
		  if (!nWood)
		  {
		    // Set timeout for wood regrowth - 15 RL minutes.
		    SetLocalInt(OBJECT_SELF, "ENT_TIMEOUT", gsTIGetActualTimestamp() + 60 * 15);
		  }  
		}
		else if (d20() == 1 && !GetIsReactionTypeHostile(oPC) && GetLocalInt(OBJECT_SELF, "ENT_GRUMPY"))
		{
		  FloatingTextStringOnCreature("Uh oh.", oPC);
		  SetIsTemporaryEnemy(oPC, OBJECT_SELF, TRUE, 30.0f);
          ClearAllActions();		  
		}
		else if (!GetIsReactionTypeHostile(oPC))
		{
		  FloatingTextStringOnCreature("Break off twigs and bark bare handed, or you anger the ent!", oPC);
		  SetLocalInt(OBJECT_SELF, "ENT_GRUMPY", TRUE);
		  ClearAllActions();
		}

        break;
    }
    case GS_EV_ON_DAMAGED:
//................................................................

        break;

    case GS_EV_ON_DEATH:
//................................................................

        break;

    case GS_EV_ON_DISTURBED:
//................................................................

        break;

    case GS_EV_ON_HEART_BEAT:
//................................................................
        ExecuteScript("gs_run_ai", OBJECT_SELF);
        break;

    case GS_EV_ON_PERCEPTION:
//................................................................

        break;

    case GS_EV_ON_PHYSICAL_ATTACKED:
//................................................................
        break;
		
    case GS_EV_ON_RESTED:
//................................................................

        break;

    case GS_EV_ON_SPAWN:
//................................................................
        SetLocalInt(OBJECT_SELF, "ENT_WOOD_COUNT", d20());
        break;

    case GS_EV_ON_SPELL_CAST_AT:
//................................................................

        break;
    case SEP_EV_ON_NIGHTPOST:
//................................................................
        SetLocalInt(OBJECT_SELF, "sep_run_daynight", SEP_EV_ON_NIGHTPOST);
        ExecuteScript("sep_run_daynight", OBJECT_SELF);

        break;
    case SEP_EV_ON_DAYPOST:
//................................................................
        SetLocalInt(OBJECT_SELF, "sep_run_daynight", SEP_EV_ON_DAYPOST);
        ExecuteScript("sep_run_daynight", OBJECT_SELF);

        break;
case SEP_EV_ON_SECURITY_HEARD:
//................................................................
        break;
case SEP_EV_ON_SECURITY_SPOT:
//................................................................
        break;
case SEP_EV_ON_SECURITY_RESOLVE:
//................................................................
        break;
case SEP_EV_ON_GUARD_ALERT:
//................................................................
        break;
case SEP_EV_ON_GUARD_RESOLVE:
//................................................................
        break;
    }
    RunSpecialBehaviors(GetUserDefinedEventNumber());
}
