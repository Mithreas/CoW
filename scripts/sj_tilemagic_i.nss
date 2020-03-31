//  ----------------------------------------------------------------------------
//  sj_tilemagic_i
//  ----------------------------------------------------------------------------
/*
    Sunjammer's TileMagic System
    ============================

    This system provides a more flexible and greatly expanded feature-set over
    the original TileMagic functions. It offers a a variety of ways for a user
    to take advange of TileMagic.

    1. Scripted: can be used by a scripter or builder during design.

    2. Markers: are waypoints (or placeables) that can be used by a builder
        during design or a DM during a game to create tiles. Once placed they
        will remain until converted into the appropriate tile(s) by a script or
        by a Control object.

    3. Autotiles: are placeables that can be used by a builder during design or
        a DM during a game to create tiles.  Once placed they automatically
        convert themselves into the appropriate tile(s).

    4. DM Widget: [work in progress] can be used by a DM to create or remove
        tiles during a game by targeting the ground and using a conversation
        interface.

    Contents
    ========

    - sj_debug_i        - script, library of debug functions (cut-down)
    - sj_tilemagic_dm   - script, OnActivateItem event/tag script for DM item
    - sj_tilemagic_ent  - script, OnEnter event script for area/trigger
    - sj_tilemagic_hb   - script, OnHeartbeat event script for autotile/marker
    - sj_tilemagic_i    - script, library of TileMagic functions
    - sj_utility_i      - script, library of utility functions (cut-down)

    - sj_tilemagic_autotile - placeable
    - sj_tilemagic_control  - placeable
    - sj_tilemagic_dm       - item
    - sj_tilemagic_marker   - waypoint

    * all objects are located in their Custom > Special > Custom 3 palette.


    The sj_tilemagic_* Controls
    ===========================

    Various controls are available for both the "marker" and "autotile" methods.
    These are stored as local variables on these object and influence aspects of
    "tile" they create. Most are optional have a default value that will be used
    if omitted.

    - tile: an int value for a SJ_TILEMAGIC_ORDINARY_* or SJ_TILEMAGIC_FEATURE_*
        constant. For example enter 402 for SJ_TILEMAGIC_ORDINARY_GRASS.

    - z: a float value for the height in metres at which the tile will appear.
        This can be used with both the normalise and the use_layer settings to
        control where this value is measured from. Default: 0.0.

    - normalise: an int value (FALSE or TRUE) to indicate if the z setting is to
        be adjusted to compensate for the tile's built-in non-zero height. TRUE
        means z will be adjusted to compensate and FALSE means the z will not.
        Default: FALSE.

    - use_layer: an int value (FALSE or TRUE) to indicate if the z setting is to
        be adjusted to account for a marker's current position. (This is done
        automatically for autotiles to aid alignment on uneven ground.) FALSE
        means the z setting will be measured from 0m and TRUE means z will be
        measured from the nearest 1m layer (rounded down). Default: FALSE.

    - columns: an int value indicating the number of columns covered by a range.
        This can be used with both the rows and corner settings to control the
        extent and starting point of a TileMagic range. Default: 0

    - rows: an int value indicating the number of rows covered by a range. This
        can be used with both the columns and corner settings to control the
        extent and starting point of a TileMagic range. Default: 0

    - corner: an int value (1, 3, 7 or 9) indicating the position of the object
        in relation to a range. This can be used when the default position is
        unavailable or inappropriate. The numbers correspond to the position of
        the keys on a numeric keypad. For example enter 3 to indicate that the
        object is in the bottom-right or SE corner of a TileMagic range. Extra
        care should be taken when range when one of the dimensions is 1 tile.
        Default: 0 (interpreted as 1, i.e. bottom-left or SW)

    - rotation: an int value (0 to 3) indicating the number of "quarter turns"
        a tile effect should be rotated.  A value of (-1) indicates that the
        number of "quarter turns" should be determined randomly. The rotation is
        applied counter-clockwise relative to the tile's default position.
        Default: 0 (SJ_ROTATION_NONE)


    Matrix and Palette
    ==================

    A matrix is essentially a map of ASCII characters. Each matrix consists of
    an index of rows, each row is described by a string of characters and each
    character represents a style code which can be interpreted (using a palette)
    to determine what TileMagic effect (if any) should be created for a given
    tile in a given area. A matrix can contain up to 32 rows and a row can
    contain up to 32 characters. A character can be alphanumeric, a symbol or a
    space. The data used to create a matrix can be predefined in a 2da file or
    can be defined at design time through scripting.

    A palette is essentially a list of style information. Each palette consists
    of an index of styles, each style is identified by a style code and
    described by a variety of attributes which can be employed (using a matrix)
    to determine what TileMagic effect (if any) should be created for a given
    tile in a given area. Different palettes can associate the same style code
    to describe different styles. A style code is a single character and can be
    alphanumeric or a symbol. The data used to create a palette can be
    predefined in a 2da file or can be defined at design time through scripting.


    Duplicated visualeffect.2da Entries
    ===================================

    Various entries in visualeffects.2da use the same model when generating the
    TileMagic effect and two look the same but actually use different models.
    When one of the former is encountered the corresponding SJ_TILEMAGIC_*
    constant is use.  The latter have individual SJ_TILEMAGIC_* constants.

    - rows 347, 348 & 453 are all the same marble arch tile
    - rows 404 & 441 are both the same ant-hill tile
    - rows 428 & 431 are both the same waterfall tile
    - rows 429 & 430 are both the same transporter tile
    - rows 401 & 437 are different blue water tiles


    Hints and Tips
    ==============

    - CoverTile and CoverSpot can be used to co-locate two tile nodes on exactly
      the same spot. Otherwise tile nodes must be at least 0.01m apart.

    - To ensure foward compatability only use alhpa-numeric characters for style
      codes. Any special characters that may appear will use symbols.


    Known Issues
    ============

    There are several known issues with TileMagic:

    - sound effects: the footsteps sound cannot be changes and so may break the
      illusion of, for example, wading through water. I suggest that builders
      use other sounds to mask this where possible.

    - graphics: there are issues with redrawing tiles and with the interaction
      of TileMagic with fog and/or skyboxes.

    - cpu hit: some TileMagic effects are quite intensive.

    - errors: row 440 in visualeffects.2da has a typo in the tile model so the
      tile won't display. The SJ_TILEMAGIC_FEATURE_GRASS_GRAVES constant has
      been included as a bug report has been submitted and it is hope it will
      be fixed in 1.64 or later.


    2.02 TODO List
    ==============
    - implement a check for empty 2DA files (eg: nIndex == 0 && sRow == "")
    - implement a post datapoint creation data load
    - implement tile effect specific delays
    - implement GetColumn/RowFromLocation
    - addon: ill-effect triggers
    - addon: DM widget

*/
//  ----------------------------------------------------------------------------
/*
    Version 2.02 - 10 Oct 2004 - Sunjammer
    - add rotation component to all Cover* functions

    Version 2.01 - 10 Aug 2004 - Sunjammer
    - added various Palette functions
    - added various Matrix functions
    - added various Spot functions
    - added unique node tagging
    - removed "GetNearest" schema

    Version 2.00 - 25 Jul 2004 - Sunjammer
    - added placeables and waypoint systems
    - added height normalisation and layer heights
    - added constants for all unique effects.2da entries
    - rewritten

    Version 1.00 - 24 Dec 2003 - Sunjammer
    - created
*/
//  ----------------------------------------------------------------------------
#include "sj_utility_i"


//  ----------------------------------------------------------------------------
//  CONSTANTS: SETTINGS
//  ----------------------------------------------------------------------------

// Sets the delay applied to all Clear functions to offset any delay inherrent
// in tile creation, default 0.0.
const float SJ_TILEMAGIC_DELAY_CLEAR    = 0.0;

// Sets the ASCII character to be used to represent no style in a matrix.
// NOTE: single character, default "."
const string SJ_TILEMAGIC_STYLE_NONE    = ".";

// Set to TRUE to render a matrix from the top (northern edge) of an area down
// (south) rather than from the bottom (sothern edge) up (north). This allows a
// matrix to visibly resemble the area more closely and makes defining it more
// natural. Default TRUE.
const int SJ_TILEMAGIC_TOPDOWN_MATRIX   = TRUE;

//  ----------------------------------------------------------------------------
//  CONSTANTS: SYSTEM
//  ----------------------------------------------------------------------------

// "keypad" corners
const int SJ_TILEMAGIC_CORNER_SE = 3;
const int SJ_TILEMAGIC_CORNER_SW = 1;
const int SJ_TILEMAGIC_CORNER_NE = 9;
const int SJ_TILEMAGIC_CORNER_NW = 7;

// constants for ordindary tiles
const int SJ_TILEMAGIC_ORDINARY_CAVE                = 406;  // Caves
const int SJ_TILEMAGIC_ORDINARY_GRASS               = 402;  // Mini
const int SJ_TILEMAGIC_ORDINARY_LAVA                = 350;  // Dungeon
const int SJ_TILEMAGIC_ORDINARY_ICE                 = 426;  // Frozen
const int SJ_TILEMAGIC_ORDINARY_PIT                 = 506;  // Underdark
const int SJ_TILEMAGIC_ORDINARY_WATER_BLUE_1        = 401;  // Rural
const int SJ_TILEMAGIC_ORDINARY_WATER_BLUE_2        = 437;  // Rural
const int SJ_TILEMAGIC_ORDINARY_WATER_GREEN         = 461;  // Sewer
const int SJ_TILEMAGIC_ORDINARY_JAIL                = 511;  // Castle Interior

// constants for freature tiles
const int SJ_TILEMAGIC_FEATURE_CAVE_MINING_PILE     = 434;  // Caves - Pile of earth & tools
const int SJ_TILEMAGIC_FEATURE_CAVE_STONE_COLUMN    = 435;  // Caves - Stone column & water
const int SJ_TILEMAGIC_FEATURE_CITY_GAZEBO          = 457;  // City Exterior - Gazebo
const int SJ_TILEMAGIC_FEATURE_CITY_HOUSE_1         = 449;  // City Exterior - House, larger
const int SJ_TILEMAGIC_FEATURE_CITY_HOUSE_2         = 438;  // City Exterior - House, smaller
const int SJ_TILEMAGIC_FEATURE_CITY_MARBLE_ARCH     = 347;  // City Exterior - Marble arch
const int SJ_TILEMAGIC_FEATURE_CITY_MARKET_1        = 432;  // City Exterior - Market, square
const int SJ_TILEMAGIC_FEATURE_CITY_MARKET_2        = 455;  // City Exterior - Market, angled
const int SJ_TILEMAGIC_FEATURE_CITY_RUBBLE          = 433;  // City Exterior - Wall section and rubble
const int SJ_TILEMAGIC_FEATURE_CITY_RUINED_HOUSE    = 451;  // City Exterior - House, ruined
const int SJ_TILEMAGIC_FEATURE_CITY_RUINED_ARCH     = 452;  // City Exterior - Marble arch, ruined
const int SJ_TILEMAGIC_FEATURE_CITY_RUINS_1         = 450;  // City Exterior - Burnt out ruins, round
const int SJ_TILEMAGIC_FEATURE_CITY_RUINS_2         = 454;  // City Exterior - Burnt out ruins, square
const int SJ_TILEMAGIC_FEATURE_CITY_WAGON           = 458;  // City Exterior - Wagon
const int SJ_TILEMAGIC_FEATURE_GRASS_CARAVAN        = 439;  // Rural - Caravan
const int SJ_TILEMAGIC_FEATURE_GRASS_GRAVES         = 440;  // **ERROR** Rural - Graves
const int SJ_TILEMAGIC_FEATURE_GRASS_ANT_HILL       = 404;  // Rural - Ant-hill
const int SJ_TILEMAGIC_FEATURE_GRASS_CRYSTAL        = 405;  // Rural - Crystal in sandpit
const int SJ_TILEMAGIC_FEATURE_ICE_BUMP             = 442;  // Frozen - Bump in ground
const int SJ_TILEMAGIC_FEATURE_ICE_CASTLE_WALL      = 443;  // Forzen - Evil castle wall, facing west
const int SJ_TILEMAGIC_FEATURE_ITHILLID_PILLAR      = 427;  // Ithillid - Pillar
const int SJ_TILEMAGIC_FEATURE_ITHILLID_TRANSPORTER = 429;  // Ithillid - Transporter
const int SJ_TILEMAGIC_FEATURE_KITCHEN_LANTERN      = 436;  // City Interior  - Kitchen floor & lantern
const int SJ_TILEMAGIC_FEATURE_LAVA_FOUNTAIN        = 349;  // Dungeon - Lava fountain
const int SJ_TILEMAGIC_FEATURE_UNDERDARK_WATERFALL  = 428;  // Underdark - Waterfall, facing west

// object blueprints
const string SJ_RES_INVISIBLE_OBJECT    = "plc_invisobj";

// object tags
const string SJ_TAG_TILEMAGIC_AUTOTILE  = "sj_tilemagic_autotile";
const string SJ_TAG_TILEMAGIC_CONTROL   = "sj_tilemagic_control";
const string SJ_TAG_TILEMAGIC_MARKER    = "sj_tilemagic_marker";
const string SJ_TAG_TILEMAGIC_WIDGET    = "sj_tilemagic_dm";

// general purpose prefix
const string SJ_TILEMAGIC_PREFIX        = "sj_tilemagic_";

// name of 2DA columns
const string SJ_TILEMAGIC_2DA_NORMALISE = "NORMALISE";
const string SJ_TILEMAGIC_2DA_ROTATION  = "ROTATION";
const string SJ_TILEMAGIC_2DA_ROW       = "ROW";
const string SJ_TILEMAGIC_2DA_STYLE     = "STYLE";
const string SJ_TILEMAGIC_2DA_TILE      = "TILE";
const string SJ_TILEMAGIC_2DA_Z         = "Z";

// name of local variables
const string SJ_VAR_TILEMAGIC_AREA_ID   = "sj_tilemagic_area_id";
const string SJ_VAR_TILEMAGIC_COLUMNS   = "sj_tilemagic_columns";
const string SJ_VAR_TILEMAGIC_CORNER    = "sj_tilemagic_corner";
const string SJ_VAR_TILEMAGIC_MATRIX    = "sj_tilemagic_matrix";
const string SJ_VAR_TILEMAGIC_OFFSET    = "sj_tilemagic_offset";
const string SJ_VAR_TILEMAGIC_NORMALISE = "sj_tilemagic_normalise";
const string SJ_VAR_TILEMAGIC_PALETTE   = "sj_tilemagic_palette";
const string SJ_VAR_TILEMAGIC_ROTATION  = "sj_tilemagic_rotation";
const string SJ_VAR_TILEMAGIC_ROWS      = "sj_tilemagic_rows";
const string SJ_VAR_TILEMAGIC_TILE      = "sj_tilemagic_tile";
const string SJ_VAR_TILEMAGIC_USE_LAYER = "sj_tilemagic_use_layer";
const string SJ_VAR_TILEMAGIC_Z         = "sj_tilemagic_z";


//  ----------------------------------------------------------------------------
//  PROTOTYPES
//  ----------------------------------------------------------------------------

// Registers sRow data string describing row nIndex with oMatrix. The string
// consists of a combination of up to 32 alphanumeric characters, symbols or
// spaces.
//  - oMatrix:      datapoint reference
//  - nIndex:       row number (0 to 31)
//  - sRow:         string of style codes
void SJ_TileMagic_AddRowToMatrix(object oMatrix, int nIndex, string sRow);

// Registers the style information describing style code sStyle with oPalette.
// The style code is a single alphanumeric character or symbol.
//  - oPalette:     datapoint reference
//  - sStyle:       single style code
//  - nTile:        SJ_TILEMAGIC_* / SJ_TILEMAGIC_FEATURE_* constant
//  - fZ:           height of the tile
//  - bNormalise:   TRUE (to compensate for tile's internal offset) or FALSE
//  - nRotation:    SJ_ROTATION_* constant
void SJ_TileMagic_AddStyleToPalette(object oPalette, string sStyle, int nTile, float fZ=0.0, int bNormalise=TRUE, int nRotation=0);

// Removes all TileMagic tiles in oArea.
//  - oArea:        area containing TileMagic tiles
void SJ_TileMagic_ClearArea(object oArea);

// Removes any TileMagic tiles in oArea that fall within the specified border.
//  - oArea:        area containing TileMagic tiles
//  - nWidth:       width of border to be cleared
void SJ_TileMagic_ClearBorder(object oArea, int nWidth=1);

// Removes any TileMagic tiles in oArea that have a non-blank style code within
// the specified matrix or the matrix registered with oArea if oMatrix is not
// specified.
//  - oArea:        area containing TileMagic matrix
//  - oMatrix:      datapoint reference
void SJ_TileMagic_ClearMatrix(object oArea, object oMatrix=OBJECT_INVALID);

// Removes any TileMagic tiles in oArea that fall within the specified range.
//  - oArea:        area containing TileMagic tiles
//  - nColumn:      column index of bottom left corner of range
//  - nRow:         row index of bottom left corner of range
//  - nColumns:     number of columns to be cleared
//  - nRows:        number of rows to be cleared
void SJ_TileMagic_ClearRange(object oArea, int nColumn=0, int nRow=0, int nColumns=1, int nRows=1);

// Removes a TileMagic tile in oArea that falls on the spot fX, fY.
//  - oArea:        area containing TileMagic matrix
//  - fX:           x co-ordinate (0.00 to 319.99)
//  - fY:           y co-ordinate (0.00 to 319.99)
void SJ_TileMagic_ClearSpot(object oArea, float fX, float fY);

// Removes a TileMagic tile from the specified location in oArea.
//  - oArea:        area containing TileMagic tile
//  - nColumn:      column index of tile
//  - nRow:         row index of tile
void SJ_TileMagic_ClearTile(object oArea, int nColumn=0, int nRow=0);

// Converts (and in the process destroys) a TileMagic object into an appropriate
// TileMagic tile in taking account of all the settings stored on oObject.
//  - oObject       TileMagic object to be converted
void SJ_TileMagic_ConvertObjectToTile(object oObject=OBJECT_SELF);

// Covers oArea with TileMagic tiles. The tiles have a vertical offset of fZ
// modified by nTile's internal offset unless using bNormalise.
//  - oArea:        area to be tiled
//  - nTile:        SJ_TILEMAGIC_ORDINARY_* / SJ_TILEMAGIC_FEATURE_* constant
//  - fZ:           height of the tile
//  - bNormalise:   TRUE (to compensate for tile's internal offset) or FALSE
//  - nRotation:    SJ_ROTATION_* constant
void SJ_TileMagic_CoverArea(object oArea, int nTile, float fZ=0.0, int bNormalise=TRUE, int nRotation=0);

// Covers a specified border-shaped range around oArea's with TileMagic tiles.
// The border extends nWidth tiles into oArea. The tiles have a vertical offset
// of fZ modified by nTile's internal offset unless using bNormalise.
//  - oArea:        area to be tiled
//  - nTile:        SJ_TILEMAGIC_ORDINARY_* / SJ_TILEMAGIC_FEATURE_* constant
//  - nWidth:       width of border (in number of tiles)
//  - fZ:           height of the tile
//  - bNormalise:   TRUE (to compensate for tile's internal offset) or FALSE
//  - nRotation:    SJ_ROTATION_* constant
void SJ_TileMagic_CoverBorder(object oArea, int nTile, int nWidth=1, float fZ=0.0, int bNormalise=TRUE, int nRotation=0);

// Covers a specified matrix of tiles within oArea with TileMagic tiles. The
// matrix defines which tiles should be covered while the palette defines what
// TileMagic effect should be used. The matrix has a vertical offset (fOffset)
// which is additional to the tile's fZ and bNormalise controls.
//  - oArea:        area containing TileMagic matrix
//  - oMatrix:      datapoint reference
//  - oPalette:     datapoint reference
//  - fOffset:      height of the matrix
void SJ_TileMagic_CoverMatrix(object oArea, object oMatrix, object oPalette, float fOffset=0.0);

// Covers a specified range of in oArea with TileMagic tiles. The range extends
// from the specified nColumn, nRow tile (which represents the bottom-left of
// the range) nColumns wide and nRows high. The tiles have a vertical offset of
// fZ modified by nTile's internal offset unless using bNormalise.
//  - oArea:        area to be tiled
//  - nTile:        SJ_TILEMAGIC_ORDINARY_* / SJ_TILEMAGIC_FEATURE_* constant
//  - nColumn:      column index of bottom left corner of range
//  - nRow:         row index of bottom left corner of range
//  - nColumns:     number of columns to be covered
//  - nRows:        number of rows to be covered
//  - fZ:           height of the tile
//  - bNormalise:   TRUE (to compensate for tile's internal offset) or FALSE
//  - nRotation:    SJ_ROTATION_* constant
void SJ_TileMagic_CoverRange(object oArea, int nTile, int nColumn=0, int nRow=0, int nColumns=1, int nRows=1, float fZ=0.0, int bNormalise=TRUE, int nRotation=0);

// Covers a specified matrix of tiles within oArea with TileMagic tiles. The
//  - oArea:        area containing TileMagic matrix
//  - nTile:        SJ_TILEMAGIC_* / SJ_TILEMAGIC_FEATURE_* constant
//  - fX:           x co-ordinate (0.00 to 319.99)
//  - fY:           y co-ordinate (0.00 to 319.99)
//  - fZ:           height of the tile
//  - bNormalise:   TRUE (to compensate for tile's internal offset) or FALSE
//  - fRotation:    0.00 to 359.99
void SJ_TileMagic_CoverSpot(object oArea, int nTile, float fX, float fY, float fZ=0.0, int bNormalise=TRUE, float Rotation=0.0);

// Covers a single tile in oArea with a TileMagic tile. The tile have a vertical
// offset of fZ modified by nTile's internal offset unless using bNormalise.
//  - oArea:        area to be tiled
//  - nTile:        SJ_TILEMAGIC_ORDINARY_* / SJ_TILEMAGIC_FEATURE_* constant
//  - nColumn:      column index tile
//  - nRow:         row index tile
//  - fZ:           height of the tile
//  - bNormalise:   TRUE (to compensate for tile's internal offset) or FALSE
//  - nRotation:    SJ_ROTATION_* constant
void SJ_TileMagic_CoverTile(object oArea, int nTile, int nColumn, int nRow, float fZ=0.0, int bNormalise=TRUE, int nRotation=0);

// Creates and returns a uniquely identified datapoint to contain a matrix. A
// matrix is essentially a map of ASCII characters. Each matrix consists of an
// index of rows, each row is described by a string of characters and each
// character represents a style code which can be interpreted (using a palette)
// to determine what TileMagic effect (if any) should be created for a given
// tile in a given area. A matrix can contain up to 32 rows and a row can
// contain up to 32 characters. A character can be alphanumeric, a symbol or a
// space. The data used to create a matrix can be predefined in a 2da file or
// can be defined at design time through scripting.
//  - sName:        unique identifier, upto 16 characters
//  - bUse2DA:      TRUE (to load from sName.2da) or FALSE
//  * Returns:      datapoint reference
//  * OnError:      OBJECT_INVALID
object SJ_TileMagic_CreateMatrix(string sName, int bUse2DA=FALSE);

// Creates and returns a uniquely identified datapoint to contain a palette. A
// palette is essentially a list of style information. Each palette consists of
// an index of styles, each style is identified by a style code and described by
// a variety of attributes which can be employed (using a matrix) to determine
// what TileMagic effect (if any) should be created for a given tile in a given
// area. Different palettes can associate the same style code to describe
// different styles. A style code is a single character and can be alphanumeric
// or a symbol. The data used to create a palette can be predefined in a 2da
// file or can be defined at design time through scripting.
//  - sName:        unique identifier, upto 16 characters
//  - bUse2DA:      TRUE (to load from sName.2da) or FALSE
//  * Returns:      datapoint reference
//  * OnError:      OBJECT_INVALID
object SJ_TileMagic_CreatePalette(string sName, int bUse2DA=FALSE);

// Returns oArea's TileMagic ID. If no ID has been assigned to the area the next
// available ID is assigned and that is returned.
int SJ_TileMagic_GetAreaID(object oArea);

// Returns an SJ_TILEMAGIC_* constant for values matching duplicate entries in
// visualeffects.2da. Returns nTile unmodified in all other circumstances.
int SJ_TileMagic_GetCorrectedConstant(int nTile);

// Returns the column index oObject.
int SJ_TileMagic_GetColumn(object oObject);

// Returns the layer index oObject.
int SJ_TileMagic_GetLayer(object oObject);

// Returns fZ modified to account for a TileMagic tile's built-in non-zero
// height if it has one. Returns fZ unmodified in all other circumstances.
float SJ_TileMagic_GetNormalisedHeight(int nTile, float fZ);

// Returns the row index oObject.
int SJ_TileMagic_GetRow(object oObject);

// Returns a unique tag for a TileMagic spot node.
string SJ_TileMagic_GetTagForSpot(object oArea, float fX, float fY);

// Returns a unique tag for a TileMagic tile node.
string SJ_TileMagic_GetTagForTile(object oArea, int nColumn, int nRow);

// Switches the matrix used to cover oArea with TileMagic tiles.
//  - oArea:        area containing TileMagic matrix
//  - oMatrix:      datapoint reference
//  - fOffset:      height of the matrix
void SJ_TileMagic_SwitchMatrix(object oArea, object oMatrix, float fOffset=0.0);

// Switches the palette used to cover oArea with TileMagic tiles.
//  - oArea:        area containing TileMagic matrix
//  - oPalette:     datapoint reference
void SJ_TileMagic_SwitchPalette(object oArea, object oPalette);

// Returns a string description of a TileMagic tile.
string SJ_TileMagic_TileToString(object oArea, string sTag, int nTile=0);


//  ----------------------------------------------------------------------------
//  DEPRECATED
//  ----------------------------------------------------------------------------

void TLChangeAreaGroundTileRange(object oArea, int nTile, int nColumn, int nRow, int nColumns=1, int nRows=1, float fZ=-0.4)
{
    // this is included for backwards compatability only and should not be used
    SJ_TileMagic_CoverRange(oArea, nTile, nColumn, nRow, nColumns, nRows, fZ, FALSE);
}


void TLResetAreaGroundTileRange(object oArea, int nColumn, int nRow, int nColumns=1, int nRows=1)
{
    // this is included for backwards compatability only and should not be used
    SJ_TileMagic_ClearRange(oArea, nColumn, nRow, nColumns, nRows);
}


//  ----------------------------------------------------------------------------
//  FUNCTIONS
//  ----------------------------------------------------------------------------

void SJ_TileMagic_AddRowToMatrix(object oMatrix, int nIndex, string sRow)
{
    string sDebug;
    string sIndex = IntToString(nIndex);

    // sanity checks
    if(sRow == "")
    {
         // check if row exists
         sDebug = "SJ_TileMagic_AddRowToMatrix: failled as row data for row ( " + sIndex + ") was null.";
    }
    else if(nIndex < 0 || nIndex > 32)
    {
        // check if row is in limits
        sDebug = "SJ_TileMagic_AddRowToMatrix: failled as row ( " + IntToString(nIndex) + ") exceeded lower or upper bounds.";
    }
    else if(GetIsObjectValid(oMatrix) == FALSE)
    {
        // check if datapoint exists
        string sDebug = "SJ_TileMagic_AddRowToMatrix: failled as datapoint was invalid.";
    }
    else if(GetLocalString(oMatrix, sIndex) != "")
    {
        // check if row exists
         sDebug = "SJ_TileMagic_AddRowToMatrix: failled as row ( " + sIndex + ") already exisited in datapoint.";
    }

    // result
    if(sDebug == "")
    {
        // valid matrix and no collisions: register row data
        SetLocalString(oMatrix, sIndex, sRow);
    }
    else
    {
        // log an error
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
     }
}


void SJ_TileMagic_AddStyleToPalette(object oPalette, string sStyle, int nTile, float fZ=0.0, int bNormalise=TRUE, int nRotation=0)
{
    string sDebug;

    // sanity checks
    if(sStyle == "")
    {
        // check if style is a single character
        sDebug = "SJ_TileMagic_AddStyleToPalette: failled as style was null.";
    }
    else if(GetStringLength(sStyle) > 1)
    {
        // check if style is a single character
        sDebug = "SJ_TileMagic_AddStyleToPalette: failled as style ( " + sStyle + ") exceeded 1 character and is invalid.";
    }
    else if(GetIsObjectValid(oPalette) == FALSE)
    {
        // check if datapoint exists
        sDebug = "SJ_TileMagic_AddStyleToPalette: failled as datapoint was invalid.";
    }
    else if(GetLocalString(oPalette, sStyle) == sStyle)
    {
        // check if style exits
        sDebug = "SJ_TileMagic_AddStyleToPalette: failled as style ( " + sStyle + ") already exisited in datapoint.";
    }

    // result
    if(sDebug == "")
    {
        // valid palette and no collisions: register style data
        SetLocalString(oPalette, sStyle, sStyle);
        SetLocalInt(oPalette, sStyle + SJ_VAR_TILEMAGIC_TILE, nTile);
        SetLocalFloat(oPalette, sStyle + SJ_VAR_TILEMAGIC_Z, fZ);
        SetLocalInt(oPalette, sStyle + SJ_VAR_TILEMAGIC_NORMALISE, bNormalise);
        SetLocalInt(oPalette, sStyle + SJ_VAR_TILEMAGIC_ROTATION, nRotation);
    }
    else
    {
        // log an error
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
    }
}


void SJ_TileMagic_ClearArea(object oArea)
{
    // get area dimensions
    int nColumns = SJ_GetAreaWidth(oArea);
    int nRows = SJ_GetAreaHeight(oArea);

    // clear each tile in area
    int nCurColumn, nCurRow;
    for(nCurColumn = 0; nCurColumn < nColumns; nCurColumn++)
    {
        for(nCurRow = 0; nCurRow < nRows; nCurRow++)
        {
            SJ_TileMagic_ClearTile(oArea, nCurColumn, nCurRow);
        }
    }
}


void SJ_TileMagic_ClearBorder(object oArea, int nWidth = 1)
{
    // sanity check
    if(nWidth < 1)
    {
        // log an error
        string sDebug = "SJ_TileMagic_ClearBorder: failled as border width (" + IntToString(nWidth) + ") was invalid.";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
        return;
    }

    // get area dimensions
    int nColumns = SJ_GetAreaWidth(oArea);
    int nRows = SJ_GetAreaHeight(oArea);

    // clear each tile in border
    int nCurColumn, nCurRow;
    for(nCurColumn = 0; nCurColumn < nColumns; nCurColumn++)
    {
        for(nCurRow = 0; nCurRow < nRows; nCurRow++)
        {
            // A tile will fall within the border if its column or row index is
            // less than the border's width OR if its column index is the same
            // or greater than the number of columns less the border width OR if
            // its row index is the same or greater than the number of rows less
            // the border width.
            if(nCurColumn < nWidth
            || nCurRow < nWidth
            || nCurRow >= (nRows - nWidth)
            || nCurColumn >= (nColumns - nWidth))
            {
                SJ_TileMagic_ClearTile(oArea, nCurColumn, nCurRow);
            }
        }
    }
}


void SJ_TileMagic_ClearMatrix(object oArea, object oMatrix = OBJECT_INVALID)
{
    // check if a matrix was supplied
    if(GetIsObjectValid(oMatrix) == FALSE)
    {
        // if no matrix is supplied use
        oMatrix = GetLocalObject(oArea, SJ_VAR_TILEMAGIC_MATRIX);

        // sanity check
        if(GetIsObjectValid(oMatrix) == FALSE)
        {
            // log an error
            string sDebug = "SJ_TileMagic_ClearMatrix: valid matrix could not be located.";
            SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
            return;
        }
    }

    // get area dimensions
    int nColumns = SJ_GetAreaWidth(oArea);
    int nRows = SJ_GetAreaHeight(oArea);

    int nColumn, nRow;
    for(nRow = 0; nRow < nRows; nRow++)
    {
        // if using the TOPDOWN setting then start at the top row and work down
        // otherwise start at the bottom row and work up as normal
        // NOTE: use (nRows - 1) because rows are numbered from 0
        int nIndex = (SJ_TILEMAGIC_TOPDOWN_MATRIX) ? (nRows - 1) - nRow  : nRow;

        // get row data for the current row, skip row if null
        string sRow = GetLocalString(oMatrix, IntToString(nIndex));

        // skip row if row data null
        if(sRow == "")
        {
            // NOTE: do not log an error as this is permitted
            continue;
        }

        // if there is an entry for this row then
        for(nColumn = 0; nColumn < nColumns; nColumn++)
        {
            // get the style code for the current column
            string sStyle = GetSubString(sRow, nColumn, 1);

            // skip if style is blank (space or user-defined)
            if(sStyle != " " && sStyle != SJ_TILEMAGIC_STYLE_NONE)
            {
                SJ_TileMagic_ClearTile(oArea, nColumn, nRow);
            }
        }
    }

    // unregister matrix and palette with area
    DeleteLocalObject(oArea, SJ_VAR_TILEMAGIC_MATRIX);
    DeleteLocalObject(oArea, SJ_VAR_TILEMAGIC_PALETTE);
    DeleteLocalFloat(oArea, SJ_VAR_TILEMAGIC_OFFSET);
}


void SJ_TileMagic_ClearRange(object oArea, int nColumn = 0, int nRow = 0, int nColumns = 1, int nRows = 1)
{
    // sanity check
    if(nColumns < 1 || nRows < 1)
    {
        // log an error
        string sDebug = "SJ_TileMagic_ClearRange: failed as the number of columns (" + IntToString(nColumns) + ") or rows (" + IntToString(nRows) + ") was invalid.";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
        return;
    }

    // clear tiles in range
    int nCurColumn, nCurRow;
    for(nCurColumn = nColumn; nCurColumn < nColumn + nColumns; nCurColumn++)
    {
        for(nCurRow = nRow; nCurRow < nRow + nRows; nCurRow++)
        {
            SJ_TileMagic_ClearTile(oArea, nCurColumn, nCurRow);
        }
    }
}


void SJ_TileMagic_ClearSpot(object oArea, float fX, float fY)
{
    // use unique tag to ID tile node
    string sTag = SJ_TileMagic_GetTagForSpot(oArea, fX, fY);
    object oTile = GetObjectByTag(sTag);

    if(GetIsObjectValid(oTile))
    {
        // clear tile
        DestroyObject(oTile, SJ_TILEMAGIC_DELAY_CLEAR);
    }
    else
    {
        // log an error
        string sDebug =  "SJ_TileMagic_ClearSpot: failed as target (" + SJ_TileMagic_TileToString(oArea, sTag) + ") did not exist.";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
    }
}


void SJ_TileMagic_ClearTile(object oArea, int nColumn = 0, int nRow = 0)
{
    // use unique tag to ID tile node
    string sTag = SJ_TileMagic_GetTagForTile(oArea, nColumn, nRow);
    object oTile = GetObjectByTag(sTag);

    if(GetIsObjectValid(oTile))
    {
        // remove tile node
        DestroyObject(oTile, SJ_TILEMAGIC_DELAY_CLEAR);
    }
    else
    {
        // log an error
        string sDebug =  "SJ_TileMagic_ClearTile: failed as target (" + SJ_TileMagic_TileToString(oArea, sTag) + ") was not a valid object.";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
    }
}


void SJ_TileMagic_ConvertObjectToTile(object oObject = OBJECT_SELF)
{
    // get positional data for object
    int nColumn = SJ_TileMagic_GetColumn(oObject);
    int nRow = SJ_TileMagic_GetRow(oObject);
    object oArea = GetArea(oObject);

    // get data from object
    int bNormalise = GetLocalInt(oObject, SJ_VAR_TILEMAGIC_NORMALISE);
    int bUseLayer = GetLocalInt(oObject, SJ_VAR_TILEMAGIC_USE_LAYER);
    int nColumns = GetLocalInt(oObject, SJ_VAR_TILEMAGIC_COLUMNS);
    int nCorner = GetLocalInt(oObject, SJ_VAR_TILEMAGIC_CORNER);
    int nRotation = GetLocalInt(oObject, SJ_VAR_TILEMAGIC_ROTATION);
    int nRows = GetLocalInt(oObject, SJ_VAR_TILEMAGIC_ROWS);
    int nTile = GetLocalInt(oObject, SJ_VAR_TILEMAGIC_TILE);
    float fZ = GetLocalFloat(oObject, SJ_VAR_TILEMAGIC_Z);

    // dimensions can be omitted but we cannot have 0 columns or rows so correct
    nColumns = (nColumns == 0) ? 1 : nColumns;
    nRows = (nRows == 0) ? 1 : nRows;

    // adjust height for autotile (always) or marker (if flagged)
    if(GetTag(oObject) == SJ_TAG_TILEMAGIC_AUTOTILE || bUseLayer)
    {
        // height increases by 5m per layer
        fZ += IntToFloat(SJ_TileMagic_GetLayer(oObject));
    }

    // the default position for an autotile or marker is the bottom-left or SW
    // corner of a range. If nCorner has been used to change it's position then
    // nColumn and nRow must be adjusted to take account for this.
    switch(nCorner)
    {
        case SJ_TILEMAGIC_CORNER_NE:
            nColumn -= (nColumns - 1);
            nRow -= (nRows - 1);
            break;

        case SJ_TILEMAGIC_CORNER_NW:
            nRow -= (nRows - 1);
            break;

        case SJ_TILEMAGIC_CORNER_SE:
            nColumn -= (nColumns - 1);
            break;
    }

    // cover a tile or each tile in as required
    int nCurColumn, nCurRow;
    for(nCurColumn = nColumn; nCurColumn < nColumn + nColumns; nCurColumn++)
    {
        for(nCurRow = nRow; nCurRow < nRow + nRows; nCurRow++)
        {
            SJ_TileMagic_CoverTile(oArea, nTile, nCurColumn, nCurRow, fZ, bNormalise, nRotation);
        }
    }

    // immediate self-destruct
    DestroyObject(oObject);
}


void SJ_TileMagic_CoverArea(object oArea, int nTile, float fZ=0.0, int bNormalise=TRUE, int nRotation=0)
{
    // get area dimensions
    int nColumns = SJ_GetAreaWidth(oArea);
    int nRows = SJ_GetAreaHeight(oArea);

    // cover each tile in area
    int nCurColumn, nCurRow;
    for(nCurColumn = 0; nCurColumn < nColumns; nCurColumn++)
    {
        for(nCurRow = 0; nCurRow < nRows; nCurRow++)
        {
            SJ_TileMagic_CoverTile(oArea, nTile, nCurColumn, nCurRow, fZ, bNormalise, nRotation);
        }
    }
}


void SJ_TileMagic_CoverBorder(object oArea, int nTile, int nWidth=1, float fZ=0.0, int bNormalise=TRUE, int nRotation=0)
{
    // sanity check
    if(nWidth < 1)
    {
        string sDebug = "SJ_TileMagic_CoverBorder: failled as border width (" + IntToString(nWidth) + ") was invalid.";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
        return;
    }

    // get area dimensions
    int nColumns = SJ_GetAreaWidth(oArea);
    int nRows = SJ_GetAreaHeight(oArea);

    // cover each tile in border
    int nCurColumn, nCurRow;
    for(nCurColumn = 0; nCurColumn < nColumns; nCurColumn++)
    {
        for(nCurRow = 0; nCurRow < nRows; nCurRow++)
        {
            // A tile will fall within the border if its column or row index is
            // less than the border's width OR if its column index is the same
            // or greater than the number of columns less the border width OR if
            // its row index is the same or greater than the number of rows less
            // the border width.
            if(nCurColumn < nWidth
            || nCurRow < nWidth
            || nCurRow >= (nRows - nWidth)
            || nCurColumn >= (nColumns - nWidth))
            {
                SJ_TileMagic_CoverTile(oArea, nTile, nCurColumn, nCurRow, fZ, bNormalise, nRotation);
            }
        }
    }
}


void SJ_TileMagic_CoverMatrix(object oArea, object oMatrix, object oPalette, float fOffset=0.0)
{
    // sanity check
    if(GetIsObjectValid(oMatrix) == FALSE)
    {
        // log an error
        string sDebug = "SJ_TileMagic_CoverMatrix: matrix supplied was invalid.";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
        return;
    }
    else if(GetIsObjectValid(oPalette) == FALSE)
    {
        // log an error
        string sDebug = "SJ_TileMagic_CoverMatrix: palette supplied was invalid.";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
        return;
    }

    // register matrix and palette with area for easy retrival
    SetLocalObject(oArea, SJ_VAR_TILEMAGIC_MATRIX, oMatrix);
    SetLocalObject(oArea, SJ_VAR_TILEMAGIC_PALETTE, oPalette);
    SetLocalFloat(oArea, SJ_VAR_TILEMAGIC_OFFSET, fOffset);

    // get area dimensions
    int nColumns = SJ_GetAreaWidth(oArea);
    int nRows = SJ_GetAreaHeight(oArea);

    int nRow, nColumn;
    for(nRow = 0; nRow < nRows; nRow++)
    {
        // if using the TOPDOWN setting then start at the top row and work down
        // otherwise start at the bottom row and work up as normal
        int nIndex = (SJ_TILEMAGIC_TOPDOWN_MATRIX) ? (nRows - 1) - nRow  : nRow;

        // get row data for the current row,
        string sRow = GetLocalString(oMatrix, IntToString(nIndex));

        // skip row if row data null
        if(sRow == "")
        {
            // NOTE: do not log an error as this is permitted
            continue;
        }

        // if there is an entry for this row then
        for(nColumn = 0; nColumn < nColumns; nColumn++)
        {
            // get the style code for the current column
            string sStyle = GetSubString(sRow, nColumn, 1);

            // skip if style is null or blank (space or user-defined)
            if(sStyle != "" && sStyle != " " && sStyle != SJ_TILEMAGIC_STYLE_NONE)
            {
                // skip column if style is null
                if(GetLocalString(oPalette, sStyle) == "")
                {
                    // log an error but continue
                    string sDebug = "SJ_TileMagic_CoverMatrix: style (" + sStyle + ") did not exist in palette.";
                    SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
                    continue;
                }

                // get style information
                float fZ = GetLocalFloat(oPalette, sStyle + SJ_VAR_TILEMAGIC_Z);
                int nTile = GetLocalInt(oPalette, sStyle + SJ_VAR_TILEMAGIC_TILE);
                int bNormalise = GetLocalInt(oPalette, sStyle + SJ_VAR_TILEMAGIC_NORMALISE);
                int nRotation = GetLocalInt(oPalette, sStyle + SJ_VAR_TILEMAGIC_ROTATION);

                // NOTE: add matrix height (fOffset) to the style height (fZ)
                SJ_TileMagic_CoverTile(oArea, nTile, nColumn, nRow, fOffset + fZ, bNormalise, nRotation);
            }
        }
    }
}


void SJ_TileMagic_CoverRange(object oArea, int nTile, int nColumn=0, int nRow=0, int nColumns=1, int nRows=1, float fZ=0.0, int bNormalise=TRUE, int nRotation=0)
{
    // sanity check
    if(nColumns < 1 || nRows < 1)
    {
        // log an error
        string sDebug = "SJ_TileMagic_CoverRange: failed as the number of columns (" + IntToString(nColumns) + ") or rows (" + IntToString(nRows) + ") was invalid.";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
        return;
    }

    // cover tiles in range
    int nCurColumn, nCurRow;
    for(nCurColumn = nColumn; nCurColumn < nColumn + nColumns; nCurColumn++)
    {
        for(nCurRow = nRow; nCurRow < nRow + nRows; nCurRow++)
        {
            SJ_TileMagic_CoverTile(oArea, nTile, nCurColumn, nCurRow, fZ, bNormalise, nRotation);
        }
    }
}


void SJ_TileMagic_CoverSpot(object oArea, int nTile, float fX, float fY, float fZ=0.0, int bNormalise=TRUE, float fRotation=0.0)
{
    // use unique tag to ID tile node
    string sTag = SJ_TileMagic_GetTagForSpot(oArea, fX, fY);
    object oTile = GetObjectByTag(sTag);

    // is location valid?
    if(SJ_GetIsSpotValid(oArea, fX, fY))
    {
        // is there already tilemagic tile?
        if(GetIsObjectValid(oTile))
        {
            // clear existing tile to minimise impact/issues
            DestroyObject(oTile, SJ_TILEMAGIC_DELAY_CLEAR);
        }

        if(bNormalise)
        {
            // get normalised height as required
            fZ = SJ_TileMagic_GetNormalisedHeight(nTile, fZ);
        }

        // generate location
        location lTile = Location(oArea, Vector(fX, fY, fZ), fRotation);

        // create tile node and apply VFX
        oTile = CreateObject(OBJECT_TYPE_PLACEABLE, SJ_RES_INVISIBLE_OBJECT, lTile, FALSE, sTag);
        effect eTile = EffectVisualEffect(SJ_TileMagic_GetCorrectedConstant(nTile));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTile, oTile);

        SetPlotFlag(oTile, TRUE);
    }
    else
    {
        // log an error
        string sDebug =  "SJ_TileMagic_CoverSpot: failed as target (" + SJ_TileMagic_TileToString(oArea, sTag, nTile) + ") was outwith area.";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
    }
}


void SJ_TileMagic_CoverTile(object oArea, int nTile, int nColumn, int nRow, float fZ=0.0, int bNormalise=TRUE, int nRotation=0)
{
    // use unique tag to ID tile node
    string sTag = SJ_TileMagic_GetTagForTile(oArea, nColumn, nRow);
    object oTile = GetObjectByTag(sTag);

    // is location valid?
    if(SJ_GetIsTileValid(oArea, nColumn, nRow))
    {
        // is there already tile node?
        if(GetIsObjectValid(oTile))
        {
            // remove existing tile node to minimise impact/issues
            DestroyObject(oTile, SJ_TILEMAGIC_DELAY_CLEAR);
        }

        // calculate centre of actual tile
        float fX = 10.0 * nColumn + 5.0;
        float fY = 10.0 * nRow + 5.0;

        if(bNormalise)
        {
            // get normalised height as required
            fZ = SJ_TileMagic_GetNormalisedHeight(nTile, fZ);
        }

        // convert rotation from number of quarters to number of degrees
        nRotation = (nRotation < 0) ? Random(4) * 90 : (nRotation % 4) * 90;

        // generate location
        location lTile = Location(oArea, Vector(fX, fY, fZ), IntToFloat(nRotation));

        // create tile node and apply VFX
        oTile = CreateObject(OBJECT_TYPE_PLACEABLE, SJ_RES_INVISIBLE_OBJECT, lTile, FALSE, sTag);
        effect eTile = EffectVisualEffect(SJ_TileMagic_GetCorrectedConstant(nTile));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eTile, oTile);

        SetPlotFlag(oTile, TRUE);
		SetLocalInt(oTile, "GS_STATIC", TRUE);
    }
    else
    {
        // log an error
        string sDebug =  "SJ_TileMagic_CoverTile: failed as target (" + SJ_TileMagic_TileToString(oArea, sTag, nTile) + ") was outwith area.";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
    }
}


object SJ_TileMagic_CreateMatrix(string sName, int bUse2DA=FALSE)
{
    // sanity check: 2DA filenames are 16 chracters max
    if(GetStringLength(sName) > 16)
    {
        // log an error
        string sDebug = "SJ_TileMagic_CreateMatrix: resource name (" + sName + ") exceeded 16 characters and is invalid.";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
        return OBJECT_INVALID;
    }

    // check if datapoint already exists
    if(SJ_GetIsDatapointValid(sName))
    {
        // log an error
        string sDebug = "SJ_TileMagic_CreateMatrix: resource (" + sName + ") aready exists.";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
        return OBJECT_INVALID;
    }

    // create a datapoint
    object oMatrix = SJ_CreateDatapoint(sName);

    // populate datapoint
    if(bUse2DA)
    {
        int nIndex = 0;

        // read each row data string in turn, interpret "" as EOF
        string sRow = Get2DAString(sName, SJ_TILEMAGIC_2DA_ROW, nIndex);
        while(sRow != "")
        {
            // add data to datapoint
            SJ_TileMagic_AddRowToMatrix(oMatrix, nIndex, sRow);

            // read next row
            // NOTE: use pre-increment to avoid duplicating the first row
            sRow = Get2DAString(sName, SJ_TILEMAGIC_2DA_ROW, ++nIndex);
        }
    }

    // return datapoint
    return oMatrix;
}


object SJ_TileMagic_CreatePalette(string sName, int bUse2DA=FALSE)
{
    // sanity check: 2DA filenames are 16 chracters max
    if(GetStringLength(sName) > 16)
    {
        // log an error
        string sDebug = "SJ_TileMagic_CreatePalette: resource name (" + sName + ") exceeded 16 characters and is invalid.";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
        return OBJECT_INVALID;
    }

    // check if datapoint already exists
    if(SJ_GetIsDatapointValid(sName))
    {
        // log an error
        string sDebug = "SJ_TileMagic_CreatePalette: resource (" + sName + ") aready exists.";
        SJ_Debug(SJ_DEBUG_PREFIX_ERROR + sDebug, TRUE);
        return OBJECT_INVALID;
    }

    // create datapoint
    object oPalette = SJ_CreateDatapoint(sName);

    // populate datapoint
    if(bUse2DA)
    {
        int nIndex;

        // read each style code and if valid add style information to palette,
        // interpret "" as EOF
        string sStyle = Get2DAString(sName, SJ_TILEMAGIC_2DA_STYLE, nIndex);
        while(sStyle != "")
        {
            // read style information
            int nTile = StringToInt(Get2DAString(sName, SJ_TILEMAGIC_2DA_TILE, nIndex));
            int bNormalise = StringToInt(Get2DAString(sName, SJ_TILEMAGIC_2DA_NORMALISE, nIndex));
            float fZ = StringToFloat(Get2DAString(sName, SJ_TILEMAGIC_2DA_Z, nIndex));
            int nRotation = StringToInt(Get2DAString(sName, SJ_TILEMAGIC_2DA_ROTATION, nIndex));

            // add data to datapoint
            SJ_TileMagic_AddStyleToPalette(oPalette, sStyle, nTile, fZ, bNormalise, nRotation);

            // get the next style code
            // NOTE: use pre-increment to avoid duplicating the first style
            sStyle = Get2DAString(sName, SJ_TILEMAGIC_2DA_STYLE, ++nIndex);
        }
    }

    // return datapoint
    return oPalette;
}


int SJ_TileMagic_GetAreaID(object oArea)
{
    // check area for ID
    int nID = GetLocalInt(oArea, SJ_VAR_TILEMAGIC_AREA_ID);

    if(nID == 0)
    {
        // no ID: generate a new ID by incrementing last ID assigned, update the
        // gobal value and assign to area for future use
        nID = GetLocalInt(GetModule(), SJ_VAR_TILEMAGIC_AREA_ID) + 1;
        SetLocalInt(GetModule(), SJ_VAR_TILEMAGIC_AREA_ID, nID);
        SetLocalInt(oArea, SJ_VAR_TILEMAGIC_AREA_ID, nID);
    }

    // return area ID
    return nID;
}


int SJ_TileMagic_GetCorrectedConstant(int nTile)
{
    // correct values corresponding to duplicated 2DA entries
    switch(nTile)
    {
        // parse nTile for special cases
        case 348: nTile = SJ_TILEMAGIC_FEATURE_CITY_MARBLE_ARCH;     break;
        case 430: nTile = SJ_TILEMAGIC_FEATURE_ITHILLID_TRANSPORTER; break;
        case 431: nTile = SJ_TILEMAGIC_FEATURE_UNDERDARK_WATERFALL;  break;
        case 441: nTile = SJ_TILEMAGIC_FEATURE_GRASS_ANT_HILL;       break;
        case 453: nTile = SJ_TILEMAGIC_FEATURE_CITY_MARBLE_ARCH;     break;
        case 458: nTile = SJ_TILEMAGIC_FEATURE_CITY_MARKET_1;        break;
    }

    // return corrected tile constant
    return nTile;
}


int SJ_TileMagic_GetColumn(object oObject)
{
    // tiles are 10m wide
    vector vObject = GetPosition(oObject);
    return FloatToInt(vObject.x) / 10;
}


int SJ_TileMagic_GetLayer(object oObject)
{
    // layers are 1m high
    vector vObject = GetPosition(oObject);
    int nRet = FloatToInt(vObject.z);

    // lower limit is enforced at 0
    return nRet = (nRet > 0) ? nRet : 0;
}


float SJ_TileMagic_GetNormalisedHeight(int nTile, float fZ)
{
    // compensate for tiles with built-in non-zero heights
    switch(nTile)
    {
        // parse nTile for special cases
        case SJ_TILEMAGIC_ORDINARY_LAVA:         fZ += 1.00; break;
        case SJ_TILEMAGIC_ORDINARY_PIT:          fZ += 2.40; break;
        case SJ_TILEMAGIC_ORDINARY_WATER_GREEN:  fZ += 2.00; break;
        case SJ_TILEMAGIC_ORDINARY_WATER_BLUE_1: fZ += 1.00; break;
        case SJ_TILEMAGIC_ORDINARY_WATER_BLUE_2: fZ += 1.00; break;
        case SJ_TILEMAGIC_FEATURE_LAVA_FOUNTAIN: fZ += 1.00; break;
    }

    // return normalised height
    return fZ;
}


int SJ_TileMagic_GetRow(object oObject)
{
    // tiles are 10m high
    vector vObject = GetPosition(oObject);
    return FloatToInt(vObject.y) / 10;
}


string SJ_TileMagic_GetTagForSpot(object oArea, float fX, float fY)
{
    // format: AAA_XXXXXxYYYYY
    // fX and fY range from 0.00 to 319.99
    string sTag = SJ_TILEMAGIC_PREFIX;
    sTag += SJ_IntToPrePaddedString(SJ_TileMagic_GetAreaID(oArea), 3) + "_";
    sTag += SJ_IntToPrePaddedString(FloatToInt(fX * 100), 5) + "x";
    sTag += SJ_IntToPrePaddedString(FloatToInt(fY * 100), 5);

    return sTag;
}


string SJ_TileMagic_GetTagForTile(object oArea, int nColumn, int nRow)
{
    // format: AAAA_CCxRR
    // nColumn and nRow range from 0 to 31
    string sTag = SJ_TILEMAGIC_PREFIX;
    sTag += SJ_IntToPrePaddedString(SJ_TileMagic_GetAreaID(oArea), 3) + "_";
    sTag += SJ_IntToPrePaddedString(nColumn, 2) + "x";
    sTag += SJ_IntToPrePaddedString(nRow, 2);

    return sTag;
}


void SJ_TileMagic_SwitchMatrix(object oArea, object oMatrix, float fOffset=0.0)
{
    // TODO: it may be possible to make a more efficient version from the point
    // of view of comparing effects rather than creating and destroying objects
    // however it is not worth pursuing at this time.

    // get palette registered with area
    object oPalette = GetLocalObject(oArea, SJ_VAR_TILEMAGIC_PALETTE);

    // clear and recover
    SJ_TileMagic_ClearMatrix(oArea);
    SJ_TileMagic_CoverMatrix(oArea, oMatrix, oPalette, fOffset);

}


void SJ_TileMagic_SwitchPalette(object oArea, object oPalette)
{
    // TODO: it may be possible to make a more efficient version from the point
    // of view of comparing effects rather than creating and destroying objects
    // however it is not worth pursuing at this time.

    // get matrix registered with area
    object oMatrix = GetLocalObject(oArea, SJ_VAR_TILEMAGIC_MATRIX);
    float fOffset = GetLocalFloat(oArea, SJ_VAR_TILEMAGIC_OFFSET);

    // clear and recover
    SJ_TileMagic_ClearMatrix(oArea);
    SJ_TileMagic_CoverMatrix(oArea, oMatrix, oPalette, fOffset);
}


string SJ_TileMagic_TileToString(object oArea, string sTag, int nTile=0)
{
    string sRet;

    // format = area name | tile tag | tile VFX constant
    sRet += GetName(oArea) + " | " + SJ_RemoveSubString(sTag, SJ_TILEMAGIC_PREFIX);
    if(nTile) sRet += " | " + IntToString(nTile);

    // return description
    return sRet;
}
