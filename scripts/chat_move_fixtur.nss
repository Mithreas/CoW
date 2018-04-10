#include "fb_inc_chatutils"
#include "gs_inc_fixture"
#include "inc_examine"
#include "x3_inc_string"
#include "nwnx_player"
#include "nwnx_creature"
#include "nwnx_object"
#include "nwnx_alts"
#include "nwnx_admin"

const string HELP = "-move_fixture [x] [y]. Moves the fixture by the provided x- and y- coordinates. The fixture must remain within 4 yards of you at all times.";

float GetDistBetweenVectors(vector vec1, vector vec2)
{
    float dx = vec2.x - vec1.x;
    float dy = vec2.y - vec1.y;
    float dz = vec2.z - vec1.z;

    float distance = sqrt((dx*dx) + (dy*dy) + (dz*dz));

    if (distance < 0.0)
    {
        distance *= -1.0;
    }

    return distance;
}

void main()
{
    string params = chatGetParams(OBJECT_SELF);

    if (params == "?")
    {
        DisplayTextInExamineWindow("-move_fixture", HELP);
    }
    else
    {
        params = GetStringLowerCase(params);

        int i = 0;
        while (TRUE)
        {
            object nearestPlaceable = GetNearestObject(OBJECT_TYPE_PLACEABLE, OBJECT_SELF, i++);

            if (!GetIsObjectValid(nearestPlaceable) || GetDistanceBetween(nearestPlaceable, OBJECT_SELF) > YardsToMeters(4.0))
            {
                SendMessageToPC(OBJECT_SELF, "No matching fixture found nearby. You may need to get closer.");
                break;
            }

            if (GetStringLeft(GetTag(nearestPlaceable), 6) != "GS_FX_")
            {
                continue;
            }

            float dx = 0.0;
            float dy = 0.0;

            string parse = StringParse(params);
            dx = StringToFloat(parse);
            dy = StringToFloat(StringParse(StringRemoveParsed(params, parse)));

            vector curPos = GetPositionFromLocation(GetLocation(nearestPlaceable));

            vector newPos;
            newPos.x = curPos.x + dx;
            newPos.y = curPos.y + dy;
            newPos.z = curPos.z;

            if (GetDistBetweenVectors(GetPositionFromLocation(GetLocation(OBJECT_SELF)), newPos) <= YardsToMeters(4.0))
            {
                if (GetIsWalkable(GetArea(nearestPlaceable), newPos))
                {
                    NWNX_Object_SetPosition(nearestPlaceable, newPos);
                    DelayCommand(0.1, gsFXUpdateFixture(GetTag(GetArea(nearestPlaceable)), nearestPlaceable));

                    SendMessageToPC(OBJECT_SELF,
                        "You moved fixture " + GetName(nearestPlaceable) +
                        " by x: " + FloatToString(dx) +
                        " and y: " + FloatToString(dy) + ".");

                    Log(FIXTURES, "Fixture " + GetName(nearestPlaceable) + " in area " +
                                   GetName(GetArea(nearestPlaceable)) + " was moved by " +
                                   GetName(OBJECT_SELF));
                }
                else
                {
                    SendMessageToPC(OBJECT_SELF, "Moving the fixture would have put it out of bounds!");
                }
            }
            else
            {
                SendMessageToPC(OBJECT_SELF, "Moving the fixture that far would put it out of your range!");
            }

            break;
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}
