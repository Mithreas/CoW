// Ripped out of gs_inc_common into its own script.

#include "gs_inc_common"
#include "inc_xfer"
#include "nwnx_admin"

void __RebootServer()
{
  NWNX_Administration_ShutdownServer();
}

void _RebootServer()
{

  //cancel actions
  ClearAllActions(TRUE);
  ActionJumpToLocation(GetLocation(OBJECT_SELF));
  SetCommandable(FALSE);

  //save location
  if (! gsFLGetAreaFlag("OVERRIDE_LOCATION"))
  {
    gsPCSavePCLocation(OBJECT_SELF, GetLocation(OBJECT_SELF));
  }

  //export (BUGGED! ExportAllCharacters will be used in the main routine below)
  //ExportSingleCharacter(OBJECT_SELF);

  //fade
  SetCutsceneMode(OBJECT_SELF);
  FadeToBlack(OBJECT_SELF, FADE_SPEED_SLOWEST);
}

void RebootServer()
{
  int nState = miXFGetState();
  if (nState != MI_XF_STATE_SIG_REBOOT && nState != MI_XF_STATE_DOWN)
  {
    // dunshine: remove player password when reset is cancelled
    NWNX_Administration_ClearPlayerPassword();

    gsCMSendMessageToAllPCs("Reset cancelled.");
    DeleteLocalInt(GetModule(), "REBOOT_SIGNALLED");
    return;
  }

  if (nState != MI_XF_STATE_DOWN)
  {
    miXFSetState(MI_XF_STATE_REBOOT);
  }

  object oPC = GetFirstPC();
  int iPC = 1;

  while (GetIsObjectValid(oPC))
  {

    if (! GetIsDM(oPC)) {
      AssignCommand(oPC, _RebootServer());
    }

    oPC = GetNextPC();
    iPC = iPC + 1;
  }

  // there is a bug with ExportSingleCharacter, when they are called at the same time. They get queued and only the last one will be executed 
  // so instead we'll use ExportAllCharacters from now on, delay this a little to ensure cutscene is active for all pcs first
  DelayCommand(5.0, ExportAllCharacters());

  DelayCommand(30.0, __RebootServer());
}

void main()
{
  if (miXFGetState() == MI_XF_STATE_DOWN)
  {
    gsCMSendMessageToAllPCs("Attention: The server will be taken down for maintenance in 60 seconds. Please collect all items belonging to your character. Your character and its location are stored shortly before restarting. Note that the server may not come back up for some time.");
  }
  else
  {
    miXFSetState(MI_XF_STATE_SIG_REBOOT);
    gsCMSendMessageToAllPCs(gsCMReplaceString(GS_T_16777233, "60"));
  }

  // dunshine: password the server here, so players won't login during the 60 seconds delay and get a surprise reboot welcoming them
  NWNX_Administration_SetPlayerPassword(GetLocalString(GetModule(), "GVD_SERVER_PASSWORD"));

  DelayCommand(60.0, RebootServer());
}
