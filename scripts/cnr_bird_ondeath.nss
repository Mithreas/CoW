/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_bird_ondeath
//
//  Desc:  The OnDeath handler for birds that drop
//         feathers. Bird/feather pairs are configured
//         in cnr_source_init.
//
//  Author: David Bobeck 26Mar03
//
/////////////////////////////////////////////////////////
void main()
{
   // Moved to gs_ai_spawn so that feathers can be pickpocketed.  
   // This script should still be set as the handler, however, to flag that this is a bird.
   ExecuteScript("gs_ai_death", OBJECT_SELF);
}
