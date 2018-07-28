/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_bird_ondeath
//
//  Desc:  The OnDeath handler for birds that drop
//         feathers. Bird/feather pairs are configured
//         in cnr_source_init.
//
//  Author: David Bobeck 26Mar03
//
/////////////////////////////////////////////////////////
void main()
{
  location locDeath = GetLocation(OBJECT_SELF);
  string sBirdTag = GetTag(OBJECT_SELF);
  string sFeatherTag = GetLocalString(GetModule(), sBirdTag + "_FeatherTag");
  CreateObject(OBJECT_TYPE_ITEM, sFeatherTag, locDeath, FALSE);
}
