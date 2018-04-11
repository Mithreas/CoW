
int StartingConditional()
{
    object oPC      = GetPCSpeaker();
    int nClass1     = GetLocalInt(OBJECT_SELF, "AR_QU_CLASS_1");
    int nClass2     = GetLocalInt(OBJECT_SELF, "AR_QU_CLASS_2");
    int nClass3     = GetLocalInt(OBJECT_SELF, "AR_QU_CLASS_3");
    int nClass4     = GetLocalInt(OBJECT_SELF, "AR_QU_CLASS_4");
    int nClass5     = GetLocalInt(OBJECT_SELF, "AR_QU_CLASS_5");
    int nClass6     = GetLocalInt(OBJECT_SELF, "AR_QU_CLASS_6");

    int nClass;
    int x;
    for(x = 1; x <= 3; x++) {
        nClass = GetClassByPosition(x, oPC);

        if ( nClass == nClass1 || nClass == nClass2 ||
             nClass == nClass3 || nClass == nClass4 ||
             nClass == nClass5 || nClass == nClass6) {
                return TRUE;
             }

    }

    return FALSE;
}
