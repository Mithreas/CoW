/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_mob_ondeath
//
//  Desc:  The OnDeath handler for mobs that drop
//         items. Mob/Item pairs are configured
//         in cnr_source_init.
//
//  Author: David Bobeck 08Aug03
//
/////////////////////////////////////////////////////////
void main()
{
  location locDeath = GetLocation(OBJECT_SELF);
  string sMobTag = GetTag(OBJECT_SELF);
  string sDropTag = GetLocalString(GetModule(), sMobTag + "_DropTag");
  CreateObject(OBJECT_TYPE_ITEM, sDropTag, locDeath, FALSE);
}
