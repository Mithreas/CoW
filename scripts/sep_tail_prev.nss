void main()
{
 int nTailType = GetCreatureTailType(GetPCSpeaker());
 if (nTailType > 0) nTailType--;
 string sTailName = Get2DAString("tailmodel", "Label", nTailType);

 while (sTailName == "" && nTailType >= 0) {
    nTailType--;
    sTailName = Get2DAString("tailmodel", "Label", nTailType);
 }

 SendMessageToPC(GetPCSpeaker(), "Tail model: " + sTailName);
 SetCreatureTailType(nTailType, GetPCSpeaker());
}
