PLUGIN = PLUGIN
PLUGIN.name = "Admin Stick"
PLUGIN.author = "Masco"
PLUGIN.description = "An admin stick with basic staff commands."

MascoStick = MascoStick or {}

-------------------------
-- IX Utility Includes --
-------------------------

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")
ix.util.Include("derma/cl_inventoryview.lua")
ix.util.Include("derma/cl_characterlist.lua")

---------------------------------------
-- CAMI replacement for Staff Groups --
-- Replace these ranks with your own --
---------------------------------------

MascoStick.StaffGroups = {
    ["superadmin"] = true,
    ["admin"] = true
}

------------------
-- IX Functions --
------------------

function MascoStick.GetCharacterData(CharID, key)
    MascoStick.CharBanOfflineSelect = mysql:Select("ix_characters");
        MascoStick.CharBanOfflineSelect:Where("id", CharID);
        MascoStick.CharBanOfflineSelect:Callback(function(result, status, lastID)
            if (type(result) == "table" and #result > 0 and result[1].data) then
                MascoStick.CharacterData.DataTable = util.JSONToTable(result[1].data)
            end
        end);
    MascoStick.CharBanOfflineSelect:Execute(true)
end

function MascoStick.SetCharacterData(CharID, key, val)
    MascoStick.GetCharacterData(CharID)
    
    MascoStick.CharacterData = MascoStick.CharacterData or {}

    if not MascoStick.CharacterData.DataTable then return false end

    MascoStick.CharacterData.DataTable[key] = val

    local JSONDataTable = util.TableToJSON(MascoStick.CharacterData.DataTable)

    MascoStick.CharBanOfflineUpdate = mysql:Update("ix_characters");
        MascoStick.CharBanOfflineUpdate:Update("data", JSONDataTable);
        MascoStick.CharBanOfflineUpdate:Where("id", CharID);
        MascoStick.CharBanOfflineUpdate:Callback(function(result, status, lastID)
            if not status then
                return false
            end
        end);
    MascoStick.CharBanOfflineUpdate:Execute();

    if ix.char.loaded[CharID] then
        ix.char.loaded[CharID]:SetData(key, val)
    end

    return true
end

-----------------
-- IX Commands --
-----------------

ix.command.Add("FlagPET", {
    description = "Gives the targeted character the PET Flags all at once.",
	arguments = {
		ix.type.number
	},
    OnCanRun = function(client)
        if MascoStick.StaffGroups[client:GetUserGroup()] then
            return true
        else
            client:Notify("You do not have the correct permission to use this command.")
            return false
        end
    end,
    OnRun = function(self, client, target)
        MascoStick.TargetCharacter = ix.char.loaded[target]
        
        if MascoStick.TargetCharacter:HasFlags("pet") then
            MascoStick.TargetCharacter:TakeFlags("pet")
            client:Notify("You have taken " .. MascoStick.TargetCharacter:GetName() .. "'s PET flags.")
        else
            MascoStick.TargetCharacter:GiveFlags("pet")
            client:Notify("You have given " .. MascoStick.TargetCharacter:GetName() .. " PET flags.")
        end
    end
})

ix.command.Add("SearchInventory", {
    description = "Searches the target's inventory.",
	arguments = {
		ix.type.number
	},
    OnCanRun = function(client)
        if MascoStick.StaffGroups[client:GetUserGroup()] then
            return true
        else
            client:Notify("You do not have the correct permission to use this command.")
            return false
        end
    end,
    OnRun = function(self, client, target)
        MascoStick.TargetCharacter = ix.char.loaded[target]
        
        if MascoStick.TargetCharacter == client:GetCharacter() then
            client:Notify("You can not search your own inventory. Please try again.")
            return
        end
        MascoStick.TargetCharacter.InventoryID = MascoStick.TargetCharacter:GetInventory():GetID()
        MascoStick.TargetCharacter.Inventory = ix.inventory.Get(MascoStick.TargetCharacter.InventoryID)

        if (MascoStick.TargetCharacter.Inventory) then
            MascoStick.TargetCharacter.Inventory:Sync(client)
            MascoStick.TargetCharacter.Inventory:AddReceiver(client)

            MascoStick.TargetCharacter.Name = MascoStick.TargetCharacter:GetName()

            net.Start("MascoStick::OpenTargetInventory")
            net.WriteUInt(MascoStick.TargetCharacter.InventoryID, 32)
            net.WriteString(MascoStick.TargetCharacter.Name)
            net.Send(client)
        else
            client:Notify("We couldn't find an inventory with the supplied ID. Please try again.")
        end

        return false
    end
})

ix.command.Add("CharacterList", {
    description = "Lists the characters of the targeted player.",
	arguments = {
		ix.type.string
	},
    OnCanRun = function(client)
        if MascoStick.StaffGroups[client:GetUserGroup()] then
            return true
        else
            client:Notify("You do not have the correct permission to use this command.")
            return false
        end
    end,
    OnRun = function(self, client, steamid)
        MascoStick.CharacterList = mysql:Select("ix_characters");
            MascoStick.CharacterList:Where("steamid", steamid);
            MascoStick.CharacterList:Callback(function(result, status, lastID)
                if (type(result) == "table" and #result > 0) then
                    net.Start("MascoStick::SendCharacterList")
                    MascoStick.CharacterList.Length = #result
                    net.WriteUInt(MascoStick.CharacterList.Length, 10)
                    
                    for _, character in ipairs(result) do
                        if type(character.data) == "string" then
                            MascoStick.CharacterList.UseData = util.JSONToTable(character.data) or {}
                        end
                        MascoStick.CharacterList.CharacterID = character.id
                        MascoStick.CharacterList.Name = character.name
                        MascoStick.CharacterList.Description = character.description
                        MascoStick.CharacterList.Faction = character.faction
                        MascoStick.CharacterList.Money = character.money
                        MascoStick.CharacterList.Banned = MascoStick.CharacterList.UseData.banned and "Yes" or "No"

                        net.WriteUInt(MascoStick.CharacterList.CharacterID, 32)
                        net.WriteString(MascoStick.CharacterList.Name)
                        net.WriteString(MascoStick.CharacterList.Description)
                        net.WriteString(MascoStick.CharacterList.Faction)
                        net.WriteUInt(MascoStick.CharacterList.Money, 32)
                        net.WriteString(MascoStick.CharacterList.Banned)
                    end
                    net.Send(client)
                end
            end);
        MascoStick.CharacterList:Execute(true);
    end
})

ix.command.Add("CharBanOffline", {
    description = "Bans (PK) the targeted character when they are offline.",
	arguments = {
		ix.type.number
	},
    OnCanRun = function(client)
        if MascoStick.StaffGroups[client:GetUserGroup()] then
            return true
        else
            client:Notify("You do not have the correct permission to use this command.")
            return false
        end
    end,
    OnRun = function(self, client, charid)
        MascoStick.SetCharacterData(charid, "banned", true)

        for _, player in ipairs(player.GetAll()) do
            if player:GetCharacter() and player:GetCharacter():GetID() == charid then
                player:GetCharacter():Kick()
                break
            end
        end

        client:Notify("You have Offline Character Banned (PK) Character ID #" .. charid)
    end
})

ix.command.Add("CharUnbanOffline", {
    description = "Unbans (Un-PK) the targeted character when they are offline.",
	arguments = {
		ix.type.number
	},
    OnCanRun = function(client)
        if MascoStick.StaffGroups[client:GetUserGroup()] then
            return true
        else
            client:Notify("You do not have the correct permission to use this command.")
            return false
        end
    end,
    OnRun = function(self, client, charid)
        MascoStick.SetCharacterData(charid, "banned", nil)

        client:Notify("You have Offline Unbanned (UnPK) Character ID #" .. charid)
    end
})