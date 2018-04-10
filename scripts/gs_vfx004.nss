#include "gs_inc_iprop"

void main()
{
    if (GetLocalInt(OBJECT_SELF, "GS_ENABLED")) return;
    SetLocalInt(OBJECT_SELF, "GS_ENABLED", TRUE);

    ActionDoCommand(gsIPLoadCostTable1());
    ActionDoCommand(gsIPLoadCostTable2());
    ActionDoCommand(gsIPLoadCostTable3());
    ActionDoCommand(gsIPLoadParamTable());
    ActionDoCommand(gsIPLoadPropertyTable());
    ActionDoCommand(gsIPLoadItemCategoryTable());
    ActionDoCommand(gsIPLoadValidationTable());

    ActionDoCommand(gsIPLoadAppearanceTable("parts_belt",     ITEM_APPR_ARMOR_MODEL_BELT));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_bicep",    ITEM_APPR_ARMOR_MODEL_LBICEP));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_bicep",    ITEM_APPR_ARMOR_MODEL_RBICEP));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_chest",    ITEM_APPR_ARMOR_MODEL_TORSO));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_foot",     ITEM_APPR_ARMOR_MODEL_LFOOT));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_foot",     ITEM_APPR_ARMOR_MODEL_RFOOT));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_forearm",  ITEM_APPR_ARMOR_MODEL_LFOREARM));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_forearm",  ITEM_APPR_ARMOR_MODEL_RFOREARM));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_hand",     ITEM_APPR_ARMOR_MODEL_LHAND));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_hand",     ITEM_APPR_ARMOR_MODEL_RHAND));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_legs",     ITEM_APPR_ARMOR_MODEL_LTHIGH));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_legs",     ITEM_APPR_ARMOR_MODEL_RTHIGH));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_neck",     ITEM_APPR_ARMOR_MODEL_NECK));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_pelvis",   ITEM_APPR_ARMOR_MODEL_PELVIS));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_robe",     ITEM_APPR_ARMOR_MODEL_ROBE));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_shin",     ITEM_APPR_ARMOR_MODEL_LSHIN));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_shin",     ITEM_APPR_ARMOR_MODEL_RSHIN));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_shoulder", ITEM_APPR_ARMOR_MODEL_LSHOULDER));
    ActionDoCommand(gsIPLoadAppearanceTable("parts_shoulder", ITEM_APPR_ARMOR_MODEL_RSHOULDER));

    ActionDoCommand(gsIPLoadTable("cloakmodel"));
    ActionDoCommand(gsIPCreateDummyTable("helmetmodel", 35));

    ActionDoCommand(SetLocalInt(GetModule(), "GS_IP_ENABLED", TRUE));

    ActionDoCommand(DestroyObject(OBJECT_SELF));
}
