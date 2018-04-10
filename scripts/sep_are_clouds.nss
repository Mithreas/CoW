#include "sep_eff_toolbox"
void main()
{
float fZClouds = GetLocalFloat(OBJECT_SELF, "fZClouds");
DoClouds(fZClouds);
DestroyObject(OBJECT_SELF);
}
