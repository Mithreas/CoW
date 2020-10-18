/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnrAlchemyTable
//
//  Desc:  Recipe initialization.
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

// Split into several methods to avoid TMI.
void processOils(string sMenuAlchemyOils);
void processEssences(string sMenuAlchemyEss);
void processPotions(string sMenuAlchemyPotions);

void main()
{
  PrintString("cnralchemytable init");

  /////////////////////////////////////////////////////////
  // CNR recipes made by cnrAlchemyTable
  /////////////////////////////////////////////////////////
  string sMenuAlchemyOils    = CnrRecipeAddSubMenu("cnralchemytable", "Oils and Inks");
  string sMenuAlchemyEss     = CnrRecipeAddSubMenu("cnralchemytable", "Essences");
  string sMenuAlchemyPotions = CnrRecipeAddSubMenu("cnralchemytable", "Potions");

  CnrRecipeSetDevicePreCraftingScript("cnralchemytable", "cnr_alchemy_anim");
  //CnrRecipeSetDeviceInventoryTool("cnrAlchemyTable", "");
  CnrRecipeSetDeviceTradeskillType("cnralchemytable", CNR_TRADESKILL_IMBUING);
  CnrRecipeSetRecipeAbilityPercentages(IntToString(CNR_TRADESKILL_IMBUING), 0, 0, 0, 0, 50, 50); // WIS and CHA
  
  CnrIncrementStackCount(OBJECT_SELF);
  AssignCommand(OBJECT_SELF, processOils(sMenuAlchemyOils));

  CnrIncrementStackCount(OBJECT_SELF);
  AssignCommand(OBJECT_SELF, processEssences(sMenuAlchemyEss));

  CnrIncrementStackCount(OBJECT_SELF);
  AssignCommand(OBJECT_SELF, processPotions(sMenuAlchemyPotions));
  
}  
  
void processOils(string sMenuAlchemyOils)
{  
  string sKeyToRecipe;
  
  //---------------------------------------------------------------------------------
  //---------------------------------------------------------------------------------

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Tanning Acid", "cnrAcidTanning", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC08", 1); // Fire Beetle Belly
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Apprentice Scribing Ink", "cnrInkL", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbellbomb", 1); // Bombardier Beetle's Belly
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 1);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 10, 10);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Tanning Oil", "cnrOilTanning", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC08", 1); // Fire Beetle Belly
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Lesser Acid Oil", "cnroillsacid", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "X1_WMGRENADE001", 1); // Acid Flask
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemgree", 5); // 5 gems
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Lesser Cold Oil", "cnroillscold", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "X1_IT_MSMLMISC01", 1); // Coldstone
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemfluo", 5); // 5 gems
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Lesser Electrical Oil", "cnroillselec", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC11", 1); // Qwartz Crystal
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemamet", 5); // 5 gems
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Lesser Fire Oil", "cnroillsfire", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC08", 1); // Fire Beetle Belly
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemfiag", 5); // 5 gems
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Lesser Negative Oil", "cnroillsnega", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC13", 1); // Skeleton Knuckle
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemgarn", 5); // 5 gems
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Lesser Positive Oil", "cnroillsposi", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "X1_WMGRENADE005", 1); // Holy Water
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemphen", 5); // 5 gems
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Lesser Sonic Oil", "cnroillssoni", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "X1_WMGRENADE007", 1); // Thunderstone
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemaven", 5); // 5 gems
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 3);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 30, 30);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Journeyman Scribing Ink", "cnrInkM", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 1); // Silver ingot
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbellbomb", 1); // Bombardier Beetle's Belly
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 5);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 50, 50);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Master Scribing Ink", "cnrInkG", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotgol", 1); // Gold ingot
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbellbomb", 1); // Bombardier Beetle's Belly
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Greater Acid Oil", "cnroilgracid", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "X1_WMGRENADE001", 5); // Acid Flask
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gememer", 1); // 1 gem
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Greater Cold Oil", "cnroilgrcold", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "X1_IT_MSMLMISC01", 5); // Coldstone
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemsapp", 3); // 3 gems
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Greater Electrical Oil", "cnroilgrelec", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC11", 5); // Qwartz Crystal
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemalex", 8); // 8 gems
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Greater Fire Oil", "cnroilgrfire", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC08", 5); // Fire Beetle Belly
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemfiop", 3); // 3 gems
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Greater Negative Oil", "cnroilgrnega", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "NW_IT_MSMLMISC13", 5); // Skeleton Knuckle
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemruby", 2); // 5 gems
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Greater Positive Oil", "cnroilgrposi", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "X1_WMGRENADE005", 5); // Holy Water
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemdiam", 2); // 5 gems
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyOils, "Greater Sonic Oil", "cnroilgrsoni", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "X1_WMGRENADE007", 5); // Thunderstone
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemtopa", 5); // 5 gems
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 11);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 110, 110);
  
  CnrDecrementStackCount(OBJECT_SELF);
}

void processEssences(string sMenuAlchemyEss)
{
  string sKeyToRecipe;
  string sMenuTempWpnEss     = CnrRecipeAddSubMenu(sMenuAlchemyEss, "Temporary Weapon Essences");
  string sMenuPermWpnEss     = CnrRecipeAddSubMenu(sMenuAlchemyEss, "Permanent Weapon Essences");
  
  //---------------------------------------------------------------------------------
  //---------------------------------------------------------------------------------
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTempWpnEss, "Essence (+1, Acid, Temporary)", "essacidtemp1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroillsacid", 2); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTempWpnEss, "Essence (+1, Cold, Temporary)", "esscoldtemp1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroillscold", 2); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTempWpnEss, "Essence (+1, Electrical, Temporary)", "esselectemp1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroillselec", 2); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTempWpnEss, "Essence (+1, Fire, Temporary)", "essfiretemp1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroillsfire", 2); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTempWpnEss, "Essence (+1, Negative, Temporary)", "essnegatemp1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroillsnega", 2); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTempWpnEss, "Essence (+1, Positive, Temporary)", "esspositemp1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroillsposi", 2); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTempWpnEss, "Essence (+1, Sonic, Temporary)", "esssonitemp1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroillssoni", 2); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTempWpnEss, "Essence (+d4, Acid, Temporary)", "essacidtemp4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroillsacid", 5); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTempWpnEss, "Essence (+d4, Cold, Temporary)", "esscoldtemp4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroillscold", 5); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTempWpnEss, "Essence (+d4, Electrical, Temporary)", "esselectemp4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroillselec", 5); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTempWpnEss, "Essence (+d4, Fire, Temporary)", "essfiretemp4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroillsfire", 5); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTempWpnEss, "Essence (+d4, Negative, Temporary)", "essnegatemp4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroillsnega", 5); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTempWpnEss, "Essence (+d4, Positive, Temporary)", "esspositemp4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroillsposi", 5); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuTempWpnEss, "Essence (+d4, Sonic, Temporary)", "esssonitemp4", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroillssoni", 5); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);
  
  //---------------------------------------------------------------------------------
  //---------------------------------------------------------------------------------
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPermWpnEss, "Essence (+1, Acid, Permanent)", "essacidperm1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroilgracid", 1); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPermWpnEss, "Essence (+1, Cold, Permanent)", "esscoldperm1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroilgrcold", 1); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPermWpnEss, "Essence (+1, Electrical, Permanent)", "esselecperm1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroilgrelec", 1); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPermWpnEss, "Essence (+1, Fire, Permanent)", "essfireperm1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroilgrfire", 1); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPermWpnEss, "Essence (+1, Negative, Permanent)", "essnegaperm1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroilgrnega", 1); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPermWpnEss, "Essence (+1, Positive, Permanent)", "essposiperm1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroilgrposi", 1); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPermWpnEss, "Essence (+1, Sonic, Permanent)", "esssoniperm1", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroilgrsoni", 1); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPermWpnEss, "Essence (+d6, Acid, Permanent)", "essacidperm6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroilgracid", 5); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPermWpnEss, "Essence (+d6, Cold, Permanent)", "esscoldperm6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroilgrcold", 5); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPermWpnEss, "Essence (+d6, Electrical, Permanent)", "esselecperm6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroilgrelec", 5); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPermWpnEss, "Essence (+d6, Fire, Permanent)", "essfireperm6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroilgrfire", 5); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPermWpnEss, "Essence (+d6, Negative, Permanent)", "essnegaperm6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroilgrnega", 5); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPermWpnEss, "Essence (+d6, Positive, Permanent)", "essposiperm6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroilgrposi", 5); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuPermWpnEss, "Essence (+d6, Sonic, Permanent)", "esssoniperm6", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnroilgrsoni", 5); 
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);
  
  CnrDecrementStackCount(OBJECT_SELF);
}  
  //---------------------------------------------------------------------------------
  //---------------------------------------------------------------------------------
void processPotions(string sMenuAlchemyPotions)
{
  string sKeyToRecipe;
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Bless", "NW_IT_MPOTION009", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrangelicaleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrwalnutfruit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);


  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Cure Light Wounds", "NW_IT_MPOTION001", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgarlicclove", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Lore", "cnrpotlore", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloverleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrsageleaf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 2);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 20, 20);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Barkskin", "NW_IT_MPOTION005", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpepmintleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrbirchbark", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Lesser Restoration", "NW_IT_MPOTION011", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrangelicaleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnralmondfruit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Cure Disease", "it_mpotion007", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrginsengroot", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgingerroot", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 4);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 40, 40);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Cure Moderate Wounds", "NW_IT_MPOTION020", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcomfreyroot", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Bull's Strength", "NW_IT_MPOTION015", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpepmintleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhawthornfwr", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Cat's Grace", "NW_IT_MPOTION014", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpepmintleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcatnipleaf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Fox's Cunning", "NW_IT_MPOTION017", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpepmintleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhazelleaf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Eagle's Splendor", "NW_IT_MPOTION010", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpepmintleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcalendulafwr", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Owl's Wisdom", "NW_IT_MPOTION018", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpepmintleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrhazelnutfruit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Endurance", "NW_IT_MPOTION013", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpepmintleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchestnutfruit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 6);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 60, 60);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Aid", "NW_IT_MPOTION016", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrangelicaleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrpecanfruit", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Clarity", "NW_IT_MPOTION007", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloverleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrnettleleaf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 8);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 80, 80);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Invisibility", "NW_IT_MPOTION008", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloverleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskullcapleaf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Speed", "NW_IT_MPOTION004", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrcloverleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrthistleleaf", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 10);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 100, 100);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Cure Serious Wounds", "NW_IT_MPOTION002", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrechinacearoot", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Antidote", "NW_IT_MPOTION006", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrangelicaleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrchamomilefwr", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 12);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 120, 120);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Negative Energy Protection", "pot_negenprot", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrskullcapleaf", 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrechinacearoot", 1);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 13);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 130, 130);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Cure Critical Wounds", "NW_IT_MPOTION003", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 3);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrgingerroot", 3);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 14);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 140, 140);

  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Heal", "NW_IT_MPOTION012", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnraloeleaf", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnrginsengroot", 5);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 16);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 160, 160);
  
  sKeyToRecipe = CnrRecipeCreateRecipe(sMenuAlchemyPotions, "Potion of Attunement", "mi_potion_attune", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cnremptyflask", 1, 1);
  CnrRecipeAddComponent(sKeyToRecipe, "cnringotsil", 5);
  CnrRecipeAddComponent(sKeyToRecipe, "cow_gemsapp", 5);
  CnrRecipeSetRecipeLevel(sKeyToRecipe, 18);
  CnrRecipeSetRecipeXP(sKeyToRecipe, 180, 180);
  
  CnrDecrementStackCount(OBJECT_SELF);
}



