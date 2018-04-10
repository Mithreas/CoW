const string GS_TEMPLATE_COLUMN_1 = "gs_placeable204";
const string GS_TEMPLATE_COLUMN_2 = "gs_placeable205";

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    object oArea     = GetArea(OBJECT_SELF);
    location lLocation;
    vector vPosition = GetPosition(OBJECT_SELF);
    vector vVector1;
    vector vVector2;
    float fAngle     = GetFacing(OBJECT_SELF);
    float fMaximum   = fAngle + 360.0;

    while (fAngle < fMaximum)
    {
        vVector1  = AngleToVector(fAngle);
        vVector2  = vVector1 * 10.0;

        if (Random(100) < 90)
        {
            lLocation  = Location(oArea,
                                  vPosition + vVector2,
                                  fAngle + Random(4) * 90.0);
            CreateObject(OBJECT_TYPE_PLACEABLE,
                         Random(100) < 80 ? GS_TEMPLATE_COLUMN_1 : GS_TEMPLATE_COLUMN_2,
                         lLocation);
        }

        if (Random(100) < 90)
        {
            vVector2  = vVector1 * 15.0;
            lLocation = Location(oArea,
                                 vPosition + vVector2,
                                 fAngle + Random(4) * 90.0);

            if (Random(100) < 80)
            {
                CreateObject(OBJECT_TYPE_PLACEABLE, GS_TEMPLATE_COLUMN_1, lLocation);

                vVector2.z += 4.1;
                lLocation   = Location(oArea,
                                       vPosition + vVector2,
                                       fAngle + Random(4) * 90.0);
                CreateObject(OBJECT_TYPE_PLACEABLE,
                             Random(100) < 80 ? GS_TEMPLATE_COLUMN_1 : GS_TEMPLATE_COLUMN_2,
                             lLocation);
            }
            else
            {
                CreateObject(OBJECT_TYPE_PLACEABLE,
                             Random(100) < 80 ? GS_TEMPLATE_COLUMN_1 : GS_TEMPLATE_COLUMN_2,
                             lLocation);
            }
        }

        fAngle   += 20.0;
    }

    DestroyObject(OBJECT_SELF);
}
