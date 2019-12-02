--------------------
-- Initialization --
--------------------

SAC = LibStub("AceAddon-3.0"):NewAddon("|cff336699SpellAnnouncer |cffFBB709Classic", "AceConsole-3.0", "AceEvent-3.0")

SAC.addonName = GetAddOnMetadata("SpellAnnouncerClassic", "Title")
SAC.addonVersion = GetAddOnMetadata("SpellAnnouncerClassic", "Version")

SAC.playerName = UnitName("player")
SAC.playerGUID = UnitGUID("player")
SAC.playerClass = select(2, UnitClass("Player"))

SAC.classAuraIDs = Auras[SAC.playerClass]
SAC.aurasList = {}
SAC.classSpellIDs = Spells[SAC.playerClass]
SAC.spellsList = {}
SAC.pvpSpellIDs = EnemySpells
SAC.pvpSpellNames = {}
SAC.pvpItemIDs = EnemyItems
SAC.pvpItemNames = {}
SAC.pvpAllList = {}

function SAC:OnInitialize()

	-- Setup SavedVariables
	self.db = LibStub("AceDB-3.0"):New("SpellAnnouncerClassicDB")
		
	-- Gather spell names based on spellID. This is done because of different languages.
	self:PopulateSpellsLists()
	
end

function SAC:OnEnable()

	self:CreateOptions()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
	if self.db.char.options.welcomeEnable then
		C_Timer.After(3, 
		function() 
			self:Print("Version", self.addonVersion, "Created By: Pit @ Firemaw-EU")
			self:Print("Use /sac or /spellannouncer to access options and please report any bugs or feedback at https://www.curseforge.com/wow/addons/spellannouncer-classic")
		end)
	end

	for k,v in pairs(self.pvpAllList) do
		print(k,v)
	end

end

function SAC:OnDisable()

	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
end

------------
-- Events --
------------

function SAC:COMBAT_LOG_EVENT_UNFILTERED(eventName)
		
	-- Assign all the data from current event
	local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, 
	destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, 
	arg15, arg16, arg17, arg18, arg19, arg20, arg21, arg22, arg23, arg24  = CombatLogGetCurrentEventInfo()
	
	--SAC:Print(eventName, subevent, spellName, spellId, sourceName, " - ", arg16, arg15, destName)
	--SAC:Print(subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, 
	--destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, 
	--arg15, arg16, arg17, arg18, arg19, arg20, arg21, arg22, arg23, arg24)
	
	-- Only report your own combatlog.
	if CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MINE) then
		
		-- Only show auras if enabled in options (Enable Auras)
		if self.db.char.options.auraAllEnable then
			
			if subevent == "SPELL_AURA_APPLIED" then
							
				for k,v in pairs(self.aurasList) do
					if v == spellName then
						-- Check if specific Aura should be announced from options when applied.
						if self.db.char.options[spellName].announceStart then
							
							local icon = raidIcons[bit.band(destRaidFlags, COMBATLOG_OBJECT_RAIDTARGET_MASK)] or ""
							
							if destName == sourceName then
								self:AnnounceSpell(string.format("%s used -%s-", sourceName, spellName))
							else
								self:AnnounceSpell(string.format("%s used -%s- --> %s%s", sourceName, spellName, icon, destName))
							end
						end
						if self.db.char.options[spellName].whisperTarget then
							if destName ~= sourceName then
								if UnitIsPlayer(destName) then
									self:AnnounceSpell(string.format("%s used -%s-on you!", sourceName, spellName), "WHISPER", destName)
								end
							end
						end
					end
				end
				
			end
			
			if subevent == "SPELL_AURA_REMOVED" then
					
				for _,v in pairs(self.aurasList) do
					if v == spellName then
						-- Check if specific Aura should be announced from options when removed.
						if self.db.char.options[spellName].announceEnd then
						
							local icon = raidIcons[bit.band(destRaidFlags, COMBATLOG_OBJECT_RAIDTARGET_MASK)] or ""
							
							--self:Print("Aura ended:", spellName, destName)
							if destName == sourceName then
								self:AnnounceSpell(string.format("%s -%s- faded!", sourceName, spellName))
							else
								self:AnnounceSpell(string.format("%s -%s- faded --> %s%s!", sourceName, spellName, icon, destName))
							end
						end
					end
				end
				
			end
			
		end

		
		if self.db.char.options.spellAllEnable then
			if subevent == "SPELL_CAST_SUCCESS" then
				--self:Print(spellName)
				for _,v in pairs(self.spellsList) do
					if v == spellName then
						-- Check if resist should be announced for specific spell.
						if self.db.char.options[spellName].spellAnnounceEnabled then
							
							local icon = raidIcons[bit.band(destRaidFlags, COMBATLOG_OBJECT_RAIDTARGET_MASK)] or ""
							
							if destName == sourceName or destName == nil then
								self:AnnounceSpell(string.format("%s used -%s-", sourceName, spellName))
							else
								self:AnnounceSpell(string.format("%s used -%s- --> %s%s", sourceName, spellName, icon, destName))
							end
						end					
					end
				end
			end
		end

		if self.db.char.options.spellAllEnable then
			if subevent == "SPELL_MISSED" then
				if arg15 ~= "ABSORB" then
					
					for _,v in pairs(self.spellsList) do
						if v == spellName then
							-- Check if resist should be announced for specific spell.
							if self.db.char.options[spellName].resistAnnounceEnabled then
							
								local icon = raidIcons[bit.band(destRaidFlags, COMBATLOG_OBJECT_RAIDTARGET_MASK)] or ""
								
								self:AnnounceSpell(string.format("%s: %s failed -%s- --> %s%s!", arg15, sourceName, spellName, icon, destName))
							end
						end
					end
					
				end
			end
		end
		
		if self.db.char.options.successfulInterrupts then
			if subevent == "SPELL_INTERRUPT" then
				local icon = raidIcons[bit.band(destRaidFlags, COMBATLOG_OBJECT_RAIDTARGET_MASK)] or ""
				
				self:AnnounceSpell(string.format("INTERRUPT: %s -%s- %s%s --> %s!", sourceName, spellName, icon, destName, arg16))
			end
		end
	end
	
	if destName == SAC.playerName then
	
		if subevent == "SPELL_CAST_SUCCESS" then
			
			--self:Print(spellName)
			for k,v in pairs(self.pvpSpellNames) do

				if v == spellName then
					-- Check if PVP spell should be announced.
					if self.db.char.options[spellName].Enable then

						local icon = raidIcons[bit.band(sourceRaidFlags, COMBATLOG_OBJECT_RAIDTARGET_MASK)] or ""
							
						self:AnnounceSpell(string.format("PVP!: %s%s -%s- --> %s", icon, sourceName, spellName, destName))

					end
				end
			end
		end
	end

	if UnitName("target") == sourceName then

		if subevent == "SPELL_CAST_SUCCESS" then
					
			--self:Print(spellName)
			for k,v in pairs(self.pvpItemNames) do

				if k == spellName then
					-- Check if resist should be announced for specific spell.
					local icon = raidIcons[bit.band(sourceRaidFlags, COMBATLOG_OBJECT_RAIDTARGET_MASK)] or ""
						
					self:AnnounceSpell(string.format("PVP!: %s%s -%s-", icon, sourceName, v))

				end
			end
		end
	end
end

---------------
-- Functions --
---------------

function SAC:AnnounceSpell(msg, channelType, channelName)

	-- Whispers
	if channelType == "WHISPER" then
		SendChatMessage(msg, channelType, _, channelName)
		return
	end
	-- Channel
	if channelType == "CHANNEL" then
		SendChatMessage(msg, channelType, _, channelName)
		return
	end
	
	-- Solo
	if (not IsInGroup()) and (not IsInRaid()) then
		for k,v in pairs(self.db.char.options.SOLO) do
			if v then
				-- Change the k string to something SendChatMessage understands (removes "chat" and makes rest upper case).
				local chatType = string.upper(string.gsub(k, "chat", ""))
				if chatType ~= "SYSTEM" then
					SendChatMessage(msg, chatType)
				else
					local sysMsg = string.gsub(msg, "{RT%w}", "")
					SAC:Print(sysMsg)
				end
			end
		end
	end
	-- Party
	if (IsInGroup()) and (not IsInRaid()) then
		for k,v in pairs(self.db.char.options.PARTY) do
			if v then
				-- Change the k string to something SendChatMessage understands (removes "chat" and makes rest upper case).
				local chatType = string.upper(string.gsub(k, "chat", ""))
				if chatType ~= "SYSTEM" then
					SendChatMessage(msg, chatType)
				else
					local sysMsg = string.gsub(msg, "{RT%w}", "")
					SAC:Print(sysMsg)
				end
			end
		end
	end
	-- Raid
	if (IsInGroup()) and (IsInRaid()) then
		for k,v in pairs(self.db.char.options.RAID) do
			if v then
				-- Change the k string to something SendChatMessage understands (removes "chat" and makes rest upper case).
				local chatType = string.upper(string.gsub(k, "chat", ""))
				if chatType ~= "SYSTEM" then
					SendChatMessage(msg, chatType)
				else
					local sysMsg = string.gsub(msg, "{RT%w}", "")
					SAC:Print(sysMsg)
				end
			end
		end
	end
end

function SAC:PopulateSpellsLists()
	if self.classAuraIDs ~= nil then
		for k,v in ipairs(self.classAuraIDs) do
			local spell = GetSpellInfo(v)
			
			table.insert(self.aurasList, spell)
		end
	end
	
	if self.classSpellIDs ~= nil then
		for k,v in ipairs(self.classSpellIDs) do
			local spell = GetSpellInfo(v)
			table.insert(self.spellsList, spell)
		end
	end
	
	if self.pvpSpellIDs ~= nil then
		for k,v in ipairs(self.pvpSpellIDs) do
			local spell = GetSpellInfo(v)
			table.insert(self.pvpSpellNames, spell)
			self.pvpAllList[spell] = spell
		end
	end
	
	if self.pvpItemIDs ~= nil then
		for k, v in pairs(self.pvpItemIDs) do
			local itemName = GetItemInfo(k)
			local spellName = GetSpellInfo(v)
			self.pvpItemNames[spellName] = itemName
			self.pvpAllList[spellName] = itemName
		end
	end
end


-----------
-- Enums --
-----------
raidIcons = {
	[COMBATLOG_OBJECT_RAIDTARGET1] = "{RT1}",
	[COMBATLOG_OBJECT_RAIDTARGET2] = "{RT2}",
	[COMBATLOG_OBJECT_RAIDTARGET3] = "{RT3}",
	[COMBATLOG_OBJECT_RAIDTARGET4] = "{RT4}",
	[COMBATLOG_OBJECT_RAIDTARGET5] = "{RT5}",
	[COMBATLOG_OBJECT_RAIDTARGET6] = "{RT6}",
	[COMBATLOG_OBJECT_RAIDTARGET7] = "{RT7}",
	[COMBATLOG_OBJECT_RAIDTARGET8] = "{RT8}",
}