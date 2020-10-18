#include "inc_ai"
#include "inc_boss"
#include "inc_common"
#include "inc_encounter"
#include "inc_event"
#include "inc_flag"
#include "inc_time"
#include "inc_weather"

const int GS_TIMEOUT = 7200; //2 hours

void main()
{
    object oSelf = OBJECT_SELF;
    SignalEvent(oSelf, EventUserDefined(GS_EV_ON_SPAWN));
    SetAILevel(oSelf, AI_LEVEL_LOW);

    //set mortality
    if ((GetLocalInt(oSelf, "GS_STATIC") ||
         ! GetLocalInt(GetArea(oSelf), "GS_ENABLED")) &&
        ! (gsENGetIsEncounterCreature() ||
           gsBOGetIsBossCreature()) ||
           GetIsObjectValid(GetMaster(oSelf)))
    {
        SetIsDestroyable(FALSE, TRUE, TRUE);
    }
    else
    {
        gsFLSetFlag(GS_FL_MORTAL);
        SetIsDestroyable(TRUE, TRUE, FALSE);
    }

    // dunshine, check for no loot flag
    if (GetLocalInt(oSelf, "GS_FL_DISABLE_LOOT") == 1) {
      gsFLSetFlag(GS_FL_DISABLE_LOOT);
    }

    //create 0-4 pickpocketables and mark them as non-stacking.
    // Removed INT requirement.
    //if (GetAbilityScore(oSelf, ABILITY_INTELLIGENCE, TRUE) >= 6)
    //{
      int nCount = Random(5);
      int nI     = 0;
      object oItem;
      for (; nI < nCount; nI++)
      {
        oItem = CreateItemOnObject("fb_treasure", oSelf);
        SetLocalInt (oItem, "_NOSTACK", nI);
        SetPickpocketableFlag(oItem, TRUE);
      }
    //}

    //create special items
    int nRacialType = GetRacialType(oSelf);

    switch (nRacialType)
    {
    case RACIAL_TYPE_ABERRATION:
        break;

    case RACIAL_TYPE_ANIMAL:
        switch (GetCreatureSize(oSelf))
        {
        case CREATURE_SIZE_TINY:
        case CREATURE_SIZE_SMALL:
            break;

        case CREATURE_SIZE_MEDIUM:
            SetDroppableFlag(CreateItemOnObject("cnranimalmeat"), TRUE); //meat
            break;

        case CREATURE_SIZE_LARGE:
        case CREATURE_SIZE_HUGE:
            SetDroppableFlag(CreateItemOnObject("cnranimalmeat"), TRUE); //meat
            SetDroppableFlag(CreateItemOnObject("cnranimalmeat"), TRUE); //meat
            break;
        }
        break;

    case RACIAL_TYPE_BEAST:
        break;

    case RACIAL_TYPE_CONSTRUCT:
        break;

    case RACIAL_TYPE_DRAGON:
        if (!GetIsObjectValid(GetItemPossessedBy(oSelf, "nw_it_msmlmisc17")))
          SetDroppableFlag(CreateItemOnObject("nw_it_msmlmisc17"), TRUE); // dr b
        SetDroppableFlag(CreateItemOnObject("dragonhide"), TRUE); //dragon hide
        break;

    case RACIAL_TYPE_DWARF:
        break;

    case RACIAL_TYPE_ELEMENTAL:
        break;

    case RACIAL_TYPE_ELF:
        break;

    case RACIAL_TYPE_FEY:
        break;

    case RACIAL_TYPE_GIANT:
        break;

    case RACIAL_TYPE_GNOME:
        break;

    case RACIAL_TYPE_HALFELF:
        break;

    case RACIAL_TYPE_HALFLING:
        break;

    case RACIAL_TYPE_HALFORC:
        break;

    case RACIAL_TYPE_HUMAN:
        break;

    case RACIAL_TYPE_HUMANOID_GOBLINOID:
        break;

    case RACIAL_TYPE_HUMANOID_MONSTROUS:
        break;

    case RACIAL_TYPE_HUMANOID_ORC:
        break;

    case RACIAL_TYPE_HUMANOID_REPTILIAN:
        break;

    case RACIAL_TYPE_INVALID:
        break;

    case RACIAL_TYPE_MAGICAL_BEAST:
        SetDroppableFlag(CreateItemOnObject("gs_item824"), TRUE); //blood
        break;

    case RACIAL_TYPE_OOZE:
        break;

    case RACIAL_TYPE_OUTSIDER:
        break;

    case RACIAL_TYPE_SHAPECHANGER:
        break;

    case RACIAL_TYPE_UNDEAD:
        break;

    case RACIAL_TYPE_VERMIN:
        break;
    }

	if (GetEventScript(oSelf, EVENT_SCRIPT_CREATURE_ON_DEATH) == "cnr_bird_ondeath")
	{
		// Configured in cnr_source_init
		string sBirdTag = GetTag(oSelf);
		string sFeatherTag = GetLocalString(GetModule(), sBirdTag + "_FeatherTag");
		SetDroppableFlag(CreateItemOnObject(sFeatherTag), TRUE);
	}

    //listen
    SetListenPattern(oSelf, "GS_AI_ATTACK_TARGET",         10000);
    SetListenPattern(oSelf, "GS_AI_REQUEST_REINFORCEMENT", 10003);
    SetListening(oSelf, TRUE);

    //set action matrix
    gsAISetActionMatrix(gsAIGetDefaultActionMatrix());

    SetLocalLocation(oSelf, "GS_LOCATION", GetLocation(oSelf));
    SetLocalInt(oSelf, "GS_TIMEOUT", gsTIGetActualTimestamp() + GS_TIMEOUT);

    // Randomly buff Spot and Listen on some creatures.
    // One creature in 6 will get a buff of between 1 and 40 to Spot and Listen
    // with 1-20 more likely than higher values.
	// Cap the bonus at the challenge rating of the creature to avoid low level 
	// creatures getting silly bonuses.
    if (d6() == 6)
    {
	  int nBonus = d20(d2());
	  int nCR    = FloatToInt(GetChallengeRating(oSelf));
	  if (nBonus > nCR) nBonus = nCR;
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_LISTEN, nBonus), oSelf);
	  
	  nBonus = d20(d2());
	  if (nBonus > nCR) nBonus = nCR;
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_SPOT, nBonus), oSelf);
    }

    // Apply visual effects if required.
    if (GetLocalInt(oSelf, "onspawn_stoneskin"))
    {
      effect eStone = SupernaturalEffect(EffectVisualEffect(VFX_DUR_PROT_STONESKIN));
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStone, oSelf);
    }

    if (GetLocalInt(oSelf, "onspawn_shadow"))
    {
      effect eShadow = SupernaturalEffect(EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR));
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eShadow, oSelf);
    }

    if (GetLocalInt(oSelf, "onspawn_petrification"))
    {
      effect eBark = SupernaturalEffect(EffectVisualEffect(VFX_DUR_PETRIFY));
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBark, oSelf);
    }

    if (GetLocalInt(oSelf, "onspawn_barkskin"))
    {
      effect eBark = SupernaturalEffect(EffectVisualEffect(VFX_DUR_PROT_BARKSKIN));
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBark, oSelf);
    }

    if (GetLocalInt(oSelf, "onspawn_iceskin"))
    {
      effect eIce = SupernaturalEffect(EffectVisualEffect(VFX_DUR_ICESKIN));
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIce, oSelf);
    }

    if (GetLocalInt(oSelf, "onspawn_stealth"))
    {
      SetActionMode(oSelf, ACTION_MODE_STEALTH, TRUE);
    }

    if (GetLocalInt(oSelf, "onspawn_search"))
    {
      SetActionMode(oSelf, ACTION_MODE_DETECT, TRUE);
    }

    if (GetLocalInt(oSelf, "onspawn_lie"))
    {
        AssignCommand(oSelf, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 999000.0));
    }

    if (GetLocalInt(oSelf, "onspawn_vfx"))
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
                              EffectVisualEffect(GetLocalInt(oSelf, "onspawn_vfx")),
                              GetLocation(OBJECT_SELF));
    }

    if (GetLocalInt(oSelf, "onspawn_appear"))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectAppear(), oSelf);
    }
	
    if (GetLocalInt(oSelf, "onspawn_seeinvis"))
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectLinkEffects(
                EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT),
                EffectSeeInvisible()), oSelf);
    }

   //::  Visual Effects OnSpawn
   effect eFX;
   
    if (GetLocalInt(OBJECT_SELF, "AR_FX_GHOST"))                //::  Ghost
    {
        eFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE_NO_SOUND));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
    }

    if (GetLocalInt(OBJECT_SELF, "AR_FX_GHOSTBUSTER"))                //::  Proper Ghost!
    {
        eFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_GHOST_SMOKE_2));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);

        //    VFX_DUR_GHOSTLY_VISAGE_NO_SOUND
        eFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_GLOW_WHITE));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
    }

    if (GetLocalInt(OBJECT_SELF, "AR_FX_SLEEP"))                //::  Sleep
    {
        effect eSleep = SupernaturalEffect(EffectSleep());
        eFX = SupernaturalEffect(EffectVisualEffect(VFX_IMP_SLEEP));

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSleep, OBJECT_SELF);
    }

    if (GetLocalInt(OBJECT_SELF, "AR_FX_AURA_RED"))             //::  Dark Red Aura
    {
        eFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_AURA_RED_DARK));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
    }

    if (GetLocalInt(OBJECT_SELF, "AR_FX_AURA_PURPLE"))         //::  Dark Purple Aura
    {
        eFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_AURA_PULSE_PURPLE_BLACK));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
    }

    if (GetLocalInt(OBJECT_SELF, "AR_FX_AURA_GREEN"))         //::  Green Aura
    {
        eFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_AURA_PULSE_GREEN_BLACK));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
    }


    if (GetLocalInt(OBJECT_SELF, "AR_FX_AURA_BLUE"))         //::  Blue Aura
    {
        eFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_AURA_PULSE_CYAN_BLUE));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
    }

    if (GetLocalInt(OBJECT_SELF, "AR_FX_LIGHT_PURPLE"))         //::  Purple Light
    {
        eFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_LIGHT_PURPLE_5));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
    }

    if (GetLocalInt(OBJECT_SELF, "AR_FX_LIGHT_DARK"))         //::  Grey/Black Pulse Light
    {
        eFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_AURA_PULSE_GREY_BLACK));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
    }


    if (GetLocalInt(OBJECT_SELF, "AR_FX_DJINN"))         //::  Djinn Fire
    {
        eFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_INFERNO_NO_SOUND));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
    }

    if (GetLocalInt(OBJECT_SELF, "AR_VFX_MYCONID"))         //::  Myconid
    {
        eFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_PROT_BARKSKIN));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);

        eFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_PIXIEDUST));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
    }

    if (GetLocalInt(OBJECT_SELF, "AR_FX_STONEHOLD"))         //::  Stonehold
    {
        eFX = SupernaturalEffect(EffectVisualEffect(VFX_DUR_STONEHOLD));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
    }

    if (GetLocalInt(OBJECT_SELF, "AR_AB"))         //::  Attack Bonus
    {
        eFX = SupernaturalEffect(EffectAttackIncrease(GetLocalInt(OBJECT_SELF, "AR_AB")));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
    }

    if (GetLocalInt(OBJECT_SELF, "AR_AC_DEFLECTION"))           //::  AC Deflection
    {
        eFX = SupernaturalEffect( EffectACIncrease(GetLocalInt(OBJECT_SELF, "AR_AC_DEF"), AC_DEFLECTION_BONUS) );
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
    }

    if (GetLocalInt(OBJECT_SELF, "AR_AC_DODGE"))                //::  AC Dodge
    {
        eFX = SupernaturalEffect( EffectACIncrease(GetLocalInt(OBJECT_SELF, "AR_AC_DODGE"), AC_DODGE_BONUS) );
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
    }

    if ( GetLocalInt(OBJECT_SELF, "AR_FX_AOE") ) {
        eFX = EffectAreaOfEffect(GetLocalInt(OBJECT_SELF, "AR_FX_AOE"), "****", "****", "****");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
    }

    if ( GetLocalInt(OBJECT_SELF, "AR_VFX") ) {
        eFX = EffectVisualEffect(GetLocalInt(OBJECT_SELF, "AR_VFX"));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, OBJECT_SELF);
    }
	
	if (GetLocalFloat(OBJECT_SELF, "AR_SCALE") > 0.0f)
	{
	    SetObjectVisualTransform(OBJECT_SELF, OBJECT_VISUAL_TRANSFORM_SCALE, GetLocalFloat(OBJECT_SELF, "AR_SCALE"));
	}
	else if (gsENGetIsEncounterCreature())
	{
	    SetObjectVisualTransform(OBJECT_SELF, OBJECT_VISUAL_TRANSFORM_SCALE, 0.85 + Random(30)/100.0f);
	}

    if ( GetLocalInt(OBJECT_SELF, "AR_BOSS") ) {    //::  Flag as Boss!
        gsFLSetFlag(GS_FL_BOSS, OBJECT_SELF);
    }

    if ( GetLocalString(OBJECT_SELF, "AR_SCRIPT") != "" ) {  //::  Execute Script
        ExecuteScript( GetLocalString(OBJECT_SELF, "AR_SCRIPT"), OBJECT_SELF );
    }	
	
	// Give 10% of monsters a 5% chance of activating truestrike as a lucky hit (see inc_combat). 
	if (!GetLocalInt(OBJECT_SELF, "GVD_TRUESTRIKE") && d10(1) == 10)
	{
	  SetLocalInt(OBJECT_SELF, "GVD_TRUESTRIKE", 5);
	}
	
    // Apply weather effects.
    if (ALLOW_WEATHER) miWHDoWeatherEffects(oSelf);

    // Set up listeners.
    string sPassphrase = GetLocalString(oSelf, "mi_passphrase");
    if (sPassphrase != "")
    {
      SetListenPattern(oSelf, "**(" + sPassphrase + ")**", 166);
      SetListening(oSelf, TRUE);
    }

    // Statue if required.
    if (GetLocalInt(oSelf, "onspawn_freeze"))
    {
      AssignCommand(oSelf, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE, 500.0, 99999999999.0));
      effect eParalyse = SupernaturalEffect(EffectLinkEffects(EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION), EffectCutsceneParalyze()));
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eParalyse, oSelf));
      SetLocalInt(oSelf, "INANIMATE_OBJECT", 1);
    }
    else
    {
      //set random facing
      SetFacing(IntToFloat(Random(360)));
    }
}
