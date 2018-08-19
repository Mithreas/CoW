/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_plant_init
//
//  Desc:  Plant initialization. This script is
//         executed from "cnr_module_oml".
//
//  Author: David Bobeck 12Dec02
//
/////////////////////////////////////////////////////////
#include "cnr_plant_utils"
#include "cnr_config_inc"
void main()
{
  PrintString("cnr_plant_init");

  // Module builders: You should put your plant initialization
  // into a file named "user_plant_init" so that future
  // versions of CNR do not over-write any resources you define.
  ExecuteScript("user_plant_init", OBJECT_SELF);

  /////////////////////////////////////////////////////////
  // Default CNR plant initialization
  /////////////////////////////////////////////////////////

  CnrPlantInitialize("cnrhazelnutplant", "cnrhazelnutfruit", 3, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS, CNR_INT_ALWAYS_RESPAWN_FRUIT);
  CnrPlantInitialize("cnrwalnutplant", "cnrwalnutfruit", 3, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS, CNR_INT_ALWAYS_RESPAWN_FRUIT);
  CnrPlantInitialize("cnrpecanplant", "cnrpecanfruit", 3, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS, CNR_INT_ALWAYS_RESPAWN_FRUIT);
  CnrPlantInitialize("cnrchestnutplant", "cnrchestnutfruit", 3, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS, CNR_INT_ALWAYS_RESPAWN_FRUIT);
  CnrPlantInitialize("cnralmondplant", "cnrAlmondFruit", 3, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS, CNR_INT_ALWAYS_RESPAWN_FRUIT);

  CnrPlantInitialize("cnraloeplant", "cnraloeleaf", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrangelicaplant", "cnrangelicaleaf", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrcalendulaplant", "cnrcalendulaflower", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrcatnipplant", "cnrcatnipleaf", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrchamomileplant", "cnrchamomileflower", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrcomfreyplant", "cnrcomfreyroot", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrechinaceaplant", "cnrechinacearoot", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrgarlicplant", "cnrgarlicclove", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrgingerplant", "cnrgingerroot", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrginsengplant", "cnrginsengroot", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrhawthornplant", "cnrhawthornflower", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS, CNR_INT_ALWAYS_RESPAWN_FRUIT);
  CnrPlantInitialize("cnrthistleplant", "cnrthistleleaf", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrnettleplant", "cnrnettleleaf", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrpepmintplant", "cnrpepmintleaf", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrcloverplant", "cnrcloverleaf", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrsageplant", "cnrsageleaf", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrskullcapplant", "cnrskullcapleaf", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrhazelplant", "cnrhazelleaf", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrcottonplant", "cnrcotton", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrbirchplant", "cnrbirchbark", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS, CNR_INT_ALWAYS_RESPAWN_FRUIT);
  CnrPlantInitialize("cnrspidercocoon", "cnrspidersilk", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
  CnrPlantInitialize("cnrmossyellow", "cnrmossyellow", 2, CNR_FLOAT_DEFAULT_PLANT_RESPAWN_TIME_SECS);
}


