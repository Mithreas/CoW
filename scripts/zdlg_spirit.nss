/*
  Name: zdlg_spirit
  Author: Mithreas
  Date: Apr 30 2020
  Description: Spirit pacting/binding dialog. Uses Z-Dialog.

*/
#include "inc_divination"
#include "inc_pc"
#include "inc_zdlg"

const string MAIN_MENU = "spirit_options";
const string PAGE_MARK = "spirit_mark";

void Init()
{
  // Responses to greeting.
  DeleteList(MAIN_MENU);
  object oPC = GetPcDlgSpeaker();
  
  // Get PC Spellcraft and Persuade and Druid levels.
  int nDruid = GetLevelByClass(CLASS_TYPE_DRUID, oPC);
  int nPersuade = GetSkillRank(SKILL_PERSUADE, oPC, FALSE);
  int nSpellcraft = GetSkillRank(SKILL_SPELLCRAFT, oPC, FALSE);
  
  // Get elemental strength.
  int nStrength = GetLocalInt(OBJECT_SELF, "ATTUNEMENT_STRENGTH");
  
  int bBind = (nPersuade + nSpellcraft) >= ( 5 * nStrength);
  int bPact = (2 * nDruid + nPersuade) >= (5 * nStrength);
  
  if (bBind) AddStringElement("[Bind elemental]", MAIN_MENU);
  if (bPact) AddStringElement("[Pact elemental]", MAIN_MENU);
  AddStringElement("[Attune to this location]", MAIN_MENU);
  AddStringElement("[Leave it alone]", MAIN_MENU);
  
  if (GetElementCount(PAGE_MARK) == 0)
  {
    AddStringElement("[Attune]", PAGE_MARK);
    AddStringElement("[Leave]", PAGE_MARK);   
  }
}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();
  
  if (sPage == PAGE_MARK)
  {
    SetDlgPrompt("You can attune to this location, to return to later with the Teleport power or a Potion of Attunement."); 
	SetDlgResponseList(PAGE_MARK);
    return;
  }
  
  object oHide           = gsPCGetCreatureHide(oPC);
  
  int nAttunement  = GetLocalInt(OBJECT_SELF, "ATTUNEMENT");
  int nStrength    = GetLocalInt(OBJECT_SELF, "ATTUNEMENT_STRENGTH");
  string sStrength = "Minor";
  string sElement  = "";
  string sDescription = "";
  
  switch (nStrength)
  {
    case 10:
	case 9:
	case 8:
	  sStrength = "Greater";
	  break;
	case 7:
	case 6:
	case 5:
	case 4:
	  sStrength = "Medium";
	  break;
  }
  
  switch (nAttunement)
  {
    case SPELL_SCHOOL_EVOCATION:
	  sElement = "Fire";
	  sDescription = "Fire spirits are often drawn to creation, as well as to places where fire can thrive for long periods.  Their magic is that of Evocation.";
	  break;
	case SPELL_SCHOOL_TRANSMUTATION:
	  sElement = "Water";
	  sDescription = "Water spirits like to be free flowing, and are drawn to places and people that change often, especially Transmuters.";
	  break;
	case SPELL_SCHOOL_ILLUSION:
	  sElement = "Air";
	  sDescription = "Air spirits love trickery and deceit, including illusions and other forms of fakery.";
	  break;
	case SPELL_SCHOOL_ENCHANTMENT:
	  sElement = "Earth";
	  sDescription = "Earth spirits are often drawn to industry.  Their nature is that of form, and their magic that of Enchantment.";
	  break;
	case SPELL_SCHOOL_CONJURATION:
	  sElement = "Life";
	  sDescription = "Spirits of Life are drawn to healing and living creatures.  Their magic is that of Conjuration.";
	  break;
	case SPELL_SCHOOL_NECROMANCY:
	  sElement = "Death";
	  sDescription = "Spirits of Death are drawn to the dead and dying... and to those who deal death.  Hence they are often strongly drawn to Necromancers.";
	  break;
  }
  
  int nRank = miDVGetRelativeAttunement(oPC, sElement);
  switch (nRank)
  {
    case 0: sDescription += " This one recoils from you, as if repulsed by your very presence."; break;
	case 1:
	case 2: sDescription += " This one watches you warily, as if unsure what to make of you."; break;
	case 3:
	case 4: sDescription += " This one approaches you slowly, curious as to your nature."; break;
	case 5: sDescription += " This one draws near to you eagerly, drawn by your similar natures."; break;
  }

  if (sPage == "")
  {
    int nCurrentAttunement = GetLocalInt(oHide, "ATTUNEMENT");
    int nCurrentStrength   = GetLocalInt(oHide, "ATTUNEMENT_STRENGTH");
	
    SetDlgPrompt("[You have encountered a "+sStrength+" "+sElement+" elemental spirit! " + sDescription + "]\n\n[Its strength rating is " + IntToString(nStrength) +
	    ". If your Persuade and Spellcraft are high enough, you can bind it.  Or if your Persuade and Druid levels are high enough, " +
		"you can make a pact with it.  Either will give you access to its power." + 
		(nCurrentAttunement ? " This will replace your current pact or binding." : "") +
		"]");
    SetDlgResponseList(MAIN_MENU, OBJECT_SELF);
		
    switch (nCurrentAttunement)
    {
    case SPELL_SCHOOL_EVOCATION:
	  sElement = "Fire";
	  break;
	case SPELL_SCHOOL_TRANSMUTATION:
	  sElement = "Water";
	  break;
	case SPELL_SCHOOL_ILLUSION:
	  sElement = "Air";
	  break;
	case SPELL_SCHOOL_ENCHANTMENT:
	  sElement = "Earth";
	  break;
	case SPELL_SCHOOL_CONJURATION:
	  sElement = "Life";
	  break;
	case SPELL_SCHOOL_NECROMANCY:
	  sElement = "Death";
	  break;
    }
	
	if (nCurrentAttunement) SendMessageToPC(oPC, "Your current pact or binding is with " + sElement + " and strength " + IntToString(nCurrentStrength));
  }
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarrassing. Please report it.");
    EndDlg();
  }
}

void HandleSelection()
{
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  object oHide   = gsPCGetCreatureHide(oPC);
  string sPage   = GetDlgPageString();
  
  int nAttunement  = GetLocalInt(OBJECT_SELF, "ATTUNEMENT");
  int nStrength    = GetLocalInt(OBJECT_SELF, "ATTUNEMENT_STRENGTH");

  if (sPage == "")
  {
    if (GetStringElement(selection, MAIN_MENU) == "[Bind elemental]")
	{
	  SetLocalInt(oHide, "ATTUNEMENT", nAttunement);
	  SetLocalInt(oHide, "ATTUNEMENT_STRENGTH", nStrength);
	  SendMessageToPC(oPC, "You have successfully bound the elemental! You can now call upon its power as you travel.");
	}
	else if (GetStringElement(selection, MAIN_MENU) == "[Pact elemental]")
	{
	  SetLocalInt(oHide, "ATTUNEMENT", nAttunement);
	  SetLocalInt(oHide, "ATTUNEMENT_STRENGTH", nStrength);
	  SendMessageToPC(oPC, "You have successfully made a pact with the elemental! You can now call upon its power as you travel.");	
	}
	else if (GetStringElement(selection, MAIN_MENU) == "[Attune to this location]")
	{
	  SetDlgPageString(PAGE_MARK);
	  return;
	}
	else
	{
	  // Leave
	  SendMessageToPC(oPC, "You leave the spirit alone."); 
	}
	
	EndDlg();
  }	 
  else if (sPage == PAGE_MARK)
  {
    if (GetStringElement(selection, PAGE_MARK) == "[Attune]")
	{
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_COLD), GetLocation(oPC));
		SetLocalString(oHide, "ESF_TELEPORT_LOCATION", APSLocationToString(GetLocation(oPC)));
		FloatingTextStringOnCreature("You have set your mark here, and can return here as your will dictates.", oPC);	
    }
	
	EndDlg();
  }  
  else
  {
    SendMessageToPC(oPC,
                    "You've found a bug. How embarrassing. Please report it.");
    EndDlg();
  }
}

void main()
{
  int nEvent = GetDlgEventType();
  switch (nEvent)
  {
    case DLG_INIT:
      Init();
      break;
    case DLG_PAGE_INIT:
      PageInit();
      break;
    case DLG_SELECTION:
      HandleSelection();
      break;
    case DLG_ABORT:
    case DLG_END:
      break;
  }
}
