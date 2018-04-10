//called from convo 'trwlrs_tble1'
//opens store after convo
//see ls_trawlers_main for details

void main()
{
    object oStore = GetNearestObjectByTag("trawlers_store_002");
    if (GetObjectType(oStore) == OBJECT_TYPE_STORE)
    {
        OpenStore(oStore, GetPCSpeaker());
    }
    else
    {
        ActionSpeakStringByStrRef(53090, TALKVOLUME_SILENT_TALK);
    }
}
