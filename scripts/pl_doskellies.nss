// Creates skeleton placeables that rise and become skeleton ambushers
// if approached.  Placeable resrefs pl_skelazn, pl_skelazn2. 
#include "inc_area"

void main()
{
    object oArea     = GetArea(OBJECT_SELF);
    vector vPosition = GetPosition(OBJECT_SELF);
    int nSizeX       = FloatToInt(gsARGetSizeX(oArea)) - 1;
    int nSizeY       = FloatToInt(gsARGetSizeY(oArea)) - 1;
    int i            = 0;
    int c            = nSizeX * nSizeY / 500;

    if (c > 15) c = 15;

    for (; i < c; i++)
    {
        vPosition.x = IntToFloat(Random(nSizeX) + 1);
        vPosition.y = IntToFloat(Random(nSizeY) + 1);

        CreateObject(OBJECT_TYPE_PLACEABLE,
		             d2() - 1 ? "pl_skelazn" : "pl_skelazn2",
                     Location(oArea, vPosition, 0.0));
    }
}
