local config = LibStub("AceConfig-3.0")
local dialog = LibStub("AceConfigDialog-3.0")

function SAC:CreateOptions()
	
	SAC.Options = {
		name = "SpellAnnouncer Classic",
		handler = SAC,
		type = 'group',
		args = {

		},
	}

	SAC.Options_Auras = {
		name = "Auras",
		handler = SAC,
		type = 'group',
		args = {
			description = {
				order = 0,
				type = 'description',
				name = "Options for spells that adds an aura to your character.",
			},
			spacer = {
				order = 1,
				type = 'header',
				name = ""
			},
			enable = {
				order = 2,
				type = 'toggle',
				name = 'Announce auras',
				desc = 'Enable or disable all announcements connected to an Aura',
				set = 'Set',
				get = 'Get',
			},
			auras = {
				order = 10,
				type = 'select',
				name = 'Auras',
				values = SAC.namedAuraList,
				style = 'radio',
				set = 'SetAuraOptions',
				get = 'GetAuraOptions',
			},
			auraSettings = {
				name = "",
				type = 'group',
				guiInline = true,
				args = {
					announceStart = {
						order = 11,
						type = 'toggle',
						name = "Announce start",
						set = 'SetAuraToggle',
						get = 'GetAuraToggle',
					},
					announceEnd = {
						order = 12,
						type = 'toggle',
						name = "Announce end",
						set = 'SetAuraToggle',
						get = 'GetAuraToggle',
					},
				},
			},
		},
	}
	
	SAC.Options_Resists = {
		name = "Resists",
		handler = SAC,
		type = 'group',
		args = {
			description = {
				order = 0,
				type = 'description',
				name = "Options for spells that fail when casted on a target. This includes all forms of resists.",
			},
			spacer = {
				order = 1,
				type = 'header',
				name = "",
			},
			enable = {
				order = 2,
				type = 'toggle',
				name = 'Announce failed spells',
				desc = 'Enable or disable all announcements connected to an Aura',
				set = 'Set',
				get = 'Get',
			},
			spells = {
				order = 10,
				type = 'select',
				name = 'Spells',
				values = SAC.namedResistList,
				style = 'radio',
				set = 'SetResistOptions',
				get = 'Get',
			},
		},
	}
	
	self:SetDefaultOptions()
	
	config:RegisterOptionsTable("SAC_Options", SAC.Options)
	self.optionsFrame = dialog:AddToBlizOptions("SAC_Options", SAC.Options.name)
	config:RegisterOptionsTable("SAC_Options_Auras", SAC.Options_Auras)
	self.optionsAurasFrame = dialog:AddToBlizOptions("SAC_Options_Auras", SAC.Options_Auras.name, SAC.Options.name)
	config:RegisterOptionsTable("SAC_Options_Resists", SAC.Options_Resists)
	self.optionsResistsFrame = dialog:AddToBlizOptions("SAC_Options_Resists", SAC.Options_Resists.name, SAC.Options.name)

end


function SAC:SetDefaultOptions()
	
	if self.db.char.options == nil then
		self.db.char.options = {}
		for k,v in pairs(self.namedAuraList) do
			table.insert(self.db.char.options, v)
			self.db.char.options[v] = {}
		end
	end
	
end


function SAC:SetAuraOptions(info, val)
	self.db.char.options[info[#info]] = val
	self.lastSelectedAura = info["option"]["values"][val]
	self.Options_Auras.args.auraSettings.name = self.lastSelectedAura
end


function SAC:GetAuraOptions(info)
	if self.db.char.options[info[#info]] == nil then
		self.db.char.options[info[#info]] = true
	end
	
	if self.Options_Auras.args.auraSettings.name == "" then
		self.Options_Auras.args.auraSettings.name = self.namedAuraList[1]
	end
	
	return self.db.char.options[info[#info]]
end


function SAC:SetResistOptions(info, val)
	self.db.char.options[info[#info]] = val
	self.lastSelectedResist = info["option"]["values"][val]
end


function SAC:SetAuraToggle(info, val)
	self.db.char.options[self.lastSelectedAura][info[#info]] = val
end


function SAC:SetResistToggle(info, val)
	self.db.char.options[self.lastSelectedResist][info[#info]] = val
end


function SAC:Set(info, val)
	self.db.char.options[info[#info]] = val
end


function SAC:GetAuraToggle(info)
	if self.lastSelectedAura == nil then
		self.lastSelectedAura = self.namedAuraList[1]
	end
	
	return self.db.char.options[self.lastSelectedAura][info[#info]]
end


function SAC:GetResistToggle(info)
	if self.lastSelectedResist == nil then
		self.lastSelectedResist = self.namedAuraList[1]
	end
	
	return self.db.char.options[self.lastSelectedResist][info[#info]]
end


function SAC:Get(info)
	if self.db.char.options[info[#info]] == nil then
		self.db.char.options[info[#info]] = true
	end
		
	return self.db.char.options[info[#info]]
end


function InterfaceOptionsFrame_OnEvent (self, event, ...)
	print(event)
end
