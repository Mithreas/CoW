void main()
{
 int nWingType = GetCreatureWingType(GetPCSpeaker());
 if (nWingType < 89) nWingType++;
 string sWingName = Get2DAString("wingmodel", "Label", nWingType);
  while (sWingName == "" && nWingType <= 89) {
    nWingType++;
    sWingName = Get2DAString("wingmodel", "Label", nWingType);
 }

 SendMessageToPC(GetPCSpeaker(), "Wing model: " + sWingName);
 SetCreatureWingType(nWingType, GetPCSpeaker());
}
