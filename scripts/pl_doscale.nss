//::  AR_SCALE is a local float variable to scale the placeable.
//::  AR_ROTATE_X is a local float to rotate the placeable on the X axis.
//::  AR_ROTATE_Y is a local float to rotate the placeable on the Y axis.
//::  AR_ROTATE_Z is a local float to rotate the placeable on the Z axis.
//::  AR_TRANSF_X is a local float to transform the placeable on the X axis.
//::  AR_TRANSF_Y is a local float to transform the placeable on the Y axis.
//::  AR_TRANSF_Z is a local float to transform the placeable on the Z axis.

void main()
{
    if (GetLocalInt(OBJECT_SELF, "AR_DO_ONCE"))
        return;

    SetLocalInt(OBJECT_SELF, "AR_DO_ONCE", TRUE);

    object oObject = GetFirstObjectInArea();
    while (GetIsObjectValid(oObject))
    {
        int iEffect     = GetLocalInt(oObject, "AR_VFX");
        float fScale    = GetLocalFloat(oObject, "AR_SCALE");
        float fRotateX  = GetLocalFloat(oObject, "AR_ROTATE_X");
        float fRotateY  = GetLocalFloat(oObject, "AR_ROTATE_Y");
        float fRotateZ  = GetLocalFloat(oObject, "AR_ROTATE_Z");
        float fTransfX  = GetLocalFloat(oObject, "AR_TRANSF_X");
        float fTransfY  = GetLocalFloat(oObject, "AR_TRANSF_Y");
        float fTransfZ  = GetLocalFloat(oObject, "AR_TRANSF_Z");

        if (iEffect) {
            effect eEffect = EffectVisualEffect(iEffect);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oObject);
        }
if (fScale > 0.0f && fScale != 1.0f) {
            SetObjectVisualTransform(oObject, OBJECT_VISUAL_TRANSFORM_SCALE, fScale);
        }

        if (fRotateX != 0.0f) {
               SetObjectVisualTransform(oObject, 21, fRotateX);
            }

        if (fRotateY != 0.0f ) {
               SetObjectVisualTransform(oObject, 22, fRotateY);
            }

        if (fRotateZ != 0.0f) {
               SetObjectVisualTransform(oObject, 23, fRotateZ);
            }

        if (fTransfX != 0.0f) {
               SetObjectVisualTransform(oObject, 31, fTransfX);
            }

        if (fTransfY != 0.0f) {
               SetObjectVisualTransform(oObject, 32, fTransfY);
            }

        if (fTransfZ != 0.0f) {
               SetObjectVisualTransform(oObject, 33, fTransfZ);
            }

        oObject = GetNextObjectInArea();
    }

    DestroyObject(OBJECT_SELF, 1.0);
}