--[[ 
	Rework © 2016 TeslaCloud Studios
	Do not share, re-distribute or sell.
--]]

timer.Remove("HintSystem_OpeningMenu");
timer.Remove("HintSystem_Annoy1");
timer.Remove("HintSystem_Annoy2");

netstream.Hook("SharedTables", function(sharedTable)
	rw.sharedTable = sharedTable or {};
end);

function GM:InitPostEntity()
	rw.client = rw.client or LocalPlayer();
end;

function GM:HUDDrawScoreBoard()
	if (!rw.client:HasInitialized()) then
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0));
	end;
end;

-- Called when the scoreboard should be shown.
function GM:ScoreboardShow()
	if (rw.client:HasInitialized()) then
		if (rw.tabMenu) then
			rw.tabMenu:CloseMenu(true);
		end;

		rw.tabMenu = vgui.Create("rwTabMenu");
		rw.tabMenu:MakePopup();
		rw.tabMenu.heldTime = CurTime() + 0.3;
	end;
end;

-- Called when the scoreboard should be hidden.
function GM:ScoreboardHide()
	if (rw.client:HasInitialized()) then
		if (rw.tabMenu and CurTime() >= rw.tabMenu.heldTime) then
			rw.tabMenu:CloseMenu();
		end;
	end;
end;

function GM:AdjustTabDockMenus(menus)
	menus["Inventory"] = {
		icon = "fa-suitcase"
	};
	menus["Settings"] = {
		icon = "fa-cog",
		menu = "rwSettings"
	};
	menus["Characters"] = {
		icon = "fa-users"
	};
end;

function GM:AdjustSettingCallbacks(callbacks)
	callbacks["DCheckBox"] = function(panel, parent, setting)
		panel:SetSize(parent:GetTall() * 0.9, parent:GetWide() * 0.05);
		panel:SetPos(parent:GetWide() - panel:GetWide() * 1.1, parent:GetTall() * 0.5 - panel:GetTall() * 0.5);

		panel:SetConVar("RW_"..setting.id);
	end;

	callbacks["DComboBox"] = function(panel, parent, setting)
		panel:SetSize(parent:GetWide() * 0.98, parent:GetTall() * 0.6);
		panel:SetPos(parent.label.x, parent.label.y + parent.label:GetTall() * 1.25);
		parent:SetSize(parent:GetWide(), parent:GetTall() + parent.label:GetTall() * 0.1 + panel:GetTall());

		if (istable(setting.info)) then
			for k, v in pairs(setting.info) do
				panel:AddChoice(v, k);
			end;
		end;

		function panel:OnSelect(index, value, data)
			if (data) then
				value = data;
			end;

			rw.settings.SetValue(setting.id, value);
		end;

		panel:SetConVar("RW_"..setting.id);
	end;

	callbacks["DTextEntry"] = function(panel, parent, setting)
		panel:SetSize(parent:GetWide() * 0.98, parent:GetTall() * 0.6);
		panel:SetPos(parent.label.x, parent.label.y + parent.label:GetTall() * 1.25);
		parent:SetSize(parent:GetWide(), parent:GetTall() + parent.label:GetTall() * 0.1 + panel:GetTall());

		panel:SetConVar("RW_"..setting.id);
	end;

	callbacks["DColorMixer"] = function(panel, parent, setting)
		panel:SetSize(parent:GetWide() * 0.98, ScrH() * 0.23);
		panel:SetPos(parent.label.x, parent.label.y + parent.label:GetTall() * 1.25);
		parent:SetSize(parent:GetWide(), parent:GetTall() + parent.label:GetTall() * 0.1 + panel:GetTall());

		panel:SetConVarR("RW_"..setting.id.."_R");
		panel:SetConVarG("RW_"..setting.id.."_G");
		panel:SetConVarB("RW_"..setting.id.."_B");
		panel:SetConVarA("RW_"..setting.id.."_A");
	end;
end;

function GM:HUDPaint()
	if (!plugin.Call("RWHUDPaint")) then
		-- if nothing else overrides this, draw HUD that sucks
		draw.RoundedBox(2, 8, 8, ScrW() / 4, 16, Color(40, 40, 40));
		
		if (LocalPlayer():Health() > 0) then
			draw.RoundedBox(2, 9, 9, (ScrW() / 4 - 2) * (LocalPlayer():Health() / 100), 14, Color(200, 30, 30));
		end;

		if (LocalPlayer():Armor() > 0) then
			draw.RoundedBox(0, 8, 26, ScrW() / 4, 16, Color(40, 40, 40));
			draw.RoundedBox(0, 9, 27, (ScrW() / 4 - 2) * (LocalPlayer():Armor() / 100), 14, Color(30, 100, 200));
		end;
	end;
end;

do
	local hiddenElements = {
		CHudHealth = true,
		CHudBattery = true,
		CHudAmmo = true,
		CHudSecondaryAmmo = true,
		CHudCrosshair = true,
		CHudHistoryResource = true
	}

	function GM:HUDShouldDraw(element)
		if (hiddenElements[element]) then
			return false;
		end

		return true;
	end
end;