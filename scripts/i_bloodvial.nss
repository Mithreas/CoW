// i_bloodvial
// For use with preserved blood vial, for all your vamp needs
#include "inc_state"

void main()
{
    object oActivator  = GetItemActivator();
	   int nTimesImbibed, nRandom;
	   AssignCommand(oActivator, PlayAnimation(ANIMATION_FIREFORGET_DRINK));

	   if (!VampireIsVamp(oActivator)) {
		      // This isn't a vampire drinking blood.
		      nTimesImbibed = GetLocalInt(oActivator, "BLOOD_IMBIBED_COUNT");
        if (nTimesImbibed < 2) {
			         FloatingTextStringOnCreature("You gulp down the blood and are left with little more than the taste of iron and a queasy feeling.", oActivator, FALSE);
        } else if (nTimesImbibed < 4) {
			         FloatingTextStringOnCreature("The queasy feeling is stronger now, and you get the sense that drinking large quantities of blood is not particularly healthy.", oActivator, FALSE);
			         ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDisease(DISEASE_FILTH_FEVER), oActivator);
        } else if (nTimesImbibed < 8) {
			         FloatingTextStringOnCreature("You are feeling wretched and bloated.  You are starting to see spots.", oActivator, FALSE);
			         ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDisease(DISEASE_FILTH_FEVER), oActivator);
			         ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPoison(POISON_WYVERN_POISON), oActivator);
        } else {
			         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), oActivator);
        }
		      SetLocalInt(oActivator, "BLOOD_IMBIBED_COUNT", nTimesImbibed + 1);
        return;
    }
		  nRandom = d4();
		  if (nRandom == 1)
			     SendMessageToPC(oActivator, "Succulent.  Indulgent.  Rapturous.");
		  else if (nRandom == 2)
			     SendMessageToPC(oActivator, "Veins boil with energy.  You almost feel alive again.  Almost.");
		  else if (nRandom == 3)
			     SendMessageToPC(oActivator, "The pangs of hunger are silent; the reprieve is joyous.");
		  else
			     SendMessageToPC(oActivator, "No godly ambrosia could match this taste; no pleasure can be compared to thirst quenched.");
    gsSTAdjustState(GS_ST_BLOOD, 100.0f, oActivator);
}


