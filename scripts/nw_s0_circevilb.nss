#include "inc_spell"

void main()
{
    gsSPRemoveEffect(
        GetExitingObject(),
        gsSPGetSpellID(),
        GetAreaOfEffectCreator());
}
