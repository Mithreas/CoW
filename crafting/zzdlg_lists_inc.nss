// zzdlg_lists_inc
//
// Original filename under Z-Dialog: zdlg_lists
// Copyright (c) 2004 Paul Speed - BSD licensed.
//  NWN Tools - http://nwntools.sf.net/

const string LIST_PREFIX = "zzdlgList:";

///// Core prototypes

// Returns the number of items in the specified list.
int GetElementCount( string list, object holder = OBJECT_SELF);

// Removes the list element at the specified index.  Returns
// the new item count.
int RemoveElement( int index, string list, object holder = OBJECT_SELF);

// Removes the list elements from start to end-1 inclusive at the
// specified index.  Returns the new item count.
int RemoveElements( int start, int end, string list, object holder = OBJECT_SELF);

// Deletes the list and all contents.  Returns the number
// of elements deleted in the process.
int DeleteList( string list, object holder = OBJECT_SELF);

///// STRING Prototypes

// Adds a string item to the list and return the new item count.
int AddStringElement( string item, string list, object holder = OBJECT_SELF);

// Returns the string item at the specified index.
string GetStringElement( int index, string list, object holder = OBJECT_SELF);

// Replaces the string element at specified index.  Returns TRUE if successful.
// FALSE if nothing exists to be replaced.
int ReplaceStringElement(int index, string newitem, string list, object holder);

// Begins a list iteration for string values
string GetFirstStringElement( string list, object holder = OBJECT_SELF);

// Returns the next item in a list iteration
string GetNextStringElement();

//// OBJECT Prototypes

// Adds an object item to the list and return the new item count.
int AddObjectElement( object item, string list, object holder = OBJECT_SELF);

// Returns the object item at the specified index.
object GetObjectElement( int index, string list, object holder = OBJECT_SELF);

// Begins a list iteration for object values
object GetFirstObjectElement( string list, object holder = OBJECT_SELF);

// Returns the next item in an object list iteration
object GetNextObjectElement();

//// INT Prototypes

// Adds an int item to the list and return the new item count.
int AddIntElement( int item, string list, object holder = OBJECT_SELF);

// Returns the int item at the specified index.
int GetIntElement( int index, string list, object holder = OBJECT_SELF);

// Begins a list iteration for int values
int GetFirstIntElement( string list, object holder = OBJECT_SELF);

// Returns the next item in a list iteration
int GetNextIntElement();


string currentList = "";
object currentHolder = OBJECT_INVALID;
int currentCount = 0;
int currentIndex = -1;

// Internal function to get the string for a given
// index
string IndexToString( int index, string list )
{
    return( LIST_PREFIX + list + "." + IntToString(index) );
}

// Returns the number of items in the specified list.
int GetElementCount( string list, object holder = OBJECT_SELF)
{
    return( GetLocalInt( holder, LIST_PREFIX + list ) );
}

// Removes the list element at the specified index.  Returns
// the new item count.
int RemoveElement( int index, string list, object holder )
{
    int count = GetElementCount( list, holder );
    if( count == 0 )
        return( count );

    // Shift all of the other elements forward
    int i;
    string next;
    for( i = index; i < count - 1; i++ )
        {
        // We don't know what type the list elements are
        // (and they could be any), so we shift them all.
        // This function is already expensive enough anyway.
        string current = IndexToString( i, list );
        next = IndexToString( i + 1, list );

        SetLocalFloat( holder, current, GetLocalFloat( holder, next ) );
        SetLocalInt( holder, current, GetLocalInt( holder, next ) );
        SetLocalLocation( holder, current, GetLocalLocation( holder, next ) );
        SetLocalObject( holder, current, GetLocalObject( holder, next ) );
        SetLocalString( holder, current, GetLocalString( holder, next ) );
        }

    // Delete the top item
    DeleteLocalFloat( holder, next );
    DeleteLocalInt( holder, next );
    DeleteLocalLocation( holder, next );
    DeleteLocalObject( holder, next );
    DeleteLocalString( holder, next );

    count--;
    SetLocalInt( holder, LIST_PREFIX + list, count );

    return( count );
}

// Removes the list elements from start to end-1 inclusive at the
// specified index.  Returns the new item count.
int RemoveElements( int start, int end, string list, object holder )
{
    int count = GetElementCount( list, holder );
    if( count == 0 )
        return( count );

    // Shift all of the other elements forward
    int i;
    string next;
    int removeCount = end - start;
    for( i = start; i < count - removeCount; i++ )
        {
        // We don't know what type the list elements are
        // (and they could be any), so we shift them all.
        // This function is already expensive enough anyway.
        string current = IndexToString( i, list );
        next = IndexToString( i + removeCount, list );

        SetLocalFloat( holder, current, GetLocalFloat( holder, next ) );
        SetLocalInt( holder, current, GetLocalInt( holder, next ) );
        SetLocalLocation( holder, current, GetLocalLocation( holder, next ) );
        SetLocalObject( holder, current, GetLocalObject( holder, next ) );
        SetLocalString( holder, current, GetLocalString( holder, next ) );
        }

    // Delete the top items
    for( i = count - removeCount; i < count; i++ )
        {
        next = IndexToString( i, list );
        DeleteLocalFloat( holder, next );
        DeleteLocalInt( holder, next );
        DeleteLocalLocation( holder, next );
        DeleteLocalObject( holder, next );
        DeleteLocalString( holder, next );
        }

    count -= removeCount;
    SetLocalInt( holder, LIST_PREFIX + list, count );

    return( count );
}

// Deletes the list and all contents.  Returns the number
// of elements deleted in the process.
int DeleteList( string list, object holder = OBJECT_SELF)
{
    int count = GetElementCount( list, holder );
    if( count == 0 )
        return( count );

    // Delete all elements
    int i;
    for( i = 0; i < count; i++ )
        {
        string current = IndexToString( i, list );
        DeleteLocalFloat( holder, current );
        DeleteLocalInt( holder, current );
        DeleteLocalLocation( holder, current );
        DeleteLocalObject( holder, current );
        DeleteLocalString( holder, current );
        }

    // Delete the main list info
    DeleteLocalInt( holder, LIST_PREFIX + list );

    return( count );
}

///// STRING FUNCTIONS

// Adds a string item to the list and return the new item count.
int AddStringElement( string item, string list, object holder = OBJECT_SELF)
{
    int count = GetElementCount( list, holder );
    SetLocalString( holder, IndexToString( count, list ), item );
    count++;
    SetLocalInt( holder, LIST_PREFIX + list, count );

    return( count );
}

// Returns the string item at the specified index.
string GetStringElement( int index, string list, object holder = OBJECT_SELF)
{
    int count = GetElementCount( list, holder );
    if( index >= count )
        {
        PrintString( "Error: (GetStringItem) index out of bounds["
                     + IntToString(index) + "] in list:" + list );
        return( "" );
        }
    return( GetLocalString( holder, IndexToString( index, list ) ) );
}

// Replaces item with newitem.
int ReplaceStringElement(int index, string newitem, string list, object holder)
{
   if (GetStringElement(index, list, holder) == "")
   {
     // No item exists
     return FALSE;
   }

   SetLocalString(holder, IndexToString(index,list), newitem);
   return TRUE;
}

// Begins a list iteration for string values
string GetFirstStringElement( string list, object holder = OBJECT_SELF )
{
    object oModule = GetModule();
    SetLocalInt(oModule, "LISTS_CURRENT_COUNT", GetElementCount( list, holder ));
    SetLocalInt(oModule, "LISTS_CURRENT_INDEX", 0);
    SetLocalObject(oModule, "LISTS_CURRENT_HOLDER", holder);
    SetLocalString(oModule, "LISTS_CURRENT_LIST", list);

    return( GetLocalString( holder, IndexToString( 0, list ) ) );
}

// Returns the next item in a list iteration
string GetNextStringElement()
{
    object oModule = GetModule();
    int currentIndex = GetLocalInt(oModule, "LISTS_CURRENT_INDEX") + 1;
    object currentHolder = GetLocalObject(oModule, "LISTS_CURRENT_HOLDER");
    string currentList = GetLocalString(oModule, "LISTS_CURRENT_LIST");
    int currentCount = GetLocalInt(oModule, "LISTS_CURRENT_COUNT");

    SetLocalInt(oModule, "LISTS_CURRENT_INDEX", currentIndex);

    if( currentIndex >= currentCount )
        return( "" );
    return( GetLocalString( currentHolder, IndexToString( currentIndex, currentList ) ) );
}

//// OBJECT FUNCTIONS

// Adds an object item to the list and return the new item count.
int AddObjectElement( object item, string list, object holder = OBJECT_SELF)
{
    int count = GetElementCount( list, holder );
    SetLocalObject( holder, IndexToString( count, list ), item );
    count++;
    SetLocalInt( holder, LIST_PREFIX + list, count );

    return( count );
}

// Returns the object item at the specified index.
object GetObjectElement( int index, string list, object holder = OBJECT_SELF)
{
    int count = GetElementCount( list, holder );
    if( index >= count )
        {
        PrintString( "Error: (GetObjectItem) index out of bounds[" + IntToString(index)
                     + "] in list:" + list );
        return( OBJECT_INVALID );
        }
    return( GetLocalObject( holder, IndexToString( index, list ) ) );
}

// Begins a list iteration for object values
object GetFirstObjectElement( string list, object holder )
{
    object oModule = GetModule();
    SetLocalInt(oModule, "LISTS_CURRENT_COUNT", GetElementCount( list, holder ));
    SetLocalInt(oModule, "LISTS_CURRENT_INDEX", 0);
    SetLocalObject(oModule, "LISTS_CURRENT_HOLDER", holder);
    SetLocalString(oModule, "LISTS_CURRENT_LIST", list);

    return( GetLocalObject( holder, IndexToString( 0, list ) ) );
}

// Returns the next item in an object list iteration
object GetNextObjectElement()
{
    object oModule = GetModule();
    int currentIndex = GetLocalInt(oModule, "LISTS_CURRENT_INDEX") + 1;
    object currentHolder = GetLocalObject(oModule, "LISTS_CURRENT_HOLDER");
    string currentList = GetLocalString(oModule, "LISTS_CURRENT_LIST");
    int currentCount = GetLocalInt(oModule, "LISTS_CURRENT_COUNT");

    SetLocalInt(oModule, "LISTS_CURRENT_INDEX", currentIndex);

    if( currentIndex >= currentCount )
        return( OBJECT_INVALID );
    return( GetLocalObject( currentHolder, IndexToString( currentIndex, currentList ) ) );
}

//// INT FUNCTIONS

// Adds an int item to the list and return the new item count.
int AddIntElement( int item, string list, object holder = OBJECT_SELF)
{
    int count = GetElementCount( list, holder );
    SetLocalInt( holder, IndexToString( count, list ), item );
    count++;
    SetLocalInt( holder, LIST_PREFIX + list, count );

    return( count );
}

// Returns the int item at the specified index.
int GetIntElement( int index, string list, object holder = OBJECT_SELF)
{
    int count = GetElementCount( list, holder );
    if( index >= count )
        {
        PrintString( "Error: (GetIntItem) index out of bounds[" + IntToString(index)
                     + "] in list:" + list );
        return( -1 );
        }
    return( GetLocalInt( holder, IndexToString( index, list ) ) );
}

// Begins a list iteration for int values
int GetFirstIntElement( string list, object holder )
{
    object oModule = GetModule();
    SetLocalInt(oModule, "LISTS_CURRENT_COUNT", GetElementCount( list, holder ));
    SetLocalInt(oModule, "LISTS_CURRENT_INDEX", 0);
    SetLocalObject(oModule, "LISTS_CURRENT_HOLDER", holder);
    SetLocalString(oModule, "LISTS_CURRENT_LIST", list);

    return( GetLocalInt( holder, IndexToString( 0, list ) ) );
}

// Returns the next item in a list iteration
int GetNextIntElement()
{
    object oModule = GetModule();
    int currentIndex = GetLocalInt(oModule, "LISTS_CURRENT_INDEX") + 1;
    object currentHolder = GetLocalObject(oModule, "LISTS_CURRENT_HOLDER");
    string currentList = GetLocalString(oModule, "LISTS_CURRENT_LIST");
    int currentCount = GetLocalInt(oModule, "LISTS_CURRENT_COUNT");

    SetLocalInt(oModule, "LISTS_CURRENT_INDEX", currentIndex);

    if( currentIndex >= currentCount )
        return( -1 );
    return( GetLocalInt( currentHolder, IndexToString( currentIndex, currentList ) ) );
}


/*void main()
{
}*/
