#include "HooksVirtual.h"
#include "HooksVirtual.h"
#include "LibFunctions.h"
#include "MovementManager.h"

SINGLETONBODY(DeviousDevices::HooksVirtual)

void DeviousDevices::HooksVirtual::Setup()
{
    if (!_init)
    {
        // Vtable of MovementHandler
        REL::Relocation<std::uintptr_t> vtbl_MovementHandler{RELOCATION_ID(263056, 208715).address()};
        ProcessButton_old = vtbl_MovementHandler.write_vfunc(0x04, ProcessButton);
        ProcessThumbstick_old = vtbl_MovementHandler.write_vfunc(0x02, ProcessThumbstick);
        
        // Vtable of AutoMoveHandler - 1418B6EA0 - xxxx/208725
        REL::Relocation<std::uintptr_t> vtbl_MovementHandlerAM{RELOCATION_ID(263061, 208725).address()};
        ProcessButtonAM_old = vtbl_MovementHandlerAM.write_vfunc(0x04, ProcessButtonAM);

        REL::Relocation<std::uintptr_t> vtbl_player{RE::PlayerCharacter::VTABLE[0]};
        DrawWeaponMagicHands_old = vtbl_player.write_vfunc(REL::Module::GetRuntime() != REL::Module::Runtime::VR ? 0x0A6 : 0x0A8, DrawWeaponMagicHands);

        // Vtable of SprintHandler - 1418B6DB0 - xxxx/208681
        //REL::Relocation<std::uintptr_t> vtbl_SprintHandler{RELOCATION_ID(0, 208717).address()};
        //ProcessButtonSH_old = vtbl_SprintHandler.write_vfunc(0x04, ProcessButtonSH);

        _init = true;
    }
}

void DeviousDevices::HooksVirtual::ProcessButton(RE::MovementHandler* a_this, RE::ButtonEvent* a_event, RE::PlayerControlsData* a_data)
{
    LOG("HooksVirtual::ProcessButton() called")
    ProcessButton_old(a_this,a_event,a_data);

    MovementManager::GetSingleton()->ManagePlayerInput(a_data);
}

void DeviousDevices::HooksVirtual::ProcessButtonAM(RE::AutoMoveHandler* a_this, RE::ButtonEvent* a_event, RE::PlayerControlsData* a_data)
{
    LOG("HooksVirtual::ProcessButton() called")
    ProcessButtonAM_old(a_this,a_event,a_data);

    MovementManager::GetSingleton()->ManagePlayerInput(a_data);
}

void DeviousDevices::HooksVirtual::ProcessThumbstick(RE::MovementHandler* a_this, RE::ThumbstickEvent* a_event, RE::PlayerControlsData* a_data)
{
    ProcessThumbstick_old(a_this,a_event,a_data);

    if (a_event->GetIDCode() != 11)
    {
        // This is not left analogue stick. Exit
        return;
    }

    MovementManager::GetSingleton()->ManagePlayerInput(a_data);
}

void DeviousDevices::HooksVirtual::DrawWeaponMagicHands(RE::PlayerCharacter* a_this, bool a_draw)
{
    LOG("HooksVirtual::DrawWeaponMagicHands() called")
    if (a_draw && MovementManager::GetSingleton()->ManageWeapons(a_this))
    {
        return;
    }
    DrawWeaponMagicHands_old(a_this,a_draw);
}

// Reversed function from Sprint Handler. Its no longer usefull, but wasted too much time reversing it so I keep it for possible future use
// This is fully functional and usable
/*
void DeviousDevices::HooksVirtual::ProcessButtonSH(RE::SprintHandler* a_this, RE::ButtonEvent* a_event, RE::PlayerControlsData* a_data)
{
    if (a_event->value != 0.0f && a_event->heldDownSecs == 0.0f)
    {
        static auto loc_player = RE::PlayerCharacter::GetSingleton();
        static auto loc_owner  = loc_player->AsActorValueOwner();
        const auto loc_stamina = loc_owner->GetActorValue(RE::ActorValue::kStamina);

        uint8_t* loc_unk = reinterpret_cast<uint8_t*>((uintptr_t)loc_player + (uintptr_t)0xBE5U);
        if (loc_stamina > 0.0f || (*loc_unk & 0x01U))
        {
            *loc_unk = *loc_unk ^ 0x01U;
        }
        else 
        {
            // 0x1409767C0 = 0x140976640 + 0x180
            REL::Relocation<void(*)(RE::ActorValue)> unk_fun{ RELOCATION_ID(0, 52845).address()};

            unk_fun(RE::ActorValue::kStamina);
        }
    }

    //ProcessButtonSH_old(a_this,a_event,a_data);
}
*/