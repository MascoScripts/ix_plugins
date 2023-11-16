-------------------------
-- Add Network Strings --
-------------------------

util.AddNetworkString("MascoStick::OpenTargetInventory")
util.AddNetworkString("MascoStick::SendCharacterList")
util.AddNetworkString("MascoStick::RemoveDoorTitle")
util.AddNetworkString("MascoStick::SendCharacterTable")

--------------------------
-- Serverside Functions --
--------------------------

function PLUGIN:PostPlayerLoadout(ply)
    -- Change the FACTION_STAFF to your Staff faction.
    if ply:Team() == FACTION_CITIZEN then
        ply:Give("adminstick")
    end
end

function PLUGIN:PlayerSpawnedNPC(client, entity)
    entity:SetCreator(client)
    entity:SetNWString("Creator_Nick", client:Nick())
end

function PLUGIN:PlayerSpawnedEntity(client, entity)
    entity:SetNWString("Creator_Nick", client:Nick())
    entity:SetCreator(client)
end

-----------------------
-- Remove Door Title --
-----------------------

net.Receive("MascoStick::RemoveDoorTitle", function(len, ply)
    if not MascoStick.StaffGroups[ply:GetUserGroup()] then return end

    MascoStick.DoorTarget = net.ReadEntity()
    
    if MascoStick.DoorTarget:IsDoor() then
        MascoStick.DoorTarget:SetNetVar("title", nil)
        MascoStick.DoorTarget:SetNetVar("name", nil)
    end
end)