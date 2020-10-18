#include "inc_common"
#include "inc_pc"

const string GS_TEMPLATE_CORPSE_FEMALE = "gs_item016";
const string GS_TEMPLATE_CORPSE_MALE   = "gs_item017";

void main()
{
    object oUsedBy = GetLastUsedBy();
    if (! GetIsPC(oUsedBy)) return;
	
    string sTarget = GetLocalString(OBJECT_SELF, "GS_TARGET");
    int nGender    = GetLocalInt(OBJECT_SELF, "GS_GENDER");
    int nSize      = GetLocalInt(OBJECT_SELF, "GS_SIZE");

    object oCorpse = CreateItemOnObject(nGender == GENDER_FEMALE ?
                                        GS_TEMPLATE_CORPSE_FEMALE :
                                        GS_TEMPLATE_CORPSE_MALE,
                                        oUsedBy);

    if (GetIsObjectValid(oCorpse))
    {
        switch (nSize)
        {
        case CREATURE_SIZE_HUGE:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS),
                            oCorpse);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS),
                            oCorpse);
            break;

        case CREATURE_SIZE_LARGE:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS),
                            oCorpse);
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_50_LBS),
                            oCorpse);
            break;

        case CREATURE_SIZE_MEDIUM:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_100_LBS),
                            oCorpse);
            break;

        case CREATURE_SIZE_SMALL:
            AddItemProperty(DURATION_TYPE_PERMANENT,
                            ItemPropertyWeightIncrease(IP_CONST_WEIGHTINCREASE_50_LBS),
                            oCorpse);
            break;

        case CREATURE_SIZE_TINY:
            break;
        }

        SetLocalString(oCorpse, "GS_TARGET", sTarget);
        SetLocalInt(oCorpse, "GS_GENDER", nGender);
        SetLocalInt(oCorpse, "GS_SIZE", nSize);
        SetLocalObject(gsPCGetPlayerByID(sTarget), "GS_CORPSE", oCorpse);
        SetLocalInt(oCorpse, "GS_GOLD", GetLocalInt(OBJECT_SELF, "GS_GOLD"));
    }

    DestroyObject(OBJECT_SELF);
}
