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
			get = 'Get',
		},
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
}
SAC.Options_Ressists = {
	name = "Ressists",
	handler = SAC,
	type = 'group',
	args = {
		description = {
			order = 0,
			type = 'description',
			name = "Options for spells that fail when casted on a target. This includes all forms of ressists.",
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
			values = SAC.namedRessistList,
			style = 'radio',
			set = 'SetRessistOptions',
			get = 'Get',
		},
	},
}


function SAC:SetAuraOptions(info, val)
	self.db.char.options[info[#info]] = val
	self.lastSelectedAura = info["option"]["values"][val]
end

function SAC:SetRessistOptions(info, val)
	self.db.char.options[info[#info]] = val
	self.lastSelectedRessist = info["option"]["values"][val]
end

function SAC:SetAuraToggle(info, val)
	self.db.char.options[self.lastSelectedAura][info[#info]] = val
end

function SAC:SetRessistToggle(info, val)
	self.db.char.options[self.lastSelectedRessist][info[#info]] = val
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

function SAC:GetRessistToggle(info)
	if self.lastSelectedRessist == nil then
		self.lastSelectedRessist = self.namedAuraList[1]
	end
	
	return self.db.char.options[self.lastSelectedRessist][info[#info]]
end

function SAC:Get(info)
	if self.db.char.options[info[#info]] == nil then
		self.db.char.options[info[#info]] = true
		print("Default Value set to true")
	end
		
	return self.db.char.options[info[#info]]
end

