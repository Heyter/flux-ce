--[[ 
	Rework © 2016 TeslaCloud Studios
	Do not share, re-distribute or sell.
--]]

Class "CCommand";

CCommand.uniqueID = "undefined";
CCommand.name = "Unknown";
CCommand.description = "An undescribed command.";
CCommand.syntax = "[none]";
CCommand.immunity = false;
CCommand.playerArg = nil;
CCommand.arguments = 0;
CCommand.noConsole = false;

function CCommand:CCommand(id)
	self.uniqueID = id;
end;

function CCommand:OnRun() end;

function CCommand:__tostring()
	return "Command ["..self.uniqueID.."]["..self.name.."]";
end;

function CCommand:Register()
	rw.command:Create(self.uniqueID, self);
end;

Command = CCommand;