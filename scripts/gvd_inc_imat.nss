/* function to try and find the item material of weapons and armor */

// 1 = bronze
// 2 = iron
// 3 = steel
// 4 = greensteel
// 5 = damask
// 6 = mithril
// 7 = adamantine

#include "x2_inc_itemprop"

string gvd_StringReplace(string sOrig, string sSearch, string sReplace);
int gvd_GetItemMaterial(object oItem);

string gvd_StringReplace(string sOrig, string sSearch, string sReplace) {
 
    int nPosition = 0;

    nPosition = FindSubString(GetStringUpperCase(sOrig), GetStringUpperCase(sSearch));

    while (nPosition != -1) {
      sOrig = GetStringLeft(sOrig, nPosition) + sReplace + GetStringRight(sOrig, GetStringLength(sOrig) - nPosition - GetStringLength(sSearch));
      nPosition = FindSubString(GetStringUpperCase(sOrig), GetStringUpperCase(sSearch));
    }

    return sOrig;
}

int gvd_GetItemMaterial(object oItem)
{

  itemproperty ip;
  int iMat = 0; // unknown

  if (IPGetIsMeleeWeapon(oItem)) {
    // melee weapon

    iMat = 1; // bronze
    int iAttackBonus = 0;
    int iKeen = 0;
    int iLight = 0;

    ip = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(ip))
    {
      // only check permanent properties
      if (GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT) {

        if ((GetItemPropertyType(ip) == ITEM_PROPERTY_ATTACK_BONUS) ||  (GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS)) {
          iAttackBonus = GetItemPropertyCostTableValue(ip);
        }      
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_KEEN) {
          iKeen = 1;
        }
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_LIGHT) {
          iLight = 1;
        }
      }

      ip = GetNextItemProperty(oItem);
    }    

    // determine weapon material
    if (iAttackBonus == 1) {
      // iron
      iMat = 2;
    } else if (iAttackBonus == 2) {
      // steel
      iMat = 3;
    }  else if (iAttackBonus == 3) {
      if ((iKeen == 1) && (iLight == 1)) {
        // probably greensteel
        iMat = 4;
      } else {
        // probably damask
        iMat = 5;
      }
    }

  //} else if (IPGetIsRangedWeapon(oItem)) {
  //  // ranged weapon

  } else if ((GetBaseItemType(oItem) == BASE_ITEM_ARMOR) || (GetBaseItemType(oItem) == BASE_ITEM_HELMET) || (GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD) || (GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD) || (GetBaseItemType(oItem) == BASE_ITEM_TOWERSHIELD)) {
    // armor, helmet, shield

    iMat = 1; // bronze
    int iACBonus = 0;
    int iImmunityDamage = 0;
    int iArcaneSpell = 0;

    ip = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(ip))
    {
      // only check permanent properties
      if (GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT) {

        if ((GetItemPropertyType(ip) == ITEM_PROPERTY_AC_BONUS)) {
          iACBonus = GetItemPropertyCostTableValue(ip);
        }      
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE) {
          iImmunityDamage = 1;
        }
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_ARCANE_SPELL_FAILURE) {
          iArcaneSpell = 1;
        }
      }

      ip = GetNextItemProperty(oItem);
    }    

    // determine weapon material
    if (iACBonus == 0) {
      if (iImmunityDamage == 1) {
        // iron (or a bronze shield, not a big deal)
        iMat = 1;
      }
    } else if (iACBonus == 1) {
      // steel
      iMat = 2;
    } else if (iACBonus == 2) {
      if (iImmunityDamage == 1) {
        // probably mithril
        iMat = 6;
      } else {
        // probably greensteel
        iMat = 4;
      }
    } else if (iACBonus == 3) {
      if ((iImmunityDamage == 1) && (iArcaneSpell == 0)) {
        // adamantine
        iMat = 7;
      } else {
        // probably greensteel
        iMat = 4;
      }
    }

  }

  return iMat;

}
