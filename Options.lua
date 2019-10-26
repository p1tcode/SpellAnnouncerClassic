local config = LibStub("AceConfig-3.0")
local dialog = LibStub("AceConfigDialog-3.0")

local CHATCHANNELS = { ["RAID"] = "RAID", ["PARTY"] = "PARTY", ["YELL"] = "YELL", ["SAY"] = "SAY", ["NONE"] = "NONE"}

function SAC:CreateOptions()
	
	SAC.Options = {
		name = "SpellAnnouncer Classic",
		handler = SAC,
		type = 'group',
		args = {
			header = {
				order = 0,
				type = 'header',
				name = "General"
			},
			channel = {
				order = 1,
				name = "Channel",
				type = 'select',
				values = CHATCHANNELS,
				set = 'SetChatChannel',
				get = 'GetChatChannel',
			},
			recursiveEnable = {
				order = 2,
				name = "Recursive Channel",
				desc = "Recursively announce to the next lower channel if your not in your selected Chat channel. Raid -> Party -> Yell",
				type = 'toggle',
				set = 'Set',
				get = 'Get',
			},
			
			-- Aura section in Options menu
			aurasHeader = {
				order = 10,
				type = 'header',
				name = "Auras"
			},
			auraDescription = {
				order = 11,
				type = 'description',
				name = "Options for spells that adds an aura to your character.",
			},
			auraAllEnable = {
				order = 12,
				type = 'toggle',
				name = 'Announce auras',
				desc = 'Enable or disable all announcements connected to an Aura',
				set = 'Set',
				get = 'Get',
			},
			auras = {
				order = 13,
				type = 'select',
				name = 'Auras',
				values = SAC.namedAuraList,
				style = 'radio',
				set = 'SetAuraList',
				get = 'GetAuraList',
			},
			auraSettings = {
				order = 14,
				name = "",
				type = 'group',
				guiInline = true,
				args = {
					announceStart = {
						order = 0,
						type = 'toggle',
						name = "Announce start",
						set = 'SetAuraToggle',
						get = 'GetAuraToggle',
					},
					announceEnd = {
						order = 1,
						type = 'toggle',
						name = "Announce end",
						set = 'SetAuraToggle',
						get = 'GetAuraToggle',
					},
				},
			},
			
			spacer1 = {
				order = 29,
				type = 'description',
				name = " ",
			},
			
			-- Resists section in the Options menu
			resistsHeader = {
				order = 30,
				type = 'header',
				name = "Resits",
			},
			resistsDescription = {
				order = 31,
				type = 'description',
				name = "Options for spells that fail when casted on a target. This includes all forms of resists.",
			},
			resistsAllEnable = {
				order = 32,
				type = 'toggle',
				name = 'Announce failed spells',
				desc = 'Enable or disable all announcements connected to an Aura',
				set = 'Set',
				get = 'Get',
			},
			spells = {
				order = 40,
				type = 'select',
				name = 'Spells',
				values = SAC.namedResistList,
				style = 'radio',
				set = 'SetResistList',
				get = 'GetResistList',
			},
			resistSettings = {
				order = 41,
				name = "",
				type = 'group',
				guiInline = true,
				args = {
					resistAnnounceEnabled = {
						order = 0,
						type = 'toggle',
						name = "Announce Enabled",
						set = 'SetResistToggle',
						get = 'GetResistToggle',
					},
				},
			},
		},
	}

	
	self:InitializeOptions()
	
	config:RegisterOptionsTable("SAC_Options", SAC.Options)
	self.optionsFrame = dialog:AddToBlizOptions("SAC_Options", SAC.Options.name)
	
	
end


function SAC:InitializeOptions()


	if self.db.char.options == nil then
		self.db.char.options = {}
	end

	for k,v in pairs(self.namedAuraList) do
		self.db.char.options[v] = {}
	end
	for k,v in pairs(self.namedResistList) do
		self.db.char.options[v] = {}
	end
	
end


function SAC:SetAuraList(info, val)

	self.db.char.options[info[#info]] = val
	self.lastSelectedAura = info["option"]["values"][val]
	self.Options.args.auraSettings.name = self.lastSelectedAura
	
end


function SAC:GetAuraList(info)

	-- Default Settings
	-- Select the first spell in the Aura list.
	if self.db.char.options[info[#info]] == nil then
		self.db.char.options[info[#info]] = 1
	end
	
	--print(self.db.char.options[info[#info]], info, info[#info])
	
	-- Do the same for the Aura settings.
	if self.Options.args.auraSettings.name == "" then
		self.Options.args.auraSettings.name = self.namedAuraList[self.db.char.options[info[#info]]] or self.namedAuraList[1]
	end
	
	return self.db.char.options[info[#info]]
	
end

function SAC:SetResistList(info, val)

	self.db.char.options[info[#info]] = val
	self.lastSelectedResist = info["option"]["values"][val]
	self.Options.args.resistSettings.name = self.lastSelectedResist
	
end


function SAC:GetResistList(info)
	
	-- Default Settings
	-- Select the first spell in the Resist list.
	if self.db.char.options[info[#info]] == nil then
		self.db.char.options[info[#info]] = 1
	end
	
	-- Do the same for the Resist settings.
	if self.Options.args.resistSettings.name == "" then
		self.Options.args.resistSettings.name = self.namedResistList[self.db.char.options[info[#info]]] or self.namedResistList[1]
	end
	
	return self.db.char.options[info[#info]]
end


function SAC:SetAuraToggle(info, val)

	self.db.char.options[self.lastSelectedAura][info[#info]] = val
	
end


function SAC:GetAuraToggle(info)

	-- Select first Aura in the Aura list if no aura has been selected before.
	if self.lastSelectedAura == nil then
		self.lastSelectedAura = self.namedAuraList[1]
	end
	
	-- Default settings
	if self.db.char.options[self.lastSelectedAura][info[#info]] == nil then
		if info[#info] == "announceStart" then
			self.db.char.options[self.lastSelectedAura][info[#info]] = true
		elseif info[#info] == "announceEnd" then
			self.db.char.options[self.lastSelectedAura][info[#info]] = false
		end
	end
	
	return self.db.char.options[self.lastSelectedAura][info[#info]]
	
end


function SAC:SetResistToggle(info, val)

	--print(self.lastSelectedResist, info[#info], val)
	self.db.char.options[self.lastSelectedResist][info[#info]] = val
	
end


function SAC:GetResistToggle(info)

	-- Select first Spell in the Resist list if no spell has been selected before.
	if self.lastSelectedResist == nil then
		self.lastSelectedResist = self.namedResistList[1]
	end
	
	-- Default settings
	if self.db.char.options[self.lastSelectedResist][info[#info]] == nil then
		self.db.char.options[self.lastSelectedResist][info[#info]] = true
	end

	return self.db.char.options[self.lastSelectedResist][info[#info]]
	
end


function SAC:SetChatChannel(info, val)

	self.db.char.options[info[#info]] = val
	
end


function SAC:GetChatChannel(info)


	-- Default settings
	if self.db.char.options[info[#info]] == nil then
		self.db.char.options[info[#info]] = "YELL"
	end
		
	return self.db.char.options[info[#info]]
	
end



function SAC:Set(info, val)

	self.db.char.options[info[#info]] = val
	
end


function SAC:Get(info)

	-- Default settings
	if self.db.char.options[info[#info]] == nil then
		self.db.char.options[info[#info]] = true
	end
		
	return self.db.char.options[info[#info]]
	
end
