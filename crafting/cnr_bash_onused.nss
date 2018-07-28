/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_bash_onused
//
//  Desc:  When a player uses a placeable, begin bashing it.
//
//  Author: David Bobeck 03Feb03
//
/////////////////////////////////////////////////////////
void main()
{
  object oUser = GetLastUsedBy();
  object oTarget = OBJECT_SELF;
  AssignCommand(oUser, DoPlaceableObjectAction(oTarget, PLACEABLE_ACTION_BASH));
}
