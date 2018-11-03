const string GS_TEMPLATE_FLOOR = "gs_placeable369";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);
	
    object oArea      = GetArea(OBJECT_SELF);
    vector vPosition  = GetPosition(OBJECT_SELF);
    float fFacing     = 0.0;
    int nNth1         = 0;
    int nNth2         = 0;

    vPosition.x      -= 4.29;
    vPosition.y      -= 4.29;

    for (; nNth1 < 7; nNth1++)
    {
        for (nNth2 = 0; nNth2 < 7; nNth2++)
        {
            switch (Random(4))
            {
            case 0: fFacing =   0.0; break;
            case 1: fFacing =  90.0; break;
            case 2: fFacing = 180.0; break;
            case 3: fFacing = 270.0; break;
            }

            CreateObject(
                OBJECT_TYPE_PLACEABLE,
                GS_TEMPLATE_FLOOR,
                Location(oArea, vPosition, fFacing));

            vPosition.y += 1.43;
        }

        vPosition.x +=  1.43;
        vPosition.y -= 10.01;
    }

    DestroyObject(OBJECT_SELF);
}
