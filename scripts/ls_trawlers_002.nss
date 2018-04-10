// called from reception room trigger in area 'The Trawlers - Main'
// creates a welcome SpeakString by the Receptionist
// see ls_trawlers_main for details

void main()
{
object oReceptionist = GetObjectByTag("TRAWLERS_RECEPTIONIST");
AssignCommand(oReceptionist, SpeakString("Welcome...!"));
}
