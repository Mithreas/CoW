// Scripted by Septire
// Created 08/07/2016
// Script will be used on a trigger to apply a wide range of effects if a save is failed.
void main()
{
    // Interface
    string sSaveType      = GetLocalString(OBJECT_SELF, "SaveType");
    int nSaveDC           = GetLocalInt(OBJECT_SELF, "SaveDC");
    string sSaveDC        = GetLocalString(OBJECT_SELF, "SaveDC");
    string sDie           = GetLocalString(OBJECT_SELF, "DieToRoll");
    int nTimes            = GetLocalInt(OBJECT_SELF, "NumberOfDice");
    int nVisualEffect     = GetLocalInt(OBJECT_SELF, "VisualEffectNumber");
    string sDamageType    = GetLocalString(OBJECT_SELF, "DamageType");
    int isKnockdownEffect = GetLocalInt(OBJECT_SELF, "appliesKnockdown");
    int nCooldownDelay    = GetLocalInt(OBJECT_SELF, "CooldownAsSeconds");

    // Default values
    if (!nVisualEffect) nVisualEffect = 473;
    if (!nTimes) nTimes = 2;
    if (!nSaveDC) nSaveDC = 18;
    if (!nCooldownDelay) nCooldownDelay = 12;
    if (StringToInt(sSaveDC)) nSaveDC = StringToInt(sSaveDC);

    // Cooldown
    int isOnCooldown = GetLocalInt(OBJECT_SELF, "DISABLED");
    if (isOnCooldown) return;

    SetLocalInt(OBJECT_SELF, "DISABLED", TRUE);
    DelayCommand(IntToFloat(nCooldownDelay), DeleteLocalInt(OBJECT_SELF, "DISABLED"));

    // Main functionality
    object oEntering   = GetEnteringObject();
    location lLocation = GetLocation(oEntering);
    object oMaster = GetMaster(oEntering);
    
    if (!GetIsPC(oEntering) && !GetIsPC(oMaster)) return;

    // Visual Effect
    ApplyEffectAtLocation(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect(nVisualEffect),
        Location(
            GetAreaFromLocation(lLocation),
            GetPositionFromLocation(lLocation),
            90.0));

    // Handle saves
    if (sSaveType == "reflex") {
        if (ReflexSave(oEntering, nSaveDC)) return;
    }
    else if (sSaveType == "fortitude") {
        if (FortitudeSave(oEntering, nSaveDC)) return;
    }
    else if (sSaveType == "will") {
        if (WillSave(oEntering, nSaveDC)) return;
    }
    else {
        if (ReflexSave(oEntering, nSaveDC)) return;
    }

    // Damage switch
    int nDamage = 0;
    if (sDie == "d2") {
        nDamage = d2(nTimes);
    }
    else if (sDie == "d3") {
        nDamage = d3(nTimes);
    }
    else if (sDie == "d4") {
        nDamage = d4(nTimes);
    }
    else if (sDie == "d6") {
        nDamage = d6(nTimes);
    }
    else if (sDie == "d8") {
        nDamage = d8(nTimes);
    }
    else if (sDie == "d10") {
        nDamage = d10(nTimes);
    }
    else if (sDie == "d12") {
        nDamage = d12(nTimes);
    }
    else if (sDie == "d20") {
        nDamage = d20(nTimes);
    }
    else if (sDie == "d100") {
        nDamage = d100(nTimes);
    }
    else {
        nDamage = d6(nTimes);
    }

    // Damage type switch
    int nDamageType = 0;
    if (sDamageType == "acid") {
        nDamageType = DAMAGE_TYPE_ACID;
    }
    else if (sDamageType == "bludgeoning") {
        nDamageType = DAMAGE_TYPE_BLUDGEONING;
    }
    else if (sDamageType == "cold") {
        nDamageType = DAMAGE_TYPE_COLD;
    }
    else if (sDamageType == "divine") {
        nDamageType = DAMAGE_TYPE_DIVINE;
    }
    else if (sDamageType == "electrical") {
        nDamageType = DAMAGE_TYPE_ELECTRICAL;
    }
    else if (sDamageType == "fire") {
        nDamageType = DAMAGE_TYPE_FIRE;
    }
    else if (sDamageType == "magical") {
        nDamageType = DAMAGE_TYPE_MAGICAL;
    }
    else if (sDamageType == "negative") {
        nDamageType = DAMAGE_TYPE_NEGATIVE;
    }
    else if (sDamageType == "piercing") {
        nDamageType = DAMAGE_TYPE_PIERCING;
    }
    else if (sDamageType == "positive") {
        nDamageType = DAMAGE_TYPE_POSITIVE;
    }
    else if (sDamageType == "slashing") {
        nDamageType = DAMAGE_TYPE_SLASHING;
    }
    else if (sDamageType == "sonic") {
        nDamageType = DAMAGE_TYPE_SONIC;
    }
    else {
        nDamageType = DAMAGE_TYPE_BLUDGEONING;
    }

    // Apply Effects
    AssignCommand(oEntering,
        ClearAllActions());

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectDamage(
            nDamage,
            nDamageType),
        oEntering);

    if (isKnockdownEffect) {
        ApplyEffectToObject(
            DURATION_TYPE_TEMPORARY,
            EffectKnockdown(),
            oEntering,
            6.0);
    }
}
