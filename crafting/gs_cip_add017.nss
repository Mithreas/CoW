#include "inc_iprop"
#include "inc_token"

int StartingConditional()
{
    if (GetLocalInt(GetModule(), "GS_IP_ENABLED"))
    {
        object oItem = GetFirstItemInInventory();
		object oPC   = GetPCSpeaker();

        if (GetIsObjectValid(oItem))
        {
            //property
            int nStrRef    = GetLocalInt(OBJECT_SELF, "GS_PROPERTY_STRREF");
            string sString = GetStringByStrRef(nStrRef);

            SetCustomToken(105, sString + "\n");

            //subtype
            nStrRef        = GetLocalInt(OBJECT_SELF, "GS_SUBTYPE_STRREF");
            sString        = GetStringByStrRef(nStrRef);

            SetCustomToken(106, sString + "\n");

            int nTableID   = gsIPGetTableID("itempropdef");
            int nNth       = GetLocalInt(OBJECT_SELF, "GS_PROPERTY");
            nTableID       = gsIPGetValue(nTableID, nNth, "COSREF");
            int nCount     = gsIPGetCount(nTableID);

            if (nCount)
            {
				int nDisabled;
				int bDisabled;
                int nSlot = 0;
                int nID   = 0;
                nNth      = GetLocalInt(OBJECT_SELF, "GS_OFFSET_3");
                nCount    = nNth + 5;

                for (; nNth < nCount; nNth++)
                {
                    sString = "GS_SLOT_" + IntToString(++nSlot) + "_";
                    nStrRef = gsIPGetValue(nTableID, nNth, "STRREF");

					//------------------------------------------------------------
					// Check for special values of "DISABLED" (GS_IP_DISABLED in
					// the 2da).
					// 2 = need spell focus: enchantment to unlock property.
					// 3 = need greater spell focus.
					// 4 = need epic spell focus.
					//------------------------------------------------------------
					nDisabled = gsIPGetValue(nTableID, nNth, "DISABLED");
					
					bDisabled = FALSE;
					
					if (nDisabled == 2 && !GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, oPC))         bDisabled = TRUE;
					if (nDisabled == 3 && !(GetHitDice(oPC) >= 15 && GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oPC))) bDisabled = TRUE;
					if (nDisabled == 4 && !GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oPC))    bDisabled = TRUE;
										
                    if (nStrRef && !bDisabled)
                    {
					    gsTKSetToken(99 + nSlot, GetStringByStrRef(nStrRef));

                        nID = gsIPGetValue(nTableID, nNth, "ID");

                        SetLocalInt(OBJECT_SELF, sString + "ID", nID);
                        SetLocalInt(OBJECT_SELF, sString + "STRREF", nStrRef);
                    }
                    else
                    {
                        SetLocalInt(OBJECT_SELF, sString + "STRREF", -1);
                    }
                }

                return TRUE;
            }
        }
    }

    return FALSE;
}
