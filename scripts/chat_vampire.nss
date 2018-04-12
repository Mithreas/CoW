#include "inc_chat"
#include "gs_inc_pc"
#include "gs_inc_state"
#include "inc_examine"
#include "inc_thrall"
#include "inc_vampire"
#include "inc_totem"
#include "x3_inc_string"

void main()
{
    string params = GetStringLowerCase(chatGetParams(OBJECT_SELF));

    if (!VampireIsVamp(OBJECT_SELF))
    {
        SendMessageToPC(OBJECT_SELF, StringToRGBString("You are not a vampire!", STRING_COLOR_RED));
    }
    else if (params == "" || params == "?")
    {
        DisplayTextInExamineWindow(
            chatCommandTitle("-vampire") + " " + chatCommandParameter("[Params]"),
            "Used to control the special abilities belonging to a vampire." +
            "For further information, consult -manual vampire.\n\n" +

            chatCommandTitle("-vampire") + " " + chatCommandParameter("bat") +
            "\nTransforms you into a bat.\n\n" +

            chatCommandTitle("-vampire") + " " + chatCommandParameter("bite") +
            "\nTransforms your next melee attack into a bite attack.\n\n" +

            chatCommandTitle("-vampire") + " " + chatCommandParameter("feed") +
            "\nFeeds from the nearest vampire or thrall offering their blood.\n\n" +

            chatCommandTitle("-vampire") + " " + chatCommandParameter("offer") +
            "\nOffers your blood to the nearest vampire or thrall to feed on.\n\n" +

            chatCommandTitle("-vampire") + " " + chatCommandParameter("wolf") +
            "\nTransforms you into a wolf.");
    }
    else
    {
        chatVerifyCommand(OBJECT_SELF);

        if (params == "bat" || params == "wolf")
        {
            int totemId = params == "wolf" ? MI_TO_VAMPIRE_WOLF : MI_TO_VAMPIRE_BAT;
            SetLocalInt(gsPCGetCreatureHide(OBJECT_SELF), MI_TOTEM, totemId);
            AssignCommand(OBJECT_SELF, SpeakString("-polymorph"));
        }
        else if (params == "bite")
        {
            if (VampireBiteAttackIsQueued(OBJECT_SELF))
            {
                SendMessageToPC(OBJECT_SELF, "You already have a bite attack queued!");
            }
            else
            {
                if (GetIsTimelocked(OBJECT_SELF, "Vampire Bite"))
                {
                    TimelockErrorMessage(OBJECT_SELF, "Vampire Bite");
                }
                else
                {
                    VampireBiteAttackSetQueued(OBJECT_SELF, TRUE);
                    SendMessageToPC(OBJECT_SELF, "You ready a bite on your next melee attack!");
                }
            }
        }
        else if (params == "feed")
        {
            int fed = FALSE;

            object area = GetArea(OBJECT_SELF);
            object creature = GetFirstObjectInArea(area);
            while (GetIsObjectValid(creature))
            {
                int inRange = GetDistanceBetween(OBJECT_SELF, creature) <= RADIUS_SIZE_MEDIUM;

                if (inRange && creature != OBJECT_SELF)
                {
                    int isVampireAndOffering = VampireIsVamp(creature) && VampireIsOffering(creature);
                    int isThrallAndOffering = ThrallIsOffering(creature);

                    if (isVampireAndOffering)
                    {
                        VampireSetOffering(creature, FALSE);

                        // We take 25% of their blood and gain 25% in return.
                        // Timer for this one isn't necessary.
                        gsSTAdjustState(GS_ST_BLOOD, 25.0, OBJECT_SELF);
                        gsSTAdjustState(GS_ST_BLOOD, -25.0, creature);

                        FloatingTextStringOnCreature("You plunge your fangs into " + GetName(creature) + " 's flesh, and you feed!", OBJECT_SELF, FALSE);
                        FloatingTextStringOnCreature(GetName(OBJECT_SELF) + "feasts on your delicious blood. You feel weaker.", creature, FALSE);

                        fed = TRUE;

                        break;
                    }
                    else if (isThrallAndOffering)
                    {
                        ThrallSetOffering(creature, FALSE);

                        int recentFeeds = ThrallGetFedFromCount(creature);

                        FloatingTextStringOnCreature("You plunge your fangs into " + GetName(creature) + " 's flesh, and you feed!", OBJECT_SELF, FALSE);

                        if (recentFeeds == 0)
                        {
                            gsSTAdjustState(GS_ST_BLOOD, 25.0, OBJECT_SELF);
                            FloatingTextStringOnCreature(GetName(OBJECT_SELF) + "feasts on your delicious blood. You feel weaker.", creature, FALSE);
                        }
                        else if (recentFeeds == 1)
                        {
                            gsSTAdjustState(GS_ST_BLOOD, 25.0, OBJECT_SELF);
                            FloatingTextStringOnCreature(GetName(OBJECT_SELF) + "feasts on your delicious blood. You feel drained and lightheaded.", creature, FALSE);
                        }
                        else if (recentFeeds == 2)
                        {
                            gsSTAdjustState(GS_ST_BLOOD, 25.0, OBJECT_SELF);
                            FloatingTextStringOnCreature(GetName(OBJECT_SELF) + "feasts on your delicious blood. You are nearly delerious. You will not last another feeding without a resting period.", creature, FALSE);
                        }
                        else
                        {
                            gsSTAdjustState(GS_ST_BLOOD, 25.0, OBJECT_SELF);
                            FloatingTextStringOnCreature(GetName(OBJECT_SELF) + "feasts on your delicious blood. They drain you dry.", creature, FALSE);
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), creature);
                            ThrallSetFedFromCount(creature, 0);
                            return;
                        }

                        ThrallSetLastFedFromTime(creature, GetModuleTime());
                        ThrallSetFedFromCount(creature, recentFeeds + 1);

                        fed = TRUE;

                        break;
                    }
                }

                creature = GetNextObjectInArea(area);
            }

            if (!fed)
            {
                FloatingTextStringOnCreature("No vampires or thralls were in range for you to drink from.", OBJECT_SELF, FALSE);
            }
        }
        else if (params == "offer")
        {
            int offeringNow = !VampireIsOffering(OBJECT_SELF);
            FloatingTextStringOnCreature(offeringNow ?
                "You offer yourself to any nearby vampires or thralls." :
                "You stop offering yourself to any nearby vampires or thralls.", OBJECT_SELF, TRUE);
            VampireSetOffering(OBJECT_SELF, offeringNow);
        }
        else
        {
            SendMessageToPC(OBJECT_SELF, StringToRGBString("Invalid vampire command: " + params + ".", STRING_COLOR_RED));
        }
    }
}
