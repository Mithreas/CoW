/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_module_oui
//
//  Desc:  This script must be run by the module's
//         OnUnaquireItem event handler.
//
//  Author: David Bobeck 22Feb03
//
/////////////////////////////////////////////////////////
void main()
{
  object oLoser = GetModuleItemLostBy();
  ExecuteScript("cnr_cowchic_oui", oLoser);
}
