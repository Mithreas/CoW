#include "ar_timberfleet"

void main()
{
    int nHour = GetTimeHour();
    object oArea = GetArea(OBJECT_SELF);
    string sTag = GetTag(oArea);


    //::  Brog-Guldorland       24-3
    if (sTag == "AR_SHIP_FROM_BROG")
    {
        if (nHour >= 3)     ar_Arrive( oArea );
    }
    //::  Guldorland-Cordor     5-7
    else if (sTag == "AR_SHIP_TO_CORDOR")
    {
        if (nHour >= 7 || nHour < 5)    ar_Arrive( oArea );
    }
    //::  Cordor-Guldorland     12-14
    else if (sTag == "AR_SHIP_FROM_CORDOR")
    {
        if (nHour >= 14 || nHour < 12)    ar_Arrive( oArea );
    }
    //::  Guldorland-Brog       17-20
    else if (sTag == "AR_SHIP_TO_BROG")
    {
        if (nHour >= 20 || nHour < 17)    ar_Arrive( oArea );
    }

}
