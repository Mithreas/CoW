//::///////////////////////////////////////////////
//:: Tailoring - Rotate Model Counter-Clockwise
//:: tlr_rotatecountr.nss
//:: Copyright (c) 2003 Jake E. Fitch
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Jake E. Fitch (Milambus Mandragon)
//:: Created On: March 9, 2004
//:://////////////////////////////////////////////
void main()
{
    float fNewFace = GetFacing(OBJECT_SELF) + 30.0;

    if (fNewFace > 360.0) fNewFace -= 360.0;

    AssignCommand(OBJECT_SELF, SetFacing(fNewFace));
}
