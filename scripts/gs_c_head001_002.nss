#include "gs_inc_common"
#include "gs_inc_xp"

void main()
{
    object oSpeaker = GetPCSpeaker();
    object oItem    = GetFirstItemInInventory(oSpeaker);
    int nValue      = 0;

    // Do a persuade check opposed by concentration to modify the bounty.
    int nSkillCheck = (GetSkillRank(SKILL_PERSUADE, oSpeaker) + d10()) -
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
