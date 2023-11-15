function MascoStick.OpenPlayerModelUI(target)
    MascoStick.IsOpen = true

    MascoStick.PMFrame = vgui.Create("DFrame")
    MascoStick.PMFrame:SetTitle("Change Playermodel")
    MascoStick.PMFrame:SetSize(450, 300)
    MascoStick.PMFrame:Center()

    function MascoStick.PMFrame:OnClose()
        MascoStick.PMFrame:Remove()
        MascoStick.IsOpen = false
    end

    MascoStick.PMFrame.Scroll = MascoStick.PMFrame:Add("DScrollPanel")
    MascoStick.PMFrame.Scroll:Dock(FILL)

    MascoStick.PMFrame.Scroll.Wrapper = MascoStick.PMFrame.Scroll:Add("DIconLayout")
    MascoStick.PMFrame.Scroll.Wrapper:Dock(FILL)

    MascoStick.PMFrame.Edit = MascoStick.PMFrame:Add("DTextEntry")
    MascoStick.PMFrame.Edit:Dock(BOTTOM)
    MascoStick.PMFrame.Edit:SetText(target:GetModel())

    MascoStick.PMFrame.Button = MascoStick.PMFrame:Add("DButton")
    MascoStick.PMFrame.Button:SetText("Change")
    MascoStick.PMFrame.Button:Dock(TOP)

    function MascoStick.PMFrame.Button:DoClick()
        MascoStick.PMFrame.Button.Text = MascoStick.PMFrame.Edit:GetValue()
        RunConsoleCommand("say", "/charsetmodel " .. target:SteamID() .. " " .. MascoStick.PMFrame.Button.Text)
        MascoStick.PMFrame:Remove()
        MascoStick.IsOpen = false
    end


    for Name, Model in SortedPairs(player_manager.AllValidModels()) do
        MascoStick.PMFrame.Icon = MascoStick.PMFrame.Scroll.Wrapper:Add("SpawnIcon")
        MascoStick.PMFrame.Icon:SetModel(Model)
        MascoStick.PMFrame.Icon:SetSize(64, 64)
        MascoStick.PMFrame.Icon:SetTooltip(Name)
        MascoStick.PMFrame.Icon.playermodel = Name
        MascoStick.PMFrame.Icon.model_path = Model

        MascoStick.PMFrame.Icon.DoClick = function(self)
            MascoStick.PMFrame.Edit:SetValue(self.model_path)
        end
    end

    MascoStick.PMFrame:MakePopup()
end

function MascoStick.OpenReasonUI(target, cmd, time)
    MascoStick.IsOpen = true

    MascoStick.ReasonFrame = vgui.Create("DFrame")
    MascoStick.ReasonFrame:SetTitle("Reason for " .. cmd)
    MascoStick.ReasonFrame:SetSize(300, 150)
    MascoStick.ReasonFrame:Center()

    function MascoStick.ReasonFrame:OnClose()
        MascoStick.ReasonFrame:Remove()
        MascoStick.IsOpen = false
    end

    MascoStick.ReasonFrame.Edit = MascoStick.ReasonFrame:Add("DTextEntry")
    MascoStick.ReasonFrame.Edit:Dock(FILL)
    MascoStick.ReasonFrame.Edit:SetMultiline(true)
    MascoStick.ReasonFrame.Edit:SetPlaceholderText("Reason")

    if (cmd == "banid") then
        MascoStick.ReasonFrame.Time = MascoStick.ReasonFrame:Add("DNumSlider")
        MascoStick.ReasonFrame.Time:Dock(TOP)
        MascoStick.ReasonFrame.Time:SetText("Length (days)")
        MascoStick.ReasonFrame.Time:SetMin(0)
        MascoStick.ReasonFrame.Time:SetMax(365)
        MascoStick.ReasonFrame.Time:SetDecimals(0)
        MascoStick.ReasonFrame.Time.Edit = time
    end

    MascoStick.ReasonFrame.Button = MascoStick.ReasonFrame:Add("DButton")
    MascoStick.ReasonFrame.Button:Dock(BOTTOM)
    MascoStick.ReasonFrame.Button:SetText("Change")

    function MascoStick.ReasonFrame.Button:DoClick()
        MascoStick.ReasonFrame.Button.Text = MascoStick.ReasonFrame.Edit:GetValue()

        if cmd == "banid" then
            MasoStick.ReasonFrame.BanTime = MascoStick.ReasonFrame.Time.Edit:GetValue() * 60 * 24
            RunConsoleCommand("sam", cmd, target:SteamID(), MasoStick.ReasonFrame.BanTime, MascoStick.ReasonFrame.Button.Text)
        else
            RunConsoleCommand("sam", cmd, target:SteamID(), MascoStick.ReasonFrame.Button.Text)
        end

        MascoStick.ReasonFrame:Remove()
        MascoStick.IsOpen = false
    end

    MascoStick.ReasonFrame:MakePopup()
end

function MascoStick.OpenAdminStickUI(isright, target)
    isright = isright or false
    MascoStick.IsOpen = true
    MascoStick.AdminMenu = DermaMenu()
    local AdminMenu = MascoStick.AdminMenu

    if target:IsPlayer() then
        MascoStick.AdminMenu.Name = MascoStick.AdminMenu:AddOption("Name: " .. target:Name() .. " (left click to copy)", function()
            LocalPlayer():ChatPrint("Copied " .. target:Name() .. " to Clipboard!")
            SetClipboardText(target:Name())
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.Name:SetIcon("icon16/information.png")

        MascoStick.AdminMenu.CharID = MascoStick.AdminMenu:AddOption("CharID: " .. target:GetCharacter():GetID() .. " (left click to copy)", function()
            LocalPlayer():ChatPrint("Copied CharID: " .. target:GetCharacter():GetID() .. " to Clipboard!")
            SetClipboardText(target:GetCharacter():GetID())
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.CharID:SetIcon("icon16/information.png")

        MascoStick.AdminMenu.SteamID = MascoStick.AdminMenu:AddOption("SteamID: " .. target:SteamID() .. " (left click to copy)", function()
            LocalPlayer():ChatPrint("Copied " .. target:SteamID() .. " to Clipboard!")
            SetClipboardText(target:SteamID())
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.SteamID:SetIcon("icon16/information.png")

        MascoStick.AdminMenu.SteamID64 = MascoStick.AdminMenu:AddOption("SteamID64: " .. target:SteamID64() .. " (left click to copy)", function()
            LocalPlayer():ChatPrint("Copied " .. target:SteamID64() .. " to Clipboard!")
            SetClipboardText(target:SteamID64())
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.SteamID64:SetIcon("icon16/information.png")

        -------------------------------------------------------------------------------------------------------------

        MascoStick.AdminMenu.PlayerInfo = MascoStick.AdminMenu:AddSubMenu("Administration")

        if target:IsFrozen() then
            MascoStick.AdminMenu.PlayerInfo.Unfreeze = MascoStick.AdminMenu.PlayerInfo:AddOption("Unfreeze", function()
                RunConsoleCommand("sam", "unfreeze", target:SteamID())
                MascoStick.IsOpen = false
            end)

            MascoStick.AdminMenu.PlayerInfo.Unfreeze:SetIcon("icon16/disconnect.png")
        else
            MascoStick.AdminMenu.PlayerInfo.Freeze = MascoStick.AdminMenu.PlayerInfo:AddOption("Freeze", function()
                if LocalPlayer() == target then
                    ix.util.Notify("You can't freeze yourself. Please try again.")

                    return false
                end

                RunConsoleCommand("sam", "freeze", target:SteamID())
                MascoStick.IsOpen = false
            end)

            MascoStick.AdminMenu.PlayerInfo.Freeze:SetIcon("icon16/connect.png")
        end

        MascoStick.AdminMenu.PlayerInfo.Ban = MascoStick.AdminMenu.PlayerInfo:AddOption("Ban", function()
            MascoStick.OpenReasonUI(target, "banid", 0)
        end)

        MascoStick.AdminMenu.PlayerInfo.Ban:SetIcon("icon16/cancel.png")

        MascoStick.AdminMenu.PlayerInfo.Kick = MascoStick.AdminMenu.PlayerInfo:AddOption("Kick", function()
            MascoStick.OpenReasonUI(target, "kick", 0)
        end)

        MascoStick.AdminMenu.PlayerInfo.Kick:SetIcon("icon16/delete.png")

        MascoStick.AdminMenu.PlayerInfo.Gag = MascoStick.AdminMenu.PlayerInfo:AddOption("Gag", function()
            RunConsoleCommand("sam", "gag", target:SteamID())
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.PlayerInfo.Gag:SetIcon("icon16/sound_mute.png")

        MascoStick.AdminMenu.PlayerInfo.Ungag = MascoStick.AdminMenu.PlayerInfo:AddOption("Ungag", function()
            RunConsoleCommand("sam", "ungag", target:SteamID())
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.PlayerInfo.Ungag:SetIcon("icon16/sound_low.png")

        MascoStick.AdminMenu.PlayerInfo.Mute = MascoStick.AdminMenu.PlayerInfo:AddOption("Mute", function()
            RunConsoleCommand("sam", "mute", target:SteamID())
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.PlayerInfo.Mute:SetIcon("icon16/sound_delete.png")

        MascoStick.AdminMenu.PlayerInfo.Unmute = MascoStick.AdminMenu.PlayerInfo:AddOption("Unmute", function()
            RunConsoleCommand("sam", "unmute", target:SteamID())
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.PlayerInfo.Unmute:SetIcon("icon16/sound_add.png")

        -------------------------------------------------------------------------------------------------------------

        MascoStick.AdminMenu.CharacterInfo = MascoStick.AdminMenu:AddSubMenu("Character")

        MascoStick.AdminMenu.CharacterInfo.CharList = MascoStick.AdminMenu.CharacterInfo:AddOption("View All Characters", function()
            RunConsoleCommand("say", "/CharacterList " .. target:SteamID64())
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.CharacterInfo.CharList:SetIcon("icon16/folder_user.png")

        MascoStick.AdminMenu.CharacterInfo.Inventory = MascoStick.AdminMenu.CharacterInfo:AddOption("Search Inventory", function()
            RunConsoleCommand("say", "/SearchInventory " .. tonumber(target:GetCharacter():GetID()))
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.CharacterInfo.Inventory:SetIcon("icon16/briefcase.png")

        MascoStick.AdminMenu.CharacterInfo.ChangeName = MascoStick.AdminMenu.CharacterInfo:AddOption("Change Name", function()
            RunConsoleCommand("say", "/CharSetName " .. target:SteamID())
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.CharacterInfo.ChangeName:SetIcon("icon16/user_gray.png")


        MascoStick.AdminMenu.CharacterInfo.ChangeModel = MascoStick.AdminMenu.CharacterInfo:AddOption("Change Playermodel", function()
            MascoStick.OpenPlayerModelUI(target)
        end)

        MascoStick.AdminMenu.CharacterInfo.ChangeModel:SetIcon("icon16/user_suit.png")

        MascoStick.AdminMenu.CharacterInfo.CharPK = MascoStick.AdminMenu.CharacterInfo:AddOption("PK Character", function()
            LocalPlayer():ConCommand('say /CharBan "' .. target:SteamID() .. '"')
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.CharacterInfo.CharPK:SetIcon("icon16/lightning.png")

        MascoStick.AdminMenu.CharacterInfo.CharKick = MascoStick.AdminMenu.CharacterInfo:AddOption("Kick Character", function()
            LocalPlayer():ConCommand('say /CharKick "' .. target:SteamID() .. '"')
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.CharacterInfo.CharKick:SetIcon("icon16/lightning_delete.png")

        for _, Faction in SortedPairs(ix.faction.teams) do
            if Faction.index == target:GetCharacter():GetFaction() then
                MascoStick.AdminMenu.CharacterInfo.Faction = MascoStick.AdminMenu.CharacterInfo:AddSubMenu("Set Faction (" .. Faction.name .. ")")

                for _, ToFaction in SortedPairs(ix.faction.teams) do
                    MascoStick.AdminMenu.CharacterInfo.Faction:AddOption(ToFaction.name, function()
                        LocalPlayer():ConCommand('say /PlyTransfer "' .. target:SteamID() .. '" "' .. ToFaction.name .. '"')
                        MascoStick.IsOpen = false
                    end)
                end
            end
        end

        MascoStick.AdminMenu.CharacterInfo.Whitelist = MascoStick.AdminMenu.CharacterInfo:AddSubMenu("Give Whitelist to Faction")

        for _, Faction in SortedPairs(ix.faction.teams) do
            if not (ix.faction.HasWhitelist(Faction.index)) then
                MascoStick.AdminMenu.CharacterInfo.Whitelist:AddOption(Faction.name, function()
                    LocalPlayer():ConCommand('say /PlyWhitelist "' .. target:SteamID() .. '" "' .. Faction.name .. '"')
                    MascoStick.IsOpen = false
                end)
            end
        end

        MascoStick.AdminMenu.CharacterInfo.RemoveWhitelist = MascoStick.AdminMenu.CharacterInfo:AddSubMenu("Remove Whitelist to Faction")

        for _, Faction in SortedPairs(ix.faction.teams) do
            if (ix.faction.HasWhitelist(Faction.index)) then
                MascoStick.AdminMenu.CharacterInfo.RemoveWhitelist:AddOption(Faction.name, function()
                    LocalPlayer():ConCommand('say /PlyUnwhitelist "' .. target:SteamID() .. '" "' .. Faction.name .. '"')
                    MascoStick.IsOpen = false
                end)
            end
        end

        -------------------------------------------------------------------------------------------------------------

        MascoStick.AdminMenu.SAMFunctions = MascoStick.AdminMenu:AddSubMenu("Teleportation")

        MascoStick.AdminMenu.SAMFunctions.GoTo = MascoStick.AdminMenu.SAMFunctions:AddOption("Go To", function()
            if LocalPlayer() == target then return false end

            RunConsoleCommand("sam", "goto", target:SteamID())
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.SAMFunctions.GoTo:SetIcon("icon16/arrow_right.png")

        MascoStick.AdminMenu.SAMFunctions.Bring = MascoStick.AdminMenu.SAMFunctions:AddOption("Bring", function()
            if LocalPlayer() == target then return false end

            RunConsoleCommand("sam", "bring", target:SteamID())
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.SAMFunctions.Bring:SetIcon("icon16/arrow_down.png")

        MascoStick.AdminMenu.SAMFunctions.Return = MascoStick.AdminMenu.SAMFunctions:AddOption("Return", function()
            RunConsoleCommand("sam", "return", target:SteamID())
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.SAMFunctions.Return:SetIcon("icon16/arrow_redo.png")

        -------------------------------------------------------------------------------------------------------------

        MascoStick.AdminMenu.Flags = MascoStick.AdminMenu:AddSubMenu("Flags")

        MascoStick.AdminMenu.Flags.PETFlags = MascoStick.AdminMenu.Flags:AddOption("Give/Take PET Flags", function()
            LocalPlayer():ConCommand('say /FlagPET "' .. tonumber(target:GetCharacter():GetID()) .. '"')
            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.Flags.PETFlags:SetIcon("icon16/cross.png")

    elseif target:IsDoor() then
        MascoStick.AdminMenu.Door = MascoStick.AdminMenu.Door or {}

        MascoStick.AdminMenu.Door.Title = MascoStick.AdminMenu:AddOption("Set Door Title", function()
            Derma_StringRequest('Set Door Title', 'Enter Title of Door', '', function(text)
            LocalPlayer():ConCommand('say /DoorSetTitle ' .. text)
            end)

            MascoStick.IsOpen = false
        end)

        MascoStick.AdminMenu.Door.Title:SetIcon("icon16/door.png")

        if target:GetNetVar("title") != nil or target:GetNetVar("name") != nil then
            MascoStick.AdminMenu.Door.RemoveTitle = MascoStick.AdminMenu:AddOption("Remove Door Title", function()
                net.Start("MascoStick::RemoveDoorTitle")
                net.WriteEntity(target)
                net.SendToServer()
                
                MascoStick.IsOpen = false
            end)

            MascoStick.AdminMenu.Door.RemoveTitle:SetIcon("icon16/door.png")
        end

        if target:GetNetVar("visible") == true then
            MascoStick.AdminMenu.Door.Hide = MascoStick.AdminMenu:AddOption("Make Door Hidden", function()
                LocalPlayer():ConCommand('say /DoorSetHidden true')
                MascoStick.IsOpen = false
            end)

            MascoStick.AdminMenu.Door.Hide:SetIcon("icon16/door.png")

        elseif target:GetNetVar("visible") == nil or target:GetNetVar("visible") == false then
            MascoStick.AdminMenu.Door.Visible = MascoStick.AdminMenu:AddOption("Make Door Visible", function()
                LocalPlayer():ConCommand('say /DoorSetHidden false')
                MascoStick.IsOpen = false
            end)

            MascoStick.AdminMenu.Door.Visible:SetIcon("icon16/door.png")
        end

        if target:GetNetVar("ownable") == nil then
            MascoStick.AdminMenu.Door.Ownable = MascoStick.AdminMenu:AddOption("Make Door Ownable", function()
                LocalPlayer():ConCommand('say /DoorSetOwnable')
                MascoStick.IsOpen = false
            end)

            MascoStick.AdminMenu.Door.Ownable:SetIcon("icon16/door_in.png")

        elseif target:GetNetVar("ownable") == true then
            MascoStick.AdminMenu.Door.Unownable = MascoStick.AdminMenu:AddOption("Make Door Unownable", function()
                LocalPlayer():ConCommand('say /DoorSetUnownable')
                MascoStick.IsOpen = false
            end)

            MascoStick.AdminMenu.Door.Unownable:SetIcon("icon16/door_in.png")
        end

        MascoStick.AdminMenu.AddFaction = MascoStick.AdminMenu:AddSubMenu("Add Faction To Door")

        for _, Faction in SortedPairs(ix.faction.teams) do
            MascoStick.AdminMenu.AddFaction.Factions = string.Split(target:GetNetVar("faction", ""), ",")
            if table.HasValue(MascoStick.AdminMenu.AddFaction.Factions, tostring(Faction.index)) then continue end

            MascoStick.AdminMenu.AddFaction:AddOption(Faction.name, function()
                LocalPlayer():ConCommand('say /DoorSetFaction "' .. Faction.name .. '"')
                MascoStick.IsOpen = false
            end)
        end

        if target:GetNetVar("faction") != nil then
            MascoStick.AdminMenu.RemoveFaction = MascoStick.AdminMenu:AddSubMenu("Remove Faction From Door")

            for _, Faction in SortedPairs(ix.faction.teams) do
                MascoStick.AdminMenu.RemoveFaction.Factions = string.Explode(",", target:GetNetVar("faction", ""))
                if not table.HasValue(MascoStick.AdminMenu.RemoveFaction.Factions, tostring(Faction.index)) then continue end

                MascoStick.AdminMenu.RemoveFaction:AddOption(Faction.name, function()
                    LocalPlayer():ConCommand('say /DoorSetFaction ')
                    MascoStick.IsOpen = false
                end)
            end

            MascoStick.AdminMenu.RemoveFaction.ClearAll = MascoStick.AdminMenu:AddOption("Clear Factions From Door", function()
                LocalPlayer():ConCommand('say /DoorSetFaction ')
                MascoStick.IsOpen = false
            end)
        end
    end

    function MascoStick.AdminMenu:OnClose()
        MascoStick.IsOpen = false
    end

    MascoStick.AdminMenu:Open()
    MascoStick.AdminMenu:Center()
end