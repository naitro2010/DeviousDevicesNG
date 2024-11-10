#include "HooksVirtual.h"
#include "HooksVirtual.h"
#include "HooksVirtual.h"
#include "LibFunctions.h"

SINGLETONBODY(DeviousDevices::HooksVirtual)

void DeviousDevices::HooksVirtual::Setup()
{
    if (!_init)
    {
        // Vtable of MovementHandler
        REL::Relocation<std::uintptr_t> vtbl_MovementHandler{RELOCATION_ID(263056, 208715).address()};
        ProcessButton_old = vtbl_MovementHandler.write_vfunc(0x04, ProcessButton);
        ProcessThumbstick_old = vtbl_MovementHandler.write_vfunc(0x02, ProcessThumbstick);

        REL::Relocation<std::uintptr_t> vtbl_player{RE::PlayerCharacter::VTABLE[0]};
        DrawWeaponMagicHands_old = vtbl_player.write_vfunc(REL::Module::GetRuntime() != REL::Module::Runtime::VR ? 0x0A6 : 0x0A8, DrawWeaponMagicHands);

        _init = true;
    }
}

void DeviousDevices::HooksVirtual::ProcessButton(RE::MovementHandler* a_this, RE::ButtonEvent* a_event, RE::PlayerControlsData* a_data)
{
    ProcessButton_old(a_this,a_event,a_data);

    // calculate amplitude
    const float loc_ampl = a_data->moveInputVec.Length();

    static const auto loc_self = GetSingleton();
    static const float loc_maxspeed = ConfigManager::GetSingleton()->GetVariable<float>("Movement.afMaxSpeedMult",0.15f);

    if (loc_ampl > loc_maxspeed && loc_self->_PlayerForceWalk)
    {
        // recalculate vector, so the direction of pointing is same, but the amplitude is reduced
        a_data->moveInputVec.x = (a_data->moveInputVec.x)*loc_maxspeed;
        a_data->moveInputVec.y = (a_data->moveInputVec.y)*loc_maxspeed;
    }
}

void DeviousDevices::HooksVirtual::ProcessThumbstick(RE::MovementHandler* a_this, RE::ThumbstickEvent* a_event, RE::PlayerControlsData* a_data)
{
    ProcessThumbstick_old(a_this,a_event,a_data);

    if (a_event->GetIDCode() != 11)
    {
        // This is not left analogue stick. Exit
        return;
    }

    // calculate amplitude
    const float loc_ampl = a_data->moveInputVec.Length();

    static const auto loc_self = GetSingleton();
    static const float loc_maxspeed = ConfigManager::GetSingleton()->GetVariable<float>("Movement.afMaxSpeedMult",0.15f);

    if (loc_ampl > loc_maxspeed && loc_self->_PlayerForceWalk)
    {
        // recalculate vector, so the direction of pointing is same, but the amplitude is reduced
        a_data->moveInputVec.x = (a_data->moveInputVec.x)*loc_maxspeed;
        a_data->moveInputVec.y = (a_data->moveInputVec.y)*loc_maxspeed;
    }
}

void DeviousDevices::HooksVirtual::DrawWeaponMagicHands(RE::PlayerCharacter* a_this, bool a_draw)
{
    static const auto loc_self = GetSingleton();
    if (a_draw && loc_self->_PlayerDisableDraw)
    {
        return;
    }
    DrawWeaponMagicHands_old(a_this,a_draw);
}

void DeviousDevices::HooksVirtual::Update()
{
    DEBUG("HooksVirtual::Update()")

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
