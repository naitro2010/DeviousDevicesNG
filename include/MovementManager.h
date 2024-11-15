#pragma once

namespace DeviousDevices
{
    class MovementManager
    {
    SINGLETONHEADER(MovementManager)
    public:
        void Setup();
        void Update();

        float ManageSpeed(RE::Actor* a_actor,float a_speed);
        void  ManageAutoMove(RE::PlayerControls* a_pc);
        void  ManagePlayerInput(RE::PlayerControlsData* a_data);
        bool  ManageWeapons(RE::Actor* a_actor);
    private:
        bool _init = false;
        bool _PlayerForceWalk       = false;
        bool _PlayerDisableDraw     = false;

    };
}
