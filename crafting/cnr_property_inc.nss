/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_property_inc
//
//  Desc:  Misc property initialization functions.
//         Basically creates a lookup table.
//
//  Author: David Bobeck 24Apr03
//
/////////////////////////////////////////////////////////
//#include "cnr_persist_inc"

void CnrSetPropertyString(string sKey, string sProperty, string sValue)
{
  //CnrSetPersistentString(GetModule(), "CnrProperty_" + sKey + "_" + sProperty, sValue);
  SetLocalString(GetModule(), "CnrProperty_" + sKey + "_" + sProperty, sValue);
}

void CnrSetPropertyInt(string sKey, string sProperty, int nValue)
{
  //CnrSetPersistentInt(GetModule(), "CnrProperty_" + sKey + "_" + sProperty, nValue);
  SetLocalInt(GetModule(), "CnrProperty_" + sKey + "_" + sProperty, nValue);
}

string CnrGetPropertyString(string sKey, string sProperty)
{
  //return CnrGetPersistentString(GetModule(), "CnrProperty_" + sKey + "_" + sProperty);
  return GetLocalString(GetModule(), "CnrProperty_" + sKey + "_" + sProperty);
}

int CnrGetPropertyInt(string sKey, string sProperty)
{
  //return CnrGetPersistentInt(GetModule(), "CnrProperty_" + sKey + "_" + sProperty);
  return GetLocalInt(GetModule(), "CnrProperty_" + sKey + "_" + sProperty);
}

string CnrGetHcrCompatibleTag(string sOrigTag)
{
  string sSubstituteHcrTag = CnrGetPropertyString(sOrigTag, "HCHTF_TAG");
  if (sSubstituteHcrTag != "")
  {
    return sSubstituteHcrTag;
  }
  return sOrigTag;
}
