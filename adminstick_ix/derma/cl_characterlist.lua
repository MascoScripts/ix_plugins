net.Receive("MascoStick::SendCharacterList", function(len, ply)
    MascoStick.CharacterList = MascoStick.CharacterList or {}

    MascoStick.CharacterList.Length = net.ReadUInt(10)

    local width, height = ScrW(), ScrH()

    local frame_background = Color(20, 20, 20)
    local frame_header_background = Color(40, 40, 40)
    local red_button_hovered = Color(189, 32, 0)
    local red_button = Color(138, 23, 0)
    local gray_button = Color(35, 35, 35)
    local dlist_background = Color(23, 23, 23)

    surface.CreateFont("CharacterListTitle", {
        font = "Roboto",
        size = 16,
        weight = 300,
    })

    surface.CreateFont("CharacterListGeneral", {
        font = "Roboto",
        size = 16,
        weight = 500,
    })

    surface.CreateFont("CharacterListButton", {
        font = "Roboto",
        size = 14,
        weight = 500,
    })

    MascoStick.CharacterFrame = vgui.Create("DFrame")
    MascoStick.CharacterFrame:SetSize(width * 0.45, height * 0.27)
    MascoStick.CharacterFrame:SetDraggable(false)
    MascoStick.CharacterFrame:Center()
    MascoStick.CharacterFrame:MakePopup()
    MascoStick.CharacterFrame:SetTitle("")
    MascoStick.CharacterFrame.Paint = function(self, w, h)
        draw.RoundedBoxEx(6, 0, 0, w, h, frame_background)
        draw.RoundedBoxEx(6, 0, 0, w, 30, frame_header_background, true, true, false, false)
        draw.DrawText("Character List", "CharacterListTitle", w * 0.5, 8, color_white, TEXT_ALIGN_CENTER)
    end

    MascoStick.CharacterFrame.btnClose:Hide()
    MascoStick.CharacterFrame.FrameClose = MascoStick.CharacterFrame:Add("DButton")
    MascoStick.CharacterFrame.FrameClose:SetSize(50,30)
    MascoStick.CharacterFrame.FrameClose:SetText("X")
    MascoStick.CharacterFrame.FrameClose:SetFont("CharacterListButton")
    MascoStick.CharacterFrame.FrameClose:SetColor(color_white)

	function MascoStick.CharacterFrame.FrameClose.PerformLayout(this,w, h)
		this:SetPos(MascoStick.CharacterFrame:GetWide()-w)
	end

    function MascoStick.CharacterFrame.FrameClose:Paint(w,h)
	    if MascoStick.CharacterFrame.FrameClose:IsHovered() then
			draw.RoundedBoxEx(6, 0, 0, w, h, red_button_hovered, false, true, false, false)
        else
            draw.RoundedBoxEx(6, 0, 0, w, h, red_button, false, true, false, false)
        end
    end

	function MascoStick.CharacterFrame.FrameClose.DoClick()
		MascoStick.CharacterFrame:Close()
	end

	MascoStick.CharacterFrame:SetAlpha(0)

	timer.Simple(0.05, function()
		if not MascoStick.CharacterFrame or not IsValid(MascoStick.CharacterFrame) then return end
		local x,y = MascoStick.CharacterFrame:GetPos()
		MascoStick.CharacterFrame:SetPos(x+50,y+50)
		MascoStick.CharacterFrame:MoveTo(x, y, 0.3, 0, -1)
		MascoStick.CharacterFrame:AlphaTo(255, 0.3, 0.15)
	end)

    MascoStick.CharacterFrame.Panel = MascoStick.CharacterFrame:Add("DPanel")
    MascoStick.CharacterFrame.Panel:Dock(FILL)
    MascoStick.CharacterFrame.Panel:SetPaintBackground(false)
    MascoStick.CharacterFrame.Panel:DockPadding(20, 20, 20, 20)

    MascoStick.CharacterFrame.CharListView = MascoStick.CharacterFrame.Panel:Add("DListView")
    MascoStick.CharacterFrame.CharListView:Dock(FILL)
    MascoStick.CharacterFrame.CharListView:SetSize(MascoStick.CharacterFrame.CharListView:GetWide(), MascoStick.CharacterFrame.CharListView:GetTall())
    MascoStick.CharacterFrame.CharListView:SetDataHeight(35)
    MascoStick.CharacterFrame.CharListView:SetMultiSelect(false)
    MascoStick.CharacterFrame.CharListView:AddColumn("ID")
    MascoStick.CharacterFrame.CharListView:AddColumn("Name")
    MascoStick.CharacterFrame.CharListView:AddColumn("Description")
    MascoStick.CharacterFrame.CharListView:AddColumn("Faction")
    MascoStick.CharacterFrame.CharListView:AddColumn("Money")
    MascoStick.CharacterFrame.CharListView:AddColumn("Banned?")
    MascoStick.CharacterFrame.CharListView.Paint = function()
        draw.RoundedBox(0, 0, 0, MascoStick.CharacterFrame.CharListView:GetWide(), MascoStick.CharacterFrame.CharListView:GetTall(), dlist_background)
        for _, line in ipairs(MascoStick.CharacterFrame.CharListView:GetLines()) do
            for _, label in ipairs(line.Columns) do
                label:SetTextColor(color_white)
                label:SetFont("CharacterListGeneral")
                label:SetContentAlignment(5)
            end
        end
    end

    MascoStick.CharacterFrame.CharListView.Columns[1].Header.Paint = function()
        draw.RoundedBox(0, 0, 0, MascoStick.CharacterFrame.CharListView.Columns[1].Header:GetWide(), MascoStick.CharacterFrame.CharListView.Columns[1].Header:GetTall(), red_button)
    end

    MascoStick.CharacterFrame.CharListView.Columns[2].Header.Paint = function()
        draw.RoundedBox(0, 0, 0, MascoStick.CharacterFrame.CharListView.Columns[2].Header:GetWide(), MascoStick.CharacterFrame.CharListView.Columns[2].Header:GetTall(), red_button)
    end

    MascoStick.CharacterFrame.CharListView.Columns[3].Header.Paint = function()
        draw.RoundedBox(0, 0, 0, MascoStick.CharacterFrame.CharListView.Columns[3].Header:GetWide(), MascoStick.CharacterFrame.CharListView.Columns[3].Header:GetTall(), red_button)
    end

    MascoStick.CharacterFrame.CharListView.Columns[4].Header.Paint = function()
        draw.RoundedBox(0, 0, 0, MascoStick.CharacterFrame.CharListView.Columns[4].Header:GetWide(), MascoStick.CharacterFrame.CharListView.Columns[4].Header:GetTall(), red_button)
    end

    MascoStick.CharacterFrame.CharListView.Columns[5].Header.Paint = function()
        draw.RoundedBox(0, 0, 0, MascoStick.CharacterFrame.CharListView.Columns[5].Header:GetWide(), MascoStick.CharacterFrame.CharListView.Columns[5].Header:GetTall(), red_button)
    end

    MascoStick.CharacterFrame.CharListView.Columns[6].Header.Paint = function()
        draw.RoundedBox(0, 0, 0, MascoStick.CharacterFrame.CharListView.Columns[6].Header:GetWide(), MascoStick.CharacterFrame.CharListView.Columns[6].Header:GetTall(), red_button)
    end

    for i=1, MascoStick.CharacterList.Length do
        MascoStick.CharacterList.CharacterID = net.ReadUInt(32)
        MascoStick.CharacterList.Name = net.ReadString()
        MascoStick.CharacterList.Description = net.ReadString()
        MascoStick.CharacterList.Faction = net.ReadString()
        MascoStick.CharacterList.Money = net.ReadUInt(32)
        MascoStick.CharacterList.Banned = net.ReadString()

        local Line = MascoStick.CharacterFrame.CharListView:AddLine(MascoStick.CharacterList.CharacterID, MascoStick.CharacterList.Name, MascoStick.CharacterList.Description, MascoStick.CharacterList.Faction, ix.currency.Get(MascoStick.CharacterList.Money), MascoStick.CharacterList.Banned)

        Line.CharacterID = MascoStick.CharacterList.CharacterID
    end

    MascoStick.CharacterFrame.CharListView.DoDoubleClick = function(ListView, LineID, Line)
        if Line.CharacterID then
            MascoStick.CharacterList.DMenu = DermaMenu()

            MascoStick.CharacterList.DMenu.Option1 = MascoStick.CharacterList.DMenu:AddOption("Ban Character", function()
                LocalPlayer():ConCommand([[say "/CharBanOffline ]] .. Line.CharacterID .. [["]])
            end)

            MascoStick.CharacterList.DMenu.Option1:SetIcon("icon16/cancel.png")

            MascoStick.CharacterList.DMenu.Option2 = MascoStick.CharacterList.DMenu:AddOption("Unban Character", function()
                LocalPlayer():ConCommand([[say "/CharUnbanOffline ]] .. Line.CharacterID .. [["]])
            end)

            MascoStick.CharacterList.DMenu.Option2:SetIcon("icon16/accept.png")
            
            MascoStick.CharacterList.DMenu:Open()
        end
    end
end)