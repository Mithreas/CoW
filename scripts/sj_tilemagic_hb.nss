//  ----------------------------------------------------------------------------
//  sj_tilemagic_hb
//  ----------------------------------------------------------------------------
/*
    Placeable OnHeartbeat event script for Sunjammer's TileMagic System.

    If fired by a TileMagic Control it will convert all TileMagic Markers in the
    area.  If fired by a TileMagic AutoTile it will convert itself.
*/
//  ----------------------------------------------------------------------------
/*
    Version 1.00 - 25/06/04 - Sunjammer
    - created
*/
//  ----------------------------------------------------------------------------
#include "sj_tilemagic_i"

void main()
{
    object oMod = GetModule();
    string sTag = GetTag(OBJECT_SELF);

    if(sTag == SJ_TAG_TILEMAGIC_CONTROL)
    {
        // control - sweep area and convert all markers
        object oArea = GetArea(OBJECT_SELF);

        object oObject = GetFirstObjectInArea(oArea);
        while(GetIsObjectValid(oObject))
        {
            if(GetTag(oObject) == SJ_TAG_TILEMAGIC_MARKER)
            {
                // markers found, convert
                // NOTE: using AssignCommand and/or DelayCommand avoids a TMI
                AssignCommand(oMod, DelayCommand(0.2, SJ_TileMagic_ConvertObjectToTile(oObject)));
            }
            oObject = GetNextObjectInArea(oArea);
        }

        // self-destruct
        DestroyObject(OBJECT_SELF);
    }
    else if(sTag == SJ_TAG_TILEMAGIC_AUTOTILE)
    {
        // magic tile - just convert self
        SJ_TileMagic_ConvertObjectToTile();
    }
    else
    {
        // log an error
        string sDebug = "sj_tilemagic_hb: script fired by object with unrecognised tag (" + sTag + ").";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
    }
}

