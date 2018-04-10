void main()
{

    object oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, 1);

    if (GetIsObjectValid(oTarget)) {

        if (Random(100) >= 90)
        {
          SpeakOneLinerConversation();
        }

    }

}
