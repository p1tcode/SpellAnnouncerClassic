local config = LibStub("AceConfig-3.0")
local dialog = LibStub("AceConfigDialog-3.0")

local CHATCHANNELS = { ["RAID"] = "RAID", ["PARTY"] = "PARTY", ["YELL"] = "YELL", ["SAY"] = "SAY", ["SYSTEM MESSAGE"] = "SYSTEM MESSAGE", }
local CHATPARTIES = { ["RAID"] = "RAID", ["PARTY"] = "PARTY", ["SOLO"] = "SOLO", }

function SAC:CreateOptions()
	
	SAC.Options = {
		name = "SpellAnnouncer Classic",
		handler = SAC,
		type = 'group',
		args = {
			version = {
				order = 0,
				type = 'description',
				fontSize = "medium",
				name = "Version" .. " " .. SAC.addonVersion .. ", Created by Pit @ Firemaw - EU",
				width = 'double',
			},
			welcomeEnable = {
				order = 1,
				type = 'toggle',
				name = 'Welcome Message',
				desc = 'Enable or disable the welcome message produced by this Addon when launching or reloading WoW.',
				set = 'Set',
				get = 'Get',
			},
			header = {
				order = 2,
				type = 'header',
				name = "General",
			},
			chatParty = {
				order = 3,
				name = "Select a party option:",
				desc = "Select a party option in the dropdown menu, and then select how you would like to announce when in specified raid/party/solo option.",
				type = 'select',
				values = CHATPARTIES,
				set = 'Set',
				get = 'Get',
			},
			chatChannels = {
				order = 4,
				name = "Then select how to announce:",
				type = 'group',
				guiInline = true,
				args = {
					chatRaid = {
						order = 0,
						type = 'toggle',
						name = "/raid",
						disabled = 'ChatRaidDisableCheck',
						hidden = 'ChatRaidDisableCheck',
						set = 'SetChatToggle',
						get = 'GetChatToggle',
					},
					chatParty = {
						order = 1,
						type = 'toggle',
						name = "/party",
						disabled = 'ChatPartyDisableCheck',
						hidden = 'ChatPartyDisableCheck',
						set = 'SetChatToggle',
						get = 'GetChatToggle',
					},
					chatYell = {
						order = 2,
						type = 'toggle',
						name = "/yell",
						set = 'SetChatToggle',
						get = 'GetChatToggle',
					},
					chatSay = {
						order = 3,
						type = 'toggle',
						name = "/say",
						set = 'SetChatToggle',
						get = 'GetChatToggle',
					},
					chatSystem = {
						order = 4,
						type = 'toggle',
						name = "System Message",
						set = 'SetChatToggle',
						get = 'GetChatToggle',
					},
				},
			},
			
			spacer0 = {
				order = 9,
				type = 'description',
				name = " ",
			},
			
			-- Aura section in Options menu
			aurasHeader = {
				order = 10,
				type = 'header',
				name = "Auras",
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
				values = SAC.aurasList,
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
					whisperTarget = {
						order = 2,
						type = 'toggle',
						name = "Whisper Target",
						desc = "When the selected buff is used on a player, inform the player with a whisper. You will not whisper yourself, and only works for players in your party/raid!",
						disabled = 'WhisperTargetDisableCheck',
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
			
			-- Spells section in the Options menu
			spellHeader = {
				order = 30,
				type = 'header',
				name = "Spells",
			},
			spellDescription = {
				order = 31,
				type = 'description',
				name = "Options for spells that fail when casted on a target. This includes all forms of resists.",
			},
			spellAllEnable = {
				order = 32,
				type = 'toggle',
				name = 'Announce spells',
				desc = 'Enable or disable all announcements connected to a Spell',
				set = 'Set',
				get = 'Get',
				width = 'full',
			},
			successfulInterrupts = {
				order = 33,
				type = 'toggle',
				name = 'Successful interrupts',
				desc = 'Enable or disable announcement when an enemy spellcast is interrupted successfully.',
				set = 'Set',
				get = 'Get',
				width = 'full',
			},
			spells = {
				order = 40,
				type = 'select',
				name = 'Spells',
				values = SAC.spellsList,
				style = 'radio',
				set = 'SetSpellsList',
				get = 'GetSpellsList',
			},
			spellSettings = {
				order = 41,
				name = "",
				type = 'group',
				guiInline = true,
				args = {
					spellAnnounceEnabled = {
						order = 0,
						type = 'toggle',
						name = "Announce Cast",
						set = 'SetSpellToggle',
						get = 'GetSpellToggle',
					},
					resistAnnounceEnabled = {
						order = 1,
						type = 'toggle',
						name = "Announce Resist",
						set = 'SetSpellToggle',
						get = 'GetSpellToggle',
					},
				},
			},
			spacer2 = {
				order = 50,
				type = 'description',
				name = " ",
			},
			
			-- Spells section in the Options menu
			pvpHeader = {
				order = 51,
				type = 'header',
				name = "PVP",
			},
			pvpDescription = {
				order = 52,
				type = 'description',
				name = "PVP related announcements.",
			},
			pvp = {
				order = 53,
				type = 'select',
				name = 'PVP Target Spells',
				values = SAC.pvpAllList,
				style = 'radio',
				set = 'SetPvpList',
				get = 'GetPvpList',
			},
			pvpSettings = {
				order = 54,
				name = "",
				type = 'group',
				guiInline = true,
				args = {
					Enable = {
						order = 0,
						type = 'toggle',
						name = "Enable",
						set = 'SetPvpToggle',
						get = 'GetPvpToggle',
					},
				},
			},
		},
	}

	self:InitializeDefaultSettings()
	
	config:RegisterOptionsTable("SAC_Options", SAC.Options)
	self.optionsFrame = dialog:AddToBlizOptions("SAC_Options", SAC.Options.name)
	
	self:RegisterChatCommand("sac", "OpenOptions")
	self:RegisterChatCommand("spellannouncer", "OpenOptions")
	
end

-- Show the options for SpellAnnouncer Classic by using /sac
function SAC:OpenOptions(input)
	if not input or input:trim() == "" then
		InterfaceOptionsFrame_Show()
		InterfaceOptionsFrame_OpenToCategory("SpellAnnouncer Classic")
	end
end

-- Sets all default settings if not set before.
function SAC:InitializeDefaultSettings()


	if self.db.char.options == nil then
		self.db.char.options = {}
	end
	
	if self.db.char.options.chatParty == nil then
		self.db.char.options.chatParty = "SOLO"
	end
	
	if self.db.char.options.welcomeEnable == nil then
		self.db.char.options.welcomeEnable = true
	end

	for p in pairs(CHATPARTIES) do
		if self.db.char.options[p] == nil then
			self.db.char.options[p] = {}
			
			self.db.char.options[p].chatRaid = false
			self.db.char.options[p].chatParty = false
			self.db.char.options[p].chatYell = true
			self.db.char.options[p].chatSay = false
			self.db.char.options[p].chatSystem = false
		end
	end
	
	if self.db.char.options.auraAllEnable == nil then
		self.db.char.options.auraAllEnable = true
	end
	
	if self.db.char.options.resistsAllEnable ~= nil then
		self.db.char.options.spellAllEnable = self.db.char.options.resistsAllEnable
	end
	
	if self.db.char.options.spellAllEnable == nil then
		self.db.char.options.spellAllEnable = true
	end

	for k,v in pairs(self.aurasList) do
		
		local found = false
		for x,_ in pairs(self.db.char.options) do
			if v == x then
				found = true
				if self.db.char.options[v].announceStart == nil then
					self.db.char.options[v].announceStart = true
				end
				if self.db.char.options[v].announceEnd == nil then
					self.db.char.options[v].announceEnd = true
				end
				if self.db.char.options[v].isSelfBuff == nil then
					self.db.char.options[v].isSelfBuff = SpellIsSelfBuff(select(7, GetSpellInfo(self.classAuraIDs[k])))
				end
				if self.db.char.options[v].whisperTarget == nil then
					self.db.char.options[v].whisperTarget = false
				end
			end
		end
		if not found then
			self.db.char.options[v] = {}
			self.db.char.options[v].announceStart = true
			self.db.char.options[v].announceEnd = false
			self.db.char.options[v].isSelfBuff = SpellIsSelfBuff(select(7, GetSpellInfo(self.classAuraIDs[k])))
			self.db.char.options[v].whisperTarget = false
		end
		
	end
	
	for k,v in pairs(self.spellsList) do
		
		local found = false
		for x,_ in pairs(self.db.char.options) do
			if v == x then
				found = true
				
				if self.db.char.options[v].spellAnnounceEnabled == nil then
					self.db.char.options[v].spellAnnounceEnabled = false
				end
				if self.db.char.options[v].resistAnnounceEnabled == nil then
					self.db.char.options[v].resistAnnounceEnabled = true
				end
			end
		end
		if not found then
			self.db.char.options[v] = {}
			self.db.char.options[v].spellAnnounceEnabled = false
			self.db.char.options[v].resistAnnounceEnabled = true
		end
		
	end
	
	for k,v in pairs(self.pvpAllList) do
		
		local found = false
		for x,_ in pairs(self.db.char.options) do
			if k == x then
				found = true
				
				if self.db.char.options[v].Enable == nil then
					self.db.char.options[v].Enable = true
				end
			end
		end
		if not found then
			self.db.char.options[v] = {}
			self.db.char.options[v].Enable = true
		end
		
	end
	
	if self.db.char.options.successfulInterrupts == nil then
		self.db.char.options.successfulInterrupts = true
	end
		
	if self.db.char.options.auras == nil then
		self.db.char.options.auras = 1
	end
	
	if self.db.char.options.spells == nil then
		self.db.char.options.spells = 1
	end
	
end


-- Disables menuoptions based on what party option is selected.
function SAC:ChatRaidDisableCheck() 
	if (self.db.char.options.chatParty == "SOLO") or (self.db.char.options.chatParty == "PARTY") then 
		return true
	else
		return false
	end
end


function SAC:WhisperTargetDisableCheck()
	return self.db.char.options[self.lastSelectedAura].isSelfBuff
end


-- Disables menuoptions based on what party option is selected.
function SAC:ChatPartyDisableCheck() 
	if (self.db.char.options.chatParty == "SOLO") then 
		return true
	else
		return false
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
		self.Options.args.auraSettings.name = self.aurasList[self.db.char.options[info[#info]]]
	end
	
	return self.db.char.options[info[#info]]
	
end


function SAC:SetSpellsList(info, val)

	self.db.char.options[info[#info]] = val
	self.lastSelectedSpell = info["option"]["values"][val]
	self.Options.args.spellSettings.name = self.lastSelectedSpell
	
end


function SAC:GetSpellsList(info)
	
	-- Set the correct name for the Resist settings box.
	if self.Options.args.spellSettings.name == "" then
		self.Options.args.spellSettings.name = self.spellsList[self.db.char.options[info[#info]]]
	end
	
	return self.db.char.options[info[#info]]
end


function SAC:SetPvpList(info, val)

	self.db.char.options[info[#info]] = val
	self.lastSelectedPvp = info["option"]["values"][val]
	self.Options.args.pvpSettings.name = self.lastSelectedPvp
	
end


function SAC:GetPvpList(info)
	
	-- Set the correct name for the Resist settings box.
	if self.Options.args.pvpSettings.name == "" then
		self.Options.args.pvpSettings.name = self.pvpAllList[self.db.char.options[info[#info]]]
	end
	
	return self.db.char.options[info[#info]]
end


function SAC:SetAuraToggle(info, val)

	self.db.char.options[self.lastSelectedAura][info[#info]] = val
	
end


function SAC:GetAuraToggle(info)

	-- Set the correct last selected aura.
	if self.lastSelectedAura == nil then
		self.lastSelectedAura = self.aurasList[self.db.char.options.auras]
	end
		
	return self.db.char.options[self.lastSelectedAura][info[#info]]
	
end


function SAC:SetSpellToggle(info, val)

	self.db.char.options[self.lastSelectedSpell][info[#info]] = val
	
end


function SAC:GetSpellToggle(info)

	-- Set the correct last selected spell.
	if self.lastSelectedSpell == nil then
		self.lastSelectedSpell = self.spellsList[self.db.char.options.spells]
	end
	
	return self.db.char.options[self.lastSelectedSpell][info[#info]]
	
end


function SAC:SetPvpToggle(info, val)

	self.db.char.options[self.lastSelectedPvp][info[#info]] = val
	
end


function SAC:GetPvpToggle(info)

	-- Set the correct last selected spell.
	if self.lastSelectedPvp == nil then
		self.lastSelectedPvp = self.pvpAllList[self.db.char.options.pvp]
	end
	
	return self.db.char.options[self.lastSelectedPvp][info[#info]]
	
end


function SAC:SetChatToggle(info, val)

	self.db.char.options[self.db.char.options.chatParty][info[#info]] = val
	
end


function SAC:GetChatToggle(info)
		
	return self.db.char.options[self.db.char.options.chatParty][info[#info]]
	
end


function SAC:Set(info, val)

	self.db.char.options[info[#info]] = val
	
end


function SAC:Get(info)
		
	return self.db.char.options[info[#info]]
	
end
