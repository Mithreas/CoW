#include "inc_area"

void gsRun()
{
    if (gsARGetIsAreaActive(GetArea(OBJECT_SELF)))
    {
        SpeakOneLinerConversation();
        DelayCommand(30.0 + IntToFloat(Random(31)), gsRun());
    }
}
//----------------------------------------------------------------
void main()
{
    gsRun();
}
