// Code for ritual circles. 
#include "inc_area"
#include "inc_quest"
#include "inc_spellsword"
#include "inc_time"
const int RITUAL_TYPE_RESTORATION = 1;
const int RITUAL_TYPE_RAISE = 2;
const int RITUAL_TYPE_WARD = 3;

string _GetRandomPlant()
{
  switch (d20())
  {
    case 1: return "cnraloeplant";
    case 2: return "cnrangelicaplant";
    case 3: return "cnrcatnipplant";
    case 4: return "cnrchamomileplant";
    case 5: return "cnrcomfreyplant";
    case 6: return "cnrechinaceaplant";
    case 7: return "cnrgarlicplant";
    case 8: return "cnrgingerplant";
    case 9: return "cnrginsengplant";
    case 10: return "cnrhawthornplant";
    case 11: return "cnrnettleplant";
    case 12: return "cnrpepmintplant";
    case 13: return "cnrcloverplant";
    case 14: return "cnrsageplant";
    case 15: return "cnrskullcapplant";
    case 16: return "cnrhazelplant";
    case 17: return "cnrcottonplant";
    case 18: return "cnrbirchplant";
    case 19: return "cnrhazelnutplant";
    case 20: return "cnrwalnutplant";
  }
  
  return "";
}

void _RewardPCs(object oArea, int nAmount)
{
  object oPC = GetFirstPC();
  while (GetIsObjectValid(oPC))
  {
    if (GetArea(oPC) == oArea)
    {
      gsXPGiveExperience(oPC, nAmount);
	
	  // restore_land quest completion
	  if (GetPersistentInt(oPC, "restore_land", DB_MISC_QUESTS) == 1)
	  {
	    SetPersistentInt(oPC, "restore_land", 100, 0, DB_MISC_QUESTS);
	    SendMessageToPC(oPC, "You have completed the Restoration quest.");
	  }
	}
	
	oPC = GetNextPC();
  }
}

void _SpawnPlants(object oArea)
{
    // Spawn plants in random spots across the restored wasteland.  Use walkmesh probes to put them in the right place.
  
    float fSizeX  = gsARGetSizeX(oArea);
    float fSizeY  = gsARGetSizeY(oArea);
    float fX      = 0.0;
    float fY      = 0.0;
    int nSizeX    = FloatToInt(fSizeX) - 19;
    int nSizeY    = FloatToInt(fSizeY) - 19;
    int nCount    = FloatToInt(fSizeX * fSizeY / 300);
    int nNth      = 0;

    for (; nNth < nCount; nNth++)
    {
        fX = IntToFloat(10 + Random(nSizeX));
        fY = IntToFloat(10 + Random(nSizeY));

		location lWalkable = guENFindNearestWalkable(Location(oArea, Vector(fX, fY), 0.0));
		CreateObject(OBJECT_TYPE_PLACEABLE, _GetRandomPlant(), lWalkable);
    }
}

void _DoRitual()
{
  int nRitualType = GetLocalInt(OBJECT_SELF, "RITUAL_TYPE");
  int nRitualists = GetLocalInt(OBJECT_SELF, "MI_ACTIVE");
  
  if (!GetIsObjectValid(OBJECT_SELF)) return; 
  if (!nRitualists) 
  {
    DestroyObject(OBJECT_SELF);
    return;
  }	
  
  int nVFXDur = GetLocalInt(OBJECT_SELF, "RITUAL_VFX_DUR");
  ApplyEffectAtLocation(
         DURATION_TYPE_TEMPORARY,
         EffectVisualEffect(nVFXDur),
         GetLocation(OBJECT_SELF),
		 6.0f);
  
  switch (nRitualType)
  {
    case RITUAL_TYPE_RESTORATION:
	{
	  // Adjust fog.
	  object oArea = GetArea(OBJECT_SELF);
      int nBaseFogAmount = gsTIGetCurrentDayTime() == GS_TI_DAYTIME_DAY ? GetLocalInt(oArea, "GS_AM_FAS") : GetLocalInt(oArea, "GS_AM_FAM");	  
      int nCurrentFogAmount = gsTIGetCurrentDayTime() == GS_TI_DAYTIME_DAY ? GetLocalInt(oArea, "GS_AM_FOG_AMOUNT_SUN") : GetLocalInt(oArea, "GS_AM_FOG_AMOUNT_MOON");

      if (nCurrentFogAmount != nBaseFogAmount)
      {
		if (nBaseFogAmount > nCurrentFogAmount)
		{
		  nCurrentFogAmount += nRitualists;
		  if (nCurrentFogAmount > nBaseFogAmount) nCurrentFogAmount = nBaseFogAmount;		
		}
		else if (nBaseFogAmount < nCurrentFogAmount)
		{
		  nCurrentFogAmount -= nRitualists;
		  if (nCurrentFogAmount < nBaseFogAmount) nCurrentFogAmount = nBaseFogAmount;		
		}
		  
		SetFogAmount(gsTIGetCurrentDayTime() == GS_TI_DAYTIME_DAY ? FOG_TYPE_SUN : FOG_TYPE_MOON, nCurrentFogAmount, oArea);
		SetLocalInt(oArea, gsTIGetCurrentDayTime() == GS_TI_DAYTIME_DAY ? "GS_AM_FOG_AMOUNT_SUN" : "GS_AM_FOG_AMOUNT_MOON", nCurrentFogAmount);
		
		if (nCurrentFogAmount == nBaseFogAmount)
		{
		  // We are now in balance.  Restore original fog colours.
		  SetFogColor(gsTIGetCurrentDayTime() == GS_TI_DAYTIME_DAY ? FOG_TYPE_SUN : FOG_TYPE_MOON, 
		              gsTIGetCurrentDayTime() == GS_TI_DAYTIME_DAY ? GetLocalInt(oArea, "GS_AM_FAS") : GetLocalInt(oArea, "GS_AM_FAM"),
					  oArea);
					  
		  SetLocalInt(oArea, gsTIGetCurrentDayTime() == GS_TI_DAYTIME_DAY ? "GS_AM_FOG_COLOR_SUN" : "GS_AM_FOG_COLOR_MOON", 
		                 gsTIGetCurrentDayTime() == GS_TI_DAYTIME_DAY ? GetLocalInt(oArea, "GS_AM_FAS") : GetLocalInt(oArea, "GS_AM_FAM"));
		  
		  ApplyEffectAtLocation(
			 DURATION_TYPE_INSTANT,
			 EffectVisualEffect(GetLocalInt(OBJECT_SELF, "RITUAL_VFX_FNF")),
			 GetLocation(OBJECT_SELF));
		  FloatingTextStringOnCreature("The area is restored to balance... for now.", GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC), TRUE); 
		  _RewardPCs(oArea, 100);
		  _SpawnPlants(oArea);
		  DestroyObject(OBJECT_SELF);
		}
		else
		{
		  FloatingTextStringOnCreature("You can feel your ritual doing some good.", GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_IS_PC), TRUE); 
		}
	  }
	  	  
	  break;
	}
	case RITUAL_TYPE_RAISE:
	{
	  break;
	}
	case RITUAL_TYPE_WARD:
	{
	  break;
	}
  }
  
  DelayCommand(6.0f, _DoRitual());
}

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  // Check whether the circle is active. Only a non spellsword wizard can initiate a ritual.
  if (!GetLocalInt(OBJECT_SELF, "MI_ACTIVE") && 
      (!GetLevelByClass(CLASS_TYPE_WIZARD, oPC) || miSSGetIsSpellsword(oPC)))
  {
    SendMessageToPC(oPC, "A non-Spellsword Wizard must initiate the ritual first.");
	AssignCommand(oPC, ClearAllActions(TRUE));
	return FALSE;
  }
  else if (!GetLocalInt(OBJECT_SELF, "MI_ACTIVE") &&
           GetLevelByClass(CLASS_TYPE_WIZARD, oPC) &&
		   !miSSGetIsSpellsword(oPC))
  {
    AssignCommand(oPC, PlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 300.0));
	
	int nVFXFnF = GetLocalInt(OBJECT_SELF, "RITUAL_VFX_FNF");
	int nVFXDur = GetLocalInt(OBJECT_SELF, "RITUAL_VFX_DUR");
	
    ApplyEffectAtLocation(
         DURATION_TYPE_INSTANT,
         EffectVisualEffect(nVFXFnF),
         GetLocation(OBJECT_SELF));
		 
    ApplyEffectAtLocation(
         DURATION_TYPE_TEMPORARY,
         EffectVisualEffect(nVFXDur),
         GetLocation(OBJECT_SELF),
		 6.0f);
	
	// Find nearby PCs with the right classes and loop them in.
    int nNth = 1;
    object oFlock = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC, nNth);

    while (GetIsObjectValid(oFlock) &&
           GetDistanceBetween(oFlock, oPC) <= 20.0f)
    {
       if (LineOfSightObject(oPC, oFlock) &&
	       (GetLevelByClass(CLASS_TYPE_WIZARD, oFlock) || GetLevelByClass(CLASS_TYPE_CLERIC, oFlock) || 
		    GetLevelByClass(CLASS_TYPE_SORCERER, oFlock) || GetLevelByClass(CLASS_TYPE_BARD, oFlock) || GetLevelByClass(CLASS_TYPE_DRUID, oFlock)))
       {
          AssignCommand(oFlock, PlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 300.0));		  
       }

       nNth++;
       oFlock = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC, nNth);
    }

    SetLocalInt(OBJECT_SELF, "MI_ACTIVE", nNth);
	
	DelayCommand(6.0f, _DoRitual());
	DelayCommand(350.0f, DestroyObject(OBJECT_SELF));
	return TRUE;
  }  

   return FALSE;
}
