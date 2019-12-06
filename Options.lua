local config = LibStub("AceConfig-3.0")
local dialog = LibStub("AceConfigDialog-3.0")

local CHATCHANNELS = { ["RAID"] = "Raid", ["PARTY"] = "Party", ["YELL"] = "Yell", ["SAY"] = "Say", ["SYSTEM MESSAGE"] = "System Message" }
local CHATPARTIES = { ["RAID"] = "Raid", ["PARTY"] = "Party", ["SOLO"] = "Solo" }
local PVPENEMY = { ["TARGET"] = "Target", ["ENEMIES"] = "All nearby enemies" }
local PVPFRIENDLY = { ["SELF"] = "Yourself", ["PARTY"] = "Party", ["ALLIES"] = "All nearby allies"}

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
			pvpAllEnable = {
				order = 53,
				type = 'toggle',
				name = 'Announce Pvp Events',
				desc = 'Enable or disable all announcements connected to a Pvp Event',
				set = 'Set',
				get = 'Get',
				width = 'full',
			},
			pvpFriendly = {
				order = 54,
				type = 'select',
				name = 'Scope of Friendlies',
				desc = 'Select who you should announce which friendly targets are affected by pvp spells.',
				values = PVPFRIENDLY,
				set = 'Set',
				get = 'Get',
			},
			pvpEnemy = {
				order = 55,
				type = 'select',
				name = 'Scope of Enemies',
				desc = 'Select who you should announce pvp spells for.',
				values = PVPENEMY,
				set = 'Set',
				get = 'Get',
			},
			pvp = {
				order = 56,
				type = 'select',
				name = 'PVP Target Spells',
				values = SAC.pvpAllList,
				style = 'radio',
				set = 'SetPvpList',
				get = 'GetPvpList',
			},
			pvpSettings = {
				order = 57,
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

	if self.db.char.options.welcomeEnable == nil then
		self.db.char.options.welcomeEnable = true
	end
	
	if self.db.char.options.chatParty == nil then
		self.db.char.options.chatParty = "SOLO"
	end

	for p in pairs(CHATPARTIES) do
		if self.db.char.options[p] == nil then
			self.db.char.options[p] = {}
			if p == "SOLO" then
				self.db.char.options[p].chatYell = false
				self.db.char.options[p].chatSay = false
				self.db.char.options[p].chatSystem = true
			end
			if p == "PARTY" then
				self.db.char.options[p].chatParty = true
				self.db.char.options[p].chatYell = false
				self.db.char.options[p].chatSay = false
				self.db.char.options[p].chatSystem = false
			end
			if p == "RAID" then
				self.db.char.options[p].chatRaid = true
				self.db.char.options[p].chatParty = false
				self.db.char.options[p].chatYell = false
				self.db.char.options[p].chatSay = false
				self.db.char.options[p].chatSystem = false
			end

		end
	end
	
	if self.db.char.options.auraAllEnable == nil then
		self.db.char.options.auraAllEnable = true
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
					self.db.char.options[v].announceEnd = false
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
	
	-- Conversion from older versions.
	if self.db.char.options.resistsAllEnable ~= nil then
		self.db.char.options.spellAllEnable = self.db.char.options.resistsAllEnable
		self.db.char.options.resistsAllEnable = nil
	end
	
	if self.db.char.options.spellAllEnable == nil then
		self.db.char.options.spellAllEnable = true
	end

	if self.db.char.options.successfulInterrupts == nil then
		self.db.char.options.successfulInterrupts = true
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
	
	if self.db.char.options.pvpAllEnable == nil then
		self.db.char.options.pvpAllEnable = true
	end

	if self.db.char.options.pvpFriendly == nil then
		self.db.char.options.pvpFriendly = "SELF"
	end

	if self.db.char.options.pvpEnemy == nil then
		self.db.char.options.pvpEnemy = "TARGET"
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
	
	if self.db.char.options.auras == nil then
		self.db.char.options.auras = 1
	end
	
	if self.db.char.options.spells == nil then
		self.db.char.options.spells = 1
	end

	if self.db.char.options.pvp == nil then
		self.db.char.options.pvp = GetSpellInfo(self.pvpSpellIDs[1])
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
