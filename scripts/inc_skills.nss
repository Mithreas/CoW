// Utility library for skill information
// Primarily used to check for which skills are class skills.
#include "inc_database"
#include "inc_favsoul"
// Returns TRUE if nSkill is a class skill for nClass, -1 if nClass cannot take nSkill, 
// and FALSE if it's not a class skill but can be taken as cross class.
int miSKGetIsClassSkill(int nClass, int nSkill);
// Initialises the cache.  Call on module load. 
void miSKInitialise();

void _Load2daIntoCache(object oCache, string s2da, int nClass)
{
  // The 2das are very annoyingly structured.  Skills which a class cannot
  // select are not listed, and a separate SkillIndex column lists the skill.
  
  // Initialise the cache with -1 so that any missing rows keep -1.
  int nSkill;
  for (nSkill = 0; nSkill < 30; nSkill++)
  {
    SetLocalInt(oCache, IntToString(nClass) + "_" + IntToString(nSkill), -1);
  }
  
  for (nSkill = 0; nSkill < 30; nSkill++)
  {
    // Note - nSkill here is just an index into the 2da and not an actual SkillID.
    string sSkill = Get2DAString(s2da, "SkillIndex", nSkill);
	string sIsClassSkill = Get2DAString(s2da, "ClassSkill", nSkill); 
	
	SetLocalInt(oCache, IntToString(nClass) + "_" + sSkill, StringToInt(sIsClassSkill));
  }
}

void _LoadSkillCache(object oCache)
{
  // Load each class 2da
  // Store as int variable named classid_skillid 
  // - 1 means it's a class skill
  // - 0 means it's not a class skill
  // - -1 means it's not allowed for the class  
  _Load2daIntoCache(oCache, "cls_skill_archer", CLASS_TYPE_ARCANE_ARCHER);
  _Load2daIntoCache(oCache, "cls_skill_asasin", CLASS_TYPE_ASSASSIN);
  _Load2daIntoCache(oCache, "cls_skill_barb", CLASS_TYPE_BARBARIAN);
  _Load2daIntoCache(oCache, "cls_skill_bard", CLASS_TYPE_BARD);
  _Load2daIntoCache(oCache, "cls_skill_blkgrd", CLASS_TYPE_BLACKGUARD);
  _Load2daIntoCache(oCache, "cls_skill_cler", CLASS_TYPE_CLERIC);
  _Load2daIntoCache(oCache, "cls_skill_divcha", CLASS_TYPE_DIVINE_CHAMPION);
  _Load2daIntoCache(oCache, "cls_skill_dradis", CLASS_TYPE_DRAGON_DISCIPLE);
  _Load2daIntoCache(oCache, "cls_skill_dru", CLASS_TYPE_DRUID);
  _Load2daIntoCache(oCache, "cls_skill_dwdef", CLASS_TYPE_DWARVEN_DEFENDER);
  _Load2daIntoCache(oCache, "cls_skill_fight", CLASS_TYPE_FIGHTER);
  _Load2daIntoCache(oCache, "cls_skill_cler", CLASS_TYPE_FAVOURED_SOUL);
  _Load2daIntoCache(oCache, "cls_skill_harper", CLASS_TYPE_HARPER);
  _Load2daIntoCache(oCache, "cls_skill_monk", CLASS_TYPE_MONK);
  _Load2daIntoCache(oCache, "cls_skill_pal", CLASS_TYPE_PALADIN);
  _Load2daIntoCache(oCache, "cls_skill_palema", CLASS_TYPE_PALE_MASTER);
  _Load2daIntoCache(oCache, "cls_skill_pdk", CLASS_TYPE_PURPLE_DRAGON_KNIGHT);
  _Load2daIntoCache(oCache, "cls_skill_rang", CLASS_TYPE_RANGER);
  _Load2daIntoCache(oCache, "cls_skill_rog", CLASS_TYPE_ROGUE);
  _Load2daIntoCache(oCache, "cls_skill_shadow", CLASS_TYPE_SHADOWDANCER);
  _Load2daIntoCache(oCache, "cls_skill_shiftr", CLASS_TYPE_SHIFTER);
  _Load2daIntoCache(oCache, "cls_skill_sorc", CLASS_TYPE_SORCERER);
  _Load2daIntoCache(oCache, "cls_skill_wiz", CLASS_TYPE_WIZARD);
  _Load2daIntoCache(oCache, "cls_skill_wm", CLASS_TYPE_WEAPON_MASTER);
  
  SetLocalInt(oCache, "INITIALISED", TRUE);
}

object _GetSkillCache()
{
  object oCache = miDAGetCacheObject("SKILLS");
  if (!GetLocalInt(oCache, "INITIALISED"))
  {
    _LoadSkillCache(oCache);
  }
  
  return oCache;
}

void miSKInitialise()
{
  _GetSkillCache();
}

int miSKGetIsClassSkill(int nClass, int nSkill)
{
  object oCache = _GetSkillCache();
  return GetLocalInt(oCache, IntToString(nClass) + "_" + IntToString(nSkill));
}