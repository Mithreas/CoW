/* STATE Library by Gigaschatten */
#include "inc_boss"
#include "inc_favsoul"
#include "inc_subrace"
#include "inc_text"
#include "inc_vampire"
#include "inc_weather"
#include "inc_zombie"

//void main() {}

const int GS_ST_FOOD     = 1;
const int GS_ST_WATER    = 2;
const int GS_ST_REST     = 3;
const int GS_ST_SOBRIETY = 4;
const int GS_ST_PIETY    = 5;
const int GS_ST_BLOOD    = 6; // Used only by vampires
const int GS_ST_STAMINA  = 7;

//set initial state of caller
void gsSTSetInitialState(int bReset = FALSE);
//apply state adjustment to caller, hourly call recommended
void gsSTProcessState();
//adjust nState of caller by fValue
//added bDoBonuses flag to prevent stacking of effects during status tick.
void gsSTAdjustState(int nState, float fValue, object oCreature = OBJECT_SELF);
//return nState of oCreature
float gsSTGetState(int nState, object oCreature = OBJECT_SELF);
//animate caller depending on state
void gsSTPlayAnimation();
// Anemoi spell system.  Bonus HP pool management. 
int gsSTGetHPPool(object oCreature);
// Anemoi spell system.  Bonus HP pool management. 
void gsSTAdjustHPPool(object oCreature, int nAdjust);
// Anemoi spell system.  Arcane spells cost 1 HP per caster level. 
void gsSTDoCasterDamage(object oCaster, int nDamage);

void gsSTSetInitialState(int bReset = FALSE)
{
    // Now this is stored persistently so we shouldn't need this method more
    // than once.
    if (bReset || (gsSTGetState(GS_ST_REST) == 0.0 &&
                   gsSTGetState(GS_ST_SOBRIETY) == 0.0 &&
                   gsSTGetState(GS_ST_FOOD) == 0.0 &&
                   gsSTGetState(GS_ST_WATER) == 0.0))
    {
      gsSTAdjustState(GS_ST_REST,      25.0 - gsSTGetState(GS_ST_REST));
      gsSTAdjustState(GS_ST_SOBRIETY, 100.0 - gsSTGetState(GS_ST_SOBRIETY));
      gsSTAdjustState(GS_ST_FOOD,      75.0 - gsSTGetState(GS_ST_FOOD));
      gsSTAdjustState(GS_ST_WATER,     75.0 - gsSTGetState(GS_ST_WATER));
      gsSTAdjustState(GS_ST_STAMINA,   IntToFloat(GetMaxHitPoints(OBJECT_SELF)) - gsSTGetState(GS_ST_STAMINA));
      // NB - do not adjust piety.
	  
	  if ((GetLevelByClass(CLASS_TYPE_CLERIC, OBJECT_SELF) || GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, OBJECT_SELF)) && gsSTGetState(GS_ST_PIETY) == 0.0f)
		gsSTAdjustState(GS_ST_PIETY, 50.0f);
	  
    }
	
    if (VampireIsVamp(OBJECT_SELF))
    {
      if (bReset || gsSTGetState(GS_ST_BLOOD) == 0.0)
      {
        gsSTAdjustState(GS_ST_BLOOD, 75.0 - gsSTGetState(GS_ST_BLOOD));
      }
    }
}
//----------------------------------------------------------------
void gsSTProcessState()
{
    // Skip if we are dead, a zombie, or not fully initialised. 
    if (GetIsDead(OBJECT_SELF) || fbZGetIsZombie(OBJECT_SELF)) return;
	if (!GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CARMOUR, OBJECT_SELF))) return;

    string sSubrace = GetSubRace(OBJECT_SELF);
    int nSubrace    = gsSUGetSubRaceByName(sSubrace);

    // If we've polymorphed, we'll have lost our state.  Reset it.
    gsSTSetInitialState();

    int inSustainArea = GetLocalInt(GetArea(OBJECT_SELF), "TAVERN_SUSTAIN");

    if (!inSustainArea) // Don't decrease stats when in a safe area.
    {
      gsSTAdjustState(GS_ST_FOOD,  (-2.083 * 0.7)); //48 hours (dunshine 30% slower now, so like 64 hours)

      float fWater = -4.166; //24 hours
      int nHumidity = miWHGetHumidity(GetArea(OBJECT_SELF));
      if (nHumidity < 5 && GetIsAreaAboveGround(GetArea(OBJECT_SELF)))
      {
        fWater -= ((5 - nHumidity) * 0.5);
      }
      gsSTAdjustState(GS_ST_WATER, (fWater * 0.7)); //24 hours (dunshine 30% slower now, so like 32 hours)

      // Addition by Mithreas. If someone is sitting or kneeling, make them get
      // tired more slowly..  --[
      if (GetLocation(OBJECT_SELF) == GetLocalLocation(OBJECT_SELF, "MI_SIT_LOCATION"))
      {
        gsSTAdjustState(GS_ST_REST,  -1.0415); //96 hours
      }
      else
      {
        gsSTAdjustState(GS_ST_REST,  -2.083); //48 hours
      }
	  
      // ]-- end addition
    }

    if (VampireIsVamp(OBJECT_SELF))
    {
      float bloodReduction = inSustainArea ? 0.52075 : 1.0415;
      float curBlood = gsSTGetState(GS_ST_BLOOD);

      if (curBlood > 50.0)
      {
        bloodReduction += ((curBlood - 50.0) / 50.0) * 4.0;
      }

      gsSTAdjustState(GS_ST_BLOOD, -bloodReduction);
    }

    gsSTAdjustState(GS_ST_SOBRIETY, IntToFloat(GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION)) / 2.0);
	
	if (!gsCMGetHasClass(CLASS_TYPE_FAVOURED_SOUL)) gsSTAdjustState(GS_ST_PIETY, -0.1); // 2.4% per game day
}
//----------------------------------------------------------------
void gsSTAdjustStateForNPC(int nState, float fValue, object oCreature = OBJECT_SELF)
{
  // Only care about stamina right now.
  if (nState != GS_ST_STAMINA) return;
  
  float fState = GetLocalFloat(oCreature, "GS_ST_" + IntToString(nState));
  
  int nMaxHP = GetMaxHitPoints(oCreature);
  if (nMaxHP > 100) nMaxHP = 100;
    
  if (gsBOGetIsBossCreature(oCreature)) nMaxHP *= 4;
  
  fState += fValue;
  
    if (fState < -1.0f * IntToFloat(nMaxHP))
    {
		// Avoid this section firing more than once per creature.
		if (!GetLocalInt(oCreature, "DEAD"))
		{
			AssignCommand(oCreature, SpeakString(" *Collapses, drained of vitality* "));

			// Make death supernatural since EffectDeath() will fail on creatures that are death-immune. 
			ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oCreature);
			SetLocalInt(oCreature, "DEAD", TRUE);
			return;
		}
    }
    else if (fState < 0.0)
    {
		// Reduce physical stats by 1 each time a creature is stamina drained below 0.
		object oCreator    = GetLocalObject(GetModule(), "GS_ST_CREATOR");
		if (! GetIsObjectValid(oCreator)) return;
        
        AssignCommand(oCreator, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_STRENGTH, 1)), oCreature));
        AssignCommand(oCreator, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_DEXTERITY, 1)), oCreature));
        AssignCommand(oCreator, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_CONSTITUTION, 1)), oCreature));
		
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oCreature);
	}  
	
	SetLocalFloat(oCreature, "GS_ST_" + IntToString(nState), fState);
  
}
//----------------------------------------------------------------
void gsSTAdjustState(int nState, float fValue, object oCreature = OBJECT_SELF)
{
    // Comment - not sure why we leave this when it's zero.
    if (fValue == 0.0 || fbZGetIsZombie(oCreature)) return;
	
	if (!GetIsPC(oCreature))
	{
	  gsSTAdjustStateForNPC(nState, fValue, oCreature);
	  return;
	}

    // Immortals don't need food or water.
    int isMortal = gsSUGetIsMortal(gsSUGetSubRaceByName(GetSubRace(oCreature)));
    if (!isMortal && (nState == GS_ST_FOOD || nState == GS_ST_WATER)) return;

    string sState   = "";
    string sMessage = "";

    switch (nState)
    {
    case GS_ST_FOOD:
        sState   = "GS_ST_FOOD";
        sMessage = GS_T_16777299;
        break;

    case GS_ST_WATER:
        sState   = "GS_ST_WATER";
        sMessage = GS_T_16777300;
        break;

    case GS_ST_REST:
        sState   = "GS_ST_REST";
        sMessage = GS_T_16777301;
        break;

    case GS_ST_SOBRIETY:
        sState   = "GS_ST_SOBRIETY";
        sMessage = GS_T_16777302;
        break;

    case GS_ST_PIETY:
	    if (gsCMGetHasClass(CLASS_TYPE_FAVOURED_SOUL, oCreature) && fValue > 0.0f) fValue *= 2;
        sState = "GS_ST_PIETY";
        sMessage = GS_T_16777592;
        break;

    case GS_ST_BLOOD:
        sState = "GS_ST_BLOOD";
        sMessage = "Blood";
        break;

    case GS_ST_STAMINA:
        sState = "GS_ST_STAMINA";
        sMessage = "Stamina";
        break;

    default:
        return;
    }

    //adjustment	
    object oHide = gsPCGetCreatureHide(oCreature);
	
    float fState    = GetLocalFloat(oHide, sState);
    float fStateOld = fState;
    float fStateNew = fState + fValue;

    if (fStateNew < -100.0)     fStateNew = -100.0;
    else if (fStateNew > 100.0) fStateNew =  100.0;

    SetLocalFloat(oHide, sState, fStateNew);

    if (fStateNew == fState)    return;

    if (nState == GS_ST_BLOOD)
    {
        VampireApplyBloodChange(oCreature, fStateOld, fStateNew);
    }

    //message
    sMessage += ": ";
    if (fValue > 0.0) sMessage += "<cªÕþ>+";
    else              sMessage += "<cþ((>";
    sMessage += FloatToString(fValue,    0, 1) + "% (" +
                FloatToString(fStateNew, 0, 1) + "%)";
	
    //effect
    if (GetIsDead(oCreature))
	{
	  SendMessageToPC(oCreature, sMessage);
	  return;
	}
	
    object oCreator    = GetLocalObject(GetModule(), "GS_ST_CREATOR");
    if (! GetIsObjectValid(oCreator)) return;
    object oSelf       = oCreature;
    float fConDecrease = 0.0;
    float fDexDecrease = 0.0;
    float fStrDecrease = 0.0;
    float fStrIncrease = 0.0;
	int   nSpFailure   = 0;

    //food
    fState = gsSTGetState(GS_ST_FOOD);

    if (fState == -100.0)
    {
        FloatingTextStringOnCreature(GS_T_16777303, oCreature, FALSE);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), oCreature);
        return;
    }
    else if (fState < 0.0)
    {
        if (nState == GS_ST_FOOD)
            FloatingTextStringOnCreature(GS_T_16777304, oCreature, FALSE);

        fValue        = fabs(fState) / 10.0;
        fConDecrease += fValue;
        fDexDecrease += fValue;
        fStrDecrease += fValue;
    }
    else if (fState < 15.0)
    {
        if (nState == GS_ST_FOOD)
            FloatingTextStringOnCreature(GS_T_16777305, oCreature, FALSE);
    }

    //water
    fState = gsSTGetState(GS_ST_WATER);

    if (fState == -100.0)
    {
        FloatingTextStringOnCreature(GS_T_16777306, oCreature, FALSE);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), oCreature);
        return;
    }
    else if (fState < 0.0)
    {
        if (nState == GS_ST_WATER)
            FloatingTextStringOnCreature(GS_T_16777307, oCreature, FALSE);

        fValue        = fabs(fState) / 10.0;
        fConDecrease += fValue;
        fDexDecrease += fValue;
        fStrDecrease += fValue;
    }
    else if (fState < 15.0)
    {
        if (nState == GS_ST_WATER)
            FloatingTextStringOnCreature(GS_T_16777308, oCreature, FALSE);
    }

    //rest
    fState = gsSTGetState(GS_ST_REST);

    if (fState == -100.0)
    {
        FloatingTextStringOnCreature(GS_T_16777309, oCreature, FALSE);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), oCreature);
        return;
    }
    else if (fState < 0.0)
    {
        if (nState == GS_ST_REST)
        {
            FloatingTextStringOnCreature(GS_T_16777310, oCreature, FALSE);
        }

        fValue        = fabs(fState) / 10.0;
        fConDecrease += fValue;
        fDexDecrease += fValue;
        fStrDecrease += fValue;
		nSpFailure   += FloatToInt(fabs(fState));
    }
    else if (fState < 15.0)
    {
        if (nState == GS_ST_REST)
        {
            FloatingTextStringOnCreature(GS_T_16777311, oCreature, FALSE);
            SetPanelButtonFlash(oCreature, PANEL_BUTTON_REST, TRUE);
        }
    }
    else SetPanelButtonFlash(oCreature, PANEL_BUTTON_REST, FALSE);

    //sobriety
    fState = gsSTGetState(GS_ST_SOBRIETY);

    if (fState == -100.0)
    {
        FloatingTextStringOnCreature(GS_T_16777312, oCreature, FALSE);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), oCreature);
        return;
    }
    else if (fState < 0.0)
    {
        if (nState == GS_ST_SOBRIETY)
            FloatingTextStringOnCreature(GS_T_16777313, oCreature, FALSE);

        fValue        = fabs(fState) / 10.0;
        fDexDecrease += fValue;
        if (GetLevelByClass(CLASS_TYPE_BARBARIAN) > 0)
        {
          fStrIncrease = 1.0;
        }
    }

    //piety
    fState = gsSTGetState(GS_ST_PIETY);

    if (fState < 0.0)
    {
      if (nState == GS_ST_PIETY)
        FloatingTextStringOnCreature(GS_T_16777593, oCreature, FALSE);
    }

    //stamina
    fState = gsSTGetState(GS_ST_STAMINA);

	if (fState == -100.0)
    {
        FloatingTextStringOnCreature(GS_T_16777309, oCreature, FALSE);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), oCreature);
        return;
    }
    else if (fState < 0.0)
    {
        fValue        = fabs(fState) / 10.0;
        fConDecrease += fValue;
        fDexDecrease += fValue;
        fStrDecrease += fValue;
		nSpFailure   += FloatToInt(fabs(fState));
    }
	else if (fState > IntToFloat(GetMaxHitPoints(OBJECT_SELF)))
	{
      SetLocalFloat(oHide, "GS_ST_STAMINA", IntToFloat(GetMaxHitPoints(OBJECT_SELF)));
      fStateNew = IntToFloat(GetMaxHitPoints(OBJECT_SELF));
	}
	
    if (fStateNew != fStateOld) SendMessageToPC(oCreature, sMessage);
	
    //limit penalty
    if (fConDecrease > 10.0) fConDecrease = 10.0;
    if (fDexDecrease > 10.0) fDexDecrease = 10.0;
    if (fStrDecrease > 10.0) fStrDecrease = 10.0;
	if (nSpFailure > 100) nSpFailure = 100;

    //remove effect
    effect eEffect = GetFirstEffect(oCreature);

    while (GetIsEffectValid(eEffect))
    {
        if (GetEffectCreator(eEffect) == oCreator)
            RemoveEffect(oCreature, eEffect);

        eEffect = GetNextEffect(oCreature);
    }

    //apply effect
    if (fConDecrease != 0.0)
        AssignCommand(
            oCreator,
            ApplyEffectToObject(
                DURATION_TYPE_PERMANENT,
                ExtraordinaryEffect(
                    EffectAbilityDecrease(ABILITY_CONSTITUTION,
                                          FloatToInt(fConDecrease))),
                oSelf));

    if (fDexDecrease != 0.0)
        AssignCommand(
            oCreator,
            ApplyEffectToObject(
                DURATION_TYPE_PERMANENT,
                ExtraordinaryEffect(
                    EffectAbilityDecrease(ABILITY_DEXTERITY,
                                          FloatToInt(fDexDecrease))),
                oSelf));

    if (fStrDecrease != 0.0)
        AssignCommand(
            oCreator,
            ApplyEffectToObject(
                DURATION_TYPE_PERMANENT,
                ExtraordinaryEffect(
                    EffectAbilityDecrease(ABILITY_STRENGTH,
                                          FloatToInt(fStrDecrease))),
                oSelf));

    if (nSpFailure)
        AssignCommand(
            oCreator,
            ApplyEffectToObject(
                DURATION_TYPE_PERMANENT,
                ExtraordinaryEffect(
                    EffectSpellFailure(nSpFailure)),
                oSelf));

    if (fStrIncrease != 0.0)
        AssignCommand(
            oCreator,
            ApplyEffectToObject(
                DURATION_TYPE_PERMANENT,
                ExtraordinaryEffect(
                    EffectAbilityIncrease(ABILITY_STRENGTH,
                                          FloatToInt(fStrIncrease))),
                oSelf));
}
//----------------------------------------------------------------
float gsSTGetState(int nState, object oCreature = OBJECT_SELF)
{
    object oHide = gsPCGetCreatureHide(oCreature);
    switch (nState)
    {
    case GS_ST_FOOD:     return GetLocalFloat(oHide, "GS_ST_FOOD");
    case GS_ST_WATER:    return GetLocalFloat(oHide, "GS_ST_WATER");
    case GS_ST_REST:     return GetLocalFloat(oHide, "GS_ST_REST");
    case GS_ST_SOBRIETY: return GetLocalFloat(oHide, "GS_ST_SOBRIETY");
    case GS_ST_PIETY:    return GetLocalFloat(oHide, "GS_ST_PIETY");
    case GS_ST_BLOOD:    return GetLocalFloat(oHide, "GS_ST_BLOOD");
    case GS_ST_STAMINA:  return GetLocalFloat(oHide, "GS_ST_STAMINA");
    }

    return 0.0;
}
//----------------------------------------------------------------
void gsSTPlayAnimation()
{
    if (GetIsDead(OBJECT_SELF) || fbZGetIsZombie(OBJECT_SELF)) return;
    if (IsInConversation(OBJECT_SELF)) return;
    int nAction   = GetCurrentAction();
    if (nAction == ACTION_REST)        return;
    float fRandom = IntToFloat(Random(100) - 99);

    // Addition by Mithreas. If someone is already sitting or kneeling, don't
    // make them stand up.  --[
    if (GetLocation(OBJECT_SELF) == GetLocalLocation(OBJECT_SELF, "MI_SIT_LOCATION"))
      return;
    // ]-- End edit.
    if (fRandom < -50.0)
    {
        if (fRandom > gsSTGetState(GS_ST_FOOD)  ||
            fRandom > gsSTGetState(GS_ST_WATER) ||
            fRandom > gsSTGetState(GS_ST_REST)  ||
            fRandom > gsSTGetState(GS_ST_SOBRIETY) ||
            fRandom > gsSTGetState(GS_ST_STAMINA))
        {
            ClearAllActions();
            ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,    1.0, 3600.0);
        }
    }
    else if (nAction != ACTION_SIT)
    {
        if (fRandom > gsSTGetState(GS_ST_SOBRIETY))
        {
            ClearAllActions();
            PlayVoiceChat(VOICE_CHAT_LAUGH);
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0,    2.0);
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,   1.0, 3598.0);
        }
        else if (fRandom > gsSTGetState(GS_ST_FOOD)  ||
                 fRandom > gsSTGetState(GS_ST_WATER) ||
                 fRandom > gsSTGetState(GS_ST_REST) ||
                 fRandom > gsSTGetState(GS_ST_STAMINA))
        {
            ClearAllActions();
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED,   1.0, 3600.0);
        }
        else if (VampireIsVamp(OBJECT_SELF) && fRandom > gsSTGetState(GS_ST_BLOOD))
        {
            ClearAllActions();
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED,   1.0, 3600.0);
        }
    }
}
//----------------------------------------------------------------
int gsSTGetHPPool(object oCreature)
{
  // NPCs
  if (GetLocalInt(oCreature, "HP_POOL")) return GetLocalInt(oCreature, "HP_POOL");

  object oHide = gsPCGetCreatureHide(oCreature);
  
  if (GetIsObjectValid(oHide)) return GetLocalInt(oHide, "HP_POOL");
  
  return 0;
}
//----------------------------------------------------------------
void gsSTAdjustHPPool(object oCreature, int nAdjust)
{
  if (nAdjust == 0) return;

  if (GetLocalInt(oCreature, "HP_POOL")) SetLocalInt(oCreature, "HP_POOL", GetLocalInt(oCreature, "HP_POOL") + nAdjust);
  
  object oHide = gsPCGetCreatureHide(oCreature);
  
  if (GetIsObjectValid(oHide)) 
  {  
    SetLocalInt(oHide, "HP_POOL", GetLocalInt(oHide, "HP_POOL") + nAdjust);
  
    string sMessage = "Stamina pool: ";
    if (nAdjust > 0) sMessage += "<cªÕþ>+";
    else             sMessage += "<cþ((>";
    sMessage += IntToString(nAdjust) + ".0 (" + IntToString(GetLocalInt(oHide, "HP_POOL")) + ".0)";
  
    SendMessageToPC(oCreature, sMessage);
  }
}
//----------------------------------------------------------------
void gsSTDoCasterDamage(object oCaster, int nDamage)
{
  if (!GetIsPC(oCaster)) return;

  int nHPPool  = gsSTGetHPPool(oCaster);
  float fStamina = gsSTGetState(GS_ST_STAMINA, oCaster);
  float fDamage = IntToFloat(nDamage);
  int nFighter = GetLevelByClass(CLASS_TYPE_FIGHTER, oCaster);
  
  int nTax = GetLocalInt(oCaster, "ST_STAM_TAX");
  if (nTax) fDamage *= (1.0f + IntToFloat(nTax)/100);
  
  fDamage *= (1 - 0.05 * nFighter);
    
  if (nHPPool && (fStamina - fDamage < 10.0f))
  {
    if (FloatToInt(fDamage) > nHPPool)
	{
	  fDamage -= IntToFloat(nHPPool);
	  gsSTAdjustHPPool(oCaster, -nHPPool);
	}
	else
	{
	  gsSTAdjustHPPool(oCaster, -FloatToInt(fDamage));
	  fDamage = 0.0f;
	}
  }
  
  if (fDamage > 0.0f)
  {
      gsSTAdjustState(GS_ST_STAMINA, -fDamage, oCaster);
  }
}
//----------------------------------------------------------------
void gsSTDoStaminaTax(object oTarget, int nPenalty, float fDuration)
{
  int nCurrentPenalty = GetLocalInt(oTarget, "ST_STAM_TAX");
  nCurrentPenalty += nPenalty;
  SetLocalInt(oTarget, "ST_STAM_TAX", nCurrentPenalty);
  
  if (fDuration > 0.0f) DelayCommand(fDuration, gsSTDoStaminaTax(oTarget, -nPenalty, 0.0f));
}
