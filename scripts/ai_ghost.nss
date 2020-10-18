#include "inc_event"
#include "inc_behaviors"
#include "inc_xp"

// Set one of the following ints as the CHALLENGE variable on this NPC.
const int CHALLENGE_NONE      = 0;
const int CHALLENGE_STRENGTH  = 1;
const int CHALLENGE_DEXTERITY = 2;
const int CHALLENGE_FORTITUDE = 3;
const int CHALLENGE_REFLEX    = 4;
const int CHALLENGE_WILL      = 5;
const int CHALLENGE_LORE      = 6;
const int CHALLENGE_BLUFF     = 7;
const int CHALLENGE_PERFORM   = 8;

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
	{
//................................................................
	    if (GetIsInCombat()) return;
		
		// Only fire for PCs
	    object oPC = GetLastSpeaker();
		if (!GetIsPC(oPC)) return;
		
		// Each NPC only gets challenged once. 
		if (GetLocalInt(OBJECT_SELF, "CHALLENGED")) return;
		SetLocalInt(OBJECT_SELF, "CHALLENGED", TRUE);
		
		int nChallenge = GetLocalInt(OBJECT_SELF, "CHALLENGE");
		int bSuccess = 0;
		string sContest = "";
		
		switch(nChallenge)
		{
		  case 0:
		    return; // No challenge configured
		  case 1: // Strength - arm wrestle
		  {
            sContest = "wrestling";		  
		    bSuccess = (d20() + GetAbilityModifier(ABILITY_STRENGTH, oPC)) > (d20() + GetAbilityModifier(ABILITY_STRENGTH, OBJECT_SELF));
			// Play animations
			AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT));
			AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT));
			break;
		  }
		  case 2: // Dex - dance
		  {
		    sContest = "dance";
		    bSuccess = (d20() + GetAbilityModifier(ABILITY_DEXTERITY, oPC)) > (d20() + GetAbilityModifier(ABILITY_DEXTERITY, OBJECT_SELF));
			// Play animations
			AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM, 0.5));
			AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM, 0.5));
			break;
		  }
		  case 3: // Fortitude - drinking
		  {
		    sContest = "drinking";
		    bSuccess = (d20() + GetFortitudeSavingThrow(oPC)) > (d20() + GetFortitudeSavingThrow(OBJECT_SELF));
			// Play animations
			AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
			AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
			AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
			AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
			AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
			AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
			break;
		  }
		  case 4: // Reflex - knucklebones
		  {
		    sContest = "knucklebones";
		    bSuccess = (d20() + GetReflexSavingThrow(oPC)) > (d20() + GetReflexSavingThrow(OBJECT_SELF));
			// Play animations
			AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_STEAL, 0.8));
			AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_FIREFORGET_STEAL, 0.8));
			break;
		  }
		  case 5: // Will - staring
		  {
		    sContest = "staring";
		    bSuccess = (d20() + GetWillSavingThrow(oPC)) > (d20() + GetWillSavingThrow(OBJECT_SELF));
			// Play animations
			if (!bSuccess) AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT));
			else AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT));
			break;
		  }
		  case 6: // Lore - riddle
		  {
		    sContest = "riddle";
		    bSuccess = (d20() + GetSkillRank(SKILL_LORE, oPC)) > (d20() + GetSkillRank(SKILL_LORE, OBJECT_SELF));
			// Play animations
			AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED));
			DelayCommand(1.0, AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED)));
			break;
		  }
		  case 7: // Bluff - storytelling
		  {
		    sContest = "storytelling";
		    bSuccess = (d20() + GetSkillRank(SKILL_BLUFF, oPC)) > (d20() + GetSkillRank(SKILL_BLUFF, OBJECT_SELF));
			// Play animations
			AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1));
			DelayCommand(2.0, AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1)));
			break;
		  }
		  case 8: // Perform - singing
		  {
		    sContest = "singing";
		    bSuccess = (d20() + GetSkillRank(SKILL_PERFORM, oPC)) > (d20() + GetSkillRank(SKILL_PERFORM, OBJECT_SELF));
			// Play animations
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BARD_SONG), oPC, 2.0f);
			DelayCommand(2.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_BARD_SONG), OBJECT_SELF, 2.0f));
			break;
		  }
		}

        FloatingTextStringOnCreature(GetName(OBJECT_SELF) + " has challenged you to a " + sContest + " contest!", oPC, FALSE);
		DelayCommand(4.0f, FloatingTextStringOnCreature("And the winner is... " + (bSuccess ? GetName(oPC) : GetName(OBJECT_SELF)) + "!", oPC, FALSE));
		DelayCommand(4.0f, gsXPGiveExperience(oPC, (bSuccess ? 5 : -5)));
        DelayCommand(6.0f, DestroyObject(OBJECT_SELF));

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
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE_NO_SOUND)), OBJECT_SELF);
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
