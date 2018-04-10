/*
  zdlg_messengers

  Z-Dialog conversation script for the Wharftown lasso capture buyer


*/
#include "fb_inc_chatutils"
#include "x0_i0_position"
#include "zdlg_include_i"
#include "gs_inc_pc"
#include "gvd_inc_rope"
#include "gvd_inc_adv_xp"

const string MAINOPTIONS = "MAINOPTIONS001";
const string CONFIRM = "MES_CONFIRM001";
const string DONE    = "MES_DONE001";
const string SELLPAYOPTIONS = "SELLPAYOPTIONS001";

const string PAGE_SELL_CAPTURED = "PAGE_SELL_CAPTURED001";
const string PAGE_SELL_CAPTURED_SUCCES = "PAGE_SELL_CAPTURED_SUCCES001";
const string PAGE_SELL_NO_DEAL = "PAGE_SELL_NO_DEAL001";

const string PAGE_DONE    = "DONE001";
const string PAGE_FAILED  = "FAILED001";

void Init()
{

  if (GetElementCount(DONE) == 0)
  {
    AddStringElement("<c þ >[Done]</c>", DONE);
  }

  if (GetElementCount(MAINOPTIONS) == 0)
  {
    AddStringElement("I figured you might be selling some ropes?", MAINOPTIONS);
    AddStringElement("Sell captured creature(s)", MAINOPTIONS);
    AddStringElement("<cþ  >[Cancel]</c>", MAINOPTIONS);
  }

  if (GetElementCount(SELLPAYOPTIONS) == 0)
  {
    AddStringElement("Sold! *accepts the money offered*", SELLPAYOPTIONS);
    AddStringElement("Your offer is not high enough.<cþ  >[Leave]</c>", SELLPAYOPTIONS);
  }

}

void PageInit()
{
  // This is the function that sets up the prompts for each page.
  string sPage = GetDlgPageString();
  object oPC   = GetPcDlgSpeaker();

  if (sPage == "")
  {

    SetDlgPrompt("Ahoy there! There be always room for more creatures in the cargo hold of our ships! Wha ye got fer me?!");
    SetDlgResponseList(MAINOPTIONS);

  }
  else if (sPage == PAGE_SELL_CAPTURED)
  {

    // check if the NPC already has it's random favorite racial type for buying this reset
    int iBonusType = GetLocalInt(OBJECT_SELF,"GVD_LASSO_RACIALBONUSTYPE");
    if (iBonusType == 0) {
      // randomly assign one
      iBonusType = gvd_GetRandomRacialType();
      SetLocalInt(OBJECT_SELF, "GVD_LASSO_RACIALBONUSTYPE", iBonusType);
    }

    // calculate the price/xp reward for the captured creature
    object oCaptured = GetLocalObject(oPC,"gvd_lasso_capture");       

    if (oCaptured != OBJECT_INVALID) {
 
      // make a price adjustment based on how recent, how many and how far (see gvd_inc_rope)
      int iPriceAdjustment = gvd_GetPriceAdjustment(OBJECT_SELF, oCaptured, 0);

      int iAppraise = 80 + GetSkillRank(SKILL_APPRAISE, oPC);
      int iGold = FloatToInt(GetChallengeRating(oCaptured) * iPriceAdjustment / 100) * iAppraise;

      if (GetRacialType(oCaptured) == iBonusType) {
        iGold = iGold * 2;
        SetDlgPrompt("*barely looks at the captured creature* Yer lucky, a lot of demand for these creatures! *reveils several gold teeth when he grins at you* I'll offer ye " + IntToString(iGold) + " gold for it.");
      } else {
        SetDlgPrompt("*barely looks at the captured creature* Yer lucky, no one else but me be stupid enough to buy that! *bellows loudly for a while reveiling several gold teeth* I'll offer ye " + IntToString(iGold) + " gold for it.");
      }

      // end conversation for now
      SetDlgPageString(PAGE_SELL_CAPTURED);
      SetDlgResponseList(SELLPAYOPTIONS);    

    } else {
      // no captured creatures found
      SetDlgPrompt("*chews on some tobacco noisely* I'm only interested in live stock so to speak! *spits* Come back when ye found one! And specially if you found a " + gvd_GetRacialTypeName(OBJECT_INVALID, iBonusType) + ", I will double the normal price for them.");
      SetDlgPageString(PAGE_DONE);
      SetDlgResponseList(DONE);
    }

  }
  else if (sPage == PAGE_SELL_NO_DEAL)
  {
    SetDlgPrompt("*his face turns red as he raises his voice* Bah! Get this creature out of my sight if yer not sellin it!");
    SetDlgPageString(PAGE_DONE);
    SetDlgResponseList(DONE);

  }
  else if (sPage == PAGE_SELL_CAPTURED_SUCCES) {
    object oShipBoy = GetObjectByTag("gvd_shipboy");
    if (oShipBoy != OBJECT_INVALID) {
      AssignCommand(oShipBoy, ActionMoveToObject(oPC, 1));
    }
    SetDlgPrompt("*motions one of his ship-boys over to take the creature from you and then hands you the money without looking at you* That'll be all!");
    SetDlgPageString(PAGE_DONE);
    SetDlgResponseList(DONE);

  }

}

void HandleSelection()
{
  // This method handles what happens when the player selects an option.
  int selection  = GetDlgSelection();
  object oPC     = GetPcDlgSpeaker();
  string sPage   = GetDlgPageString();
  int nCost;

  if (sPage == "") {
    // handle the PCs selection
    switch (selection) {
      case 0: {
        // open rope shop
        object oStore = GetObjectByTag("GS_STORE_gvd_wharbuy");
        if (GetIsObjectValid(oStore)) {         
          gsCMOpenStore(oStore, OBJECT_SELF, oPC); 
        }

        EndDlg();
        break;
      }
      case 1:
        // sell captured creatures
        SetDlgPageString(PAGE_SELL_CAPTURED);
        break;
      case 2:
        // leave
        EndDlg();
        break;
    }

  } else if (sPage == PAGE_SELL_CAPTURED) {
    // PC wants to sell captured creatures

    // handle the PCs selection
    switch (selection) {
      case 0: {
        // PC wants to sell

        // remove the henchman from the PC and remove the visual effects

        // determine the captured creature
        object oCaptured = GetLocalObject(oPC,"gvd_lasso_capture");        
        ReleaseTargetFromLasso(oPC, oCaptured, "*gets taken away by a ship-boy*");               

        // make a price adjustment based on how recent, how many and how far (see gvd_inc_rope)
        int iPriceAdjustment = gvd_GetPriceAdjustment(OBJECT_SELF, oCaptured, 1);

        // give gold to PC
        int iAppraise = 80 + GetSkillRank(SKILL_APPRAISE, oPC);
        int iGold = FloatToInt(GetChallengeRating(oCaptured) * iPriceAdjustment / 100) * iAppraise;

        int iBonusType = GetLocalInt(OBJECT_SELF,"GVD_LASSO_RACIALBONUSTYPE");
        if (GetRacialType(oCaptured) == iBonusType) {
          iGold = iGold * 2;          
        }

        GiveGoldToCreature(oPC, iGold);
        int iXP = FloatToInt(GetChallengeRating(oCaptured) * iPriceAdjustment / 100) * 20;
        gvd_AdventuringXP_GiveXP(oPC, iXP, "Capture");
          
        SetDlgPageString(PAGE_SELL_CAPTURED_SUCCES);
        break;
   
      } case 1: {
        // PC doesn't want to sell, cancel transaction
        SetDlgPageString(PAGE_SELL_NO_DEAL);
        break;
      }

    }

  } else {
    // The Done response list has only one option, to end the conversation.
    EndDlg();
  }

}

void main()
{
  // Don't change this method unless you understand Z-dialog.
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Called conversation script with event... " + IntToString(nEvent));
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
