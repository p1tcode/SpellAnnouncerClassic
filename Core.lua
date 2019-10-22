--------------------
-- Initialization --
--------------------

SAC = LibStub("AceAddon-3.0"):NewAddon("SAC", "AceConsole-3.0", "AceEvent-3.0")

local playerName = UnitName("player")
local playerGUID = UnitGUID("player")
local playerClass = select(2, UnitClass("Player"))

local playerAuraList = Auras[playerClass]
local namedAuraList = {}
local playerTauntsList = Taunts[playerClass]
local tauntsList = {}

function SAC:OnInitialize()

	-- Setup SavedVariables
	self.db = LibStub("AceDB-3.0"):New("SpellAnnouncerClassicDB")
	LibStub("AceConfig-3.0"):RegisterOptionsTable("SAC_Options", SAC.Options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SAC_Options", "SpellAnnouncer Classic")
	
	-- Gather spell names based on spellID. This is done because of different languages.
	SAC:PopulateSpellsLists()
	SAC:SetDefaultSavedVariables()
	
	
	SAC:Print("Initialized")
	
end

function SAC:OnEnable()

	SAC:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
end

function SAC:OnDisable()

	SAC:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
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
	if sourceGUID ~= playerGUID then
		return
	end
	
	if subevent == "SPELL_AURA_APPLIED" then
			
		for k,v in pairs(namedAuraList) do
			if v == spellName then
				SAC:Print("Aura applied:", spellName, destName)
			end
		end
		
	end
	
	if subevent == "SPELL_AURA_REMOVED" then
			
		for _,v in pairs(namedAuraList) do
			if v == spellName then
				SAC:Print("Aura ended:", spellName, destName)
			end
		end
		
	end
	
	if subevent == "SPELL_MISSED" then
		
		for _,v in pairs(tauntsList) do
			if v == spellName then
				SAC:Print(string.format("%s: %s Failed %s - Target: %s!", arg15, sourceName, spellName, destName))
			end
		end
	
	end
	
end

---------------
-- Functions --
---------------


function SAC:SetDefaultSavedVariables()

	if self.db.char.test == nil then
		self.db.char.test = "This is a test"
	end
	
end

function SAC:PopulateSpellsLists()
	if not playerAuraList == nil then
		for k,v in ipairs(playerAuraList) do
			local spellname = GetSpellInfo(v)
			table.insert(namedAuraList, spellname)
		end
	end
	
	if not playerTauntsList == nil then
		for k,v in ipairs(playerTauntsList) do
			local spellname = GetSpellInfo(v)
			table.insert(tauntsList, spellname)
		end
	end
end

function SAC:IsAuraApplied(auraName)
	found = false
	for _,v in pairs(appliedAuras) do
		if auraName == v then
			found = true
		end
	end
	
	return found
end