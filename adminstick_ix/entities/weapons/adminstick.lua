AddCSLuaFile()

SWEP.Author = "Masco"
SWEP.PrintName = "Admin Stick"
SWEP.Purpose = "Instructions: Press R when looking at someone to select them. \nPress Shift+R to select yourself. \nLeft click to open the menu. \nRight click with selection to freeze them."
SWEP.ViewModelFOV = 90
SWEP.Category = "NutScript"
SWEP.ViewModelFlip = false
SWEP.IsAlwaysRaised = true
SWEP.Spawnable = true
SWEP.AnimPrefix = "stunstick"
SWEP.ViewModel = Model("models/weapons/v_stunstick.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

function SWEP:PrimaryAttack()
    if (SERVER) then return end
    MascoStick.StickTarget = IsValid(LocalPlayer().AdminStickTarget) and LocalPlayer().AdminStickTarget or LocalPlayer():GetEyeTrace().Entity

    if not IsValid(MascoStick.StickTarget) then return end
    
    if not MascoStick.StickTarget:IsPlayer() then
        if MascoStick.StickTarget:IsVehicle() and IsValid(MascoStick.StickTarget:GetDriver()) then
            MascoStick.StickTarget = MascoStick.StickTarget:GetDriver()
        end
    end

    if MascoStick.StickTarget:IsPlayer() or MascoStick.StickTarget:IsDoor() or MascoStick.StickTarget:GetClass() == "ix_storage" then
        MascoStick.OpenAdminStickUI(false, MascoStick.StickTarget)
    end
end

function SWEP:SecondaryAttack()
    if (SERVER) then return end
    MascoStick.StickTarget = IsValid(LocalPlayer().AdminStickTarget) and LocalPlayer().AdminStickTarget or LocalPlayer():GetEyeTrace().Entity

    if not IsFirstTimePredicted() or not IsValid(MascoStick.StickTarget) then return end

    if not MascoStick.StickTarget:IsPlayer() then
        if MascoStick.StickTarget:IsVehicle() and IsValid(MascoStick.StickTarget:GetDriver()) then
            MascoStick.StickTarget = MascoStick.StickTarget:GetDriver()
        end
    end

    if MascoStick.StickTarget:IsPlayer() and MascoStick.StickTarget != LocalPlayer() then
        MascoStick.StickTarget.Command = MascoStick.StickTarget:IsFrozen() and "sam unfreeze" or "sam freeze"
        LocalPlayer():ConCommand(MascoStick.StickTarget.Command .. " " .. MascoStick.StickTarget:SteamID())
    else
        LocalPlayer():Notify("You cannot freeze what you are looking at. Please try again.")
    end
end

function SWEP:DrawHUD()
    if (SERVER) then return end
    MascoStick.StickTarget = IsValid(LocalPlayer().AdminStickTarget) and LocalPlayer().AdminStickTarget or LocalPlayer():GetEyeTrace().Entity

    MascoStick.StickTarget.Client = MascoStick.StickTarget.Client or {}

    MascoStick.StickTarget.Client.X, MascoStick.StickTarget.Client.Y = ScrW() / 2, ScrH() / 2
    MascoStick.StickTarget.CrossColor = Color(255, 0, 0)
    MascoStick.StickTarget.Information = {}

    if not IsValid(MascoStick.StickTarget) then return end

    if not MascoStick.StickTarget:IsPlayer() then
        if MascoStick.StickTarget:IsVehicle() and IsValid(MascoStick.StickTarget:GetDriver()) then
            MascoStick.StickTarget = MascoStick.StickTarget:GetDriver()
        end
    end

    if MascoStick.StickTarget:IsPlayer() then
        MascoStick.StickTarget.CrossColor = Color(0, 255, 0)

        MascoStick.StickTarget.Information = {
            IsValid(LocalPlayer().AdminStickTarget) and "Player (Selected with Reload)" or "Player", "Nickname: " .. MascoStick.StickTarget:Nick(), "Steam Name: " .. (MascoStick.StickTarget.SteamName and MascoStick.StickTarget:SteamName() or MascoStick.StickTarget:Name()), "Steam ID: " .. MascoStick.StickTarget:SteamID(), "Health: " .. MascoStick.StickTarget:Health(), "Armor: " .. MascoStick.StickTarget:Armor(), "Usergroup: " .. MascoStick.StickTarget:GetUserGroup()
        }

        if MascoStick.StickTarget:GetCharacter() then
            MascoStick.StickTarget.Character = MascoStick.StickTarget:GetCharacter()
            MascoStick.StickTarget.Faction = ix.faction.indices[MascoStick.StickTarget:Team()]

            table.Add(MascoStick.StickTarget.Information, {"Character Name: " .. MascoStick.StickTarget.Character:GetName(), "Character Faction: " .. MascoStick.StickTarget.Faction.uniqueID .. " (" .. MascoStick.StickTarget.Faction.name .. ")"})
        else
            table.insert(MascoStick.StickTarget.Information, "No Loaded Character")
        end
    elseif MascoStick.StickTarget:IsWorld() then
        if not LocalPlayer().NextRequestInfo or SysTime() >= LocalPlayer().NextRequestInfo then
            LocalPlayer().NextRequestInfo = SysTime() + 1
        end

        MascoStick.StickTarget.Information = {"Entity", "Class: " .. MascoStick.StickTarget:GetClass(), "Model: " .. MascoStick.StickTarget:GetModel(), "Position: " .. tostring(MascoStick.StickTarget:GetPos()), "Angles: " .. tostring(MascoStick.StickTarget:GetAngles()), "Owner: " .. tostring(MascoStick.StickTarget:GetNWString("Creator_Nick", "NULL")), "EntityID: " .. MascoStick.StickTarget:EntIndex()}

        MascoStick.StickTarget.CrossColor = Color(255, 255, 0)
    else
        if not LocalPlayer().NextRequestInfo or SysTime() >= LocalPlayer().NextRequestInfo then
            LocalPlayer().NextRequestInfo = SysTime() + 1
        end

        MascoStick.StickTarget.Information = {"Entity", "Class: " .. MascoStick.StickTarget:GetClass(), "Model: " .. MascoStick.StickTarget:GetModel(), "Position: " .. tostring(MascoStick.StickTarget:GetPos()), "Angles: " .. tostring(MascoStick.StickTarget:GetAngles()), "Owner: " .. tostring(MascoStick.StickTarget:GetNWString("Creator_Nick", "NULL")), "EntityID: " .. MascoStick.StickTarget:EntIndex()}

        MascoStick.StickTarget.CrossColor = Color(255, 255, 0)
    end

    MascoStick.StickTarget.Client.Length = 20
    MascoStick.StickTarget.Client.Thickness = 1
    surface.SetDrawColor(MascoStick.StickTarget.CrossColor)
    surface.DrawRect(MascoStick.StickTarget.Client.X - MascoStick.StickTarget.Client.Length / 2, MascoStick.StickTarget.Client.Y - MascoStick.StickTarget.Client.Thickness / 2, MascoStick.StickTarget.Client.Length, MascoStick.StickTarget.Client.Thickness)
    surface.DrawRect(MascoStick.StickTarget.Client.X - MascoStick.StickTarget.Client.Thickness / 2, MascoStick.StickTarget.Client.Y - MascoStick.StickTarget.Client.Length / 2, MascoStick.StickTarget.Client.Thickness, MascoStick.StickTarget.Client.Length)
    MascoStick.StickTarget.Client.StartPosX, MascoStick.StickTarget.Client.StartPosY = ScrW() / 2 + 10, ScrH() / 2 + 10
    MascoStick.StickTarget.Client.Font = "DebugFixed"
    MascoStick.StickTarget.Client.Buffer = 0

    for k, v in pairs(MascoStick.StickTarget.Information) do
        surface.SetFont(MascoStick.StickTarget.Client.Font)
        surface.SetTextColor(color_black)
        surface.SetTextPos(MascoStick.StickTarget.Client.StartPosX + 1, MascoStick.StickTarget.Client.StartPosY + MascoStick.StickTarget.Client.Buffer + 1)
        surface.DrawText(v)
        surface.SetTextColor(MascoStick.StickTarget.CrossColor)
        surface.SetTextPos(MascoStick.StickTarget.Client.StartPosX, MascoStick.StickTarget.Client.StartPosY + MascoStick.StickTarget.Client.Buffer)
        surface.DrawText(v)
        local t_w, t_h = surface.GetTextSize(v)
        MascoStick.StickTarget.Client.Buffer = MascoStick.StickTarget.Client.Buffer + t_h
    end
end

function SWEP:Reload()
    if (SERVER) then return end
    if self.NextReload and self.NextReload > SysTime() then return end

    self.NextReload = SysTime() + 0.5

    MascoStick.StickTarget.Client.LookingAt = LocalPlayer():KeyDown(IN_SPEED) and LocalPlayer() or LocalPlayer():GetEyeTrace().Entity

    if IsValid(MascoStick.StickTarget.Client.LookingAt) and not MascoStick.StickTarget.Client.LookingAt:IsPlayer() then
        if MascoStick.StickTarget.Client.LookingAt:IsVehicle() and IsValid(MascoStick.StickTarget.Client.LookingAt:GetDriver()) then
            MascoStick.StickTarget.Client.LookingAt = MascoStick.StickTarget.Client.LookingAt:GetDriver()
        end
    end

    if IsValid(MascoStick.StickTarget.Client.LookingAt) and MascoStick.StickTarget.Client.LookingAt:IsPlayer() then
        LocalPlayer().AdminStickTarget = MascoStick.StickTarget.Client.LookingAt
    else
        LocalPlayer().AdminStickTarget = nil
    end
end

function SWEP:DrawWorldModel()
	if not MascoStick.StaffGroups[self:GetOwner():GetUserGroup()] and self:GetOwner():GetMoveType() == MOVETYPE_NOCLIP then
		return
	end
	self:DrawModel()
end