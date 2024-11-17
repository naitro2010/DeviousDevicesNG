#include "HooksVirtual.h"
#include "LibFunctions.h"
#include "MovementManager.h"
static bool DDInventoryUnequip = false;
static std::recursive_mutex unequip_mutex;
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
        REL::Relocation<std::uintptr_t> vtbl_actor{RE::Actor::VTABLE[0]};
        REL::Relocation<std::uintptr_t> vtbl_character{RE::Character::VTABLE[0]};

        REL::Relocation<std::uintptr_t> vtbl_player{RE::PlayerCharacter::VTABLE[0]};
        
        PlayerCharacterUnequipItem_old = vtbl_player.write_vfunc(0xA1, PlayerCharacterUnequipItem);
        CharacterUnequipItem_old = vtbl_character.write_vfunc(0xA1, CharacterUnequipItem);
        ActorUnequipItem_old = vtbl_actor.write_vfunc(0xA1, ActorUnequipItem);
        
        DrawWeaponMagicHands_old = vtbl_player.write_vfunc(REL::Module::GetRuntime() != REL::Module::Runtime::VR ? 0x0A6 : 0x0A8, DrawWeaponMagicHands);

        _init = true;
    }
}
bool DeviousDevices::HooksVirtual::GetNormalUnequipMode()
{ 
    std::lock_guard<std::recursive_mutex> lk(unequip_mutex);
    return DDInventoryUnequip;
}
void DeviousDevices::HooksVirtual::ActorUnequipItem(RE::Actor* a_this, std::uint64_t a_arg1,
    RE::TESBoundObject* a_object)
{
    {
        std::lock_guard<std::recursive_mutex> lk(unequip_mutex);
        DDInventoryUnequip = true;
    }
    ActorUnequipItem_old(a_this, a_arg1, a_object);
    {
        std::lock_guard<std::recursive_mutex> lk(unequip_mutex);
        DDInventoryUnequip = false;
    }
}
void DeviousDevices::HooksVirtual::CharacterUnequipItem(RE::Actor* a_this, std::uint64_t a_arg1,
    RE::TESBoundObject* a_object) {
    {
        std::lock_guard<std::recursive_mutex> lk(unequip_mutex);
        DDInventoryUnequip = true;
    }
    CharacterUnequipItem_old(a_this, a_arg1, a_object);
    {
        std::lock_guard<std::recursive_mutex> lk(unequip_mutex);
        DDInventoryUnequip = false;
    }
}
void DeviousDevices::HooksVirtual::PlayerCharacterUnequipItem(RE::Actor* a_this, std::uint64_t a_arg1,
    RE::TESBoundObject* a_object)
{
    {
        std::lock_guard<std::recursive_mutex> lk(unequip_mutex);
        DDInventoryUnequip = true;
    }
    PlayerCharacterUnequipItem_old(a_this, a_arg1, a_object);
    {
        std::lock_guard<std::recursive_mutex> lk(unequip_mutex);
        DDInventoryUnequip = false;
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
