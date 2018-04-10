const string GS_TEMPLATE_STONE = "gs_placeable386";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oArea         = GetArea(OBJECT_SELF);
    vector vOffset       = GetPosition(OBJECT_SELF);
    vector vPosition     = vOffset;
    vector vDimension    = Vector(2.0, 1.25, 1.0);
    float fFacing1       = GetFacing(OBJECT_SELF);
    float fFacing2       = fFacing1;
    float fRandom        = 0.0;
    vector vDisplacement = AngleToVector(fFacing1 + 90.0) * vDimension.x;
    int nWidth           = GetLocalInt(OBJECT_SELF, "GS_WIDTH");
    int nHeight          = GetLocalInt(OBJECT_SELF, "GS_HEIGHT");
    int nX               = 0;
    int nY               = 0;

    for (nX = 0; nX < nWidth; nX++)
    {
        for (nY = 0; nY < nHeight; nY++)
        {
            fRandom      = IntToFloat(Random(201) - 100) / 10.0;

            CreateObject(
                OBJECT_TYPE_PLACEABLE,
                GS_TEMPLATE_STONE,
                Location(
                    oArea,
                    vPosition,
                    fFacing2 + fRandom));

            vPosition.z += vDimension.z;
            fFacing2    += 180.0;
            if (fFacing2 >= 360.0) fFacing2 -= 360.0;
        }

        vPosition   += vDisplacement;
        vPosition.z  = vOffset.z;
        fFacing1    += 180.0;
        if (fFacing1 >= 360.0) fFacing1 -= 360.0;
        fFacing2     = fFacing1;
    }

    DestroyObject(OBJECT_SELF);
}
