#include "inc_common"
#include "inc_xp"

void main()
{
    object oSpeaker = GetPCSpeaker();
    object oItem    = GetFirstItemInInventory(oSpeaker);
    int nValue      = 0;

    // Do a persuade check opposed by concentration to modify the bounty.
	int nRandom = (NWNX_Creature_GetKnowsFeat(oSpeaker, FEAT_SKILL_MASTERY) ? 10 : d10());
    int nSkillCheck = (GetSkillRank(SKILL_PERSUADE, oSpeaker) + nRandom) -
                       (GetSkillRank(SKILL_CONCENTRATION, OBJECT_SELF) + d10());
                      

    if (nSkillCheck > 20)  nSkillCheck = 20;
    if (nSkillCheck < -20) nSkillCheck = -20;

    while (GetIsObjectValid(oItem))
    {
        if (GetStringLeft(GetTag(oItem), 12) == "GS_HEAD_EVIL")
        {
            nValue = gsCMGetItemValue(oItem) * (100 + nSkillCheck) / 100;
            gsCMCreateGold(nValue, oSpeaker);
            DestroyObject(oItem);
        }

        oItem = GetNextItemInInventory(oSpeaker);
    }
}
