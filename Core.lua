--------------------
-- Initialization --
--------------------

SAC = LibStub("AceAddon-3.0"):NewAddon("SAC", "AceConsole-3.0", "AceEvent-3.0")

SAC.playerName = UnitName("player")
SAC.playerGUID = UnitGUID("player")
SAC.playerClass = select(2, UnitClass("Player"))

SAC.playerAuraList = Auras[SAC.playerClass]
SAC.namedAuraList = {}
SAC.playerResistList = Resists[SAC.playerClass]
SAC.namedResistList = {}

function SAC:OnInitialize()

	-- Setup SavedVariables
	self.db = LibStub("AceDB-3.0"):New("SpellAnnouncerClassicDB")
	
	-- Gather spell names based on spellID. This is done because of different languages.
	self:PopulateSpellsLists()
		
	self:Print("Initialized")
	
end

function SAC:OnEnable()

	self:CreateOptions()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
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
						
			for k,v in pairs(self.namedAuraList) do
				if v == spellName then
					if self.db.char.options[spellName].announceStart then
						self:Print("Aura applied:", spellName, destName)
					end
				end
			end
			
		end
		
		if subevent == "SPELL_AURA_REMOVED" then
				
			for _,v in pairs(self.namedAuraList) do
				if v == spellName then
					if self.db.char.options[spellName].announceEnd then
						self:Print("Aura ended:", spellName, destName)
					end
				end
			end
			
		end
		
	end

	if self.db.char.options.resistsAllEnable then
		if subevent == "SPELL_MISSED" then
			
			for _,v in pairs(self.namedResistList) do
				if v == spellName then
					if self.db.char.options[spellName].resistAnnounceEnabled then
						self:Print(string.format("%s: %s Failed %s - Target: %s!", arg15, sourceName, spellName, destName))
					end
				end
			end
		
		end
	end
end

---------------
-- Functions --
---------------

function SAC:PopulateSpellsLists()
	if self.playerAuraList ~= nil then
		for k,v in ipairs(self.playerAuraList) do
			local spellname = GetSpellInfo(v)
			table.insert(self.namedAuraList, spellname)
		end
	end
	
	if self.playerResistList ~= nil then
		for k,v in ipairs(self.playerResistList) do
			local spellname = GetSpellInfo(v)
			table.insert(self.namedResistList, spellname)
		end
	end
end