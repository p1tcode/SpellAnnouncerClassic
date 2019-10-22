SAC.Options = {
	name = "SpellAnnouncer Classic",
	handler = SAC,
	type = 'group',
	args = {
		msg = {
			type = 'input',
			name = 'Message',
			desc = 'Dette er en melding for min addon',
			set = 'SetFunction',
			get = 'GetFunction',
		},
	},
}

function SAC:SetFunction(info, val)
	self.message = val
	SAC:Print(self.message)
end

function SAC:GetFunction(info)
	return self.message
end