#include "fb_inc_chatutils"
#include "inc_examine"
#include "nwnx_creature"
#include "x3_inc_string"

void main()
{
    string params = chatGetParams(OBJECT_SELF);

    if (params == "?" || params == "")
    {
        DisplayTextInExamineWindow(
            chatCommandTitle("-walk") + " " + chatCommandParameter("[Type]"),

            "Toggles between various walk speed capping options.\n\n" +

            chatCommandParameter("alwayswalk") + "\n" +
            "Forces the character to always walk, as if they had detect mode active.\n\n" +

            chatCommandParameter("naturalwalk") + "\n" +
            "Forces the character to always walk at a normal pace, as if they had no movement-speed increasing effects."
        );
    }
    else
    {
        if (params == "alwayswalk")
        {
            int alreadyOn = GetLocalInt(OBJECT_SELF, "ALWAYS_WALK");
            NWNX_Player_SetAlwaysWalk(OBJECT_SELF, alreadyOn ? 0 : 1);
            SetLocalInt(OBJECT_SELF, "ALWAYS_WALK", alreadyOn ? 0 : 1);
            SendMessageToPC(OBJECT_SELF, "Toggled alwayswalk " + (alreadyOn ? "off!" : "on!"));
        }
        else if (params == "naturalwalk")
        {
            int alreadyOn = GetLocalInt(OBJECT_SELF, "NATURAL_WALK");
            NWNX_Creature_SetWalkRateCap(OBJECT_SELF, alreadyOn ? -1.0 : 2000.0);
            SetLocalInt(OBJECT_SELF, "NATURAL_WALK", alreadyOn ? 0 : 1);
            SendMessageToPC(OBJECT_SELF, "Toggled naturalwalk " + (alreadyOn ? "off!" : "on!"));
        }
        else
        {
            SendMessageToPC(OBJECT_SELF, StringToRGBString("Invalid parameter: " + params, STRING_COLOR_RED));
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}
