#include "inc_lootgen"

void Tier1_Phase2Common();
void Tier1_Phase3Common();

void Tier2_Phase2Common();
void Tier2_Phase3Common();

void Tier1_Phase2Common()
{
  switch (LGEN_GetGenType())
  {
    case ITEM_TYPE_GEAR:
	{
      IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_SKILL_BONUS);
      IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_SKILL_BONUS);
      IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_SKILL_BONUS);
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_SPECIFIC_SAVE_BONUS);

      int acCount = LGEN_GetPropertyCount(PROPERTY_AC_BONUS);
      int statCount = LGEN_GetPropertyCount(PROPERTY_ABILITY_BONUS);

      if (acCount + statCount < 1)
      {
        IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_ABILITY_BONUS);

        if (GetBaseItemType(OBJECT_SELF) == BASE_ITEM_BOOTS)
        {
            IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_AC_BONUS);
            IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_AC_BONUS);
        }
	  }	
	  
	  break;
    }
	case ITEM_TYPE_ARMOUR:
	{
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_SPECIFIC_SAVE_BONUS);
      IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_AC_BONUS_VS_RACE);
      IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_AC_BONUS);
      IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_AC_BONUS);
      IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_AC_BONUS);
      IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_ELEMENTAL_DR);
	  
	  break;
	}
	case ITEM_TYPE_WEAPON:
	{
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_WEAPON_ENH_BONUS);
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_WEAPON_ENH_BONUS);
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_WEAPON_ENH_BONUS_VS_RACE);
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_WEAPON_MASSIVE_CRITICALS);
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_WEAPON_ELEMENTAL_DAMAGE);
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_WEAPON_ELEMENTAL_DAMAGE);
	  
	  break;
	}
  }	
}

void Tier1_Phase3Common()
{
    int property = LGEN_GetChosenProperty();

    if (property == PROPERTY_ABILITY_BONUS)
    {
        LGEN_SetMinProperty1Value(0);
        LGEN_SetMaxProperty1Value(5);
        LGEN_SetMinProperty2Value(1);
        LGEN_SetMaxProperty2Value(1);
    }
    else if (property == PROPERTY_SKILL_BONUS)
    {
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_APPRAISE);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_CONCENTRATION);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_DISCIPLINE);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_HIDE);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_LISTEN);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_MOVE_SILENTLY);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_PARRY);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_PERFORM);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_PERSUADE);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_SPELLCRAFT);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_SPOT);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_TAUNT);

        int itemType = GetBaseItemType(OBJECT_SELF);

        if (itemType == BASE_ITEM_RING || itemType == BASE_ITEM_AMULET)
        {
            IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_HEAL);
        }
    }
    else if (property == PROPERTY_AC_BONUS)
    {
        LGEN_SetMinProperty1Value(1);
        LGEN_SetMaxProperty1Value(2);
    }
	else if (property == PROPERTY_SPECIFIC_SAVE_BONUS)
	{
        LGEN_SetMinProperty1Value(1);
        LGEN_SetMaxProperty1Value(3);
        LGEN_SetMinProperty2Value(1);
        LGEN_SetMaxProperty2Value(3);
	}
	else if (property == PROPERTY_ELEMENTAL_DR)
	{
	    // Acid, Cold, Divine, Electrical, Fire, 5-25%.
        LGEN_SetMinProperty1Value(6);
        LGEN_SetMaxProperty1Value(10);
        LGEN_SetMinProperty2Value(1);
        LGEN_SetMaxProperty2Value(3);
	}
	else if (property == PROPERTY_AC_BONUS_VS_RACE)
	{
	    // Exclude Dwarf, Vermin, Ooze.  Some blank rows.
        LGEN_SetMinProperty1Value(1);
        LGEN_SetMaxProperty1Value(24);
        LGEN_SetMinProperty2Value(1);
        LGEN_SetMaxProperty2Value(4);
	}
	else if (property == PROPERTY_WEAPON_ENH_BONUS)
	{
        LGEN_SetMinProperty1Value(1);
        LGEN_SetMaxProperty1Value(3);
	}
	else if (property == PROPERTY_WEAPON_ENH_BONUS_VS_RACE)
	{
	    // Exclude Dwarf, Vermin, Ooze.  Some blank rows.
        LGEN_SetMinProperty1Value(1);
        LGEN_SetMaxProperty1Value(24);
        LGEN_SetMinProperty2Value(1);
        LGEN_SetMaxProperty2Value(4);
	}
	else if (property == PROPERTY_WEAPON_MASSIVE_CRITICALS)
	{
	    // +1 to +3. 
        LGEN_SetMinProperty1Value(1);
        LGEN_SetMaxProperty1Value(3);
	}
	else if (property == PROPERTY_WEAPON_ELEMENTAL_DAMAGE)
	{
	    // Acid, Cold, Divine, Electrical, Fire, d4-d8.
        LGEN_SetMinProperty1Value(6);
        LGEN_SetMaxProperty1Value(10);
        LGEN_SetMinProperty2Value(6);
        LGEN_SetMaxProperty2Value(8);
	}
}

void Tier2_Phase2Common()
{
  switch (LGEN_GetGenType())
  {
    case ITEM_TYPE_GEAR:
	{
      IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_SKILL_BONUS);
      IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_SKILL_BONUS);
      IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_SKILL_BONUS);
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_SPECIFIC_SAVE_BONUS);

      int acCount = LGEN_GetPropertyCount(PROPERTY_AC_BONUS);
      int statCount = LGEN_GetPropertyCount(PROPERTY_ABILITY_BONUS);

      if (acCount + statCount < 2)
      {
        IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_ABILITY_BONUS);

        if (GetBaseItemType(OBJECT_SELF) == BASE_ITEM_BOOTS)
        {
            IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_AC_BONUS);
        }
	  }	
	  
	  break;
    }
	case ITEM_TYPE_ARMOUR:
	{
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_SPECIFIC_SAVE_BONUS);
      IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_AC_BONUS_VS_RACE);
      IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_AC_BONUS);
      IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_AC_BONUS);
      IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_AC_BONUS);
      IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_ELEMENTAL_DR);
	  
	  break;
	}
	case ITEM_TYPE_WEAPON:
	{
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_WEAPON_ENH_BONUS);
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_WEAPON_ENH_BONUS);
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_WEAPON_ENH_BONUS_VS_RACE);
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_WEAPON_MASSIVE_CRITICALS);
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_WEAPON_ELEMENTAL_DAMAGE);
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_WEAPON_ELEMENTAL_DAMAGE);
	  IntArray_PushBack(OBJECT_SELF, LGEN_PROPERTY_ARRAY_TAG, PROPERTY_WEAPON_AMMO_OR_VAMP_REGEN);
	  
	  break;
	}
  }	
}

void Tier2_Phase3Common()
{
    int property = LGEN_GetChosenProperty();

    if (property == PROPERTY_ABILITY_BONUS)
    {
        LGEN_SetMinProperty1Value(0);
        LGEN_SetMaxProperty1Value(5);
        LGEN_SetMinProperty2Value(1);
        LGEN_SetMaxProperty2Value(3);
    }
    else if (property == PROPERTY_SKILL_BONUS)
    {
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_CONCENTRATION);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_DISCIPLINE);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_HIDE);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_LISTEN);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_MOVE_SILENTLY);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_PARRY);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_PERFORM);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_PERSUADE);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_SPELLCRAFT);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_SPOT);
        IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_TAUNT);

        int itemType = GetBaseItemType(OBJECT_SELF);

        if (itemType == BASE_ITEM_RING || itemType == BASE_ITEM_AMULET)
        {
            IntArray_PushBack(OBJECT_SELF, LGEN_MOD1_ARRAY_TAG, SKILL_HEAL);
        }
		
        LGEN_SetMinProperty2Value(2);
        LGEN_SetMaxProperty2Value(5);
    }
    else if (property == PROPERTY_AC_BONUS)
    {
        LGEN_SetMinProperty1Value(1);
        LGEN_SetMaxProperty1Value(3);
    }
	else if (property == PROPERTY_SPECIFIC_SAVE_BONUS)
	{
        LGEN_SetMinProperty1Value(1);
        LGEN_SetMaxProperty1Value(3);
        LGEN_SetMinProperty2Value(2);
        LGEN_SetMaxProperty2Value(4);
	}
	else if (property == PROPERTY_ELEMENTAL_DR)
	{
	    // Acid, Cold, Divine, Electrical, Fire, 10-50%.
        LGEN_SetMinProperty1Value(6);
        LGEN_SetMaxProperty1Value(10);
        LGEN_SetMinProperty2Value(2);
        LGEN_SetMaxProperty2Value(4);
	}
	else if (property == PROPERTY_AC_BONUS_VS_RACE)
	{
	    // Exclude Dwarf, Vermin, Ooze.  Some blank rows.
        LGEN_SetMinProperty1Value(1);
        LGEN_SetMaxProperty1Value(24);
        LGEN_SetMinProperty2Value(1);
        LGEN_SetMaxProperty2Value(6);
	}
	else if (property == PROPERTY_WEAPON_ENH_BONUS)
	{
        LGEN_SetMinProperty1Value(1);
        LGEN_SetMaxProperty1Value(5);
	}
	else if (property == PROPERTY_WEAPON_ENH_BONUS_VS_RACE)
	{
	    // Exclude Dwarf, Vermin, Ooze.  Some blank rows.
        LGEN_SetMinProperty1Value(1);
        LGEN_SetMaxProperty1Value(24);
        LGEN_SetMinProperty2Value(1);
        LGEN_SetMaxProperty2Value(6);
	}
	else if (property == PROPERTY_WEAPON_MASSIVE_CRITICALS)
	{
	    // +1 to +3. 
        LGEN_SetMinProperty1Value(1);
        LGEN_SetMaxProperty1Value(5);
	}
	else if (property == PROPERTY_WEAPON_ELEMENTAL_DAMAGE)
	{
	    // Acid, Cold, Divine, Electrical, Fire, d4-2d6.
        LGEN_SetMinProperty1Value(6);
        LGEN_SetMaxProperty1Value(10);
        LGEN_SetMinProperty2Value(6);
        LGEN_SetMaxProperty2Value(10);
	}
	else if (property == PROPERTY_WEAPON_AMMO_OR_VAMP_REGEN)
	{
        LGEN_SetMinProperty1Value(1);
        LGEN_SetMaxProperty1Value(4);
	}
}
