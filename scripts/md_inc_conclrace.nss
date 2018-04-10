#include "mi_inc_class"

//Adds race options to zdlg, nBit is the currently saved bit
void md_SetUpRaceList(string sPage, int nBit, object oHolder = OBJECT_SELF);
//On selection for race options for zdlg
int md_GetRaceSelection(int selection);
//Adds class options to zdlg, nBit is the currently saved bit
void md_SetUpClassList(string sPage, int nBit, object oHolder = OBJECT_SELF, int nIgnoreHarper = TRUE);
//On selection for class options for zdlg
int md_GetClassSelection(int selection, int nIgnoreHarper = TRUE);

void _AddBitString(int nBit, string sString, string sPage, int nRace, object oHolder)
{
    if(nRace == 0)
        return; //reject if bit is empty
    string sColor;
    if((nBit & nRace) == nRace)
        sColor = STRING_COLOR_GREEN;
    else
        sColor = STRING_COLOR_RED;

    AddStringElement(StringToRGBString(sString, sColor), sPage, oHolder);

}

void md_SetUpRaceList(string sPage, int nBit, object oHolder = OBJECT_SELF)
{
    if(GetElementCount(sPage) == 0)
    {
        //int nBit = GetLocalInt(oCzar, VAR_BIT);
        int x;
        for(x=0;x<=6;x++)
            _AddBitString(nBit, gsSUGetRaceName(x), sPage, md_ConvertRaceToBit(x), oHolder);

        for(x=1;x<=HIGHEST_SR;x++)
        {
            if(x == 15) //genasi not in system
                x = 19;
                                                                                                                                  //we don't need two listings of orog
            while(x == GS_SU_ELF_MOON || x == GS_SU_GNOME_ROCK || x == GS_SU_HALFLING_LIGHTFOOT || x == GS_SU_DWARF_SHIELD || x == GS_SU_FR_OROG)
                x++;
            _AddBitString(nBit, gsSUGetNameBySubRace(x), sPage, md_ConvertSubraceToBit(x), oHolder);
        }

        for(x=100;x<=HIGHEST_SSR;x++)
        {
            if(x == 103)
                x = 107;
            _AddBitString(nBit, gsSUGetNameBySubRace(x), sPage, md_ConvertSubraceToBit(x), oHolder);
        }

        _AddBitString(nBit, "Group: Underdark Races", sPage, MD_BIT_UNDARK, oHolder);
        _AddBitString(nBit, "Group: Surface Elves", sPage, MD_BIT_SU_ELF, oHolder);
        _AddBitString(nBit, "Group: Hin/Halflings", sPage, MD_BIT_SU_HL, oHolder);
        _AddBitString(nBit, "Group: Earthkin", sPage, MD_BIT_EARTHKIN, oHolder);

    }
}

int md_GetRaceSelection(int selection)
{
        int nBit;
        if(selection == 29)
            nBit = MD_BIT_UNDARK;
        else if(selection == 30)
            nBit = MD_BIT_SU_ELF;
        else if(selection == 31)
            nBit = MD_BIT_SU_HL;
        else if(selection == 32)
            nBit = MD_BIT_EARTHKIN;
        else if(selection > 6)
        {

            if(selection > 22)
            {
                selection += 77;
                if(selection > 102)
                    selection+=4;
            }
            else if(selection > 20)
                selection += 3;
            else if(selection >= 17)
                selection += 2;
            else
            {
                selection -= 6;

                if(selection >= GS_SU_HALFLING_LIGHTFOOT-3)
                    selection += 4;
                else if(selection >= GS_SU_GNOME_ROCK-2)
                    selection += 3;
                else if(selection >= GS_SU_ELF_MOON-1)
                    selection += 2;
                else if(selection >= GS_SU_DWARF_SHIELD)
                    selection++;


            }


            nBit = md_ConvertSubraceToBit(selection);
        }
        else
            nBit = md_ConvertRaceToBit(selection);

       return nBit;

}

void md_SetUpClassList(string sPage, int nBit, object oHolder = OBJECT_SELF, int nIgnoreHarper = TRUE)
{
    // If you add to this method, you will also need to update md_GetClassSelection accordingly.
    if(GetElementCount(sPage) == 0)
    {
        int x;
        for(x=0;x<=10;x++)
        {
            //if(x == CLASS_TYPE_PALADIN)
               // x++;

            _AddBitString(nBit, mdGetClassName(x), sPage, mdConvertClassToBit(x), oHolder);
        }

        for(x=27;x<=37;x++)
        {
            //while(x == CLASS_TYPE_ASSASSIN || x == CLASS_TYPE_SHIFTER || x == CLASS_TYPE_HARPER || x == CLASS_TYPE_BLACKGUARD || x == CLASS_TYPE_PALEMASTER)
            if(x == CLASS_TYPE_HARPER && nIgnoreHarper)
                x++;

            _AddBitString(nBit, mdGetClassName(x), sPage, mdConvertClassToBit(x), oHolder);
        }

        _AddBitString(nBit, "Knight", sPage, MD_BIT_PDK, oHolder);
        _AddBitString(nBit, "Favored Soul", sPage, MD_BIT_FAVSOUL, oHolder);
        _AddBitString(nBit, "Warlock", sPage, MD_BIT_WARLOCK, oHolder);
        _AddBitString(nBit, "Group: Warrior", sPage, MD_BIT_WARRIOR, oHolder);
        _AddBitString(nBit, "Group: Arcane", sPage, MD_BIT_ARCANE, oHolder);
        _AddBitString(nBit, "Group: Clergy", sPage, MD_BIT_CLERGY, oHolder);
        _AddBitString(nBit, "Group: Divine", sPage, MD_BIT_DIVINE, oHolder);
        _AddBitString(nBit, "Group: Thief", sPage, MD_BIT_THIEF, oHolder);
     }

}
int md_GetClassSelection(int selection, int nIgnoreHarper = TRUE)
{
    int nBit;
    if(!nIgnoreHarper && selection >= 22)
        selection--; //harpers on the list so subtract one here
    if(selection == 21)
        nBit = MD_BIT_PDK;
    else if(selection == 22)
        nBit = MD_BIT_FAVSOUL;
    else if(selection == 23)
        nBit = MD_BIT_WARLOCK;
    else if(selection == 24)
        nBit = MD_BIT_WARRIOR;
    else if(selection == 25)
        nBit = MD_BIT_ARCANE;
    else if(selection == 26)
        nBit = MD_BIT_CLERGY;
    else if(selection == 27)
        nBit = MD_BIT_DIVINE;
    else if(selection == 28)
        nBit = MD_BIT_THIEF;
    else
    {

        if(selection > 10)
        {
            selection += 16;


            if(selection >= CLASS_TYPE_HARPER && nIgnoreHarper)
                selection++;


        }


        nBit = mdConvertClassToBit(selection);
    }

    return nBit;
}
