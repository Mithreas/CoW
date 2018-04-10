 #include "sep_eff_toolbox"

void main()
{
    float fXstart = GetLocalFloat(OBJECT_SELF, "fXstart");           // The start/origin of the X coordinate system.
    float fXend = GetLocalFloat(OBJECT_SELF, "fXend");               // The end/destination of the X coordinate system.
    float fYstart = GetLocalFloat(OBJECT_SELF, "fYstart");           // The start/origin of the Y coordinate system.
    float fYend = GetLocalFloat(OBJECT_SELF, "fYend");               // The end/destination of the Y coordinate system.
    float fZstart = GetLocalFloat(OBJECT_SELF, "fZstart");           // The start/origin of Z coordinate system
    float fZend = GetLocalFloat(OBJECT_SELF, "fZend");               // The end/destination of Z coordinate system.
    float fplcXwidth = GetLocalFloat(OBJECT_SELF, "fplcXwidth");     // The X space between placeables
    float fplcYheight = GetLocalFloat(OBJECT_SELF, "fplcYheight");   // The Y space between placeables
    float fplcZdepth = GetLocalFloat(OBJECT_SELF, "fplcZdepth");     // The Z space between placeables
    string sResref = GetLocalString(OBJECT_SELF, "sResref");         // Placeable Resref
    float fOrientation = GetLocalFloat(OBJECT_SELF, "fOrientation"); // Orientation a placeable should have
    int bRandomFacing = GetLocalInt(OBJECT_SELF, "bRandomFacing");   // Create a completely random orientation for every placeable
    int bSmallOffset = GetLocalInt(OBJECT_SELF, "bSmallOffset");     // Small deviation in orientation to break uniformity
    int bXstagger = GetLocalInt(OBJECT_SELF, "bXstagger");            // Staggers the placement of placeables to prevent texture overlap, X-axis.
    int bYstagger = GetLocalInt(OBJECT_SELF, "bYstagger");            // Staggers the placement of placeables to prevent texture overlap, X-axis.
    int bZstagger = GetLocalInt(OBJECT_SELF, "bZstagger");            // Staggers the placement of placeables to prevent texture overlap, X-axis.
    PlaceableWall(fXstart,
                  fXend,
                  fYstart,
                  fYend,
                  fZstart,
                  fZend,
                  fplcXwidth,
                  fplcYheight,
                  fplcZdepth,
                  sResref,
                  fOrientation,
                  bRandomFacing,
                  bSmallOffset,
                  bXstagger,
                  bYstagger,
                  bZstagger
                  );
    DestroyObject(OBJECT_SELF);
}
