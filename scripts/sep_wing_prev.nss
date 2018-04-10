void main()
{
 int nWingType = GetCreatureWingType(GetPCSpeaker());
 if (nWingType > 0) nWingType--;
 string sWingName = Get2DAString("wingmodel", "Label", nWingType);

 while (sWingName == "" && nWingType >= 0) {
    nWingType--;
    sWingName = Get2DAString("wingmodel", "Label", nWingType);
 }

 SendMessageToPC(GetPCSpeaker(), "Wing model: " + sWingName);
 SetCreatureWingType(nWingType, GetPCSpeaker());
}
