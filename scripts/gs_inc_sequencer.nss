/* SEQUENCER Library by Gigaschatten */

//add sScript to stack of oObject for execution on oTarget
void gsSEAdd(string sScript, object oTarget, object oObject = OBJECT_INVALID);

void gsSEAdd(string sScript, object oTarget, object oObject = OBJECT_INVALID)
{
    if (! GetIsObjectValid(oObject)) oObject = GetLocalObject(GetModule(), "GS_SEQUENCER");

    AssignCommand(oObject, SetCommandable(TRUE));
    AssignCommand(oObject, ActionDoCommand(ExecuteScript(sScript, oTarget)));
    AssignCommand(oObject, SetCommandable(FALSE));
}
