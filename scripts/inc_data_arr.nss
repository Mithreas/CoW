// This file exposes arrays for four data types: float, integer, object, and string.
// The functionality contained within depends on nwnx_data.
//
// There are a few reasons to use this functionality over a traditional nwscript-native array implementation.
//
//     1. Speed. The advantages here are two-fold. First, operations (particularly search operations)
//        are carried out OUTWITH nwscript, which means that a) they do not count towards the instruciton
//        count, and b) they are much faster.
//
//     2. Functionality. Because of advantage 1., we can offer rich functionality that is typically
//        missing from nwscript-native collection classes, such as sorting, inserting, copying, etc.
//
//     3. Cleanliness. This array class does not use variables. Therefore, the array contents will
//        not be stored on the object in any way that can interact with nwscript. This confers both
//        a speed advantage (variable lookups don't have to skip over a potentially large array) and
//        a cleanliness advantage.
//
// In particular, rather than storing cached values on random magical objects that you've created on
// the module, it is highly advantageous to use an array on either OBJECT_INVALID, or on GetModule().
// There is no disadvantage to having hundreds of arrays assigned to OBJECT_INVALID or the module, so go wild!
//
// Note that these arrays are TEMPORARY. They are stored IN MEMORY and are lost ON MOUDLE SHUTDOWN.
// If you want to persist these arrays, you must serialise them, probably by storing as a string.
//
// Each array class exposes the following functions, where T is the data type:
//
//     // Returns the element at the index.
//     T Array_At(object obj, string tag, int index);
//
//     // Clears the entire array, such that size==0.
//     void Array_Clear(object obj, string tag);
//
//     // Returns TRUE if the collection contains the element.
//     int Array_Contains(object obj, string tag, T element);
//
//     // Copies the array of name otherTag over the array of name tag.
//     void Array_Copy(object obj, string tag, string otherTag);
//
//     // Erases the element at index, and shuffles any elements from index size-1 to index + 1 left.
//     void Array_Erase(object obj, string tag, int index);
//
//     // Returns the index at which the element is located, or ARRAY_INVALID_INDEX.
//     int Array_Find(object obj, string tag, T element);
//
//     // Inserts the element at the index, where size > index >= 0.
//     void Array_Insert(object obj, string tag, int index, T element);
//
//     // Pushes an element to the back of the collection.
//     // Functionally identical to an insert at index size-1.
//     void Array_PushBack(object obj, string tag, T element);
//
//     // Resizes the array. If the array is shrinking, it chops off elements at the ned.
//     void Array_Resize(object obj, string tag, int size);
//
//     // Returns the size of the array.
//     int Array_Size(object obj, string tag);
//
//     // Reorders the array such each possible permutation of elements has equal probability of appearance.
//     void Array_Shuffle(object obj, string tag);
//
//     // Sorts the collection based on descending order.
//     void Array_SortAscending(object obj, string tag);
//
//     // Sorts the collection based on descending order.
//     void Array_SortDescending(object obj, string tag);
//

// This value is returned by search operations to indicate that the requested
// item is not present in the collection.
const int ARRAY_INVALID_INDEX = -1;

#include "inc_data_arr_flt"
#include "inc_data_arr_int"
#include "inc_data_arr_obj"
#include "inc_data_arr_str"
