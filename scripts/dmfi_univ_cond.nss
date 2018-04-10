//DMFI Universal Wand scripts by hahnsoo
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    DeleteLocalInt(oPC, "Tens");
    int iOffset = GetLocalInt(oPC, "dmfi_univ_offset")+1;
    string sOffset = GetLocalString(oPC, "dmfi_univ_conv");
    SetLocalInt(oPC, "dmfi_univ_offset", iOffset);

    if (sOffset == "afflict" && iOffset==1)
        return TRUE;
    if (sOffset == "pc_emote" && iOffset==2)
        return TRUE;
    if (sOffset == "emote" && iOffset==2)
        return TRUE;
    if (sOffset == "encounter" && iOffset==3)
        return TRUE;
    if (sOffset == "fx" && iOffset==4)
        return TRUE;
    if (sOffset == "music" && iOffset==5)
        return TRUE;
    if (sOffset == "sound" && iOffset==6)
        return TRUE;
    if (sOffset == "xp" && iOffset==7)
        return TRUE;
    if (sOffset == "onering" && iOffset==8)
        return TRUE;
    if (sOffset == "pc_dicebag" && iOffset==9)
    {
        SetLocalInt(oPC, "dmfi_univ_offset", 8);

        if (GetLocalInt(oPC, "dmfi_dicebag")==0)
                SetCustomToken(20681, "Private");
        else  if (GetLocalInt(oPC, "dmfi_dicebag")==1)
                SetCustomToken(20681, "Global");
        else if (GetLocalInt(oPC, "dmfi_dicebag")==2)
                SetCustomToken(20681, "Local");
        else if (GetLocalInt(oPC, "dmfi_dicebag")==3)
                SetCustomToken(20681, "DM Only");

        return TRUE;
    }
    if (sOffset == "dicebag" && iOffset==10)
    {
        SetLocalInt(oPC, "dmfi_univ_offset", 9);

        if (GetLocalInt(oPC, "dmfi_dicebag")==0)
                SetCustomToken(20681, "Private");
        else  if (GetLocalInt(oPC, "dmfi_dicebag")==1)
                SetCustomToken(20681, "Global");
        else if (GetLocalInt(oPC, "dmfi_dicebag")==2)
                SetCustomToken(20681, "Local");
        else if (GetLocalInt(oPC, "dmfi_dicebag")==3)
                SetCustomToken(20681, "DM Only");

        string sName = GetName(GetLocalObject(oPC, "dmfi_univ_target"));
        SetCustomToken(20680, sName);

        return TRUE;
    }
    if (sOffset == "voice" &&
        GetIsObjectValid(GetLocalObject(oPC, "dmfi_univ_target")) &&
        oPC != GetLocalObject(oPC, "dmfi_univ_target") &&
        iOffset==11)
        {
        string sName = GetName(GetLocalObject(oPC, "dmfi_univ_target"));
        SetCustomToken(20680, sName);
        return TRUE;
        }

    if (sOffset == "voice" &&
        !GetIsObjectValid(GetLocalObject(oPC, "dmfi_univ_target")) &&
        iOffset==12)
        {
        string sName = GetName(GetLocalObject(oPC, "dmfi_univ_target"));
        SetCustomToken(20680, sName);
        return TRUE;
        }

    if (sOffset == "voice" &&
        GetIsObjectValid(GetLocalObject(oPC, "dmfi_univ_target")) &&
        oPC == GetLocalObject(oPC, "dmfi_univ_target") &&
        iOffset==13)
        {
        string sName = GetName(GetLocalObject(oPC, "dmfi_univ_target"));
        SetCustomToken(20680, sName);
        return TRUE;
        }

    if (sOffset == "faction" && iOffset==14)
        {
        int iLoop = 1;
        string sName;
        object sFaction;
        while (iLoop < 10)
            {
            sFaction = GetLocalObject(oPC, "dmfi_customfaction" + IntToString(iLoop));
            sName = GetName(sFaction);
            SetCustomToken(20690 + iLoop, sName + "'s Faction ");
            iLoop++;
            }

        SetCustomToken(20690, GetName(GetLocalObject(oPC, "dmfi_henchman")));
        SetCustomToken(20784, FloatToString(GetLocalFloat(oPC, "dmfi_reputation")));
        sName = GetName(GetLocalObject(oPC, "dmfi_univ_target"));
        SetCustomToken(20680, sName);


        return TRUE;
        }
    if (sOffset == "dmw" && iOffset ==15)
        {
        SetCustomToken(20781, IntToString(GetLocalInt(oPC, "dmfi_alignshift")));
        return TRUE;
        }
    if (sOffset == "buff" && iOffset ==16)
        {
        if (GetLocalInt(oPC, "dmfi_buff_party")==0)
             SetCustomToken(20783, "Single Target");
             else
             SetCustomToken(20783, "Party");
        SetCustomToken(20782, GetLocalString(oPC, "dmfi_buff_level"));

        return TRUE;
        }

    return FALSE;
}
