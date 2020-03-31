#include "inc_chatutils"
#include "inc_chat"
#include "zzdlg_lists_inc"
#include "inc_examine"
#include "inc_bloodstains"
#include "inc_craft"

const string HELP = "-investigate lets you study a bloodstain or fixture remains and work out details of the encounter that caused it.  A few areas of the module can also give you additional information from using this command.  It keys off Search and Lore.";
const int INVEST_BLOOD = 1;
const int INVEST_SECRET = 2;
const int INVEST_REMAINS = 3;
const int INVEST_NPC = 4;

void main()
{
  object oSpeaker = OBJECT_SELF;
  chatVerifyCommand(oSpeaker);
  if (chatGetParams(oSpeaker) == "?")
  {
    DisplayTextInExamineWindow("-investigate", HELP);
  }
  else
  {
    object oBlood = BMGetNearestBloodStain(oSpeaker);
    object oNPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, oSpeaker);
    object oInvestigation = GetNearestObjectByTag("Investigation", oSpeaker);
    object oRemains = GetNearestObjectByTag("GS_FX_gvd_it_remains", oSpeaker);

    // determine which investigate target is closest to the PC first, so people have more control over what to investigate
    int iClosest = 0;
    float fClosestDistance = 999.0f;
    float fDistance;
    if (GetIsObjectValid(oBlood)) {
      iClosest = INVEST_BLOOD;
      fClosestDistance = GetDistanceBetween(oBlood, oSpeaker);
    }
    if (GetIsObjectValid(oInvestigation)) {
      fDistance = GetDistanceBetween(oInvestigation, oSpeaker);
      if (fDistance < fClosestDistance) {
        iClosest = INVEST_SECRET;
        fClosestDistance =fDistance;
      }
    }
    if (GetIsObjectValid(oRemains)) {
      fDistance = GetDistanceBetween(oRemains, oSpeaker);
      if (fDistance < fClosestDistance) {
        iClosest = INVEST_REMAINS;
        fClosestDistance = fDistance;
      }
    }
    if (GetIsObjectValid(oNPC)) {
      fDistance = GetDistanceBetween(oNPC, oSpeaker);
      if (fDistance < fClosestDistance) {
        iClosest = INVEST_NPC;
        fClosestDistance = fDistance;
      }
    }

    // not within 5 feet of something?
    if (fClosestDistance > 5.0f) {
      iClosest = 0;
    }

    if (iClosest == INVEST_BLOOD)
    {
      AssignCommand( oSpeaker, ActionMoveToObject( oBlood, FALSE, 0.1 ) );
      AssignCommand( oSpeaker, SetFacingPoint( GetPositionFromLocation( GetLocation( oBlood ) ) ) );
      AssignCommand( oSpeaker, ActionPlayAnimation( ANIMATION_LOOPING_GET_LOW, 2.0, IntToFloat( d6( 6 ) ) ) );

      SendMessageToPC(oSpeaker, BMGetBloodStainDetails(oSpeaker, oBlood));
    }
    else if (iClosest == INVEST_SECRET)
    {
      // Investigation object.
      int nLore   = GetSkillRank(SKILL_LORE, oSpeaker);
      int nSearch = GetSkillRank(SKILL_SEARCH, oSpeaker);

      int nDC1 = GetLocalInt(oInvestigation, "DC_1");
      int nDC2 = GetLocalInt(oInvestigation, "DC_2");
      int nDC3 = GetLocalInt(oInvestigation, "DC_3");

      string sRes1 = GetLocalString(oInvestigation, "RESULT_1");
      string sRes2 = GetLocalString(oInvestigation, "RESULT_2");
      string sRes3 = GetLocalString(oInvestigation, "RESULT_3");

      if (nLore >= nDC1 && nSearch >= nDC1)
      {
        FloatingTextStringOnCreature("What's that?", oSpeaker);
        AssignCommand( oSpeaker, ActionMoveToObject( oInvestigation, FALSE, 0.1 ) );
        AssignCommand( oSpeaker, SetFacingPoint( GetPositionFromLocation( GetLocation( oInvestigation ) ) ) );
        AssignCommand( oSpeaker, ActionPlayAnimation( ANIMATION_LOOPING_GET_MID, 2.0, IntToFloat( d6( 6 ) ) ) );
		
        effect eVis = EffectVisualEffect(VFX_IMP_KNOCK);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oInvestigation);
      }

      if (nLore >= nDC1 && nSearch >= nDC1) SendMessageToPC(oSpeaker, sRes1);
      if (nLore >= nDC2 && nSearch >= nDC2) SendMessageToPC(oSpeaker, sRes2);
      if (nLore >= nDC3 && nSearch >= nDC3) SendMessageToPC(oSpeaker, sRes3);
    }
    else if (iClosest == INVEST_REMAINS)
    {
      // Investigation remains of a fixture
      int nLore   = GetSkillRank(SKILL_LORE, oSpeaker);
      int nSearch = GetSkillRank(SKILL_SEARCH, oSpeaker);

      // add the craftskill rank / 3 to both scores
      int nCraft = gsCRGetSkillRank(GetLocalInt(oRemains, "GS_SKILL"), oSpeaker) / 3;
      nLore = nLore + nCraft;
      nSearch = nSearch + nCraft;

      // same DCs for all fixture remains
      int nDC1 = 5;
      int nDC2 = 10;
      int nDC3 = 20;

      // in case of lightning strike, everyone can see this, and the other 2 clues don't make sense, so just make them impossible
      if (GetLocalString(oRemains, "RESULT_1") == "a lightning strike") {
        nDC1 = 0;
        nDC2 = 200;
        nDC3 = 200;
      }

      string sRes1 = "It looks like the damage done was " + GetLocalString(oRemains, "RESULT_1");  // damage type reveiled
      string sRes2 = "You find the tracks of a " + GetLocalString(oRemains, "RESULT_2");			// race reveiled
      string sRes3 = "Based on the size of the tracks you think it must have been a " + GetLocalString(oRemains, "RESULT_3");		// gender reveiled

      if (nLore >= nDC1 && nSearch >= nDC1)
      {
        FloatingTextStringOnCreature("You search through the remains", oSpeaker);
        AssignCommand( oSpeaker, ActionMoveToObject( oRemains, FALSE, 0.1 ) );
        AssignCommand( oSpeaker, SetFacingPoint( GetPositionFromLocation( GetLocation( oRemains ) ) ) );
        AssignCommand( oSpeaker, ActionPlayAnimation( ANIMATION_LOOPING_GET_MID, 2.0, IntToFloat( d6( 6 ) ) ) );
      } else {
        SendMessageToPC(oSpeaker, "You investigate the remains but gather no information on how the object was destroyed");        
      }

      if (nLore >= nDC1 && nSearch >= nDC1) SendMessageToPC(oSpeaker, sRes1);
      if (nLore >= nDC2 && nSearch >= nDC2) SendMessageToPC(oSpeaker, sRes2);
      if (nLore >= nDC3 && nSearch >= nDC3) SendMessageToPC(oSpeaker, sRes3);
    }
    else if (iClosest == INVEST_NPC)
    {
      int nNPCType;  // Internal var: 0 = animal language only, 1 = normal, 2 = no speech
      int bAnimal;

      switch (GetRacialType(oNPC))
      {
        case RACIAL_TYPE_ANIMAL:
        case RACIAL_TYPE_BEAST:
        case RACIAL_TYPE_MAGICAL_BEAST:
        case RACIAL_TYPE_ELEMENTAL:
        case RACIAL_TYPE_VERMIN:
          nNPCType = 0;
          bAnimal = 1;
          break;
        case RACIAL_TYPE_DRAGON:
        case RACIAL_TYPE_DWARF:
        case RACIAL_TYPE_ELF:
        case RACIAL_TYPE_FEY:
        case RACIAL_TYPE_GIANT:
        case RACIAL_TYPE_GNOME:
        case RACIAL_TYPE_HALFELF:
        case RACIAL_TYPE_HALFLING:
        case RACIAL_TYPE_HALFORC:
        case RACIAL_TYPE_HUMAN:
        case RACIAL_TYPE_HUMANOID_GOBLINOID:
        case RACIAL_TYPE_HUMANOID_MONSTROUS:
        case RACIAL_TYPE_HUMANOID_ORC:
        case RACIAL_TYPE_HUMANOID_REPTILIAN:
        case RACIAL_TYPE_OUTSIDER:
        case RACIAL_TYPE_SHAPECHANGER:
          nNPCType = 1;
          break;
        case RACIAL_TYPE_OOZE:
        case RACIAL_TYPE_UNDEAD:
          nNPCType = 2;
          break;
      }

      if (nNPCType==2)
      {
        SendMessageToPC(oSpeaker, GetName(oNPC) + " cannot be interrogated.");
        return;
      }
      else if (nNPCType==0)
      {
        if (!gsLAGetCanSpeakLanguage(GS_LA_LANGUAGE_ANIMAL, oSpeaker))
        {
          SendMessageToPC(oSpeaker, "You cannot interrogate " + GetName(oNPC) + "!");
          return;
        }
      }

      // checks done.
      AssignCommand( oSpeaker, ActionMoveToObject( oNPC, FALSE, 0.1 ) );
      AssignCommand( oSpeaker, SetFacingPoint( GetPositionFromLocation( GetLocation( oNPC ) ) ) );
      AssignCommand( oNPC, SetFacingPoint( GetPositionFromLocation( GetLocation( oSpeaker ) ) ) );

      string sPCText = "Who have you seen lately?";
      string sNPCText = "Let me see, I've seen: ";
      int nCurrentIndex = GetLocalInt(oNPC, "_MI_SEEN_LIST_INDEX");
      int nCount = GetElementCount("MI_SEEN_LIST", oNPC);

      // This is a rolling list.  While it's less than 20 long, 0 is the oldest
      // entry.  Once it's longer than 20, 1 above the current index is the
      // oldest entry.
      if (nCount < 20) nCurrentIndex = 0;
      else nCurrentIndex++;
      int nI = 0;

      while (nI < nCount)
      {
        if (nCurrentIndex == 20) nCurrentIndex = 0;
        sNPCText += GetStringElement(nCurrentIndex, "MI_SEEN_LIST", oNPC);


        nCurrentIndex++;
        nI++;
        if (nI < nCount) sNPCText += "; ";
        else sNPCText += ".";
      }

      if (bAnimal)
      {
        fbCHSwitchLanguage(GS_LA_LANGUAGE_ANIMAL, oSpeaker);
        fbCHSwitchLanguage(GS_LA_LANGUAGE_ANIMAL, oNPC);
        AssignCommand(oSpeaker,
                      ActionSpeakString(gsLATranslate(sPCText, GS_LA_LANGUAGE_ANIMAL)));
        DelayCommand(3.0,
                     AssignCommand(oNPC,
                                   ActionSpeakString(gsLATranslate(sNPCText, GS_LA_LANGUAGE_ANIMAL))));
         chatSpeakString(oSpeaker, NWNX_CHAT_CHANNEL_PLAYER_TALK, sPCText);
         DelayCommand(3.0, chatSpeakString(oNPC, NWNX_CHAT_CHANNEL_PLAYER_TALK, sNPCText));
      }
      else
      {
        AssignCommand(oSpeaker, ActionSpeakString(sPCText));
        DelayCommand(3.0, AssignCommand(oNPC, ActionSpeakString(sNPCText)));
      }
    }
    else
    {
      SendMessageToPC(oSpeaker, "No nearby bloodstain or remains to investigate, no NPC to question, and no nearby point of interest.");
    }
  }
}
