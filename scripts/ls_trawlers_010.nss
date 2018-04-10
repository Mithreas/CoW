
void main()
{
object oSpeaker = GetObjectByTag("Commoner1");
int nLiner1 = GetLocalInt(oSpeaker, "oneliner_tracking1");

if (nLiner1 < 1)
{
SpeakString("What a daring thing to do!");
SetLocalInt(oSpeaker, "oneliner_tracking1", 1);
}

else if (nLiner1 == 1)
{
SpeakString("It looks quite... exotic.");
SetLocalInt(oSpeaker, "oneliner_tracking1", 2);
}

else if (nLiner1 == 2)
{
SpeakString("Won't you be prosecuted?");
SetLocalInt(oSpeaker, "oneliner_tracking1", 3);
}

else if (nLiner1 == 3)
{
SpeakString("What a daring thing to do!");
}

}
