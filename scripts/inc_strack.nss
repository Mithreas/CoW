/* SPELLTRACKER Library by Gigaschatten */

//void main() {}

const string GS_SPT_INDEX_COUNT = "GS_SPT_COUNT";
const string GS_SPT_INDEX       = "GS_SPT_I_";
const string GS_SPT_SPELL       = "GS_SPT_S_";
const string GS_SPT_METAMAGIC   = "GS_SPT_M_";
const string GS_SPT_SPELL_COUNT = "GS_SPT_C_";
#include "inc_customspells"
//store use of nSpell by oCaster
void gsSPTCast(object oCaster, int nSpell, int nMetaMagic = METAMAGIC_NONE);
//decrement spells of caller by stored uses
void gsSPTActionApply();
//reset spell uses of oCaster
void gsSPTReset(object oCaster);

void gsSPTCast(object oCaster, int nSpell, int nMetaMagic = METAMAGIC_NONE)
{
    string sSpell     = IntToString(nSpell);
    string sMetaMagic = IntToString(nMetaMagic);
    string sIndex     = "";
    int nIndex        = GetLocalInt(oCaster, GS_SPT_INDEX + sSpell + "_" + sMetaMagic);
    int nCount        = 0;

    if (nIndex)
    {
        sIndex = IntToString(nIndex);
        nCount = GetLocalInt(oCaster, GS_SPT_SPELL_COUNT + sIndex) + 1;

        SetLocalInt(oCaster, GS_SPT_SPELL_COUNT + sIndex, nCount);
    }
    else
    {
        nCount = GetLocalInt(oCaster, GS_SPT_INDEX_COUNT) + 1;
        sIndex = IntToString(nCount);

        SetLocalInt(oCaster, GS_SPT_INDEX_COUNT, nCount);
        SetLocalInt(oCaster, GS_SPT_INDEX + sSpell + "_" + sMetaMagic, nCount);
        SetLocalInt(oCaster, GS_SPT_SPELL + sIndex, nSpell);
        SetLocalInt(oCaster, GS_SPT_METAMAGIC + sIndex, nMetaMagic);
        SetLocalInt(oCaster, GS_SPT_SPELL_COUNT + sIndex, 1);
    }
}
//----------------------------------------------------------------
void gsSPTActionApply()
{
    string sNth     = "";
    int nIndexCount = GetLocalInt(OBJECT_SELF, GS_SPT_INDEX_COUNT);
    int nSpell      = 0;
    int nMetaMagic  = 0;
    int nSpellCount = 0;
    int nNth1       = 1;
    int nNth2       = 0;

    SetLocalInt(OBJECT_SELF, "GS_SPT_OVERRIDE", TRUE);

    for (; nNth1 <= nIndexCount; nNth1++)
    {
        sNth        = IntToString(nNth1);
        nSpell      = GetLocalInt(OBJECT_SELF, GS_SPT_SPELL + sNth);
        nMetaMagic  = GetLocalInt(OBJECT_SELF, GS_SPT_METAMAGIC + sNth);
        nSpellCount = GetLocalInt(OBJECT_SELF, GS_SPT_SPELL_COUNT + sNth);

        for (nNth2 = 0; nNth2 < nSpellCount; nNth2++)
        {
            ActionCastSpellAtObject(
                nSpell,
                OBJECT_SELF,
                nMetaMagic,
                FALSE,
                0,
                PROJECTILE_PATH_TYPE_DEFAULT,
                TRUE);
        }
    }

    ActionDoCommand(DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "GS_SPT_OVERRIDE")));
}
//----------------------------------------------------------------
void gsSPTReset(object oCaster)
{
    string sNth     = "";
    int nIndexCount = GetLocalInt(oCaster, GS_SPT_INDEX_COUNT);
    int nSpell      = 0;
    int nMetaMagic  = 0;
    int nNth        = 1;

    DeleteLocalInt(oCaster, GS_SPT_INDEX_COUNT);

    for (; nNth <= nIndexCount; nNth++)
    {
        sNth       = IntToString(nNth);
        nSpell     = GetLocalInt(oCaster, GS_SPT_SPELL + sNth);
        nMetaMagic = GetLocalInt(oCaster, GS_SPT_METAMAGIC + sNth);

        DeleteLocalInt(oCaster, GS_SPT_INDEX + IntToString(nSpell) + "_" + IntToString(nMetaMagic));
        DeleteLocalInt(oCaster, GS_SPT_SPELL + sNth);
        DeleteLocalInt(oCaster, GS_SPT_METAMAGIC + sNth);
        DeleteLocalInt(oCaster, GS_SPT_SPELL_COUNT + sNth);
    }

    miSPClearAllCastSpells(oCaster);
}
