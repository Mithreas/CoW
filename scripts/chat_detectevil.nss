#include "__server_config"
#include "gs_inc_text_en"
#include "gs_inc_pc"
#include "gs_inc_worship"
#include "gs_inc_xp"
#include "fb_inc_chatutils"
#include "fb_inc_zombie"
#include "inc_examine"
#include "x3_inc_string"

const string HELP = "Detects nearby evil. Costs 10% piety and 100 exp.";

void main()
{
    if (chatGetParams(OBJECT_SELF) == "?")
    {
        DisplayTextInExamineWindow("-detectevil", HELP);
    }
    else
    {
        if (ALLOW_DETECT_EVIL)
        {
            //get caster level
            string sDeity = GetDeity(OBJECT_SELF);
            int nCasterLevel = ((sDeity != "") &&  (gsWOGetPiety(OBJECT_SELF) >= 10.0) &&
                           GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD &&
                           GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_LAWFUL) ?
                           GetLevelByClass(CLASS_TYPE_PALADIN, OBJECT_SELF) : 0;

            if (GetLocalInt(gsPCGetCreatureHide(OBJECT_SELF), VAR_HARPER) == MI_CL_HARPER_PARAGON)
            {
                nCasterLevel += GetLevelByClass(CLASS_TYPE_HARPER, OBJECT_SELF);
            }

            if (fbZGetIsZombie(OBJECT_SELF))
            {
                FloatingTextStringOnCreature("Right now, doing something like that would be pretty hypocritical all things considered.", OBJECT_SELF, FALSE);
            }
            else
            {
                if (nCasterLevel)
                {
                    //usage limitation
                    int nTimestamp1 = gsTIGetActualTimestamp();
                    int nTimestamp2 = GetLocalInt(OBJECT_SELF, "GS_LI_TIMESTAMP_DETECT_EVIL");

                    if (nTimestamp1 > nTimestamp2 + FloatToInt(HoursToSeconds(12)))
                    {
                        // cost of 10 power to deity and 100XP.
                        gsWOAdjustPiety(OBJECT_SELF, -10.0);
                        gsXPGiveExperience(OBJECT_SELF, -100);

                        location lLocation = GetLocation(OBJECT_SELF);
                        object oCreature   = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation);
                        effect eVisual     = EffectVisualEffect(VFX_DUR_PARALYZED);
                        int nDC            = 11 + GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF);

                        //add feat bonus to DC
                        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION, OBJECT_SELF))         nDC += 6;
                        else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINATION, OBJECT_SELF)) nDC += 4;
                        else if (GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, OBJECT_SELF))         nDC += 2;

                        int nEvilPresent = FALSE;
                        //mark evil creatures
                        while (GetIsObjectValid(oCreature))
                        {
                            if (oCreature != OBJECT_SELF &&
                                GetAlignmentGoodEvil(oCreature) == ALIGNMENT_EVIL &&
                                WillSave(oCreature, nDC, SAVING_THROW_TYPE_DIVINE, OBJECT_INVALID) == 0)
                            {
                                //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVisual, oCreature, 3.0);
                                //SendMessageToPC(OBJECT_SELF, gsCMReplaceString(GS_T_16777534, GetName(oCreature)));
                                nEvilPresent = TRUE;
                            }

                            oCreature = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation);
                        }

                        if (nEvilPresent) SendMessageToPC(OBJECT_SELF, "There is evil nearby!");
                        SetLocalInt(OBJECT_SELF, "GS_LI_TIMESTAMP_DETECT_EVIL", nTimestamp1);
                    }
                    else
                    {
                        FloatingTextStringOnCreature(GS_T_16777533, OBJECT_SELF, FALSE);
                    }
                }
                else
                {
                    SendMessageToPC(OBJECT_SELF, StringToRGBString("You must be a paladin to use Detect Evil, and you must have at least 10% piety.", STRING_COLOR_RED));
                }
            }
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}
