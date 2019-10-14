--------------------
-- Initialization --
--------------------

local SAC = LibStub("AceAddon-3.0"):NewAddon("SAC", "AceConsole-3.0", "AceEvent-3.0")
local playerGUID = UnitGUID("player")

local appliedAuras = {}

function SAC:OnInitialize()

	-- Setup SavedVariables
	self.db = LibStub("AceDB-3.0"):New("SpellAnnouncerClassicDB")
	
	SAC:SetDefaultSavedVariables()
	SAC:Print(self.db.char.test)
	
	SAC:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
	SAC:Print("Initialized")
	
end

------------
-- Events --
------------

function SAC:COMBAT_LOG_EVENT_UNFILTERED(eventName)
	
	-- Assign all the data from current event
	local timestamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, 
	destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool, arg15, arg16, 
	arg17, arg18, arg19, arg20, arg21, arg22, arg23, arg24  = CombatLogGetCurrentEventInfo()
	
	-- Only report your own combatlog.
	if sourceGUID ~= playerGUID then
		return
	end
	
	if subevent == "SPELL_AURA_APPLIED" then
		
	end
	
	SAC:Print(timestamp, eventName, subevent, sourceName)
	
end

---------------
-- Functions --
---------------
function SAC:OnEnable()
end

function SAC:OnDisable()
end

function SAC:SetDefaultSavedVariables()

	if self.db.char.test == nil then
		SAC:Print("Defaultvalue set")
		self.db.char.test = "This is a test"
	end
	
end