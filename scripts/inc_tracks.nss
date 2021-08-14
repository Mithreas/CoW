#include "inc_subrace"
#include "inc_combat2"
#include "inc_customspells"
void miTRDoTracks(object oPC, int bEntering=TRUE)
{
        object oArea = GetArea(oPC);
        int nSubRace = gsSUGetSubRaceByName(GetSubRace(oPC));
        string sSubRace = gsSUGetNameBySubRace(nSubRace);

        if (!GetIsAreaNatural(oArea)) return;
        if (GetHasFeat(FEAT_TRACKLESS_STEP, oPC)) return;
        if (miSCIsScrying(oPC)) return;
        int nBaseAC = gsCMGetItemBaseAC(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
        if(nBaseAC < 4 && (nSubRace == GS_SU_SPECIAL_FEY)) return;
        object oTracks = GetNearestObjectByTag("mi_tracks2", oPC);
        if (!GetIsObjectValid(oTracks) || GetDistanceBetween(oTracks, oPC) > 5.0)
        {
          oTracks = CreateObject(OBJECT_TYPE_PLACEABLE, "mi_tracks", GetLocation(oPC));
        }

        string sTracks = GetLocalString(oTracks, "MI_TRACKS");


        string sDescription;


        switch (nSubRace)
        // Override for aasimar, tieflings, genasi and other subraces very
        // similar culturally and physically to base.
        {
          case GS_SU_NONE:
            sSubRace = gsSUGetRaceName(GetRacialType(oPC));
            break;
        }

        // Override for polymorphed.
        if (gsC2GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC))
          sSubRace = "creature";

        string sEntering = bEntering ? "(Entering) " : "(Leaving) ";

        if (nBaseAC == 0) sDescription = sEntering + "an unarmoured " + sSubRace;
        else if (nBaseAC < 4) sDescription = sEntering + "a lightly armoured " + sSubRace;
        else if (nBaseAC < 6) sDescription = sEntering + "a medium armoured " + sSubRace;
        else sDescription = sEntering + "a heavily armoured " + sSubRace;

        sTracks += (sTracks == "" ? "" : ",") + sDescription;

        SetLocalString(oTracks, "MI_TRACKS", sTracks);
}
