

void main()
{object oSpeaker = GetObjectByTag("Commoner2");
int nLiner2 = GetLocalInt(oSpeaker, "oneliner_tracking2");
if (nLiner2 < 1)
{
SpeakString("It looks very attractive... Yet so odd at the same time.");
SetLocalInt(oSpeaker, "oneliner_tracking2", 1);
}

else if (nLiner2 == 1)
{
SpeakString("Would it look good on me?");
SetLocalInt(oSpeaker, "oneliner_tracking2", 2);
}

else if (nLiner2 == 2)
{
SpeakString("Why not?");
SetLocalInt(oSpeaker, "oneliner_tracking2", 3);
}

else if (nLiner2 == 3)
{
SpeakString("It looks very attractive... Yet so odd at the same time.");
}

}
