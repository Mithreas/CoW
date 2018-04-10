//9 10 11 17 18 19 20
#include "gs_inc_common"
#include "gs_inc_message"
// Edited by Mithreas to allow longer messages.
const string GS_TEMPLATE_LETTER = "gs_item370";

void main()
{
    object oTarget = GetLocalObject(OBJECT_SELF, "GS_TARGET");

    if (GetIsObjectValid(oTarget))
    {
        string sTitle     = GetLocalString(OBJECT_SELF, "GS_ME_TITLE");
        string sText1      = GetLocalString(OBJECT_SELF, "GS_ME_TEXT_1");
        string sText2      = GetLocalString(OBJECT_SELF, "GS_ME_TEXT_2");
        string sText3      = GetLocalString(OBJECT_SELF, "GS_ME_TEXT_3");
        string sText4      = GetLocalString(OBJECT_SELF, "GS_ME_TEXT_4");

        string sMessageID = gsCMCreateRandomID();
        object oObject    = CreateItemOnObject(GS_TEMPLATE_LETTER,
                                               OBJECT_SELF,
                                               1,
                                               "GS_ME_" + sMessageID);

        if (GetIsObjectValid(oObject))
        {
            string sDoubleQuote = GetLocalString(GetModule(), "GS_DOUBLE_QUOTE");

            SetName(oObject, sDoubleQuote + sTitle + sDoubleQuote);
            gsMEForgeMessage(sMessageID, sTitle, sText1, sText2, sText3, sText4, "Noristan Aylomen", GetName(GetPCSpeaker()));
            gsCMReduceItem(oTarget);
        }
    }
}
