// This include file contains functionality for performing a visual emote.

#include "inc_zombie"

// NOTE: If you add a new emote, ADD IT IN ALPHABETICAL ORDER!
// If you add an emote to the end, make sure to update EMOTE_LAST!

const int EMOTE_BOW = 0;
const int EMOTE_CAST = 1;
const int EMOTE_CHEER = 2;
const int EMOTE_CONJURE = 3;
const int EMOTE_CROUCH = 4;
const int EMOTE_DANCE = 5;
const int EMOTE_FALL = 6;
const int EMOTE_KNEEL = 7;
const int EMOTE_LAUGH = 8;
const int EMOTE_LEAVE = 9;
const int EMOTE_LIE = 10;
const int EMOTE_READ = 11;
const int EMOTE_SCOFF = 12;
const int EMOTE_SIT = 13;
const int EMOTE_THREATEN = 14;
const int EMOTE_TREMBLE = 15;
const int EMOTE_WAVE = 16;
const int EMOTE_WORSHIP = 17;

const int EMOTE_FIRST = EMOTE_BOW;
const int EMOTE_LAST = EMOTE_WORSHIP;
const int EMOTE_INVALID_ID = -1;
const string EMOTE_INVALID_STR = "";

// Performs the provided emote on the provided target.
// If the target is in an invalid state, e.g. a zombie, it may fail.
void PerformEmote(int emoteId, object target);

// Converts an emote to its ID. Returns EMOTE_INVALID_ID if no match.
int EmoteStringToId(string emote);

// Converts an emote ID to its string representation. Returns EMOTE_INVALID_STR if invalid.
string EmoteIdToString(int emoteId);

void PerformEmote(int emoteId, object target)
{
    if (emoteId == EMOTE_BOW)
    {
        AssignCommand(target, PlayAnimation(ANIMATION_FIREFORGET_BOW));
    }
    else if (emoteId == EMOTE_CAST)
    {
        if (fbZGetIsZombie(target))
        {
            FloatingTextStringOnCreature("You would feel quite silly doing something like that.", target, FALSE);
        }
        else
        {
            AssignCommand(target, PlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0, 3600.0));
        }
    }
    else if (emoteId == EMOTE_CHEER)
    {
        if (fbZGetIsZombie(target))
        {
            FloatingTextStringOnCreature("You really don't see how cheering is going to net you a brain to eat.", target, FALSE);
        }
        else
        {
            AssignCommand(target, PlayAnimation(ANIMATION_FIREFORGET_VICTORY2));
            PlayVoiceChat(VOICE_CHAT_CHEER, target);
        }
    }
    else if (emoteId == EMOTE_CONJURE)
    {
        if (fbZGetIsZombie(target))
        {
            FloatingTextStringOnCreature("You would feel quite silly doing something like that.", target, FALSE);
        }
        else
        {
            AssignCommand(target, PlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 3600.0));
        }
    }
    else if (emoteId == EMOTE_CROUCH)
    {
        AssignCommand(target, PlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3600.0));
    }
    else if (emoteId == EMOTE_DANCE)
    {
        if (fbZGetIsZombie(target))
        {
            // THRILLER!
            AssignCommand(target, fbZInitializeDance());
        }
        else
        {
            int nNth = 0;
            for (; nNth < 60; nNth++)
            {
                switch (Random(8))
                {
                    case 0: AssignCommand(target, ActionPlayAnimation(ANIMATION_FIREFORGET_BOW, 0.5));         break;
                    case 1: AssignCommand(target, ActionPlayAnimation(ANIMATION_FIREFORGET_DODGE_DUCK, 0.25)); break;
                    case 2: AssignCommand(target, ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM, 0.125));     break;
                    case 3: AssignCommand(target, ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT, 0.5));       break;
                    case 4: AssignCommand(target, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1, 0.5));    break;
                    case 5: AssignCommand(target, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2, 0.5));    break;
                    case 6: AssignCommand(target, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 0.5, 4.0));  break;
                    case 7: AssignCommand(target, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 0.5, 4.0));  break;
                }
            }
        }
    }
    else if (emoteId == EMOTE_FALL)
    {
        SetLocalLocation(target, "MI_SIT_LOCATION", GetLocation(target));
        AssignCommand(target, PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 3600.0));
    }
    else if (emoteId == EMOTE_KNEEL)
    {
        SetLocalLocation(target, "MI_SIT_LOCATION", GetLocation(target));
        AssignCommand(target, PlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 3600.0));
    }
    else if (emoteId == EMOTE_LAUGH)
    {
        if (fbZGetIsZombie(target))
        {
            FloatingTextStringOnCreature("You know what you need to laugh? Healthy lungs. You know what you lack? Healthy lungs.", target, FALSE);
        }
        else
        {
            AssignCommand(target, PlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING, 1.0, 2.0));
            PlayVoiceChat(VOICE_CHAT_LAUGH, target);
        }
    }
    else if (emoteId == EMOTE_LEAVE)
    {
        if (fbZGetIsZombie(target))
        {
            FloatingTextStringOnCreature("When you remember how limited your vocabulary is right now, you decide not to say goodbye after all.", target, FALSE);
        }
        else
        {
            AssignCommand(target, PlayAnimation(ANIMATION_FIREFORGET_GREETING));
            PlayVoiceChat(VOICE_CHAT_GOODBYE, target);
        }
    }
    else if (emoteId == EMOTE_LIE)
    {
        SetLocalLocation(target, "MI_SIT_LOCATION", GetLocation(target));
        AssignCommand(target, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 3600.0));
    }
    else if (emoteId == EMOTE_READ)
    {
        if (fbZGetIsZombie(target))
        {
            FloatingTextStringOnCreature("Zombies can't read. You'd know that if you had ever read anything about zombies. But you haven't, because you can't read.", target, FALSE);
        }
        else
        {
            AssignCommand(target, PlayAnimation(ANIMATION_FIREFORGET_READ));
        }
    }
    else if (emoteId == EMOTE_SCOFF)
    {
        if (fbZGetIsZombie(target))
        {
            FloatingTextStringOnCreature("If you want to taunt someone, do it when your craving for cranial tissue has gone down a bit.", target, FALSE);
        }
        else
        {
            AssignCommand(target, PlayAnimation(ANIMATION_FIREFORGET_TAUNT));
            PlayVoiceChat(VOICE_CHAT_TAUNT, target);
        }
    }
    else if (emoteId == EMOTE_SIT)
    {
        if (fbZGetIsZombie(target))
        {
            FloatingTextStringOnCreature("You attempt to sit down, but after considering what a pain it would be to get up again in your current state, you decide you didn't really want to sit down after all.", target, FALSE);
        }
        else
        {
            SetLocalLocation(target, "MI_SIT_LOCATION", GetLocation(target));
            AssignCommand(target, PlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, 3600.0));
        }
    }
    else if (emoteId == EMOTE_THREATEN)
    {
        if (fbZGetIsZombie(target))
        {
            FloatingTextStringOnCreature("You're pretty threatening already, no need to overdo it.", target, FALSE);
        }
        else
        {
            AssignCommand(target, PlayAnimation(ANIMATION_FIREFORGET_VICTORY3));
            PlayVoiceChat(VOICE_CHAT_THREATEN, target);
        }
    }
    else if (emoteId == EMOTE_TREMBLE)
    {
        AssignCommand(target, PlayAnimation(ANIMATION_FIREFORGET_SPASM));
    }
    else if (emoteId == EMOTE_WAVE)
    {
        if (fbZGetIsZombie(target))
        {
            FloatingTextStringOnCreature("The greeting you most feel like giving right now is a gnaw on the noggin.", target, FALSE);
        }
        else
        {
            AssignCommand(target, PlayAnimation(ANIMATION_FIREFORGET_GREETING));
            PlayVoiceChat(VOICE_CHAT_HELLO, target);
        }
    }
    else if (emoteId == EMOTE_WORSHIP)
    {
        SetLocalLocation(target, "MI_SIT_LOCATION", GetLocation(target));
        AssignCommand(target, PlayAnimation(ANIMATION_LOOPING_WORSHIP, 1.0, 3600.0));
    }
}

int EmoteStringToId(string emote)
{
    emote = GetStringUpperCase(emote);

    if      (emote == "BOW")      return EMOTE_BOW;
    else if (emote == "CAST")     return EMOTE_CAST;
    else if (emote == "CHEER")    return EMOTE_CHEER;
    else if (emote == "CONJURE")  return EMOTE_CONJURE;
    else if (emote == "CROUCH")   return EMOTE_CROUCH;
    else if (emote == "DANCE")    return EMOTE_DANCE;
    else if (emote == "FALL")     return EMOTE_FALL;
    else if (emote == "KNEEL")    return EMOTE_KNEEL;
    else if (emote == "LAUGH")    return EMOTE_LAUGH;
    else if (emote == "LEAVE")    return EMOTE_LEAVE;
    else if (emote == "LIE")      return EMOTE_LIE;
    else if (emote == "READ")     return EMOTE_READ;
    else if (emote == "SCOFF")    return EMOTE_SCOFF;
    else if (emote == "SIT")      return EMOTE_SIT;
    else if (emote == "THREATEN") return EMOTE_THREATEN;
    else if (emote == "TREMBLE")  return EMOTE_TREMBLE;
    else if (emote == "WAVE")     return EMOTE_WAVE;
    else if (emote == "WORSHIP")  return EMOTE_WORSHIP;

    return EMOTE_INVALID_ID;
}

string EmoteIdToString(int emoteId)
{
    switch (emoteId)
    {
        case EMOTE_BOW:      return "Bow";
        case EMOTE_CAST:     return "Cast";
        case EMOTE_CHEER:    return "Cheer";
        case EMOTE_CONJURE:  return "Conjure";
        case EMOTE_CROUCH:   return "Crouch";
        case EMOTE_DANCE:    return "Dance";
        case EMOTE_FALL:     return "Fall";
        case EMOTE_KNEEL:    return "Kneel";
        case EMOTE_LAUGH:    return "Laugh";
        case EMOTE_LEAVE:    return "Leave";
        case EMOTE_LIE:      return "Lie";
        case EMOTE_READ:     return "Read";
        case EMOTE_SCOFF:    return "Scoff";
        case EMOTE_SIT:      return "Sit";
        case EMOTE_THREATEN: return "Threaten";
        case EMOTE_TREMBLE:  return "Tremble";
        case EMOTE_WAVE:     return "Wave";
        case EMOTE_WORSHIP:  return "Worship";
    }

    return EMOTE_INVALID_STR;
}
