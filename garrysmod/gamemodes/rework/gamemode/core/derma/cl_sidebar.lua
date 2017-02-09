--[[
	Rework © 2016-2017 TeslaCloud Studios
	Do not share or re-distribute before
	the framework is publicly released.
--]]

local PANEL = {}
PANEL.lastPos = 0
PANEL.margin = 0

function PANEL:Init()
	self.VBar.Paint = function() return true; end
	self.VBar.btnUp.Paint = function() return true; end
	self.VBar.btnDown.Paint = function() return true; end
	self.VBar.btnGrip.Paint = function() return true; end

	self:PerformLayout()

	function self:OnScrollbarAppear() return true; end
end

function PANEL:Paint(width, height)
	theme.Hook("PaintSidebar", self, width, height)
end

function PANEL:AddPanel(panel, bCenter)
	local x, y = panel:GetPos()

	if (bCenter) then
		x = self:GetWide() / 2 - panel:GetWide() / 2
	end

	panel:SetPos(x, self.lastPos)
	self:AddItem(panel)
	self.lastPos = self.lastPos + self.margin + panel:GetTall()
end

function PANEL:AddSpace(px)
	self.lastPos = self.lastPos + px
end

function PANEL:Clear()
	self.BaseClass.Clear(self)
	self.lastPos = 0
end

function PANEL:SetMargin(margin)
	self.margin = tonumber(margin) or 0
end

-- 'borrowed' from lua/vgui/dscrollpanel.lua
function PANEL:PerformLayout()
	local oldHeight = self.pnlCanvas:GetTall()
	local oldWidth = self:GetWide()
	local YPos = 0

	self:Rebuild()

	self.VBar:SetUp(self:GetTall(), self.pnlCanvas:GetTall())
	YPos = self.VBar:GetOffset()

	self.pnlCanvas:SetPos(0, YPos)
	self.pnlCanvas:SetWide(oldWidth)

	self:Rebuild()

	if (oldHeight != self.pnlCanvas:GetTall()) then
		self.VBar:SetScroll(self.VBar:GetScroll())
	end
end

vgui.Register("rwSidebar", PANEL, "DScrollPanel");