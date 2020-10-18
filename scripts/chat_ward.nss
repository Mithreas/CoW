#include "__server_config"
#include "inc_chatutils"
#include "inc_flag"
#include "inc_text"
#include "inc_customspells"
#include "inc_spell"
#include "inc_worship"
#include "inc_examine"

const string HELP = "If a character has the Epic Spell Focus: Abjuration, they get a bonus spell once per day that allows them to ward their current location. Using -ward activates this spell, which holds multiple enemies in place for one round within a set radius around the caster, unless they pass a will save. This ward lasts for a long time, so it can buy a fleeing caster valuable time. There is also an alternative version: '-ward teleport', which blocks all forms of teleportation within your current area.";

void main()
{
  // Command not valid
  if (!ALLOW_WARDING) return;

  object oSpeaker = OBJECT_SELF;
  string sParams  = chatGetParams(oSpeaker);
  if (sParams == "?")
  {
    DisplayTextInExamineWindow("-ward", HELP);
  }
  else
  {
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, oSpeaker))
    {
      // Ward once per rest
      if(miSPGetCanCastSpell(oSpeaker, CUSTOM_SPELL_WARD))
      {
        miSPHasCastSpell(oSpeaker, CUSTOM_SPELL_WARD);
        miDoCastingAnimation(oSpeaker);
        location lTarget = GetLocation(oSpeaker);

        // Get caster level.
        int nCasterLevel = GetLevelByClass(CLASS_TYPE_WIZARD, oSpeaker) +
                           GetLevelByClass(CLASS_TYPE_SORCERER, oSpeaker) +
                           GetLevelByClass(CLASS_TYPE_CLERIC, oSpeaker) +
						   GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oSpeaker) +
                           GetLevelByClass(CLASS_TYPE_DRUID, oSpeaker) + 2;
        int nDuration = nCasterLevel / 2;
		
		if (GetLevelByClass(CLASS_TYPE_CLERIC, oSpeaker) < 17 &&
                 GetLevelByClass(CLASS_TYPE_DRUID, oSpeaker) < 17)
		{
		    gsSTDoCasterDamage(oSpeaker, 5);
		}

        if ((GetLevelByClass(CLASS_TYPE_CLERIC, oSpeaker) >= 17 ||
             GetLevelByClass(CLASS_TYPE_DRUID, oSpeaker) >= 17)
             && !gsWOAdjustPiety(oSpeaker, -5.0, FALSE))
        {
          string sDeity = GetDeity(oSpeaker);
                FloatingTextStringOnCreature(
                    "You are not pious enough for " + sDeity + " to grant you that spell now.",
                    OBJECT_SELF,
                    FALSE);
        }
        
		if (sParams == "teleport")
        {
          object oForbidding = CreateObject(OBJECT_TYPE_PLACEABLE,
                                            "abjurer_ward",
                                            lTarget,
                                            FALSE,
                                            "scry_protector");
          // Shorten the duration to 1/4 level - 10-15 IG hours is far too long.
          float fDuration = HoursToSeconds(nDuration) / 2.0;
          AssignCommand(GetModule(), DelayCommand(fDuration, DestroyObject(oForbidding)));

          gsFLTemporarilySetAreaFlag("OVERRIDE_TELEPORT", FloatToInt(fDuration), oForbidding, TRUE, "[" + GS_T_16777294 + "]", TRUE);
        }
        else
        {
          int nStatModifier = GetAbilityModifier(ABILITY_WISDOM, oSpeaker);
          if (GetAbilityModifier(ABILITY_INTELLIGENCE, oSpeaker) > nStatModifier)
            nStatModifier = GetAbilityModifier(ABILITY_INTELLIGENCE, oSpeaker);
          if (GetAbilityModifier(ABILITY_CHARISMA, oSpeaker) > nStatModifier)
            nStatModifier = GetAbilityModifier(ABILITY_CHARISMA, oSpeaker);

          int nDC = 10 + 9 + nStatModifier
                       + GetSpellDCModifiers(oSpeaker, SPELL_SCHOOL_ABJURATION);

          object oForbidding = CreateObject(OBJECT_TYPE_PLACEABLE,
                                            "abjurer_ward",
                                            lTarget);
          SetLocalInt(oForbidding, "DC", nDC);
          SetLocalFloat(oForbidding, "Duration", 6.0); // One round.
          SetLocalObject(oForbidding, "Caster", oSpeaker);

          // Glyph of Warding visual effect.
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                              EffectVisualEffect(445),
                              oForbidding,
                              HoursToSeconds(nDuration));

          AssignCommand(GetModule(), DelayCommand(HoursToSeconds(nDuration),
                                          DestroyObject(oForbidding)));
          // Set up AOE. AOE_MOB_CIRCGOOD
          effect eAOE = EffectAreaOfEffect(38, "abjurer_ward_oe", "", "");
          //effect eVis = EffectVisualEffect(VFX_DUR_GLYPH_OF_WARDING);
          //effect eLink = EffectLinkEffects(eAOE, eVis);
          // Cast the spell.
          ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE,
                                         lTarget, HoursToSeconds(nDuration));
        }
      }
      else
      {
        SendMessageToPC(oSpeaker,"<cþ  >You cannot use this ability yet. " +
                                       "It's available once per rest.");
      }
    }
    else
    {
      SendMessageToPC(oSpeaker, "<cþ  >You must have Epic Spell Focus in Abjuration to lay wards.");
    }
  }

  chatVerifyCommand(oSpeaker);
}
