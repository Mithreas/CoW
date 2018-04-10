/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_hchtf_init
//
//  Desc:  HCR HTF property initialization. This script is
//         executed from "cnr_trade11_init".
//
//  Author: David Bobeck 24Apr03
//
/////////////////////////////////////////////////////////
#include "cnr_property_inc"

void main()
{
  // set up custom properties for each of the food items crafted by CNR
  
  // Beers
  CnrSetPropertyString("cnrbAxeHead", "HCHTF_TAG", "Drink_LOW_Alcohol1");
  CnrSetPropertyString("cnrbBigRock", "HCHTF_TAG", "Drink_LOW_Alcohol1");
  CnrSetPropertyString("cnrbBlackHorse", "HCHTF_TAG", "Drink_LOW_Alcohol2");
  CnrSetPropertyString("cnrbBlackKnight", "HCHTF_TAG", "Drink_LOW_Alcohol3");
  CnrSetPropertyString("cnrbBlueSword", "HCHTF_TAG", "Drink_LOW_Alcohol3");
  CnrSetPropertyString("cnrbBrokenKnuckle", "HCHTF_TAG", "Drink_LOW_Alcohol1");
  CnrSetPropertyString("cnrbCherryRiver", "HCHTF_TAG", "Drink_LOW_Alcohol2");
  CnrSetPropertyString("cnrbCrackedSkull", "HCHTF_TAG", "Drink_LOW_Alcohol3");
  CnrSetPropertyString("cnrbDarkDragon", "HCHTF_TAG", "Drink_HIGH_Alcohol5");
  CnrSetPropertyString("cnrbDeadOrc", "HCHTF_TAG", "Drink_LOW_Alcohol2");
  CnrSetPropertyString("cnrbDwarfsSledge", "HCHTF_TAG", "Drink_MED_Alcohol3");
  CnrSetPropertyString("cnrbFireWood", "HCHTF_TAG", "Drink_LOW_Alcohol2");
  CnrSetPropertyString("cnrbGreenForest", "HCHTF_TAG", "Drink_LOW_Alcohol1");
  CnrSetPropertyString("cnrbIronHammer", "HCHTF_TAG", "Drink_MED_Alcohol3");
  CnrSetPropertyString("cnrbJumpinJuniper", "HCHTF_TAG", "Drink_LOW_Alcohol3");
  CnrSetPropertyString("cnrbPigsEar", "HCHTF_TAG", "Drink_LOW_Alcohol3");
  CnrSetPropertyString("cnrbRedCrow", "HCHTF_TAG", "Drink_LOW_Alcohol3");
  CnrSetPropertyString("cnrbSilverBuckle", "HCHTF_TAG", "Drink_LOW_Alcohol3");
  CnrSetPropertyString("cnrbTowerMalt", "HCHTF_TAG", "Drink_LOW_Alcohol3");
  CnrSetPropertyString("cnrbWilloWhiskey", "HCHTF_TAG", "Drink_LOW_Alcohol5");
  CnrSetPropertyString("cnrbWizardsWheat", "HCHTF_TAG", "Drink_HIGH_Alcohol4");
  // Juices
  CnrSetPropertyString("cnrAppleJuice", "HCHTF_TAG", "Drink_LOW_ENERGY1");
  CnrSetPropertyString("cnrBlkberryJuice", "HCHTF_TAG", "Drink_MED_ENERGY2");
  CnrSetPropertyString("cnrBluberryJuice", "HCHTF_TAG", "Drink_MED_HPBONUS1");
  CnrSetPropertyString("cnrCherryJuice", "HCHTF_TAG", "Drink_MED_HPBONUS2");
  CnrSetPropertyString("cnrCrnberryJuice", "HCHTF_TAG", "Drink_MED_HPBONUS4");
  CnrSetPropertyString("cnrEldberryJuice", "HCHTF_TAG", "Drink_MED_HPBONUS3");
  CnrSetPropertyString("cnrGrapeJuice", "HCHTF_TAG", "Drink_MED_ENERGY3");
  CnrSetPropertyString("cnrJuniperJuice", "HCHTF_TAG", "Drink_MED_ENERGY3");
  CnrSetPropertyString("cnrPearJuice", "HCHTF_TAG", "Drink_MED_HPBONUS5");
  CnrSetPropertyString("cnrRspberryJuice", "HCHTF_TAG", "Drink_MED_ENERGY3");
  // Breads
  CnrSetPropertyString("cnrCornBread", "HCHTF_TAG", "Food_POOR");
  CnrSetPropertyString("cnrOatBread", "HCHTF_TAG", "Food_POOR");
  CnrSetPropertyString("cnrRiceBread", "HCHTF_TAG", "Food_POOR");
  CnrSetPropertyString("cnrRyeBread", "HCHTF_TAG", "Food_POOR");
  CnrSetPropertyString("cnrWheatBread", "HCHTF_TAG", "Food_POOR");
  // Pie's
  CnrSetPropertyString("cnrApplePie", "HCHTF_TAG", "Food_RICH");
  CnrSetPropertyString("cnrBlkberryPie", "HCHTF_TAG", "Food_RICH");
  CnrSetPropertyString("cnrBluberryPie", "HCHTF_TAG", "Food_RICH");
  CnrSetPropertyString("cnrCherryPie", "HCHTF_TAG", "Food_RICH");

}

