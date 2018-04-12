// Create treasure on oCorpse, if oSearcher is not an invalid object, we're performing a search check for bonus loot.
#include "inc_common"

const string GOLD_TEMPLATE       = "nw_it_gold001";

// From the provided actualCr, determines the gold CR.
int DetermineGoldCR(float actualCr);

void gsTRCreateTreasure(object oCorpse, int nRacialType, float fCR, int nStolen, int nStolenGold, object oSearcher);

int DetermineGoldCR(float actualCr)
{
    int goldCr = 0;
    while (actualCr > 0.0f)
    {
        goldCr += 1;

        if (goldCr == 15)
        {
            break;
        }
        else if (goldCr > 13)
        {
            actualCr -= 4.0f;
        }
        else if (goldCr > 10)
        {
            actualCr -= 3.0f;
        }
        else if (goldCr > 7)
        {
            actualCr -= 2.0f;
        }
        else
        {
            actualCr -= 1.0f;
        }
    }

    return goldCr;
}

void gsTRCreateTreasure(object oCorpse, int nRacialType, float fCR, int nStolen, int nStolenGold, object oSearcher)
{
  object oInventory = GetObjectByTag("GS_INVENTORY_" + IntToString(nRacialType));

  if (GetIsObjectValid(oInventory))
  {
    int nCount = GetLocalInt(oInventory, "FB_CO_TREASURE_COUNT");

    if (nCount > 0)
    {
      if ( fCR > 18.0 ) fCR = 18.0;
      int nRating = FloatToInt(pow(fCR, 2.0));
      int nRandom = 0;
      int nItemSelector = 0;
      int nTotalItemsGenerated = 0;
      int nValue  = 0;
      int nI      = 0;
      int nGoldCR = FloatToInt(pow(IntToFloat(DetermineGoldCR(fCR)), 2.0));
      int nGold   = GetLocalInt(GetModule(), "STATIC_LEVEL") ? 0 : Random(nGoldCR) - nStolenGold;
      object oItem;
      object oCopy;

      int bBonusLootFound = FALSE;
      int bBonusSearch = (GetIsObjectValid(oSearcher));

      // int nMaxItems = d2() + !bBonusSearch;
      int nMaxItems = 1 + !bBonusSearch;

      nRating *= 10;

      for (; nI < nCount; nI++)
      {
        nRandom = Random(100);
        nItemSelector = Random(nCount);
        if (nRandom >= 90 || (bBonusSearch && GetSkillRank(SKILL_SEARCH, oSearcher) > Random(100)))
        {
          oItem  = GetLocalObject(oInventory, "FB_CO_TREASURE_" + IntToString(nItemSelector));
          nValue = gsCMGetItemValue(oItem);
          if (nRandom == 99 || nValue <= nRating)
          {
            // Item was actually pickpocketed
            if (nStolen > 0)
            {
              nStolen--;
            }
            else
            {
              oCopy  = gsCMCopyItem(oItem, oCorpse);
              nTotalItemsGenerated++;
              if (bBonusSearch) bBonusLootFound = TRUE;
              if(GetIsItemMundane(oItem)) SetIsItemMundane(oCopy, TRUE);
              if (GetIsObjectValid(oCopy))
              {
                SetIdentified(oCopy, nValue <= 100);
              }
            }
          }
        }
        if (nTotalItemsGenerated >= nMaxItems || bBonusSearch) {
          if (bBonusLootFound) SendMessageToPC(oSearcher, "Your searching has produced some extra items");
          break;
        }
      }

      // Removed and replaced with gold dispensed when the carcass is opened,
      // scaling gold drops with party size.
      if (nGold > 0 && !bBonusSearch) {
        CreateItemOnObject(GOLD_TEMPLATE, oCorpse, nGold);
      }

    }
  }
}
//----------------------------------------------------------------
