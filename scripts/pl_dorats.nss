// Spawns neutral rats in the area. They'll run away if approached.
#include "inc_area"

void main()
{
    object oArea     = GetArea(OBJECT_SELF);
    vector vPosition = GetPosition(OBJECT_SELF);
    int nSizeX       = FloatToInt(gsARGetSizeX(oArea)) - 1;
    int nSizeY       = FloatToInt(gsARGetSizeY(oArea)) - 1;
    int i            = 0;
    int c            = 5;

    for (; i < c; i++)
    {
        vPosition.x = IntToFloat(Random(nSizeX) + 1);
        vPosition.y = IntToFloat(Random(nSizeY) + 1);

        CreateObject(OBJECT_TYPE_CREATURE,
		             "smallrat",
                     Location(oArea, vPosition, 0.0));
    }
}
