//------------------------------------------------------------------------------
//                       Item Creation Feat Wrapper
//------------------------------------------------------------------------------
// This is the point where we link the craft item scripts into every
// spellcast script. It's called from x2_inc_spellhook
// The reason why it is wrapped in its own script is to allow it being cached
// and modified without recompiling every single spellscript
//------------------------------------------------------------------------------
// GZ, 2003-10-25; (c) 2003 Bioware Corp.
//------------------------------------------------------------------------------
// Recompiled by Mith to pick up change to x2_inc_craft.
#include "x2_inc_craft"
void main()
{
    object oTarget = GetSpellTargetObject();
    int nRet = (CIGetSpellWasUsedForItemCreation(oTarget));
    SetExecutedScriptReturnValue (nRet);
}
