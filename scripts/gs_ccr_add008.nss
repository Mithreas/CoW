#include "inc_craft"
#include "inc_token"

int StartingConditional()
{
    gsTKSetToken(100, gsCRGetSkillName(GS_CR_SKILL_FORGE));
    gsTKSetToken(101, gsCRGetSkillName(GS_CR_SKILL_CARPENTER));
    gsTKSetToken(102, gsCRGetSkillName(GS_CR_SKILL_SEW));
    gsTKSetToken(103, gsCRGetSkillName(GS_CR_SKILL_MELD));
    gsTKSetToken(104, gsCRGetSkillName(GS_CR_SKILL_CRAFT_ART));
    gsTKSetToken(105, gsCRGetSkillName(GS_CR_SKILL_COOK));

    return TRUE;
}
