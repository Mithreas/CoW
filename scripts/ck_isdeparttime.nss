int StartingConditional()
{
    int nCurrentHour = GetTimeHour();
    int nDepartTime;
    switch (nCurrentHour)
    {
        case 0:
        case 3:
        case 6:
        case 9:
        case 12:
        case 15:
        case 18:
        case 21:
          {
            nDepartTime = TRUE;
          }
          break;
        default:
          {
            nDepartTime = FALSE;
          }
          break;
    }

    return nDepartTime;
}