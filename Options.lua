local config = LibStub("AceConfig-3.0")
local dialog = LibStub("AceConfigDialog-3.0")

local CHATCHANNELS = { ["RAID"] = "RAID", ["PARTY"] = "PARTY", ["YELL"] = "YELL", ["SAY"] = "SAY",}

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
				set = 'Set',
				get = 'Get',
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

	
	self:InitializeDefaultSettings()
	
	config:RegisterOptionsTable("SAC_Options", SAC.Options)
	self.optionsFrame = dialog:AddToBlizOptions("SAC_Options", SAC.Options.name)
	
	
end


function SAC:InitializeDefaultSettings()


	if self.db.char.options == nil then
		self.db.char.options = {}
	end
	
	if self.db.char.options.recursiveEnable == nil then
		self.db.char.options.recursiveEnable = true
	end

	if self.db.char.options.channel == nil then
		self.db.char.options.channel = "YELL"
	end
	
	if self.db.char.options.auraAllEnable == nil then
		self.db.char.options.auraAllEnable = true
	end
	
	if self.db.char.options.resistsAllEnable == nil then
		self.db.char.options.resistsAllEnable = true
	end

	for k,v in pairs(self.namedAuraList) do
		
		local found = false
		for x,_ in pairs(self.db.char.options) do
			if v == x then
				found = true
			end
		end
		if not found then
			self.db.char.options[v] = {}
			self.db.char.options[v].announceStart = true
			self.db.char.options[v].announceEnd = false
		end
		
	end
	
	for k,v in pairs(self.namedResistList) do
		
		local found = false
		for x,_ in pairs(self.db.char.options) do
			if v == x then
				found = true
			end
		end
		if not found then
			self.db.char.options[v] = {}
			self.db.char.options[v].resistAnnounceEnabled = true
		end
		
	end
	
	if self.db.char.options.auras == nil then
		self.db.char.options.auras = 1
	end
	
	if self.db.char.options.spells == nil then
		self.db.char.options.spells = 1
	end
	
end


function SAC:SetAuraList(info, val)

	self.db.char.options[info[#info]] = val
	self.lastSelectedAura = info["option"]["values"][val]
	self.Options.args.auraSettings.name = self.lastSelectedAura
	
end


function SAC:GetAuraList(info)

	-- Set the correct name for the Aura settings box.
	if self.Options.args.auraSettings.name == "" then
		self.Options.args.auraSettings.name = self.namedAuraList[self.db.char.options[info[#info]]] --or self.namedAuraList[1]
	end
	
	return self.db.char.options[info[#info]]
	
end

function SAC:SetResistList(info, val)

	self.db.char.options[info[#info]] = val
	self.lastSelectedResist = info["option"]["values"][val]
	self.Options.args.resistSettings.name = self.lastSelectedResist
	
end


function SAC:GetResistList(info)
	
	-- Set the correct name for the Resist settings box.
	if self.Options.args.resistSettings.name == "" then
		self.Options.args.resistSettings.name = self.namedResistList[self.db.char.options[info[#info]]] --or self.namedResistList[1]
	end
	
	return self.db.char.options[info[#info]]
end


function SAC:SetAuraToggle(info, val)

	self.db.char.options[self.lastSelectedAura][info[#info]] = val
	
end


function SAC:GetAuraToggle(info)

	-- Set the correct last selected aura.
	if self.lastSelectedAura == nil then
		self.lastSelectedAura = self.namedAuraList[self.db.char.options.auras]
	end
		
	return self.db.char.options[self.lastSelectedAura][info[#info]]
	
end


function SAC:SetResistToggle(info, val)

	self.db.char.options[self.lastSelectedResist][info[#info]] = val
	
end


function SAC:GetResistToggle(info)

	-- Set the correct last selected resist spell.
	if self.lastSelectedResist == nil then
		self.lastSelectedResist = self.namedResistList[self.db.char.options.spells]
	end
	
	return self.db.char.options[self.lastSelectedResist][info[#info]]
	
end


function SAC:Set(info, val)

	self.db.char.options[info[#info]] = val
	
end


function SAC:Get(info)
		
	return self.db.char.options[info[#info]]
	
end
