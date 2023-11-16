net.Receive("MascoStick::OpenTargetInventory", function(len, ply)
    MascoStick.TargetInventoryID = net.ReadUInt(32)
    MascoStick.TargetName = net.ReadString()

    MascoStick.TargetInventory = ix.inventory.Get(MascoStick.TargetInventoryID)

    if (MascoStick.TargetInventory and MascoStick.TargetInventory.slots) then
        MascoStick.ClientInv = LocalPlayer():GetCharacter():GetInventory()
        MascoStick.InvPanel = vgui.Create("ixStorageView")

        if (MascoStick.ClientInv) then
            MascoStick.InvPanel:SetLocalInventory(MascoStick.ClientInv)
            ix.gui.inv1:CenterHorizontal(0.7)
            ix.gui.inv1:CenterVertical()
            ix.gui.inv1:SetTitle(LocalPlayer():GetCharacter():GetName() .. "'s Inventory")
        end

        MascoStick.InvPanel:SetStorageID(MascoStick.TargetInventoryID)
        MascoStick.InvPanel:SetStorageInventory(MascoStick.TargetInventory)
        MascoStick.InvPanel.storageInventory:CenterHorizontal(0.3)
        MascoStick.InvPanel.storageInventory:CenterVertical()
        MascoStick.InvPanel.storageInventory:SetTitle(MascoStick.TargetName .. "'s Inventory")
    else
        return
    end
end)