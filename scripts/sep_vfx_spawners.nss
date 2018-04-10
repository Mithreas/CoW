void main()
{
//Create all visual effects for area and then destroy this.
SendMessageToAllDMs("Initializing visual effects in area with tag: "+ GetTag(GetArea(OBJECT_SELF)));
ExecuteScript("sep_area_"+GetStringRight(GetTag(GetArea(OBJECT_SELF)), 3), OBJECT_SELF);
DestroyObject(OBJECT_SELF);
}
