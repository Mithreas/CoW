/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_source_init
//
//  Desc:  Minable placeables initialization. This script is
//         executed from "cnr_module_oml".
//
//  Author: David Bobeck 08May03
//
/////////////////////////////////////////////////////////
#include "cnr_source_inc"
#include "cnr_config_inc"
void main()
{
  PrintString("cnr_source_init");

  // Module builders: You should put your mining initialization
  // into a file named "user_source_init" so that future
  // versions of CNR do not over-write any resources you define.
  ExecuteScript("user_source_init", OBJECT_SELF);

  // This section (new to V3.00) allows for easy setup of trees that
  // drop branches when bashed with a woodcutter's axe.
  CnrBashableTreeInitialize("cnrtree2", "cnrbranch2");
  CnrBashableTreeInitialize("cnrtree3", "cnrbranch3");
  CnrBashableTreeInitialize("cnrtree1", "cnrbranch1");

  // This section (new to V3.00) allows for easy setup of misc deposits that
  // can be dug with a shovel to provide an item.
  CnrShoveledDepositInitialize("cnrdepositclay", "cnrlumpofclay");
  CnrShoveledDepositInitialize("cnrdepositsand", "cnrbagofsand");
  CnrShoveledDepositInitialize("cnrdepositsulphu", "sulphur");

  // This section (new to V3.00) allows for easy setup of mineral deposits that
  // can be excavated with a chisel to provide an item.
  CnrChiseledDepositInitialize("cnrGemDeposit001", "cnrGemMineral001");

  // This section (new to V3.00) allows for easy setup of ore deposits that
  // can be bashed with a pickaxe to provide an item.
  CnrMinableRockInitialize("cnrrockond", "cnrnuggetond");
  CnrMinableRockInitialize("cnrrockelf", "cnrnuggetelf");
  CnrMinableRockInitialize("cnrrocklir", "cnrnuggetlir");
  CnrMinableRockInitialize("cnrrockdem", "cnrnuggetdem");
  CnrMinableRockInitialize("cnrrockiol", "cnrnuggetiol");
  CnrMinableRockInitialize("cnrrockada", "cnrnuggetada");
  CnrMinableRockInitialize("cnrrocksta", "cnrnuggetsta");
  CnrMinableRockInitialize("cnrdepositcoal", "cnrLumpOfCoal");

  // This section (new to V3.00) allows for easy setup of feather drops
  // upon the death of the identified bird.
  CnrBirdOnDeathInitialize("cnraFalcon", "cnrfeather");
  CnrBirdOnDeathInitialize("cnraRaven", "cnrfeather");
  CnrBirdOnDeathInitialize("cnraOwl", "cnrfeather");

  // This section (new to V3.05, similar to CnrBirdOnDeathInitialize) allows
  // for easy setup of item drops upon the death of the identified mob.
  CnrMobOnDeathInitialize("cnrBeetleStink", "cnrstinkgland");
  CnrMobOnDeathInitialize("cnrBeetleBomber", "cnrbellbomb");
}

