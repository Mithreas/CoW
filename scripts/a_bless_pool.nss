//::///////////////////////////////////////////////
//:: FileName a_bless_pool
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 5/17/2003 5:53:47 PM
//:://////////////////////////////////////////////
int StartingConditional()
{
   object oPC = GetLastUsedBy();

   if (GetHasSpell(SPELL_BLESS, oPC) &&
       GetItemPossessedBy(oPC, "cnrGlassVial") != OBJECT_INVALID) return TRUE;

   else return FALSE;
}
