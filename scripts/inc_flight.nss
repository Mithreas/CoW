/**
 * mi_inc_flight
 *
 * Flight library.  Allows flying creatures that are large enough to 
 * port to a 'flight map' allowing quick travel.  Very large fliers 
 * can carry their party with them.
 *
 * Setup requires an area of the module to be the flight map, and variables
 * on outside areas with the destination flight waypoint tag 
 * (MI_FL_DEST).  It's expected that groups of areas (like Arelith Forest)
 * will share a single flight waypoint.
 *
 * Possible future extensions - allow fliers to list creatures in the areas
 * below them.
 */
 
#include "inc_pc"
 
// Returns 1(TRUE) if the creature can fly, and 2 if it can carry others.
int miFLGetCanFly(object oCreature);

// Ports the flier (and their party if bParty is TRUE) to the local flight WP.
// Adjusts appearances etc as appropriate.
void miFLStartFlight(object oCreature, int bParty = FALSE);

// Ports the flier back from the flight map to the specified WP.  If their
// party is with them, they'll get ported back too.
void miFLFinishFlight(object oCreature, string sTargetWaypoint);

// Internal method to set the correct appearance for the flier (and his party
// members, who will become invisible).  Also sets ghost mode so that the 
// party cram together.
void miFLSetFlightAppearance(object oCreature, int bPrimaryFlier=TRUE);

// Internal method to undo the effects of miFLSetFlightAppearance.
void miFLRemoveFlightAppearance(object oCreature);

void miFLSetFlightAppearance(object oCreature, int bPrimaryFlier=TRUE)
{
  if (!bPrimaryFlier)
  {
    // Turn invisible and apply cutscene ghost to allow closer following.
	effect eInvis = EffectLinkEffects(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), 
	                                  EffectCutsceneGhost());
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInvis, oCreature);
	return;
  }
  
  // Set the creature to 10% size.  Which 10% size model to use depends on whether the model
  // is Simple, Large or Dragon.
  int nAppearance = GetAppearanceType(oCreature);
  int nTailType = GetCreatureTailType(oCreature);
  int nNewAppearance = 0;
  int nNewTailType = 0;
  
  // Save off old appearance values for later.  Just in case this somehow gets called twice, 
  // never change the value.  Note that all PCs have the 'invisible horse' tail applied
  // as standard (unless they have a totem appearance etc), so no PCs should have a tail type 
  // of none.
  object oHide = gsPCGetCreatureHide(oCreature);
  if (!GetLocalInt(oHide, "MI_FL_DEFAULT_APPEARANCE")) 
    SetLocalInt(oHide, "MI_FL_DEFAULT_APPEARANCE", nAppearance);
  if (!GetLocalInt(oHide, "MI_FL_DEFAULT_TAIL")) 
    SetLocalInt(oHide, "MI_FL_DEFAULT_TAIL", nTailType);
  
  if (nAppearance > 828 && nAppearance < 849)
  {
    nNewAppearance = 829; // 10% Simple
	nNewTailType = nTailType;
  }
  else if (nAppearance > 848 && nAppearance < 869)
  {
    nNewAppearance = 849; // 10% Large
	nNewTailType = nTailType;
  }
  else if (nAppearance > 568 && nAppearance < 589)
  {
    nNewAppearance = 569; // 10% Dragon
	nNewTailType = nTailType;
  }
  else
  {
    switch (nAppearance)
    { 
      case APPEARANCE_TYPE_BALOR:
        nNewAppearance = 849; // 10% Large
	    nNewTailType = 287;
		break;
	  case APPEARANCE_TYPE_DEVIL:
        nNewAppearance = 849; // 10% Large
	    nNewTailType = 288;
		break;
	  
	  case APPEARANCE_TYPE_ELEMENTAL_AIR:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 339;
		break;
	  case APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER:	 
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 340;
		break; 
	  case APPEARANCE_TYPE_FALCON:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 378;
		break;
	  case APPEARANCE_TYPE_GARGOYLE:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 420;
		break;
	  case APPEARANCE_TYPE_HARPY:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 429;
		break;
	  case APPEARANCE_TYPE_MEPHISTO_BIG:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 433;
		break;
	  case APPEARANCE_TYPE_MEPHISTO_NORM:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 433;
		break;
	  case APPEARANCE_TYPE_PARROT:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 376;
		break;
	  case APPEARANCE_TYPE_RAVEN:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 380;
		break;
	  case APPEARANCE_TYPE_SEAGULL_FLYING:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 381;
		break;
	  case APPEARANCE_TYPE_SEAGULL_WALKING:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 381;
		break;
	  case APPEARANCE_TYPE_MANTICORE:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 426;
		break;
	  case APPEARANCE_TYPE_GYNOSPHINX:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 425;
		break;
	  case APPEARANCE_TYPE_SPHINX:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 427;
		break;
	  case 455: // wyverns
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 457;
		break;
	  case 456:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 457;
		break;
	  case 457:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 457;
		break;
	  case 458:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 457;
		break;
	  
	  case APPEARANCE_TYPE_DRACOLICH:
        nNewAppearance = 569; // 10% Dragon
	    nNewTailType = 321;
		break;
	  case APPEARANCE_TYPE_DRAGON_BLACK:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 454;
		break;
	  case APPEARANCE_TYPE_DRAGON_BLUE:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 455;
		break;
	  case APPEARANCE_TYPE_DRAGON_BRASS:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 456;
		break;
	  case APPEARANCE_TYPE_DRAGON_BRONZE:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 457;
		break;
	  case APPEARANCE_TYPE_DRAGON_COPPER:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 458;
		break;
	  case APPEARANCE_TYPE_DRAGON_GOLD:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 459;
		break;
	  case APPEARANCE_TYPE_DRAGON_GREEN:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 460;
		break;
	  case APPEARANCE_TYPE_DRAGON_PRIS:
        nNewAppearance = 330; // 10% Dragon
	    nNewTailType = nTailType;
		break;
	  case APPEARANCE_TYPE_DRAGON_RED:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 461;
		break;
	  case APPEARANCE_TYPE_DRAGON_SHADOW:
        nNewAppearance = 569; // 10% Dragon
	    nNewTailType = 332;
		break;
	  case APPEARANCE_TYPE_DRAGON_SILVER:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 462;
		break;
	  case APPEARANCE_TYPE_DRAGON_WHITE:
        nNewAppearance = 829; // 10% Simple
	    nNewTailType = 463;
		break;
    
    } 
  }
  
  if (nNewAppearance) SetCreatureAppearanceType(oCreature, nNewAppearance);
  if (nNewTailType)  SetCreatureTailType(nNewTailType, oCreature);

  ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oCreature); 
}


void miFLRemoveFlightAppearance(object oCreature)
{
  effect eEffect = GetFirstEffect(oCreature);
  
  while (GetIsEffectValid(eEffect))
  {
	if (GetEffectDurationType(eEffect) == DURATION_TYPE_PERMANENT &&
	    GetEffectType(eEffect) == EFFECT_TYPE_VISUALEFFECT)
      RemoveEffect(oCreature, eEffect);
  }
  
  // Reset appearance.
  object oHide = gsPCGetCreatureHide(oCreature);
  if (GetLocalInt(oHide, "MI_FL_DEFAULT_APPEARANCE")) 
  {
    SetCreatureAppearanceType(oCreature, GetLocalInt(oHide, "MI_FL_DEFAULT_APPEARANCE"));
    DeleteLocalInt(oHide, "MI_FL_DEFAULT_APPEARANCE");
    SetCreatureTailType(GetLocalInt(oHide, "MI_FL_DEFAULT_TAIL"), oCreature);
	DeleteLocalInt(oHide, "MI_FL_DEFAULT_TAIL");
  }
}

int miFLGetCanFly(object oCreature)
{
  int nAppearance = GetAppearanceType(oCreature);
  
  // Regular appearances.
  switch(nAppearance)
  {
    case APPEARANCE_TYPE_BALOR:
	case APPEARANCE_TYPE_DEVIL:
	case APPEARANCE_TYPE_ELEMENTAL_AIR:
	case APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER:
	case APPEARANCE_TYPE_FALCON:
	case APPEARANCE_TYPE_GARGOYLE:
	case APPEARANCE_TYPE_HARPY:
	case APPEARANCE_TYPE_MEPHISTO_BIG:
	case APPEARANCE_TYPE_MEPHISTO_NORM:
	case APPEARANCE_TYPE_PARROT:
	case APPEARANCE_TYPE_RAVEN:
	case APPEARANCE_TYPE_SEAGULL_FLYING:
	case APPEARANCE_TYPE_SEAGULL_WALKING:
	  return 1;
	  break;
	case APPEARANCE_TYPE_DRACOLICH:
	case APPEARANCE_TYPE_DRAGON_BLACK:
	case APPEARANCE_TYPE_DRAGON_BLUE:
	case APPEARANCE_TYPE_DRAGON_BRASS:
	case APPEARANCE_TYPE_DRAGON_BRONZE:
	case APPEARANCE_TYPE_DRAGON_COPPER:
	case APPEARANCE_TYPE_DRAGON_GOLD:
	case APPEARANCE_TYPE_DRAGON_GREEN:
	case APPEARANCE_TYPE_DRAGON_PRIS:
	case APPEARANCE_TYPE_DRAGON_RED:
	case APPEARANCE_TYPE_DRAGON_SHADOW:
	case APPEARANCE_TYPE_DRAGON_SILVER:
	case APPEARANCE_TYPE_DRAGON_WHITE:
	case APPEARANCE_TYPE_MANTICORE:
	case APPEARANCE_TYPE_GYNOSPHINX:
	case APPEARANCE_TYPE_SPHINX:
	case 455: // wyverns
	case 456:
	case 457:
	case 458:
	  return 2;
	  break;  
  }
  
  // Totem appearances.
  if ((nAppearance > 568 && nAppearance < 589) ||
      (nAppearance > 828 && nAppearance < 869))
  {
    int nTailType = GetCreatureTailType(oCreature);
	
	switch (nTailType)
	{
	  case 287: // balor
	  case 288: // devil (pit fiend)
	  case 339: // air elemental
	  case 340: // elder air elemental
	  case 376: // parrot
	  case 378: // falcon
	  case 380: // raven
	  case 381: // seagull a
	  case 382: // seagull b
	  case 420: // gargoyle
	  case 429: // harpy
	    return 1;
		break;
	  case 321: // dragons
	  case 322: // dragons
	  case 323: // dragons
	  case 324: // dragons
	  case 325: // dragons
	  case 326: // dragons
	  case 327: // dragons
	  case 328: // dragons
	  case 329: // dragons
	  case 330: // dragons
	  case 331: // dragons
	  case 332: // dragons
	  case 333: // dragons
	  case 334: // dragons
	  case 425: // gynosphinx
	  case 426: // manticore
	  case 427: // sphinx
	  case 487: // wyverns
	  case 488: // wyverns
	  case 489: // wyverns
	  case 490: // wyverns
	    return 2;
		break;
	}
  }
  
  return FALSE;
}


void miFLStartFlight(object oCreature, int bParty = FALSE)
{
}


void miFLFinishFlight(object oCreature, string sTargetWaypoint)
{
}