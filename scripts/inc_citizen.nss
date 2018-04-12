/*
  inc_citizen
  Citizenship library

  BECOMING A CITIZEN

  Speak to registrar NPC.  Pay 10k, you're now a citizen of the town.
  Taking citizenship at a town removes any citzenship of other towns.
  Citizenship will expire if you do not log in for 5 game years (6 RL months).
  Note - citizenship changed to be permanent 13 Apr 15.  But citizen counts
  ignore inactives.

  ELECTING A LEADER

  All citizens will be able to vote for their leaders.  Leadership posts for
  each community are decided by the admin team.  There may be a single monarch
  or mayor position, or a council of equals.

  Any citizen may challenge for the top job if the last election was held more
  than one game year ago.  To do this, they speak to the registrar, and that
  triggers an election.  During the next game month, any citizen can speak to
  the registrar to vote (or to change their existing vote).  At the end of the
  election, the person or people (if there are multiple posts) with the highest
  vote counts gain the office.

  While an election is active, all citizens will be reminded of the fact when
  they log in (and when an election is called, it will be declared server wide).

  The counts will be secret until the election is completed.

  BEING A LEADER

  A leader can do lots of stuff, as follows.

   APPOINTING OFFICERS

  A leader may create officer positions by speaking to the Registrar. To do so
  (s)he must give the name of the position, its salary, and the name of the
  first holder (who must be logged on).

  The leader may, at any point, change the holder of a rank or remove a rank.

  Salary is paid monthly direct from the bank account of the town to the bank
  account of the holder.

  Anyone holding such a position may create other positions underneath their own
  position. They may hire and fire the holders of those positions, and set
  their salary.  However, any salary then comes out of the bank account of the
  holder of the rank.

  For example, the mayor of Bendir appoints a guard captain and gives them a
  salary of 1000g a month.  The captain creates five guardsman postions and a
  sergeant position, and gives the guardsmen 100g salaries and the sergeant a
  200g salary.  Each month, the captain gets 1000g from the Bendir account, and
  700 of that is immediately transferred to his subordinates.  If the captain
  created another five guardsman positions with 100g salaries, he would then
  make a loss each month.

  Anyone may resign an office they hold by speaking to the Registrar.  If one or
  more leadership positions are vacant at any time, anyone may call an election
  (even if it's not been a year since the last one).

  Leaders will not be paid by default.  They are encouraged to set up offices
  that they can hold in order to salary themselves.

   TAXES AND MONEY

  Taxes have a base rating of 10% - this means 10% of every shop or quarter sale
  goes to the government, and 1% of a quarter or shop's full value is paid to
  the government each month (including cost of improvements if any).  The
  leader(s) of the community may alter this base tax rate by talking to the
  Registrar.

  Any community leader can withdraw or deposit funds from/to the community bank
  account.

  If the settlement bank balance reaches zero or less, then:
  - Taxes will automatically be doubled until the balance becomes positive
  - Salaries will stop being paid until the balance becomes positive
  - Trade (see below) will continue.

   INTERNATIONAL RELATIONS

  The community leader(s) can choose to enter hostile relations with another
  community. All citizens of rival communities will be unable to enter the town
  unless they are in disguise and pass a disguise (bluff) check.  They will
  continue to make checks until they leave, and will be thrown out if they fail
  one.

  Similarly, community leader(s) can open trade agreements with other nations.
  Opening a trade agreement means that the other nation will be able to buy
  resources from you (and, if they reciprocate the agreement, your nation will
  be able to buy from them).  See below for more on trade.

  Finally, community leaders can make their settlement a vassal of another
  settlement, or release a vassal they already have.  Community leaders have
  control over vassal states: they can perform any of the community leader
  actions on the vassal state by speaking to its Registrar and Trade Czar NPCs.

   PUNISHMENT

  Community leaders can banish individuals.  They will be treated exactly the
  same as citizens from rival states, as above.

  Community leaders can also strip citizenship from any citizen of the
  community, and may evict the resident of any quarter or shop in the town.

   TRADE

  (NB - this section under construction).

  Every settlement needs an amount of certain basic resources, determined by the
  number of registered citizens it has.  These basic resources are food, cloth,
  metal, wood and stone.  Settlements may obtain these items by two means: PCs
  depositing them, or trade with other settlements (or the outside world).

  All trade is managed by the community leader(s). (Dev note - may want to add
  the ability to delegate?)

    TRADE MANAGEMENT

  Community leaders can set their buy/sell rates for each resource.  Each game
  year, the stockpile of resources held by each settlement will be reduced by
  the amount needed for all their citizens.  If the amount currently stored
  falls short of the amount needed, the settlement will automatically attempt to
  buy from the surplus generated by other settlements, or (if available) from
  external sources (option only available to Cordor and Wharftown, which have
  ports, or any other government that's bribed a pirate in the Crow's Nest to
  ship in resources).  The cost to import resources from elsewhere will be very
  high, especially if using pirates.  Settlements can only buy from settlements
  that have a trade agreement in place with them.

  At any time, community leaders can build up the stockpile of resources by
  speaking to the Trade Czar and trying to buy resources from a settlement that
  has a trade agreement with them, or from external sources.  This might allow,
  for instance, Cordor importing a large amount of metal from the mainland and
  then selling it to Brogendenstein for a profit.

    PC DEPOSIT

  The Dev Team will maintain an inventory of items that 'count as' one of the
  five basic resource types.  For example, nuts, berries and fruit would all
  count as food.  The Underdark might have mushrooms that count as wood, and
  both hardwood and softwood will count as wood too.

  PCs speaking to the Trade Czar in the settlement will be able to gift or sell
  resources to the settlement.  If they choose to sell, the buy price is derived
  from the price the community leader(s) have set for buying goods.

    RUNNING OUT

  If a settlement is unable to source the resources it needs, e.g. because they
  haven't bribed the pirates and nobody else is trading it, then it will suffer
  a reduction on all tax income each year until the situation is remedied, to
  represent the decay of the community as an essential resource isn't available.

  This could become crippling quite quickly if it's not remedied...

  As an added whammy, running out of gold (at any time) causes your settlement
  to go bankrupt.  All exiles are cancelled and leaders are ejected from office.

  INDUSTRY

  TBD - allow players to fund farms, quarries, timber mills etc that will
  produce a value of resource and add them to their nation's stockpiles.  The
  industry should have a maintenance cost (coming out of the PC's bank account)
  but this should be << the value of the resources it produces.

  ===========================================================================

  DATABASE TABLES

  create table micz_nations (
    id INT(11),
    name VARCHAR(64),       [Nation name]
    `master` INT(11),       [id of the nation this nation is controlled by, FK:micz_nations.id]
    bank INT(11),           [current bank balance]
    food INT(8),            [value of food stockpile in GP]
    wood INT(8),            [value of wood stockpile in GP]
    cloth INT(8),           [value of cloth stockpile in GP]
    metal INT(8),           [value of metal stockpile in GP]
    stone INT(8),           [value of stone stockpile in GP]
    decay SMALLINT(2),      [decay count - % tax income lost on maintenance]
    election_start INT(11), [game timestamp of election start]
    foodsellprice FLOAT,    [% sale price expressed as a decimal (e.g. 0.5=50%)]
    woodsellprice FLOAT,    [% sale price expressed as a decimal (e.g. 0.5=50%)]
    clothsellprice FLOAT,   [% sale price expressed as a decimal (e.g. 0.5=50%)]
    metalsellprice FLOAT,   [% sale price expressed as a decimal (e.g. 0.5=50%)]
    stonesellprice FLOAT,   [% sale price expressed as a decimal (e.g. 0.5=50%)]
    foodbuyprice FLOAT,     [% buy price expressed as a decimal (e.g. 0.5=50%)]
    woodbuyprice FLOAT,     [% buy price expressed as a decimal (e.g. 0.5=50%)]
    clothbuyprice FLOAT,    [% buy price expressed as a decimal (e.g. 0.5=50%)]
    metalbuyprice FLOAT,    [% buy price expressed as a decimal (e.g. 0.5=50%)]
    stonebuyprice FLOAT,    [% buy price expressed as a decimal (e.g. 0.5=50%)]
    contract TINYINT(1),    [whether nation has a supply contract with shippers]
    tax FLOAT,              [% tax rate expressed as a decimal (e.g. 0.1=10%)]
    PRIMARY KEY (id)
    );

  create table micz_positions (
    rank_id INT(11),            [PK]
    row_key VARCHAR(64),        [position name]
    nation INT(11),             [nation id, FK:micz_nations.id]
    salary INT(8),              [amount the position gets paid]
    `master_rank` INT(11),      [id of the rank which employs this position, FK:micz_positions.rank_id]
    `master_holder` TINYINT(3), [id of the rank holder which employs this position, FK:micz_rank.holder_id]
    holders TINYINT(2),         [number of slots open]
    PRIMARY KEY (rank_id)
    );

  create table micz_votes (
    nation INT(11),    [PK/FK:micz_nations.id]
    candidate INT(11), [PK/FK:gs_pc_data.id]
    votes TEXT,        [the votes: 6 digits, followed by ;;, followed by the IDs of each voter]
    PRIMARY KEY (nation,candidate)
  );

  create table micz_war (
    nation_agg INT(11), [the nation who initiated the war, PK/FK:micz_nations.id]
    nation_def INT(11), [the nation whom war was declared against, PK/FK:micz_nations.id]
    PRIMARY KEY (nation_agg,nation_def)
    );

  create table micz_trade (
    nation_sell INT(11), [PK/FK:micz_nations.id]
    nation_buy INT(11),  [PK/FK:micz_nations.id]
    PRIMARY KEY (nation_sell,nation_buy)
    );

  create table micz_banish (
    nation INT(11), [PK/FK:micz_nations.id]
    pc_id INT(11),  [PK/FK:gs_pc_data.id]
    PRIMARY KEY (nation,pc_id)
    );

  create table micz_rank (
    rank_id INT(11),      [PK/FK:micz_positions.rank_id]
    holder_id TINYINT(3), [PK]
    pc_id INT(11),        [id of the pc with the rank, FK:gs_pc_data.id]
    granted INT(11),      [game timestamp of when pc gained the rank or was re-elected]
    PRIMARY KEY (rank_id,holder_id)
    );

  ============================================================================

  MODULE CHANGES NEEDED

  Nation placeables needed that have mi_initnation as heartbeat script and the
  following variables set up.
  - MI_NATION (string) name of the settlement (e.g, Cordor, Bendir)
  - MI_NATION_LEADER (string) name of the leadership position (e.g. Councilor)
  - MI_NATION_NUM_LEADERS (int) number of leaders - usually 1 but may be more

  Registrar NPCs needed for each settlement that have zdlg_converse set up as
  their conversation and the following variables set:
  - dialog (string) zdlg_registrar
  - MI_NATION (string) name of the settlement they serve (e.g. Cordor, Bendir)

  Trade NPCs needed for each settlement that have zdlg_converse set up as their
  conversation and the following variables set:
  - dialog (string) zdlg_tradeczar
  - MI_NATION (string) name of the settlement they serve (e.g. Cordor, Bendir)

  The trade NPC needs an accompanying container (e.g. chest) with the tag
   MI_CZ_CHEST_(nation) - where (nation) is the name of the settlement they
   server IN UPPER CASE.

  Dockmaster NPCs needed for each settlement that has a port. Need following
  variables set and zdlg_converse set as their conversations.
  - dialog (string) zdlg_dockmaster
  - MI_NATION (string) name of the settlement (e.g. Cordor, Wharftown)

  Pirate captain NPC needed in the Crow's Nest. Needs following variable set and
  zdlg_converse set as conversation.
  - dialog (string) zdlg_dockmaster

  Areas that make up part of a settlement need to have the following variable
  set.  This may be done only to exterior areas, though key public buildings
  should be included too.
  - MI_NATION (string) name of the settlement (e.g. Cordor, Bendir)

  Each nation needs an 'exit' waypoint to send banished folks to.  This should
  be in an area that's NOT part of the nation, and have a tag GS_TARGET_ + the
  name of the nation IN UPPER CASE.

  Resource chests are needed in the inventory area with the following tags
  - MI_RESOURCE_FOOD
  - MI_RESOURCE_WOOD
  - MI_RESOURCE_CLOTH
  - MI_RESOURCE_METAL
  - MI_RESOURCE_STONE
  Each should be a persistent chest and hold examples of that type of resource.

  Resource items (that go in chests) need their values adjusted to ensure that
  they count appropriately. The amount of resource needed each year is
  configurable but is currently set to 1000g worth per citizen.  So if
  softwood has a value of 25g in the toolset, that means you need 40 softwoods
  per citizen per year.  If everything has value 1, though, that means 1000
  items... per citizen...

  Quarters that are part of the nation need the following variable set on their
  sign (note: this should not include interior areas of guildhouses).
  - MI_NATION (string) name of the settlement (e.g. Cordor, Bendir)

  Shops that are part of the nation need the following variable set on BOTH
  their sign AND the shop itself:
  - MI_NATION (string) name of the settlement (e.g. Cordor, Bendir)

  Nations
   Cordor
   Bendir
   Wharftown
   Myon
   Brogendenstein
   LightKeep (now Benwick)
   Guldorand
   Urblexis
   Udos
   Jhareds

  ============================================================================

  CONVERSATIONS NEEDED

  zdlg_dockmaster
  - only talks to settlement leaders
  - won't talk if have a supply contract
  - may be pirate (no nation) or loyal
  - if pay SUPPLY_CONTRACT_COST, set contract to 1 (for normal) or 2 (pirate)

  zdlg_tradeczar
  - if settlement leader, lets you set purchase prices
  - if settlement leader, lets you set sale prices
  - lets anyone donate items or sell items
  - inventory.

  zdlg_registrar
  - lets non-leaders sign up for citizenship
  - lets anyone call an election if appropriate
  - lets leaders...
   - access war menu (declare war, end war)
   - access trade menu (open trade route, close trade route)
   - remove citizen or banish player (speak name to get list of matches)
   - bank account (deposit/withdraw)
   - tax management (change tax rate)
   - manage positions
   - vassal menu (view/become/release)

*/
#include "inc_finance"
#include "inc_time"
#include "inc_log"
#include "inc_facranks"
#include "inc_xfer"
#include "zzdlg_lists_inc"


//------------------------------------------------------------------------------
// Config settings for trade.
//------------------------------------------------------------------------------
//const int NEED_PER_CITIZEN = 1000;     // Value in GP of needed food, metal etc per citizen
const int NEED_PER_EXILE = 5000;
const float SHIPPING_SURCHARGE = 1.33; // % surcharge for shipping
const float PIRATE_SURCHARGE  = 1.66;  // % surcharge for using pirates
const int SUPPLY_CONTRACT_COST = 5000; // one-off cost of arranging an annual shipping contract
const int MI_CZ_JOIN_PRICE = 10000;    // Amount payable to the registrar to become a citizen

//------------------------------------------------------------------------------
// Services
//------------------------------------------------------------------------------
const int MD_SV_EXPWH = 0x01;
const int SVC_UPKEEP_LOW = 0; //any value will do. as long as it's different
const int SVC_UPKEEP_MED = 0x02;
const int SVC_UPKEEP_HIGH = 0x04;
//------------------------------------------------------------------------------
// Static variables
//------------------------------------------------------------------------------
const string CITIZENSHIP = "CITIZENSHIP"; // for logging

const string RESOURCE_FOOD  = "FOOD";
const string RESOURCE_WOOD  = "WOOD";
const string RESOURCE_CLOTH = "CLOTH";
const string RESOURCE_METAL = "METAL";
const string RESOURCE_STONE = "STONE";

const string VAR_NATION       = "MI_NATION";
const string VAR_RESOURCE_INV = "MI_RESOURCE_";
const string VAR_NAME = "MI_NAME";
const string VAR_WAR  = "MI_WAR";
const string VAR_TRADE = "MI_TRADE";
const string VAR_MASTER = "MI_MASTER";
const string VAR_BANISHED = "MI_BANISHED";
const string VAR_DECAY = "MI_DECAY";
const string VAR_ELECTION_START = "MI_ELECTION_START";
const string VAR_LEADER = "MI_LEADERSHIP_POSITION";
const string VAR_NUM_LEADERS = "MI_NUM_LEADERS";
const string VAR_CURRENT_LEADER = "MI_CURRENT_LEADER";
const string VAR_CURRENT_LEADER_TIME = "MI_CURRENT_LEADER_TIME";
const string VAR_CONTRACT = "MI_CONTRACT";
const string VAR_TAX = "MI_TAX";
const string VAR_BUYPRICE = "MI_BUYPRICE_";
const string VAR_SELLPRICE = "MI_SELLPRICE_";
const string VAR_RESOURCE_TYPE = "MI_SRESOURCE_TYPE";
const string VAR_VOTE_COOLDOWN = "VAR_VOTE_COOLDOWN";

const string ELECTION_IN_PROGRESS = "A leadership challenge is currently in progress for your settlement. To vote, speak to your settlement's registrar.";
const string ELECTION_COMPLETE = "A leadership challenge has just completed for your settlement.  Your settlement is now led by: ";

// Loads the information about the nation with id sNation and returns the
// database cache object.
object miCZLoadNation(string sNation);
// Returns the name of the nation with ID sNation.
string miCZGetName(string sNation);
// Finds the nation that best matches string sNation. Will return an empty
// string if nothing found, otherwise a single nation is returned.
string miCZGetBestNationMatch(string sName);
// Populates a nation in the database, if one with this name doesn't exist
// already.
void miCZCreateNation(string sName, string sLeadershipPosition, int nNumLeaders);
// Called monthly to process salaries.
void miCZDoSalaries();
// Is it time for an election?  Returns true if there are any vacant leadership
// positions or if it's been at least a game year since the last election.
int miCZTimeForElection(string sNation);
// Is there currently an election in progress for sNation?  Defaults to oPC's
// nation.  If no valid nation, returns FALSE.
int miCZIsElectionInProgress(object oPC, string sNation = "");
// Is there currently an election in progress for sNation?
int _miCZIsElectionInProgress(string sNation);
// Starts an election for sNation.
void miCZStartElection(string sNation, string sCandidate, string sFaction = "");
// Called by _miCZIsElectionInProgress if it determines that an election is
// complete.
void _miCZCompleteElection(string sNation);
// Utility method to send a message to all citizens of sNation who are
// currently logged in.
void miCZNotifyAllCitizens(string sNation, string sMessage);
// Adds sCandidate (which should be the ID of a PC) as a candidate in sNation's
// current election.  If no election is in progress, this does nothing.
void miCZAddCandidate(string sNation, string sCandidate, string sFaction = "");
// Removes sCandidate (which should be the ID of a PC) as a candidate in sNation's
// current election.  If no election is in progress, this does nothing.
void miCZRemoveCandidate(string sNation, string sCandidate);
// Called annually to adjust nation stockpiles and do any automatic trading
void miCZDoAnnualTrade();
// Internal method, passed the list of nations on this server.
void _miCZDoAnnualTrade(string sNations);
// Obtains nAmount of sResource for sNation from its trading partners.  If
// nAmount cannot be obtained and bDecay is true, increments bDecay.
void miCZGetByTrade(string sNation, string sResource, int nAmount, int bDecay = TRUE);
// Returns true if oPC is a leader of sNation.  If sNation is blank, then oPC
// may be a leader of any nation.
int miCZGetIsLeader(object oPC, string sNation = "");
// Returns true if sLeaderID is a leader of sNation.  If sNation is blank, then
// sLeaderID may be a leader of any nation.
int miCZGetIsLeaderByID(string sLeaderID, string sNation = "");
// Returns TRUE if oPC is a leader of a nation who is the master of sNation.
int miCZGetIsMaster(object oPC, string sNation);
// Returns TRUE if sLeaderID is a leader of a nation who is the master of
// sNation.
int miCZGetIsMasterByID(string sLeaderID, string sNation);
// Returns TRUE if oPC is exiled from sNation, FALSE otherwise.
int miCZGetIsExiled(object oPC, string sNation);
// Returns the tax rate for sNation.  This is the fraction that should be
// charged on all shop purchases, and 1/10 this fraction of the value of a
// shop or quarter should be deducted each month as occupancy tax.
float miCZGetTaxRate(string sNation);
// Sets the tax rate for sNation to fTax, where fTax is no more than 1.
void miCZSetTaxRate(string sNation, float fTax);
// Pays tax, accounting for any decay sNationID might be suffering from.
// If oTakeFrom is used sCitizenID serves no purpose, take gold directly from oTakeFrom.
void miCZPayTax(string sCitizenID, string sNationID, int nAmount, int bAllowNegatives = FALSE, object oTakeFrom=OBJECT_INVALID);
// Returns TRUE if sNationSupply supplies sNationBuy by trade.
int miCZGetTrade(string sNationSupply, string sNationBuy);
// Sets whether or not sNationSupply should supply sNationBuy by trade.
void miCZSetTrade(string sNationSupply, string sNationBuy, int bOpen = TRUE);
// Returns TRUE if the PC with PCID sBanished is banished from sNation.
int miCZGetBanished(string sNation, string sBanished);
// Sets whether or not sBanished is banished from sNation.
void miCZSetBanished(string sNation, string sBanished, int bBanned = TRUE);
// Returns TRUE if sOffense is hostile to sDefense.
int miCZGetWar(string sOffense, string sDefense);
// Sets whether or not sOffense should be hostile to sDefense.
void miCZSetWar(string sOffense, string sDefense, int bWar = TRUE);
// Sets the master of sVassal to sProtectorate. If sProtectorate is empty, will
// free sVassal and make it independent.
void miCZSetVassal(string sVassal, string sProtectorate = "");
// Returns a formatted description of the settlement's current status.
string miCZGetSettlementStatus(string sNation);
// Get the trade status of sNation (a subset of the full settlement status).
string miCZGetSettlementTradeStatus(string sNation);
// Returns TRUE if sLeaderID has authority to act over sCitizenID.  This will be
// true unless sCitizenID and sLeaderID are peers (e.g. fellow councilors).  A
// councilor can be banished etc by the leader of a master state.
// Mord added an override so that these powers can be designated
// Where there is more than one leader, a whit signed by a majority is needed.
//Moved to inc_factions
//int miCZGetHasAuthority(string sLeaderID, string sCitizenID, string sNation, int nOverride=FALSE);
// Resigns a leader.
void miCZResign(string sLeaderID, string sNation);
// Get buy price of sResource at sNation
float miCZGetSettlementBuyPrice(string sNation, string sResource);
// Get sell price of sResource at sNation
float miCZGetSettlementSellPrice(string sNation, string sResource);
// Get stockpile amount for sResource at sNation
int miCZGetSettlementStockpile(string sNation, string sResource);
// Returns the number of citizens in sNation
int miCZGetCitizenCount(string sNation);
// Modify sNation's sResource stockpile by nAmount (which can be negative).
void miCZAddtoStockpile(string sNation, string sResource, int nAmount);
// A bankrupt nation cancels all exiles and wars, and boots out its leaders.
void miCZDoBankrupcy(string sNation);
//Counts exiles, uses SQL call
int mdCZGetExileCount(string sNation);
//Retrieves yearly resource cost. SQL calls.
struct Service mdCZYearlyResourceCost(string sNation);
//Gets the name and resources required for a service. Only expenaded warehouse supported
struct Service GetService(int nService);
//Checks to see if they have resources for the year and decreases resources by service amount
//oPC is the PC making the transaction
//sAreaID is for use for landbroker services only and is the area id used in that table.
int EnableService(int nService, string sNationID, object oPC, string sAreaID="");
//------------------------------------------------------------------------------
// Structs
//------------------------------------------------------------------------------
struct Service
{
    string sName;// = "Expanded Warehouse";
    int nFood;
    int nWood;
    int nMetal;
    int nCloth;
    int nStone;
};
struct Service GetService(int nService)
{
    struct Service retService;
    if(nService == MD_SV_EXPWH)
    {
        retService.sName = "Expanded Warehouse";
        retService.nFood = 1000;
        retService.nWood = 1000;
        retService.nMetal = 1000;
        retService.nCloth = 1000;
        retService.nStone = 1000;
    }
    else if(nService ==  SVC_UPKEEP_HIGH)
    {
        retService.sName = "Upkeep High";
        retService.nFood = 3000;
        retService.nWood = 3000;
        retService.nMetal = 3000;
        retService.nCloth = 3000;
        retService.nStone = 3000;
    }
    else if(nService ==  SVC_UPKEEP_MED)
    {
        retService.sName = "Upkeep Medium";
        retService.nFood = 2000;
        retService.nWood = 2000;
        retService.nMetal = 2000;
        retService.nCloth = 2000;
        retService.nStone = 2000;
    }
    else if(nService ==  SVC_UPKEEP_LOW)
    {
        retService.sName = "Upkeep Low";
        retService.nFood = 1000;
        retService.nWood = 1000;
        retService.nMetal = 1000;
        retService.nCloth = 1000;
        retService.nStone = 1000;
    }



    return retService;
}
//------------------------------------------------------------------------------
// Internal methods
//------------------------------------------------------------------------------
void _miCZUpdateNeeds(object oNation, string sNation, string sResource, string sResourceLower, int nBaseNeed)
{
  int nLeftoverNeed = 0;
  int nResourceAmount = GetLocalInt(oNation, sResource);

  if (nResourceAmount >= nBaseNeed)
  {
    Trace(CITIZENSHIP, sNation + " has enough " + sResourceLower + ".");
          nResourceAmount -= nBaseNeed;
  }
  else
  {
    nLeftoverNeed = nBaseNeed - nResourceAmount;
    nResourceAmount = 0;
    Trace(CITIZENSHIP, sNation + " doesn't have enough " + sResourceLower + ", by " + IntToString(nLeftoverNeed));
  }

  SetLocalInt(oNation, sResource, nResourceAmount);
  miDASetKeyedValue("micz_nations", sNation, sResourceLower, IntToString(nResourceAmount));

  SetLocalInt(OBJECT_SELF, sNation + sResource, nLeftoverNeed);
}
//------------------------------------------------------------------------------
void _miCZGetByTrade(string sNation, string sResource)
{
  int nLeftoverNeed = GetLocalInt(OBJECT_SELF, sNation + sResource);

  if (nLeftoverNeed > 0)
  {
    miCZGetByTrade(sNation, sResource, nLeftoverNeed);
  }
}
//------------------------------------------------------------------------------
void _RemoveNationPowersFromCache(string sNation, string sPCID)
{
    string sNationName = miCZGetName(sNation);
    string sFDatabaseID = GetLocalString(GetModule(), "MD_FA_"+sNationName);
    object oCacheObject = miDAGetCacheObject(DATABASE_PREFIX+sFDatabaseID);
    _RemoveMemFacCache(oCacheObject, sPCID);

    int nMax = md_FaRankCount(sFDatabaseID);
    int nCount;
    for(nCount = 1; nCount <= nMax; nCount++)
    {
      oCacheObject = miDAGetCacheObject(DATABASE_PREFIX+GetLocalString(GetModule(), "MD_FA_"+md_FAGetRankName(sFDatabaseID, md_FAGetNthRankID(sFDatabaseID, nCount))));
      _RemoveMemFacCache(oCacheObject, sPCID);
    }

}
//------------------------------------------------------------------------------
// Method implementations.
//------------------------------------------------------------------------------
object miCZLoadNation(string sNation)
{
  Trace(CITIZENSHIP, "Loading nation: " + sNation);
  if (sNation == "") return OBJECT_INVALID;

  object oCache = miDAGetCacheObject(sNation);
  // Check whether we're already loaded.  When creating a new nation we set
  // MASTER to NONE if there's no master nation.
  if (GetLocalString(oCache, VAR_MASTER) != "") return oCache;

  Trace(CITIZENSHIP, "Loading from database");

  SQLExecStatement("SELECT IF(master IS NULL,'NONE',master),food,wood,cloth," +
   "metal,stone,decay,election_start,contract,tax,foodsellprice,woodsellprice," +
   "clothsellprice,metalsellprice,stonesellprice,foodbuyprice,woodbuyprice," +
   "clothbuyprice,metalbuyprice,stonebuyprice,name FROM micz_nations WHERE id=?",
   sNation);

  if (SQLFetch())
  {
    SetLocalString(oCache, VAR_MASTER, SQLGetData(1));
    SetLocalInt(oCache, RESOURCE_FOOD, StringToInt(SQLGetData(2)));
    SetLocalInt(oCache, RESOURCE_WOOD, StringToInt(SQLGetData(3)));
    SetLocalInt(oCache, RESOURCE_CLOTH, StringToInt(SQLGetData(4)));
    SetLocalInt(oCache, RESOURCE_METAL, StringToInt(SQLGetData(5)));
    SetLocalInt(oCache, RESOURCE_STONE, StringToInt(SQLGetData(6)));
    SetLocalInt(oCache, VAR_DECAY, StringToInt(SQLGetData(7)));
    SetLocalInt(oCache, VAR_ELECTION_START, StringToInt(SQLGetData(8)));
    SetLocalInt(oCache, VAR_CONTRACT, StringToInt(SQLGetData(9)));
    SetLocalFloat(oCache, VAR_TAX, StringToFloat(SQLGetData(10)));
    SetLocalFloat(oCache, VAR_SELLPRICE + RESOURCE_FOOD, StringToFloat(SQLGetData(11)));
    SetLocalFloat(oCache, VAR_SELLPRICE + RESOURCE_WOOD, StringToFloat(SQLGetData(12)));
    SetLocalFloat(oCache, VAR_SELLPRICE + RESOURCE_CLOTH, StringToFloat(SQLGetData(13)));
    SetLocalFloat(oCache, VAR_SELLPRICE + RESOURCE_METAL, StringToFloat(SQLGetData(14)));
    SetLocalFloat(oCache, VAR_SELLPRICE + RESOURCE_STONE, StringToFloat(SQLGetData(15)));
    SetLocalFloat(oCache, VAR_BUYPRICE + RESOURCE_FOOD, StringToFloat(SQLGetData(16)));
    SetLocalFloat(oCache, VAR_BUYPRICE + RESOURCE_WOOD, StringToFloat(SQLGetData(17)));
    SetLocalFloat(oCache, VAR_BUYPRICE + RESOURCE_CLOTH, StringToFloat(SQLGetData(18)));
    SetLocalFloat(oCache, VAR_BUYPRICE + RESOURCE_METAL, StringToFloat(SQLGetData(19)));
    SetLocalFloat(oCache, VAR_BUYPRICE + RESOURCE_STONE, StringToFloat(SQLGetData(20)));
    SetLocalString(oCache, VAR_NAME, SQLGetData(21));

    // Now deal with war, trade and banishment
    SQLExecStatement("SELECT nation_def FROM micz_war WHERE nation_agg=?", sNation);
    string sConc = ";;";
    while (SQLFetch())
    {
      sConc += SQLGetData(1) + ";;";
    }
    SetLocalString(oCache, VAR_WAR, sConc);

    SQLExecStatement("SELECT nation_buy FROM micz_trade WHERE nation_sell=?", sNation);
    sConc = ";;";
    while (SQLFetch())
    {
      sConc += SQLGetData(1) + ";;";
    }
    SetLocalString(oCache, VAR_TRADE, sConc);

    SQLExecStatement("SELECT pc_id FROM micz_banish WHERE nation=?", sNation);
    sConc = ";;";
    while (SQLFetch())
    {
      sConc += SQLGetData(1) + ";;";
    }
    SetLocalString(oCache, VAR_BANISHED, sConc);

    // Also store the details of the leadership position for this faction as we
    // otherwise would need to retrieve it a lot.
    SQLExecStatement("SELECT rank_id,row_key,holders FROM micz_positions WHERE " +
     "nation=? AND master_rank IS NULL", sNation);

    if (SQLFetch())
    {
      string sRankID   = SQLGetData(1);
      string sPosition = SQLGetData(2);
      int nNumHolders  = StringToInt(SQLGetData(3));
      string sHolder;

      SQLExecStatement("SELECT pc_id, holder_id, granted, fac_id FROM micz_rank WHERE " +
       "rank_id=? ORDER BY holder_id ASC", sRankID);

      while (SQLFetch())
      {
        sHolder = SQLGetData(2);
        SetLocalString(oCache, VAR_CURRENT_LEADER + sHolder, SQLGetData(1));
        SetLocalInt(oCache, VAR_CURRENT_LEADER_TIME + sHolder, StringToInt(
         SQLGetData(3)));
        SetLocalString(oCache, VAR_CURRENT_LEADER + sHolder + "F",
         SQLGetData(4));
      }

      Trace(CITIZENSHIP, "Got leadership position: " + sPosition);

      SetLocalString(oCache, VAR_LEADER, sPosition);
      SetLocalInt(oCache, VAR_NUM_LEADERS, nNumHolders);
    }
  }

  return oCache;
}
//------------------------------------------------------------------------------
string miCZGetName(string sNation)
{
  object oNation = miCZLoadNation(sNation);
  return GetLocalString(oNation, VAR_NAME);
}
//------------------------------------------------------------------------------
string miCZGetBestNationMatch(string sNation)
{
  Trace(CITIZENSHIP, "Trying to find a match for: " + sNation);

  if (sNation == "")
  {
    Trace(CITIZENSHIP, "Ignoring empty input.");
    return "";
  }

  SQLExecStatement("SELECT id FROM micz_nations WHERE name LIKE ? LIMIT 1",
    "%" + sNation + "%");

  if (!SQLFetch())
  {
    Trace(CITIZENSHIP, "No match found.");
    return "";
  }

  sNation = SQLGetData(1);
  Trace(CITIZENSHIP, "Found a match: " + sNation);
  return sNation;
}
//------------------------------------------------------------------------------
void miCZCreateNation(string sNation, string sLeadershipPosition, int nNumLeaders)
{
  Trace(CITIZENSHIP, "Creating nation: " + sNation);
  // Check whether nation exists.
  object oCache = miCZLoadNation(miCZGetBestNationMatch(sNation));

  if (GetLocalString(oCache, VAR_MASTER) == "")
  {
    Trace(CITIZENSHIP, "Nation doesn't already exist, adding to database.");
    SetLocalString(oCache, VAR_MASTER, "NONE");

    SQLExecStatement("INSERT INTO micz_nations (name,master,foodsellprice,woodsellprice," +
     "clothsellprice,metalsellprice,stonesellprice,foodbuyprice,woodbuyprice,clothbuyprice," +
     "metalbuyprice,stonebuyprice,bank) values (?,NULL,'1.5','1.5','1.5','1.5','1.5'," +
     "'0.5','0.5','0.5','0.5','0.5','0')", sNation);

    SQLExecStatement("SELECT id FROM micz_nations ORDER BY id DESC LIMIT 1");

    if (SQLFetch())
    {
      SQLExecStatement("INSERT INTO micz_positions (row_key,nation,holders) values (?,?,?)",
       sLeadershipPosition, SQLGetData(1), IntToString(nNumLeaders));
    }
  }
}
//------------------------------------------------------------------------------
void miCZDoSalaries()
{
  Trace(CITIZENSHIP, "Dishing out salaries for all positions");

  // NASTY query, but provides very nice results. :D
  SQLExecStatement("SELECT cr1.pc_id, cp1.salary, IF(cp2.master_rank IS NULL, " +
   "CONCAT('N', cp1.nation), cr2.pc_id) FROM micz_positions AS cp1 INNER JOIN " +
   "micz_positions AS cp2 INNER JOIN micz_rank AS cr1 INNER JOIN micz_rank AS " +
   "cr2 ON cp1.rank_id=cr1.rank_id AND cp2.rank_id=cr2.rank_id WHERE " +
   "cp1.master_rank=cr2.rank_id AND cp1.master_holder=cr2.holder_id");

  while (SQLFetch())
  {
    gsFITransferFromTo(SQLGetData(3), SQLGetData(1), StringToInt(SQLGetData(2)));
  }

  WriteTimestampedLogEntry("Salaries paid successfully.");
}
//------------------------------------------------------------------------------
int miCZTimeForElection(string sNation)
{
  Trace(CITIZENSHIP, "Checking if it's time for " + sNation + " to have an election.");

  object oNation = miCZLoadNation(sNation);
  if (!GetIsObjectValid(oNation))
  {
    Error(CITIZENSHIP, " miCZTimeForElection called for invalid nation " + sNation);
  }

  int nHolders = GetLocalInt(oNation, VAR_NUM_LEADERS);
  int nI       = 1;
  int nTime    = 0;
  int nNow     = gsTIGetActualTimestamp();

  for (; nI <= nHolders; nI++)
  {

    nTime = GetLocalInt(oNation, VAR_CURRENT_LEADER_TIME + IntToString(nI));
    Log(CITIZENSHIP, "!!!SHARPS DEBUG!!!3 Nation ID: " + sNation + " Position: " + IntToString(nI) + " Holders: " + IntToString(nHolders) + " Time: " + IntToString(nTime));
    // Check to see that the leader both exists and has not been in power for
    // over a year.
    // nNow and nTime are both absolute (actual) timestamps so we can
    // just subtract them.
    if (!nTime || gsTIGetAbsoluteYear(nNow - nTime) > 0)
    {
      return TRUE;
    }
  }
  return FALSE;
}
//------------------------------------------------------------------------------
int miCZIsElectionInProgress(object oPC, string sNation = "")
{
  Trace(CITIZENSHIP, "Checking if election is in progress for " + GetName(oPC));

  if (sNation == "") sNation = GetLocalString(oPC, VAR_NATION);
  if (sNation == "") return FALSE;

  Trace(CITIZENSHIP, "Checking for bankruptcy of nation " + sNation);

  if (gsFIGetAccountBalance("N" + sNation) <= 0)
  {
    miCZDoBankrupcy(sNation);
  }

  return _miCZIsElectionInProgress(sNation);
}
//------------------------------------------------------------------------------
int _miCZIsElectionInProgress(string sNation)
{
  Trace(CITIZENSHIP, "Checking if election is in progress for " + sNation);

  object oCache = miCZLoadNation(sNation);
  int nElectionStarted = GetLocalInt(oCache, VAR_ELECTION_START);
  Log(CITIZENSHIP, "!!!SHARPS DEBUG!!!2 Nation ID: " + sNation + " Election Started? " + IntToString(nElectionStarted) + " Value should be 0");
  if (!nElectionStarted) return FALSE;

  int nNow = gsTIGetActualTimestamp();

  int nDays = (gsTIGetYear(nNow) * 12 + gsTIGetMonth(nNow)) * 30 + gsTIGetDay(nNow) -
            (gsTIGetYear(nElectionStarted) * 12 + gsTIGetMonth(nElectionStarted)) * 30 -
            gsTIGetDay(nElectionStarted);

  if (nDays < 30) return TRUE;

  // Election has been going for over a month.  Complete it.
  _miCZCompleteElection(sNation);
  return FALSE;
}
//------------------------------------------------------------------------------
void miCZStartElection(string sNation, string sCandidate, string sFaction = "")
{
  Trace(CITIZENSHIP, "Starting election for nation: " + sNation);
  int nNow = gsTIGetActualTimestamp();
  object oNation = miCZLoadNation(sNation);
  SetLocalInt(oNation, VAR_ELECTION_START, nNow);
  miDASetKeyedValue("micz_nations", sNation, "election_start", IntToString(nNow));

  // clear out the old vote table. Note - we do this now so we can look at it
  // in the database between elections.
  SQLExecStatement("DELETE FROM micz_votes WHERE nation=?", sNation);

  miCZAddCandidate(sNation, sCandidate, sFaction);

  //No longer add the old leaders, we now import over the other table
  SQLExecStatement("INSERT INTO micz_votes(nation,candidate,fac_id,votes) SELECT nation, candidate, fac_id, '00000;;' FROM mdcz_cand WHERE nation=?", sNation);
  SQLExecStatement("DELETE FROM mdcz_cand WHERE nation=?", sNation);
}
//------------------------------------------------------------------------------
void _miCZCompleteElection(string sNation)
{
  Trace(CITIZENSHIP, "Completing election in " + sNation);

  // Mark that no election is in progress.
  object oNation = miCZLoadNation(sNation);
  SetLocalInt(oNation, VAR_ELECTION_START, 0);
  miDASetKeyedValue("micz_nations", sNation, "election_start", "0");
  miDASetKeyedValue("micz_nations", sNation, "noble_timestamp", "0"); //refresh timestamp as well, setting to 0 will give them a token next time a leader speaks to their registrar

  string sPosition  = GetLocalString(oNation, VAR_LEADER);
  int nNumPositions = GetLocalInt(oNation, VAR_NUM_LEADERS);

  // Select the rank to be competed for
  SQLExecStatement("SELECT rank_id FROM micz_positions WHERE nation=? AND " +
   "master_rank IS NULL", sNation);
  SQLFetch();
  string sRankID = SQLGetData(1);

  SQLExecStatement("SELECT candidate, fac_id FROM micz_votes WHERE nation=? ORDER BY " +
   "votes DESC LIMIT " + IntToString(nNumPositions), sNation);

  string sNewLeaders = "";
  string sCandidate;
  string sFaction;
  int nI = 0;
  string sI;
  int nNow    = gsTIGetActualTimestamp();
  string sNow = IntToString(nNow);

  while (SQLFetch())
  {
    // Delimiter - apply each time except first.
    if (sNewLeaders != "")
    {
      sNewLeaders += ",";
    }
    nI++;
    sI = IntToString(nI);
    sCandidate = SQLGetData(1);
    sFaction = SQLGetData(2);
    Trace(CITIZENSHIP, "Electing " + sCandidate);
    SetLocalString(oNation, VAR_CURRENT_LEADER + sI, sCandidate);
    SetLocalString(oNation, VAR_CURRENT_LEADER + sI + "F", sFaction);
    SetLocalInt(oNation, VAR_CURRENT_LEADER_TIME + sI, nNow);
    sNewLeaders += SQLPrepareStatement("(?,?,?,?,?)", sRankID, sI, sCandidate, sNow, sFaction);
  }
  string sID;
  for (nI = 1; nI <= nNumPositions; nI++)
  {
    sID = GetLocalString(oNation, VAR_CURRENT_LEADER + IntToString(nI));
    // Unexile the characters, if they've been exiled since the poll began.
    miCZSetBanished(sNation,
                    sID,
                    FALSE);
    //They're going into office. remove them from the faction system for this nation
    //Removed to make compliant with landed nobles
    //SQLExecStatement("DELETE Mem FROM md_fa_members AS Mem INNER JOIN md_fa_factions AS Fac  ON Mem.faction_Id = Fac.id WHERE Fac.nation=? AND Mem.pc_id=?", sNation, sID);
    //_RemoveNationPowersFromCache(sNation, sID);
  }

  // Delete all existing leaders from the database, then add new ones.
  if (sNewLeaders != "")
  {
    //Removed to make compliant with landed nobles
    /*SQLExecStatement("SELECT Mem.pc_id FROM md_fa_members AS Mem INNER JOIN md_fa_factions AS Fac ON Mem.faction_id = Fac.id INNER JOIN micz_rank AS Rank ON Rank.pc_id = Mem.pc_id WHERE Fac.nation=? AND Rank.rank_id=? GROUP BY Mem.pc_id", sNation, sRankID);
    while(SQLFetch())
    {
      _RemoveNationPowersFromCache(sNation, SQLGetData(1));
    }
    SQLExecStatement("DELETE Mem FROM md_fa_members AS Mem INNER JOIN md_fa_factions AS Fac ON Mem.faction_id = Fac.id INNER JOIN micz_rank AS Rank ON Rank.pc_id = Mem.pc_id WHERE Fac.nation=? AND Rank.rank_id=?", sNation, sRankID);*/
    SQLExecStatement("DELETE FROM micz_rank WHERE rank_id=?", sRankID);
    SQLExecStatement("INSERT INTO micz_rank (rank_id, holder_id, pc_id, granted, fac_id) " +
   "VALUES " + sNewLeaders);
  }
}
//------------------------------------------------------------------------------
void miCZNotifyAllCitizens(string sNation, string sMessage)
{
  Trace(CITIZENSHIP, "Informing all citizens of " + sNation + ": " + sMessage);

  object oPC = GetFirstPC();

  while (GetIsObjectValid(oPC))
  {
    if (GetLocalString(oPC, VAR_NATION) == sNation)
    {
      FloatingTextStringOnCreature(sMessage, oPC, FALSE);
    }

    oPC = GetNextPC();
  }
}
//------------------------------------------------------------------------------
void miCZAddCandidate(string sNation, string sCandidate, string sFaction = "")
{
  Trace(CITIZENSHIP, "Adding candidate " + sCandidate + " for election at " + sNation);

  if (!_miCZIsElectionInProgress(sNation)) return;

  SQLExecStatement("INSERT INTO micz_votes (nation,candidate,votes,fac_id) VALUES (?,?,'00000;;',?)",
   sNation, sCandidate, sFaction);
}
//------------------------------------------------------------------------------
void miCZRemoveCandidate(string sNation, string sCandidate)
{
  Trace(CITIZENSHIP, "Removing candidate " + sCandidate + " for election at " + sNation);

  if (!_miCZIsElectionInProgress(sNation)) return;

  SQLExecStatement("DELETE FROM micz_votes WHERE nation=? AND candidate=?",
   sNation, sCandidate);
}
//------------------------------------------------------------------------------
int miCZGetCitizenCount(string sNation)
{
  SQLExecStatement("SELECT COUNT(DISTINCT l.cdkey) FROM gs_pc_data AS c INNER JOIN gs_player_data AS l ON c.keydata=l.id WHERE nation=? AND DATE_SUB(CURDATE(), INTERVAL 37 DAY) < c.modified", sNation);
  SQLFetch();
  return StringToInt(SQLGetData(1));
}
//------------------------------------------------------------------------------
void miCZDoAnnualTrade()
{
  // This method is going to be horrible for performance.  Also need to
  // watch out for TMIs, so we've lifted the TMI limit using nwnx_TMI.
  //Trace (CITIZENSHIP, "Removing old citizens from the database");
  //SQLExecDirect("UPDATE gs_pc_data SET nation=NULL,modified=modified WHERE nation IS NOT NULL and " +
  //"DATE_SUB(CURDATE(), INTERVAL 37 DAY) > modified");

  Trace(CITIZENSHIP, "Performing annual trade.");

  //----------------------------------------------------------------------------
  // Go through each nation and:
  // - determine its current needs
  // - reduce its current needs from its stockpiles
  // - if stockpiles are insufficient, save off remaining need
  //
  // Once all nations are complete...
  // - check each nation's outstanding need
  // - for any that are > 0, check all trading partners in asc price order
  // - if any trading partners have stockpiles, buy what's needed
  //  -- NB - allow balance to go negative on this transfer! --
  // - if no trade partners have stockpiles, check whether nation has external
  //   trade set up
  // - If so, use external trade
  // - If not, increment Decay counter for the nation
  //
  // FINALLY
  // - set all nations to not have external trade set up (contracts must be
  //   renewed annually)
  //----------------------------------------------------------------------------

  // We need to do lots of nested searches, so use lists to do this, or our
  // SQL results will override each other.
  DeleteList("MI_NATION_LIST");
  string sNations;

  string sServer = miXFGetCurrentServer();
  if (sServer == SERVER_ISLAND)
  {
    // Due to caching issues, only do the nations that are relevant to this
    // server.
    sNations = "'Bendir','Brogendenstein','Guldorand','Myon'";
  }
  else if (sServer == SERVER_UNDERDARK)
  {
    sNations = "'Andunor_Devils_Table','Andunor_The_Sharps','Blingstonhold','Cordor'";
  }



  _miCZDoAnnualTrade(sNations);
}

void _miCZDoAnnualTrade(string sNations)
{
  string sNation;
  object oNation;

  int nLeftoverNeed;
  int nResourceAmount;

  SQLExecDirect("SELECT id FROM micz_nations WHERE name IN (" + sNations + ")");
  while (SQLFetch())
  {
    AddStringElement(SQLGetData(1), "MI_NATION_LIST");
  }

  Trace(CITIZENSHIP, "Got list of nations.");

  int nNumNations = GetElementCount("MI_NATION_LIST");
  int nCount;
  struct Service nBaseNeed;
  for (nCount = 0; nCount < nNumNations; nCount++)
  {
    sNation = GetStringElement(nCount, "MI_NATION_LIST");
    oNation = miCZLoadNation(sNation);
    Trace(CITIZENSHIP, "Getting needs for " + sNation);

    nBaseNeed = mdCZYearlyResourceCost(sNation);

    _miCZUpdateNeeds(oNation, sNation, RESOURCE_FOOD, "food", nBaseNeed.nFood);
    _miCZUpdateNeeds(oNation, sNation, RESOURCE_WOOD, "wood", nBaseNeed.nWood);
    _miCZUpdateNeeds(oNation, sNation, RESOURCE_METAL, "metal", nBaseNeed.nMetal);
    _miCZUpdateNeeds(oNation, sNation, RESOURCE_STONE, "stone", nBaseNeed.nStone);
    _miCZUpdateNeeds(oNation, sNation, RESOURCE_CLOTH, "cloth", nBaseNeed.nCloth);
  }

  // We've now adjusted every nation's stockpiles.  If any nation still needs
  // anything, now's the time to sort it out through trade.
  //
  // Check decay before and after.  If decay isn't incremented and is greater
  // than zero, zero it now (as the settlement has all they need).
  for (nCount = 0; nCount < nNumNations; nCount++)
  {
    sNation = GetStringElement(nCount, "MI_NATION_LIST");
    oNation = miCZLoadNation(sNation);
    Trace(CITIZENSHIP, "Checking trade requirements for " + sNation);

    int nDecay = GetLocalInt(oNation, VAR_DECAY);
    _miCZGetByTrade(sNation, RESOURCE_FOOD);
    _miCZGetByTrade(sNation, RESOURCE_WOOD);
    _miCZGetByTrade(sNation, RESOURCE_METAL);
    _miCZGetByTrade(sNation, RESOURCE_STONE);
    _miCZGetByTrade(sNation, RESOURCE_CLOTH);

    if (nDecay && GetLocalInt(oNation, VAR_DECAY) == nDecay)
    {
      SetLocalInt(oNation, VAR_DECAY, 0);
      miDASetKeyedValue("micz_nations", sNation, "decay", "0");
    }
  }

  // Finally, remove any trade contracts.
  for (nCount = 0; nCount < nNumNations; nCount++)
  {
    sNation = GetStringElement(nCount, "MI_NATION_LIST");
    oNation = miCZLoadNation(sNation);

    SetLocalInt(oNation, VAR_CONTRACT, 0);
  }

  SQLExecStatement("UPDATE micz_nations SET contract='0' WHERE id in (" + sNations + ")");

  // Phew, that's it.
}
//------------------------------------------------------------------------------
void miCZGetByTrade(string sNation, string sResource, int nAmount, int bDecay = TRUE)
{
  Trace(CITIZENSHIP, "Getting " + IntToString(nAmount) + " " + sResource + " for "
   + sNation + " by trade.");

  string sSeller;
  int nStockpile;
  float fPrice;
  int nCost;
  int nTradeAmount;
  int nTreasury = gsFIGetAccountBalance("N" + sNation);

  // Query for resources, returning prospective sellers, cheapest first.
  SQLExecStatement("SELECT ct.nation_sell, cn." + sResource + ", cn." + sResource +
   "sellprice FROM micz_nations AS cn INNER JOIN micz_trade AS ct ON "+
   "ct.nation_sell=cn.id WHERE cn." + sResource + " > 0 AND ct.nation_buy=? " +
   "ORDER BY cn." + sResource + "sellprice ASC", sNation);

  while (SQLFetch() && nTreasury)
  {
    sSeller = SQLGetData(1);
    nStockpile = StringToInt(SQLGetData(2));
    fPrice = StringToFloat(SQLGetData(3));

    Trace(CITIZENSHIP, "Found seller: " + sSeller + " selling " + IntToString(nStockpile) +
     " at " + FloatToString(fPrice));

    if (nStockpile >= nAmount)
    {
      Trace(CITIZENSHIP, "Seller has enough to cover our remaining needs.");
      nCost = FloatToInt(fPrice * IntToFloat(nAmount));
      nTradeAmount = nAmount;

      if (nCost > nTreasury)
      {
        nCost = nTreasury;
        nTradeAmount = FloatToInt(IntToFloat(nCost) / fPrice);
      }

      gsFITransferFromTo("N" + sNation, "N" + sSeller, nCost, TRUE);
      nStockpile -= nTradeAmount;
      nAmount -= nTradeAmount;
      nTreasury -= nCost;
    }
    else
    {
      Trace(CITIZENSHIP, "Seller doesn't have enough to cover our remaining needs.");
      nCost = FloatToInt(fPrice * IntToFloat(nStockpile));
      nTradeAmount = nStockpile;

      if (nCost > nTreasury)
      {
        nCost = nTreasury;
        nTradeAmount = FloatToInt(IntToFloat(nCost) / fPrice);
      }

      gsFITransferFromTo("N" + sNation, "N" + sSeller, nCost, TRUE);
      nAmount -= nStockpile;
      nStockpile -= nTradeAmount;
      nTreasury -= nCost;
    }

    miDASetKeyedValue("micz_nations", sSeller, sResource, IntToString(nStockpile));
    SetLocalInt(miCZLoadNation(sSeller), sResource, nStockpile);

    if (!nAmount) return;
  }

  // If we get here then, even after exhausting our trade agreements, we can't
  // cover our own needs. So now we see if we have a shipping contract.
  object oNation = miCZLoadNation(sNation);
  int nContract = GetLocalInt(oNation, VAR_CONTRACT);
  if (nContract && nTreasury)
  {
    Trace(CITIZENSHIP, "Satisfying remaining " + IntToString(nAmount) +
                       " by contract trade.");
    fPrice = ((nContract == 1) ? SHIPPING_SURCHARGE : PIRATE_SURCHARGE);
    nCost  = FloatToInt(fPrice * IntToFloat(nAmount));
    nTradeAmount = nAmount;

    if (nCost > nTreasury)
    {
      nCost = nTreasury;
      nTradeAmount = FloatToInt(IntToFloat(nCost) / fPrice);
    }

    gsFITransferFromTo("N" + sNation, "DUMMY", nCost, TRUE);
    nAmount -= nTradeAmount;
    if (!nAmount) return;
  }

  // If we get here, even external suppliers weren't able to help us.  Increment
  // Decay.
  int nDecay = GetLocalInt(oNation, VAR_DECAY) + 1;
  if (nDecay == 100) nDecay = 99; // cap
  SetLocalInt(oNation, VAR_DECAY, nDecay);
  miDASetKeyedValue("micz_nations", sNation, "decay", IntToString(nDecay));
}
//------------------------------------------------------------------------------
int miCZGetIsLeaderByID(string sLeaderID, string sNation = "")
{
  Trace(CITIZENSHIP, "Checking whether " + sLeaderID + " is a leader of " +
   (sNation == "" ? "any nation" : sNation));

  SQLExecStatement("SELECT COUNT(1) FROM micz_positions AS cp INNER JOIN micz_rank " +
   "AS cr ON cp.rank_id=cr.rank_id WHERE cp.master_rank IS NULL AND cr.pc_id=?" +
   (sNation == "" ? "" : " AND cp.nation=?"), sLeaderID, sNation);

  if (SQLFetch())
  {
    int bLeader = StringToInt(SQLGetData(1));
    Trace(CITIZENSHIP, "Returning " + IntToString(bLeader > 0));
    return (bLeader > 0);
  }

  Trace(CITIZENSHIP, "Returning 0");
  return FALSE;
}
//------------------------------------------------------------------------------
int miCZGetIsLeader(object oPC, string sNation = "")
{
  return miCZGetIsLeaderByID(gsPCGetPlayerID(oPC), sNation);
}
//------------------------------------------------------------------------------
int miCZGetIsMasterByID(string sLeaderID, string sNation)
{
  Trace(CITIZENSHIP, "Checking whether " + sLeaderID + " is a master of " +
    sNation);

  object oNation = miCZLoadNation(sNation);
  string sMasterNation = GetLocalString(oNation, VAR_MASTER);

  if (sMasterNation == "NONE") return FALSE;
  return miCZGetIsLeaderByID(sLeaderID, sMasterNation);
}
//------------------------------------------------------------------------------
int miCZGetIsMaster(object oPC, string sNation)
{
  return miCZGetIsMasterByID(gsPCGetPlayerID(oPC), sNation);
}
//------------------------------------------------------------------------------
int miCZGetIsExiled(object oPC, string sNation)
{
  Trace(CITIZENSHIP, "Checking whether " + GetName(oPC) + " is exiled from " + sNation);

  // Check if at war, or banished.
  object oNation = miCZLoadNation(sNation);
  string sPCNation = GetLocalString(oPC, VAR_NATION);
  //We want to see if he's exiled from his home settlement to ignore war
  //for this check as the player can remove themself from them.
  //ignore this check if pc's nation and the nation entering is the name
  int nExlHome = FALSE;
  if(sPCNation != sNation)
  {
    nExlHome = miCZGetBanished(sPCNation, gsPCGetPlayerID(oPC));
  }
  if ((FindSubString(GetLocalString(oNation, VAR_WAR), ";;" + sPCNation + ";;") != -1 && !nExlHome)||
   FindSubString(GetLocalString(oNation, VAR_BANISHED), ";;" + gsPCGetPlayerID(oPC) + ";;") != -1)
  {
    return TRUE;
  }
  else
  {

    // check for attacking nations factions
    SQLExecStatement("SELECT War.nation_def FROM micz_war As War INNER JOIN md_fa_factions As Fac ON War.nation_def = Fac.nation INNER JOIN md_fa_members AS Mem ON Fac.id = Mem.faction_id WHERE War.nation_agg=? AND Mem.pc_id=? GROUP BY War.nation_def", sNation, gsPCGetPlayerID(oPC));
    if(SQLFetch()) return TRUE;

    // addition Dunshine: also check for defending nations factions
    SQLExecStatement("SELECT War.nation_agg FROM micz_war As War INNER JOIN md_fa_factions As Fac ON War.nation_agg = Fac.nation INNER JOIN md_fa_members AS Mem ON Fac.id = Mem.faction_id WHERE War.nation_def=? AND Mem.pc_id=? GROUP BY War.nation_agg", sNation, gsPCGetPlayerID(oPC));
    if(SQLFetch()) return TRUE;

  }
  return FALSE;
}
//------------------------------------------------------------------------------
float miCZGetTaxRate(string sNation)
{
  object oCache = miCZLoadNation(sNation);
  float fTax = GetLocalFloat(oCache, VAR_TAX);

  if (fTax == 0.0) fTax = 0.1; // 10% base, or 1% monthly on quarters and shops

  Trace(CITIZENSHIP, "Tax rate for " + sNation + " is " + FloatToString(fTax));

  return fTax;
}
//------------------------------------------------------------------------------
void miCZSetTaxRate(string sNation, float fTax)
{
  object oCache = miCZLoadNation(sNation);
  SetLocalFloat(oCache, VAR_TAX, fTax);
  SQLExecStatement("UPDATE micz_nations SET tax=? WHERE id=?",
   FloatToString(fTax), sNation);
}
//------------------------------------------------------------------------------
void miCZPayTax(string sCitizenID, string sNationID, int nAmount, int bAllowNegatives = FALSE, object oTakeFrom=OBJECT_INVALID)
{
  Trace(BANK, "Paying tax; amount: " + IntToString(nAmount) + ", from: " + sCitizenID +
   ", to: " + sNationID);
  struct gsFIAccount stDest = gsFIGetAccount("N" + sNationID);
  struct gsFIAccount stFrom;

  if(GetIsObjectValid(oTakeFrom))
  {
    //shouldn't happen ever.. but just in case
    if(GetGold(oTakeFrom) < nAmount)
    {
        Trace(BANK, "miczPayTax() " + GetName(oTakeFrom) + " did not have enough to cover his taxes to Nation " + sNationID);
        nAmount = GetGold(oTakeFrom);
    }
    stDest = gsFIAdjustBalance(stDest, nAmount, bAllowNegatives);

  }
  else
  {
    stFrom = gsFIGetAccount(sCitizenID);

    if (!stFrom.bValid || !stDest.bValid) return; //invalid account

    // Attempt to make the transfer.
    stFrom = gsFIAdjustBalance(stFrom, -nAmount, bAllowNegatives);
    stDest = gsFIAdjustBalance(stDest, nAmount, bAllowNegatives);

    // Use the smaller amount, in case they are different. Remember that
    // stFrom.nLastAdjust is negative. The difference is therefore the two
    // nLastAdjust variables added together.
    // nb - this code should never actually be needed since gsQUPayTax checks
    // first.  But doesn't hurt to firewall.
    if (-stFrom.nLastAdjust >= stDest.nLastAdjust)
    {
      nAmount = stDest.nLastAdjust;
      stFrom.nBalance -= stFrom.nLastAdjust + stDest.nLastAdjust;
    }
    else
    {
      nAmount = -stFrom.nLastAdjust;
      stDest.nBalance -= stFrom.nLastAdjust + stDest.nLastAdjust;
    }
  }

  if (nAmount > 0)
  {
    object oPC;
    if(!GetIsObjectValid(oTakeFrom))
    {
      Trace(CITIZENSHIP, "Taking " + IntToString(nAmount) + " from " + sCitizenID);
      gsFISaveAccount(stFrom);

      oPC = gsPCGetPlayerByID(sCitizenID);
      if (GetIsObjectValid(oPC))
        SetLocalInt(oPC, "GS_FINANCE", stFrom.nBalance);
    }
    else
    {
        Trace(CITIZENSHIP, "Taking " + IntToString(nAmount) + " from " + GetName(oTakeFrom));
        TakeGoldFromCreature(nAmount, oTakeFrom, TRUE);
    }
    // Apply any decay.
    object oNation = miCZLoadNation(sNationID);
    int nDecay       = GetLocalInt(oNation, VAR_DECAY);
    int nDecayAmount = FloatToInt(IntToFloat(nAmount) * (IntToFloat(nDecay)/100.0));
    stDest = gsFIAdjustBalance(stDest, -nDecayAmount);

    //Pay out taxes to landed nobles
    int nNobleAmt = nAmount - nDecayAmount;

    if(nNobleAmt >= 20) //only do if amount earned is greater than 20 gold
    {
        struct gsFIAccount stNoble;
        nNobleAmt = FloatToInt(IntToFloat(nNobleAmt) * 0.05); //settlements keep the change

        //we'll cache so nested sqls don't happen
        SQLExecStatement("SELECT m.pc_id FROM md_fa_members AS m INNER JOIN md_fa_factions AS f ON f.id=m.faction_id WHERE f.nation=? AND f.type=? AND m.is_Noble=1", sNationID, IntToString(0x40000000));
        DeleteList("NOBLE_LIST");
        while(SQLFetch())
        {
            AddStringElement(SQLGetData(1), "NOBLE_LIST");
        }
        int x;
        string sID;
        for(x=0; x<GetElementCount("NOBLE_LIST"); x++)
        {
            sID = GetStringElement(x, "NOBLE_LIST");
            stNoble = gsFIGetAccount(sID);
            stNoble = gsFIAdjustBalance(stNoble, nNobleAmt);
            Trace(CITIZENSHIP, "Adding " + IntToString(nNobleAmt) + " to a " + sID + " Noble from " + sNationID);
            oPC = gsPCGetPlayerByID(sID);
            if (GetIsObjectValid(oPC))
              SetLocalInt(oPC, "GS_FINANCE", stNoble.nBalance);
            gsFISaveAccount(stNoble);
        }

        stDest = gsFIAdjustBalance(stDest, -nNobleAmt*x);

    }
    // Update the nation's bank account.
    Trace(CITIZENSHIP, "Adding " + IntToString(nAmount - nDecayAmount) + " to " + sNationID);
    gsFISaveAccount(stDest);
  }
}
//------------------------------------------------------------------------------
int miCZGetTrade(string sNationSupply, string sNationBuy)
{
  Trace(CITIZENSHIP, "Checking whether " + sNationSupply + " is supplying " + sNationBuy);

  object oNation = miCZLoadNation(sNationSupply);
  if (FindSubString(GetLocalString(oNation, VAR_TRADE), ";;" + sNationBuy + ";;") == -1)
  {
    return FALSE;
  }
  return TRUE;
}
//------------------------------------------------------------------------------
void miCZSetTrade(string sNationSupply, string sNationBuy, int bOpen = TRUE)
{
  if (bOpen)
  {
    Trace(CITIZENSHIP, sNationSupply + " will start supplying " + sNationBuy);

    SQLExecStatement("INSERT INTO micz_trade (nation_buy, nation_sell) VALUES (?,?)",
     sNationBuy, sNationSupply);

    object oNation = miCZLoadNation(sNationSupply);
    SetLocalString(oNation, VAR_TRADE, GetLocalString(oNation, VAR_TRADE) + sNationBuy + ";;");
  }
  else
  {
    Trace(CITIZENSHIP, sNationSupply + " will stop supplying " + sNationBuy);

    SQLExecStatement("DELETE FROM micz_trade WHERE nation_buy=? and nation_sell=?",
                     sNationBuy, sNationSupply);
    object oNation = miCZLoadNation(sNationSupply);
    string sTradePartners = GetLocalString(oNation, VAR_TRADE);
    int nIndex = FindSubString(sTradePartners, sNationBuy + ";;");
    sTradePartners = GetSubString(sTradePartners, 0, nIndex) + GetSubString(
     sTradePartners,
     nIndex + GetStringLength(sNationBuy) + 2,
     GetStringLength(sTradePartners) - (nIndex + GetStringLength(sNationBuy) + 2));

    SetLocalString(oNation, VAR_TRADE, sTradePartners);
  }
}
//------------------------------------------------------------------------------
int miCZGetBanished(string sNation, string sBanished)
{
  Trace(CITIZENSHIP, "Checking whether " + sBanished + " is banished from " + sNation);

  object oNation = miCZLoadNation(sNation);
  if (FindSubString(GetLocalString(oNation, VAR_BANISHED), ";;" + sBanished + ";;") == -1)
  {
    return FALSE;
  }
  return TRUE;
}
//------------------------------------------------------------------------------
void miCZSetBanished(string sNation, string sBanished, int bBanned = TRUE)
{
  object oNation  = miCZLoadNation(sNation);
  string sBanList = GetLocalString(oNation, VAR_BANISHED);

  if (bBanned)
  {
    Trace(CITIZENSHIP, sNation + " is banishing " + sBanished);

    SQLExecStatement("INSERT INTO micz_banish (nation, pc_id) VALUES (?,?)",
     sNation, sBanished);

    SetLocalString(oNation, VAR_BANISHED, sBanList + sBanished + ";;");

    // If this is a settlement leader, resign them.
    miCZResign(sBanished, sNation);
  }
  else
  {
    Trace(CITIZENSHIP, sNation + " is un-banishing " + sBanished);

    SQLExecStatement("DELETE FROM micz_banish WHERE nation=? AND pc_id=?",
     sNation, sBanished);

    int nPos = FindSubString(sBanList, ";;" + sBanished + ";;");
    if (nPos != -1)
    {
      SetLocalString(oNation, VAR_BANISHED, GetStringLeft(sBanList, nPos) +
       GetStringRight(sBanList, GetStringLength(sBanList) - nPos - GetStringLength(sBanished) - 2));
    }
  }
}
//------------------------------------------------------------------------------
int miCZGetWar(string sOffense, string sDefense)
{
  Trace(CITIZENSHIP, "Checking whether " + sOffense + " is at war with " + sDefense);

  object oNation = miCZLoadNation(sOffense);
  if (FindSubString(GetLocalString(oNation, VAR_WAR), ";;" + sDefense + ";;") == -1)
  {
    return FALSE;
  }
  return TRUE;
}
//------------------------------------------------------------------------------
void miCZSetWar(string sOffense, string sDefense, int bWar = TRUE)
{
  object oNation = miCZLoadNation(sOffense);
  string sWar    = GetLocalString(oNation, VAR_WAR);

  if (bWar)
  {
    Trace(CITIZENSHIP, sOffense + " is declaring war on " + sDefense);

    SQLExecStatement("INSERT INTO micz_war (nation_agg, nation_def) VALUES (?,?)",
     sOffense, sDefense);

    SetLocalString(oNation, VAR_WAR, sWar + sDefense + ";;");
  }
  else
  {
    Trace(CITIZENSHIP, sOffense + " is making peace with " + sDefense);

    SQLExecStatement("DELETE FROM micz_war WHERE nation_agg=? AND nation_def=?",
     sOffense, sDefense);

    int nPos = FindSubString(sWar, ";;" + sDefense + ";;");
    if (nPos != -1)
    {
      SetLocalString(oNation, VAR_WAR, GetStringLeft(sWar, nPos) +
       GetStringRight(sWar, GetStringLength(sWar) - nPos - GetStringLength(sDefense) - 2));
    }
  }
}
//------------------------------------------------------------------------------
void miCZSetVassal(string sVassal, string sProtectorate = "")
{
  Trace(CITIZENSHIP, sVassal + " is becoming the vassal of " + sProtectorate);

  if (sProtectorate == "")
  {
    SQLExecStatement("UPDATE micz_nations SET master=NULL WHERE id=?", sVassal);
  }
  else
  {
    SQLExecStatement("UPDATE micz_nations SET master=? WHERE id=?",
     sProtectorate, sVassal);
  }

  object oNation = miCZLoadNation(sVassal);
  SetLocalString(oNation, VAR_MASTER, sProtectorate);
}
//------------------------------------------------------------------------------
float miCZGetSettlementBuyPrice(string sNation, string sResource)
{
   object oNation = miCZLoadNation(sNation);
   return (GetLocalFloat(oNation, VAR_BUYPRICE + sResource));
}
//------------------------------------------------------------------------------
float miCZGetSettlementSellPrice(string sNation, string sResource)
{
   object oNation = miCZLoadNation(sNation);
   return (GetLocalFloat(oNation, VAR_SELLPRICE + sResource));
}
//------------------------------------------------------------------------------
int miCZGetSettlementStockpile(string sNation, string sResource)
{
   object oNation = miCZLoadNation(sNation);
   return GetLocalInt(oNation, sResource);
}
//------------------------------------------------------------------------------
void miCZAddtoStockpile(string sNation, string sResource, int nAmount)
{
   object oNation = miCZLoadNation(sNation);

   int nNewValue = GetLocalInt(oNation, sResource) + nAmount;
   SetLocalInt(oNation, sResource, nNewValue);
   miDASetKeyedValue("micz_nations", sNation, GetStringLowerCase(sResource), IntToString(nNewValue));
}
//------------------------------------------------------------------------------
string miCZGetSettlementTradeStatus(string sNation)
{
   object oNation = miCZLoadNation(sNation);

   string sOutput = "\nTrade(stockpile/buy price/sell price):\n  Food: " +
   IntToString(GetLocalInt(oNation, RESOURCE_FOOD)) + "/" +
   gsCMGetAsString(GetLocalFloat(oNation, VAR_BUYPRICE + RESOURCE_FOOD)*100) + "%/" +
   gsCMGetAsString(GetLocalFloat(oNation, VAR_SELLPRICE + RESOURCE_FOOD)*100) + "%\n  Wood: " +
   IntToString(GetLocalInt(oNation, RESOURCE_WOOD)) + "/" +
   gsCMGetAsString(GetLocalFloat(oNation, VAR_BUYPRICE + RESOURCE_WOOD)*100) + "%/" +
   gsCMGetAsString(GetLocalFloat(oNation, VAR_SELLPRICE + RESOURCE_WOOD)*100) + "%\n  Cloth: " +
   IntToString(GetLocalInt(oNation, RESOURCE_CLOTH)) + "/" +
   gsCMGetAsString(GetLocalFloat(oNation, VAR_BUYPRICE + RESOURCE_CLOTH)*100) + "%/" +
   gsCMGetAsString(GetLocalFloat(oNation, VAR_SELLPRICE + RESOURCE_CLOTH)*100) + "%\n  Metal: " +
   IntToString(GetLocalInt(oNation, RESOURCE_METAL)) + "/" +
   gsCMGetAsString(GetLocalFloat(oNation, VAR_BUYPRICE + RESOURCE_METAL)*100) + "%/" +
   gsCMGetAsString(GetLocalFloat(oNation, VAR_SELLPRICE + RESOURCE_METAL)*100) + "%\n  Stone: " +
   IntToString(GetLocalInt(oNation, RESOURCE_STONE)) + "/" +
   gsCMGetAsString(GetLocalFloat(oNation, VAR_BUYPRICE + RESOURCE_STONE)*100) + "%/" +
   gsCMGetAsString(GetLocalFloat(oNation, VAR_SELLPRICE + RESOURCE_STONE)*100) + "%\n";


   SQLExecStatement("SELECT n.name FROM micz_trade AS t INNER JOIN micz_nations " +
    "AS n ON t.nation_buy = n.id WHERE t.nation_sell=?", sNation);

   if (SQLFetch())
   {
     sOutput += "\nSelling to:\n  " + SQLGetData(1) + "\n";

     while (SQLFetch())
     {
       sOutput += "  " + SQLGetData(1) + "\n";
     }
   }

   return sOutput;
}
//------------------------------------------------------------------------------
string miCZGetSettlementStatus(string sNation)
{
   /*
     Settlement of <name>
      Vassal of <name>

     Current <leader/s>:
      <name>
      <name>
     Leadership contest in progress!

     Citizens: <number>

     At war with:
      <name>
      <name>

     Trade (stockpile/buy price/sell price):
      Food: <n>/<n>/</n>
      Wood: <n>/<n>/</n>
      Cloth: <n>/<n>/</n>
      Metal: <n>/<n>/</n>
      Stone: <n>/<n>/</n>

     Trading with:
      <name>
      <name>

     Tax rate: <n>%
     Account balance: <n>
   */
   object oNation = miCZLoadNation(sNation);
   string sOutput = "Settlement of " + GetLocalString(oNation, VAR_NAME) + "\n";

   string sMaster = GetLocalString(oNation, VAR_MASTER);
   if (sMaster == "NONE")
   {
     sOutput += "  Independent\n\n";
   }
   else
   {
     object oMaster = miCZLoadNation(sMaster);
     sOutput += "  Vassal of " + GetLocalString(oMaster, VAR_NAME) + "\n\n";
   }

   SQLExecStatement("SELECT row_key FROM micz_positions WHERE nation=? AND " +
    "master_rank IS NULL", sNation);
   if (SQLFetch())
   {
     sOutput += "Current " + SQLGetData(1) + ":\n";
   }

   SQLExecStatement("SELECT t3.name, t4.name FROM micz_positions AS t1 INNER JOIN " +
    "micz_rank AS t2 ON t2.rank_id = t1.rank_id INNER JOIN gs_pc_data AS t3 ON " +
    "t2.pc_id = t3.id LEFT JOIN md_fa_factions AS t4 ON t4.id=t2.fac_id WHERE t1.nation=? AND t1.master_rank IS NULL", sNation);
   while (SQLFetch())
   {
     sOutput += "  " + SQLGetData(1) + " of " + SQLGetData(2) + "\n";
   }



   if (_miCZIsElectionInProgress(sNation)) sOutput += "Leadership challenge in progress!\n";
   else
   {
    SQLExecStatement("SELECT f.name FROM micz_votes AS v INNER JOIN md_fa_factions AS f ON f.id=v.fac_id WHERE v.nation=? ORDER BY " +
    "votes DESC LIMIT 1, 3", sNation);

    sOutput += "\nInfluential Factions:\n";
    while(SQLFetch())
    {
     sOutput += "  " + SQLGetData(1) + "\n";
    }

   }

   sOutput += "\nNumber of supporters: " + IntToString(miCZGetCitizenCount(sNation)) + "\n";

   SQLExecStatement("SELECT n.name FROM micz_war AS w INNER JOIN micz_nations " +
    "AS n ON w.nation_def = n.id WHERE w.nation_agg=?", sNation);

   if (SQLFetch())
   {
     sOutput += "\nAt war with:\n  " + SQLGetData(1) + "\n";

     while (SQLFetch())
     {
       sOutput += "  " + SQLGetData(1) + "\n";
     }
   }

   sOutput += miCZGetSettlementTradeStatus(sNation);

  sOutput += "\nTax rate: " + gsCMGetAsString(GetLocalFloat(oNation, VAR_TAX) * 100) + "%";
  sOutput += "\nTreasury: " + IntToString(gsFIGetAccountBalance("N" + sNation)) + "gp";

  sNation = miCZGetName(sNation);
  string sFactionID = GetLocalString(GetModule(), "MD_FA_"+sNation);
  object oCache = miDAGetCacheObject("FAC"+sFactionID);
  int nMax = GetLocalInt(oCache, "MD_FA_RANK");
  int nCount;
  string sRank;
  string sRankName;
  string sMember;
  int nMemC;
  for(nCount = 1; nCount <= nMax; nCount++)
  {
    sRank = GetLocalString(oCache, "MD_FA_RANK_"+IntToString(nCount));
    sRankName = GetLocalString(oCache, "MD_FA_RANK_R"+sRank);
    if(sRank != "Unranked" || sRank != "Rank Removed")
    {
      sOutput += "\n\nHead(s) of division " + sRankName + ": ";
      sMember = GetLocalString(oCache, "MD_FA_R"+sRank+"_"+"1");
      nMemC = 1;
      while(sMember != "")
      {
        if(sMember != "REMOVED")
          sOutput += gsPCGetPlayerName(sMember) + ", ";
        nMemC++;
        sMember = GetLocalString(oCache, "MD_FA_R"+sRank+"_"+IntToString(nMemC));
      }
    }
  }
  return sOutput;
}

//------------------------------------------------------------------------------
int miCZGetCanTrade(object oPC, string sNation)
{
  object oNation = miCZLoadNation(sNation);
  string sPCNation = GetLocalString(oPC, VAR_NATION);

  if (sPCNation == sNation) return TRUE;
  if (FindSubString(GetLocalString(oNation, VAR_TRADE), ";;" + sPCNation + ";;") != -1) return TRUE;
  return FALSE;
}
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
void miCZResign(string sLeaderID, string sNation)
{
  Trace(CITIZENSHIP, sLeaderID + " is resigning as leader of " + sNation);
  object oNation = miCZLoadNation(sNation);
  //Mord-edit. Fixed a bug. If you were exileing a foreign leader with the same holder_id as one of your leaders
  //then that settlement leader was being removed from the cache.
  SQLExecStatement("SELECT rank.holder_id FROM micz_rank AS rank INNER JOIN micz_positions " +
                   "AS pos ON rank.rank_id = pos.rank_id WHERE pc_id=? AND nation=?", sLeaderID, sNation);
  SQLFetch();
  DeleteLocalString(oNation, VAR_CURRENT_LEADER + SQLGetData(1));
  DeleteLocalInt(oNation, VAR_CURRENT_LEADER_TIME + SQLGetData(1));
  //Resigning no longer removes member
  //SQLExecStatement("DELETE Mem FROM md_fa_members AS Mem INNER JOIN md_fa_factions AS Fac  ON Mem.faction_Id = Fac.id WHERE Fac.nation=? AND Mem.pc_id=?", sNation, sLeaderID);
  //_RemoveNationPowersFromCache(sNation, sLeaderID);
  // May hold multiple ranks. @@@ TODO
  SQLExecStatement("DELETE rank FROM micz_rank AS rank INNER JOIN micz_positions " +
  "AS pos ON rank.rank_id = pos.rank_id WHERE pc_id=? AND nation=?", sLeaderID, sNation);

}
//------------------------------------------------------------------------------
void miCZDoBankrupcy(string sNation)
{
  Trace(CITIZENSHIP, "Nation " + sNation + " is bankrupt!");
  object oNation = miCZLoadNation(sNation);

  // Remove all exiles
  SQLExecStatement("DELETE FROM micz_banish WHERE nation=?", sNation);

  // Find the leader rank
  SQLExecStatement("SELECT rank_id FROM micz_positions WHERE nation=?", sNation);
  SQLFetch();
  string sRank = SQLGetData(1);

  // Remove all leaders
  SQLExecStatement("SELECT holder_id FROM micz_rank WHERE rank_id=?", sRank);

  while (SQLFetch())
  {
    DeleteLocalString(oNation, VAR_CURRENT_LEADER + SQLGetData(1));
    DeleteLocalInt(oNation, VAR_CURRENT_LEADER_TIME + SQLGetData(1));
  }
  //Compliance with landed nobles
 /* SQLExecStatement("SELECT Mem.pc_id FROM md_fa_members AS Mem INNER JOIN md_fa_factions AS Fac ON Mem.faction_id = Fac.id INNER JOIN micz_rank AS Rank ON Rank.pc_id = Mem.pc_id WHERE Fac.nation=? AND Rank.rank_id=? GROUP BY Mem.pc_id", sNation, sRank);
  while(SQLFetch())
  {
    _RemoveNationPowersFromCache(sNation, SQLGetData(1));
  }
  SQLExecStatement("DELETE Mem FROM md_fa_members AS Mem INNER JOIN md_fa_factions AS Fac ON Mem.faction_id = Fac.id INNER JOIN micz_rank AS Rank ON Rank.pc_id = Mem.pc_id WHERE Fac.nation=? AND Rank.ranK_id=?", sNation, sRank); */
  SQLExecStatement("DELETE FROM micz_rank WHERE rank_id=?", sRank);

  // Notify the citizenry.
  miCZNotifyAllCitizens(sNation, "Your settlement has gone bankrupt.");
}
//------------------------------------------------------------------------------
int mdCZGetExileCount(string sNation)
{
    SQLExecStatement("SELECT COUNT(pc_id) FROM micz_banish WHERE nation=?", sNation);
    if(SQLFetch())
    {
        return StringToInt(SQLGetData(1));
    }

    return 0;
}
//------------------------------------------------------------------------------
struct Service mdCZYearlyResourceCost(string sNation)
{
    int nBase = mdCZGetExileCount(sNation) * NEED_PER_EXILE;
    int nService = StringToInt(miDAGetKeyedValue("micz_nations", sNation, "services"));
    struct Service ResCost;
    ResCost.nFood = nBase;
    ResCost.nWood = nBase;
    ResCost.nCloth = nBase;
    ResCost.nStone = nBase;
    ResCost.nMetal = nBase;
    if(nService & MD_SV_EXPWH)
    {
        struct Service Exp = GetService(MD_SV_EXPWH);
        ResCost.nFood += Exp.nFood;
        ResCost.nWood += Exp.nWood;
        ResCost.nCloth += Exp.nCloth;
        ResCost.nStone += Exp.nStone;
        ResCost.nMetal += Exp.nMetal;
    }

    int x=0;
    string sTag;
    struct Service Upkeep;
    SQLExecStatement("SELECT service FROM landbroker WHERE nation_id=?", sNation);


     while(SQLFetch())
     {
       nService =  StringToInt(SQLGetData(1));
       if(nService & SVC_UPKEEP_HIGH)
         Upkeep = GetService(SVC_UPKEEP_HIGH);
       else if(nService & SVC_UPKEEP_MED)
         Upkeep = GetService(SVC_UPKEEP_MED);
       else
         Upkeep = GetService(SVC_UPKEEP_LOW);


       ResCost.nFood += Upkeep.nFood;
       ResCost.nWood += Upkeep.nWood;
       ResCost.nCloth += Upkeep.nCloth;
       ResCost.nStone += Upkeep.nStone;
       ResCost.nMetal += Upkeep.nMetal;

     }

    return ResCost;
}

int _ModifyCost(int nResource, int nPrior)
{
    nResource -= nPrior;
    if(nResource < 0)
        nResource = 0;

   return nResource;
}
//--------------------------------------------------------------------------------
int EnableService(int nService, string sNationID, object oPC, string sAreaID="")
{
  int nOldService;
  struct Service PriorService;
  if(sAreaID != "")
  {
    SQLExecStatement("SELECT service FROM landbroker WHERE area_id=?", sAreaID);
    SQLFetch();
    nOldService = StringToInt(SQLGetData(1));
    PriorService = GetService(nOldService);
  }
  struct Service Ext = GetService(nService);
  struct Service YearlyCost = mdCZYearlyResourceCost(sNationID);

  Ext.nCloth = _ModifyCost(Ext.nCloth, PriorService.nCloth);

  Ext.nFood = _ModifyCost(Ext.nFood, PriorService.nFood);
  Ext.nMetal = _ModifyCost(Ext.nMetal, PriorService.nMetal);
  Ext.nStone = _ModifyCost(Ext.nStone, PriorService.nStone);
  Ext.nWood = _ModifyCost(Ext.nWood, PriorService.nWood);
  if(miCZGetSettlementStockpile(sNationID, RESOURCE_CLOTH) > Ext.nCloth* 2 + YearlyCost.nCloth &&
     miCZGetSettlementStockpile(sNationID, RESOURCE_FOOD) > Ext.nFood * 2 + YearlyCost.nFood  &&
     miCZGetSettlementStockpile(sNationID, RESOURCE_METAL) > Ext.nMetal * 2 + YearlyCost.nMetal &&
     miCZGetSettlementStockpile(sNationID, RESOURCE_STONE) > Ext.nStone * 2 + YearlyCost.nStone &&
     miCZGetSettlementStockpile(sNationID, RESOURCE_WOOD) > Ext.nWood * 2 + YearlyCost.nWood)
  {
     if(sAreaID != "")
        SQLExecStatement("UPDATE landbroker SET service=? WHERE area_id=?", IntToString(nService), sAreaID);
     else
       SQLExecStatement("UPDATE micz_nations SET services = services | ? WHERE id=?", IntToString(nService), sNationID);

     if(Ext.nFood>0)
       miCZAddtoStockpile(sNationID, RESOURCE_FOOD, -1*Ext.nFood);
     if(Ext.nCloth)
       miCZAddtoStockpile(sNationID, RESOURCE_CLOTH, -1*Ext.nCloth);
     if(Ext.nMetal)
       miCZAddtoStockpile(sNationID, RESOURCE_METAL, -1*Ext.nMetal);
     if(Ext.nStone)
       miCZAddtoStockpile(sNationID, RESOURCE_STONE, -1*Ext.nStone);
     if(Ext.nWood)
       miCZAddtoStockpile(sNationID, RESOURCE_WOOD, -1*Ext.nWood);

  }
  else
  {
     SendMessageToPC(oPC, "You do not have enough resources to enable the service.");
     return FALSE;
  }

  return TRUE;
}
//void main() {}
