// Altar OnDisturbed script in the Forest of Thorns grotto.
#include "inc_common"
void main()
{
    object oDisturbed = GetLastDisturbed();
    object oItem      = GetInventoryDisturbItem();
    string sTag       = GetTag(oItem);

    switch (GetInventoryDisturbType())
    {
      case INVENTORY_DISTURB_TYPE_ADDED:
	  {
	    if (sTag == "fotg_flower")
		{
		  gsCMTeleportToObject(oDisturbed, GetObjectByTag("WP_fotg_dest"));
		  DestroyObject(oItem);		  
  		}
		else
		{
		  effect eDamage = EffectDamage(d6(3), DAMAGE_TYPE_MAGICAL);
		  eDamage = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_IMP_MAGBLUE));
		  ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oDisturbed);
		}
	    break;
	  }
    }	
}