//::///////////////////////////////////////////////
//:: On Heartbeat: Decay VFX
//:: hrt_decayvfx
//:://////////////////////////////////////////////
/*
    A one in six chance to play a disgusting visual
    whenever this script is called.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: August 24, 2017
//:://////////////////////////////////////////////

#include "nw_i0_spells"

void main()
{
    effect eVFX;

    if(d6() == 6)
    {
        switch(d6())
        {
            case 1:
                eVFX = EffectVisualEffect(VFX_COM_CHUNK_GREEN_SMALL);
                break;
            case 2:
                eVFX = EffectVisualEffect(VFX_COM_CHUNK_GREEN_MEDIUM);
                break;
            case 3:
                eVFX = EffectVisualEffect(VFX_COM_CHUNK_RED_SMALL);
                break;
            case 4:
                eVFX = EffectVisualEffect(VFX_COM_CHUNK_RED_MEDIUM);
                break;
            case 5:
                eVFX = EffectVisualEffect(VFX_COM_CHUNK_YELLOW_SMALL);
                break;
            case 6:
                eVFX = EffectVisualEffect(VFX_COM_CHUNK_YELLOW_MEDIUM);
                break;
        }
    }
    DelayCommand(GetRandomDelay(0.0, 3.0), ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF));
}
