#include "inc_chatutils"
#include "inc_common"
#include "inc_dm"
#include "inc_examine"
const string HELP = "-t at start to select target from DM Tool 1. No option targets self. No option resizes. Options -z,-x,-y,-a,-rx,-ry,-rz. First 3 translate across that axis. -a deals with animation speed. Last 3 rotates across that axis. -a default: 1";

void main()
{
    object oDM = OBJECT_SELF;
    if(!GetIsDM(oDM) && !GetIsDMPossessed(oDM)) return;

    chatVerifyCommand(oDM);
    string sParams = GetStringLowerCase(gsCMTrimString(chatGetParams(oDM), " "));
    if(sParams == "?")
    {
        DisplayTextInExamineWindow(chatCommandTitle("-transl"), HELP);
        return;
    }
    object oTarget;
    if(FindSubString(sParams, "-t") > -1)
    {
        oTarget = GetDMActionTarget();
        sParams = gsCMTrimString(GetStringRight(sParams, GetStringLength(sParams)-2), " ");
    }
    else
        oTarget = oDM;


    int nTranslate = OBJECT_VISUAL_TRANSFORM_SCALE;
    if(FindSubString(sParams, "-") > -1)
    {
        string sOption = GetSubString(sParams, 1, 2);
        sParams = gsCMTrimString(GetStringRight(sParams, GetStringLength(sParams)-3), " ");

        if(sOption == "z ")
            nTranslate = OBJECT_VISUAL_TRANSFORM_TRANSLATE_Z;
        else if(sOption == "y ")
            nTranslate = OBJECT_VISUAL_TRANSFORM_TRANSLATE_Y;
        else if(sOption == "x ")
            nTranslate = OBJECT_VISUAL_TRANSFORM_TRANSLATE_X;
        else if(sOption == "rz")
            nTranslate = OBJECT_VISUAL_TRANSFORM_ROTATE_Z;
        else if(sOption == "ry")
            nTranslate = OBJECT_VISUAL_TRANSFORM_ROTATE_Y;
        else if(sOption == "rx")
            nTranslate = OBJECT_VISUAL_TRANSFORM_ROTATE_X;
        else if(sOption == "a ")
            nTranslate = OBJECT_VISUAL_TRANSFORM_ANIMATION_SPEED;

    }
    float fAmt = StringToFloat(sParams);
    if(fAmt == 0.0 && nTranslate == OBJECT_VISUAL_TRANSFORM_SCALE)
        fAmt = 1.0;


    SetObjectVisualTransform(oTarget, nTranslate, fAmt);
    DMLog(oDM, oTarget,  "Translation " + IntToString(nTranslate) +  " " + sParams);
}
