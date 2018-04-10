int StartingConditional()
{
    object oSpeaker = GetPCSpeaker();

    DeleteLocalObject(OBJECT_SELF, "GS_TATTOO_TARGET");

    if (! GetIsPC(oSpeaker)) return FALSE;

    switch (GetAppearanceType(oSpeaker))
    {
    case APPEARANCE_TYPE_DWARF:
    case APPEARANCE_TYPE_ELF:
    case APPEARANCE_TYPE_GNOME:
    case APPEARANCE_TYPE_HALF_ELF:
    case APPEARANCE_TYPE_HALF_ORC:
    case APPEARANCE_TYPE_HALFLING:
    case APPEARANCE_TYPE_HUMAN:
        return TRUE;
    }

    return FALSE;
}
