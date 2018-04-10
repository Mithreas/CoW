//::///////////////////////////////////////////////
//:: Executed Script: Yoink Reset
//:: exe_yoinkrst
//:://////////////////////////////////////////////
/*
    Resets the Yoink variables on oCaster to allow
    to allow multiple yoink attempts if the oTarget
    did not accept Yoink.
    The standard behaviour 1 Yoink per rest still 
    applies
*/
//:://////////////////////////////////////////////
//:: Created By: Miesny_Jez
//:: Created On: December 09, 2017
//:://////////////////////////////////////////////

void main()
{
    if(GetLocalInt(OBJECT_SELF, "YOINKING"))
    { // Sanity Check
    	object oTarget = GetLocalObject(OBJECT_SELF, "YOINK_TARGET");
    	
    	//Clear Yoinking Variables from both oCaster and oTarget
    	DeleteLocalInt(OBJECT_SELF,"YOINKING");			// stored on oCaster    	
    	DeleteLocalObject(oTarget, "MI_YOINKER");		// stored on oTarger    	
		DeleteLocalObject(OBJECT_SELF, "YOINK_TARGET");	// stored on oCaster    	
	}
}
