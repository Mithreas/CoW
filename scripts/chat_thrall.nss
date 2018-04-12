#include "inc_chat"
#include "gs_inc_state"
#include "inc_examine"
#include "inc_thrall"
#include "inc_vampire"
#include "x3_inc_string"

void main()
{
    string params = GetStringLowerCase(chatGetParams(OBJECT_SELF));

    if (VampireIsVamp(OBJECT_SELF))
    {
        SendMessageToPC(OBJECT_SELF, StringToRGBString("You are a vampire, not a lowly thrall!", STRING_COLOR_RED));
    }
    else if (params == "" || params == "?")
    {
        DisplayTextInExamineWindow(
            chatCommandTitle("-thrall") + " " + chatCommandParameter("[Params]"),
            "Used to control the special abilities belonging to a thrall." +

            chatCommandTitle("-thrall") + " " + chatCommandParameter("feed") +
            "\nFeeds from the nearest vampire offering their blood.\n\n" +

            chatCommandTitle("-thrall") + " " + chatCommandParameter("offer") +
            "\nOffers your blood to the nearest vampire to feed on.\n\n");
    }
    else
    {
        if (params == "feed")
        {
            int fed = FALSE;

            object area = GetArea(OBJECT_SELF);
            object creature = GetFirstObjectInArea(area);
            while (GetIsObjectValid(creature))
            {
                int inRange = GetDistanceBetween(OBJECT_SELF, creature) <= RADIUS_SIZE_MEDIUM;

                if (inRange)
                {
                    int isVampireAndOffering = VampireIsVamp(creature) && VampireIsOffering(creature);

                    if (isVampireAndOffering)
                    {
                        VampireSetOffering(creature, FALSE);

                        // We take 25% of their blood and gain a feed count in return
                        gsSTAdjustState(GS_ST_BLOOD, -25.0, creature);
                        ThrallSetLastFeedTime(OBJECT_SELF, GetModuleTime());
                        ThrallSetFeedCount(OBJECT_SELF, ThrallGetFeedCount(OBJECT_SELF) + 1);

                        FloatingTextStringOnCreature("You drink from " + GetName(creature) + " 's blood.", OBJECT_SELF, FALSE);
                        FloatingTextStringOnCreature(GetName(OBJECT_SELF) + " accepts a donation of your blood.", creature, FALSE);

                        fed = TRUE;

                        break;
                    }
                }

                creature = GetNextObjectInArea(area);
            }

            if (!fed)
            {
                FloatingTextStringOnCreature("No vampires were in range for you to drink from.", OBJECT_SELF, FALSE);
            }
        }
        else if (params == "offer")
        {
            int offeringNow = !ThrallIsOffering(OBJECT_SELF);
            FloatingTextStringOnCreature(offeringNow ?
                "You offer yourself to any nearby vampires." :
                "You stop offering yourself to any nearby vampires.", OBJECT_SELF, TRUE);
            ThrallSetOffering(OBJECT_SELF, offeringNow);
        }
        else
        {
            SendMessageToPC(OBJECT_SELF, StringToRGBString("Invalid vampire command: " + params + ".", STRING_COLOR_RED));
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}
