#include "fb_inc_chatutils"
#include "gs_inc_fixture"
#include "inc_examine"

const string HELP = "-rotate_fixture [degrees] or [cardinal direction]. Rotates the nearest fixture (must be within 4 yards) by the provided degrees (minimum 25) or cardinal direction (north/east/south/west).";

void main()
{
    string params = chatGetParams(OBJECT_SELF);

    if (params == "?")
    {
        DisplayTextInExamineWindow("-rotate_fixture", HELP);
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

            float newRot = 0.0;

            if (params == "north")
            {
                newRot = DIRECTION_NORTH;
                SendMessageToPC(OBJECT_SELF, "You rotated fixture " + GetName(nearestPlaceable) + " to face north.");
            }
            else if (params == "east")
            {
                newRot = DIRECTION_EAST;
                SendMessageToPC(OBJECT_SELF, "You rotated fixture " + GetName(nearestPlaceable) + " to face east.");
            }
            else if (params == "south")
            {
                newRot = DIRECTION_SOUTH;
                SendMessageToPC(OBJECT_SELF, "You rotated fixture " + GetName(nearestPlaceable) + " to face south.");
            }
            else if (params == "west")
            {
                newRot = DIRECTION_WEST;
                SendMessageToPC(OBJECT_SELF, "You rotated fixture " + GetName(nearestPlaceable) + " to face west.");
            }
            else
            {
                float delta = StringToFloat(params);

                if (delta > 0.0 && delta < 25.0)
                {
                    delta = 25.0;
                }
                else if (delta < 0.0 && delta > -25.0)
                {
                    delta = -25.0;
                }

                newRot = GetFacing(nearestPlaceable) + delta;

                SendMessageToPC(OBJECT_SELF, "You rotated fixture " + GetName(nearestPlaceable) +
                    " by " + FloatToString(delta) + " degrees.");
            }

            AssignCommand(nearestPlaceable, SetFacing(newRot));
            DelayCommand(0.1, gsFXUpdateFixture(GetTag(GetArea(nearestPlaceable)), nearestPlaceable));

            Log(FIXTURES, "Fixture " + GetName(nearestPlaceable) + " in area " +
                           GetName(GetArea(nearestPlaceable)) + " was rotated by " +
                           GetName(OBJECT_SELF));

            break;
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}
