/* Library for shapechanger racial functions. 
 * Developer notes:

- Award locked
- Achievement locked (new thing - basically find it in game to be able to play it.  Half elf will be similar)
- Select it as an award choice with the base race of your choice.  This will open up a new menu option to pick what sort of werecreature you are (rat, cat, wolf to start). 
- Start location by base race.  TBD whether a starting faction is allowed (currently no way IG to join Wardens, Fernvale - could fix that)
- All shapechangers get a hybrid form feat.  This changes their base race to Shapechanger at the cost of modest amounts of piety and stamina.  Initially it just uses the NWN hybrid forms probably with totem like scaling but ideally I'd like to open up new appearance options (need to figure out heads etc. here based on werecreature type). 
- Characters in Shapechanger form do not claim resource areas; instead they sabotage them (0 resource production for the owner until someone from the faction clicks the sign again to "repair").  Sabotage can be done even if a resource area is guarded, but has no benefit to the saboteur.
- Shapechangers who take the Shifter race have dramatically cheaper Stamina costs for forms but also have a small piety cost.
- Shapechangers gain Piety whenever someone uses a shapechange ability near them (Shifter feats, Shapechanger racial ability, Shapechange and Polymorph Self spells, druid shapechange feats).  (A group of shifters changing together will earn back more piety than they spend on the shift).
- Shapechangers gain XP from consecrating altars and gain significant XP the first time each other character converts to their deity.  However, they gain no XP from faction quests.
 
 *
 */
#include "inc_common"
#include "inc_effect"
#include "inc_pc"
#include "inc_time"
#include "inc_worship"
#include "inc_xp"
 
const int SPC_NONE    = 0;
const int SPC_WOLF    = 1;
const int SPC_RAT     = 2;
const int SPC_CAT     = 3;
const int SPC_FOX     = 4;
const int SPC_BEAR    = 5;
const int SPC_BEETLE  = 6;
const int SPC_BAT     = 7;
const int SPC_BOAR    = 8;
const int SPC_SNOWCAT = 9;
const int SPC_DOG     = 10;
const int SPC_DESFOX  = 11;
 
const string VAR_SHAPECHANGER = "SPC_IS_SHAPECHANGER";
const string VAR_BASE_FORM    = "SPC_BASE_FORM";
const string VAR_BASE_HEAD    = "SPC_BASE_HEAD";
const string VAR_BASE_RACE    = "SPC_BASE_RACE";
const string VAR_HYBRID_FORM  = "SPC_HYBRID_FORM";
const string VAR_HYBRID_TAIL  = "SPC_HYBRID_TAIL";
const string VAR_ANIMAL_FORM  = "SPC_ANIMAL_FORM";
const string VAR_HYBRID_LEGS  = "SPC_HYBRID_LEGS";
const string VAR_HYBRID_HEAD  = "SPC_HYBRID_HEAD";
const string VAR_HYBRID_EARS  = "SPC_HYBRID_EARS";
const string VAR_HYBRID_EARZ  = "SPC_HYBRID_EARZ";
const string VAR_CURRENT_FORM = "SPC_CURRENT_FORM";

const int POLYMORPH_TYPE_TOTEM_5 = 107;
const int POLYMORPH_TYPE_TOTEM_6 = 108;
const int POLYMORPH_TYPE_TOTEM_7 = 109;
const int POLYMORPH_TYPE_TOTEM_8 = 110;
const int POLYMORPH_TYPE_TOTEM_9 = 111;
const int POLYMORPH_TYPE_TOTEM_10 = 112;
const int POLYMORPH_TYPE_TOTEM_11 = 113;
const int POLYMORPH_TYPE_TOTEM_12 = 114;
const int POLYMORPH_TYPE_TOTEM_13 = 115;
const int POLYMORPH_TYPE_TOTEM_14 = 116;
const int POLYMORPH_TYPE_TOTEM_15 = 117;
 
// Apply ear VFX to the PC, using the user's saved Z height.  Apply VFX 0 to remove all ears.
void SPC_ApplyEarVFX(object oPC, int nVFX);
// Once per RL day, gives an XP bonus to a shapechanger who consecrates an altar to a beast deity.
void SPC_Consecrate(object oPC);
// Initialise the character's forms based on race.
void SPC_Initialise(object oPC, int nAnimal);
// Transform the PC into their hybrid form.
void SPC_DoHybridForm(object oPC);
// Transform the PC into their animal form.
void SPC_DoAnimalForm(object oPC);
// Transform the PC into their humanoid form.
void SPC_DoHumanoidForm(object oPC);
// Reapply soft bonuses.
void SPC_DoBonuses(object oPC);


void SPC_ApplyEarVFX(object oPC, int nVFX)
{
  object oHide = gsPCGetCreatureHide(oPC);
  float fZ = GetLocalFloat(oHide, VAR_HYBRID_EARZ);
  
  effect eEff = GetFirstEffect(oPC);
  while (GetIsEffectValid(eEff))
  {
    if (GetEffectTag(eEff) == VAR_SHAPECHANGER)
	{
	  RemoveEffect(oPC, eEff);
	  break;
	}
	
	eEff = GetNextEffect(oPC);
  }
  
  if (nVFX > 0)
  {
    // Scale up by 30% to reflect the scale change we're making to PCs.  Apply PC's custom Z.	
	// Delay command to run after this script ends, to allow the deletion of the previous effect to run first.
	float fScale = GetLocalFloat(oHide, "AR_SCALE");
	if (nVFX < 679) fScale += 0.3f;
    eEff = TagEffect(SupernaturalEffect(EffectVisualEffect(nVFX, FALSE, fScale, Vector(0.0f, 0.0f, fZ))), VAR_SHAPECHANGER);  	
    DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oPC));
  }  
}


void SPC_Consecrate(object oPC) 
{
   object oHide = gsPCGetCreatureHide(oPC);
   if (!GetIsObjectValid(oHide)) return; // DMs etc
   
   if (!GetLocalInt(oHide, VAR_SHAPECHANGER)) return;
   
   if (gsWOGetCategory(gsWOGetDeityByName(GetDeity(oPC))) != FB_WO_CATEGORY_BEAST_CULTS) return;
   
   int nTimeout = GetLocalInt(oHide, "SPC_TIMEOUT");
   if (nTimeout > gsTIGetActualTimestamp()) return;
   
   gsXPGiveExperience(oPC, 250);
   
   SetLocalInt(oHide, "SPC_TIMEOUT", gsTIGetActualTimestamp() + 60*60*24);  
}
 
void SPC_Initialise(object oPC, int nAnimal)
{
   object oHide = gsPCGetCreatureHide(oPC);
   
   // If we are already a shifter, return to our base race...
   if (GetLocalInt(oHide, VAR_BASE_FORM) && GetAppearanceType(oPC) != GetLocalInt(oHide, VAR_BASE_FORM))
   {
		SPC_DoHumanoidForm(oPC);
		FloatingTextStringOnCreature("You must be in your base form to choose another form.", oPC);
		return;
   }	

   int nBaseForm = GetAppearanceType(oPC);
   int nBaseHead = GetCreatureBodyPart(CREATURE_PART_HEAD, oPC);
   int nBaseRace = GetRacialType(oPC);
   int nHybridForm = 0;
   int nHybridTail = 0;
   int nAnimalForm = 0;
   
   // Animal forms are actually tail models to apply to totem forms.
   
   switch (nAnimal)
   {
     case SPC_WOLF:
	   nHybridForm = 171;
	   nAnimalForm = 387;
	   break;
     case SPC_DOG:
	   nHybridForm = 295;
	   nAnimalForm = 388;
	   break;
     case SPC_RAT:
	   nHybridForm = 170;
	   nAnimalForm = 365;
	   break;
     case SPC_CAT:
	   nHybridForm = 3; // werecat is horrible, using halfling...
	   nHybridTail = 622;
	   nAnimalForm = 366;
	   break;
     case SPC_SNOWCAT:
	   nHybridForm = 2034;
	   nHybridTail = 629;
	   nAnimalForm = 367; 
	   break;
     case SPC_FOX:
	   if (GetGender(oPC) == GENDER_FEMALE)
	     nHybridForm = 2044;
	   else
	     nHybridForm = 2040;
	   nAnimalForm = 491;
	   break;
	 case SPC_DESFOX:
	   nHybridForm = 3; // More halfling based fun
	   nHybridTail = 626;
	   nAnimalForm = 492;
	   break;
     case SPC_BEAR:
	   nHybridForm = 2037;
	   nAnimalForm = 353;
	   break;
     case SPC_BEETLE:
	   nHybridForm = 2;
	   nHybridTail = 617;
	   nAnimalForm = 403;
	   break;
     case SPC_BAT:
	   nHybridForm = 2039;
	   nAnimalForm = 348;
	   break;
     case SPC_BOAR:
	   nHybridForm = 2038;
	   nAnimalForm = 356;
	   break;
   }
   
   SetLocalInt(oHide, VAR_BASE_FORM, nBaseForm);
   SetLocalInt(oHide, VAR_BASE_HEAD, nBaseHead);
   SetLocalInt(oHide, VAR_BASE_RACE, nBaseRace);
   SetLocalInt(oHide, VAR_HYBRID_FORM, nHybridForm);
   SetLocalInt(oHide, VAR_HYBRID_TAIL, nHybridTail);
   SetLocalInt(oHide, VAR_ANIMAL_FORM, nAnimalForm);
   
   // Add the custom shapechange feats.
   AddKnownFeat(oPC, 1122);
   AddKnownFeat(oPC, 1123);
   AddKnownFeat(oPC, 1124);
}

void _VisualTransformVoid(object oPC, int nTransform, float fValue)
{
  SetObjectVisualTransform(oPC, nTransform, fValue);
}
 
void SPC_DoHybridForm(object oPC)
{
  // Combining polymorph with other changes doesn't work great.
  // If we're in polymorph, get out of it but don't try to change form.  
  if (gsC2GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC, TRUE))
  {
    gsFXRemoveEffect(oPC, OBJECT_INVALID, EFFECT_TYPE_POLYMORPH);	
	SendMessageToPC(oPC, "You must get out of polymorph before you can pick a form.");
  }
  else
  {
	  
	  // Now figure out whether we are already in hybrid form.
	  object oHide = gsPCGetCreatureHide(oPC);
	  int nHybridForm  = GetLocalInt(oHide, VAR_HYBRID_FORM);
	  int nHybridTail  = GetLocalInt(oHide, VAR_HYBRID_TAIL);
	  int nCurrentForm = GetLocalInt(oHide, VAR_CURRENT_FORM);
	  
	  if (nCurrentForm == 1)
	  {
		// Reapply tail and ears in case they were lost by polymorphing. 
		SetCreatureTailType(nHybridTail, oPC);	
		if (GetLocalInt(oHide, VAR_HYBRID_EARS))
		{
		  DelayCommand(0.2f, SPC_ApplyEarVFX(oPC, GetLocalInt(oHide, VAR_HYBRID_EARS)));
		}
	  }
	  else
	  {  
		SetLocalInt(oHide, VAR_CURRENT_FORM, 1);
		int nHead = GetCreatureBodyPart(CREATURE_PART_HEAD, oPC);
		AssignCommand(oPC, ClearAllActions());

		SetCreatureAppearanceType(oPC, nHybridForm);
		SetCreatureTailType(nHybridTail, oPC);
		NWNX_Creature_SetRacialType(oPC, 23);
		DelayCommand(0.1f, SetCommandable(TRUE, oPC));
			
		// Save off the head we were using before.  This might have changed since we started the char.
	   SetLocalInt(oHide, VAR_BASE_HEAD, nHead);	
		
		// Custom code to tune certain dynamic races.
		if (nHybridForm == 3)
		{
		  if (GetLocalInt(oHide, VAR_HYBRID_HEAD))
			SetCreatureBodyPart(CREATURE_PART_HEAD, GetLocalInt(oHide, VAR_HYBRID_HEAD), oPC);
		  else if (GetGender(oPC) == GENDER_FEMALE)
			SetCreatureBodyPart(CREATURE_PART_HEAD, 18, oPC);
		  else
			SetCreatureBodyPart(CREATURE_PART_HEAD, 16, oPC);
		  
		  if (!GetLocalInt(oHide, VAR_HYBRID_LEGS)) // Unless the PC has chosen to override, default to beast legs.
		  {
			DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, 213, oPC));
			DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, 213, oPC));
			DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, 213, oPC));
			DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, 213, oPC));
		  }
		  
		  float fScale = GetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE);
		  float fTrueScale = GetLocalFloat(oHide, "AR_SCALE");
		  if (fTrueScale == 0.0f || fTrueScale > 1.3f) SetLocalFloat(oHide, "AR_SCALE", fScale);
		  DelayCommand(0.2f, _VisualTransformVoid(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fScale + 0.3f));
		  SetCreatureSize(oPC, CREATURE_SIZE_MEDIUM);
		  
		  if (GetLocalInt(oHide, VAR_HYBRID_EARS))
		  {
		    // Apply after scaling.
			DelayCommand(0.3f, SPC_ApplyEarVFX(oPC, GetLocalInt(oHide, VAR_HYBRID_EARS)));
		  }
		}
		
		// Apply soft bonuses spot/listen
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), oPC);
		effect eBonus = EffectSkillIncrease(SKILL_SPOT, GetHitDice(oPC));
		eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(SKILL_LISTEN, GetHitDice(oPC)));
		eBonus = SupernaturalEffect(eBonus);
		eBonus = TagEffect(eBonus, "SFC");
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oPC);
		SetCommandable(FALSE, oPC);
	  }
  }
}
 
void SPC_DoAnimalForm(object oPC)
{
  object oHide = gsPCGetCreatureHide(oPC);
	
  // If we are currently in animal form, get out of it.
  if (gsC2GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC, TRUE))
  {
    gsFXRemoveEffect(oPC, OBJECT_INVALID, EFFECT_TYPE_POLYMORPH);	
  }
  else
  {
    int nLevel = GetHitDice(oPC);
	if (nLevel < 4) nLevel = 4;
	if (nLevel > 13) nLevel = 13;
	nLevel += 103; // Adjustment to get to the totem appearances in polymorph.2da.
	
	// Hijack totem code to set the tail.
    SetLocalInt(OBJECT_SELF, "TAIL_APPEARANCE", GetLocalInt(oHide, VAR_ANIMAL_FORM));
	
    effect ePoly = EffectPolymorphEx(nLevel);
    ePoly = ExtraordinaryEffect(ePoly);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), oPC);
	
	// Deliberately skip merging gear.  But we do need to copy hide information
    object oHideNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);
	gsCMCopyPropertiesAndVariables(oHide, oHideNew);
	
	SPC_ApplyEarVFX(oPC, 0);
  }

}
void SPC_DoHumanoidForm(object oPC)
{
  // Combining polymorph with other changes doesn't work great.
  // If we're in polymorph, get out of it but don't try to change form.  
  if (gsC2GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC, TRUE))
  {
    gsFXRemoveEffect(oPC, OBJECT_INVALID, EFFECT_TYPE_POLYMORPH);	
	SendMessageToPC(oPC, "You must get out of polymorph before you can pick a form.");
  }
  else
  {
	  
	  // Now figure out whether we are already in humanoid form.
	  object oHide     = gsPCGetCreatureHide(oPC);
	  int nBaseForm    = GetLocalInt(oHide, VAR_BASE_FORM);
	  int nBaseHead    = GetLocalInt(oHide, VAR_BASE_HEAD);
	  int nBaseRace    = GetLocalInt(oHide, VAR_BASE_RACE);
	  int nCurrentForm = GetLocalInt(oHide, VAR_CURRENT_FORM);
	  
	  // Belt and braces - look up base form by race
	  if (nBaseRace == RACIAL_TYPE_ELF) nBaseForm = 1;
	  if (nBaseRace == RACIAL_TYPE_HALFLING) nBaseForm = 3;
	  if (nBaseRace == RACIAL_TYPE_HUMAN) nBaseForm = 6;
	  
	  if (!nBaseHead) nBaseHead = 1;
	  SPC_ApplyEarVFX(oPC, 0);
	  
	  if (!nCurrentForm)
	  {
		// Reapply head and race just in case.
		SetCreatureBodyPart(CREATURE_PART_HEAD, nBaseHead, oPC);
		NWNX_Creature_SetRacialType(oPC, nBaseRace);
	  }
	  else
	  {
		// Delay slightly to allow the depolymorph to take full effect.
		SetLocalInt(oHide, VAR_CURRENT_FORM, 0);
		DelayCommand(0.1f, SetCreatureAppearanceType(oPC, nBaseForm));
		DelayCommand(0.1f, SetCreatureTailType(CREATURE_TAIL_TYPE_NONE, oPC));
		DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_HEAD, nBaseHead, oPC));
		DelayCommand(0.1f, NWNX_Creature_SetRacialType(oPC, nBaseRace));
		DelayCommand(0.1f, SetCommandable(TRUE, oPC));
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUPER_HEROISM), oPC);
	  
		// Reset scale if needed.
		float fScale = GetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE);
		float fTrueScale = GetLocalFloat(oHide, "AR_SCALE");
		  
		if (fTrueScale > 0.0f && fScale != fTrueScale)
		{
		  DelayCommand(0.2f, _VisualTransformVoid(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, fTrueScale));
		}	
		
		// Remove spot/listen bonuses.
		effect eEffect = GetFirstEffect(oPC);
		while(GetIsEffectValid(eEffect))
		{
			if(GetEffectTag(eEffect) == "SFC")
			{
				RemoveEffect(oPC, eEffect);
				break;
			}	
			eEffect = GetNextEffect(oPC);
		}
			
		// In case of cat shifters...
		if (GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, oPC) == 213)
		{
		  DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, 1, oPC));
		  DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, 1, oPC));
		  DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, 1, oPC));
		  DelayCommand(0.1f, SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, 1, oPC));
		}
		
		SetCommandable(FALSE, oPC);
	  }	
  }
}

void SPC_DoBonuses(object oPC)
{
  // Blank for now - could potentially add varied bonuses and penalties by race.
}