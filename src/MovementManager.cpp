#include "MovementManager.h"
#include "LibFunctions.h"

SINGLETONBODY(DeviousDevices::MovementManager)

void DeviousDevices::MovementManager::Setup()
{
    if (!_init)
    {
        _init = true;
    }
}

void DeviousDevices::MovementManager::Update()
{
    LOG("MovementManager::Update() called")

    static auto loc_disablecombatkwds = ConfigManager::GetSingleton()->GetArrayText("Movement.asDisableCombatKeywords",false);
    
    _PlayerDisableDraw = false;
    for (auto&& it :loc_disablecombatkwds)
    {
        if (LibFunctions::GetSingleton()->WornHasKeywordAll(RE::PlayerCharacter::GetSingleton(),it))
        {
            _PlayerDisableDraw = true;
            break;
        }
    }
    
    static auto loc_forcewalkkwds = ConfigManager::GetSingleton()->GetArrayText("Movement.asForceWalkKeywords",false);
    
    _PlayerForceWalk = false;
    for (auto&& it :loc_forcewalkkwds)
    {
        if (LibFunctions::GetSingleton()->WornHasKeywordAll(RE::PlayerCharacter::GetSingleton(),it))
        {
            _PlayerForceWalk = true;
            break;
        }
    }
}

float DeviousDevices::MovementManager::ManageSpeed(RE::Actor* a_actor, float a_speed)
{
    static const float loc_maxspeed = ConfigManager::GetSingleton()->GetVariable<float>("Movement.afMaxSpeed",20.0f);
    if (a_speed > loc_maxspeed && _PlayerForceWalk) a_speed = loc_maxspeed;
    return a_speed;
}

void DeviousDevices::MovementManager::ManageAutoMove(RE::PlayerControls* a_pc)
{
    ManagePlayerInput(&a_pc->data);
}

void DeviousDevices::MovementManager::ManagePlayerInput(RE::PlayerControlsData* a_data)
{
    static const auto loc_camera = RE::PlayerCamera::GetSingleton();
    if (_PlayerForceWalk && (!loc_camera || !loc_camera->IsInFreeCameraMode()))
    {
        static const float loc_maxspeed = ConfigManager::GetSingleton()->GetVariable<float>("Movement.afMaxSpeedMult",0.15f);
        if (std::abs(a_data->moveInputVec.x) > loc_maxspeed) a_data->moveInputVec.x = a_data->moveInputVec.x > 0.0f ? loc_maxspeed : -1.0f*loc_maxspeed;
        if (std::abs(a_data->moveInputVec.y) > loc_maxspeed) a_data->moveInputVec.y = a_data->moveInputVec.y > 0.0f ? loc_maxspeed : -1.0f*loc_maxspeed;
    }
}

bool DeviousDevices::MovementManager::ManageWeapons(RE::Actor* a_actor)
{
    return _PlayerDisableDraw;
}
