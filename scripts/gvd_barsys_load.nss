#include "gvd_inc_bar"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"

// loops through all gvd_barsys_res placeables and assigns a random drink to them
// and loops through all gvd_barsys_npc merchants and sets a local object variable on them with the corresponding bar store.

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    string sBarDrink;
    string sBarID;
    int iBarResource = 0;
    object oBarResource = GetObjectByTag("gvd_barsys_res", iBarResource);
    int iDraft;
    int iNamelist = 0;

    while (oBarResource != OBJECT_INVALID) {
 
      // first check if the bar resource hasn't got a fixed drink assigned to it
      if (GetLocalString(oBarResource,"gvd_fixed_drink") == "") {
        // is it a draft or other resource?
        iDraft = GetLocalInt(oBarResource, "gvd_draft");

        // Batra: are we in the UD or another special location?
        // (0 = Surface (default), 1 = Underdark)
        iNamelist = GetLocalInt(oBarResource, "gvd_namelist");        

        // get a random name and set this as name/desc
        sBarDrink = GetRandomDrinkName(iDraft, iNamelist);
        SetName(oBarResource, sBarDrink);
        SetDescription(oBarResource, sBarDrink);
        
        // get the BarID
        sBarID = GetBarID(oBarResource);

        // see if there is an advertismentboard
        AddDrinkToSign(sBarDrink, sBarID);

        // add drink to NPC store
        AddDrinkToStore(sBarDrink, sBarID, iDraft);
        
      } else {
        // fixed drink, leave as is
      }

      // next object 
      iBarResource = iBarResource + 1;
      oBarResource = GetObjectByTag("gvd_barsys_res", iBarResource);

    }

    // loop through all NPC barkeepers
    iBarResource = 0;
    oBarResource = GetObjectByTag("gvd_barsys_npc", iBarResource);
    object oStore;
    string sTag;

    while (oBarResource != OBJECT_INVALID) {
      
      // get the BarID
      sBarID = GetBarID(oBarResource);

      // get the store for this bar
      oStore = GetStoreForBar(sBarID);

      // set this as local variable for easy use later
      SetLocalObject(oBarResource, "gvd_store", oStore);

      // set the tag of the NPC if the gvd_tag variable is set
      sTag = GetLocalString(oBarResource, "gvd_tag");
      if (sTag != "") {
        SetTag(oBarResource, sTag);
      }

      // next object 
      iBarResource = iBarResource + 1;
      oBarResource = GetObjectByTag("gvd_barsys_npc", iBarResource);

    }

    DestroyObject(OBJECT_SELF);
}
