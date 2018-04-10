/* WORSHIP Library by Gigaschatten */

#include "gs_inc_state"
#include "gs_inc_xp"

const int ASPECT_WAR_DESTRUCTION     = 1;
const int ASPECT_HEARTH_HOME         = 2;
const int ASPECT_KNOWLEDGE_INVENTION = 4;
const int ASPECT_TRICKERY_DECEIT     = 8;
const int ASPECT_NATURE              = 16;
const int ASPECT_MAGIC               = 32;

const int FB_WO_CATEGORY_MAJOR        = 1;
const int FB_WO_CATEGORY_INTERMEDIATE = 2;
const int FB_WO_CATEGORY_LESSER       = 3;
const int FB_WO_CATEGORY_DEMIGOD      = 4;
const int FB_WO_CATEGORY_PLANAR       = 5;
const int FB_WO_CATEGORY_ARELITH      = 6;

const int GS_WO_NONE = -1;

// The script compiler has a limitation on constants.
// Soooo . . . we're just not going to add any constants.
// Make sure to add one here and comment it out, then fill in the required stuff below.
// If you want to improve this in the future and have way more time than I do, consider
// porting this logic to a 2da file or to the mysql database.

//const int GS_WO_AKADI                =     1;
//const int GS_WO_AURIL                =     2;
//const int GS_WO_AZUTH                =     3;
//const int GS_WO_BANE                 =     4;
//const int GS_WO_BESHABA              =     5;
//const int GS_WO_CHAUNTEA             =     6;
//const int GS_WO_CYRIC                =     7;
//const int GS_WO_DENEIR               =     8;
//const int GS_WO_EILISTRAEE           =     9;
//const int GS_WO_ELDATH               =    10;
//const int GS_WO_FINDER_WYVERNSPUR    =    11;
//const int GS_WO_GARAGOS              =    12;
//const int GS_WO_GARGAUTH             =    13;
//const int GS_WO_GOND                 =    14;
//const int GS_WO_GRUMBAR              =    15;
//const int GS_WO_GWAERON_WINDSTROM    =    16;
//const int GS_WO_HELM                 =    17;
//const int GS_WO_HOAR                 =    18;
//const int GS_WO_ILMATER              =    19;
//const int GS_WO_ISTISHIA             =    20;
//const int GS_WO_JERGAL               =    21;
//const int GS_WO_KELEMVOR             =    22;
//const int GS_WO_KOSSUTH              =    23;
//const int GS_WO_LATHANDER            =    24;
//const int GS_WO_LLIIRA               =    25;
//const int GS_WO_LOLTH                =    26;
//const int GS_WO_LOVIATAR             =    27;
//const int GS_WO_LURUE                =    28;
//const int GS_WO_MALAR                =    29;
//const int GS_WO_MASK                 =    30;
//const int GS_WO_MIELIKKI             =    31;
//const int GS_WO_MILIL                =    32;
//const int GS_WO_MYSTRA               =    33;
//const int GS_WO_NOBANION             =    34;
//const int GS_WO_OGHMA                =    35;
//const int GS_WO_RED_KNIGHT           =    36;
//const int GS_WO_SAVRAS               =    37;
//const int GS_WO_SELUNE               =    38;
//const int GS_WO_SHAR                 =    39;
//const int GS_WO_SHARESS              =    40;
//const int GS_WO_SHAUNDAKUL           =    41;
//const int GS_WO_SHIALLIA             =    42;
//const int GS_WO_SIAMORPHE            =    43;
//const int GS_WO_SILVANUS             =    44;
//const int GS_WO_SUNE                 =    45;
//const int GS_WO_TALONA               =    46;
//const int GS_WO_TALOS                =    47;
//const int GS_WO_TEMPUS               =    48;
//const int GS_WO_TIAMAT               =    49;
//const int GS_WO_TORM                 =    50;
//const int GS_WO_TYMORA               =    51;
//const int GS_WO_TYR                  =    52;
//const int GS_WO_UBTAO                =    53;
//const int GS_WO_ULUTIU               =    54;
//const int GS_WO_UMBERLEE             =    55;
//const int GS_WO_UTHGAR               =    56;
//const int GS_WO_VALKUR               =    57;
//const int GS_WO_VELSHAROON           =    58;
//const int GS_WO_WAUKEEN              =    59;
//const int GS_WO_MORADIN              =    60;
//const int GS_WO_CORELLON             =    61;
//const int GS_WO_GARL                 =    62;
//const int GS_WO_YONDALLA             =    63;
//const int GS_WO_ANGHARRADH           =    64;
//const int GS_WO_HORUS                =    65;
//const int GS_WO_GRUUMSH              =    66;
//const int GS_WO_MAGLUBIYET           =    67;
//const int GS_WO_TITANIA              =    68;
//const int GS_WO_ABBATHOR             =    69;
//const int GS_WO_BERRONAR             =    70;
//const int GS_WO_CLANGEDDIN           =    71;
//const int GS_WO_DUMATHOIN            =    72;
//const int GS_WO_LADUGUER             =    73;
//const int GS_WO_SHARINDLAR           =    74;
//const int GS_WO_VERGADAIN            =    75;
//const int GS_WO_AERDRIE              =    76;
//const int GS_WO_DEEP_SASHELAS        =    77;
//const int GS_WO_EREVAN               =    78;
//const int GS_WO_HANALI               =    79;
//const int GS_WO_LABELAS              =    80;
//const int GS_WO_RILLIFANE            =    81;
//const int GS_WO_SEHANINE             =    82;
//const int GS_WO_SOLONOR              =    83;
//const int GS_WO_BAERVAN              =    84;
//const int GS_WO_CALLARDURAN          =    85;
//const int GS_WO_FLANDAL              =    86;
//const int GS_WO_SEGOJAN              =    87;
//const int GS_WO_URDLEN               =    88;
//const int GS_WO_ARVOREEN             =    89;
//const int GS_WO_CYRROLLALEE          =    90;
//const int GS_WO_SHEELA               =    91;
//const int GS_WO_DALLAH_THAUN         =    92;
//const int GS_WO_ISIS                 =    93;
//const int GS_WO_NEPHTHYS             =    94;
//const int GS_WO_OSIRIS               =    95;
//const int GS_WO_SET                  =    96;
//const int GS_WO_THOTH                =    97;
//const int GS_WO_NATHAIR              =    98;
//const int GS_WO_QUEEN                =    99;
//const int GS_WO_GHAUNADAUR           =    101;
//const int GS_WO_VHAERAUN             =    102;
//const int GS_WO_DUGMAREN             =    103;
//const int GS_WO_GORM                 =    104;
//const int GS_WO_MARTHAMMOR           =    105;
//const int GS_WO_THARD                =    106;
//const int GS_WO_FENMAREL             =    107;
//const int GS_WO_BARAVAR              =    108;
//const int GS_WO_GAERDAL              =    109;
//const int GS_WO_BRANDOBARIS          =    110;
//const int GS_WO_ANHUR                =    111;
//const int GS_WO_GEB                  =    112;
//const int GS_WO_HATHOR               =    113;
//const int GS_WO_BAHGTRU              =    114;
//const int GS_WO_ILNEVAL              =    115;
//const int GS_WO_LUTHIC               =    116;
//const int GS_WO_SHARGAAS             =    117;
//const int GS_WO_YURTRUS              =    118;
//const int GS_WO_OOGOOBOOGOO          =    119;
//const int GS_WO_BARGRIVYEK           =    120;
//const int GS_WO_KHURGORBAEYAG        =    121;
//const int GS_WO_KIKANUTI             =    122;
//const int GS_WO_OBERON               =    123;
//const int GS_WO_VERENESTRA           =    124;
//const int GS_WO_KIARANSALEE          =    125;
//const int GS_WO_SELVETARM            =    126;
//const int GS_WO_DEEP_DUERRA          =    127;
//const int GS_WO_HAELA                =    128;
//const int GS_WO_SHEVARASH            =    129;
//const int GS_WO_UROGALAN             =    130;
//const int GS_WO_SEBEK                =    131;
//const int GS_WO_YEENOGHU             =    132;
//const int GS_WO_GORELLIK             =    133;
//const int GS_WO_ZINZERENA            =    134;
//const int GS_WO_GAKNULAK             =    135;
//const int GS_WO_NATURE               =    136;
//const int GS_WO_BAHAMUT              =    137;
//const int GS_WO_LALASKRA             =    138;
//const int GS_WO_ZARUS                =    139;
//const int GS_WO_BEL                  =    140;
//const int GS_WO_DISPATER             =    141;
//const int GS_WO_MAMMON               =    142;
//const int GS_WO_FIERNA               =    143;
//const int GS_WO_LEVISTUS             =    144;
//const int GS_WO_GLASYA               =    145;
//const int GS_WO_BAALZEBUL            =    146;
//const int GS_WO_MEPHISTOPHELES       =    147;
//const int GS_WO_ASMODEUS             =    148;
//const int GS_WO_ABYSSMAGIC           =    149;
//const int GS_WO_ABYSSWAR             =    150;
//const int GS_WO_ABYSSTRICKERY        =    151;
//const int GS_WO_VAPRAK               =    152;
//const int GS_WO_KURTULMAK            =    153;
//const int GS_WO_BHAAL                =    154;

string gsWOGetPortfolio(int nDeity)
{
  string sPortfolio = "";

  switch (nDeity)
  {
    case 1   : sPortfolio = "Akadi\nQueen of Air, the Lady of Air, Lady of the Winds\n\nSymbol: White cloud on blue background\nAlignment: Neutral\nPortfolio: Elemental air, movement, speed, flying creatures\nWorshipers: Animal breeders, elemental archons (air), rangers, rogues, sailors"; break;
    case 2   : sPortfolio = "Auril\nFrostmaiden, Icedawn, the Cold Goddess\n\nSymbol: A white snowflake on a gray diamond (a heraldic lozenge) with a white border\nAlignment: Neutral evil\nPortfolio: Cold, winter\nWorshipers: Druids, elemental archons (air or water), frost giants, inhabitants of cold climates, rangers"; break;
    case 3   : sPortfolio = "Azuth\nThe High One, Patron of Mages, Lord of Spells\n\nSymbol: Human left hand pointing upward outlined in blue fire\nAlignment: Lawful neutral\nPortfolio: Wizards, mages, spellcasters in general, monks (Shining Hand)\nWorshipers: Philosophers, sages, sorcerers, wizards"; break;
    case 4   : sPortfolio = "Bane\nThe Black Lord, The Black Hand, Lord of Darkness\n\nSymbol: Green rays squeezed forth from a black fist\nAlignment: Lawful evil\nPortfolio: Strife, hatred, tyranny, fear\nWorshipers: Conquerors, evil fighters and monks, tyrants, wizards"; break;
    case 5   : sPortfolio = "Beshaba\nThe Maid of Misfortune, Lady Doom\n\nSymbol: Black antlers on a red field\nAlignment: Chaotic evil\nPortfolio: Random mischief, misfortune, bad luck, accidents\nWorshipers: Assassins, auspicians, capricious individuals, gamblers, rogues, sadists"; break;
    case 6   : sPortfolio = "Chauntea\nThe Great Mother, Grain Goddess, Earth Mother\n\nSymbol: Blooming rose on a sunburst wreath of golden grain\nAlignment: Neutral good\nPortfolio: Agriculture, plants cultivated by humans, farmers, gardeners, summer\nWorhipers: Peasants and indentured servants, druids, farmers, gardeners"; break;
    case 7   : sPortfolio = "Cyric\nPrince of Lies, the Dark Sun, the Black Sun\n\nSymbol: White jawless skull on black or purple sunburst\nAlignment: Chaotic evil\nPortfolio: Murder, lies, intrigue, deception, illusion\nWorshipers: Former worshipers of Bane, Bhaal, and Myrkul, power-hungry (primarily young) humans"; break;
    case 8   : sPortfolio = "Deneir\nLord of All Glyphs and Images, the Scribe of Oghma\n\nSymbol: Lit candle above purple eye with triangular pupil\nAlignment: Neutral good\nPortfolio: Glyphs, images, literature, scribes, cartography\nWorshipers: Historians, loremasters, sages, scholars, scribes, seekers of enlightenment, students"; break;
    case 9   : sPortfolio = "Eilistraee\nThe Dark Maiden, Lady of the Dance\n\nSymbol: Nude long-haired female drow dancing with a silver bastard sword in front of a full moon\nAlignment: Chaotic good\nPortfolio: Song, beauty, dance, swordwork, hunting, moonlight\nWorshipers: Good-aligned drow, hunters, surface-dwelling elves"; break;
    case 10  : sPortfolio = "Eldath\nGoddess of Singing Waters, Mother Guardian of Groves, the Green Goddess\n\nSymbol: Waterfall plunging into a still pool\nAlignment: Neutral good\nPortfolio: Quiet places, springs, pools, peace, waterfalls\nWorshipers: Druids, pacifists, rangers"; break;
    case 11  : sPortfolio = "Finder Wyvernspur\nThe Nameless Bard\n\nSymbol: White harp on gray circle\nAlignment: Chaotic neutral\nPortfolio: Cycle of life, transformation of art, saurials\nWorshipers: Artists, bards, saurials"; break;
    case 12  : sPortfolio = "Garagos\nThe Reaver, Master of All Weapons, Lord of War\n\nSymbol: A pinwheel of five snaky arms cluthing swords\nAlignment: Chaotic neutral\nPortfolio: War, skill-at-arms, destruction, plunder\nWorshipers: Barbarians, fighters, rangers, soldiers, spies, warriors"; break;
    case 13  : sPortfolio = "Gargauth\nThe Tenth Lord of Nine, the Lost Lord of the Pit, the Hidden Lord\n\nSymbol: Broken animal horn\nAlignment: Lawful evil\nPortfolio: Betrayal, cruelty, political corruption, powerbrokers\nWorshipers: Corrupt leaders and politicians, sorcerers, traitors"; break;
    case 14  : sPortfolio = "Gond\nWonderbringer, Lord of All Smiths\n\nSymbol: A toothed metal, bone, or wood cog with four spokes\nAlignment: Neutral\nPortfolio: Artifice, craft, construction, smithwork\nWorshipers: Blacksmiths, crafters, engineers, gnomes, inventors, Lantanese, woodworkers/n(By Gnomes, he is known and worshipped as Nebelun)"; break;
    case 15  : sPortfolio = "Grumbar\nEarthlord, King of the Land Below the Roots\n\nSymbol: Mountains on purple\nAlignment: Neutral\nPortfolio: Elemental earth, solidity, changelessness, oaths\nWorshipers: Elemental archons (earth), fighters, monks, rangers"; break;
    case 16  : sPortfolio = "Gwaeron Windstrom\nMaster of Tracking, the Tracker Who Never Goes Astray\n\nSymbol: White star and brown pawprint\nAlignment: Neutral good\nPortfolio: Tracking, rangers of the North\nWorshipers: Druids, rangers, troll hunters"; break;
    case 17  : sPortfolio = "Helm\nThe Watcher, the Vigilant One\n\nSymbol: Staring eye with blue pupil on an upright war gauntlet\nAlignment: Lawful neutral\nPortfolio: Guardians, protectors, protection\nWorshipers: Explorers, fighters, guards, mercenaries, paladins"; break;
    case 18  : sPortfolio = "Hoar\nThe Doombringer, Lord of Three Thunders\n\nSymbol: Black-gloved hand holding a coin with a two-faced head\nAlignment: Lawful neutral\nPortfolio: Revenge, retribution, poetic justice\nWorshipers: Assassins, fighters, rogues, seekers of retribution"; break;
    case 19  : sPortfolio = "Ilmater\nThe Crying God, the Broken God\n\nSymbol: Pair of white hands bound at the wrist with a red cord\nAlignment: Lawful good\nPortfolio: Endurance, suffering, martyrdom, perseverance\nWorshipers: The lame, the oppressed, the poor, monks, paladins, serfs, slaves"; break;
    case 20  : sPortfolio = "Istishia\nThe Water Lord, King of the Water Elementals\n\nSymbol: Cresting wave\nAlignment: Neutral\nPortfolio: Elemental water, purification\nWorshipers: Bards, elemental archons (water), sailors, travelers"; break;
    case 21  : sPortfolio = "Jergal\nLord of the End of Everything, Scribe of the Doomed, the Pitiless One\n\nSymbol: Jawless skull and writing quill on scroll\nAlignment: Lawful neutral\nPortfolio: Fatalism, proper burial, guardian of tombs\nWorshipers: Monks, necromancers, paladins"; break;
    case 22  : sPortfolio = "Kelemvor\nLord of the Dead, Judge of the Damned\n\nSymbol: Upright skeletal arm holding the golden scales of justice\nAlignment: Lawful neutral\nPortfolio: Death, the dead\nWorshipers: The dying, families of the dying, gravediggers, hunters of the undead, morticians, mourners"; break;
    case 23  : sPortfolio = "Kossuth\nThe Lord of Flames, the Firelord\n\nSymbol: A twining red flame\nAlignment: Neutral\nPortfolio: Elemental fire, purification through fire\nWorshipers: Druids, elemental archons, fire creatures, Thayans"; break;
    case 24  : sPortfolio = "Lathander\nThe Morninglord\n\nSymbol: Sunrise made of rose, red, and yellow gems\nAlignment: Neutral good\nPortfolio: Athletics, birth, creativity, dawn, renewal, self-perfection, spring, vitality, youth\nWorshipers: Aristocrats, artists, athletes, merchants, monks (Sun Soul), the young"; break;
    case 25  : sPortfolio = "Lliira\nOur Lady of Joy, Joybringer, Mistress of the Revels\n\nSymbol: A triangle of three six-pointed stars (orange, yellow, red)\nAlignment: Chaotic good\nPortfolio: Joy, happiness, dance, festivals, freedom, liberty\nWorshipers: Bards, dancers, entertainers, poets, revelers, singers"; break;
    case 26  : sPortfolio = "Lolth\nQueen of Spiders, Queen of the Demonweb Pits\n\nSymbol: Black spider with female drow head hanging from a spider web\nAlignment: Chaotic evil\nPortfolio: Assassins, chaos, darkness, drow, evil, spiders\nWorshipers: Drow and depraved elves, sentient spiders"; break;
    case 27  : sPortfolio = "Loviatar\nMaiden of Pain, the Willing Whip\n\nSymbol: Nine-tailed barbed scourge\nAlignment: Lawful evil\nPortfolio: Pain, hurt, agony, torment, suffering, torture\nWorshipers: Beguilers, torturers, evil warriors, the depraved"; break;
    case 28  : sPortfolio = "Lurue\nThe Unicorn, the Unicorn Queen, the Queen of Talking Beasts\n\nSymbol: Silver-horned unicorn head before a crescent moon\nAlignment: Chaotic good\nPortfolio: Talking beasts, intelligent nonhumanoid creatures\nWorshipers: Druids, entertainers, outcasts, rangers, travelers, unicorn riders"; break;
    case 29  : sPortfolio = "Malar\nThe Beastlord, the Black-Blooded Pard\n\nSymbol: Bestial claw with brown fur and curving bloody talons\nAlignment: Chaotic evil\nPortfolio: Bloodlust, evil lycanthropes, hunters, marauding beasts and monsters, stalking\nWorshipers: Hunters, evil lycanthropes, sentient carnivores, rangers, druids"; break;
    case 30  : sPortfolio = "Mask\nMaster of All Thieves, Lord of Shadows\n\nSymbol: Black velvet mask tinged with red\nAlignment: Neutral evil\nPortfolio: Shadows, thievery, thieves\nWorshipers: Assassins, beggars, criminals, rogues, shades, shadowdancers"; break;
    case 31  : sPortfolio = "Mielikki\nOur Lady of the Forest, the Forest Queen\n\nSymbol: Gold-horned, blue-eyed unicorn's head facing left\nAlignment: Neutral good\nPortfolio: Autumn, dryads, forest creatures, forests, rangers\nWorshipers: Druids, fey creatures, foresters, rangers"; break;
    case 32  : sPortfolio = "Milil\nLord of Song, the One True Hand of All-Wise Oghma\n\nSymbol: Five-caseed harp made of silver leaves\nAlignment: Neutral good\nPortfolio: Poetry, song, eloquence\nWorshipers: Adventurers, bards, entertainers"; break;
    case 33  : sPortfolio = "Mystra\nThe Lady of Mysteries, the Mother of All Magic\n\nSymbol: Circle of seven blue-white stars with red mist flowing from the center\nAlignment: Neutral good\nPortfolio: Magic, spells, the Weave\nWorshipers: Elves, half-elves, incantatrixes, mystic wanderers, sorcerers, spelldancers, spellfire channelers, wizards"; break;
    case 34  : sPortfolio = "Nobanion\nLord Firemane, King of the Beasts\n\nSymbol: Male lion's head on a green shield\nAlignment: Lawful good\nPortfolio: Royalty, lions and feline beasts, good beasts\nWorshipers: Druids, fighters, leaders, paladins, rangers, soldiers, teachers, wemics"; break;
    case 35  : sPortfolio = "Oghma\nThe Lord of Knowledge, Binder of What is Known\n\nSymbol: Blank scroll\nAlignment: Neutral\nPortfolio: bards, inspiration, invention, knowledge\nWorshipers: Artists, bards, cartographers, inventors, loremasters, sages, scholars, scribes, wizards"; break;
    case 36  : sPortfolio = "Red Knight\nLady of Strategy, Grandmaster of the Lanceboard\n\nSymbol: Red knight chess piece with stars for eyes\nAlignment: Lawful neutral\nPortfolio: Strategy, planning, tactics\nWorshipers: Fighters, gamesters, monks, strategists, tacticians"; break;
    case 37  : sPortfolio = "Savras\nThe All-Seeing, Lord of Divination, He of the Third Eye\n\nSymbol: Crystal ball containing many kinds of eyes\nAlignment: Lawful neutral\nPortfolio: Divination, fate, truth\nWorshipers: Diviners, judges, monks, seekers of truth, spellcasters"; break;
    case 38  : sPortfolio = "Selune\nOur Lady of Silver, the Moonmaiden\n\nSymbol:  Pair of female eyes surrounded by seven silver stars\nAlignment: Chaotic good\nPortfolio: Good and neutral lycanthropes, moon, navigation, questers, stars, wanderers\nWorshipers: Female spellcasters, good and neutral lycanthropes, navigators, monks (Sun Soul), sailors"; break;
    case 39  : sPortfolio = "Shar\nMistress of the Night, Lady of Loss, Dark Goddess\n\nSymbol: Black disk with deep purple border\nAlignment: Neutral evil\nPortfolio: Caverns, dark, dungeons, forgetfulness, loss, night, secrets, the Underdark\nWorshipers: Anarchists, assassins, avengers, monks (Dark Moon), nihilists, rogues, shadow adepts, shadowdancers"; break;
    case 40  : sPortfolio = "Sharess\nThe Dancing Lady, Mother of Cats\n\nSymbol: Feminine lips\nAlignment: Chaotic good\nPortfolio: Hedonism, sensual fulfillment, festhalls, cats\nWorshipers: Bards, hedonists, sensualists"; break;
    case 41  : sPortfolio = "Shaundakul\nRider of the Winds, the Helping Hand\n\nSymbol: A wind-walking bearded man in traveler's cape and boots\nAlignment: Chaotic neutral\nPortfolio: Travel, exploration, portals, miners, caravans\nWorshipers: Explorers, caravaneers, rangers, portal-walkers, half-elves"; break;
    case 42  : sPortfolio = "Shiallia\nDancer in the Glades, Daughter of the High Forest, the Lady of the Woods\n\nSymbol: Golden acorn\nAlignment: Neutral good\nPortfolio: Woodland glades, woodland fertility, growth, the High Forest, Neverwinter Wood\nWorshipers: Druids, farmers, foresters, gardeners, nuptial couples"; break;
    case 43  : sPortfolio = "Siamorphe\nThe Divine Right\n\nSymbol: Silver chalice with a golden sun on the side\nAlignment: Lawful neutral\nPortfolio: Nobles, rightful rule of nobility, human royalty\nWorshipers: Leaders, loremasters, nobles, those with inherited wealth or status"; break;
    case 44  : sPortfolio = "Silvanus\nOak Father, the Forest Father, Treefather\n\nSymbol: Green living oak leaf\nAlignment: Neutral\nPortfolio: Wild nature, druids\nWorshipers: Druids, woodsmen, wood elves"; break;
    case 45  : sPortfolio = "Sune\nFirehair, Lady Firehair\n\nSymbol: Face of a red-haired, ivory-skinned beautiful woman\nAlignment: Chaotic good\nPortfolio: Beauty, love, passion\nWorshipers: Lovers, artists, half-elves, adventurers"; break;
    case 46  : sPortfolio = "Talona\nLady of Poison, Mistress of Disease, Mother of All Plagues\n\nSymbol: Three amber teardrops on a purple triangle\nAlignment: Chaotic evil\nPortfolio: Disease, poison\nWorshipers: Assassins, druids, healers, rogues, those suffering from disease and illness"; break;
    case 47  : sPortfolio = "Talos\nThe Destroyer, the Storm Lord\n\nSymbol: An explosive lightning strike\nAlignment: Chaotic evil\nPortfolio: Storms, destruction, rebellion, conflagration, earthquakes, vortices\nWorshipers: Those who fear the destructive power of nature, barbarians, fighters, druids, half-orcs"; break;
    case 48  : sPortfolio = "Tempus\nLord of Battles, Foehammer\n\nSymbol: A blazing silver sword on a blood-red shield\nAlignment: Chaotic neutral\nPortfolio: War, battle, warriors\nWorshipers: Warriors, fighters, barbarians, rangers, half-orcs"; break;
    case 49  : sPortfolio = "Tiamat\nThe Dragon Queen, Nemesis of the Gods, the Dark Lady\n\nSymbol: Five-headed dragon\nAlignment: Lawful evil\nPortfolio: Evil dragons, evil reptiles, greed, Chessenta\nWorshipers: Chromatic dragons, Cult of the Dragon, evil dragons, evil reptiles, fighters, sorcerers, thieves, vandals"; break;
    case 50  : sPortfolio = "Torm\nThe True, the True Deity, the Loyal Fury\n\nSymbol: Right-hand gauntlet held upright with palm forward\nAlignment: Lawful good\nPortfolio: Duty, loyalty, obedience, paladins\nWorshipers: Paladins, heroes, good fighters and warriors, guardians, knights, loyal courtiers"; break;
    case 51  : sPortfolio = "Tymora\nLady Luck, the Lady Who Smiles, Our Smiling Lady\n\nSymbol: Silver coin featuring Tymora's face surrounded by shamrocks\nAlignment: Chaotic good\nPortfolio: Good fortune, skill, victory, adventurers\nWorshipers: Rogues, gamblers, adventurers, Harpers, lightfoot halflings"; break;
    case 52  : sPortfolio = "Tyr\nThe Even-Handed, the Maimed God, the Just God\n\nSymbol: Balanced scales resting on a warhammer\nAlignment: Lawful good\nPortfolio: Justice\nWorshipers: Paladins, judges, magistrates, lawyers, police, the oppressed"; break;
    case 53  : sPortfolio = "Ubtao\nCreator of Chult, Founder of Mezro, Father of the Dinosaurs\n\nSymbol: Maze\nAlignment: Neutral\nPortfolio: Creation, jungles, Chult, the Chultans, dinosaurs\nWorshipers: Adepts, chultans, druids, inhabitants of jungles, rangers"; break;
    case 54  : sPortfolio = "Ulutiu\nThe Lord in the Ice, the Eternal Sleeper, Father of the Giants' Kin\n\nSymbol: Necklace of blue and white ice crystals\nAlignment: Lawful neutral\nPortfolio: Glaciers, polar environments, arctic dwellers\nWorshipers: Arctic dwellers, druids, historians, leaders, teachers, rangers"; break;
    case 55  : sPortfolio = "Umberlee\nThe Bitch Queen, Queen of the Depths\n\nSymbol: Blue-green wave curling left and right\nAlignment: Chaotic evil\nPortfolio: Oceans, currents, waves, sea winds\nWorshipers: Sailors, weresharks, sentient sea creatures, coastal dwellers"; break;
    case 56  : sPortfolio = "Uthgar\nFather of the Uthgardt, Battle Father\n\nSymbol: That of the individual beast totem spirit\nAlignment: Chaotic neutral\nPortfolio: Uthgardt barbarian tribes, physical strength\nWorhipers: TheUthgardt tribes, barbarians"; break;
    case 57  : sPortfolio = "Valkur\nThe Mighty, Captain of the Waves\n\nSymbol: Cloud with three lightning bolts on a shield\nAlignment: Chaotic good\nPortfolio: Sailors, ships, favorable winds, naval combat\nWorshipers: Fighters, rogues, sailors"; break;
    case 58  : sPortfolio = "Velsharoon\nThe Vaunted, Archmage of Necromancy, Lord of the Forsaken Crypt\n\nSymbol: A crowned laughing lich skull on a solid black hexagon\nAlignment: Neutral evil\nPortfolio: Necromancy, necromancers, evil liches, undeath\nWorshipers: Liches, necromancers, seekers of immortality through undeath, Cult of the Dragon"; break;
    case 59  : sPortfolio = "Waukeen\nMerchant's Friend\n\nSymbol: Gold coin with Waukeen's profile facing left\nAlignment: Neutral\nPortfolio: Trade, money, wealth\nWorshipers: Merchants, traders, the wealthy, rogues (those who learn the thiefly art in order to fight thieves)"; break;
    case 61  : sPortfolio = "Corellon Larethian\nCreator of the Elves, First of the Seldarine, Coronal of Arvandor (Greater Elven Deity)\n\nSymbol: Crescent Moon\nAlignment: Chaotic Good\nPortfolio: Magic, music, arts, crafts, war, the elven race (especially sun elves), poetry, bards, warriors.\nWorshipers: Arcane archers, artisans, artists, bards, fighters, good leaders, rangers, poets, sorcerers, warriors, wizards."; break;
    case 62  : sPortfolio = "Garl Glittergold\nThe Joker, the Watchful Protector, the Priceless Gem, the Sparkling Wit\n\nSymbol: Gold nugget\nAlignment: Lawful Good\nPortfolio: Protection, humor, trickery, gemcutting, smithing\nWorshipers: Gnomes"; break;
    case 60  : sPortfolio = "Moradin\nSoul Forger, Dwarffather, the All-Father, the Creator\n\nSymbol: Hammer and Anvil\nAlignment: Lawful Good\nPortfolio: Dwarves, creation, smithing, protection, metalcraft, stonework\nWorshipers: Dwarves"; break;
    case 63  : sPortfolio = "Yondalla\nThe Protector and Provider, the Nurturing Matriarch, the Blessed One\n\nSymbol: Shield with a cornucopia motif\nAlignment: Lawful Good\nPortfolio: Protection, fertility\nWorshipers: Halflings\n\n(In her aspect as Dallah Thaun, Lady of Mysteries, Yondalla has a CN alignment and patrons greed, deceit and stealth)"; break;
    case 101 : sPortfolio = "Ghaunadaur\nThat Which Lurks, the Elder Eye\n\nSymbol: Purplish eye on purple, violet, and black circles\nAlignment: Chaotic Evil\nPortfolio: Oozes, slimes, jellies, outcasts, ropers, rebels\nWorshipers: Aboleths, drow, fighters, oozes, outcasts, ropers."; break;
    case 125 : sPortfolio = "Kiaransalee\nLady of the Dead, the Revenancer, the Vengeful Banshee\n\nSymbol: Female drow hand wearing silver rings\nAlignment: Chaotic Evil\nPortfolio: Undead, Vengeance\nWorshipers: Drow, necromancers, undead."; break;
    case 126 : sPortfolio = "Selvetarm\nChampion of Lolth, the Spider that Waits\n\nSymbol: Spider on a crossed sword and mace\nAlignment: Chaotic Evil\nPortfolio: Drow Warriors\nWorshipers: Barbarians, drow, fighters, those who like to kill, warriors."; break;
    case 102 : sPortfolio = "Vhaeraun\nThe Masked Lord, the Masked God of Night\n\nSymbol: A pair of black glass lenses that form a mask\nAlignment: Chaotic Evil\nPortfolio: Thievery, drow males, evil activity on the surface\nWorshipers: Assassins, male drow and half-drow, poisoners, shadowdancers, rogues, thieves."; break;
    case 69  : sPortfolio = "Abbathor\nGreat Master of Greed, Trove Lord, Wyrm of Avarice\n\nSymbol: Jeweled Dagger\nAlignment: Neutral Evil\nPortfolio: Greed\nWorshipers: Dwarves, misers, rogues, shadowdancers."; break;
    case 70  : sPortfolio = "Berronar Truesilver\nThe Revered Mother, Mother of Safety\n\nSymbol: Two Silver Rings\nAlignment: Laweful Good\nPortfolio: Safety, honesty, home, healing, the dwarven family, records, marriage, faithfulness, loyalty, oaths\nWorshipers: Children, dwarven defenders, dwarves, fighters, homemakers, husbands, parents, scribes, wives."; break;
    case 71  : sPortfolio = "Clangeddin Silverbeard\nFather of Battle, Lord of the TWin Axes, the Rock of Battle\n\nSymbol: Two crossed battleaxes\nAlignment: Laweful Good\nPortfolio: Battle, war, valor, bravery, honor in battle\nWorshipers: Barbarians, dwarven defenders, dwarves, fighters, monks, paladins, soldiers, strategists, tacticians, warriors."; break;
    case 127 : sPortfolio = "Deep Duerra\nQueen of the Invisible Art, Axe Princess of Conquest\n\nSymbol: Broken Illithid Skull\nAlignment: Lawful Evil\nPortfolio: Psionics, conquest, expansion\nWorshipers: Dwarves, fighters, psionicists, travelers in the Underdark."; break;
    case 103 : sPortfolio = "Dugmaren Brightmantle\nThe Gleam in the Eye, the Errant Explorer\n\nSymbol: Open Book\nAlignment: Chaotic Good\nPortfolio: Scholarship, Invention, Discovery\nWorshipers: Artisans, dwarves, loremasters, runecasters, scholars, tinkers, wizards."; break;
    case 72  : sPortfolio = "Dumathoin\nKeeper of Secrets under the Mountain, the Silent Keeper\n\nSymbol: Faceted gem inside a mountain\nAlignment: Neutral\nPortfolio: Bruied wealth, ores, gems, mining, exploration, shield dwarves, guardian of the dead\nWorshipers: Dwarves, Gemsmiths, Metalsmiths, Miners."; break;
    case 104 : sPortfolio = "Gorm Gulthyn\nFire Eyes, Lord of the Bronze Mask, the Eternally Vigilant\n\nSymbol: Shining bronze mask with eyeholes of flame\nAlignment: Lawful Good\nPortfolio: Guardian of all dwarves, defense, watchfulness\nWorshipers: Dwarven Defenders, dwarves, fighters."; break;
    case 128 : sPortfolio = "Haela Brightaxe\nLady of the Fray, Luckmaiden\n\nSymbol: Unsheathed sword wrapped into two spirals of flame\nAlignment: Chaotic Good\nPortfolio: Luck in Battle, Joy of Battle, Dwarven Fighters\nWorshipers: Barbarians, dwarves, fighters."; break;
    case 73  : sPortfolio = "Laduguer\nThe Exile, the Gray Protector, Master of Crafts\n\nSymbol: Broken Crossbow bolt on a shiled\nAlignment: Lawful Evil\nPortfolio: Magic Weapon Creation, Artisans, Magic, Gray Dwarves\nWorshipers: Dwarves, fighters, loremasters, soldiers."; break;
    case 105 : sPortfolio = "Marthammor Duin\nFinder-of-Trails, Watcher over Wanderers, the Watchful Eye\n\nSymbol: Upright mace in front of a fur-trimmed leather boot\nAlignment: Neutral Good\nPortfolio: Guides, explorers, expatriates, travelers, lightning\nWorshipers: Dwarves, fighters, rangers, travelers."; break;
    case 74  : sPortfolio = "Sharindlar\nLady of Life and Mercy, the Shining Dancer\n\nSymbol: Flame ring rising from a steel needle\nAlignment: Chaotic Good\nPortfolio: Healing, mercy, romantic love, fertility, dancing, courtship, the moon\nWorshipers: Dwarves, Bards, dancers, healers, lovers."; break;
    case 106 : sPortfolio = "Thard Harr\nLord of the Jungle Deeps\n\nSymbol: Two crossed scaly clawed gauntlets of silvery-blue material\nAlignment: Chaotic Good\nPortfolio: Wild Dwarves, jungle survival, hunting\nWorshipers: Wild Dwarves, Druids, inhabitants of jungles, rangers."; break;
    case 75  : sPortfolio = "Vergadain\nMerchant King, the Short Father, the Laughing Dwarf\n\nSymbol: Gold Piece\nAlignment: Neutral\nPortfolio: Wealth, luck, chance, nonevil thieves, suspicion, trickery, negotiation, sly cleverness\nWorshipers: Dwarves, merchants, rogues, wealthy individuals."; break;
    case 76  : sPortfolio = "Aerdrie Faenya\nThe Winged Mother, Queen of the Avariel\n\nSymbol: Cloud with bird silhouette\nAlignment: Chaotic Good\nPortfolio: Air, weather, avians, rain, fertility, avariels\nWorshipers: Bards, druids, elves, rangers, sorcerers, travelers, winged beings."; break;
    case 64  : sPortfolio = "Angharradh\nThe Triune Goddess, Queen of Arvandor\n\nSymbol: Three interconnecting rings on a downard pointing triangle\nAlignment: Chaotic Good\nPortfolio: Spring, fertility, planting, birth, defense, wisdom\nWorshipers: Community elders, druids, elves, farmers, fighters, midwives, mothers."; break;
    case 77  : sPortfolio = "Deep Sashelas\nLord of the Undersea, the Dolphin Prince\n\nSymbol: Dolphin\nAlignment: Chaotic Good\nPortfolio: Oceans, sea elves, creation, knowledge\nWorshipers: Druids, elves, fisherfolk, rangers, sages, sailors."; break;
    case 78  : sPortfolio = "Erevan Ilesere\nThe Chameleon, the Green Changeling, the Fey Jester\n\nSymbol: Starburst with asymmatrical rays\nAlignment: Chaotic Neural\nPortfolio: Mischief, change, rogues\nWorshipers: Elves, Bards, revelers, rogues, sorcerers, tricksters."; break;
    case 107 : sPortfolio = "Fenmarel Mestarine\nThe Lone Wolf\n\nSymbol: Pair of elven eyes in the darkness\nAlignment: Chaotic Neural\nPortfolio: Feral Elves, outcasts, scapegoats, isolation\nWorshipers: Elves, druids, outcasts, rangers, rogues, spies, wild elves."; break;
    case 79  : sPortfolio = "Hanali Celanil\nThe Heart of Gold, Winsome Rose, Lady Goldheart\n\nSymbol: Gold Heart\nAlignment: Chaotic Good\nPortfolio: Love, romance, beauty, enchantments, magic item artistry, fine art, artists\nWorshipers: Aesthetes, artists, enchanters, lovers, sorcerers."; break;
    case 80  : sPortfolio = "Labelas Enoreth\nThe Lifegiver, Lord of the Continuum, the Sage at Sunset\n\nSymbol: Setting Sun\nAlignment: Chaotic Good\nPortfolio: Time, Longevity, the moment of choice, history\nWorshipers: Bards, divine disciples, elves, loremasters, scholars, teachers."; break;
    case 81  : sPortfolio = "Rillifane Rallathil\nThe Leaflord\n\nSymbol: Oak Tree\nAlignment: Chaotic Good\nPortfolio: Woodlands, nature, wild elves, druids\nWorshipers: Druids, Rangers, wild elves."; break;
    case 82  : sPortfolio = "Sehanine Moonbow\nDaughter of the Night Skies, the Luminous Cloud, Lady of Dreams\n\nSymbol: Misty Crescent above a full moon\nAlignment: Chaotic Good\nPortfolio: Mysticism, dreams, death, journeys, transcendence, the moon, the stars, the heavens, moon elves\nWorshipers: Diviners, elves, half-elves, illusionists, opponents of the undead."; break;
    case 129 : sPortfolio = "Shevarash\nThe Black Archer, the Night Hunter\n\nSymbol: Broken arrow above a teardrop\nAlignment: Chaotic Neutral\nPortfolio: Hatred of the drow, vengeance, crusades, loss\nWorshipers: Arcane Archers, Archers, elves, fighters, hunters, rangers, soldiers, sorcerers."; break;
    case 83  : sPortfolio = "Solonor Thelandira\nKeen-Eye, The Great Archer\n\nSymbol: Silver arrow with green fletching\nAlignment: Chaotic Good\nPortfolio: Archery, Hunting, Wilderness Survival\nWorshipers: Arcane Archers, Archers, elves, druids, rangers."; break;
    case 84  : sPortfolio = "Baervan Wildwanderer\nThe Masked Leaf\n\nSymbol: Raccoon's Face\nAlignment: Neutral Good\nPortfolio: Travel, nature, forest gnomes\nWorshipers: Druids, rangers, forest gnomes, rock gnomes, tricksters."; break;
    case 108 : sPortfolio = "Baravar Cloakshadow\nThe Sly One, Master of Illusion, Lord in Disguise\n\nSymbol: Cloak and Dagger\nAlignment: Neutral Good\nPortfolio: Illusions, deception, traps, wards\nWorshipers: Adventurers, deceivers, gnomes, illusionists, rogues, thieves."; break;
    case 85  : sPortfolio = "Calladuran Smoothhands\nDeep Brother, Master of Stone, Lord of Deepearth\n\nSymbol: Gold ring with star symbol\nAlignment: Neutral\nPortfolio: Stone, the Underdark, mining, the svirfneblin\nWorshipers: Fighters, gemcutters, hermits, jewelers, illusionists, opponents of drow, svirfneblin."; break;
    case 86  : sPortfolio = "Flandal Steelskin\nMaster of Metal, the Great Steelsmith\n\nSymbol: Flaming Hammer\nAlignment: Neutral Good\nPortfolio: Mining, physical fitness, smithing, metal-working\nWorshipers: Artisans, fighters, gnomes, miners, smiths."; break;
    case 109 : sPortfolio = "Gaerdal Ironhand\nThe Stern, Shield of the Golden Hills\n\nSymbol: Iron Band\nAlignment: Lawful Good\nPortfolio: Vigilance, Combat, Martial Defense\nWorshipers: Administrators, fighters, judges, monks, paladins, soldiers, warriors."; break;
    case 87  : sPortfolio = "Segojan Earthcaller\nEarthfriend, Lord of the Burrow\n\nSymbol: Glwoing Gemstone\nAlignment: Neutral Good\nPortfolio: Earth, nature, the dead\nWorshipers: Druids, elemental archons (earth), fightrs, gnomes, illusionists, merchants, miners."; break;
    case 88  : sPortfolio = "Urdlen\nThe Crawler Below\n\nSymbol: White Mole\nAlignment: Chaotic Evil\nPortfolio: Greed, bloodlust, evil, hatred, uncontrolled impulse, spriggans\nWorshipers: Assassins, blackguards, gnomes, rogues, spriggans."; break;
    case 89  : sPortfolio = "Arvoreen\nThe Defender, the Wary Sword\n\nSymbol: Two crossed short swords\nAlignment: Lawful Good\nPortfolio: Defense, war, vigilance, halfling warriors, duty\nWorshipers: Halflings, fighters, paladins, rangers, soldiers, warriors."; break;
    case 110 : sPortfolio = "Brandobaris\nMaster of Stealth, the Irrepressible Scamp\n\nSymbol: Halfling's footprint\nAlignment: Neutral\nPortfolio: Stealth, thievery, adventuring, halfling rogues\nWorshipers: Adventurers, bards, halflings, risk takers, rogues."; break;
    case 90  : sPortfolio = "Cyrrollalee\nThe Hand of Fellowship, the Hearthkeeper\n\nSymbol: Open Door\nAlignment: Lawful Good\nPortfolio: Friendship, trust, the hearth, hospitality, crafts\nWorshipers: Artisans, cooks, guards, halflings, hosts, innkeepers."; break;
    case 91  : sPortfolio = "Sheela Peryroyl\nGreen Sister, Watchful Mother\n\nSymbol: Daisy\nAlignment: Neutral\nPortfolio: Nature, agriculture, weather, song, dance, beauty, romantic love\nWorshipers: Halflings, bards, druids, farmers, gardeners, rangers."; break;
    case 130 : sPortfolio = "Urogalan\nHe Who Must Be, Lord of the Earth, the Black Hound\n\nSymbol: Silhouette of a Dog's Head\nAlignment: Lawful Neutral\nPortfolio: Earth, death, protection of the dead\nWorshipers: Halflings, Genealogists, grave diggers."; break;
    case 92  : sPortfolio = "Dallah Thaun\nThe Lady of Mysteries\n\nSymbol: Purse full of Coin\nAlignment: Chaotic Neutral\nPortfolio: secrets, guile, greed, thieves and rogues, acquisition of wealth and death\nWorshipers: Halflings, rogues, thieves./n/n(Dallah Thaun is Yondallah's CN aspect and the Halfling's deeply guarded secret: Do not reveal Dallah Thaun's existence to any non-halfling.)"; break;
    case 111 : sPortfolio = "Anhur\nGeneral of the Gods, Champion of Physical Prowess, the Falcon of War\n\nSymbol: Hawk-Headed falchion bound with a cord\nAlignment: Chaotic Good\nPortfolio: War, conflict, physical prowess, thunder, rain\nWorshipers: Druids, fighters, monks, rangers, soldiers, warriors."; break;
    case 112 : sPortfolio = "Geb\nKing of the Riches under the Earth, Father under the Skies nad Sands\n\nSymbol: A mountain\nAlignment: Neutral\nPortfolio: the earth, miniers, mines, mineral resources\nWorshipers: Elemental archons (earth), fighters, miners and smiths."; break;
    case 113 : sPortfolio = "Hathor\nThe Nurturing Mother\n\nSymbol: HOrned cow's head, wearing a lunar disk\nAlignment: Neutral Good\nPortfolio: Motherhood, folk music, dance, the moon, fate\nWorshipers: Bards, dancers, mothers."; break;
    case 65  : sPortfolio = "Horus-Re\nLord of the Sun, Master of Vengeance, Pharaoh of the Gods\n\nSymbol: Hawk's head in pharaoh's crown surrounded by a solar circle\nAlignment: Lawful Good\nPortfolio: The sun, vengeance, rulership, kings, life\nWorshipers: Administrators, judges, nobles, paladins."; break;
    case 93  : sPortfolio = "Isis\nBeautiful Lady, Lady of Rivers, Mistress of Enchantments\n\nSymbol: Ankh and Star on a Lunar Disk\nAlignment: Neutral Good\nPortfolio: Weather, rivers, agriculture, love, marriage, good magic\nWorshipers: Arcane spellcasters, druids, lovers, mothers."; break;
    case 94  : sPortfolio = "Nephthys\nGuardian of Wealth and Commerce, Protector of the Dead, the Avenging Mother\n\nSymbol: A golden offering bowl topped by an Ankh\nAlignment: Chaotic Good\nPortfolio: Wealth, trade, protector of children and the dead\nWorshipers: Merchants, money-changers, tax-collectors, rogues."; break;
    case 95  : sPortfolio = "Osiris\nLord of Nature, Judge of the Dead, Reaper of the Harvest\n\nSymbol: White crown of Mulhorand over a crossed crook and flail\nAlignment: Lawful Good\nPortfolio: Vegetation, death, the dead, justice, the harvest\nWorshipers: Attorneys, druids, embalmers, judges, paladins, rangers, seekers of rightful vengeance."; break;
    case 131 : sPortfolio = "Sebek\nLord of Crocodiles, the Smiling Death\n\nSymbol: Crocodile head wearing a horned and plumed headdress\nAlignment: Neutral Evil\nPortfolio: River hazards, crocodiles, werecrocodiles, wetlands\nWorshipers: Druids, inhabitants of crocodile infested areas, rangers, werecrocodiles."; break;
    case 96  : sPortfolio = "Set\nDefiler of the Dead, Lord of Carrion, Father of Jackals\n\nSymbol: Coiled Cobra\nAlignment: Lawful Evil\nPortfolio: The desert, destruction, drought, night, rot, snakes, hate, betrayal, evil magic, poison, murder\nWorshipers: Assassins, blackguards, brigands, criminals, rogues, thieves, tomb robbers, wizards."; break;
    case 97  : sPortfolio = "Thoth\nLord of Magic, Scribe of the Gods, the Keeper of Knowledge\n\nSymbol: Ankh above an ibis head\nAlignment: Neutral\nPortfolio: Neutral magic, scribes, knowledge, invention, secrets\nWorshipers: Loremasters, those who craft magic items, wizards."; break;
    case 114 : sPortfolio = "Bahgtru\nThe Strong, the Leg Breaker, the Son of Gruumsh\n\nSymbol: Broken thighbone\nAlignment: Chaotic Evil\nPortfolio: Loyalty, stupidity, brute strength\nWorshipers: Barbarians, followers, orcs, physically strong beings, warriors, wrestlers."; break;
    case 66  : sPortfolio = "Gruumsh\nHe Who Never Sleeps, the One Eyed God, He Who Watches\n\nSymbol: Unwinking Eye\nAlignment: Chaotic Evil\nPortfolio: Orcs, conquest, survival, strength, territory\nWorshipers: Orcs, Fighters."; break;
    case 115 : sPortfolio = "Ilneval\nThe Horde Leader, the War Maker, the Lieutenant of Gruumsh\n\nSymbol: Bloodied longsword\nAlignment: Neutral Evil\nPortfolio: War, combat, overwhelming numbers, strategy\nWorshipers: Orcs, Fighters, Barbarians."; break;
    case 116 : sPortfolio = "Luthic\nThe Cave Mother, the Blood Moon Witch\n\nSymbol: Orc Rune for 'Home'\nAlignment: Neutral Evil\nPortfolio: Caves, orc females, home, wisdom, fertility, healing, servitude\nWorshipers: Orc Females, Monks, Runecasters."; break;
    case 117 : sPortfolio = "Shargaas\nThe Night Lord, the Blade in the Darkness, the Stalker Below\n\nSymbol: Skull on a red crescent moon\nAlignment: Chaotic Evil\nPortfolio: Night, thieves, stealth, darkness, the Underdark\nWorshipers: Assassins, blackguards, orcs, shadowdancers, thieves."; break;
    case 118 : sPortfolio = "Yurtrus\nWhite Hands, the Lord of Maggots, the Rotting One\n\nSymbol: White hands on a dark background\nAlignment: Neutral Evil\nPortfolio: Death, disease\nWorshipers: Assassins, Monks, Orcs."; break;
    case 119 : sPortfolio = "Oogooboogoo\nThe eater in The Dark, The Great Kivvil Eater, The Glorious Goblin, The Dreaded Father, The Terrifying Goblin Leader\n\nSymbol: A big O drawn with human and elven teeth, often a mace and/or a dagger is situated in the middle\nAlignment: Chaotic Evil\nPortfolio: Shamans, Rogues, Fighters, Barbarians\nWorshipers: Underdark Goblins and some Underdark Hobgoblin barbarians."; break;
    case 132 : sPortfolio = "Yeenoghu\nThe Prince of Gnolls, Lord of Savagery, the Prince of Demons\n\nSymbol: Triple Headed Flail\nAlignment: Chaotic Evil\nPortfolio: Gnolls\nWorshipers: Gnolls."; break;
    case 133 : sPortfolio = "Gorellik\nUnknown\n\nSymbol: A Mottled and pale Gnoll Head\nAlignment: Chaotic Evil\nPortfolio: Gnolls, Hunting, Hyenas\nWorshipers: Gnolls, Hunters, Feral Gnolls."; break;
    case 120 : sPortfolio = "Bargrivyek\nThe Peacekeeper\n\nSymbol: A White-Tipped Flail\nAlignment: Lawful Evil\nPortfolio: Goblins, Peace between Tribes, Cooperation, Territory\nWorshipers: Goblins, Shamans."; break;
    case 121 : sPortfolio = "Khurgorbaeyag \nThe Oveseer\n\nSymbol: A Whip\nAlignment: Lawful Evil\nPortfolio: Slavery, Oppression, Morale\nWorshipers: Goblins, Commanders, Soldiers."; break;
    case 67  : sPortfolio = "Maglubiyet\nFiery-Eyes, the Mighty One, the High Chieftain, the Lord of Depths and Darkness, the Battle Lord\n\nSymbol: Blood dripping Battleaxe\nAlignment: Neutral Evil\nPortfolio: War, Rulership\nWorshipers: Goblins, Tribe Leaders, Fighters."; break;
    case 122 : sPortfolio = "Kikanuti\nMother Diety\n\nSymbol: Braided Corn\nAlignment: Neutral\nPortfolio: Protection, Fertility\nWorshipers: Goblins, Female Goblins, Rangers, Druids."; break;
    case 134 : sPortfolio = "Zinzerena\nThe Hunted\n\nSymbol: A shortsword draped in a black cloak\nAlignment: Chaotic Evil\nPortfolio: Trickery, Assassins, Chaos\nWorshipers: Drow, Opponents of Lolth."; break;
    case 135 : sPortfolio = "Gaknulak\nUnknown\n\nSymbol: A cauldron with whirling elipses\nAlignment: Lawful Evil\nPortfolio: Trickery, Protection, Stealth, Traps\nWorshipers: Kobolds, Scouts, Spies."; break;
    case 98  : sPortfolio = "Nathair Sgiathach\nUnknown\n\nSymbol: A Smile\nAlignment: Chaotic Good\nPortfolio: Trickery, Pranks, Mischief\nWorshipers: Pixies, Sprites, Grigs."; break;
    case 123 : sPortfolio = "Oberon\nLord of Beasts, King of the Seelie Courtn\n\nSymbol: A White Stag\nAlignment: Neutral Good\nPortfolio: Nature, Wild Places, Animals\nWorshipers: Non-Evil Fey, Druids, Rangers."; break;
    case 68  : sPortfolio = "Titania\nThe Faerie Queen\n\nSymbol: A white diamond with a blue star glowing in its center\nAlignment: Chaotic Good\nPortfolio: Faerie folk and Realms, Friendship, Magic\nWorshipers: Non-Evil Fey, Sprites, Pixies."; break;
    case 99  : sPortfolio = "Queen of Air and Darkness\nThe Unnamed One\n\nSymbol: A Black Diamond\nAlignment: Chaotic Evil\nPortfolio: Magic, Darkness, Murder\nWorshipers: Evil Fey, unseelie Sprites, Pixies, Evil Elves."; break;
    case 124 : sPortfolio = "Verenestra\nUnknown\n\nSymbol: A filigree edged mirror\nAlignment: Neutral\nPortfolio: Beauty, Charm, Female Faeries\nWorshipers: Female Faeries, mainly nymphs, dryads and sprites."; break;
    case 136 : sPortfolio = "The aspect of nature, sometimes referred to as Toril."; break;
    case 137 : sPortfolio = "Bahamut\nGod of Dragons\n\nSymbol:Argent dragon's head on a blue shield\nAlignment: Lawful Good\nPortfolio: Justice, Good dragons, Wisdom, Wind\nWorshipers: Metalic dragons."; break;
    case 138 : sPortfolio = "La'laskra\nThe Dark Queen of Torment, The Forgotten Sister\n\nSymbol: A sharpened dagger pointing downwards wrapped in a coiling of a barbed whip.\nAlignment: Lawful Evil\nPortfolio: Drow, tyranny, unity, suffering, hedonism\nWorshippers: Drow, Half-Drow, Crinti."; break;
    case 139 : sPortfolio = "Zarus\nThe Inheritor, The Father of Humanity, The Guiding Hand\n\nSymbol: Visage of a perfect Human male set upon a shield and geometric starburst.\nHome Plane: Acheron\nAlignment: Lawful Evil\nPortfolio: Humanity, domination, perfection.\nWorshipers: Human Supremacists, Conquerors, Subjugated Abhumans, Perfectionists\n"; break;
    case 140 : sPortfolio = "Bel\nThe Lord of the First, Warmaster, The Black Strategarch, General of the Third Command\n\nSymbol: A fanged mouth biting down on a sword's blade.\nAlignment: Lawful Evil\nPortfolio: Wrath, military duty, war crimes, gateways.\nWorshipers: Blood War soldiers, usurpers, demon slayers."; break;
    case 141 : sPortfolio = "Dispater\nCastellan of the Eternal City, The Iron Duke, Father of Strife, Patrician Poneros\n\nSymbol: Crowned iron nail driven into a golden ring.\nAlignment: Lawful Evil\nPortfolio: Cities, surveillance, corrupt enterprise, paranoia, prisons.\nWorshipers: Wardens, corrupt merchants, architects, saboteurs."; break;
    case 142 : sPortfolio = "Mammon\nThe Viscount of Minauros, Lord of Greed, The Serpent, The Grasping One\n\nSymbol: A devil-faced coin, left-facing profile.\nAlignment: Lawful Evil\nPortfolio: Avarice, wealth, selfishness, cheating.\nWorshipers: Wealthy and selfish humanoids and monsters, gamblers, loan sharks."; break;
    case 143 : sPortfolio = "Fierna/Belial\nThorned Caress, Duke of Whores, The Heart Catastrophic, The Indulgence in Flame\n\nSymbol: A two-toned, horned theatre mask (right red, left white).\nAlignment: Lawful Evil\nPortfolio: Lust, domination, abuse, incest.\nWorshipers: Debauchers, pimps, libertines and hedonists, manipulators."; break;
    case 144 : sPortfolio = "Levistus\nPrince of Stygia, The First Blasphemer, The Rogue Archduke, Lord of Spite\n\nSymbol: A duelist's sword thrust into a block of ice.\nAlignment: Lawful Evil\nPortfolio: Heresy, vengeance, apostasy, loathing.\nWorshipers: Pirates, thugs, swordsmen, fallen priests."; break;
    case 145 : sPortfolio = "Glasya\nMother Cancer, Princess of Hell, The Dark Prodigy\n\nSymbol: An inverted purple star within an anatomical heart.\nAlignment: Lawful Evil\nPortfolio: Corruption, agony, nepotism, flesh.\nWorshipers: Manipulators, powers behind thrones, experimental youth."; break;
    case 146 : sPortfolio = "Baalzebul\nThe Slug Archduke, Lord of Lies, Lord of Flies, The Fallen One, Perfect Imperfect\n\nSymbol: A swarm of flies within a broken silver crown.\nAlignment: Lawful Evil\nPortfolio: Lies, perfectionism, sloth, political assassinations.\nWorshipers: Bugbears, pathological liars, con artists, disaffected masses."; break;
    case 147 : sPortfolio = "Mephistopheles\nSeneschal of Hell, The Cold Lord, Merchant of Souls, Prince of Hellfire\n\nSymbol: A downward-pointed trident shrouded in fire.\nAlignment: Lawful Evil\nPortfolio: Hellfire, ambition, pride.\nWorshipers: Wizards (especially evokers), disaffected devil worshipers, pyromaniacs, seconds-in-command."; break;
    case 148 : sPortfolio = "Asmodeus\nThe Archfiend, The Leviathan of the Pits, Prince of Darkness, Lord-Sovereign, The Eschatarch\n\nSymbol: An inverted pentacle.\nAlignment: Lawful Evil\nPortfolio: Oppression, contracts, power, supremacy, authority.\nWorshipers: Slavers, bureaucrats, tyrants, the wealthy and powerful, supremacists."; break;
    case 149 : sPortfolio = "This deity represents an abyssal power focused on magic."; break;
    case 150 : sPortfolio = "This deity represents an abyssal power focused on war."; break;
    case 151 : sPortfolio = "This deity represents an abyssal power focused on trickery."; break;
    case 152 : sPortfolio = "Vaprak\nThe Destroyer\n\nSymbol: A taloned claw.\nAlignment: Chaotic Evil\nPortfolio: Combat, greed, chaos, destruction, evil, war.\nWorshipers: Ogres and trolls."; break;
    case 153 : sPortfolio = "Kurtulmak\nThe Horned Sorcerer, Steelscale, Stingtail, Watcher\n\nSymbol: A gnome skull.\nAlignment: Lawful Evil\nPortfolio: Kobolds, trapmaking, mining, war, evil, law, luck, trickery.\nWorshipers: Kobolds"; break;
    case 154 : sPortfolio = "Bhaal\nLord of Murder\n\nSymbol: A skull encircled by a counterclockwise orbit of drops of blood.\nAlignment: Lawful Evil\nPortfolio: Murder, assassination, violence, death, destruction, evil, retribution.\nWorshipers: Bhaal is commonly worshipped by assassins of any evil alignment, as well as lawful evil clerics."; break;
    default  : sPortfolio = "No portfolio! Please report this bug."; break;
  }

  return sPortfolio;
}

// Sets up the deity list if not already done so
void gsWOSetup();
//return TRUE if nDeity is available for oPlayer
int gsWOGetIsDeityAvailable(int nDeity, object oPlayer = OBJECT_SELF);
//return deity constant resembling sDeity
int gsWOGetDeityByName(string sDeity);
//return name of nDeity
string gsWOGetNameByDeity(int nDeity);
//return aspect of nDeity
int gsWOGetAspect(int nDeity);
//return aspect of oPC's deity
int gsWOGetDeityAspect(object oPC);
//return race restriction of nDeity
int gsWOGetRacialType(int nDeity);
//return whether oPC is of an allowed race for nDeity
int gsWOGetIsRacialTypeAllowed(int nDeity, object oPC);
//return alignment restriction of nDeity
string gsWOGetAlignments(int nDeity);
//return the Piety score of oPC
float gsWOGetPiety(object oPC);
//adjust oPC's Piety by fAmount.  Return FALSE if it is now below 0.
int gsWOAdjustPiety(object oPC, float fAmount, int bReducePietyBelowZero = TRUE);
//adjust piety for oPC if they have the right aspected deity.
void gsWOGiveSpellPiety(object oPC, int bHealSpell);
//return TRUE if deity grants favor to oTarget
int gsWOGrantFavor(object oTarget = OBJECT_SELF);
//return TRUE if deity grants an unrequested boon to oTarget
int gsWOGrantBoon(object oTarget = OBJECT_SELF);
//return TRUE if deity resurrects oTarget
int gsWOGrantResurrection(object oTarget = OBJECT_SELF);
//oPC consecrates oAltar to their deity
void gsWOConsecrate(object oPC, object oAltar);
//oPC desecrates oAltar
void gsWODesecrate(object oPC, object oAltar);
//return the deity to which this altar is consecrated, if any.
int gsWOGetConsecratedDeity(object oAltar);
//return whether or not this altar is desecrated
int gsWOGetIsDesecrated(object oAltar);
// Handles the tedious technicalities of adding a deity's portfolio to the list
void gsWOAddDeity(int nDeity, string sAlignments, int nAspect, int nRacialType);
//lookup the item cache for the worship subsystem
void __gsWOInitCacheItem();
// Changes the currently active category of deities
void gsWOChangeCategory(int nCategory);

object oWOCacheItem = OBJECT_INVALID;
void __gsWOInitCacheItem()
{
    if (GetIsObjectValid(oWOCacheItem))
        return;

    oWOCacheItem = gsCMGetCacheItem("WORSHIP");
}
//-----------------------------------------------------------------
int gsWOGetIsDeityAvailable(int nDeity, object oPlayer = OBJECT_SELF)
{
    if (GetIsDM(oPlayer)) return TRUE;
    if (nDeity == GS_WO_NONE) return TRUE;


    object oItem = gsPCGetCreatureHide(oPlayer);
    // Non religious classes can worship anyone.
    if (!gsCMGetHasClass(CLASS_TYPE_CLERIC, oPlayer) &&
        !gsCMGetHasClass(CLASS_TYPE_PALADIN, oPlayer) &&
        !gsCMGetHasClass(CLASS_TYPE_BLACKGUARD, oPlayer) &&
        !gsCMGetHasClass(CLASS_TYPE_DRUID, oPlayer) &&
        !gsCMGetHasClass(CLASS_TYPE_RANGER, oPlayer) &&
        !gsCMGetHasClass(CLASS_TYPE_DIVINECHAMPION, oPlayer) &&
        !GetLocalInt(gsPCGetCreatureHide(oPlayer), VAR_FAV_SOUL) &&
        !GetLocalInt(oItem, "GIFT_OF_HOLY")) return TRUE;

    // Racial restrictions.
    if (!GetLocalInt(oItem, "GIFT_OF_UFAVOR") && !gsWOGetIsRacialTypeAllowed(nDeity, oPlayer)) return FALSE;

    // Druids can worship only nature god(desse)s.  Rangers can also, without alignment restrictions
    if ((gsCMGetHasClass(CLASS_TYPE_DRUID, oPlayer) ||
         gsCMGetHasClass(CLASS_TYPE_RANGER, oPlayer)) &&
         gsWOGetAspect(nDeity) & ASPECT_NATURE)
    {
      //enforce alignment restrictions if the druid has one of these classes.
      if(!gsCMGetHasClass(CLASS_TYPE_CLERIC, oPlayer) &&
         !gsCMGetHasClass(CLASS_TYPE_PALADIN, oPlayer) &&
         !gsCMGetHasClass(CLASS_TYPE_BLACKGUARD, oPlayer) &&
         !gsCMGetHasClass(CLASS_TYPE_DIVINECHAMPION, oPlayer))
           return TRUE;
    }
    //Rangers don't need to follow a nature deity.
    else if(gsCMGetHasClass(CLASS_TYPE_DRUID, oPlayer))
      return FALSE;


    // Clerics, rangers, paladins, champion of torms and blackguards must obey alignment restrictions.
    //As well as those with the gift of holy & favored souls.
    string sAlignment = "";

    switch (GetAlignmentLawChaos(oPlayer))
    {
    case ALIGNMENT_LAWFUL:  sAlignment = "L"; break;
    case ALIGNMENT_NEUTRAL: sAlignment = "N"; break;
    case ALIGNMENT_CHAOTIC: sAlignment = "C"; break;
    }

    switch (GetAlignmentGoodEvil(oPlayer))
    {
    case ALIGNMENT_GOOD:    sAlignment += "G"; break;
    case ALIGNMENT_NEUTRAL: sAlignment += "N"; break;
    case ALIGNMENT_EVIL:    sAlignment += "E"; break;
    }

    string sDeityAlignment = gsWOGetAlignments(nDeity);

    if (FindSubString(sDeityAlignment, sAlignment) > -1) return TRUE;

    if ((nDeity == gsWOGetDeityByName("Sune") || nDeity == gsWOGetDeityByName("Corellon Larethian")) &&
         gsCMGetHasClass(CLASS_TYPE_PALADIN, oPlayer)) return TRUE;

    return FALSE;
}
//----------------------------------------------------------------
int gsWOGetDeityByName(string sDeity)
{
    if (sDeity == "")                  return GS_WO_NONE;
    if (sDeity == "Akadi")             return 1;
    if (sDeity == "Auril")             return 2;
    if (sDeity == "Azuth")             return 3;
    if (sDeity == "Bahamut")           return 137;
    if (sDeity == "Bane")              return 4;
    if (sDeity == "Beshaba")           return 5;
    if (sDeity == "Chauntea")          return 6;
    if (sDeity == "Cyric")             return 7;
    if (sDeity == "Deneir")            return 8;
    if (sDeity == "Eilistraee")        return 9;
    if (sDeity == "Eldath")            return 10;
    if (sDeity == "Finder Wyvernspur") return 11;
    if (sDeity == "Garagos")           return 12;
    if (sDeity == "Gargauth")          return 13;
    if (sDeity == "Gond")              return 14;
    if (sDeity == "Grumbar")           return 15;
    if (sDeity == "Gwaeron Windstrom") return 16;
    if (sDeity == "Helm")              return 17;
    if (sDeity == "Hoar")              return 18;
    if (sDeity == "Ilmater")           return 19;
    if (sDeity == "Istishia")          return 20;
    if (sDeity == "Jergal")            return 21;
    if (sDeity == "Kelemvor")          return 22;
    if (sDeity == "Kossuth")           return 23;
    if (sDeity == "Lathander")         return 24;
    if (sDeity == "Lliira")            return 25;
    if (sDeity == "Lolth")             return 26;
    if (sDeity == "Loviatar")          return 27;
    if (sDeity == "Lurue")             return 28;
    if (sDeity == "Malar")             return 29;
    if (sDeity == "Mask")              return 30;
    if (sDeity == "Mielikki")          return 31;
    if (sDeity == "Milil")             return 32;
    if (sDeity == "Mystra")            return 33;
    if (sDeity == "Nobanion")          return 34;
    if (sDeity == "Oghma")             return 35;
    if (sDeity == "Red Knight")        return 36;
    if (sDeity == "Savras")            return 37;
    if (sDeity == "Selune")            return 38;
    if (sDeity == "Shar")              return 39;
    if (sDeity == "Sharess")           return 40;
    if (sDeity == "Shaundakul")        return 41;
    if (sDeity == "Shiallia")          return 42;
    if (sDeity == "Siamorphe")         return 43;
    if (sDeity == "Silvanus")          return 44;
    if (sDeity == "Sune")              return 45;
    if (sDeity == "Talona")            return 46;
    if (sDeity == "Talos")             return 47;
    if (sDeity == "Tempus")            return 48;
    if (sDeity == "Tiamat")            return 49;
    if (sDeity == "Torm")              return 50;
    if (sDeity == "Tymora")            return 51;
    if (sDeity == "Tyr")               return 52;
    if (sDeity == "Ubtao")             return 53;
    if (sDeity == "Ulutiu")            return 54;
    if (sDeity == "Umberlee")          return 55;
    if (sDeity == "Uthgar")            return 56;
    if (sDeity == "Valkur")            return 57;
    if (sDeity == "Velsharoon")        return 58;
    if (sDeity == "Waukeen")           return 59;
    if (sDeity == "Corellon Larethian") return 61;
    if (sDeity == "Garl Glittergold")  return 62;
    if (sDeity == "Moradin")           return 60;
    if (sDeity == "Yondalla")          return 63;
    if (sDeity == "Ghaunadaur")        return 101;
    if (sDeity == "Kiaransalee")       return 125;
    if (sDeity == "Selvetarm")         return 126;
    if (sDeity == "Vhaeraun")          return 102;
    if (sDeity == "Abbathor")          return 69;
    if (sDeity == "Berronar Truesilver") return 70;
    if (sDeity == "Clangeddin Silverbeard") return 71;
    if (sDeity == "Deep Duerra")       return 127;
    if (sDeity == "Dugmaren Brightmantle") return 103;
    if (sDeity == "Dumathoin")         return 72;
    if (sDeity == "Gorm Gulthyn")      return 104;
    if (sDeity == "Haela Brightaxe")   return 128;
    if (sDeity == "Laduguer")          return 73;
    if (sDeity == "Marthammor Duin")   return 105;
    if (sDeity == "Sharindlar")        return 74;
    if (sDeity == "Thard Harr")        return 106;
    if (sDeity == "Vergadain")         return 75;
    if (sDeity == "Aerdrie Faenya")    return 76;
    if (sDeity == "Angharradh")        return 64;
    if (sDeity == "Deep Sashelas")     return 77;
    if (sDeity == "Erevan Ilesere")    return 78;
    if (sDeity == "Fenmarel Mestarine") return 107;
    if (sDeity == "Hanali Celanil")    return 79;
    if (sDeity == "Labelas Enoreth")   return 80;
    if (sDeity == "Rillifane Rallathil") return 81;
    if (sDeity == "Sehanine Moonbow")  return 82;
    if (sDeity == "Shevarash")         return 129;
    if (sDeity == "Solonor Thelandira") return 83;
    if (sDeity == "Baervan Wildwanderer") return 84;
    if (sDeity == "Baravar Cloakshadow") return 108;
    if (sDeity == "Callarduran Smoothhands") return 85;
    if (sDeity == "Flandal Steelskin") return 86;
    if (sDeity == "Gaerdal Ironhand")  return 109;
    if (sDeity == "Segojan Earthcaller") return 87;
    if (sDeity == "Urdlen")            return 88;
    if (sDeity == "Arvoreen")          return 89;
    if (sDeity == "Brandobaris")       return 110;
    if (sDeity == "Cyrrollalee")       return 90;
    if (sDeity == "Sheela Peryroyl")   return 91;
    if (sDeity == "Urogalan")          return 130;
    if (sDeity == "Dallah Thaun")      return 92;
    if (sDeity == "Anhur")             return 111;
    if (sDeity == "Geb")               return 112;
    if (sDeity == "Hathor")            return 113;
    if (sDeity == "Horus-Re")          return 65;
    if (sDeity == "Isis")              return 93;
    if (sDeity == "Nephthys")          return 94;
    if (sDeity == "Osiris")            return 95;
    if (sDeity == "Sebek")             return 131;
    if (sDeity == "Set")               return 96;
    if (sDeity == "Thoth")             return 97;
    if (sDeity == "Bahgtru")           return 114;
    if (sDeity == "Gruumsh")           return 66;
    if (sDeity == "Ilneval")           return 115;
    if (sDeity == "Luthic")            return 116;
    if (sDeity == "Shargaas")          return 117;
    if (sDeity == "Yurtrus")           return 118;
    if (sDeity == "Gorellik")          return 133;
    if (sDeity == "Bargrivyek")        return 120;
    if (sDeity == "Khurgorbaeyag")     return 121;
    if (sDeity == "Maglubiyet")        return 67;
    if (sDeity == "Kikanuti")          return 122;
    if (sDeity == "Zinzerena")         return 134;
    if (sDeity == "Gaknulak")          return 135;
    if (sDeity == "Nathair Sgiathach") return 98;
    if (sDeity == "Oberon")            return 123;
    if (sDeity == "Titania")           return 68;
    if (sDeity == "Queen of Air and Darkness") return 99;
    if (sDeity == "Verenestra")        return 124;
    if (sDeity == "Oogooboogoo")       return 119;
    if (sDeity == "Yeenoghu")          return 132;
    if (sDeity == "Toril")             return 136;
    if (sDeity == "La'laskra")         return 138;
    if (sDeity == "Zarus")             return 139;
    if (sDeity == "Bel")               return 140;
    if (sDeity == "Dispater")          return 141;
    if (sDeity == "Mammon")            return 142;
    if (sDeity == "Fierna")            return 143;
    if (sDeity == "Belial")            return 144;
    if (sDeity == "Levistus")          return 144;
    if (sDeity == "Glasya")            return 145;
    if (sDeity == "Baalzebul")         return 146;
    if (sDeity == "Mephistopheles")    return 147;
    if (sDeity == "Asmodeus")          return 148;
    if (sDeity == "Abyssal (magic)")    return 149;
    if (sDeity == "Abyssal (war)")      return 150;
    if (sDeity == "Abyssal (trickery)") return 151;
    if (sDeity == "Vaprak")             return 152;
    if (sDeity == "Kurtulmak")          return 153;
    if (sDeity == "Bhaal")              return 154;

    return FALSE;
}
//----------------------------------------------------------------
string gsWOGetNameByDeity(int nDeity)
{
    switch (nDeity)
    {
        case 1:    return "Akadi";
        case 2:    return "Auril";
        case 3:    return "Azuth";
        case 137:  return "Bahamut";
        case 4:    return "Bane";
        case 5:    return "Beshaba";
        case 6:    return "Chauntea";
        case 7:    return "Cyric";
        case 8:    return "Deneir";
        case 9:    return "Eilistraee";
        case 10:   return "Eldath";
        case 11:   return "Finder Wyvernspur";
        case 12:   return "Garagos";
        case 13:   return "Gargauth";
        case 14:   return "Gond";
        case 15:   return "Grumbar";
        case 16:   return "Gwaeron Windstrom";
        case 17:   return "Helm";
        case 18:   return "Hoar";
        case 19:   return "Ilmater";
        case 20:   return "Istishia";
        case 21:   return "Jergal";
        case 22:   return "Kelemvor";
        case 23:   return "Kossuth";
        case 24:   return "Lathander";
        case 25:   return "Lliira";
        case 26:   return "Lolth";
        case 27:   return "Loviatar";
        case 28:   return "Lurue";
        case 29:   return "Malar";
        case 30:   return "Mask";
        case 31:   return "Mielikki";
        case 32:   return "Milil";
        case 33:   return "Mystra";
        case 34:   return "Nobanion";
        case 35:   return "Oghma";
        case 36:   return "Red Knight";
        case 37:   return "Savras";
        case 38:   return "Selune";
        case 39:   return "Shar";
        case 40:   return "Sharess";
        case 41:   return "Shaundakul";
        case 42:   return "Shiallia";
        case 43:   return "Siamorphe";
        case 44:   return "Silvanus";
        case 45:   return "Sune";
        case 46:   return "Talona";
        case 47:   return "Talos";
        case 48:   return "Tempus";
        case 49:   return "Tiamat";
        case 136:  return "Toril";
        case 50:   return "Torm";
        case 51:   return "Tymora";
        case 52:   return "Tyr";
        case 53:   return "Ubtao";
        case 54:   return "Ulutiu";
        case 55:   return "Umberlee";
        case 56:   return "Uthgar";
        case 57:   return "Valkur";
        case 58:   return "Velsharoon";
        case 59:   return "Waukeen";
        case 61:   return "Corellon Larethian";
        case 62:   return "Garl Glittergold";
        case 60:   return "Moradin";
        case 63:   return "Yondalla";
        case 101:  return "Ghaunadaur";
        case 125:  return "Kiaransalee";
        case 126:  return "Selvetarm";
        case 102:  return "Vhaeraun";
        case 69:   return "Abbathor";
        case 70:   return "Berronar Truesilver";
        case 71:   return "Clangeddin Silverbeard";
        case 127:  return "Deep Duerra";
        case 103:  return "Dugmaren Brightmantle";
        case 72:   return "Dumathoin";
        case 104:  return "Gorm Gulthyn";
        case 128:  return "Haela Brightaxe";
        case 73:   return "Laduguer";
        case 105:  return "Marthammor Duin";
        case 74:   return "Sharindlar";
        case 75:   return "Vergadain";
        case 76:   return "Aerdrie Faenya";
        case 64:   return "Angharradh";
        case 77:   return "Deep Sashelas";
        case 78:   return "Erevan Ilesere";
        case 107:  return "Fenmarel Mestarine";
        case 79:   return "Hanali Celanil";
        case 80:   return "Labelas Enoreth";
        case 81:   return "Rillifane Rallathil";
        case 82:   return "Sehanine Moonbow";
        case 129:  return "Shevarash";
        case 84:   return "Baervan Wildwanderer";
        case 85:   return "Callarduran Smoothhands";
        case 86:   return "Flandal Steelskin";
        case 109:  return "Gaerdal Ironhand";
        case 87:   return "Segojan Earthcaller";
        case 88:   return "Urdlen";
        case 89:   return "Arvoreen";
        case 130:  return "Urogalan";
        case 92:   return "Dallah Thaun";
        case 111:  return "Anhur";
        case 112:  return "Geb";
        case 113:  return "Hathor";
        case 65:   return "Horus-Re";
        case 93:   return "Isis";
        case 94:   return "Nephthys";
        case 95:   return "Osiris";
        case 131:  return "Sebek";
        case 97:   return "Thoth";
        case 114:  return "Bahgtru";
        case 66:   return "Gruumsh";
        case 115:  return "Ilneval";
        case 116:  return "Luthic";
        case 118:  return "Yurtrus";
        case 133:  return "Gorellik";
        case 120:  return "Bargrivyek";
        case 121:  return "Khurgorbaeyag";
        case 67:   return "Maglubiyet";
        case 122:  return "Kikanuti";
        case 134:  return "Zinzerena";
        case 135:  return "Gaknulak";
        case 98:   return "Nathair Sgiathach";
        case 123:  return "Oberon";
        case 68:   return "Titania";
        case 99:   return "Queen of Air and Darkness";
        case 124:  return "Verenestra";
        case 119:  return "Oogooboogoo";
        case 132:  return "Yeenoghu";
        case 90:   return "Cyrrollalee";
        case 83:   return "Solonor Thelandira";
        case 91:   return "Sheela Peryroyl";
        case 96:   return "Set";
        case 106:  return "Thard Harr";
        case 108:  return "Baravar Cloakshadow";
        case 110:  return "Brandobaris";
        case 117:  return "Shargaas";
        case 138:  return "La'laskra";
        case 139:  return "Zarus";
        case 140:  return "Bel";
        case 141:  return "Dispater";
        case 142:  return "Mammon";
        case 143:  return "Fierna";
        case 144:  return "Levistus";
        case 145:  return "Glasya";
        case 146:  return "Baalzebul";
        case 147:  return "Mephistopheles";
        case 148:  return "Asmodeus";
        case 149:  return "Abyssal (magic)";
        case 150:  return "Abyssal (war)";
        case 151:  return "Abyssal (trickery)";
        case 152:  return "Vaprak";
        case 153:  return "Kurtulmak";
        case 154:  return "Bhaal";
    }

    return "";
}
//----------------------------------------------------------------
float gsWOGetPiety(object oPC)
{
    object oHide = gsPCGetCreatureHide(oPC);
    return GetLocalFloat(oHide, "GS_ST_PIETY");
}
//----------------------------------------------------------------
int gsWOAdjustPiety(object oPC, float fAmount, int bReducePietyBelowZero = TRUE)
{
    object oHide = gsPCGetCreatureHide(oPC);
    float fPiety = gsWOGetPiety(oPC);

    if(fAmount < 0.0 && fPiety + fAmount < 0.0 && !bReducePietyBelowZero) return FALSE;

    if (fPiety + fAmount > 100.0) fPiety = 100.0;
    else if (fPiety + fAmount < -100.0) fPiety = -100.0;
    else fPiety += fAmount;

    SetLocalFloat(oHide, "GS_ST_PIETY",  fPiety);

    string sMessage = "";
    if (fAmount > 0.0) sMessage += "<cªÕþ>+";
    else               sMessage += "<cþ((>";

    SendMessageToPC(oPC, "Piety: " + sMessage + FloatToString(fAmount, 0, 1) + " (" +
    FloatToString(fPiety, 0, 1) + "%)");

    return (fPiety >= 0.0f);
}
//----------------------------------------------------------------
void gsWOGiveSpellPiety(object oPC, int bHealSpell)
{
    int nAspect = gsWOGetDeityAspect(oPC);

    if (nAspect & ASPECT_MAGIC && !bHealSpell) gsWOAdjustPiety(oPC, 0.1);
    if (nAspect & ASPECT_HEARTH_HOME && bHealSpell) gsWOAdjustPiety(oPC, 0.5);
}
//----------------------------------------------------------------
int gsWOGrantFavor(object oTarget = OBJECT_SELF)
{
    int GS_WO_TIMEOUT_FAVOR        = 10800; // 3 hours
    float GS_WO_COST_LESSER_FAVOR    =     5.0f;
    float GS_WO_COST_GREATER_FAVOR   =    10.0f;
    int GS_WO_PENALTY_PER_LEVEL    =    15;

    //deity
    string sDeity  = GetDeity(oTarget);

    if (sDeity == "")
    {
        FloatingTextStringOnCreature(GS_T_16777282, oTarget, FALSE);
        return FALSE;
    }

    //timeout
    int nTimestamp = gsTIGetActualTimestamp();

    if (GetLocalInt(oTarget, "GS_WO_TIMEOUT_FAVOR") > nTimestamp)
    {
        FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777283, sDeity), oTarget, FALSE);
        return FALSE;
    }

    SetLocalInt(oTarget, "GS_WO_TIMEOUT_FAVOR", nTimestamp + GS_WO_TIMEOUT_FAVOR);

    //piety
    float fPiety  = gsWOGetPiety(oTarget);

    // Removing random chance of triggering.
    // if (IntToFloat(Random(100)) >= fPiety)
    // {
    //    FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777284, sDeity), oTarget, FALSE);
    //    return FALSE;
    // }

    int nFlag      = FALSE;

    //greater favor
    if (fPiety >= GS_WO_COST_GREATER_FAVOR)
    {
        //remove negative effects
        effect eEffect = GetFirstEffect(oTarget);
        int nHitDice   = GetHitDice(oTarget);
        int nHeal = nHitDice * 10; // Max healing is hit dice x 10;
        int nCount = 0;

        while (GetIsEffectValid(eEffect) && nCount < 3)
        {
            switch (GetEffectType(eEffect))
            {
            case EFFECT_TYPE_ABILITY_DECREASE:
            case EFFECT_TYPE_AC_DECREASE:
            case EFFECT_TYPE_ARCANE_SPELL_FAILURE:
            case EFFECT_TYPE_ATTACK_DECREASE:
            case EFFECT_TYPE_BLINDNESS:
            case EFFECT_TYPE_CHARMED:
            case EFFECT_TYPE_CONFUSED:
            case EFFECT_TYPE_CURSE:
            case EFFECT_TYPE_DAMAGE_DECREASE:
            case EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE:
            case EFFECT_TYPE_DAZED:
            case EFFECT_TYPE_DEAF:
            case EFFECT_TYPE_DISEASE:
            case EFFECT_TYPE_DOMINATED:
            case EFFECT_TYPE_ENTANGLE:
            case EFFECT_TYPE_FRIGHTENED:
            case EFFECT_TYPE_NEGATIVELEVEL:
            case EFFECT_TYPE_PARALYZE:
            case EFFECT_TYPE_PETRIFY:
            case EFFECT_TYPE_POISON:
            case EFFECT_TYPE_SAVING_THROW_DECREASE:
            case EFFECT_TYPE_SKILL_DECREASE:
            case EFFECT_TYPE_SLEEP:
            case EFFECT_TYPE_SLOW:
            case EFFECT_TYPE_SPELL_FAILURE:
            case EFFECT_TYPE_SPELL_RESISTANCE_DECREASE:
            case EFFECT_TYPE_STUNNED:
                if (GetEffectSubType(eEffect) != SUBTYPE_EXTRAORDINARY)
                {
                    RemoveEffect(oTarget, eEffect);
                    nFlag = TRUE;
                    nCount++;
                    nHeal -= 100;
                }
            }

            eEffect = GetNextEffect(oTarget);
        }

        // int nCurrentHitPoints = GetCurrentHitPoints(oTarget);
        // int nMaxHitPoints     = GetMaxHitPoints(oTarget);

        //heal
        // if (nFlag || nCurrentHitPoints < nMaxHitPoints / 3)
        // {
        //    ApplyEffectToObject(DURATION_TYPE_INSTANT,
        //                        EffectHeal(nMaxHitPoints - nCurrentHitPoints),
        //                        oTarget);
        //    nFlag = TRUE;
        //}

        if (nHeal > 0)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oTarget);
            nFlag = TRUE;
        }

        //divine wrath - restricted to religious classes only.
        int nWRATHDISABLED = TRUE;  // Disabling this feature
        if (!nFlag && !nWRATHDISABLED &&
            (gsCMGetHasClass(CLASS_TYPE_CLERIC, oTarget) ||
             gsCMGetHasClass(CLASS_TYPE_PALADIN, oTarget) ||
             gsCMGetHasClass(CLASS_TYPE_BLACKGUARD, oTarget)||
             gsCMGetHasClass(CLASS_TYPE_DRUID, oTarget)||
             gsCMGetHasClass(CLASS_TYPE_RANGER, oTarget)))
        {
            location lLocation = GetLocation(oTarget);
            object oEnemy      = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, TRUE);
            effect eVisual1    = EffectVisualEffect(VFX_FNF_STRIKE_HOLY);
            effect eVisual2    = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
            int nDamage        = 0;
            float fPietyEnemy  = gsWOGetPiety(oEnemy);;
            int nResistance    = 0;
            int nNth           = 0;

            while (GetIsObjectValid(oEnemy))
            {
                if (GetIsReactionTypeHostile(oEnemy, oTarget) &&
                    ! gsBOGetIsBossCreature(oEnemy))
                {
                    string sDeityEnemy = GetDeity(oEnemy);

                    if (sDeityEnemy != sDeity)
                    {
                        if (GetIsPC(oEnemy))
                        {
                            nDamage        = d6(FloatToInt(fPiety) * nHitDice / 100);
                            nResistance    = fPietyEnemy < 1.0 ?
                                             0 : d6(FloatToInt(fPietyEnemy) * GetHitDice(oEnemy) / 100);
                        }
                        else
                        {
                            nDamage        = d6(FloatToInt(fPiety));
                            nResistance    = FloatToInt(gsWOGetPiety(oEnemy)) < 20 ?
                                             d6(20) : d6(FloatToInt(gsWOGetPiety(oEnemy)));
                        }

                        //visual effect
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual1, oEnemy);

                        if (nResistance < nDamage)
                        {
                            FloatingTextStringOnCreature(GS_T_16777481, oEnemy, FALSE);

                            //apply damage
                            DelayCommand(
                                1.0,
                                ApplyEffectToObject(
                                    DURATION_TYPE_INSTANT,
                                    EffectLinkEffects(
                                        eVisual2,
                                        EffectDamage(
                                            nDamage - nResistance,
                                            DAMAGE_TYPE_DIVINE,
                                            DAMAGE_POWER_ENERGY)),
                                    oEnemy));
                        }
                        else
                        {
                            FloatingTextStringOnCreature(GS_T_16777480, oEnemy, FALSE);
                        }

                        nFlag = TRUE;
                        nNth++;
                    }
                }

                if (nNth >= 3) break; //affects a maximum of 3 creatures

                oEnemy = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocation, TRUE);
            }
        }

        if (nFlag)
        {
            gsWOAdjustPiety(oTarget, -GS_WO_COST_GREATER_FAVOR);
            FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777285, sDeity), oTarget, FALSE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                EffectVisualEffect(VFX_FNF_LOS_HOLY_20),
                                oTarget);

            //apply penalty
            if (GetIsInCombat(oTarget))
            {
                gsXPApplyDeathPenalty(oTarget, nHitDice * GS_WO_PENALTY_PER_LEVEL, TRUE);
            }

            return TRUE;
        }
    }

    //lesser favor
    if (fPiety >= GS_WO_COST_LESSER_FAVOR)
    {
        //state
        if (gsSTGetState(GS_ST_FOOD, oTarget)  <= 0.0) gsSTAdjustState(GS_ST_FOOD,  25.0);
        if (gsSTGetState(GS_ST_WATER, oTarget) <= 0.0) gsSTAdjustState(GS_ST_WATER, 25.0);
        if (gsSTGetState(GS_ST_REST, oTarget)  <= 0.0) gsSTAdjustState(GS_ST_REST,  25.0);

        //ability
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_CHARISMA, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_CONSTITUTION, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_DEXTERITY, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_INTELLIGENCE, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_STRENGTH, Random(3)),
                            oTarget,
                            600.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                            EffectAbilityIncrease(ABILITY_WISDOM, Random(3)),
                            oTarget,
                            600.0);

        gsWOAdjustPiety(oTarget, -GS_WO_COST_LESSER_FAVOR);
        FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777286, sDeity), oTarget, FALSE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectVisualEffect(VFX_FNF_LOS_HOLY_10),
                            oTarget);
        return TRUE;
    }

    FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777287, sDeity), oTarget, FALSE);
    return FALSE;
}
//----------------------------------------------------------------
int gsWOGrantBoon(object oTarget = OBJECT_SELF)
{
    int GS_WO_TIMEOUT_BOON = 43200; //12 hours
    float GS_WO_COST_BOON  =    25.0f;

    float fPiety = gsWOGetPiety(oTarget);

    string sDeity  = GetDeity(oTarget);
    if (sDeity == "")                                            return FALSE;
    int nTimestamp = gsTIGetActualTimestamp();
    if (GetLocalInt(oTarget, "GS_WO_TIMEOUT_BOON") > nTimestamp) return FALSE;
    SetLocalInt(oTarget, "GS_WO_TIMEOUT_BOON", nTimestamp + GS_WO_TIMEOUT_BOON);
    if (IntToFloat(Random(100)) >= fPiety)                       return FALSE;
    if (Random(100) < 5)                                         return FALSE;
    if (fPiety < GS_WO_COST_BOON)                                return FALSE;

    gsWOAdjustPiety(oTarget, -GS_WO_COST_BOON);
    return TRUE;
}
//----------------------------------------------------------------
int gsWOGrantResurrection(object oTarget = OBJECT_SELF)
{

    string sDeity  = GetDeity(oTarget);
    int nAspect = gsWOGetDeityAspect(oTarget);
    if (!(nAspect & ASPECT_HEARTH_HOME) &&
        !(nAspect & ASPECT_NATURE) &&
        !(nAspect & ASPECT_WAR_DESTRUCTION)) return FALSE;

    if (!GetIsDead(oTarget))                                    return FALSE;
    if (!gsWOGrantBoon(oTarget)) return FALSE;

    ApplyResurrection(oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectHeal(GetMaxHitPoints(oTarget) + 10),
                        oTarget);
    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
            ExtraordinaryEffect(
                EffectLinkEffects(
                    EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE),
                    EffectLinkEffects(
                        EffectVisualEffect(VFX_DUR_SANCTUARY),
                        EffectEthereal()))),
        oTarget,
        12.0);

    FloatingTextStringOnCreature(gsCMReplaceString(GS_T_16777288, sDeity), oTarget, FALSE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
                        EffectVisualEffect(VFX_FNF_LOS_HOLY_30),
                        oTarget);

    return TRUE;
}
//----------------------------------------------------------------
void gsWOConsecrate(object oPC, object oAltar)
{
   float fPiety = gsWOGetPiety(oPC);

   int nPCDeity = gsWOGetDeityByName(GetDeity(oPC));
   int nAltarDeity = StringToInt(GetLocalString(oAltar, "GS_WO_DEITY"));

   if (nAltarDeity && (nPCDeity != nAltarDeity))
   {
     FloatingTextStringOnCreature("You can only reconsecrate an altar belonging to your deity.", oPC, FALSE);
     return;
   }

   if (fPiety < 20.0f)
   {
     FloatingTextStringOnCreature("You do not have enough piety to consecrate this altar.", oPC, FALSE);
     return;
   }

   gsFXSetLocalString(oAltar, "GS_WO_DEITY", IntToString(nPCDeity));
   gsFXSetLocalString(oAltar, "GS_WO_DESECRATED", "0");
   gsWOAdjustPiety(oPC, -20.0f);
}
//----------------------------------------------------------------
void gsWODesecrate(object oPC, object oAltar)
{
   float fPiety = gsWOGetPiety(oPC);

   if (fPiety < 5.0f)
   {
     FloatingTextStringOnCreature("You do not have enough piety to desecrate this altar.", oPC, FALSE);
     return;
   }

   // Random chance of deity smite.
   if (d20() == 1)
   {
     FloatingTextStringOnCreature("You have incurred the wrath of " +
        gsWOGetNameByDeity(gsWOGetConsecratedDeity(oAltar)) + "!", oPC, FALSE);
     ApplyEffectToObject(DURATION_TYPE_INSTANT,
                         EffectVisualEffect(VFX_FNF_GREATER_RUIN),
                         oPC);
     DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT,
                                           EffectDamage(d6(35), DAMAGE_TYPE_DIVINE),
                                           oPC));
   }

   // Hostile nearby NPCs.
   int nNth = 1;
   object oNPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                                    PLAYER_CHAR_NOT_PC,
                                    oPC, nNth);
   while (GetIsObjectValid(oNPC) && GetDistanceBetween(oNPC, oPC) <= 20.0)
   {
     if (LineOfSightObject(oNPC, oPC))
     {
       AdjustReputation(oPC, oNPC, -100);

       // Use the DMFI trick of blinding an NPC so that they see the PC again
       // and trigger hostility.
       effect eInvis =EffectBlindness();
       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oNPC, 6.1);
     }

     nNth++;
     oNPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
                                    PLAYER_CHAR_NOT_PC,
                                    oPC, nNth);
   }


   gsFXSetLocalString(oAltar, "GS_WO_DESECRATED", "1");
   gsWOAdjustPiety(oPC, -5.0f);
}
//----------------------------------------------------------------
int gsWOGetConsecratedDeity(object oAltar)
{
  int nDeity = StringToInt(GetLocalString(oAltar, "GS_WO_DEITY"));
  if (!nDeity) {
    // check for an INT variable as well (used on permanent altars in the toolset)
    nDeity = GetLocalInt(oAltar, "GS_WO_DEITY");
  }
  if (!nDeity) nDeity = GS_WO_NONE;

  return nDeity;
}
//----------------------------------------------------------------
int gsWOGetIsDesecrated(object oAltar)
{
  return StringToInt(GetLocalString(oAltar, "GS_WO_DESECRATED"));
}
//----------------------------------------------------------------
int nGlobalCategory = 0;
int nGlobalNth = 0;
//----------------------------------------------------------------
void gsWOAddDeity(int nDeity, string sAlignments, int nAspect, int nRacialType)
{
    __gsWOInitCacheItem();
    string sCat   = IntToString(nGlobalCategory);
    string sNth   = IntToString(++nGlobalNth);
    string sDeity = IntToString(nDeity);
    SetLocalInt(oWOCacheItem, "FB_WO_DEITY_"+sCat+"_"+sNth, nDeity);
    SetLocalString(oWOCacheItem, "FB_WO_PORTFOLIO_"+sCat+"_"+sNth, gsWOGetPortfolio(nDeity));
    SetLocalString(oWOCacheItem, "FB_WO_ALIGNMENTS_"+sDeity, sAlignments);
    SetLocalInt(oWOCacheItem, "FB_WO_ASPECT_"+sDeity, nAspect);
    SetLocalInt(oWOCacheItem, "FB_WO_RACE_"+sDeity, nRacialType);
}
//----------------------------------------------------------------
int gsWOGetRacialType(int nDeity)
{
  __gsWOInitCacheItem();
  return (GetLocalInt(oWOCacheItem, "FB_WO_RACE_" + IntToString(nDeity)));
}
//----------------------------------------------------------------
int gsWOGetIsRacialTypeAllowed(int nDeity, object oPlayer)
{
    int nRacialType = gsWOGetRacialType(nDeity);
    int nSubRace = gsSUGetSubRaceByName(GetSubRace(oPlayer));
    //don't allow people to change deity if they're under polymorph.
    //given polymorph has the ability to change race.
    if (gsC2GetHasEffect(EFFECT_TYPE_POLYMORPH, oPlayer, TRUE) && nRacialType != RACIAL_TYPE_ALL)
    {
        SendMessageToPC(oPlayer, "You cannot change deity to racial deities while polymorphed.");
        return FALSE;
    }
    switch (nRacialType)
    {
      case RACIAL_TYPE_ALL: break;
      case RACIAL_TYPE_DWARF:
      case RACIAL_TYPE_GNOME:
        if (GetRacialType(oPlayer) != nRacialType) return FALSE;
        break;
      case RACIAL_TYPE_HALFLING:
        if (GetRacialType(oPlayer) != nRacialType ||
            nSubRace == GS_SU_SPECIAL_GOBLIN ||
            nSubRace == GS_SU_SPECIAL_KOBOLD ||
            nSubRace == GS_SU_SPECIAL_FEY ||
            nSubRace == GS_SU_SPECIAL_IMP) return FALSE;
         break;
      case RACIAL_TYPE_ELF:
        if (GetRacialType(oPlayer) != nRacialType &&
            GetRacialType(oPlayer) != RACIAL_TYPE_HALFELF ||
            nSubRace == GS_SU_SPECIAL_HOBGOBLIN ||
            nSubRace == GS_SU_DEEP_IMASKARI) return FALSE;
         break;
      case RACIAL_TYPE_HUMAN:
        if ((GetRacialType(oPlayer) != nRacialType &&
             GetRacialType(oPlayer) != RACIAL_TYPE_HALFELF &&
             GetRacialType(oPlayer) != RACIAL_TYPE_HALFORC) ||
            nSubRace == GS_SU_HALFORC_OROG ||
            nSubRace == GS_SU_FR_OROG ||
            nSubRace == GS_SU_HALFORC_GNOLL ||
            nSubRace == GS_SU_SPECIAL_OGRE ||
            nSubRace == GS_SU_SPECIAL_HOBGOBLIN) return FALSE;
         break;
      case RACIAL_TYPE_FEY:
         if (nSubRace != GS_SU_SPECIAL_FEY) return FALSE;
         break;
      case RACIAL_TYPE_HUMANOID_GOBLINOID:
         if (nSubRace != GS_SU_SPECIAL_GOBLIN &&
             nSubRace != GS_SU_SPECIAL_HOBGOBLIN) return FALSE;
         break;
      case RACIAL_TYPE_HUMANOID_REPTILIAN:
         if (nSubRace != GS_SU_SPECIAL_KOBOLD &&
             nSubRace != GS_SU_SPECIAL_DRAGON) return FALSE;
         break;
      case RACIAL_TYPE_HUMANOID_ORC:
         if (GetRacialType(oPlayer) != RACIAL_TYPE_HALFORC ||
             nSubRace == GS_SU_HALFORC_GNOLL ||
             nSubRace == GS_SU_SPECIAL_OGRE) return FALSE;
         break;
      case RACIAL_TYPE_HUMANOID_MONSTROUS:
         if (nSubRace != GS_SU_HALFORC_GNOLL &&
             nSubRace != GS_SU_SPECIAL_OGRE) return FALSE;
         break;
    }


    return TRUE;
}
//----------------------------------------------------------------
string gsWOGetAlignments(int nDeity)
{
  __gsWOInitCacheItem();
  return (GetLocalString(oWOCacheItem, "FB_WO_ALIGNMENTS_" + IntToString(nDeity)));
}
//----------------------------------------------------------------
int gsWOGetAspect(int nDeity)
{
  __gsWOInitCacheItem();
  return (GetLocalInt(oWOCacheItem, "FB_WO_ASPECT_" + IntToString(nDeity)));
}
//----------------------------------------------------------------
int gsWOGetDeityAspect(object oPC)
{
  // Harper override.
  if (GetLocalInt(gsPCGetCreatureHide(oPC), VAR_HARPER) == MI_CL_HARPER_PRIEST &&
      GetLevelByClass(CLASS_TYPE_HARPER, oPC) > 4)
  {
    return ASPECT_WAR_DESTRUCTION &
           ASPECT_HEARTH_HOME &
           ASPECT_KNOWLEDGE_INVENTION &
           ASPECT_TRICKERY_DECEIT &
           ASPECT_NATURE &
           ASPECT_MAGIC;
  }
  else
  {
    return gsWOGetAspect(gsWOGetDeityByName(GetDeity(oPC)));
  }
}
//----------------------------------------------------------------
void gsWOSetup()
{
    __gsWOInitCacheItem();
    if (GetLocalInt(oWOCacheItem, "FB_WO_SETUP")) return;

    gsWOChangeCategory(FB_WO_CATEGORY_MAJOR);
    gsWOAddDeity(1, "CN,NN,LN,NE", ASPECT_NATURE+ ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_ALL); //Akadi
    gsWOAddDeity(4, "LN,LE,NE", ASPECT_WAR_DESTRUCTION + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_ALL); //Bane
    gsWOAddDeity(6, "CG,LG,NN,NG", ASPECT_HEARTH_HOME + ASPECT_NATURE, RACIAL_TYPE_ALL); //Chauntea
    gsWOAddDeity(61, "CG,CN,NG", ASPECT_HEARTH_HOME + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ELF); //Corellon Larethian
    gsWOAddDeity(7, "CE,CN,NE", ASPECT_TRICKERY_DECEIT + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Cyric
    gsWOAddDeity(62, "LG,LN,NG", ASPECT_HEARTH_HOME + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_GNOME); //Garl Glittergold
    gsWOAddDeity(15, "CN,NN,NE,NG,LN", ASPECT_NATURE + ASPECT_HEARTH_HOME, RACIAL_TYPE_ALL); //Grumbar
    gsWOAddDeity(20, "CN,NN,NE,NG,LN", ASPECT_NATURE + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Istishia
    gsWOAddDeity(22, "LE,LG,LN", ASPECT_HEARTH_HOME + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Kelemvor
    gsWOAddDeity(23, "CN,LE,LG,LN,NN,NE,NG", ASPECT_NATURE + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Kossuth
    gsWOAddDeity(24, "CG,LG,NG", ASPECT_HEARTH_HOME + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_ALL); //Lathander 
    gsWOAddDeity(33, "CG,LE,LG,LN,NG", ASPECT_MAGIC + ASPECT_HEARTH_HOME, RACIAL_TYPE_ALL); //Mystra
    gsWOAddDeity(60, "LG,LN,NG", ASPECT_KNOWLEDGE_INVENTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_DWARF);//Moradin
    gsWOAddDeity(35, "LG,NG,CG,LN,NN,CN,LE,NE,CE", ASPECT_KNOWLEDGE_INVENTION + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_ALL); //Oghma
    gsWOAddDeity(39, "CE,LE,NE", ASPECT_MAGIC + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_ALL); //Shar
    gsWOAddDeity(44, "CN,LN,NN,NE,NG", ASPECT_NATURE + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Silvanus
    gsWOAddDeity(45, "CG,CN,NG", ASPECT_HEARTH_HOME + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_ALL); //Sune
    gsWOAddDeity(47, "CE,CN,NE", ASPECT_NATURE + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Talos
    gsWOAddDeity(48, "CE,CG,CN", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_ALL); //Tempus
    gsWOAddDeity(52, "LG,LN,NG", ASPECT_WAR_DESTRUCTION + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_ALL); //Tyr
    gsWOAddDeity(53, "CN,NN,NE,NG,LN", ASPECT_NATURE  +ASPECT_HEARTH_HOME, RACIAL_TYPE_ALL); //Ubtao
    gsWOAddDeity(63, "LG,LN,NG", ASPECT_HEARTH_HOME + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_HALFLING); //Yondalla
    gsWOAddDeity(64, "CG,CN,NG", ASPECT_HEARTH_HOME + ASPECT_NATURE, RACIAL_TYPE_ELF); //Angharradh
    gsWOAddDeity(65, "LG,LN,NG", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_HUMAN); //Horus-Re
    gsWOAddDeity(66, "CE,CN,NE", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_HUMANOID_ORC); //Gruumsh
    gsWOAddDeity(67, "LE,LN,NE", ASPECT_WAR_DESTRUCTION + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_HUMANOID_GOBLINOID); //Maglubiyet
    gsWOAddDeity(68, "NG,CG,CN", ASPECT_MAGIC + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_FEY); //Titania
    gsWOAddDeity(136, "", ASPECT_NATURE + ASPECT_MAGIC, RACIAL_TYPE_ALL); //Toril


    gsWOChangeCategory(FB_WO_CATEGORY_INTERMEDIATE);
    gsWOAddDeity(5, "CE,CN,NE", ASPECT_TRICKERY_DECEIT + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Beshaba
    gsWOAddDeity(14, "LG,NG,CG,LN,NN,CN,LE,NE,CE", ASPECT_KNOWLEDGE_INVENTION + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_ALL); //Gond
    gsWOAddDeity(17, "LE,LG,LN", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_ALL); //Helm
    gsWOAddDeity(19, "LG,LN,NG", ASPECT_HEARTH_HOME + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Ilmater
    gsWOAddDeity(26, "CE,CN,NE", ASPECT_TRICKERY_DECEIT + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ELF); //Lolth
    gsWOAddDeity(31, "CG,LG,NG", ASPECT_NATURE + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Mielikki
    gsWOAddDeity(38, "CG,CN,NG", ASPECT_HEARTH_HOME + ASPECT_MAGIC, RACIAL_TYPE_ALL); //Selune
    gsWOAddDeity(51, "CG,CN,NG", ASPECT_HEARTH_HOME + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_ALL); //Tymora
    gsWOAddDeity(55, "CE,CN,NE", ASPECT_WAR_DESTRUCTION + ASPECT_NATURE, RACIAL_TYPE_ALL); //Umberlee
    gsWOAddDeity(69, "CE,NE,LE", ASPECT_TRICKERY_DECEIT + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_DWARF); //Abbathor
    gsWOAddDeity(70, "LG,LN,NG", ASPECT_HEARTH_HOME + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_DWARF); //Berronar Truesilver
    gsWOAddDeity(71, "LG,LN,NG", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_DWARF); //Clangeddin Silverbeard
    gsWOAddDeity(72, "CN,NN,NE,NG,LN", ASPECT_KNOWLEDGE_INVENTION + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_DWARF); //Dumathoin
    gsWOAddDeity(73, "LE,LN,NE", ASPECT_KNOWLEDGE_INVENTION + ASPECT_MAGIC, RACIAL_TYPE_DWARF); //Laduger
    gsWOAddDeity(74, "CG,CN,NG", ASPECT_HEARTH_HOME + ASPECT_NATURE, RACIAL_TYPE_DWARF); //Sharindlar
    gsWOAddDeity(75, "CN,NN,NE,NG,LN", ASPECT_TRICKERY_DECEIT + ASPECT_HEARTH_HOME, RACIAL_TYPE_DWARF); //Vergadain
    gsWOAddDeity(76, "CG,CN,NG", ASPECT_HEARTH_HOME + ASPECT_NATURE, RACIAL_TYPE_ELF); //Aerdrie Faenya
    gsWOAddDeity(77, "CG,CN,NG", ASPECT_HEARTH_HOME + ASPECT_NATURE, RACIAL_TYPE_ELF); //Deep Sashelas
    gsWOAddDeity(78, "CE,CG,CN", ASPECT_TRICKERY_DECEIT + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ELF); //Erevan Ilesere
    gsWOAddDeity(79, "CG,CN,NG", ASPECT_HEARTH_HOME + ASPECT_MAGIC, RACIAL_TYPE_ELF); //Hanali Celanil
    gsWOAddDeity(80, "CG,CN,NG", ASPECT_KNOWLEDGE_INVENTION + ASPECT_MAGIC, RACIAL_TYPE_ELF); //Labelas Enoreth
    gsWOAddDeity(81, "CG,CN,NG", ASPECT_NATURE + ASPECT_HEARTH_HOME, RACIAL_TYPE_ELF); //Rillifane Rallathil
    gsWOAddDeity(82, "CG,CN,NG", ASPECT_MAGIC + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_ELF); //Sehanine Moonbow
    gsWOAddDeity(83, "CG,CN,NG", ASPECT_NATURE + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ELF); //Solonor Thelandira
    gsWOAddDeity(84, "CG,LG,NG", ASPECT_NATURE + ASPECT_HEARTH_HOME, RACIAL_TYPE_GNOME); //Baervan Wildwanderer
    gsWOAddDeity(85, "CN,NN,NE,NG,LN", ASPECT_HEARTH_HOME + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_GNOME); //Callarduran Smoothhands
    gsWOAddDeity(86, "CG,LG,NG", ASPECT_KNOWLEDGE_INVENTION + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_GNOME); //Flandal Steelskin
    gsWOAddDeity(87, "CG,LG,NG", ASPECT_NATURE + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_GNOME); //Segojan Earthcaller
    gsWOAddDeity(88, "CE,CN,NE", ASPECT_WAR_DESTRUCTION + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_GNOME); //Urdlen
    gsWOAddDeity(89, "LG,LN,NG", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_HALFLING); //Arvoreen
    gsWOAddDeity(90, "LG,LN,NG", ASPECT_HEARTH_HOME + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_HALFLING); //Cyrrollalee
    gsWOAddDeity(91, "CN,NN,NE,NG,LN", ASPECT_NATURE + ASPECT_HEARTH_HOME, RACIAL_TYPE_HALFLING); //Sheela Peryroyl
    gsWOAddDeity(92, "CN,NN,CE,CG", ASPECT_HEARTH_HOME + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_HALFLING); //Dallah Thaun
    gsWOAddDeity(93, "CG,LG,NG", ASPECT_MAGIC + ASPECT_NATURE, RACIAL_TYPE_HUMAN); //Isis
    gsWOAddDeity(94, "CG,CN,NG", ASPECT_HEARTH_HOME + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_HUMAN); //Nephthys
    gsWOAddDeity(95, "LG,LN,NG", ASPECT_NATURE + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_HUMAN); //Osiris
    gsWOAddDeity(96, "LE,LN,NE", ASPECT_WAR_DESTRUCTION + ASPECT_MAGIC, RACIAL_TYPE_HUMAN); //Set
    gsWOAddDeity(97, "CN,NN,NE,NG,LN", ASPECT_MAGIC + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_HUMAN); //Thoth
    gsWOAddDeity(98, "CG,NG,CN", ASPECT_TRICKERY_DECEIT + ASPECT_MAGIC, RACIAL_TYPE_FEY); //Nathair Sgiathach
    gsWOAddDeity(99, "CE,NE,CN", ASPECT_MAGIC + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_FEY); //Queen of Air and Darkness
    gsWOAddDeity(153, "LN,LE,NE", ASPECT_MAGIC + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_HUMANOID_REPTILIAN); //Kurtulmak
    gsWOAddDeity(154, "LN,N,CN,LE,NE,CE", ASPECT_TRICKERY_DECEIT + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Bhaal

    gsWOChangeCategory(FB_WO_CATEGORY_LESSER);
    gsWOAddDeity(2, "LN,CN,NE", ASPECT_NATURE + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Auril
    gsWOAddDeity(3, "LE,LG,LN", ASPECT_MAGIC + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_ALL); //Azuth
    gsWOAddDeity(137, "LG,LN,NG", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_HUMANOID_REPTILIAN); //Bahamut
    gsWOAddDeity(8, "CG,LG,NG", ASPECT_KNOWLEDGE_INVENTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_ALL); //Deneir
    gsWOAddDeity(9, "CG,CN,NG", ASPECT_HEARTH_HOME + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ELF); //Eilistraee
    gsWOAddDeity(10, "CG,CN,NG", ASPECT_NATURE + ASPECT_HEARTH_HOME, RACIAL_TYPE_ALL); //Eldath
    gsWOAddDeity(25, "CG,CN,NG", ASPECT_HEARTH_HOME + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_ALL); //Lliira
    gsWOAddDeity(27, "LE,LN,NE", ASPECT_WAR_DESTRUCTION + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_ALL); //Loviatar
    gsWOAddDeity(29, "CE,CN,NE", ASPECT_NATURE + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Malar
    gsWOAddDeity(30, "CE,LE,NE", ASPECT_TRICKERY_DECEIT + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_ALL); //Mask
    gsWOAddDeity(32, "CG,LG,NG", ASPECT_KNOWLEDGE_INVENTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_ALL); //Milil
    gsWOAddDeity(41, "CE,CG,CN", ASPECT_NATURE + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_ALL); //Shaundakul
    gsWOAddDeity(46, "CE,CN,NE", ASPECT_NATURE + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_ALL); //Talona
    gsWOAddDeity(49, "LN,LE,NE", ASPECT_HEARTH_HOME + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_HUMANOID_REPTILIAN); //Tiamat
    gsWOAddDeity(50, "LG,LN,NG", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_ALL); //Torm
    gsWOAddDeity(59, "CN,LN,NN,NE,NG", ASPECT_KNOWLEDGE_INVENTION + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_ALL); // Waukeen
    gsWOAddDeity(101, "CE,CN,NE", ASPECT_WAR_DESTRUCTION + ASPECT_NATURE, RACIAL_TYPE_ALL); //Ghaunadaur
    gsWOAddDeity(102, "CE,CN,NE", ASPECT_TRICKERY_DECEIT + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ELF); //Vhaeraun
    gsWOAddDeity(103, "CG,CN,NG", ASPECT_KNOWLEDGE_INVENTION + ASPECT_MAGIC, RACIAL_TYPE_DWARF); //Dugmaren Brightmantle 
    gsWOAddDeity(104, "LG,NG,LN", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_DWARF); //Gorm Gulthyn
    gsWOAddDeity(105, "CG,LG,NG", ASPECT_NATURE + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_DWARF); //Marthammor Duin
    gsWOAddDeity(106, "CG,CN,NG", ASPECT_NATURE + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_DWARF); //Thard Harr
    gsWOAddDeity(107, "CE,CG,CN", ASPECT_NATURE + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_ELF); //Fenmarel Mestarine
    gsWOAddDeity(108, "CG,LG,NG", ASPECT_TRICKERY_DECEIT + ASPECT_MAGIC, RACIAL_TYPE_GNOME); //Baravar Cloakshadow
    gsWOAddDeity(109, "LG,LN,NG", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_GNOME); //Gaerdal Ironhand
    gsWOAddDeity(110, "CN,NN,NE,NG,LN", ASPECT_TRICKERY_DECEIT + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_HALFLING); //Brandobaris
    gsWOAddDeity(111, "CG,CN,NG", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_HUMAN); // Anhur
    gsWOAddDeity(112, "CN,NN,NE,NG,LN", ASPECT_KNOWLEDGE_INVENTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_HUMAN); //Geb
    gsWOAddDeity(113, "CG,LG,NG", ASPECT_HEARTH_HOME + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_HUMAN); //Hathor
    gsWOAddDeity(114, "CE,CN,NE", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_HUMANOID_ORC); //Bahgtru
    gsWOAddDeity(115, "CN,LN,NE", ASPECT_WAR_DESTRUCTION + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_HUMANOID_ORC); //Ilneval
    gsWOAddDeity(116, "CN,LN,NE", ASPECT_HEARTH_HOME + ASPECT_MAGIC, RACIAL_TYPE_HUMANOID_ORC); //Luthic
    gsWOAddDeity(117, "CE,CN,NE", ASPECT_TRICKERY_DECEIT + ASPECT_MAGIC, RACIAL_TYPE_HUMANOID_ORC); //Shargaas
    gsWOAddDeity(118, "CN,LN,NE", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_HUMANOID_ORC); //Yurtrus
    gsWOAddDeity(120, "LN,LE,NE", ASPECT_HEARTH_HOME + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_HUMANOID_GOBLINOID); //Bargrivyek
    gsWOAddDeity(121, "LN,LE,NE", ASPECT_WAR_DESTRUCTION + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_HUMANOID_GOBLINOID); //Khurgorbaeyag
    gsWOAddDeity(122, "NN,LN,CN,NE,NG", ASPECT_NATURE + ASPECT_HEARTH_HOME,  RACIAL_TYPE_HUMANOID_GOBLINOID); //Kikanuti
    gsWOAddDeity(123, "NG,CG,NN", ASPECT_HEARTH_HOME + ASPECT_NATURE, RACIAL_TYPE_FEY); //Oberon
    gsWOAddDeity(124, "NG,CG,NN", ASPECT_HEARTH_HOME + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_FEY); //Verenestra
    gsWOAddDeity(152, "CE,CN,NE", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_HUMANOID_MONSTROUS); //Vaprak

    gsWOChangeCategory(FB_WO_CATEGORY_DEMIGOD);
    gsWOAddDeity(11, "CE,CG,CN", ASPECT_KNOWLEDGE_INVENTION + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Finder Wyvernspur
    gsWOAddDeity(12, "CE,CG,CN", ASPECT_WAR_DESTRUCTION + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_ALL); //Garagos
    gsWOAddDeity(13, "LE,LN,NE", ASPECT_TRICKERY_DECEIT + ASPECT_MAGIC, RACIAL_TYPE_ALL); //Gargauth
    gsWOAddDeity(16, "CG,LG,NG", ASPECT_NATURE + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Gwaeron Windstrom
    gsWOAddDeity(18, "LE,LG,LN", ASPECT_WAR_DESTRUCTION +  ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_ALL); //Hoar
    gsWOAddDeity(21, "LE,LG,LN", ASPECT_KNOWLEDGE_INVENTION +  ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Jergal
    gsWOAddDeity(28, "CG,CN,NG", ASPECT_NATURE + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_ALL); //Lurue
    gsWOAddDeity(34, "LG,LN,NG", ASPECT_NATURE + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Nobanion
    gsWOAddDeity(36, "LE,LG,LN", ASPECT_KNOWLEDGE_INVENTION + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Red Knight
    gsWOAddDeity(37, "LE,LG,LN", ASPECT_MAGIC + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_ALL); //Savras
    gsWOAddDeity(40, "CG,CN,NG", ASPECT_HEARTH_HOME + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_ALL); //Sharess
    gsWOAddDeity(42, "CG,LG,NG", ASPECT_NATURE + ASPECT_HEARTH_HOME, RACIAL_TYPE_ALL); //Shiallia
    gsWOAddDeity(43, "LE,LG,LN", ASPECT_HEARTH_HOME + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_ALL); //Siamorphe
    gsWOAddDeity(54, "LE,LG,LN", ASPECT_NATURE + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Ulutiu
    gsWOAddDeity(56, "CG,CE,CN,NN,NG", ASPECT_WAR_DESTRUCTION + ASPECT_NATURE, RACIAL_TYPE_ALL); //Uthgar
    gsWOAddDeity(57, "CG,CN,NG", ASPECT_HEARTH_HOME + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL); //Valkur
    gsWOAddDeity(58, "LE,NE,CE", ASPECT_MAGIC + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_ALL); //Velsharoon
    gsWOAddDeity(125, "CE,CN,NE", ASPECT_MAGIC + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ELF); //Kiaransalee
    gsWOAddDeity(126, "CE,CN,NE", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_ELF); //Selvetarm
    gsWOAddDeity(127, "LE,LN,NE", ASPECT_WAR_DESTRUCTION + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_DWARF); //Deep Duerra
    gsWOAddDeity(128, "CG,CN,NG", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_DWARF); //Haela Brightaxe
    gsWOAddDeity(129, "CE,CG,CN", ASPECT_WAR_DESTRUCTION + ASPECT_TRICKERY_DECEIT, RACIAL_TYPE_ELF); //Shevarash
    gsWOAddDeity(130, "LE,LG,LN", ASPECT_HEARTH_HOME + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_HALFLING); //Urogalan
    gsWOAddDeity(131, "CN,LN,NE", ASPECT_NATURE + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_HUMAN); //Sebek
    gsWOAddDeity(132, "CE,CN,NE", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_HUMANOID_MONSTROUS); //Yeenoghu
    gsWOAddDeity(133, "CE,CN,NE", ASPECT_WAR_DESTRUCTION + ASPECT_NATURE, RACIAL_TYPE_HUMANOID_MONSTROUS); //Gorellik
    gsWOAddDeity(134, "CE,CN,NE,NN", ASPECT_TRICKERY_DECEIT + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ELF); //Zinzerena
    gsWOAddDeity(135, "LE,NE,LN", ASPECT_TRICKERY_DECEIT + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_HUMANOID_REPTILIAN); //Gaknulak

    gsWOChangeCategory(FB_WO_CATEGORY_PLANAR);
    gsWOAddDeity(gsWOGetDeityByName("Bel"), "LN,LE,NE", ASPECT_WAR_DESTRUCTION + ASPECT_KNOWLEDGE_INVENTION, RACIAL_TYPE_ALL);
    gsWOAddDeity(gsWOGetDeityByName("Dispater"), "LN,LE,NE", ASPECT_TRICKERY_DECEIT + ASPECT_MAGIC, RACIAL_TYPE_ALL);
    gsWOAddDeity(gsWOGetDeityByName("Mammon"), "LN,LE,NE", ASPECT_TRICKERY_DECEIT + ASPECT_MAGIC, RACIAL_TYPE_ALL);
    gsWOAddDeity(gsWOGetDeityByName("Fierna"), "LN,LE,NE", ASPECT_TRICKERY_DECEIT + ASPECT_HEARTH_HOME, RACIAL_TYPE_ALL);
    gsWOAddDeity(gsWOGetDeityByName("Levistus"), "LN,LE,NE", ASPECT_TRICKERY_DECEIT + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL);
    gsWOAddDeity(gsWOGetDeityByName("Glasya"), "LN,LE,NE", ASPECT_TRICKERY_DECEIT + ASPECT_HEARTH_HOME, RACIAL_TYPE_ALL);
    gsWOAddDeity(gsWOGetDeityByName("Baalzebul"), "LN,LE,NE", ASPECT_TRICKERY_DECEIT + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL);
    gsWOAddDeity(gsWOGetDeityByName("Mephistopheles"), "LN,LE,NE", ASPECT_KNOWLEDGE_INVENTION + ASPECT_MAGIC, RACIAL_TYPE_ALL);
    gsWOAddDeity(gsWOGetDeityByName("Asmodeus"), "LN,LE,NE", ASPECT_TRICKERY_DECEIT + ASPECT_MAGIC, RACIAL_TYPE_ALL);
    gsWOAddDeity(gsWOGetDeityByName("Abyssal (magic)"), "CN,CE,NE", ASPECT_MAGIC + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL);
    gsWOAddDeity(gsWOGetDeityByName("Abyssal (war)"), "CN,CE,NE", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_ALL);
    gsWOAddDeity(gsWOGetDeityByName("Abyssal (trickery)"), "CN,CE,NE", ASPECT_TRICKERY_DECEIT + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_ALL);

    gsWOChangeCategory(FB_WO_CATEGORY_ARELITH);
    gsWOAddDeity(gsWOGetDeityByName("Oogooboogoo"), "CN,NN,NE,CE", ASPECT_HEARTH_HOME + ASPECT_WAR_DESTRUCTION, RACIAL_TYPE_HUMANOID_GOBLINOID);
    gsWOAddDeity(gsWOGetDeityByName("La'laskra"), "LE,NE,LN", ASPECT_WAR_DESTRUCTION + ASPECT_HEARTH_HOME, RACIAL_TYPE_ELF);

    SetLocalInt(oWOCacheItem, "FB_WO_SETUP", TRUE);
}

//----------------------------------------------------------------
void gsWOChangeCategory(int nCategory)
{
    nGlobalCategory = nCategory;
    nGlobalNth = 0;
}

