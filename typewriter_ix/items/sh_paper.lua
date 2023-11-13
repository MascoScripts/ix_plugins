ITEM.name = "Document"
ITEM.description = "A piece of thick paper, quite fancy. Looks official."
ITEM.model = "models/props_lab/clipboard.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Documents"
ITEM.noBusiness = true

ITEM.functions.View = {
	name = "View",
	OnClick = function(item)
		local document = vgui.Create("ixDocument")
		document:SetDocument(item)
	end,
	OnRun = function(item) return false end,
	OnCanRun = function(item)
		if IsValid(item.entity) or item:GetData("documentBody") == nil then
            return false
        end
	end,
}

function ITEM:GetName()
	return self:GetData("documentName", self.name)
end

function ITEM:GetDescription()
	return Format(
		"%s %s %s",
		self.description,
		self:GetData("documentBody") and "This document has something written on it." or "This document is blank.",
		LocalPlayer():IsAdmin() and ("This document was created by "..self:GetData("creator", "N/A")) or ""
	)
end