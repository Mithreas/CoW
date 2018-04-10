

int nLiner3 = GetLocalInt(OBJECT_SELF, "oneliner_tracking3");
void main()
{
if (nLiner3 < 1)
{
SpeakString("Daddy bought it for me.");
SetLocalInt(OBJECT_SELF, "oneliner_tracking3", 1);
}

else if (nLiner3 == 1)
{
SpeakString("I like it allot.");
SetLocalInt(OBJECT_SELF, "oneliner_tracking3", 2);
}

else if (nLiner3 == 2)
{
SpeakString("It's just that everyone keeps looking down my cleavage.");
SetLocalInt(OBJECT_SELF, "oneliner_tracking3", 3);
}

else if (nLiner3 == 3)
{
SpeakString("Did I just say that?");
SetLocalInt(OBJECT_SELF, "oneliner_tracking3", 4);
}

else if (nLiner3 == 4)
{
SpeakString("I like it allot.");
}
}
