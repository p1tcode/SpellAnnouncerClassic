--------------------
-- Initialization --
--------------------

SAC = LibStub("AceAddon-3.0"):NewAddon("SAC", "AceConsole-3.0", "AceEvent-3.0")

SAC.playerName = UnitName("player")
SAC.playerGUID = UnitGUID("player")
SAC.playerClass = select(2, UnitClass("Player"))

SAC.playerAuraList = Auras[SAC.playerClass]
SAC.namedAuraList = {}
SAC.playerRessistList = Ressists[SAC.playerClass]
SAC.namedRessistList = {}

function SAC:OnInitialize()

	-- Setup SavedVariables
	self.db = LibStub("AceDB-3.0"):New("SpellAnnouncerClassicDB")
	
	
	
	-- Gather spell names based on spellID. This is done because of different languages.
	self:PopulateSpellsLists()
	self:InitializeSavedVariables()
		
	self:Print("Initialized")
	
end

function SAC:OnEnable()

	LibStub("AceConfig-3.0"):RegisterOptionsTable("SAC_Options", SAC.Options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SAC_Options", SAC.Options.name)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("SAC_Options_Auras", SAC.Options_Auras)
	self.optionsAurasFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SAC_Options_Auras", SAC.Options_Auras.name, SAC.Options.name)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("SAC_Options_Ressists", SAC.Options_Ressists)
	self.optionsRessistsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SAC_Options_Ressists", SAC.Options_Ressists.name, SAC.Options.name)

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
	
	if subevent == "SPELL_AURA_APPLIED" then
			
		for k,v in pairs(self.namedAuraList) do
			if v == spellName then
				self:Print("Aura applied:", spellName, destName)
			end
		end
		
	end
	
	if subevent == "SPELL_AURA_REMOVED" then
			
		for _,v in pairs(self.namedAuraList) do
			if v == spellName then
				self:Print("Aura ended:", spellName, destName)
			end
		end
		
	end
	
	if subevent == "SPELL_MISSED" then
		
		for _,v in pairs(self.namedRessistList) do
			if v == spellName then
				self:Print(string.format("%s: %s Failed %s - Target: %s!", arg15, sourceName, spellName, destName))
			end
		end
	
	end
	
end

---------------
-- Functions --
---------------


function SAC:InitializeSavedVariables()
	
	if self.db.char.options == nil then
		self.db.char.options = {}
		for k,v in pairs(self.namedAuraList) do
			table.insert(self.db.char.options, v)
			self.db.char.options[v] = {}
		end
	end
	
end

function SAC:PopulateSpellsLists()
	if self.playerAuraList ~= nil then
		for k,v in ipairs(self.playerAuraList) do
			local spellname = GetSpellInfo(v)
			table.insert(self.namedAuraList, spellname)
		end
	end
	
	if self.playerRessistList ~= nil then
		for k,v in ipairs(self.playerRessistList) do
			local spellname = GetSpellInfo(v)
			table.insert(self.namedRessistList, spellname)
		end
	end
end