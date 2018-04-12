#include "inc_craft"

int StartingConditional()
{
    struct gsCRRecipe stRecipe = gsCRAddRecipe(GetObjectByTag("GS_CR_INPUT"),
                                               GetObjectByTag("GS_CR_OUTPUT"),
                                               GetLocalInt(OBJECT_SELF, "GS_SKILL"));

    SetCustomToken(100, stRecipe.sName);
    SetCustomToken(101, gsCRGetSkillName(stRecipe.nSkill));
    SetCustomToken(102, gsCRGetCategoryName(stRecipe.nCategory));
    SetCustomToken(103, IntToString(gsCRGetRecipeDC(stRecipe)));
    SetCustomToken(104, IntToString(gsCRGetRecipeCraftPoints(stRecipe)));
    SetCustomToken(105, IntToString(stRecipe.nValue));
    SetCustomToken(106, gsCRGetRecipeInputList(stRecipe));
    SetCustomToken(107, gsCRGetRecipeOutputList(stRecipe));

    return TRUE;
}
