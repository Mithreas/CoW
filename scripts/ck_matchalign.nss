int StartingConditional()
{
  // used for warlock convo mi_ba_warlock, returns TRUE is PC does NOT have the correct alignment

  int iPCAlignment = GetAlignmentLawChaos(GetPCSpeaker());

  // neutral is okay in all cases, so return FALSE
  if (iPCAlignment == ALIGNMENT_NEUTRAL) return FALSE;

  // otherwise compare chaotic vs lawful, if different return TRUE, if the same return FALSE
  return (iPCAlignment != GetAlignmentLawChaos(OBJECT_SELF));

}
