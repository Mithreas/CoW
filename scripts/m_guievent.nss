
const int VFX_DUR_CHAT_BUBBLE = 681;

void main()
{
    int nGuiEvent    = GetLastGuiEventType();
    object oPC       = GetLastGuiEventPlayer();

    switch ( nGuiEvent )
    {
        case GUIEVENT_CHATBAR_FOCUS:
        {
            //effect eVFX = EffectVisualEffect( VFX_DUR_PARALYZE_HOLD );
            effect eVFX = EffectVisualEffect( VFX_DUR_CHAT_BUBBLE );
            eVFX = TagEffect( eVFX, "VFX_DUR_CHAT_BUBBLE" );
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVFX, oPC );
            break;
        }

        case GUIEVENT_CHATBAR_UNFOCUS:
        {
            effect eEffect = GetFirstEffect( oPC );
            while( GetIsEffectValid( eEffect ) )
            {
                if( GetEffectTag( eEffect ) == "VFX_DUR_CHAT_BUBBLE" )
                    RemoveEffect( oPC, eEffect );
                eEffect = GetNextEffect( oPC );
            }
            break;
        }
    }
}
