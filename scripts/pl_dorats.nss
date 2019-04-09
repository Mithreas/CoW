// Spawns neutral rats in the area. They'll run away if approached.
// Placeables can spawn something else instead by specifying the resref
// in an mi_resref variable.
#include "inc_area"

void main()
{
    object oArea     = GetArea(OBJECT_SELF);
    vector vPosition = GetPosition(OBJECT_SELF);
    int nSizeX       = FloatToInt(gsARGetSizeX(oArea)) - 1;
    int nSizeY       = FloatToInt(gsARGetSizeY(oArea)) - 1;
    int i            = 0;
    int c            = 5;

	string sResRef   = GetLocalString(OBJECT_SELF, "mi_resref");
	if (sResRef == "") sResRef = "smallrat";
	
    for (; i < c; i++)
    {
        vPosition.x = IntToFloat(Random(nSizeX) + 1);
        vPosition.y = IntToFloat(Random(nSizeY) + 1);

        CreateObject(OBJECT_TYPE_CREATURE,
		             sResRef,
                     Location(oArea, vPosition, 0.0));
    }
	
	DestroyObject(OBJECT_SELF);
}
