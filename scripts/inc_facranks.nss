//Created by Morderon on 04/26/2015
//Ugg.. this is to avoid circular include: inc_citizen and inc_factions are heavily intertwined

//Mord edit: Non-member rank, but pays in or out
//SPECIAL NOTE: When adding to the databse, non-members rank should be 1.
//Unranked default rank should be 0/null
const int FB_FA_NON_MEMBER = -1;
const string MD_FA_NON_MEMBER = "Outsider";
//Default member rank
const int FB_FA_MEMBER_RANK = 1;
const string MD_FA_MEMBER_RANK = "Unranked";
// The rank of the owner
const int FB_FA_OWNER_RANK = -2;
const string MD_FA_OWNER_RANK = "Owner";
const string DATABASE_PREFIX = "FAC";

// Gets the rank count for the faction
int md_FaRankCount(string sDatabaseID);
//Returns the rank name
string md_FAGetRankName(string sDatabaseID, string sRankID);
// Returns the rank id belonging to nNth in nFaction
string md_FAGetNthRankID(string sDatabaseID, int nNth);

void _RemoveMemFacCache(object oCacheObject, string sID)
{
    //Remove his powers
    DeleteLocalInt(oCacheObject, "MD_FA_POWER_1_"+sID);
    DeleteLocalInt(oCacheObject, "MD_FA_POWER_ST_1_"+sID);
    DeleteLocalInt(oCacheObject, "MD_FA_POWER_2_"+sID);
    DeleteLocalInt(oCacheObject, "MD_FA_POWER_ST_2_"+sID);
    int nPay = GetLocalInt(oCacheObject, "MD_FA_PAY_"+sID);
    if(nPay > 0) //dues
      SetLocalInt(oCacheObject, "MD_FA_DUE", GetLocalInt(oCacheObject, "MD_FA_DUE") - nPay);
    else if(nPay < 0)
      SetLocalInt(oCacheObject, "MD_FA_SAL", GetLocalInt(oCacheObject, "MD_FA_SAL") - nPay);
    DeleteLocalInt(oCacheObject, "MD_FA_PAY_"+sID);
    DeleteLocalInt(oCacheObject, "MD_FA_MR_"+sID);
}

int md_FaRankCount(string sDatabaseID)
{
  return GetLocalInt(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID), "MD_FA_RANK");
}

string md_FAGetRankName(string sDatabaseID, string sRankID)
{
  int nRankID = StringToInt(sRankID);
  if(nRankID == FB_FA_NON_MEMBER)
    return MD_FA_NON_MEMBER;
  else if(nRankID == FB_FA_MEMBER_RANK)
    return MD_FA_MEMBER_RANK;
  else if(nRankID == FB_FA_OWNER_RANK)
    return MD_FA_OWNER_RANK;

  return GetLocalString(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID),
                                  "MD_FA_RANK_R"+sRankID);
}

string md_FAGetNthRankID(string sDatabaseID, int nNth)
{
  return GetLocalString(miDAGetCacheObject(DATABASE_PREFIX+sDatabaseID),
                                  "MD_FA_RANK_"+IntToString(nNth));
}
