util.AddNetworkString("MascoType::CreateDocumentInv")

net.Receive("MascoType::CreateDocumentInv", function(len, ply)
    local documentName = net.ReadString()
    local documentBody = net.ReadString()
    local quantityAmount = net.ReadInt(32)
    local inventory = ply:GetCharacter():GetInventory()
    local characterName = ply:GetCharacter():GetName()

    if quantityAmount > tonumber(ix.config.Get("MaxQuantityAmount")) or quantityAmount < 1 then
        ply:Notify("Cheating ass bastard. Stop trying to hack to the typewriters.")
        return
    end

    local titleTooLong = #documentName > 128
	local titleTooShort = #documentName == 0

    if titleTooLong or titleTooShort then
        ply:Notify(titleTooLong and "The title cannot be longer than 128 characters in length!" or "The title cannot be empty!")
        return
    end

    local bodyTooLong = #documentBody > 256
	local bodyTooShort = #documentBody < 16
	
    if bodyTooLong or bodyTooShort then
        ply:Notify(bodyTooLong and "The document body cannot be longer than 256 characters in length!" or "The document body cannot be any shorter than 16 characters in length!")
        return
    end

    if inventory and string.StartsWith(documentBody, "https://docs.google.com/") then
        timer.Create("CreateItemDocuments", 0.5, quantityAmount, function()
            inventory:Add("paper", 1, {
                documentName = documentName,
                documentBody = documentBody,
                creator = characterName
            })
        end)

        ply:Notify('You created ' .. quantityAmount .. ' document(s) titled "' .. documentName .. '".')
    else
        ply:Notify("Something went wrong. Try again.")
        return
    end
end)