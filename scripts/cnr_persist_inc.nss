/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_persist_inc
//
//  Desc:  These functions are collected together to
//         facilitate interfacing to a persistent database.
//
//  Author: David Bobeck 20Apr03
//
/////////////////////////////////////////////////////////

// #include "your_persistent_db_inc_here"
// Note: no include is required to use Bioware's database.
#include "aps_include"

// CNR defined return codes for CnrSQLFetch()
int CNR_SQL_ERROR = 0;
int CNR_SQL_SUCCESS = 1;

/////////////////////////////////////////////////////////
void CnrSetPersistentInt(object oHost, string sVarName, int nValue)
{
  // Change this function call to whatever function
  // should be called from the above include file
  // for storing Integers in your Database

  // uncomment the following line for NO database support
  //SetLocalInt(oHost, sVarName, nValue);

  // uncomment the following line for Bioware database support
  //SetCampaignInt("cnr_misc", sVarName, nValue, oHost);

  // uncomment the following line for APS database support
  SetPersistentInt(oHost, sVarName, nValue, 0, "cnr_misc");
}

/////////////////////////////////////////////////////////
int CnrGetPersistentInt(object oHost, string sVarName)
{
  // Change this function call to whatever function
  // should be called from the above include file
  // for retrieving Integers from your Database

  // uncomment the following line for NO database support
  //return GetLocalInt(oHost, sVarName);

  // uncomment the following line for Bioware database support
  //return GetCampaignInt("cnr_misc", sVarName, oHost);

  // uncomment the following line for APS database support
  return GetPersistentInt(oHost, sVarName, "cnr_misc");
}

/////////////////////////////////////////////////////////
void CnrSetPersistentFloat(object oHost, string sVarName, float fValue)
{
  // Change this function call to whatever function
  // should be called from the above include file
  // for storing Floats in your Database

  // uncomment the following line for NO database support
  //SetLocalFloat(oHost, sVarName, fValue);

  // uncomment the following line for Bioware database support
  //SetCampaignFloat("cnr_misc", sVarName, fValue, oHost);

  // uncomment the following line for APS database support
  SetPersistentFloat(oHost, sVarName, fValue, 0, "cnr_misc");
}

/////////////////////////////////////////////////////////
float CnrGetPersistentFloat(object oHost, string sVarName)
{
  // Change this function call to whatever function
  // should be called from the above include file
  // for retrieving Floats from your Database

  // uncomment the following line for NO database support
  //return GetLocalFloat(oHost, sVarName);

  // uncomment the following line for Bioware database support
  //return GetCampaignFloat("cnr_misc", sVarName, oHost);

  // uncomment the following line for APS database support
  return GetPersistentFloat(oHost, sVarName, "cnr_misc");
}

/////////////////////////////////////////////////////////
void CnrSetPersistentString(object oHost, string sVarName, string sValue)
{
  // Change this function call to whatever function
  // should be called from the above include file
  // for storing Strings in your Database

  // uncomment the following line for NO database support
  //SetLocalString(oHost, sVarName, sValue);

  // uncomment the following line for Bioware database support
  //SetCampaignString("cnr_misc", sVarName, sValue, oHost);

  // uncomment the following line for APS database support
  SetPersistentString(oHost, sVarName, sValue, 0, "cnr_misc");
}

/////////////////////////////////////////////////////////
string CnrGetPersistentString(object oHost, string sVarName)
{
  // Change this function call to whatever function
  // should be called from the above include file
  // for retrieving Strings from your Database

  // uncomment the following line for NO database support
  //return GetLocalString(oHost, sVarName);

  // uncomment the following line for Bioware database support
  //return GetCampaignString("cnr_misc", sVarName, oHost);

  // uncomment the following line for APS database support
  return GetPersistentString(oHost, sVarName, "cnr_misc");
}

/////////////////////////////////////////////////////////
void CnrSQLExecDirect(string sSQL)
{
  // If you're using APS, uncomment the following line
  SQLExecDirect(sSQL);
}

/////////////////////////////////////////////////////////
int CnrSQLFetch()
{
  // If you're using APS, comment out the following line
  //return CNR_SQL_ERROR;

  // If you're using APS, uncomment the following line
  return SQLFetch();
}

/////////////////////////////////////////////////////////
string CnrSQLGetData(int iCol)
{
  // If you're using APS, comment out the following line
  //return "";

  // If you're using APS, uncomment the following line
  return SQLGetData(iCol);
}
