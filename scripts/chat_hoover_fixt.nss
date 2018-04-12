#include "gs_inc_pc"
#include "gs_inc_fixture"
#include "inc_chatutils"
#include "inc_examine"

const string HELP = "DM command: Hoovers up all fixtures in an area (up to inventory capacity.)";

void main()
{
    if (!GetIsDM(OBJECT_SELF))
    {
        return;
    }

    if (chatGetParams(OBJECT_SELF) == "?")
    {
        DisplayTextInExamineWindow("-hoover_fixtures", HELP);
    }
    else
    {
        int i = 0;
        while (TRUE)
        {
            object placeable = GetNearestObject(OBJECT_TYPE_PLACEABLE, OBJECT_SELF, i++);

            if (!GetIsObjectValid(placeable))
            {
                // No more placeables to search.
                break;
            }

            if (GetStringLeft(GetTag(placeable), 6) != "GS_FX_")
            {
                // Not a valid placeable for pick-up.
                continue;
            }

            if (GetIsObjectValid(gsFXPickupFixture(OBJECT_SELF, placeable)))
            {
                Log(FIXTURES, "Fixture " + GetName(placeable) +
                              " in area " + GetName(GetArea(placeable)) +
                              " was taken by " + GetName(placeable));

                DestroyObject(placeable);
            }
        }
    }

    chatVerifyCommand(OBJECT_SELF);
}
