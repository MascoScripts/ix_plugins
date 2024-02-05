PLUGIN.name = "Third Person Toggle"
PLUGIN.author = "Masco"
PLUGIN.description = "Adds a keybind for third person toggling."

local keybind = KEY_F4 -- Check for key code here: https://wiki.facepunch.com/gmod/Enums/KEY
local antispam_time = 1 -- Seconds

hook.Add("PlayerButtonDown", "CustomThirdPersonBind", function(ply, button)
    if button != keybind or not IsFirstTimePredicted() then return end

    ply.AntiSpamThirdPerson = ply.AntiSpamThirdPerson or CurTime()
    local timeRemaining = ply.AntiSpamThirdPerson - CurTime()
    if ply.AntiSpamThirdPerson > CurTime() then return end

    ply.AntiSpamThirdPerson = CurTime() + antispam_time

    if CLIENT then
        LocalPlayer():ConCommand("ix_togglethirdperson")
    end
end)