#include "nwnx"
  
 const string NWNX_Creature = "NWNX_Creature"; 
  
 const int NWNX_CREATURE_MOVEMENT_RATE_PC        = 0;
 const int NWNX_CREATURE_MOVEMENT_RATE_IMMOBILE  = 1;
 const int NWNX_CREATURE_MOVEMENT_RATE_VERY_SLOW = 2;
 const int NWNX_CREATURE_MOVEMENT_RATE_SLOW      = 3;
 const int NWNX_CREATURE_MOVEMENT_RATE_NORMAL    = 4;
 const int NWNX_CREATURE_MOVEMENT_RATE_FAST      = 5;
 const int NWNX_CREATURE_MOVEMENT_RATE_VERY_FAST = 6;
 const int NWNX_CREATURE_MOVEMENT_RATE_DEFAULT   = 7;
 const int NWNX_CREATURE_MOVEMENT_RATE_DM_FAST   = 8;
  
 const int NWNX_CREATURE_MOVEMENT_TYPE_STATIONARY      = 0;
 const int NWNX_CREATURE_MOVEMENT_TYPE_WALK            = 1;
 const int NWNX_CREATURE_MOVEMENT_TYPE_RUN             = 2;
 const int NWNX_CREATURE_MOVEMENT_TYPE_SIDESTEP        = 3;
 const int NWNX_CREATURE_MOVEMENT_TYPE_WALK_BACKWARDS  = 4;
  
 const int NWNX_CREATURE_CLERIC_DOMAIN_AIR         = 0;
 const int NWNX_CREATURE_CLERIC_DOMAIN_ANIMAL      = 1;
 const int NWNX_CREATURE_CLERIC_DOMAIN_DEATH       = 3;
 const int NWNX_CREATURE_CLERIC_DOMAIN_DESTRUCTION = 4;
 const int NWNX_CREATURE_CLERIC_DOMAIN_EARTH       = 5;
 const int NWNX_CREATURE_CLERIC_DOMAIN_EVIL        = 6;
 const int NWNX_CREATURE_CLERIC_DOMAIN_FIRE        = 7;
 const int NWNX_CREATURE_CLERIC_DOMAIN_GOOD        = 8;
 const int NWNX_CREATURE_CLERIC_DOMAIN_HEALING     = 9;
 const int NWNX_CREATURE_CLERIC_DOMAIN_KNOWLEDGE   = 10;
 const int NWNX_CREATURE_CLERIC_DOMAIN_MAGIC       = 13;
 const int NWNX_CREATURE_CLERIC_DOMAIN_PLANT       = 14;
 const int NWNX_CREATURE_CLERIC_DOMAIN_PROTECTION  = 15;
 const int NWNX_CREATURE_CLERIC_DOMAIN_STRENGTH    = 16;
 const int NWNX_CREATURE_CLERIC_DOMAIN_SUN         = 17;
 const int NWNX_CREATURE_CLERIC_DOMAIN_TRAVEL      = 18;
 const int NWNX_CREATURE_CLERIC_DOMAIN_TRICKERY    = 19;
 const int NWNX_CREATURE_CLERIC_DOMAIN_WAR         = 20;
 const int NWNX_CREATURE_CLERIC_DOMAIN_WATER       = 21;
  
 const int NWNX_CREATURE_BONUS_TYPE_ATTACK        = 1;
 const int NWNX_CREATURE_BONUS_TYPE_DAMAGE        = 2;
 const int NWNX_CREATURE_BONUS_TYPE_SAVING_THROW  = 3;
 const int NWNX_CREATURE_BONUS_TYPE_ABILITY       = 4;
 const int NWNX_CREATURE_BONUS_TYPE_SKILL         = 5;
 const int NWNX_CREATURE_BONUS_TYPE_TOUCH_ATTACK  = 6;
  
 struct NWNX_Creature_SpecialAbility
 {
     int id; 
     int ready; 
     int level; 
 };
  
 struct NWNX_Creature_MemorisedSpell
 {
     int id; 
     int ready; 
     int meta; 
     int domain; 
 };
  
 void NWNX_Creature_AddFeat(object creature, int feat);
  
 void NWNX_Creature_AddFeatByLevel(object creature, int feat, int level);
  
 void NWNX_Creature_RemoveFeat(object creature, int feat);
  
 int NWNX_Creature_GetKnowsFeat(object creature, int feat);
  
 int NWNX_Creature_GetFeatCountByLevel(object creature, int level);
  
 int NWNX_Creature_GetFeatByLevel(object creature, int level, int index);
  
 int NWNX_Creature_GetFeatGrantLevel(object creature, int feat);
  
 int NWNX_Creature_GetFeatCount(object creature);
  
 int NWNX_Creature_GetFeatByIndex(object creature, int index);
  
 int NWNX_Creature_GetMeetsFeatRequirements(object creature, int feat);
  
 int NWNX_Creature_GetSpecialAbilityCount(object creature);
  
 struct NWNX_Creature_SpecialAbility NWNX_Creature_GetSpecialAbility(object creature, int index);
  
 void NWNX_Creature_AddSpecialAbility(object creature, struct NWNX_Creature_SpecialAbility ability);
  
 void NWNX_Creature_RemoveSpecialAbility(object creature, int index);
  
 void NWNX_Creature_SetSpecialAbility(object creature, int index, struct NWNX_Creature_SpecialAbility ability);
  
 int NWNX_Creature_GetClassByLevel(object creature, int level);
  
 void NWNX_Creature_SetBaseAC(object creature, int ac);
  
 int NWNX_Creature_GetBaseAC(object creature);
  
 void NWNX_Creature_SetRawAbilityScore(object creature, int ability, int value);
  
 int NWNX_Creature_GetRawAbilityScore(object creature, int ability);
  
 void NWNX_Creature_ModifyRawAbilityScore(object creature, int ability, int modifier);
  
 int NWNX_Creature_GetPrePolymorphAbilityScore(object creature, int ability);
  
 int NWNX_Creature_GetMemorisedSpellCountByLevel(object creature, int class, int level);
  
 struct NWNX_Creature_MemorisedSpell NWNX_Creature_GetMemorisedSpell(object creature, int class, int level, int index);
  
 void NWNX_Creature_SetMemorisedSpell(object creature, int class, int level, int index, struct NWNX_Creature_MemorisedSpell spell);
  
 int NWNX_Creature_GetRemainingSpellSlots(object creature, int class, int level);
  
 void NWNX_Creature_SetRemainingSpellSlots(object creature, int class, int level, int slots);
  
 int NWNX_Creature_GetMaxSpellSlots(object creature, int class, int level);
  
 int NWNX_Creature_GetKnownSpellCount(object creature, int class, int level);
  
 int NWNX_Creature_GetKnownSpell(object creature, int class, int level, int index);
  
 void NWNX_Creature_AddKnownSpell(object creature, int class, int level, int spellId);
  
 void NWNX_Creature_RemoveKnownSpell(object creature, int class, int level, int spellId);
  
 void NWNX_Creature_ClearMemorisedKnownSpells(object creature, int class, int spellId);
  
 void NWNX_Creature_ClearMemorisedSpell(object creature, int class, int level, int index);
  
 int NWNX_Creature_GetMaxHitPointsByLevel(object creature, int level);
  
 void NWNX_Creature_SetMaxHitPointsByLevel(object creature, int level, int value);
  
 void NWNX_Creature_SetMovementRate(object creature, int rate);
  
 float NWNX_Creature_GetMovementRateFactor(object creature);
  
 void NWNX_Creature_SetMovementRateFactor(object creature, float rate);
  
 void NWNX_Creature_SetMovementRateFactorCap(object creature, float cap);
  
 int NWNX_Creature_GetMovementType(object creature);
  
 void NWNX_Creature_SetWalkRateCap(object creature, float fWalkRate = 2000.0f);
  
 void NWNX_Creature_SetAlignmentGoodEvil(object creature, int value);
  
 void NWNX_Creature_SetAlignmentLawChaos(object creature, int value);
  
 int NWNX_Creature_GetSoundset(object creature);
  
 void NWNX_Creature_SetSoundset(object creature, int soundset);
  
 void NWNX_Creature_SetSkillRank(object creature, int skill, int rank);
  
 void NWNX_Creature_SetClassByPosition(object creature, int position, int classID);
  
 void NWNX_Creature_SetLevelByPosition(object creature, int position, int level);
  
 void NWNX_Creature_SetBaseAttackBonus(object creature, int bab);
  
 int NWNX_Creature_GetAttacksPerRound(object creature, int bBaseAPR = FALSE);
  
 void NWNX_Creature_SetGender(object creature, int gender);
  
 void NWNX_Creature_RestoreFeats(object creature);
  
 void NWNX_Creature_RestoreSpecialAbilities(object creature);
  
 void NWNX_Creature_RestoreSpells(object creature, int level = -1);
  
 void NWNX_Creature_RestoreItems(object creature);
  
 void NWNX_Creature_SetSize(object creature, int size);
  
 int NWNX_Creature_GetSkillPointsRemaining(object creature);
  
 void NWNX_Creature_SetSkillPointsRemaining(object creature, int skillpoints);
  
 void NWNX_Creature_SetRacialType(object creature, int racialtype);
  
 void NWNX_Creature_SetGold(object creature, int gold);
  
 void NWNX_Creature_SetCorpseDecayTime(object creature, int nDecayTime);
  
 int NWNX_Creature_GetBaseSavingThrow(object creature, int which);
  
 void NWNX_Creature_SetBaseSavingThrow(object creature, int which, int value);
  
 void NWNX_Creature_LevelUp(object creature, int class, int count=1);
  
 void NWNX_Creature_LevelDown(object creature, int count=1);
  
 void NWNX_Creature_SetChallengeRating(object creature, float fCR);
  
 int NWNX_Creature_GetAttackBonus(object creature, int isMelee = -1, int isTouchAttack = FALSE, int isOffhand = FALSE, int includeBaseAttackBonus = TRUE);
  
 int NWNX_Creature_GetHighestLevelOfFeat(object creature, int feat);
  
 int NWNX_Creature_GetFeatRemainingUses(object creature, int feat);
  
 int NWNX_Creature_GetFeatTotalUses(object creature, int feat);
  
 void NWNX_Creature_SetFeatRemainingUses(object creature, int feat, int uses);
  
 int NWNX_Creature_GetTotalEffectBonus(object creature, int bonusType=NWNX_CREATURE_BONUS_TYPE_ATTACK, object target=OBJECT_INVALID, int isElemental=0, int isForceMax=0, int savetype=-1, int saveSpecificType=-1, int skill=-1, int abilityScore=-1, int isOffhand=FALSE);
  
 void NWNX_Creature_SetOriginalName(object creature, string name, int isLastName);
  
 string NWNX_Creature_GetOriginalName(object creature, int isLastName);
  
 void NWNX_Creature_SetSpellResistance(object creature, int sr);
  
 void NWNX_Creature_SetAnimalCompanionCreatureType(object creature, int type);
  
 void NWNX_Creature_SetFamiliarCreatureType(object creature, int type);
  
 void NWNX_Creature_SetAnimalCompanionName(object creature, string name);
  
 void NWNX_Creature_SetFamiliarName(object creature, string name);
  
 int NWNX_Creature_GetDisarmable(object creature);
  
 void NWNX_Creature_SetDisarmable(object creature, int disarmable);
  
 int NWNX_Creature_GetDomain(object creature, int class, int index);
  
 void NWNX_Creature_SetDomain(object creature, int class, int index, int domain);
  
 int NWNX_Creature_GetSpecialization(object creature, int class);
  
 void NWNX_Creature_SetSpecialization(object creature, int class, int school);
  
 void NWNX_Creature_SetFaction(object oCreature, int nFactionId);
  
 int NWNX_Creature_GetFaction(object oCreature);
  
 int NWNX_Creature_GetFlatFooted(object oCreature);
  
 string NWNX_Creature_SerializeQuickbar(object oCreature);
  
 int NWNX_Creature_DeserializeQuickbar(object oCreature, string sSerializedQuickbar);
  
 void NWNX_Creature_SetCasterLevelModifier(object oCreature, int nClass, int nModifier, int bPersist = FALSE);
  
 int NWNX_Creature_GetCasterLevelModifier(object oCreature, int nClass);
  
 void NWNX_Creature_SetCasterLevelOverride(object oCreature, int nClass, int nCasterLevel, int bPersist = FALSE);
  
 int NWNX_Creature_GetCasterLevelOverride(object oCreature, int nClass);
  
 void NWNX_Creature_JumpToLimbo(object oCreature);
  
 void NWNX_Creature_SetCriticalMultiplierModifier(object oCreature, int nModifier, int nHand = 0, int bPersist = FALSE, int nBaseItem = -1);
  
 int NWNX_Creature_GetCriticalMultiplierModifier(object oCreature, int nHand = 0, int nBaseItem = -1);
  
 void NWNX_Creature_SetCriticalMultiplierOverride(object oCreature, int nOverride, int nHand = 0, int bPersist = FALSE, int nBaseItem = -1);
  
 int NWNX_Creature_GetCriticalMultiplierOverride(object oCreature, int nHand = 0, int nBaseItem = -1);
  
 void NWNX_Creature_SetCriticalRangeModifier(object oCreature, int nModifier, int nHand = 0, int bPersist = FALSE, int nBaseItem = -1);
  
 int NWNX_Creature_GetCriticalRangeModifier(object oCreature, int nHand = 0, int nBaseItem = -1);
  
 void NWNX_Creature_SetCriticalRangeOverride(object oCreature, int nOverride, int nHand = 0, int bPersist = FALSE, int nBaseItem = -1);
  
 int NWNX_Creature_GetCriticalRangeOverride(object oCreature, int nHand = 0, int nBaseItem = -1);
  
 void NWNX_Creature_AddAssociate(object oCreature, object oAssociate, int nAssociateType);
  
 void NWNX_Creature_SetEffectIconFlashing(object oCreature, int nIconId, int bFlashing);
  
 void NWNX_Creature_OverrideDamageLevel(object oCreature, int nDamageLevel);
  
 void NWNX_Creature_SetEncounter(object oCreature, object oEncounter);
  
 object NWNX_Creature_GetEncounter(object oCreature);
  
 int NWNX_Creature_GetIsBartering(object oCreature);
  
 void NWNX_Creature_SetLastItemCasterLevel(object oCreature, int nCasterLvl);
  
 int NWNX_Creature_GetLastItemCasterLevel(object oCreature);
  
 int NWNX_Creature_GetArmorClassVersus(object oAttacked, object oVersus, int nTouch=FALSE);
  
 int NWNX_Creature_GetWalkAnimation(object oCreature);
  
 void NWNX_Creature_SetWalkAnimation(object oCreature, int nAnimation);
  
 void NWNX_Creature_SetAttackRollOverride(object oCreature, int nRoll, int nModifier);
  
 void NWNX_Creature_SetParryAllAttacks(object oCreature, int bParry);
  
 int NWNX_Creature_GetNoPermanentDeath(object oCreature);
  
 void NWNX_Creature_SetNoPermanentDeath(object oCreature, int bNoPermanentDeath);
  
 vector NWNX_Creature_ComputeSafeLocation(object oCreature, vector vPosition, float fRadius = 20.0f, int bWalkStraightLineRequired = TRUE);
  
 void NWNX_Creature_DoPerceptionUpdateOnCreature(object oCreature, object oTargetCreature);
  
 float NWNX_Creature_GetPersonalSpace(object oCreature);
  
 void NWNX_Creature_SetPersonalSpace(object oCreature, float fPerspace);
  
 float NWNX_Creature_GetCreaturePersonalSpace(object oCreature);
  
 void NWNX_Creature_SetCreaturePersonalSpace(object oCreature, float fCrePerspace);
  
 float NWNX_Creature_GetHeight(object oCreature);
  
 void NWNX_Creature_SetHeight(object oCreature, float fHeight);
  
 float NWNX_Creature_GetHitDistance(object oCreature);
  
 void NWNX_Creature_SetHitDistance(object oCreature, float fHitDist);
  
 float NWNX_Creature_GetPreferredAttackDistance(object oCreature);
  
 void NWNX_Creature_SetPreferredAttackDistance(object oCreature, float fPrefAtckDist);
  
  
 void NWNX_Creature_AddFeat(object creature, int feat)
 {
     string sFunc = "AddFeat";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, feat);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_AddFeatByLevel(object creature, int feat, int level)
 {
     string sFunc = "AddFeatByLevel";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, feat);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_RemoveFeat(object creature, int feat)
 {
     string sFunc = "RemoveFeat";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, feat);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetKnowsFeat(object creature, int feat)
 {
     string sFunc = "GetKnowsFeat";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, feat);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetFeatCountByLevel(object creature, int level)
 {
     string sFunc = "GetFeatCountByLevel";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetFeatByLevel(object creature, int level, int index)
 {
     string sFunc = "GetFeatByLevel";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, index);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetFeatCount(object creature)
 {
     string sFunc = "GetFeatCount";
  
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetFeatGrantLevel(object creature, int feat)
 {
     string sFunc = "GetFeatGrantLevel";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, feat);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetFeatByIndex(object creature, int index)
 {
     string sFunc = "GetFeatByIndex";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, index);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetMeetsFeatRequirements(object creature, int feat)
 {
     string sFunc = "GetMeetsFeatRequirements";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, feat);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 struct NWNX_Creature_SpecialAbility NWNX_Creature_GetSpecialAbility(object creature, int index)
 {
     string sFunc = "GetSpecialAbility";
  
     struct NWNX_Creature_SpecialAbility ability;
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, index);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
  
     ability.level  = NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
     ability.ready  = NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
     ability.id     = NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
  
     return ability;
 }
  
 int NWNX_Creature_GetSpecialAbilityCount(object creature)
 {
     string sFunc = "GetSpecialAbilityCount";
  
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_AddSpecialAbility(object creature, struct NWNX_Creature_SpecialAbility ability)
 {
     string sFunc = "AddSpecialAbility";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, ability.id);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, ability.ready);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, ability.level);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_RemoveSpecialAbility(object creature, int index)
 {
     string sFunc = "RemoveSpecialAbility";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, index);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetSpecialAbility(object creature, int index, struct NWNX_Creature_SpecialAbility ability)
 {
     string sFunc = "SetSpecialAbility";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, ability.id);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, ability.ready);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, ability.level);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, index);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetClassByLevel(object creature, int level)
 {
     string sFunc = "GetClassByLevel";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetBaseAC(object creature, int ac)
 {
     string sFunc = "SetBaseAC";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, ac);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetBaseAC(object creature)
 {
     string sFunc = "GetBaseAC";
  
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetRawAbilityScore(object creature, int ability, int value)
 {
     string sFunc = "SetRawAbilityScore";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, value);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, ability);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetRawAbilityScore(object creature, int ability)
 {
     string sFunc = "GetRawAbilityScore";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, ability);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_ModifyRawAbilityScore(object creature, int ability, int modifier)
 {
     string sFunc = "ModifyRawAbilityScore";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, modifier);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, ability);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetPrePolymorphAbilityScore(object creature, int ability)
 {
     string sFunc = "GetPrePolymorphAbilityScore";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, ability);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 struct NWNX_Creature_MemorisedSpell NWNX_Creature_GetMemorisedSpell(object creature, int class, int level, int index)
 {
     string sFunc = "GetMemorisedSpell";
     struct NWNX_Creature_MemorisedSpell spell;
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, index);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, class);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
  
     spell.domain = NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
     spell.meta   = NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
     spell.ready  = NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
     spell.id     = NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
     return spell;
 }
  
 int NWNX_Creature_GetMemorisedSpellCountByLevel(object creature, int class, int level)
 {
     string sFunc = "GetMemorisedSpellCountByLevel";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, class);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetMemorisedSpell(object creature, int class, int level, int index, struct NWNX_Creature_MemorisedSpell spell)
 {
     string sFunc = "SetMemorisedSpell";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, spell.id);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, spell.ready);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, spell.meta);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, spell.domain);
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, index);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, class);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetRemainingSpellSlots(object creature, int class, int level)
 {
     string sFunc = "GetRemainingSpellSlots";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, class);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetRemainingSpellSlots(object creature, int class, int level, int slots)
 {
     string sFunc = "SetRemainingSpellSlots";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, slots);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, class);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetKnownSpell(object creature, int class, int level, int index)
 {
     string sFunc = "GetKnownSpell";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, index);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, class);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetKnownSpellCount(object creature, int class, int level)
 {
     string sFunc = "GetKnownSpellCount";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, class);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_RemoveKnownSpell(object creature, int class, int level, int spellId)
 {
     string sFunc = "RemoveKnownSpell";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, spellId);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, class);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_AddKnownSpell(object creature, int class, int level, int spellId)
 {
     string sFunc = "AddKnownSpell";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, spellId);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, class);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_ClearMemorisedKnownSpells(object creature, int class, int spellId)
 {
     string sFunc = "ClearMemorisedKnownSpells";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, spellId);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, class);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_ClearMemorisedSpell(object creature, int class, int level, int index)
 {
     string sFunc = "ClearMemorisedSpell";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, index);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, class);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetMaxSpellSlots(object creature, int class, int level)
 {
     string sFunc = "GetMaxSpellSlots";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, class);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
  
 int NWNX_Creature_GetMaxHitPointsByLevel(object creature, int level)
 {
     string sFunc = "GetMaxHitPointsByLevel";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetMaxHitPointsByLevel(object creature, int level, int value)
 {
     string sFunc = "SetMaxHitPointsByLevel";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, value);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetMovementRate(object creature, int rate)
 {
     string sFunc = "SetMovementRate";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, rate);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 float NWNX_Creature_GetMovementRateFactor(object creature)
 {
     string sFunc = "GetMovementRateFactor";
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueFloat(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetMovementRateFactor(object creature, float factor)
 {
     string sFunc = "SetMovementRateFactor";
  
     NWNX_PushArgumentFloat(NWNX_Creature, sFunc, factor);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetMovementRateFactorCap(object creature, float cap)
 {
     string sFunc = "SetMovementRateFactorCap";
  
     NWNX_PushArgumentFloat(NWNX_Creature, sFunc, cap);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetAlignmentGoodEvil(object creature, int value)
 {
     string sFunc = "SetAlignmentGoodEvil";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, value);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetAlignmentLawChaos(object creature, int value)
 {
     string sFunc = "SetAlignmentLawChaos";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, value);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetSoundset(object creature)
 {
     string sFunc = "GetSoundset";
  
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetSoundset(object creature, int soundset)
 {
     string sFunc = "SetSoundset";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, soundset);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetSkillRank(object creature, int skill, int rank)
 {
     string sFunc = "SetSkillRank";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, rank);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, skill);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetClassByPosition(object creature, int position, int classID)
 {
     string sFunc = "SetClassByPosition";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, classID);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, position);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetLevelByPosition(object creature, int position, int level)
 {
     string sFunc = "SetLevelByPosition";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, position);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetBaseAttackBonus(object creature, int bab)
 {
     string sFunc = "SetBaseAttackBonus";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, bab);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetAttacksPerRound(object creature, int bBaseAPR = FALSE)
 {
     string sFunc = "GetAttacksPerRound";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, bBaseAPR);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetGender(object creature, int gender)
 {
     string sFunc = "SetGender";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, gender);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_RestoreFeats(object creature)
 {
     string sFunc = "RestoreFeats";
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_RestoreSpecialAbilities(object creature)
 {
     string sFunc = "RestoreSpecialAbilities";
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_RestoreSpells(object creature, int level = -1)
 {
     string sFunc = "RestoreSpells";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, level);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_RestoreItems(object creature)
 {
     string sFunc = "RestoreItems";
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetSize(object creature, int size)
 {
     string sFunc = "SetSize";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, size);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetSkillPointsRemaining(object creature)
 {
     string sFunc = "GetSkillPointsRemaining";
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
  
 void NWNX_Creature_SetSkillPointsRemaining(object creature, int skillpoints)
 {
     string sFunc = "SetSkillPointsRemaining";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, skillpoints);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetRacialType(object creature, int racialtype)
 {
     string sFunc = "SetRacialType";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, racialtype);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetMovementType(object creature)
 {
     string sFunc = "GetMovementType";
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetWalkRateCap(object creature, float fWalkRate = 2000.0f)
 {
     string sFunc = "SetWalkRateCap";
     NWNX_PushArgumentFloat(NWNX_Creature, sFunc, fWalkRate);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetGold(object creature, int gold)
 {
     string sFunc = "SetGold";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, gold);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetCorpseDecayTime(object creature, int nDecayTime)
 {
     string sFunc = "SetCorpseDecayTime";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nDecayTime);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
  
 int NWNX_Creature_GetBaseSavingThrow(object creature, int which)
 {
     string sFunc = "GetBaseSavingThrow";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, which);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetBaseSavingThrow(object creature, int which, int value)
 {
     string sFunc = "SetBaseSavingThrow";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, value);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, which);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_LevelUp(object creature, int class, int count=1)
 {
     string sFunc = "LevelUp";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, count);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, class);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_LevelDown(object creature, int count=1)
 {
     string sFunc = "LevelDown";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, count);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetChallengeRating(object creature, float fCR)
 {
     string sFunc = "SetChallengeRating";
     NWNX_PushArgumentFloat(NWNX_Creature, sFunc, fCR);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetAttackBonus(object creature, int isMelee = -1, int isTouchAttack = FALSE, int isOffhand = FALSE, int includeBaseAttackBonus = TRUE)
 {
     string sFunc = "GetAttackBonus";
  
     if (isMelee == -1)
     {
         object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, creature);
  
         if (GetIsObjectValid(oWeapon))
         {
             isMelee = !GetWeaponRanged(oWeapon);
         }
         else
         {// Default to melee for unarmed
             isMelee = TRUE;
         }
     }
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, includeBaseAttackBonus);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, isOffhand);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, isTouchAttack);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, isMelee);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetHighestLevelOfFeat(object creature, int feat)
 {
     string sFunc = "GetHighestLevelOfFeat";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, feat);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetFeatRemainingUses(object creature, int feat)
 {
     string sFunc = "GetFeatRemainingUses";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, feat);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetFeatTotalUses(object creature, int feat)
 {
     string sFunc = "GetFeatTotalUses";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, feat);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetFeatRemainingUses(object creature, int feat, int uses)
 {
     string sFunc = "SetFeatRemainingUses";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, uses);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, feat);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetTotalEffectBonus(object creature, int bonusType=NWNX_CREATURE_BONUS_TYPE_ATTACK, object target=OBJECT_INVALID, int isElemental=0, int isForceMax=0, int savetype=-1, int saveSpecificType=-1, int skill=-1, int abilityScore=-1, int isOffhand=FALSE)
 {
     string sFunc = "GetTotalEffectBonus";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, isOffhand);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, abilityScore);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, skill);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, saveSpecificType);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, savetype);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, isForceMax);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, isElemental);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, target);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, bonusType);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetOriginalName(object creature, string name, int isLastName)
 {
     string sFunc = "SetOriginalName";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, isLastName);
     NWNX_PushArgumentString(NWNX_Creature, sFunc, name);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 string NWNX_Creature_GetOriginalName(object creature, int isLastName)
 {
     string sFunc = "GetOriginalName";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, isLastName);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueString(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetSpellResistance(object creature, int sr)
 {
     string sFunc = "SetSpellResistance";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, sr);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetAnimalCompanionCreatureType(object creature, int type)
 {
     string sFunc = "SetAnimalCompanionCreatureType";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, type);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetFamiliarCreatureType(object creature, int type)
 {
     string sFunc = "SetFamiliarCreatureType";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, type);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetAnimalCompanionName(object creature, string name)
 {
     string sFunc = "SetAnimalCompanionName";
  
     NWNX_PushArgumentString(NWNX_Creature, sFunc, name);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetFamiliarName(object creature, string name)
 {
     string sFunc = "SetFamiliarName";
  
     NWNX_PushArgumentString(NWNX_Creature, sFunc, name);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetDisarmable(object creature)
 {
     string sFunc = "GetDisarmable";
  
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetDisarmable(object creature, int disarmable)
 {
     string sFunc = "SetDisarmable";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, disarmable);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetDomain(object creature, int class, int index)
 {
     WriteTimestampedLogEntry("NWNX_Creature: GetDomain() is deprecated. Please use the basegame's GetDomain() instead");
  
     return GetDomain(creature, index, class);
 }
  
 void NWNX_Creature_SetDomain(object creature, int class, int index, int domain)
 {
     string sFunc = "SetDomain";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, domain);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, index);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, class);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetSpecialization(object creature, int class)
 {
     WriteTimestampedLogEntry("NWNX_Creature: GetSpecialization() is deprecated. Please use the basegame's GetSpecialization() instead");
  
     return GetSpecialization(creature, class);
 }
  
 void NWNX_Creature_SetSpecialization(object creature, int class, int school)
 {
     string sFunc = "SetSpecialization";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, school);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, class);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, creature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetFaction(object oCreature, int nFactionId)
 {
     string sFunc = "SetFaction";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nFactionId);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetFaction(object oCreature)
 {
     string sFunc = "GetFaction";
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetFlatFooted(object oCreature)
 {
     string sFunc = "GetFlatFooted";
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 string NWNX_Creature_SerializeQuickbar(object oCreature)
 {
     string sFunc = "SerializeQuickbar";
  
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
  
     return NWNX_GetReturnValueString(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_DeserializeQuickbar(object oCreature, string sSerializedQuickbar)
 {
     string sFunc = "DeserializeQuickbar";
  
     NWNX_PushArgumentString(NWNX_Creature, sFunc, sSerializedQuickbar);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetCasterLevelModifier(object oCreature, int nClass, int nModifier, int bPersist = FALSE)
 {
     string sFunc = "SetCasterLevelModifier";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, bPersist);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nModifier);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nClass);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetCasterLevelModifier(object oCreature, int nClass)
 {
     string sFunc = "GetCasterLevelModifier";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nClass);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetCasterLevelOverride(object oCreature, int nClass, int nCasterLevel, int bPersist = FALSE)
 {
     string sFunc = "SetCasterLevelOverride";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, bPersist);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nCasterLevel);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nClass);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetCasterLevelOverride(object oCreature, int nClass)
 {
     string sFunc = "GetCasterLevelOverride";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nClass);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_JumpToLimbo(object oCreature)
 {
     string sFunc = "JumpToLimbo";
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetCriticalMultiplierModifier(object oCreature, int nModifier, int nHand = 0, int bPersist = FALSE, int nBaseItem = -1)
 {
     string sFunc = "SetCriticalMultiplierModifier";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nBaseItem);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, bPersist);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nHand);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nModifier);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetCriticalMultiplierModifier(object oCreature, int nHand = 0, int nBaseItem = -1)
 {
     string sFunc = "GetCriticalMultiplierModifier";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nBaseItem);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nHand);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetCriticalMultiplierOverride(object oCreature, int nOverride, int nHand = 0, int bPersist = FALSE, int nBaseItem = -1)
 {
     string sFunc = "SetCriticalMultiplierOverride";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nBaseItem);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, bPersist);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nHand);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nOverride);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetCriticalMultiplierOverride(object oCreature, int nHand = 0, int nBaseItem = -1)
 {
     string sFunc = "GetCriticalMultiplierOverride";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nBaseItem);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nHand);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetCriticalRangeModifier(object oCreature, int nModifier, int nHand = 0, int bPersist = FALSE, int nBaseItem = -1)
 {
     string sFunc = "SetCriticalRangeModifier";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nBaseItem);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, bPersist);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nHand);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nModifier);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetCriticalRangeModifier(object oCreature, int nHand = 0, int nBaseItem = -1)
 {
     string sFunc = "GetCriticalRangeModifier";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nBaseItem);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nHand);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetCriticalRangeOverride(object oCreature, int nOverride, int nHand = 0, int bPersist = FALSE, int nBaseItem = -1)
 {
     string sFunc = "SetCriticalRangeOverride";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nBaseItem);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, bPersist);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nHand);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nOverride);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetCriticalRangeOverride(object oCreature, int nHand = 0, int nBaseItem = -1)
 {
     string sFunc = "GetCriticalRangeOverride";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nBaseItem);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nHand);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_AddAssociate(object oCreature, object oAssociate, int nAssociateType)
 {
     string sFunc = "AddAssociate";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nAssociateType);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oAssociate);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
  
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetEffectIconFlashing(object oCreature, int nIconId, int bFlashing)
 {
     string sFunc = "SetEffectIconFlashing";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, bFlashing);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nIconId);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_OverrideDamageLevel(object oCreature, int nDamageLevel)
 {
     string sFunc = "OverrideDamageLevel";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nDamageLevel);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetEncounter(object oCreature, object oEncounter)
 {
     string sFunc = "SetEncounter";
  
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oEncounter);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 object NWNX_Creature_GetEncounter(object oCreature)
 {
     string sFunc = "GetEncounter";
  
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
  
     return NWNX_GetReturnValueObject(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetIsBartering(object oCreature)
 {
     string sFunc = "GetIsBartering";
  
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetLastItemCasterLevel(object oCreature, int nCasterLvl)
 {
     string sFunc = "SetLastItemCasterLevel";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nCasterLvl);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
  
 int NWNX_Creature_GetLastItemCasterLevel(object oCreature)
 {
     string sFunc = "GetLastItemCasterLevel";
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetArmorClassVersus(object oAttacked, object oVersus, int nTouch=FALSE)
 {
     string sFunc = "GetArmorClassVersus";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nTouch);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oVersus);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oAttacked);
     NWNX_CallFunction(NWNX_Creature, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetWalkAnimation(object oCreature)
 {
     string sFunc = "GetWalkAnimation";
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetWalkAnimation(object oCreature, int nAnimation)
 {
     string sFunc = "SetWalkAnimation";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nAnimation);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetAttackRollOverride(object oCreature, int nRoll, int nModifier)
 {
     string sFunc = "SetAttackRollOverride";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nModifier);
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, nRoll);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetParryAllAttacks(object oCreature, int bParry)
 {
     string sFunc = "SetParryAllAttacks";
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, bParry);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 int NWNX_Creature_GetNoPermanentDeath(object oCreature)
 {
     string sFunc = "GetNoPermanentDeath";
  
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
  
     return NWNX_GetReturnValueInt(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetNoPermanentDeath(object oCreature, int bNoPermanentDeath)
 {
     string sFunc = "SetNoPermanentDeath";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, bNoPermanentDeath);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 vector NWNX_Creature_ComputeSafeLocation(object oCreature, vector vPosition, float fRadius = 20.0f, int bWalkStraightLineRequired = TRUE)
 {
     string sFunc = "ComputeSafeLocation";
  
     NWNX_PushArgumentInt(NWNX_Creature, sFunc, bWalkStraightLineRequired);
     NWNX_PushArgumentFloat(NWNX_Creature, sFunc, fRadius);
     NWNX_PushArgumentFloat(NWNX_Creature, sFunc, vPosition.x);
     NWNX_PushArgumentFloat(NWNX_Creature, sFunc, vPosition.y);
     NWNX_PushArgumentFloat(NWNX_Creature, sFunc, vPosition.z);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
  
     vector v;
     v.z = NWNX_GetReturnValueFloat(NWNX_Creature, sFunc);
     v.y = NWNX_GetReturnValueFloat(NWNX_Creature, sFunc);
     v.x = NWNX_GetReturnValueFloat(NWNX_Creature, sFunc);
  
     return v;
 }
  
 void NWNX_Creature_DoPerceptionUpdateOnCreature(object oCreature, object oTargetCreature)
 {
     string sFunc = "DoPerceptionUpdateOnCreature";
  
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oTargetCreature);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 float NWNX_Creature_GetPersonalSpace(object oCreature)
 {
     string sFunc = "GetPersonalSpace";
  
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
  
     return NWNX_GetReturnValueFloat(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetPersonalSpace(object oCreature, float fPerspace)
 {
     string sFunc = "SetPersonalSpace";
  
     NWNX_PushArgumentFloat(NWNX_Creature, sFunc, fPerspace);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 float NWNX_Creature_GetCreaturePersonalSpace(object oCreature)
 {
     string sFunc = "GetCreaturePersonalSpace";
  
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
  
     return NWNX_GetReturnValueFloat(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetCreaturePersonalSpace(object oCreature, float fCrePerspace)
 {
     string sFunc = "SetCreaturePersonalSpace";
  
     NWNX_PushArgumentFloat(NWNX_Creature, sFunc, fCrePerspace);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 float NWNX_Creature_GetHeight(object oCreature)
 {
     string sFunc = "GetHeight";
  
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
  
     return NWNX_GetReturnValueFloat(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetHeight(object oCreature, float fHeight)
 {
     string sFunc = "SetHeight";
  
     NWNX_PushArgumentFloat(NWNX_Creature, sFunc, fHeight);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 float NWNX_Creature_GetHitDistance(object oCreature)
 {
     string sFunc = "GetHitDistance";
  
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
  
     return NWNX_GetReturnValueFloat(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetHitDistance(object oCreature, float fHitDist)
 {
     string sFunc = "SetHitDistance";
  
     NWNX_PushArgumentFloat(NWNX_Creature, sFunc, fHitDist);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }
  
 float NWNX_Creature_GetPreferredAttackDistance(object oCreature)
 {
     string sFunc = "GetPreferredAttackDistance";
  
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
  
     return NWNX_GetReturnValueFloat(NWNX_Creature, sFunc);
 }
  
 void NWNX_Creature_SetPreferredAttackDistance(object oCreature, float fPrefAtckDist)
 {
     string sFunc = "SetPreferredAttackDistance";
  
     NWNX_PushArgumentFloat(NWNX_Creature, sFunc, fPrefAtckDist);
     NWNX_PushArgumentObject(NWNX_Creature, sFunc, oCreature);
     NWNX_CallFunction(NWNX_Creature, sFunc);
 }

