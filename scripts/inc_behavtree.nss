#include "nwnx_behavtree"

// A behaviour tree is a way to craft artificial intelligence.
//
// References: http://www.gamasutra.com/blogs/ChrisSimpson/20140717/221339/Behavior_trees_for_AI_How_they_work.php
//             https://github.com/libgdx/gdx-ai/wiki/Behavior-Trees
//
// A hypothetical AI which will attempt to sit and eat if no enemies are nearby might look like:
//
//                   +----------------------------------+
//                   | sit_and_eat_if_no_enemies_nearby |
//                   +----------------------------------+
//                                    |                      FAILURE
//                                    |                         |
//                              +-----------+                   |
//                              | Is Hungry | N -----------------
//                              +-----------+                   |
//                                    Y                         |
//                                    |                         |
//                              +-----------+                   |
//                              | Has food  | N -----------------
//                              +-----------+                   |
//                                    Y                         |
//                                    |                         |
//                            +---------------+                 |
//        ----------------- N | Enemies near  | Y ---------------
//        |                   +---------------+                 |
//        |                                                     |
//  +---------------+         +---------------+                 |
//  | Sit on chair  | N ----- | Sit on floor  | N ---------------
//  +---------------+         +---------------+                 |
//        Y                            Y                        |
//        |                            |                        |
//        |                    +-------------+                  |
//        ---------------------| Devour food | N ----------------
//                             +-------------+                  |
//                                     Y                        |
//                                     |                        |
//                                  +------+                    |
//                                  | Burp | N ------------------
//                                  +------+
//
//
// This same AI expressed in behaviour tree code would look like:
//
//     BTCreate(obj, "sit_and_eat_if_no_enemies_nearby",
//         BTCompositeSequence(
//             BTLeafScript("bt_ishungry"),
//             BTLeafScript("bt_hasfood"),
//             BTDecoratorInvert(
//                 BTLeafScript("bt_enemynear")
//             ),
//             BTCompositeSelector(
//                 BTLeafScript("bt_sitonchair"),
//                 BTLeafScript("bt_sitonground")
//             ),
//             BTLeafScript("bt_devour"),
//             BTLeafScript("bt_burp")
//     );
//
// To create and process process trees, the following functions can be called:
//

// This function creates the behaviour tree. It should be combined with one or more nodes.
void BTCreate(object obj, string name, int childId);

// This clears (deletes) the behaviour tree.
void BTClear(object obj, string name);

// This ticks the behaviour tree.
// This can be called as often as you want; most sensible rate is every heartbeat.
void BTTick(object obj, string name);

//
// The tree is comprised of nodes. When executed, nodes will return a success code:
//

// Indicates that the action failed to complete.
const int BT_FAILURE = 0;

// Indicates that the action completed successful.
const int BT_SUCCESS = 1;

// Indicates that the action is still running.
const int BT_RUNNING = 2;

//
// Nodes can be one of three types:
//
// 1. Composite: This node type has one or more children, and executes its children.
//
// 1.1. CompositeRandomSelector: As BTCompositeSelector, except randomises its order each time
//                               the parent node returns BT_FAILURE or BT_SUCCESS.
//

int BTCompositeRandomSelector(
    int child1,       int child2  = -1, int child3  = -1, int child4  = -1, int child5  = -1, int child6  = -1, int child7  = -1, int child8  = -1,
    int child9  = -1, int child10 = -1, int child11 = -1, int child12 = -1, int child13 = -1, int child14 = -1, int child15 = -1, int child16 = -1,
    int child17 = -1, int child18 = -1, int child19 = -1, int child20 = -1, int child21 = -1, int child22 = -1, int child23 = -1, int child24 = -1,
    int child25 = -1, int child26 = -1, int child27 = -1, int child28 = -1, int child29 = -1, int child30 = -1, int child31 = -1, int child32 = -1);

//
// 1.2. CompositeRandomSequence: As BTCompositeSequence, except randomises its order each time
//                               the parent node returns BT_FAILURE or BT_SUCCESS.
//

int BTCompositeRandomSequence(
    int child1,       int child2  = -1, int child3  = -1, int child4  = -1, int child5  = -1, int child6  = -1, int child7  = -1, int child8  = -1,
    int child9  = -1, int child10 = -1, int child11 = -1, int child12 = -1, int child13 = -1, int child14 = -1, int child15 = -1, int child16 = -1,
    int child17 = -1, int child18 = -1, int child19 = -1, int child20 = -1, int child21 = -1, int child22 = -1, int child23 = -1, int child24 = -1,
    int child25 = -1, int child26 = -1, int child27 = -1, int child28 = -1, int child29 = -1, int child30 = -1, int child31 = -1, int child32 = -1);

//
// 1.3. CompositeSelector: Executes its children in order.
//
//                         - Returns BT_RUNNING if one of the children returns BT_RUNNING.
//                         - Returns BT_SUCCESS if one of the children returns BT_SUCCESS.
//                         - Else, returns BT_FAILURE.
//
//                         Can be considered functionally equivalent to an OR gate.
//

int BTCompositeSelector(
    int child1,       int child2  = -1, int child3  = -1, int child4  = -1, int child5  = -1, int child6  = -1, int child7  = -1, int child8  = -1,
    int child9  = -1, int child10 = -1, int child11 = -1, int child12 = -1, int child13 = -1, int child14 = -1, int child15 = -1, int child16 = -1,
    int child17 = -1, int child18 = -1, int child19 = -1, int child20 = -1, int child21 = -1, int child22 = -1, int child23 = -1, int child24 = -1,
    int child25 = -1, int child26 = -1, int child27 = -1, int child28 = -1, int child29 = -1, int child30 = -1, int child31 = -1, int child32 = -1);

//
// 1.3. CompositeSequence: Executes its children in order.
//
//                         - Returns BT_RUNNING if one of the children returns BT_RUNNING.
//                         - Returns BT_FAILURE if one of the children returns BT_FAILURE.
//                         - Else, returns BT_SUCCESS.
//
//                         Can be considered functionally equivalent to an AND gate.
//

int BTCompositeSequence(
    int child1,       int child2  = -1, int child3  = -1, int child4  = -1, int child5  = -1, int child6  = -1, int child7  = -1, int child8  = -1,
    int child9  = -1, int child10 = -1, int child11 = -1, int child12 = -1, int child13 = -1, int child14 = -1, int child15 = -1, int child16 = -1,
    int child17 = -1, int child18 = -1, int child19 = -1, int child20 = -1, int child21 = -1, int child22 = -1, int child23 = -1, int child24 = -1,
    int child25 = -1, int child26 = -1, int child27 = -1, int child28 = -1, int child29 = -1, int child30 = -1, int child31 = -1, int child32 = -1);

//
// 2. Decorator: This node type has one child. It mutates the return value of its child.
//
// 2.1. DecoratorInvert: Inverts the output of the child node, such that ...
//      - BT_SUCCESS -> BT_FAILURE
//      - BT_FAILURE -> BT_SUCCESS
//      - BT_RUNNING -> BT_RUNNING
//

int BTDecoratorInvert(int childId);

//
// 3. Leaf: This node type has no children, and represents 'actions'.
//
// 3.1. LeafAlwaysFail: Always returns BT_FAILURE.
//

int BTLeafAlwaysFail();

//
// 3.2. LeafAlwaysSucceed: Always returns BT_SUCCESS.
//

int BTLeafAlwaysSucceed();

//
// 3.3. LeafSleep: Returns BT_RUNNING for the first durationInMs, then returns BT_SUCCESS.
//

int BTLeafSleep(int durationInMs);

void BTCreate(object obj, string name, int childId)
{
    NWNX_BehaviourTree_CreateBT(obj, name, childId);
}

void BTClear(object obj, string name)
{
    NWNX_BehaviourTree_ClearBT(obj, name);
}

void BTTick(object obj, string name)
{
    NWNX_BehaviourTree_TickBT(obj, name);
}

int BTCompositeRandomSelector(
    int child1,       int child2  = -1, int child3  = -1, int child4  = -1, int child5  = -1, int child6  = -1, int child7  = -1, int child8  = -1,
    int child9  = -1, int child10 = -1, int child11 = -1, int child12 = -1, int child13 = -1, int child14 = -1, int child15 = -1, int child16 = -1,
    int child17 = -1, int child18 = -1, int child19 = -1, int child20 = -1, int child21 = -1, int child22 = -1, int child23 = -1, int child24 = -1,
    int child25 = -1, int child26 = -1, int child27 = -1, int child28 = -1, int child29 = -1, int child30 = -1, int child31 = -1, int child32 = -1)
{
    return NWNX_BehaviourTree_CreateCompositeRandomSelector(
        child1,  child2,  child3,  child4,  child5,  child6,  child7,  child8,
        child9,  child10, child11, child12, child13, child14, child15, child16,
        child17, child18, child19, child20, child21, child22, child23, child24,
        child25, child26, child27, child28, child29, child30, child31, child32);
}

int BTCompositeRandomSequence(
    int child1,       int child2  = -1, int child3  = -1, int child4  = -1, int child5  = -1, int child6  = -1, int child7  = -1, int child8  = -1,
    int child9  = -1, int child10 = -1, int child11 = -1, int child12 = -1, int child13 = -1, int child14 = -1, int child15 = -1, int child16 = -1,
    int child17 = -1, int child18 = -1, int child19 = -1, int child20 = -1, int child21 = -1, int child22 = -1, int child23 = -1, int child24 = -1,
    int child25 = -1, int child26 = -1, int child27 = -1, int child28 = -1, int child29 = -1, int child30 = -1, int child31 = -1, int child32 = -1)
{
    return NWNX_BehaviourTree_CreateCompositeRandomSequence(
        child1,  child2,  child3,  child4,  child5,  child6,  child7,  child8,
        child9,  child10, child11, child12, child13, child14, child15, child16,
        child17, child18, child19, child20, child21, child22, child23, child24,
        child25, child26, child27, child28, child29, child30, child31, child32);
}

int BTCompositeSelector(
    int child1,       int child2  = -1, int child3  = -1, int child4  = -1, int child5  = -1, int child6  = -1, int child7  = -1, int child8  = -1,
    int child9  = -1, int child10 = -1, int child11 = -1, int child12 = -1, int child13 = -1, int child14 = -1, int child15 = -1, int child16 = -1,
    int child17 = -1, int child18 = -1, int child19 = -1, int child20 = -1, int child21 = -1, int child22 = -1, int child23 = -1, int child24 = -1,
    int child25 = -1, int child26 = -1, int child27 = -1, int child28 = -1, int child29 = -1, int child30 = -1, int child31 = -1, int child32 = -1)
{
    return NWNX_BehaviourTree_CreateCompositeSelector(
        child1,  child2,  child3,  child4,  child5,  child6,  child7,  child8,
        child9,  child10, child11, child12, child13, child14, child15, child16,
        child17, child18, child19, child20, child21, child22, child23, child24,
        child25, child26, child27, child28, child29, child30, child31, child32);
}

int BTCompositeSequence(
    int child1,       int child2  = -1, int child3  = -1, int child4  = -1, int child5  = -1, int child6  = -1, int child7  = -1, int child8  = -1,
    int child9  = -1, int child10 = -1, int child11 = -1, int child12 = -1, int child13 = -1, int child14 = -1, int child15 = -1, int child16 = -1,
    int child17 = -1, int child18 = -1, int child19 = -1, int child20 = -1, int child21 = -1, int child22 = -1, int child23 = -1, int child24 = -1,
    int child25 = -1, int child26 = -1, int child27 = -1, int child28 = -1, int child29 = -1, int child30 = -1, int child31 = -1, int child32 = -1)
{
    return NWNX_BehaviourTree_CreateCompositeSequence(
        child1,  child2,  child3,  child4,  child5,  child6,  child7,  child8,
        child9,  child10, child11, child12, child13, child14, child15, child16,
        child17, child18, child19, child20, child21, child22, child23, child24,
        child25, child26, child27, child28, child29, child30, child31, child32);
}

int BTDecoratorInvert(int childId)
{
    return NWNX_BehaviourTree_CreateDecoratorInvert(childId);
}

int BTLeafAlwaysFail()
{
    return NWNX_BehaviourTree_CreateLeafAlwaysFail();
}

int BTLeafAlwaysSucceed()
{
    return NWNX_BehaviourTree_CreateLeafAlwaysSucceed();
}

int BTLeafSleep(int durationInMs)
{
    return NWNX_BehaviourTree_CreateLeafSleep(durationInMs);
}
