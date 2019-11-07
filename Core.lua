--------------------
-- Initialization --
--------------------

SAC = LibStub("AceAddon-3.0"):NewAddon("|cff336699SpellAnnouncer |cffFBB709Classic", "AceConsole-3.0", "AceEvent-3.0")

SAC.playerName = UnitName("player")
SAC.playerGUID = UnitGUID("player")
SAC.playerClass = select(2, UnitClass("Player"))

SAC.classAuraIDs = Auras[SAC.playerClass]
SAC.aurasList = {}
SAC.classSpellIDs = Spells[SAC.playerClass]
SAC.spellsList = {}

function SAC:OnInitialize()

	-- Setup SavedVariables
	self.db = LibStub("AceDB-3.0"):New("SpellAnnouncerClassicDB")
	
	-- Gather spell names based on spellID. This is done because of different languages.
	self:PopulateSpellsLists()
	
end

function SAC:OnEnable()

	self:CreateOptions()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
	local name = GetAddOnMetadata("SpellAnnouncerClassic", "Title")
	local version = GetAddOnMetadata("SpellAnnouncerClassic", "Version")
	C_Timer.After(3, 
	function() 
		self:Print("Version", version, "Created By: Pit @ Firemaw-EU")
		self:Print("Use /sac or /spellannouncer to access options and please report any bugs or feedback at https://www.curseforge.com/wow/addons/spellannouncer-classic")
	end)
	
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
	
	-- Only report your own combatlog.
	if sourceGUID ~= self.playerGUID then
		return
	end
		
	-- Only show auras if enabled in options (Enable Auras)
	if self.db.char.options.auraAllEnable then
		
		if subevent == "SPELL_AURA_APPLIED" then
						
			for k,v in pairs(self.aurasList) do
				if v == spellName then
					-- Check if specific Aura should be announced from options when applied.
					if self.db.char.options[spellName].announceStart then
						--self:Print("Aura applied:", spellName, destName)
						if destName == sourceName then
							self:AnnounceSpell(string.format("%s used -%s-", sourceName, spellName))
						else
							self:AnnounceSpell(string.format("%s used -%s- --> %s", sourceName, spellName, destName))
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
						--self:Print("Aura ended:", spellName, destName)
						if destName == sourceName then
							self:AnnounceSpell(string.format("%s -%s- faded!", sourceName, spellName))
						else
							self:AnnounceSpell(string.format("%s -%s- faded --> %s!", sourceName, spellName, destName))
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
						
						
						SAC:Print(destFlags)
						
						--self:Print(string.format("%s: %s Failed %s - Target: %s!", arg15, sourceName, spellName, destName))
						if destName == sourceName then
							self:AnnounceSpell(string.format("%s used -%s-", sourceName, spellName))
						else
							self:AnnounceSpell(string.format("%s used -%s- --> %s", sourceName, spellName, destName))
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
							--self:Print(string.format("%s: %s Failed %s - Target: %s!", arg15, sourceName, spellName, destName))
							self:AnnounceSpell(string.format("%s: %s failed -%s- --> %s!", arg15, sourceName, spellName, destName))
						end
					end
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
					SAC:Print(msg)
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
					SAC:Print(msg)
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
					SAC:Print(msg)
				end
			end
		end
	end
end

function SAC:PopulateSpellsLists()
	if self.classAuraIDs ~= nil then
		for k,v in ipairs(self.classAuraIDs) do
			local spellname = GetSpellInfo(v)
			
			table.insert(self.aurasList, spellname)
		end
	end
	
	if self.classSpellIDs ~= nil then
		for k,v in ipairs(self.classSpellIDs) do
			local spellname = GetSpellInfo(v)
			table.insert(self.spellsList, spellname)
		end
	end
end
