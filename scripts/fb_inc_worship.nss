/*
fb_inc_worship

Fireboar's extension to gs_inc_worship (Gigaschatten's Worship library). This is
a part of the zz_co_worship conversation and serves simply as an information
dump. Just five functions here with a whole swarm of text - change fbWOAddDeity
to add more in - it should be really easy. You'll notice that I'm doing something
really daring here - using global variables. Is that a bad thing? I don't think
it is in this case but that's for you to decide.

Mith comment - we're not short on RAM for our server so we've no issue with
global variables.
*/

#include "gs_inc_worship"
#include "zzdlg_main_inc"

// Grabs the nNth deity in nCategory
int fbWOGetNthDeity(int nCategory, int nDeity);
// Grabs the portfolio of the nNth deity in nCategory
string fbWOGetNthPortfolio(int nCategory, int nDeity);
// Convenience method to return the friendly name of the aspect
string fbWOGetAspectName(int nDeity);
// Convenience method to return the name of the race
string fbWOGetRacialTypeName(int nDeity);

//----------------------------------------------------------------
int fbWOGetNthDeity(int nCategory, int nNth)
{
    __gsWOInitCacheItem();
    return GetLocalInt(oWOCacheItem, "FB_WO_DEITY_"+IntToString(nCategory)+"_"+IntToString(nNth));
}
//----------------------------------------------------------------
string fbWOGetNthPortfolio(int nCategory, int nNth)
{
    __gsWOInitCacheItem();
    return GetLocalString(oWOCacheItem, "FB_WO_PORTFOLIO_"+IntToString(nCategory)+"_"+IntToString(nNth));
}
//----------------------------------------------------------------
string fbWOGetAspectName(int nDeity)
{
    int nAspect = gsWOGetAspect(nDeity);
    string sAspect = "";

    if (nAspect & ASPECT_WAR_DESTRUCTION) sAspect += "War and Destruction, ";
    if (nAspect & ASPECT_HEARTH_HOME) sAspect += "Hearth and Home, ";
    if (nAspect & ASPECT_KNOWLEDGE_INVENTION) sAspect += "Knowledge and Invention, ";
    if (nAspect & ASPECT_TRICKERY_DECEIT) sAspect += "Trickery and Deceit, ";
    if (nAspect & ASPECT_NATURE) sAspect += "Nature, ";
    if (nAspect & ASPECT_MAGIC) sAspect += "Magic, ";

    sAspect = GetSubString(sAspect, 0, GetStringLength(sAspect) - 2);

    return sAspect;
}
//----------------------------------------------------------------
string fbWOGetRacialTypeName(int nDeity)
{
  int nRacialType = gsWOGetRacialType(nDeity);
  string sRace = "";

  switch (nRacialType)
  {
    case RACIAL_TYPE_ALL:                 sRace = "Any"; break;
    case RACIAL_TYPE_DWARF:               sRace = "Dwarf"; break;
    case RACIAL_TYPE_ELF:                 sRace = "Elf"; break;
    case RACIAL_TYPE_FEY:                 sRace = "Fey"; break;
    case RACIAL_TYPE_HALFLING:            sRace = "Halfling"; break;
    case RACIAL_TYPE_HUMAN:               sRace = "Human"; break;
    case RACIAL_TYPE_HUMANOID_GOBLINOID:  sRace = "Goblin"; break;
    case RACIAL_TYPE_HUMANOID_REPTILIAN:  sRace = "Reptilian"; break;
    case RACIAL_TYPE_HUMANOID_ORC:        sRace = "Orc"; break;
    case RACIAL_TYPE_HUMANOID_MONSTROUS:  sRace = "Monstrous"; break;
    case RACIAL_TYPE_GNOME:               sRace = "Gnome"; break;
  }

  return sRace;
}
