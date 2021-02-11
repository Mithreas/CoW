#include "inc_common"
#include "inc_pc"

void main()
{
    object oTarget = gsPCGetPlayerByID(GetLocalString(OBJECT_SELF, "GS_TARGET"));

    if (GetIsObjectValid(oTarget) && FindSubString(GetName(GetArea(oTarget)), "Death") >= 0)
    {
        int nSpell = GetLastSpell();
	    object oCaster = GetLastSpellCaster();
	
        // Dunshine: check for altar raises through prayer (see zz_co_sacrifice)
        if (GetLocalInt(OBJECT_SELF, "GVD_ALTAR_RAISE") == 1) {
          // use resurrection for this
          nSpell = SPELL_RESURRECTION;
          oCaster = GetLocalObject(OBJECT_SELF, "GVD_ALTAR_USER");
        }
        

		if (nSpell == SPELL_RAISE_DEAD || 
			nSpell == SPELL_RESURRECTION)
		{
			if (GetLocalObject(OBJECT_SELF, "sep_azn_claimedby") == oCaster)
			{
				SendMessageToPC(oCaster, "You are very tricky, assassin, but the guild is watching your deeds from the shadows. The spell doesn't seem to function..." +
				" something about the curved blade is interfering with your magic.");

                                // make sure to delete these variables, in case the corpse gets a raise attempt in a different way later on
                                DeleteLocalInt(OBJECT_SELF, "GVD_ALTAR_RAISE");
                                DeleteLocalObject(OBJECT_SELF, "GVD_ALTAR_USER");

				return;
			}
			gsCMCreateGold(GetLocalInt(OBJECT_SELF, "GS_GOLD"), oTarget);
			gsCMSetHitPoints(nSpell == SPELL_RAISE_DEAD ? 1 : GetMaxHitPoints(oTarget), oTarget);
			gsCMTeleportToLocation(oTarget, GetLocation(OBJECT_SELF), VFX_IMP_RAISE_DEAD);
			AssignCommand(oTarget, gsPCSavePCLocation(oTarget, GetLocation(oTarget)));
			DestroyObject(OBJECT_SELF);
	    }
    }
}
