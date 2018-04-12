/*
    Filename: inc_bloodstains
    Author: Barking_Mad
    Created: 8/11/2008
    Modified: 8/11/2008
    Description: Include file for PC blood spillage cleanup methods, associated with
                    the placement and cleanup operations of player blood from
                    fights and deaths.

    Notes: When a blood patch is created it is given a time of creation which
            is chek against by cleanup operations to see if its valid for removal.
            If its valid the player makes some rolls to see if cleanup was a success.
            If it was, the blood patch is removed and replaced with a water patch which
            then automatically dries (deletes itself) after a sjort period.

    Requirements: Two placeable objects, one based on the battlefield bloodstain and the
                    other based on the misc puddle. Both the tag and resref should match
                    and can be set in the constants.
                  One Item object. A pale or bucket item, with a specific tag and resref which match
                    exactly and can be modified in the constant, if using item tag scripts the script needs
                    to be correspondingly named.
                  Placement of blood spill creation function call into relevant events (death etc).


    TODO:   Water puddle evaporation rate which is dependant on weather conditions. Need to look at arelith hooks.
    TODO:   Modify the chance of success in cleaning up, to add a bit of variety
    TODO:   Tweek timings

    BM: MODIFIED: Modified to work with gs_ timesystem, replacing all bm_inc_common code with arelith specific calls
*/
#include "inc_time"
#include "inc_subrace"
#include "inc_divination"

///////////////////////////////////////////////////////////////////////////////
// Constants
///////////////////////////////////////////////////////////////////////////////
const float BM_BLOOD_CLEANUP_RANGE = 5.0f;       //5m range for detecting cleanup candidates
const int BM_BLOOD_MIN_LIFETIME = 0;            //Number of in-game hours that a blood stain will remain uncleannable
const int BM_BLOOD_WATER_MIN_LIFETIME = 2;      //Number of in-game rounds a cleanup puddle will live in normal conditions
const string BM_BLOOD_STAIN_PLC_RESREF = "bm_plc_blood_bc";    //The resource refrence of the blood stain placeable
const string BM_BLOOD_WATER_PLC_RESREF = "bm_plc_water_bc";    //The resource refrence of the blood cleanup water placeable
const string BM_BLOOD_EXPIRES_TIME_VAR = "BM_LV_STR_EXPIRY_TIME";  //Name of the variable to look for for checking when a blood spill was born/created

///////////////////////////////////////////////////////////////////////////////
// Function Decleration
///////////////////////////////////////////////////////////////////////////////

//Test if a given bloodstain is old enough to be considered for removal, Returns -1 on error, true or false.
int BMIsBloodStainExpired( object oBloodStain );

//Create a bloodstain at a location and assign it a new lifetime value.  Save information about the attacker and victim for investigators.
object BMCreateBloodStainAtLocation( object oBleeder, object oAttacker, string sDamageType);

//Creates a temporary and short lived water puddle at the location of a blood spill cleanup, which will self destruct after n rounds
void BMCreateBloodWaterPuddleAtLocation( location lPosition, int nLifetime=BM_BLOOD_MIN_LIFETIME );

//Get the first bloodstain in range of oPlayer that we can check for cleanup
object BMGetNearestBloodStain( object oPlayer );

//Action tells oPlayer to cleanup the blood spilled oBloodStain, this will cause the player to move to and run animations
void BMActionCleanupBloodStain( object oActor, object oBloodStain );

//get the number of ingame hours remaining till a blood patch can be cleaned
int BMGetBloodExpiryHours( object oBloodStain );

//return information about the bloodstain, based on the investigator's Search and Lore skills.
string BMGetBloodStainDetails( object oInvestigator, object oBloodStain );

//void main(){}

// Dunshine: moved these 2 functions below here from gs_m_dying, so they can be included elsewhere as well

string _GetWeaponDamageType(object oWeapon)
{
  int nType = GetBaseItemType(oWeapon);

  switch (nType)
  {
    case BASE_ITEM_BASTARDSWORD:
    case BASE_ITEM_BATTLEAXE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_DWARVENWARAXE:
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HANDAXE:
    case BASE_ITEM_KAMA:
    case BASE_ITEM_KATANA:
    case BASE_ITEM_KUKRI:
    case BASE_ITEM_LONGSWORD:
    case BASE_ITEM_SCIMITAR:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SICKLE:
    case BASE_ITEM_THROWINGAXE:
    case BASE_ITEM_TWOBLADEDSWORD:
    case BASE_ITEM_WHIP:
      return "Slashing";
    case BASE_ITEM_DAGGER:
    case BASE_ITEM_DART:
    case BASE_ITEM_HEAVYCROSSBOW:
    case BASE_ITEM_LIGHTCROSSBOW:
    case BASE_ITEM_LONGBOW:
    case BASE_ITEM_RAPIER:
    case BASE_ITEM_SHORTSPEAR:
    case BASE_ITEM_SHORTBOW:
    case BASE_ITEM_SHORTSWORD:
    case BASE_ITEM_SHURIKEN:
    case BASE_ITEM_TRIDENT:
      return "Piercing";
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_INVALID:
    case BASE_ITEM_LIGHTFLAIL:
    case BASE_ITEM_LIGHTHAMMER:
    case BASE_ITEM_LIGHTMACE:
    case BASE_ITEM_MAGICSTAFF:
    case BASE_ITEM_MORNINGSTAR:
    case BASE_ITEM_QUARTERSTAFF:
    case BASE_ITEM_SLING:
    case BASE_ITEM_WARHAMMER:
      return "Bludgeoning";
  }

  return "Bludgeoning";
}

string _GetLargestDamageDealt(object oVictim)
{
  //----------------------------------------------------------------------------
  // Monster hack since GetDamageDealtByType only registers EffectDamage
  // and not standard melee damage.  Damn.
  // Logic as follows.
  // 1.  find the killer
  // 2.  if they're next to us and have a melee weapon equipped, use the damage
  //     type of that weapon.
  // 3.  if they have a ranged weapon equipped, use the damage type of that
  //     weapon
  // 4.  else assume death by spell; ExecuteScript something to populate the
  //     damage dealt to the caller of different types and return that.
  //----------------------------------------------------------------------------
  object oKiller = GetLastHostileActor(oVictim);
  //SendMessageToPC(oKiller, "Distance: " + FloatToString(GetDistanceBetween(oKiller, oVictim)));
  object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oKiller);

  if (GetDistanceBetween(oKiller, oVictim) < 2.5 && IPGetIsMeleeWeapon(oWeapon))
  {
    return _GetWeaponDamageType(oWeapon);
  }
  else if (!IPGetIsMeleeWeapon(oWeapon))
  {
    return _GetWeaponDamageType(oWeapon);
  }
  else
  {
    ExecuteScript("mi_getdamagetype", oVictim);
    return GetLocalString(oVictim, "MI_DAMAGE_TYPE");
  }
}


int BMGetHighestClass(object oCreature)
{
  int nClass1 = GetLevelByPosition(1, oCreature);
  int nClass2 = GetLevelByPosition(2, oCreature);
  int nClass3 = GetLevelByPosition(3, oCreature);


  if (nClass1 >= nClass2 && nClass1 >= nClass3) return GetClassByPosition(1, oCreature);
  if (nClass2 >= nClass1 && nClass2 >= nClass3) return GetClassByPosition(2, oCreature);
  if (nClass3 >= nClass1 && nClass3 >= nClass2) return GetClassByPosition(3, oCreature);

  return GetClassByPosition(1, oCreature);
}

string BMGetClassName(int nClass)
{
  switch (nClass)
  {
    case CLASS_TYPE_ABERRATION:
      return "Aberration";
    case CLASS_TYPE_ANIMAL:
      return "Animal";
    case CLASS_TYPE_ARCANE_ARCHER:
      return "Arcane Archer";
    case CLASS_TYPE_BARBARIAN:
    case CLASS_TYPE_RANGER:
    case CLASS_TYPE_FIGHTER:
    case CLASS_TYPE_DWARVEN_DEFENDER:
    case CLASS_TYPE_HARPER:
    case CLASS_TYPE_HUMANOID:
    case CLASS_TYPE_WEAPON_MASTER:
      return "Warrior";
    case CLASS_TYPE_BARD:
      return "Bard";
    case CLASS_TYPE_COMMONER:
      return "Peasant";
    case CLASS_TYPE_CONSTRUCT:
      return "Construct";
    case CLASS_TYPE_DIVINE_CHAMPION:
    case CLASS_TYPE_BLACKGUARD:
    case CLASS_TYPE_CLERIC:
    case CLASS_TYPE_PALADIN:
      return "Holy Warrior";
    case CLASS_TYPE_DRAGON:
    case CLASS_TYPE_DRAGON_DISCIPLE:
      return "Dragon";
    case CLASS_TYPE_DRUID:
    case CLASS_TYPE_SHIFTER:
      return "Druid";
    case CLASS_TYPE_ELEMENTAL:
    case CLASS_TYPE_OUTSIDER:
      return "Outsider";
    case CLASS_TYPE_FEY:
      return "Fey";
    case CLASS_TYPE_GIANT:
    case CLASS_TYPE_MONSTROUS:
      return "Monster";
      return "Humanoid";
    case CLASS_TYPE_MAGICAL_BEAST:
    case CLASS_TYPE_BEAST:
      return "Beast";
    case CLASS_TYPE_MONK:
      return "Monk";
    case CLASS_TYPE_OOZE:
      return "Ooze";
    case CLASS_TYPE_PALE_MASTER:
      return "Aberration";
    case CLASS_TYPE_PURPLE_DRAGON_KNIGHT:
      return "Aberration";
    case CLASS_TYPE_ROGUE:
    case CLASS_TYPE_ASSASSIN:
    case CLASS_TYPE_SHADOWDANCER:
      return "Rogue";
    case CLASS_TYPE_SHAPECHANGER:
      return "Shapechanger";
    case CLASS_TYPE_SORCERER:
    case CLASS_TYPE_WIZARD:
      return "Mage";
    case CLASS_TYPE_UNDEAD:
      return "Undead";
    case CLASS_TYPE_VERMIN:
      return "Vermin";
  }

  return "Unknown";
}

///////////////////////////////////////////////////////////////////////////////
// Function Implementation
///////////////////////////////////////////////////////////////////////////////

object BMCreateBloodStainAtLocation( object oBleeder, object oAttacker, string sDamageType )
{
    //Create the blood patch
    object oBlood = CreateObject( OBJECT_TYPE_PLACEABLE, BM_BLOOD_STAIN_PLC_RESREF, GetLocation(oBleeder) );

    //creation was success, mark the creation time so we can check expiry of the patch
    if( GetIsObjectValid( oBlood ) )
    {
        //Set blood expiry time
        int nExpires = gsTIGetActualTimestamp() + 10*FloatToInt( HoursToSeconds( BM_BLOOD_MIN_LIFETIME ) );
        SetLocalInt( oBlood, BM_BLOOD_EXPIRES_TIME_VAR, nExpires );

        SetLocalString(oBlood, "BM_ATTACKER_RACE", GetSubRace(oAttacker) == "" ? gsSUGetRaceName(GetRacialType(oAttacker)): GetSubRace(oAttacker));
        SetLocalString(oBlood, "BM_VICTIM_RACE", GetSubRace(oBleeder) == "" ? gsSUGetRaceName(GetRacialType(oBleeder)): GetSubRace(oBleeder));
        SetLocalInt(oBlood, "BM_ATTACKER_CLASS", BMGetHighestClass(oAttacker));
        SetLocalInt(oBlood, "BM_VICTIM_CLASS", BMGetHighestClass(oBleeder));
        SetLocalString(oBlood, "BM_DAMAGE_TYPE", sDamageType);
        SetLocalString(oBlood, "BM_ATTACKER_ATTUNEMENT", miDVGetAttunement(oAttacker));
        SetLocalString(oBlood, "BM_VICTIM_ATTUNEMENT", miDVGetAttunement(oBleeder));
    }

    return oBlood;
}

void BMCreateBloodWaterPuddleAtLocation( location lLocation, int nLifetime )
{
    object oPuddle = CreateObject( OBJECT_TYPE_PLACEABLE, BM_BLOOD_WATER_PLC_RESREF, lLocation, TRUE );

    if( GetIsObjectValid( oPuddle ) )
    {
        //success - now calculate the puddle lifetime and tell it to evaporate

        //Element of randomness to puddle duration
        float fLifetime = IntToFloat( d6( BM_BLOOD_MIN_LIFETIME ) );

        //Calculate the weather conditions, modify the liftime accordingly
        //

        //Tell the puddle to self destroy in the time
        DestroyObject( oPuddle, fLifetime );
    }

    //return oPuddle;
}

int BMIsBloodStainExpired( object oBloodStain )
{
    if( gsTIGetActualTimestamp() > GetLocalInt( oBloodStain, BM_BLOOD_EXPIRES_TIME_VAR ) )
    {
        return TRUE;
    }

    return FALSE;
}

object BMGetNearestBloodStain( object oPlayer )
{
    object oBlood = GetNearestObjectByTag( BM_BLOOD_STAIN_PLC_RESREF, oPlayer );

    if( GetIsObjectValid( oBlood ) )
    {
        //Only consider if its the correct placeable and its marked with bloodstain timer
        if( GetResRef( oBlood ) == BM_BLOOD_STAIN_PLC_RESREF )
        {
            float fDist = GetDistanceBetween( oPlayer, oBlood );

            /*BMDebug( "Potential blood stain found: " + ObjectToString( oBlood ) +
                     " Object Tag: " + GetTag( oBlood ) +
                     " Object Name: " + GetName( oBlood ) +
                     " Object ResRef: " + GetResRef( oBlood ) +
                     " Dist: " + FloatToString( fDist,6,2 ) );*/

            if( fDist <= BM_BLOOD_CLEANUP_RANGE ) return oBlood;
        }
    }

    return OBJECT_INVALID;
}

void BMActionCleanupBloodStain( object oActor, object oBloodStain )
{
    //Move the player over to the object
    AssignCommand( oActor, ActionMoveToObject( oBloodStain, FALSE, 0.1 ) );
    AssignCommand( oActor, SetFacingPoint( GetPositionFromLocation( GetLocation( oBloodStain ) ) ) );

    ///Speak the cleanup string
    string sComment;

    switch( d6(1) )
    {
        case 1: sComment = "*Pulls out a bucket and brush and scrubs at the bloodstain*";
            break;
        case 2: sComment = "*Cleans up the spillage with some rags and warm water*";
            break;
        default: sComment = "*Scrubs away at the bloodstain with a stiff scrubbing brush*";
            break;
    }

    AssignCommand( oActor, ActionSpeakString( sComment ) );

    location lCleanup = GetLocation( oBloodStain );

    //Delete the object
    DestroyObject( oBloodStain, 3.0 );

    //Play the player animation
    AssignCommand( oActor, ActionPlayAnimation( ANIMATION_LOOPING_GET_LOW, 2.0, IntToFloat( d6( 6 ) ) ) );

    //Create the water placeable
    AssignCommand( oActor, DelayCommand( 6.0, BMCreateBloodWaterPuddleAtLocation( lCleanup ) ) );
}

string BMGetBloodStainDetails( object oInvestigator, object oBloodStain )
{
   int nSearch = GetSkillRank(SKILL_SEARCH, oInvestigator);
   int nLore   = GetSkillRank(SKILL_LORE, oInvestigator);

   string sAttRace = GetLocalString(oBloodStain, "BM_ATTACKER_RACE");
   string sVicRace = GetLocalString(oBloodStain, "BM_VICTIM_RACE");
   int nAttClass   = GetLocalInt(oBloodStain, "BM_ATTACKER_CLASS");
   int nVicClass   = GetLocalInt(oBloodStain, "BM_VICTIM_CLASS");
   string sDamageType = GetLocalString(oBloodStain, "BM_DAMAGE_TYPE");
   string sAttAtt = GetLocalString(oBloodStain, "BM_ATTACKER_ATTUNEMENT");
   string sVicAtt = GetLocalString(oBloodStain, "BM_VICTIM_ATTUNEMENT");

   string sMessage;

   if (nSearch >= 5 && nLore >= 5)
   {
     sMessage = "The victim was killed by " + sDamageType + " damage.";
   }
   else if (!GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINATION, oInvestigator))
   {
     sMessage = "You can't really tell much about what happened.";
   }

   if (nSearch >= 20 && nLore >= 20)
   {
     sMessage += "\n\nFrom the tracks, blood type and other signs, you think " +
     "that the victim was a " + sVicRace + " and the attacker a " + sAttRace + ".";
   }

   if (nSearch >= 30 && nLore >= 30)
   {
     string sAttClass = BMGetClassName(nAttClass);
     string sVicClass = BMGetClassName(nVicClass);
     sMessage += "\n\nReading the signs of the fight in more detail, you think " +
     "that the victim was a(n) " + sVicClass + " and the attacker a(n) " + sAttClass + ".";
   }

   if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINATION, oInvestigator))
   {
     sMessage += "\n\nThe attacker was attuned to " + sAttAtt + " and the defender to " +
      sVicAtt + ".";
   }

   return sMessage;
}
